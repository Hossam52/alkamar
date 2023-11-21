import 'package:alqamar/widgets/text_widget.dart';

import '../auth/login_screen.dart';

import '../../shared/presentation/resourses/color_manager.dart';
import '../../shared/presentation/resourses/font_manager.dart';
import '../../shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                    child: Image.asset(
                  'assets/images/alkamar.png',
                  width: width * 0.55,
                  height: width * 0.6,
                  fit: BoxFit.fill,
                )),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: TextWidget(
                          label: 'مرحبا بك في منظومة القمر التعليمية',
                          color: ColorManager.primary,
                          fontSize: FontSize.s17,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: TextWidget(
                                textAlign: TextAlign.center,
                                label:
                                    '''الحضور والانصراف والدرجات للطلاب أصبح سهلا بضغطة زر واحدة تستطيع عمل الكثير''',
                                color: ColorManager.primary,
                                fontSize: FontSize.s16),
                          ),
                        ],
                      )),
                    ],
                  )),
              SizedBox(
                  height: 45.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Container(
                        color: ColorManager.highlight.withOpacity(0.7),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Expanded(
                            //   child: ElevatedButton(
                            //     style: ButtonStyle(
                            //         backgroundColor: MaterialStatePropertyAll(
                            //             ColorManager.accentColor)),
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const RegisterScreen()));
                            //     },
                            //     child: Text(
                            //       'تسجيل حساب جديد',
                            //       style:
                            //           getBoldStyle(color: ColorManager.white),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        ColorManager.accentColor),
                                    elevation:
                                        const MaterialStatePropertyAll(0)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style:
                                      getBoldStyle(color: ColorManager.primary),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
