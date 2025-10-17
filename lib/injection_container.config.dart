// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/network/network_info.dart' as _i75;
import 'core/network/network_info_impl.dart' as _i973;
import 'database/database.dart' as _i565;
import 'features/auth/data/datasources/auth_local_datasource.dart' as _i1043;
import 'features/auth/data/datasources/auth_remote_datasource.dart' as _i588;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/domain/usecases/check_auth_status.dart' as _i818;
import 'features/auth/domain/usecases/get_current_user.dart' as _i191;
import 'features/auth/domain/usecases/sign_in_with_email.dart' as _i509;
import 'features/auth/domain/usecases/sign_in_with_google.dart' as _i648;
import 'features/auth/domain/usecases/sign_out.dart' as _i872;
import 'features/auth/presentation/bloc/auth_bloc.dart' as _i363;
import 'features/tasks/data/datasources/task_local_datasource.dart' as _i361;
import 'features/tasks/data/datasources/task_remote_datasource.dart' as _i403;
import 'features/tasks/data/repositories/task_repository_impl.dart' as _i969;
import 'features/tasks/domain/repositories/task_repository.dart' as _i356;
import 'features/tasks/domain/usecases/check_in_task.dart' as _i754;
import 'features/tasks/domain/usecases/complete_task.dart' as _i202;
import 'features/tasks/domain/usecases/create_task.dart' as _i483;
import 'features/tasks/domain/usecases/delete_task.dart' as _i335;
import 'features/tasks/domain/usecases/get_task_by_id.dart' as _i869;
import 'features/tasks/domain/usecases/get_tasks.dart' as _i441;
import 'features/tasks/domain/usecases/update_task.dart' as _i184;
import 'features/tasks/presentation/bloc/task_bloc.dart' as _i1006;
import 'injection_container.dart' as _i809;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => registerModule.firebaseFirestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i565.AppDatabase>(() => registerModule.database);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i403.TaskRemoteDataSource>(
        () => _i403.TaskRemoteDataSourceImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.lazySingleton<_i75.NetworkInfo>(
        () => _i973.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i1043.AuthLocalDataSource>(
        () => _i1043.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i588.AuthRemoteDataSource>(
        () => _i588.AuthRemoteDataSourceImpl(
              firebaseAuth: gh<_i59.FirebaseAuth>(),
              firestore: gh<_i974.FirebaseFirestore>(),
              googleSignIn: gh<_i116.GoogleSignIn>(),
            ));
    gh.lazySingleton<_i361.TaskLocalDataSource>(
        () => _i361.TaskLocalDataSourceImpl(gh<_i565.AppDatabase>()));
    gh.lazySingleton<_i1015.AuthRepository>(() => _i111.AuthRepositoryImpl(
          remoteDataSource: gh<_i588.AuthRemoteDataSource>(),
          localDataSource: gh<_i1043.AuthLocalDataSource>(),
          networkInfo: gh<_i75.NetworkInfo>(),
        ));
    gh.lazySingleton<_i356.TaskRepository>(() => _i969.TaskRepositoryImpl(
          remoteDataSource: gh<_i403.TaskRemoteDataSource>(),
          localDataSource: gh<_i361.TaskLocalDataSource>(),
        ));
    gh.lazySingleton<_i818.CheckAuthStatus>(
        () => _i818.CheckAuthStatus(gh<_i1015.AuthRepository>()));
    gh.lazySingleton<_i191.GetCurrentUser>(
        () => _i191.GetCurrentUser(gh<_i1015.AuthRepository>()));
    gh.lazySingleton<_i509.SignInWithEmail>(
        () => _i509.SignInWithEmail(gh<_i1015.AuthRepository>()));
    gh.lazySingleton<_i648.SignInWithGoogle>(
        () => _i648.SignInWithGoogle(gh<_i1015.AuthRepository>()));
    gh.lazySingleton<_i872.SignOut>(
        () => _i872.SignOut(gh<_i1015.AuthRepository>()));
    gh.factory<_i754.CheckInTask>(
        () => _i754.CheckInTask(gh<_i356.TaskRepository>()));
    gh.factory<_i202.CompleteTask>(
        () => _i202.CompleteTask(gh<_i356.TaskRepository>()));
    gh.factory<_i483.CreateTask>(
        () => _i483.CreateTask(gh<_i356.TaskRepository>()));
    gh.factory<_i335.DeleteTask>(
        () => _i335.DeleteTask(gh<_i356.TaskRepository>()));
    gh.factory<_i441.GetTasks>(
        () => _i441.GetTasks(gh<_i356.TaskRepository>()));
    gh.factory<_i869.GetTaskById>(
        () => _i869.GetTaskById(gh<_i356.TaskRepository>()));
    gh.factory<_i184.UpdateTask>(
        () => _i184.UpdateTask(gh<_i356.TaskRepository>()));
    gh.factory<_i363.AuthBloc>(() => _i363.AuthBloc(
          signInWithGoogle: gh<_i648.SignInWithGoogle>(),
          signInWithEmail: gh<_i509.SignInWithEmail>(),
          signOut: gh<_i872.SignOut>(),
          getCurrentUser: gh<_i191.GetCurrentUser>(),
          checkAuthStatus: gh<_i818.CheckAuthStatus>(),
        ));
    gh.factory<_i1006.TaskBloc>(() => _i1006.TaskBloc(
          getTasks: gh<_i441.GetTasks>(),
          getTaskById: gh<_i869.GetTaskById>(),
          createTask: gh<_i483.CreateTask>(),
          updateTask: gh<_i184.UpdateTask>(),
          deleteTask: gh<_i335.DeleteTask>(),
          checkInTask: gh<_i754.CheckInTask>(),
          completeTask: gh<_i202.CompleteTask>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i809.RegisterModule {}
