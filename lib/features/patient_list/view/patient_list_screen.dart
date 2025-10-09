import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/core/widgets/async_value_widget.dart';
import 'package:kowairo/features/patient_list/provider/patient_list_provider.dart';
import 'package:kowairo/domain/entities/patient.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('患者一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Call sign out method from auth provider
              // ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: AsyncValueWidget<List<Patient>>(
        value: patientsAsync,
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('患者が見つかりません。'));
          }
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              // TODO: Create and use a PatientListItem widget
              return ListTile(
                title: Text(patient.fullName),
                subtitle: Text('生年月日: ${patient.dateOfBirth?.toLocal().toString().split(' ')[0]}, ${patient.age}歳'),
                onTap: () {
                  // TODO: Navigate to patient detail screen using GoRouter
                  // context.go('/patients/${patient.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
