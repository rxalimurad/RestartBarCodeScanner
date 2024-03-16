import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';

import '../DBHandler/MongoDbHelper.dart';

class ChangePasswordScreen extends StatelessWidget {
  var isLoading = false.obs;
  late GSForm form;
  var email = Get.arguments['email'];
  var postLogin = Get.arguments['postLogin'] ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: form = GSForm.singleSection(context,
                      style: GSFormStyle(
                          backgroundSectionColor: Colors.white,
                          sectionCardElevation: 0,
                          sectionRadius: 10.0,
                          fieldRadius: 10,
                          sectionCardPadding: 8.0,
                          requiredText: '*'),
                      fields: [
                        GSField.password(
                          value: '',
                          hint: 'New Password',
                          tag: 'newPassword',
                          title: 'New Password',
                          validateReg: RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                          ),
                          errorMessage:
                              'Password must contain at least 8 characters, including letters and numbers',
                          required: true,
                        ),
                        GSField.password(
                          value: '',
                          hint: 'Confirm Password',
                          tag: 'confirmPassword',
                          title: 'Confirm Password',
                          validateReg: RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                          ),
                          errorMessage:
                              'Password must contain at least 8 characters, including letters and numbers',
                          required: true,
                        ),
                      ]),
                ),
                Obx(() {
                  return SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (form.isValid()) {
                          isLoading.value = true;
                          Map<String, dynamic> map = form.onSubmit();
                          if (map['newPassword'] != map['confirmPassword']) {
                            isLoading.value = false;
                            SnackBar snackBar = SnackBar(
                              content: Text('Password does not match'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          var password = map['newPassword'];
                          try {
                            print('Email: $email');
                            await MongoDbHelper.changePassword(
                                email!, password);
                          } catch (e) {
                            print('Error changing password: $e');
                            isLoading.value = false;
                            SnackBar snackBar = SnackBar(
                              content: Text('Error changing password'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          isLoading.value = false;
                          SnackBar snackBar = SnackBar(
                            content: Text('Password changed successfully'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          if (postLogin) {
                            Get.back();
                          } else {
                            Get.offAllNamed('/LoginScreen');
                          }
                        }
                      },
                      child: isLoading.value
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              height: 30,
                              width: 30,
                            )
                          : Text('Change Password'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
