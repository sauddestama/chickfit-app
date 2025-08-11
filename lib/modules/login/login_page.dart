import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_fonts.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/utils.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/input_text.dart';
import 'package:chickfit/core/widgets/loading_ring.dart';
import 'package:chickfit/core/widgets/text_label.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._({Key? key}) : super(key: key);

  static route(settings) {
    return MyPageRoute(
        BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginPage._(),
        ),
        settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AssetColors.backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(child: const _LoginForm()),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.authenticated) {
                    if (state.userProfile != null) {
                      context
                          .read<AppCubit>()
                          .setUserProfile(state.userProfile!);
                    }
                    Navigator.of(context)
                        .pushReplacementNamed(MyRouteName.homePage);
                  }

                  if (state.status == LoginStatus.unauthenticated) {
                    if (state.errorMessage != null) {
                      MessageUtil.showErrorSnackBar(state.errorMessage!);
                    }
                  }
                  if (state.status == LoginStatus.authenticated) {
                    MessageUtil.showInfoToast("Login Berhasil");
                  }
                },
                builder: (context, state) {
                  if (state.status == LoginStatus.loading ||
                      state.status == LoginStatus.authenticated) {
                    return Container(
                      color: Colors.black12.withOpacity(0.8),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: const SpinKitRing(
                        color: AssetColors.colorPrimaryShades,
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Gap.height(24),
            Center(
              child: Image.asset(
                "assets/logo_chickfit.png",
                width: SizeConfig.screenWidth / 4,
              ),
            ),
            Gap.height(52),
            TextLabel(
              label: "Login",
              style: ThemeFonts.h4Bold,
              color: AssetColors.black,
              textAlign: TextAlign.center,
            ),
            Gap.height(18),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return InputText.login(
                  "Email",
                  labelColor: AssetColors.inputLabelColor,
                  hint: "Email address",
                  required: true,
                  onSaved: (value) {
                    context.read<LoginCubit>().setUsername(value);
                  },
                  leadingIcon: const Icon(
                    Icons.mail,
                    color: AssetColors.inputLabelColor,
                  ),
                  errorMessage: state.displayErrorText,
                );
              },
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2.5,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return InputText.login(
                  "Password",
                  labelColor: AssetColors.inputLabelColor,
                  hint: "Password",
                  leadingIcon: const Icon(
                    Icons.lock,
                    color: AssetColors.inputLabelColor,
                  ),
                  onSaved: (value) {
                    context.read<LoginCubit>().setPassword(value);
                  },
                  suffixIcon: InkWell(
                    onTap: () {
                      context.read<LoginCubit>().toggleShowPassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        state.passwordObscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility,
                        color: AssetColors.colorPrimary,
                      ),
                    ),
                  ),
                  required: true,
                  obscure: state.passwordObscure,
                  errorMessage: state.displayErrorText,
                );
              },
            ),
            _buildForgotPasswordBtn(),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            _buildLoginBtn(),
            Gap.height(16),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AssetColors.black),
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AssetColors.primaryMain,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context)
                            .pushNamed(MyRouteName.registerPage);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot password',
          style: TextStyle(fontSize: 12, color: AssetColors.primaryMain),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    final deviceUUID = context.read<AppCubit>().state.deviceUUID;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: ButtonPrimary(
        onPressed: () {
          // Navigator.of(context).pushNamed(MyRouteName.homePage);
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<LoginCubit>().postLogin(deviceUUID ?? "");
          }
        },
        text: "Login",
      ),
    );
  }

/*
  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            )),
        onPressed: () {
          assert(_formKey.currentState != null);
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<LoginCubit>().postLogin();
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Login',
            style: TextStyle(
              color: Color(0xFF5A5959),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
*/
}

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF525E5E),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
