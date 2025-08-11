import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/size_config.dart';
import 'package:chickfit/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isStarted = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startAnimation();
    _playAudio();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _playAudio() async {
    try {
      // await _player.setAsset('assets/audio_welcome.mp4');
      // await _player.play();
      // _player.dispose();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      body: BlocListener<AppCubit, AppState>(
          listener: (BuildContext context, state) {
            if (state.status == AuthenticationStatus.unauthenticated) {
              Navigator.pushReplacementNamed(context, MyRouteName.loginPage);
            }
            if (state.status == AuthenticationStatus.aunthenticated) {
              Navigator.pushReplacementNamed(context, MyRouteName.homePage);
            }
          },
          child: Center(
            child: Image.asset(
              "assets/logo_chickfit.png",
              width: SizeConfig.screenWidth / 3,
            ),
          )),
    );
  }

  void startAnimation() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isStarted = true;
        locator<AppCubit>().appStarted();
      });
    });
  }
}
