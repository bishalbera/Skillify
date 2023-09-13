import 'package:flutter/material.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/extensions/string_extension.dart';
import 'package:skillify/src/profile/presentation/widgets/edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.oldPasswordController,
    required this.bioController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          controller: nameController,
          fieldTitle: 'Name',
        ),
        EditProfileFormField(
          controller: emailController,
          fieldTitle: 'Email',
          hintText: context.currentUser!.email.obscureEmail,
        ),
        EditProfileFormField(
          controller: oldPasswordController,
          fieldTitle: 'Current Password',
          hintText: '********',
        ),
        StatefulBuilder(
          builder: (_, setState) {
            oldPasswordController.addListener(() => setState(() {}));
            return EditProfileFormField(
              controller: passwordController,
              fieldTitle: 'New Password',
              hintText: '********',
              readOnly: oldPasswordController.text.isEmpty,
            );
          },
        ),
        EditProfileFormField(
          controller: bioController,
          fieldTitle: 'Bio',
          hintText: context.currentUser!.bio,
        ),
      ],
    );
  }
}
