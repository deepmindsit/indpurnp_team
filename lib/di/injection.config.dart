// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:indapur_team/network/api_service.dart' as _i269;
import 'package:indapur_team/network/register_module.dart' as _i652;
import 'package:indapur_team/utils/translate_controller.dart' as _i282;
import 'package:indapur_team/view/complaint/controller/complaint_controller.dart'
    as _i869;
import 'package:indapur_team/view/dashboard/controller/dashboard_controller.dart'
    as _i599;
import 'package:indapur_team/view/dashboard/controller/notification_controller.dart'
    as _i185;
import 'package:indapur_team/view/dashboard/controller/profile_controller.dart'
    as _i758;
import 'package:indapur_team/view/dashboard/controller/update_firebase_token.dart'
    as _i203;
import 'package:indapur_team/view/navigation/controller/navigation_controller.dart'
    as _i496;
import 'package:indapur_team/view/onboarding/controller/onboarding_controller.dart'
    as _i354;
import 'package:indapur_team/view/onboarding/controller/splash_controller.dart'
    as _i891;
import 'package:indapur_team/view/onboarding/controller/user_controller.dart'
    as _i645;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i282.TranslateController>(
      () => _i282.TranslateController(),
    );
    gh.lazySingleton<_i869.ComplaintController>(
      () => _i869.ComplaintController(),
    );
    gh.lazySingleton<_i599.DashboardController>(
      () => _i599.DashboardController(),
    );
    gh.lazySingleton<_i185.NotificationController>(
      () => _i185.NotificationController(),
    );
    gh.lazySingleton<_i758.ProfileController>(() => _i758.ProfileController());
    gh.lazySingleton<_i203.FirebaseTokenController>(
      () => _i203.FirebaseTokenController(),
    );
    gh.lazySingleton<_i496.NavigationController>(
      () => _i496.NavigationController(),
    );
    gh.lazySingleton<_i354.OnboardingController>(
      () => _i354.OnboardingController(),
    );
    gh.lazySingleton<_i891.SplashController>(() => _i891.SplashController());
    gh.lazySingleton<_i645.UserService>(() => _i645.UserService());
    gh.factory<_i269.ApiService>(() => _i269.ApiService(gh<_i361.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i652.RegisterModule {}
