import 'package:flutter/material.dart';

class AlertInfo extends StatelessWidget {
  final String message;

  const AlertInfo({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: Colors.blue[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 6.0),
                Text(
                  'Bilgilendirme',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
