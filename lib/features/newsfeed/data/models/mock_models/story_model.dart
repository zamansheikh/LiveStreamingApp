import 'package:dlstarlive/features/newsfeed/data/models/mock_models/user_model.dart';

class Story {
  final User user;
  final String imageUrl;
  final bool isViewed;

  const Story({
    required this.user,
    required this.imageUrl,
    this.isViewed = false,
  });
}
