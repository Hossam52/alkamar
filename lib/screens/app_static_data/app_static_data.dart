import 'package:flutter/material.dart';

import 'package:alqamar/screens/app_static_data/widgets/base_app_static_data.dart';
import 'package:alqamar/shared/presentation/resourses/strings_manager.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseAppStaticData(
      title: 'About app',
      content: AppStrings.aboutApp,
    );
  }
}
