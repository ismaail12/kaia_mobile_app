import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kaia_mobile_app/bloc/auth/auth_bloc.dart';
import 'package:kaia_mobile_app/bloc/bloc/device_bloc.dart';
import 'package:kaia_mobile_app/bloc/presence/presence_bloc.dart';
import 'package:kaia_mobile_app/cubit/cubit/type_chip_cubit.dart';
import 'package:kaia_mobile_app/presentation/components/custom_button.dart';
import 'package:kaia_mobile_app/presentation/components/custom_loading.dart';
import 'package:kaia_mobile_app/utils/custom_utils.dart';
import 'package:kaia_mobile_app/utils/default_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DeviceBloc>().add(const GetPhone());
    context.read<PresenceBloc>().add(PresenceInitial());
    Map<String, String> getDateNow() {
      initializeDateFormatting('id');
      return {
        "day": DateFormat('EEEE', 'id').format(DateTime.now()),
        "date": DateFormat('dd MMMM yyyy', 'id').format(DateTime.now())
      };
    }

    final screenHeight = MediaQuery.of(context).size.height;

    Stream<String> timeStream = Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) => DateFormat.Hms().format(DateTime.now()),
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'PT KAIA Anugerah Internasional',
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.grey[200],
          elevation: 0,
          expandedHeight: 120,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  // InkWell(
                  //   onTap: () {
                  //     final token = context.read<AuthBloc>().state.token;
                  //     context.read<AuthBloc>().add(AuthLogout(token!));
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) => LoginScreen(),
                  //       ),
                  //     );
                  //   },
                  //   child: const CircleAvatar(
                  //     backgroundColor: kPrimary,
                  //     radius: 25,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 6),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.user?.name ?? 'no name',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(state.user?.email ?? 'no email',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                )),
                          ],
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                  color: kPrimary, borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<String>(
                          stream: timeStream,
                          initialData: DateFormat.Hms().format(DateTime.now()),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDateNow()['day'] ?? 'Day',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            getDateNow()['date'] ?? 'Date',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )
                    ],
                  ),
                  BlocConsumer<PresenceBloc, PresenceState>(
                    listener: (context, state) {
                      if (state.status == ClockedStatus.clockedOut) {
                        CustomUtils.displaySnackBarGreen(
                            context, state.message.toString(), 150);
                      }
                      if (state.status == ClockedStatus.error) {
                        CustomUtils.displaySnackBarRed(
                            context, state.message.toString(), 150);
                      }
                    },
                    builder: (context, state) {
                      final text = state.status == ClockedStatus.clockedIn
                          ? 'Clock Out'
                          : 'Clock In';
                      final color = state.status == ClockedStatus.clockedIn
                          ? Colors.red
                          : const Color.fromRGBO(53, 197, 67, 1);

                      return BlocBuilder<DeviceBloc, DeviceState>(
                        builder: (context, deviceState) {
                          if (deviceState is! DeviceActive) {
                            return Container();
                          }
                          return CusElevatedButton(
                            text: state.status == ClockedStatus.loading
                                ? const CustLoading(size: 20)
                                : Text(
                                    text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                            color: state.status == ClockedStatus.loading
                                ? Colors.transparent
                                : color,
                            action: () {
                              if (state.status == ClockedStatus.clockedIn) {
                                if (state.status != ClockedStatus.loading) {
                                  CustomUtils.customAlertConfirmDialog(context,
                                      () {
                                    context.read<PresenceBloc>().add(
                                        PresenceClockOut(
                                            id: context
                                                .read<PresenceBloc>()
                                                .state
                                                .id!));
                                  },
                                      title: 'Clock out',
                                      message: 'Apakah anda yakin?');
                                }
                              } else {
                                showClockInBottomSheet(context);
                              }
                            },
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Container(
        //       height: 100,
        //       decoration: BoxDecoration(
        //           color: kPrimary, borderRadius: BorderRadius.circular(12)),
        //     ),
        //   ),
        // ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Presensi',
                  style: TextStyle(
                      color: Colors.grey[800], fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),

        BlocBuilder<PresenceBloc, PresenceState>(
          builder: (context, state) {
            if (state.last5Presences?.data == null) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text('Tidak ada data'),
                    ),
                  ),
                ),
              );
            } else {
              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // print(state.last5Presences?.data.length);
                    final date = state.last5Presences?.data.entries
                            .toList()[index]
                            .value
                            .createdAt
                            .toString() ??
                        "null";
                    final clockOutDate = state.last5Presences?.data.entries
                            .toList()[index]
                            .value
                            .clockout
                            .toString() ??
                        "null";

                    String clockOut;

                    if (clockOutDate == "null") {
                      clockOut = " - ";
                    } else {
                      final parsed = DateTime.parse(clockOutDate);
                      clockOut = '${parsed.hour + 7} : ${parsed.minute}';
                    }

                    DateTime createdAt = DateTime.parse(date);

                    String formattedDate =
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                            .format(createdAt);
                    String formattedClockIn =
                        '${createdAt.hour + 7} : ${createdAt.minute}';

                    // String formattedClockOut =

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        childrenPadding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        expandedAlignment: Alignment.topLeft,

                        title: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jam Masuk'),
                                  Text('Jam Pulang'),
                                  // Text('Keterangan'),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Column(
                                children: [
                                  Text(':'),
                                  Text(':'),
                                  // Text(':'),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(formattedClockIn),
                                    Text(clockOut),
                                    // Text(
                                    //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                    //     maxLines: 3),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                        // trailing: const Icon(Icons.arrow_right),
                      ),
                    );
                  }, childCount: state.last5Presences?.data.length),
                ),
              );
            }
          },
        )
      ],
    );
  }

  Future<dynamic> showClockInBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Nama Perusahaan:',
                  style: TextStyle(
                      color: Colors.grey[800], fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'PT KAIA Anugerah Internasional',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text('Jabatan:',
                  style: TextStyle(
                      color: Colors.grey[800], fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                context.read<AuthBloc>().state.user?.jabatan.toString() ??
                    'Jabatan',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Jam Kerja:',
                style: TextStyle(
                    color: Colors.grey[800], fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 4),
              BlocBuilder<TypeChipCubit, Map<String, bool>>(
                builder: (context, state) {
                  return Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Normal'),
                        selected: state["normal"]!,
                        selectedColor: Colors.green[100],
                        onSelected: (value) {
                          context.read<TypeChipCubit>().setNormalTrue();
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ChoiceChip(
                        label: const Text('Lembur'),
                        selected: state["lembur"]!,
                        selectedColor: Colors.green[100],
                        onSelected: (value) {
                          context.read<TypeChipCubit>().setLemburTrue();
                        },
                      ),
                    ],
                  );
                },
              ),
              // const SizedBox(height: 16),
              // CusTextField(
              //   name: 'Keterangan',
              //   padding: 4,
              // ),
              const SizedBox(height: 16 * 2),
              BlocConsumer<PresenceBloc, PresenceState>(
                listener: (context, state) {
                  if (state.status == ClockedStatus.clockedIn) {
                    CustomUtils.displaySnackBarGreen(
                        context, state.message.toString(), 150);
                    Navigator.pop(context);
                  }
                  if (state.status == ClockedStatus.error) {
                    CustomUtils.displaySnackBarRed(
                        context, state.message.toString(), 150);
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return CusElevatedButton(
                      text: state.status == ClockedStatus.loading
                          ? const CustLoading(size: 20)
                          : const Text(
                              'Submit',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      action: () async {
                        final typeChipState =
                            context.read<TypeChipCubit>().state;

                        if (typeChipState['normal'] == true ||
                            typeChipState['lembur'] == true) {
                          if (state.status != ClockedStatus.loading) {
                            context.read<PresenceBloc>().add(PresenceClockIn(
                                type: typeChipState['normal'] == true
                                    ? 'normal'
                                    : 'overtime'));
                            print(state.status);
                          }
                        } else {
                          CustomUtils.displaySnackBarRed(
                              context, 'Pilih Jenis Jam Kerja', 150);
                        }
                      });
                },
              )
            ],
          ),
        ]),
      ),
    );
  }
}
