import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_sos/constants/constants.dart' as constants;
import 'package:blood_sos/theme/theme.dart' as theme;

class RequestDetailScreenArgs {
  final String id;
  const RequestDetailScreenArgs({required this.id});
}

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RequestDetailScreenArgs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("İstek Detayı"),
      ),
      body: Padding(
        padding: EdgeInsets.all(constants.defaultPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("İstek ID: ${args.id}", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse("https://example.com/request/${args.id}"));
              },
              child: const Text("Detayları Aç"),
            )
          ],
        ),
      ),
    );
  }
}
