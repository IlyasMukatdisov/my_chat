import 'package:flutter/material.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = "/otp-screen";
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).verify_your_number),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        width: size.width,
        child: Column(
          children: [
            Text(AppLocalizations.of(context).we_have_send_sms),
            const SizedBox(
              height: AppConstants.defaultPadding * 2,
            ),
            SizedBox(
              width: size.width / 2,
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 5,
                ),
                decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(fontSize: 24)),
                maxLength: 6,
                onChanged: (value) {
                  
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
