import '../models/post.dart';

/// Abstraksi repository untuk mengelola data Post.
abstract class PostRepository {
  /// Mengambil daftar semua post dari API.
  Future<List<Post>> getPosts();
}