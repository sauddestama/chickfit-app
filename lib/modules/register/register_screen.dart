import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_fonts.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/utils.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/input_text.dart';
import 'package:chickfit/core/widgets/loading_ring.dart';
import 'package:chickfit/core/widgets/text_label.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen._({Key? key}) : super(key: key);

  static route(RouteSettings settings) {
    return MyPageRouteRightToLeft(
        BlocProvider(
          create: (context) => RegisterCubit(),
          child: const RegisterScreen._(),
        ),
        settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: AssetColors.backgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(child: const _RegisterForm()),
          Positioned(
              top: MediaQuery.of(context).viewPadding.top,
              child: IconButton(
                splashColor: Colors.white,
                color: Colors.white,
                hoverColor: Colors.white,
                focusColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                if (state.userProfile != null) {
                  context.read<AppCubit>().setUserProfile(state.userProfile!);
                }
                Navigator.of(context)
                    .pushReplacementNamed(MyRouteName.homePage);
              }

              if (state.status == RegisterStatus.unauthenticated) {
                if (state.errorMessage != null) {
                  MessageUtil.showErrorSnackBar(state.errorMessage!);
                }
              }
              if (state.status == RegisterStatus.success) {
                MessageUtil.showInfoToast("Registrasi akun berhasil!",
                    infinite: true);
              }
            },
            builder: (context, state) {
              if (state.status == RegisterStatus.loading ||
                  state.status == RegisterStatus.success) {
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
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                label: "Register",
                style: ThemeFonts.h4Bold,
                color: AssetColors.black,
                textAlign: TextAlign.center,
              ),
              Gap.height(18),
              InputText.login(
                "Full Name",
                labelColor: AssetColors.inputLabelColor,
                hint: "Enter full name",
                required: true,
                onSaved: (value) {
                  context.read<RegisterCubit>().setName(value);
                },
                leadingIcon: const Icon(
                  Icons.person,
                  color: AssetColors.inputLabelColor,
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2.5,
              ),
              InputText.login(
                "Email",
                labelColor: AssetColors.inputLabelColor,
                hint: "Email address",
                required: true,
                onSaved: (value) {
                  context.read<RegisterCubit>().setEmail(value);
                },
                leadingIcon: const Icon(
                  Icons.email,
                  color: AssetColors.inputLabelColor,
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2.5,
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return InputText.login(
                    "Password",
                    labelColor: AssetColors.inputLabelColor,
                    hint: "Create password",
                    leadingIcon: const Icon(
                      Icons.lock,
                      color: AssetColors.inputLabelColor,
                    ),
                    onChanged: (value) {
                      context.read<RegisterCubit>().setPassword(value);
                    },
                    required: true,
                    obscure: state.passwordObscure,
                    suffixIcon: InkWell(
                      onTap: () {
                        context.read<RegisterCubit>().toggleShowPassword();
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
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Minimal 6 karakter';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3.5,
              ),
              _buildRegisterBtn(),
              Gap.height(16),
              _buildGoogleLoginBtn(),
              Gap.height(24),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AssetColors.black),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AssetColors.primaryMain,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context)
                              .pushNamed(MyRouteName.loginPage);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      width: double.infinity,
      child: ButtonPrimary(
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<RegisterCubit>().postRegister();
          }
        },
        text: "Register",
      ),
    );
  }

  Widget _buildGoogleLoginBtn() {
    return SizedBox(
      height: 50,
      child: InkPressableBase(
        onTap: () {},
        width: double.infinity,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/google-logo.svg",
              width: 20.ds,
              height: 20.ds,
            ),
            Gap.width(12),
            Text(
              'Registrasi dengan Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AssetColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
