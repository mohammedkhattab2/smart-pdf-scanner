import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class BatchProcessorDataSource {
  Future<Either<Failure, List<String>>> processMultipleImages({
    required List<String> imagePaths,
    bool autoCrop = true,
    bool autoEnhance = true,
  });
  
  Future<Either<Failure, Uint8List>> mergeImagesIntoPdf({
    required List<String> imagePaths,
    String? title,
  });
  
  Stream<double> getBatchProcessingProgress();
}

class BatchProcessorDataSourceImpl implements BatchProcessorDataSource {
  double _currentProgress = 0.0;
  
  @override
  Future<Either<Failure, List<String>>> processMultipleImages({
    required List<String> imagePaths,
    bool autoCrop = true,
    bool autoEnhance = true,
  }) async {
    try {
      final processedPaths = <String>[];
      _currentProgress = 0.0;
      
      for (int i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];
        final file = File(imagePath);
        
        if (!await file.exists()) {
          return Left(FileReadFailure('Image not found: $imagePath'));
        }
        
        // For now, just return the original paths
        // In production, this would apply batch processing
        processedPaths.add(imagePath);
        
        _currentProgress = (i + 1) / imagePaths.length;
      }
      
      return Right(processedPaths);
    } catch (e) {
      return Left(UnexpectedFailure('Batch processing failed: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Uint8List>> mergeImagesIntoPdf({
    required List<String> imagePaths,
    String? title,
  }) async {
    try {
      // This would be implemented with pdf package
      // For now, return empty bytes
      return Right(Uint8List(0));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to merge images: $e'));
    }
  }
  
  @override
  Stream<double> getBatchProcessingProgress() async* {
    while (_currentProgress < 1.0) {
      yield _currentProgress;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    yield 1.0;
  }
}