import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';
import 'package:blood_sos/models/auth.dart';
import 'package:blood_sos/models/blood_request.dart';
import 'package:blood_sos/provider/global_state.dart';
import 'package:blood_sos/screens/home/request_detail_screen.dart';
import 'package:blood_sos/services/blood_request.dart';
import 'package:blood_sos/widgets/info_card.dart';
import 'package:blood_sos/constants/constants.dart' as constants;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String averageRating = '...';
  String totalDonated = '...';
  String totalRequested = '...';
  int requestRadius = 200;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    var res = await BloodRequestService.getBloodRequestStats();

    setState(() {
      totalDonated = res.data.totalDonated;
      totalRequested = res.data.totalRequests;
      averageRating = res.data.averageRating;
    });
  }

  void showFilterModal() {
    TextTheme textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: constants.defaultPagePadding,
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter', style: textTheme.headlineMedium),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Request Geo Radius', style: textTheme.labelLarge),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            min: 50,
                            max: 500,
                            label: '$requestRadius km',
                            value: requestRadius.toDouble(),
                            onChanged: (value) {
                              setState(() => requestRadius = value.toInt());
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$requestRadius km'),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await fetchData();
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.done),
                      label: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildHomeStats(String? bloodType) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InfoCard(
            icon: Icons.bloodtype,
            title: 'Blood Type',
            description: bloodType ?? '',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          InfoCard(
            icon: Icons.star,
            title: 'Average Rating',
            description: averageRating,
            onTap: () => Navigator.pushNamed(context, '/reviews'),
          ),
          InfoCard(
            icon: Icons.medical_services_sharp,
            title: 'Times Donated',
            description: totalDonated,
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          InfoCard(
            icon: Icons.local_hospital,
            title: 'Times Requested',
            description: totalRequested,
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
        ],
      ),
    );
  }

  Widget bloodRequestsList(List<GetNearbyBloodRequestResponseData>? data) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: (data?.length ?? 0) + 1,
      itemBuilder: (context, index) {
        if (index == 0 || data == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Blood Requests Nearby', style: textTheme.titleLarge),
                    const SizedBox(width: 8.0),
                    const Icon(Icons.location_on_outlined),
                  ],
                ),
                IconButton(
                  onPressed: showFilterModal,
                  icon: const Icon(Icons.filter_alt_sharp),
                )
              ],
            ),
          );
        }

        var item = data[index - 1];

        return ListTile(
          title: Text('${item.patientName} (Age: ${item.age})'),
          subtitle: Text(item.location),
          trailing: Column(
            children: [Text(item.timeUntil.toMoment().lll)],
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/request-detail',
              arguments: RequestDetailScreenArgs(id: item.id),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserResponseData? user = context.read<GlobalState>().user;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name}'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await fetchData(),
          child: ListView(
            children: [
              buildHomeStats(user?.bloodType),
              FutureBuilder(
                future: BloodRequestService.getNearbyBloodRequests(requestRadius: requestRadius),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error Loading Data'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data?.data;
                  if (data?.isEmpty == true) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 150),
                          Icon(Icons.info_outline, size: 64),
                          SizedBox(height: 8),
                          Text('No Nearby Blood Requests'),
                        ],
                      ),
                    );
                  }
                  return bloodRequestsList(data);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
