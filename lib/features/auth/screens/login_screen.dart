import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/common/widgets/custom_button.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _phoneController;
  String _phoneCode = '';

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          _phoneCode = country.phoneCode;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = _phoneController.text.trim();
    if (_phoneCode.isNotEmpty && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
            context: context,
            phoneNumber: "+$_phoneCode$phoneNumber",
          );
    } else {
      showSnackBar(
          context: context, text: 'Fill the phone number and country code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        AppLocalizations.of(context).enter_phone_number,
      ),
    );
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(
          builder: (context1, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight -
                          appBar.preferredSize.height / 2,
                      minWidth: constraints.maxWidth),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).my_chat_need_to_verify,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppConstants.defaultPadding,
                        ),
                        TextButton(
                          onPressed: () {
                            pickCountry();
                          },
                          child: Text(
                            AppLocalizations.of(context).pick_country,
                          ),
                        ),
                        // ignore: prefer_const_constructors
                        SizedBox(
                          height: AppConstants.defaultPadding,
                        ),
                        TextFormField(
                          controller: _phoneController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          maxLength:
                              _phoneCode.isEmpty ? 14 : 15 - _phoneCode.length,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixText: '+$_phoneCode',
                              labelText:
                                  AppLocalizations.of(context).phone_number,
                              hintText:
                                  AppLocalizations.of(context).phone_number),
                        ),
                        size.height > 300
                            ? const Spacer()
                            : const SizedBox(
                                height: AppConstants.defaultPadding,
                              ),
                        CustomButton(
                          text: AppLocalizations.of(context).next,
                          callback: sendPhoneNumber,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
