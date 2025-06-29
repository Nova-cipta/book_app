import 'package:book_app/core/data/datasource/local/database/database_client.dart';
import 'package:book_app/core/data/datasource/local/local_datasource.dart';
import 'package:book_app/core/data/datasource/remote/network/dio_client.dart';
import 'package:book_app/core/data/datasource/remote/remote_datasource.dart';
import 'package:book_app/core/data/repository/main_repository_impl.dart';
import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/domain/usecase/add_like.dart';
import 'package:book_app/core/domain/usecase/get_books.dart';
import 'package:book_app/core/domain/usecase/get_favorite_books.dart';
import 'package:book_app/core/domain/usecase/remove_like.dart';
import 'package:book_app/core/domain/usecase/save_book.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:book_app/feature/home/provider/home_provider.dart';
import 'package:book_app/feature/home/provider/liked_book_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

/// [GetIt] is used as service locator this project
final locator = GetIt.instance;

/// initiating all of the services used in this project
init() {
  locator.registerLazySingletonAsync<Database>(
    () async => await DatabaseClient().initDb()
  );

  locator.registerLazySingleton<Dio>(() => DioClient().dio);

  locator.registerLazySingleton<LocalDatasource>(
    () => LocalDatasourceImpl(database: locator<Database>())
  );

  locator.registerLazySingleton<RemoteDatasource>(
    () => RemoteDatasourceImpl(dio: locator<Dio>())
  );

  locator.registerLazySingleton<MainRepository>(
    () => MainRepositoryImpl(
      local: locator<LocalDatasource>(),
      remote: locator<RemoteDatasource>()
    )
  );

  locator.registerLazySingleton<GetBooks>(
    () => GetBooksImpl(repository: locator<MainRepository>())
  );

  locator.registerLazySingleton<GetSavedBooks>(
    () => GetSavedBooksImpl(repository: locator<MainRepository>())
  );

  locator.registerLazySingleton<SaveBook>(
    () => SaveBookImpl(repository: locator<MainRepository>())
  );

  locator.registerLazySingleton<AddLike>(
    () => AddLikeImpl(repository: locator<MainRepository>())
  );

  locator.registerLazySingleton<RemoveLike>(
    () => RemoveLikeImpl(repository: locator<MainRepository>())
  );

  locator.registerLazySingleton<HomeProvider>(
    () => HomeProvider(
      getBooks: locator<GetBooks>(),
      getSavedBooks: locator<GetSavedBooks>()
    )
  );

  locator.registerLazySingleton<LikedBookProvider>(
    () => LikedBookProvider(getSavedBooks: locator<GetSavedBooks>())
  );

  locator.registerFactory<BookDetailProvider>(
    () => BookDetailProvider(
      addLike: locator<AddLike>(),
      saveBook: locator<SaveBook>(),
      removeLike: locator<RemoveLike>()
    )
  );
}