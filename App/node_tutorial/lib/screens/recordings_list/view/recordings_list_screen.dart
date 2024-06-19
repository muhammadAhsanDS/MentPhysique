import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/app_colors.dart';
import '../../../controller/audio_player_controller.dart';
import '../../../models/recording_group.dart';
import '../cubit/files/files_cubit.dart';
import 'widgets/playing_icons.dart';

class RecordingsListScreen extends StatefulWidget {
  static const routeName = '/recordingsList';

  @override
  _RecordingsListScreenState createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  final AudioPlayerController controller = AudioPlayerController();

  @override
  void initState() {
    super.initState();
    // Request storage permission automatically when the screen loads
    _requestStoragePermission();
  }

  // Method to request storage permission
  void _requestStoragePermission() async {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // If permission is granted, load files
      context.read<FilesCubit>().getFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<FilesCubit, FilesState>(
        builder: (context, state) {
          if (state is FilesLoaded) {
            String _durationString(Duration duration) {
              String twoDigits(int n) => n.toString().padLeft(2, "0");
              String twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
              String twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));
              return "$twoDigitMinutes:$twoDigitSeconds";
            }

            Widget buildGroup(RecordingGroup rGroup) {
              final currentTime = DateTime.now();

              final today = DateTime.utc(
                  currentTime.year, currentTime.month, currentTime.day);

              String title = '';
              int diffrence = rGroup.date.difference(today).inDays;

              if (diffrence == -1) {
                title = 'Yesterday';
              } else if (diffrence == 0) {
                title = 'Today';
              } else {
                title = getDateString(rGroup.date);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 5,
                    ),
                  ),
                  ...rGroup.recordings
                      .map((groupRecording) => Dismissible(
                            background: Container(color: AppColors.shadowColor),
                            onDismissed: (direction) async {
                              controller.stop();
                              final recording = state.recordings.firstWhere(
                                  (element) => element == groupRecording);
                              await recording.file.delete();
                              context
                                  .read<FilesCubit>()
                                  .removeRecording(recording);
                            },
                            key: Key(groupRecording.fileDuration.toString()),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                selectedTileColor: Colors.green,
                                title: Text(
                                  dateTimeToTimeString(groupRecording.dateTime),
                                  style: TextStyle(
                                    color: AppColors.accentColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: 5,
                                  ),
                                ),
                                trailing: Text(
                                  _durationString(groupRecording.fileDuration),
                                  style: TextStyle(
                                    color: AppColors.accentColor,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                onTap: () async {
                                  await controller.stop();
                                  await controller.setPath(
                                      filePath: groupRecording.file.path);
                                  await controller.play();
                                  await controller.stop();
                                },
                              ),
                            ),
                          ))
                      .toList()
                ],
              );
            }

            if (state.sortedRecordings.isNotEmpty) {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: state.sortedRecordings
                          .map((RecordingGroup recordingGroup) {
                        if (recordingGroup.recordings.isNotEmpty) {
                          return buildGroup(recordingGroup);
                        } else {
                          return SizedBox();
                        }
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'You have not recorded any notes',
                  style: TextStyle(color: AppColors.accentColor),
                ),
              );
            }
          } else if (state is FilesLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.accentColor,
            ));
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
      bottomNavigationBar: playingIndicator(),
    );
  }

  String getDateString(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month = '';
    switch (dateTime.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'Novenber';
        break;
      case 12:
        month = 'December';
        break;
    }

    return '$day $month';
  }

  String dateTimeToTimeString(DateTime dateTime) {
    bool isPM = false;
    int hour = dateTime.hour;
    int min = dateTime.minute;

    if (hour > 12) {
      isPM = true;
      hour -= 12;
    }

    return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} ${isPM ? 'pm' : 'am'}';
  }

  Widget playingIndicator() {
    final double borderRadius = 40;
    return GestureDetector(
      onTap: () {
        controller.stop();
      },
      child: Container(
        alignment: Alignment.center,
        height: 80,
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                // blurRadius: 20,
                offset: Offset(0, -5),
                blurRadius: 10,
                color: Colors.black26,
              ),
            ]),
        child: StreamBuilder<PlayerState>(
          stream: controller.playerState,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.playing) {
                return PlayingIcon();
              } else {
                return PlayingIcon.idle();
              }
            } else {
              return Text('Stopped');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
