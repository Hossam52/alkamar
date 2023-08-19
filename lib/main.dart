import 'dart:io';

import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc_observer.dart';
import 'constants/constants.dart';
import 'cubits/auth_cubit/auth_cubit.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/app_dio_helper.dart';
import 'shared/presentation/resourses/theme_manager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  HttpOverrides.global = MyHttpOverrides();

  await CacheHelper.init();
  Constants.token = await CacheHelper.getData(key: 'token');
  AppDioHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
  // runApp(IAPTest());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        builder: (_, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(create: (context) => StageCubit()),
          ],
          child: MaterialApp(
            title: 'Al-Kamar',
            builder: (context, child) =>
                Directionality(textDirection: TextDirection.rtl, child: child!),
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(),
            locale: const Locale('ar', 'eg'),
            //           locale: const Locale('ar'),
            // supportedLocales: const [
            //   Locale('ar'),
            //   Locale('en'),
            // ],
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            // ],
            //  ThemeData(
            //     scaffoldBackgroundColor: scaffoldBackgroundColor,
            //     appBarTheme: AppBarTheme(
            //       color: cardColor,
            //     )),

            // home: const ConfirmPhoneScreen(phoneNumber: '+201115425561'),
            // home: _TestScaffold(),
            home: Constants.token != null
                ? const HomeScreen()
                : const OnBoardingScreen(),
          ),
        ),
      ),
    );
  }
}
