import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/api_service.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class UserDirectoryData {
  final List<User> users;
  final List<Post> posts;

  const UserDirectoryData({required this.users, required this.posts});
}

class UserRepository {
  final ApiService _apiService;

  UserRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<User>> getUsers() async {
    final response = await _apiService.get(ApiConstants.usersEndpoint);

    if (response is List) {
      return response
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<List<Post>> getPosts() async {
    final response = await _apiService.get(ApiConstants.postsEndpoint);

    if (response is List) {
      return response
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
  Future<UserDirectoryData> getUsersWithPosts() async {
    // Fetch users and posts concurrently for better performance
    final results = await Future.wait([getUsers(), getPosts()]);

    return UserDirectoryData(
      users: results[0] as List<User>,
      posts: results[1] as List<Post>,
    );
  }

  void dispose() {
    _apiService.dispose();
  }
}
