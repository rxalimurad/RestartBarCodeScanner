import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:restart_scanner/DBHandler/MongoDbHelper.dart';
import 'package:restart_scanner/LoginScreen/LoginController.dart';

class LoginScreen extends StatelessWidget {
  late GSForm form;
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return Column(
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
                        GSField.text(
                          value: '',
                          hint: 'Email',
                          tag: 'email',
                          title: 'Email',
                          validateRegEx: RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ),
                          errorMessage: 'Please enter a valid email',
                          required: true,
                        ),
                        GSField.password(
                          value: '',
                          hint: 'Password',
                          tag: 'password',
                          title: 'Password',
                          validateReg: RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                          ),
                          errorMessage:
                              'Password must contain at least 8 characters, including letters and numbers',
                          required: true,
                        ),
                      ]),
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (form.isValid()) {
                        print('Login form is valid');
                        Map<String, dynamic> map = form.onSubmit();
                        var email = map['email'];
                        var password = map['password'];
                        loginController.isLoading.value = true;
                        LoginResponseStatus status =
                            await MongoDbHelper.loginUser(email, password);
                        loginController.isLoading.value = false;
                        switch (status) {
                          case LoginResponseStatus.alreadyExist:
                            break;
                          case LoginResponseStatus.success:
                            SnackBar snackBar = SnackBar(
                              content: Text('Login successful'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Get.offAllNamed('/ProductsListScreen');
                            break;
                          case LoginResponseStatus.userNotExist:
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                  'User does not exist, please create an account'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Get.toNamed('/SignupScreen');
                            break;
                          case LoginResponseStatus.passwordNotCorrect:
                            SnackBar snackBar = SnackBar(
                              content: Text('Password is not correct'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            break;
                          case LoginResponseStatus.error:
                            SnackBar snackBar = SnackBar(
                              content:
                                  Text('Failed to login, please try again'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            break;
                        }
                      } else {
                        print('Form is invalid');
                      }
                    },
                    child: loginController.isLoading.value
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            height: 30,
                            width: 30,
                          )
                        : Text('Login'),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Get.toNamed('/SignupScreen');
                    },
                    child: Text("Create new account")),
                TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Get.toNamed('/forgotPassword');
                    },
                    child: Text("Forgot Password")),
                TextButton(
                    onPressed: () {
                      Get.offAllNamed('/ProductsListScreen');
                    },
                    child: Text("Skip login"))
              ],
            );
          }),
        ),
      ),
    );
  }
}
