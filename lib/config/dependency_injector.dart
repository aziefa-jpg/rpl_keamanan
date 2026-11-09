import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';
import '../services/auth_storage_service.dart';

/// Container sederhana untuk Dependency Injection (DI).
class DependencyInjector {
  static final DependencyInjector _instance = DependencyInjector._internal();
  factory DependencyInjector() => _instance;
  DependencyInjector._internal();

  late final ApiService apiService;
  late final UserRepository userRepository;
  late final PostRepository postRepository;
  late final AuthStorageService authStorageService;

  /// Inisialisasi semua service dan repository.
  void setup() {
    apiService = ApiService();
    userRepository = UserRepositoryImpl(apiService: apiService);
    postRepository = PostRepositoryImpl(apiService: apiService);
    authStorageService = AuthStorageService();
  }
}

/// Helper global untuk mengakses instance dependency.
final locator = DependencyInjector();