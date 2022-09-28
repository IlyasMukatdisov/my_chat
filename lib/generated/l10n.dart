// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Welcome to`
  String get landing_title {
    return Intl.message(
      'Welcome to',
      name: 'landing_title',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Calls`
  String get calls {
    return Intl.message(
      'Calls',
      name: 'calls',
      desc: '',
      args: [],
    );
  }

  /// `Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.`
  String get landing_privacy_terms {
    return Intl.message(
      'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
      name: 'landing_privacy_terms',
      desc: '',
      args: [],
    );
  }

  /// `AGREE AND CONTINUE`
  String get agree_and_continue {
    return Intl.message(
      'AGREE AND CONTINUE',
      name: 'agree_and_continue',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enter_phone_number {
    return Intl.message(
      'Enter phone number',
      name: 'enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `This page doesn't exist`
  String get page_does_not_exists {
    return Intl.message(
      'This page doesn\'t exist',
      name: 'page_does_not_exists',
      desc: '',
      args: [],
    );
  }

  /// `My chat need to verify your phone number`
  String get my_chat_need_to_verify {
    return Intl.message(
      'My chat need to verify your phone number',
      name: 'my_chat_need_to_verify',
      desc: '',
      args: [],
    );
  }

  /// `Pick country`
  String get pick_country {
    return Intl.message(
      'Pick country',
      name: 'pick_country',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone_number {
    return Intl.message(
      'Phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Login error: `
  String get login_error {
    return Intl.message(
      'Login error: ',
      name: 'login_error',
      desc: '',
      args: [],
    );
  }

  /// `Verify your number`
  String get verify_your_number {
    return Intl.message(
      'Verify your number',
      name: 'verify_your_number',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `We have send you an SMS with code. Please enter it here`
  String get we_have_send_sms {
    return Intl.message(
      'We have send you an SMS with code. Please enter it here',
      name: 'we_have_send_sms',
      desc: '',
      args: [],
    );
  }

  /// `We can't load image from your gallery. Please try again later`
  String get cant_load_image {
    return Intl.message(
      'We can\'t load image from your gallery. Please try again later',
      name: 'cant_load_image',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enter_your_name {
    return Intl.message(
      'Enter your name',
      name: 'enter_your_name',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
