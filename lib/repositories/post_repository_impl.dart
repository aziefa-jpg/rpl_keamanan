import '../models/post.dart';
import '../services/api_service.dart';
import 'post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final ApiService apiService;

  PostRepositoryImpl({required this.apiService});

  @override
  Future<List<Post>> getPosts() async {
    final responseData = await apiService.get('/posts');

    if (responseData is List) {
      return responseData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException('Format data postingan tidak valid.');
    }
  }
}