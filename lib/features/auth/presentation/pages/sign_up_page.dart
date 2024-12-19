import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController =
      TextEditingController(text: "ahmed");

  final TextEditingController lastNameController =
      TextEditingController(text: "fathy zain");

  final TextEditingController emailController =
      TextEditingController(text: "ahmedr@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "ahmed1998");

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle success and failure states
          switch (state) {
            case AuthConfirmationCodeSent():
              Navigator.pushNamed(context, '/confirm', arguments: {
                'email': emailController.text,
                'password': passwordController.text,
              });
            case AuthFailure():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'وَمِنْ آَيَاتِهَ أَنْ خَلَقَ لَكُمْ مِنْ أَنْفُسِكُمْ أَزْوَاجَاً لِتَسْكُنُواْ إِلَيْهَا وَجَعَلَ بَيْنَكُمْ مَوَدَةً وَرَحْمَةً إِن فِي ذَلِكَ لَآَيَاتٍ لِقَوْمٍ يَتَفَكَرُونَ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Image.asset(
                      'assets/images/3demail_icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Column(
                    children: [
                      CustomTextField(
                        controller: firstNameController,
                        hintText: 'الاسم الأول',
                        keyboardType: TextInputType.name,
                        prefixIcon: Image.asset(
                          'assets/images/profile_icon.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: lastNameController,
                        hintText: 'اسم الوالد والجد',
                        keyboardType: TextInputType.name,
                        prefixIcon: Image.asset(
                          'assets/images/parents_names.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        preIconPadding: 11,
                        prefixIcon: Image.asset(
                          'assets/images/email_icon.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'كلمة السر',
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Image.asset(
                          'assets/images/shield_icon.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            _obscureText
                                ? 'assets/images/visibility_off.png' // Eye icon for hidden password
                                : 'assets/images/visibility_on.png',
                            // Eye icon for visible password
                            // Eye icon for visibility toggle
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            // Toggle visibility logic here
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Toggle the visibility
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          switch (state) {
                            case AuthLoading():
                              return ExpandingCircleProgress();
                          }
                          return CustomButton(
                            text: 'تسجيل حساب جديد',
                            icon: 'assets/images/signup_icon.png',
                            iconBackgroundColor: Colors.white,
                            onPressed: () {
                              // Dispatch the sign-up event with user input data
                              BlocProvider.of<AuthBloc>(context).add(
                                SignUpEvent(
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Text(
                        "هل لديك حساب بالفعل ؟",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          // Remove padding
                          minimumSize: Size.zero,
                          // Remove the minimum size (if any)
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // Shrink the tap target size
                        ),
                        onPressed: () {
                          // Navigate to the reset password page
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text(
                          "قم بتسجيل الدخول",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
