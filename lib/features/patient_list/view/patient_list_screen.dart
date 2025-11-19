import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/core/widgets/async_value_widget.dart';
import 'package:kowairo/domain/entities/user.dart';
import 'package:kowairo/features/auth/provider/auth_provider.dart';
import 'package:kowairo/features/patient_list/provider/patient_list_provider.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/domain/entities/patient.dart';
import 'package:kowairo/features/patient_list/widgets/patient_tile.dart';
import 'package:kowairo/gen/assets.gen.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final keyword = ref.read(patientSearchKeywordProvider);
    _searchController = TextEditingController(text: keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(filteredPatientListProvider);
    final userService = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('患者一覧'),
        actions: [
          FutureBuilder<User?>(
            future: userService.getCurrentUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Icon(Icons.error, color: Colors.red);
              }

              final userName = snapshot.data?.fullName ?? 'ユーザー';
              return InkWell(
                onTap: () {
                  ref.read(authProvider.notifier).signOut();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Assets.icons.icId.svg(),
                    Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: AsyncValueWidget<List<Patient>>(
        value: patientsAsync,
        data: (patients) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                child: Row(
                  children: [
                    SizedBox(
                      width: 420,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, _) {
                          final hasText = value.text.isNotEmpty;
                          return TextField(
                            controller: _searchController,
                            onChanged: (newValue) =>
                                ref.read(patientSearchKeywordProvider.notifier).updateKeyword(newValue),
                            decoration: InputDecoration(
                              hintText: '患者の名前を入力',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: hasText
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(patientSearchKeywordProvider.notifier).updateKeyword('');
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: patients.isEmpty
                    ? const Center(child: Text('患者が見つかりません。'))
                    : ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return PatientTile(
                            patient: patient,
                            onVisitRecord: () {
                              context.push('/patients/${patient.id}', extra: patient);
                            },
                            onConference: () {
                              context.push('/patients/${patient.id}', extra: patient);
                            },
                            onMonthlyReport: () {
                              context.push('/patients/${patient.id}', extra: patient);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
