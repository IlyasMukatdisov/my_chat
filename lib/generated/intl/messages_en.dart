// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "agree_and_continue":
            MessageLookupByLibrary.simpleMessage("AGREE AND CONTINUE"),
        "calls": MessageLookupByLibrary.simpleMessage("Calls"),
        "chats": MessageLookupByLibrary.simpleMessage("Chats"),
        "enter_phone_number":
            MessageLookupByLibrary.simpleMessage("Enter phone number"),
        "landing_privacy_terms": MessageLookupByLibrary.simpleMessage(
            "Read our Privacy Policy. Tap \"Agree and continue\" to accept the Terms of Service."),
        "landing_title": MessageLookupByLibrary.simpleMessage("Welcome to"),
        "login_error": MessageLookupByLibrary.simpleMessage("Login error: "),
        "my_chat_need_to_verify": MessageLookupByLibrary.simpleMessage(
            "My chat need to verify your phone number"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "page_does_not_exists":
            MessageLookupByLibrary.simpleMessage("This page doesn\'t exist"),
        "phone_number": MessageLookupByLibrary.simpleMessage("Phone number"),
        "pick_country": MessageLookupByLibrary.simpleMessage("Pick country"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "verify_your_number":
            MessageLookupByLibrary.simpleMessage("Verify your number"),
        "we_have_send_sms": MessageLookupByLibrary.simpleMessage(
            "We have send you an SMS with code. Please enter it here")
      };
}
