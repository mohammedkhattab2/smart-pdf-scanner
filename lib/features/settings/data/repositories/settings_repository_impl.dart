import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  const SettingsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings ?? AppSettingsModel.defaultSettings);
    } catch (e) {
      return const Left(
        UnexpectedFailure('Failed to load settings'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings) async {
    try {
      final settingsModel = AppSettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(settingsModel);
      return const Right(unit);
    } catch (e) {
      return const Left(
        FileSaveFailure('Failed to save settings'),
      );
    }
  }
  
  @override
  Future<Either<Failure, String>> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return Right('${packageInfo.version} (${packageInfo.buildNumber})');
    } catch (e) {
      return const Left(
        UnexpectedFailure('Failed to get app version'),
      );
    }
  }
  
  @override
  Future<Either<Failure, Unit>> openAppSettings() async {
    try {
      // Use permission_handler's global openAppSettings function
      final opened = await permission_handler.openAppSettings();
      if (opened) {
        return const Right(unit);
      } else {
        return const Left(
          UnexpectedFailure('Could not open app settings'),
        );
      }
    } catch (e) {
      return const Left(
        UnexpectedFailure('Failed to open app settings'),
      );
    }
  }
  
  @override
  Future<Either<Failure, bool>> checkPermissions() async {
    try {
      final cameraStatus = await permission_handler.Permission.camera.status;
      final storageStatus = await permission_handler.Permission.storage.status;
      
      return Right(cameraStatus.isGranted && storageStatus.isGranted);
    } catch (e) {
      return const Left(
        UnexpectedFailure('Failed to check permissions'),
      );
    }
  }
  
  @override
  Future<Either<Failure, bool>> validateFolderPath(String path) async {
    try {
      if (path.isEmpty) {
        return const Right(false);
      }
      
      final directory = Directory(path);
      final exists = await directory.exists();
      
      if (!exists) {
        // Try to create the directory
        try {
          await directory.create(recursive: true);
          return const Right(true);
        } catch (e) {
          return const Right(false);
        }
      }
      
      return const Right(true);
    } catch (e) {
      return const Left(
        UnexpectedFailure('Failed to validate folder path'),
      );
    }
  }
}