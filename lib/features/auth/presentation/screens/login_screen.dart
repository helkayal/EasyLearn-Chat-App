// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/login_cubit.dart';
// import '../cubit/login_states.dart';
// import '../widgets/login_header.dart';
// import '../widgets/login_form.dart';
// import '../widgets/social_login_section.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LoginCubit(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: BlocListener<LoginCubit, LoginState>(
//           listener: (context, state) {
//             if (state is LoginSuccess) {
//               // Navigate to Home/Dashboard
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: const SafeArea(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//               child: Column(
//                 children: [
//                   LoginHeader(),
//                   SizedBox(height: 40),
//                   LoginForm(),
//                   SizedBox(height: 50),
//                   SocialLoginSection(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_row.dart';
import '../widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate to Home/Dashboard
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          child: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  LoginHeader(),
                  SizedBox(height: 40),
                  LoginForm(),
                  SignupRow(),
                  SizedBox(height: 50),
                  SocialLoginSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
