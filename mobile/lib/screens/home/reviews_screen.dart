import 'package:flutter/material.dart';
import 'package:blood_sos/models/review.dart' as review_model;
import 'package:blood_sos/services/user.dart';
import 'package:blood_sos/constants/constants.dart' as constants;

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<review_model.ProfileReviewData> reviews = [];
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      setState(() {
        loading = true;
        error = false;
      });

      final res = await UserService.getProfile(id: 'me');
      setState(() {
        reviews = res.data.reviews.cast<review_model.ProfileReviewData>();
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Yorumlar')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error
              ? const Center(child: Text("Bir hata oluştu."))
              : ListView.separated(
                  padding: EdgeInsets.all(constants.defaultPagePadding),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ListTile(
                      title: Text('${review.createdBy.name} yazdı:'),
                      subtitle: Text(review.review),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(review.rating.toString()),
                          const Icon(Icons.star, color: Colors.amber),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
