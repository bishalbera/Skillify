import 'package:flutter/material.dart';
import 'package:skillify/core/common/widgets/text_field.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.controller,
    required this.fieldTitle,
    this.readOnly = false,
    super.key,
    this.hintText,
  });

  final TextEditingController controller;
  final String fieldTitle;
  final String? hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            fieldTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
