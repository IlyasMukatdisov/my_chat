import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/group/widgets/select_contact_group.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:my_chat/utils/colors.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = '/create-group-screen';
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? _image;
  late final TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void createGroup() {
    if (_nameController.text.trim().isNotEmpty && _image != null) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).create_group),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding),
          child: Column(
            children: [
              const SizedBox(
                height: AppConstants.defaultPadding,
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
                      _image != null
                          ? CircleAvatar(
                              radius: size.width / 6,
                              backgroundImage: FileImage(_image!),
                              backgroundColor: _image == null ? tabColor : null,
                            )
                          : CircleAvatar(
                              radius: size.width / 6,
                              backgroundImage: const NetworkImage(
                                  AppConstants.defaultProfilePic),
                              backgroundColor: _image == null ? tabColor : null,
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
                controller: _nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).group_name,
                  hintText: AppLocalizations.of(context).group_name,
                ),
              ),
              const SizedBox(
                height: AppConstants.defaultPadding,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).select_contact,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SelectContactGroup(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
