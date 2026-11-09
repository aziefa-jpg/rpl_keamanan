import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl({required this.apiService});

  @override
  Future<List<User>> getUsers() async {
    final responseData = await apiService.get('/users');

    if (responseData is List) {
      return responseData.map((json) => User.fromJson(json)).toList();
    } else {
      throw ApiException('Format data user tidak valid.');
    }
  }
}