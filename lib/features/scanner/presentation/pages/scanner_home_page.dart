import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/scanned_document.dart';
import '../cubit/pdf_list_cubit.dart';
import '../cubit/pdf_list_state.dart';
import '../cubit/scanner_cubit.dart';

/// Home screen displaying the list of saved PDFs and entry point to the scan flow.
///
/// This screen:
/// - Listens to [PdfListCubit] to show saved documents.
/// - Uses [ScannerCubit] only to reset scanner state when starting a new scan.
/// - Navigates to the camera/crop flow (to be implemented in separate pages).
class ScannerHomePage extends StatelessWidget {
  const ScannerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart PDF Scanner'),
      ),
      body: BlocBuilder<PdfListCubit, PdfListState>(
        builder: (context, state) {
          if (state is PdfListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PdfListLoaded) {
            if (state.documents.isEmpty) {
              return const _EmptyState();
            }
            return _PdfList(documents: state.documents);
          } else if (state is PdfListError) {
            return _ErrorState(message: state.message);
          } else {
            // Initial or unknown state: show simple placeholder.
            return const _EmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Reset scanner state before starting a new flow.
          context.read<ScannerCubit>().reset();

          // TODO: Navigate to CameraPage when implemented.
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (_) => const CameraPage()),
          // );
        },
        child: const Icon(Icons.document_scanner),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No PDFs yet.\nTap the scan button to create your first document.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class _PdfList extends StatelessWidget {
  final List<ScannedDocument> documents;

  const _PdfList({required this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(doc.fileName),
          subtitle: Text(doc.createdAt.toLocal().toString()),
          onTap: () {
            // Open PDF
            context.read<PdfListCubit>().openDocument(doc);
          },
          trailing: IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              context.read<PdfListCubit>().shareDocument(doc);
            },
          ),
        );
      },
    );
  }
}