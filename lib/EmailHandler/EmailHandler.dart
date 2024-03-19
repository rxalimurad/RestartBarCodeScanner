import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailHandler {
  final String username;
  final String password;
  final SmtpServer smtpServer;
  var toEmail = "app@restartedu.org";

  EmailHandler._(
      {required this.username,
      required this.password,
      required this.smtpServer});

  static final EmailHandler _instance = EmailHandler._(
    username: 'volutiontechnologies@gmail.com',
    password: 'ibdl ibvw yqkp oldf',
    smtpServer: gmail('volutiontechnologies@gmail.com', 'ibdl ibvw yqkp oldf'),
  );

  factory EmailHandler.getInstance() {
    return _instance;
  }

  Future<void> sendEmail(String title, String body) async {
    final smtpServer =
        gmail("volutiontechnologies@gmail.com", "ibdl ibvw yqkp oldf");

    final message = Message()
      ..from = Address(username)
      ..recipients.add(toEmail)
      ..bccRecipients.add(username)
      ..subject = title
      ..html = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('Error sending email: $e');
    } finally {}
  }
}
