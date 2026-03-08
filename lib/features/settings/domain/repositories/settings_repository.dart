import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings);
  Future<Either<Failure, String>> getAppVersion();
  Future<Either<Failure, Unit>> openAppSettings();
  Future<Either<Failure, bool>> checkPermissions();
  Future<Either<Failure, bool>> validateFolderPath(String path);
}