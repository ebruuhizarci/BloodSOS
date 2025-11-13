import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_sos/models/user.dart';
import 'package:blood_sos/services/user.dart';
import 'package:blood_sos/theme/theme.dart' as theme;
import 'package:blood_sos/constants/constants.dart' as constants;

class PublicProfileScreenArgs {
  final String id;
  PublicProfileScreenArgs({required this.id});
}

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  GetProfileResponseData? data;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  Future<void> fetchData() async {
    final args = ModalRoute.of(context)!.settings.arguments as PublicProfileScreenArgs;

    try {
      setState(() {
        loading = true;
        error = false;
      });

      final res = await UserService.getProfile(id: args.id);
      setState(() => data = res.data);
    } catch (_) {
      setState(() => error = true);
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildReviewItem(ProfileReviewData? reviewData) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text('${reviewData?.createdBy.name ?? 'Anonim'} Says'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reviewData?.review ?? ''),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${reviewData?.rating ?? 0}', style: textTheme.bodyLarge),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadingWidget() => const Center(child: CircularProgressIndicator());

  Widget buildErrorWidget() {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 64),
          const SizedBox(height: 8),
          Text('Bir hata oluştu.', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: fetchData,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget buildDetailWidget() {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('${constants.apiUrl}/avatar/${data?.avatar}'),
              onBackgroundImageError: (_, __) {},
            ),
            Flexible(
              child: Text(
                data?.name ?? '',
                style: textTheme.displaySmall,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        if (data?.phone != null)
          Card(
            margin: const EdgeInsets.all(4),
            child: ListTile(
              leading: const Icon(Icons.phone, color: theme.primaryColor),
              title: Text(data!.phone),
              onTap: () async {
                await launchUrl(Uri.parse('tel:${data!.phone}'));
              },
            ),
          ),
        if (data?.email != null)
          Card(
            margin: const EdgeInsets.all(4),
            child: ListTile(
              leading: const Icon(Icons.email, color: theme.primaryColor),
              title: Text(data!.email),
            ),
          ),
        if (data?.address != null)
          Card(
            margin: const EdgeInsets.all(4),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: theme.primaryColor),
              title: Text(data!.address),
            ),
          ),
        Card(
          margin: const EdgeInsets.all(4),
          child: ListTile(
            leading: const Icon(Icons.bloodtype, color: theme.primaryColor),
            title: Text(data?.bloodType ?? 'Belirtilmemiş'),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(4),
          child: ListTile(
            leading: const Icon(Icons.healing, color: theme.primaryColor),
            title: Text('Toplam Bağış: ${data?.totalDonated ?? 0}'),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(4),
          child: ListTile(
            leading: const Icon(Icons.star, color: theme.primaryColor),
            title: Text('Ortalama Puan: ${data?.averageRating ?? '0.0'}'),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text('Kullanıcı Yorumları', style: textTheme.titleLarge),
            const SizedBox(width: 8),
            const Icon(Icons.reviews),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                title: Text('Kullanıcı Profili'),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: constants.defaultPagePadding),
                      child: Column(
                        children: [
                          if (loading) buildLoadingWidget(),
                          if (error && !loading) buildErrorWidget(),
                          if (data != null && !loading) buildDetailWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (data?.reviews.isNotEmpty ?? false)
                SliverList.separated(
                  itemCount: data!.reviews.length,
                  itemBuilder: (_, i) => buildReviewItem(data!.reviews[i]),
                  separatorBuilder: (_, __) => const Divider(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
