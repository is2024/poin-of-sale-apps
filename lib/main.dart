import 'package:flutter/material.dart';
import 'package:flutter_pos_apps/core/constants/colors.dart';
import 'package:flutter_pos_apps/data/datasources/auth_local_remote_datasource.dart';
import 'package:flutter_pos_apps/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_pos_apps/presentation/auth/bloc/login/login_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'presentation/auth/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/home/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              color: AppColors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              iconTheme: const IconThemeData(
                color: AppColors.primary,
              ),
            )),
        home: FutureBuilder<bool>(
            future: AuthLocalRemoteDatasource().isAuthDataExist(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const DashboardPage();
                } else {
                  return const LoginPage();
                }
              }
              return const Scaffold(
                body: Center(
                  child: Text('Error'),
                ),
              );
            }),
      ),
    );
  }
}
