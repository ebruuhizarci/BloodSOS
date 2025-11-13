class ProfileReviewData {
  final String review;
  final double rating;
  final _CreatedBy createdBy;

  ProfileReviewData({
    required this.review,
    required this.rating,
    required this.createdBy,
  });

  factory ProfileReviewData.fromJson(Map<String, dynamic> json) {
    return ProfileReviewData(
      review: json['review'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdBy: _CreatedBy.fromJson(json['createdBy']),
    );
  }
}

class _CreatedBy {
  final String id;
  final String name;

  _CreatedBy({
    required this.id,
    required this.name,
  });

  factory _CreatedBy.fromJson(Map<String, dynamic> json) {
    return _CreatedBy(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
