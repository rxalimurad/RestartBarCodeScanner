import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:restart_scanner/DBHandler/MongoDbHelper.dart';
import 'package:restart_scanner/ForgotPassword/ForgotPasswordController.dart';

class ForgotPasswordScreen extends StatelessWidget {
  late GSForm form;
  ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
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
                    ]),
              ),
              Obx(() {
                return SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (form.isValid()) {
                        Map<String, dynamic> map = form.onSubmit();
                        controller.isLoading.value = true;
                        var isValidInfo =
                            await MongoDbHelper.verifyRecordExistence(
                                map['email'], map['mobile']);
                        controller.isLoading.value = false;

                        if (isValidInfo) {
                          Get.toNamed('/changePassword',
                              arguments: {'email': map['email']});
                        } else {
                          SnackBar snackBar = SnackBar(
                            content: Text('Record not found'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: controller.isLoading.value
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            height: 30,
                            width: 30,
                          )
                        : Text('Reset Password'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
