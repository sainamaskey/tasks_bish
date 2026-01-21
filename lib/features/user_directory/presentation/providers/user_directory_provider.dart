import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class LocationPostCount {
  final GeoLocation location;
  final String cityName;
  final int postCount;
  final List<String> userNames;

  const LocationPostCount({
    required this.location,
    required this.cityName,
    required this.postCount,
    required this.userNames,
  });
}

class UserWithPostCount {
  final User user;
  final int postCount;

  const UserWithPostCount({required this.user, required this.postCount});
}

class UserDirectoryProvider extends ChangeNotifier {
  final UserRepository _repository;

  List<User> _users = [];
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  UserDirectoryProvider({UserRepository? repository})
    : _repository = repository ?? UserRepository();

  List<User> get users => _users;
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _users.isNotEmpty;

  List<UserWithPostCount> get usersWithPostCounts {
    return _users.map((user) {
      final postCount = _posts.where((post) => post.userId == user.id).length;
      return UserWithPostCount(user: user, postCount: postCount);
    }).toList();
  }

  List<LocationPostCount> get locationPostCounts {
    final Map<String, LocationPostCount> locationMap = {};

    for (final user in _users) {
      final cityKey =
          '${user.address.city}_${user.location.lat}_${user.location.lng}';
      final userPostCount = _posts
          .where((post) => post.userId == user.id)
          .length;

      if (locationMap.containsKey(cityKey)) {
        final existing = locationMap[cityKey]!;
        locationMap[cityKey] = LocationPostCount(
          location: existing.location,
          cityName: existing.cityName,
          postCount: existing.postCount + userPostCount,
          userNames: [...existing.userNames, user.name],
        );
      } else {
        locationMap[cityKey] = LocationPostCount(
          location: user.location,
          cityName: user.address.city,
          postCount: userPostCount,
          userNames: [user.name],
        );
      }
    }

    return locationMap.values.toList();
  }

  Future<void> fetchData() async {
    if (_isDisposed) return;

    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final data = await _repository.getUsersWithPosts();

      if (_isDisposed) return;

      _users = data.users;
      _posts = data.posts;
      _isLoading = false;
      _safeNotifyListeners();
    } on NetworkException catch (e) {
      _handleError(e.message);
    } on TimeoutException catch (e) {
      _handleError(e.message);
    } on ApiException catch (e) {
      _handleError(e.message);
    } on ParseException catch (e) {
      _handleError(e.message);
    } catch (e) {
      _handleError('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> retry() => fetchData();

  void _handleError(String message) {
    if (_isDisposed) return;

    _isLoading = false;
    _errorMessage = message;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _repository.dispose();
    super.dispose();
  }
}
