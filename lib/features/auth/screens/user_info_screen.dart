import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:my_chat/utils/colors.dart';

class UserInfoScreen extends StatefulWidget {
  static const routeName = '/user-credential';

  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? _image;
  late final TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() {}),
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width / 3,
                child: InkWell(
                  onTap: () async {
                    _image = await pickImageFromGallery(context);
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      _image != null?
                      CircleAvatar(
                        radius: size.width / 6,
                        backgroundImage:
                            FileImage(_image!),
                        backgroundColor: _image == null ? tabColor : null,
                        child: _image == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ): CircleAvatar(
                        radius: size.width / 6,
                        backgroundImage:
                            const NetworkImage(AppConstants.defaultProfilePic),
                        backgroundColor: _image == null ? tabColor : null,
                        child: _image == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const Positioned(
                        right: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: AppConstants.defaultPadding * 2,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).name,
                  hintText: AppLocalizations.of(context).enter_your_name,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
