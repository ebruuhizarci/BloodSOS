import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/services/blood_request.dart';
import 'package:blood_sos/utils/functions.dart';
import 'request_detail_screen.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  bool loading = true;
  bool error = false;
  List requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() {
      loading = true;
      error = false;
    });
    try {
      var res = await BloodRequestService.getBloodRequests(page: 1, limit: 15);
      setState(() => requests = res.data);
    } catch (e) {
      setState(() => error = true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Kan İstekleri")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPagePadding),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : error
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 12),
                          const Text("Bir hata oluştu"),
                          ElevatedButton(
                            onPressed: fetchRequests,
                            child: const Text("Tekrar Dene"),
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: requests.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        var request = requests[index];
                        return ListTile(
                          title: Text(
                            request.patientName,
                            style: textTheme.titleMedium,
                          ),
                          subtitle: Text(request.bloodType),
                          trailing: Text(
                            Moment(request.createdAt).fromNow(),
                            style: textTheme.bodySmall,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/request-detail',
                              arguments: RequestDetailScreenArgs(id: request.id),
                            );
                          },
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
