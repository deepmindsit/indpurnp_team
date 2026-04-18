import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> getHttpClient() async {
  final ioc = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
        true;
  return IOClient(ioc);
}

class AllUrl {
  // static const String baseUrl =
  //     "https://192.168.29.102/pnp_v2/api/team/v1";
  static const String baseUrl = "https://myindapurnp.diabot.in/api/team/v1";
  // static const String baseUrl = "http://192.168.29.37/myindapurnp/api/team/v1";
  static const String login = '$baseUrl/sign-in';
  static const String getStatus = '$baseUrl/get-complaint-status';
  static const String getComplaint = '$baseUrl/get-complaint';
  static const String addComplaintComment = '$baseUrl/add-complaint-comment';
  static const String getComplaintDetails = '$baseUrl/get-complaint-details';
  static const String getDepartment = '$baseUrl/get-department';
  static const String getWard = '$baseUrl/get-ward';
  static const String getTask = '$baseUrl/get-task';
  static const String getTaskDetails = '$baseUrl/get-task-details';
  static const String getPriority = '$baseUrl/get-priority';
  static const String getTaskStatus = '$baseUrl/get-task-status';
  static const String getAssignee = '$baseUrl/get-assignee';
  static const String addTaskComment = '$baseUrl/add-task-comment';
  static const String addNewTask = '$baseUrl/add-new-task';
  static const String helpAndSupport = '$baseUrl/get-help-support';
  static const String legalPage = '$baseUrl/get-legal-page';
  static const String getProfile = '$baseUrl/get-profile';
  static const String getFiles = '$baseUrl/get-files';
  static const String getFileDetails = '$baseUrl/get-file-details';
  static const String addFileComment = '$baseUrl/add-file-comment';
  static const String updateProfile = '$baseUrl/update';
  static const String getKms = '$baseUrl/get-kms';
  static const String getDashboard = '$baseUrl/get-dashboard';
  static const String deleteAccount = '$baseUrl/delete-account';
  static const String getComplaintType = '$baseUrl/get-complaint-type';
  //pending

  static const String updateFirebaseToken = "$baseUrl/update-firebase-token";
  static const String getNotification = "$baseUrl/get-notification";
  static const String readNotification = "$baseUrl/read-notification";
}
