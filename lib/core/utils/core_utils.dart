import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillify/core/enums/notification_enum.dart';
import 'package:skillify/core/res/colours.dart';
import 'package:skillify/src/notification/data/models/notification_model.dart';
import 'package:skillify/src/notification/presentation/cubit/notification_cubit.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colours.primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static void sendNotification(
    BuildContext context, {
    required String title,
    required String body,
    required NotificationCategory category,
  }) {
    context.read<NotificationCubit>().sendNotification(
          NotificationModel.empty().copyWith(
            title: title,
            body: body,
            category: category,
          ),
        );
  }
}
