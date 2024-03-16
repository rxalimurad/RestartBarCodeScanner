import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:restart_scanner/DBHandler/MongoDbHelper.dart';
import 'package:restart_scanner/SignupScreen/SignUpScreenController.dart';

class SignupScreen extends StatelessWidget {
  late GSForm form;
  SignupScreenController signupController = Get.put(SignupScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Account'),
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
                          hint: 'First Name',
                          tag: 'fname',
                          title: 'First Name',
                          weight: 90,
                          errorMessage: 'Please enter a valid first name',
                          required: true,
                          minLine: 1,
                          maxLine: 1,
                        ),
                        GSField.text(
                          value: '',
                          hint: 'Last Name',
                          tag: 'lname',
                          title: 'Last Name',
                          errorMessage: 'Please enter a valid last name',
                          required: true,
                          minLine: 1,
                          maxLine: 1,
                        ),
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
                        GSField.mobile(
                          value: '',
                          hint: 'Mobile',
                          maxLength: 20,
                          tag: 'mobile',
                          title: 'Mobile',
                          errorMessage: 'Please enter a valid mobile number',
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
                        GSField.password(
                          value: '',
                          hint: 'Confirm Password',
                          tag: 'cpassword',
                          validateReg: RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                          ),
                          errorMessage:
                              'Password must contain at least 8 characters, including letters and numbers',
                          title: 'Confirm Password',
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
                        print('Signup form is valid');
                        Map<String, dynamic> map = form.onSubmit();
                        var name = map['fname'] + ' ' + map['lname'];
                        var email = map['email'];
                        var phoneNumber = map['mobile'];
                        var password = map['password'];
                        var confirmPassword = map['cpassword'];
                        if (password != confirmPassword) {
                          SnackBar snackBar = SnackBar(
                            content:
                                Text('Password and confirm password not match'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        signupController.isLoading.value = true;
                        LoginResponseStatus status =
                            await MongoDbHelper.createrUser(
                                name, email, phoneNumber, password);
                        signupController.isLoading.value = false;
                        switch (status) {
                          case LoginResponseStatus.userNotExist:
                            break;
                          case LoginResponseStatus.passwordNotCorrect:
                            break;
                          case LoginResponseStatus.success:
                            SnackBar snackBar = SnackBar(
                              content: Text('User created successfully'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Get.back();
                            // form./
                            break;
                          case LoginResponseStatus.alreadyExist:
                            SnackBar snackBar = SnackBar(
                              content:
                                  Text('Email already exist, please login.'),
                            );
                            Get.back();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            break;
                          case LoginResponseStatus.error:
                            SnackBar snackBar = SnackBar(
                              content: Text('Failed to create user'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            break;
                          case LoginResponseStatus.userNotExist:
                          // TODO: Handle this case.
                        }
                      } else {
                        print('Form is invalid');
                      }
                    },
                    child: signupController.isLoading.value
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            height: 30,
                            width: 30,
                          )
                        : Text('Create'),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Get.back();
                    },
                    child: Text("Already have an account? Login here")),
              ],
            );
          }),
        ),
      ),
    );
  }
}
