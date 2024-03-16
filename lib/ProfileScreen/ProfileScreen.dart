import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_scanner/DBHandler/MongoDbHelper.dart';
import 'package:restart_scanner/LocalDataHandler/LocalDataHandler.dart';

import '../Widgets/CustomAlert.dart';

class ProfileScreen extends StatelessWidget {
  var isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder(
          future: LocalDataHandler.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(snapshot.data?.name ?? ''),
                ),
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(snapshot.data?.email ?? ''),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(snapshot.data?.phoneNumber ?? ''),
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () async {
                        Get.dialog(CustomAlertDialog(
                          title: 'Delete Account',
                          message:
                              'Are you sure you want to delete your account?',
                          onOkPressed: () async {
                            isLoading.value = true;
                            await LocalDataHandler.removeUserData();
                            await MongoDbHelper.deleteUser(
                                snapshot.data?.email ?? '');
                            isLoading.value = false;
                            SnackBar snackBar = SnackBar(
                              content: Text('Account Deleted successfully'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Get.offAllNamed('/LoginScreen');
                          },
                        ));
                      },
                      child: isLoading.value
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              height: 30,
                              width: 30,
                            )
                          : Text('Delete Account'),
                    );
                  }),
                ),
              ],
            );
          },
        ));
  }
}
