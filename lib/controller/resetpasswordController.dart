import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math'; // Random key generator
import 'package:flutter/material.dart';

class ResetPassword {
  bool _isSending = false;

  Future<int> sendEmail(String email) async {
    // Replace with your email credentials
    String username = 'arshadmuhd50@gmail.com'; // Sender username
    String password = 'fjqsxpcbbfubxtzy'; // Sender App Password

    final smtpServer = gmail(username, password);

    final verificationCode = generateVerificationCode();

    final message = Message()
      ..from = Address(username, 'MYCare') // Replace with your app name
      ..recipients.add('muhddarshad@gmail.com') // Recipient email
      ..subject = '(MYCare) Your Verification Code - ${DateTime.now().toLocal()}'
      ..html = """
        <div style="font-family: Arial, sans-serif; padding: 20px; line-height: 1.5;">
          <h2 style="color: #4CAF50;">Password Verification</h2>
          <p>Hi,</p>
          <p>Your password verification code is:</p>
          <div style="font-size: 20px; font-weight: bold; color: #333; margin: 20px 0;">
            $verificationCode
          </div>
          <p>Please enter this code in the app to complete your verification process.</p>
        </div>
      """;

    try {
      // Send the email and handle any exceptions
      _isSending = true;
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      return int.parse(verificationCode); // Return the verification code as an integer
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } finally {
      _isSending = false;
    }

    return 0; // Return 0 if something went wrong
  }

  String generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit code
  }
}
