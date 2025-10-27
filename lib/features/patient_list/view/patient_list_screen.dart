import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/core/widgets/async_value_widget.dart';
import 'package:kowairo/features/auth/provider/auth_provider.dart';
import 'package:kowairo/features/patient_list/provider/patient_list_provider.dart';
import 'package:kowairo/features/auth/provider/user_provider.dart';
import 'package:kowairo/domain/entities/patient.dart';
import 'package:kowairo/gen/assets.gen.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientListProvider);
    final userInfoAsync = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('患者一覧'),
        actions: [
          AsyncValueWidget<String>(
            value: userInfoAsync,
            data: (userName) => InkWell(
              onTap: () {
                // TODO: ユーザープロフィール画面への遷移
                ref.read(authProvider.notifier).signOut();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.icId.svg(),
                    const SizedBox(width: 8),
                    Text(userName, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(strokeWidth: 2), SizedBox(width: 8), Text('読み込み中...')],
              ),
            ),
            error: (error, stackTrace) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('エラー'),
                ],
              ),
            ),
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
