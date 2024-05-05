import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tech_mastering_api_with_flutter/cache/cache_helper.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/end_point.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/errors/exceptions.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/functions/api_uplode_image.dart';
import 'package:happy_tech_mastering_api_with_flutter/cubit/user_state.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_in_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_up_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.api) : super(UserInitial());

  final ApiConsumer api;
  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey();
  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  //Profile Pic
  XFile? profilePic;
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();
  SignInModel? user;
  uplodeProfilePicture(XFile image) {
    profilePic = image;
    emit(UplodeProfilePicture());
  }

  signIn() async {
    emit(SignInLoading());
    try {
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKey.email: signInEmail.text,
          ApiKey.password: signInPassword.text
        },
      );
      user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user!.token);

      CacheHelper().saveData(key: ApiKey.token, value: user!.token);
      CacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);

      emit(SignInSuccess());
    } on ServerExceptions catch (e) {
      emit(SignInFailure(message: e.errorModel.errorMessage));
    }
  }

  signUp() async {
    emit(SignUpLoading());
    try {
      final resonse = await api.post(
        EndPoint.signUp,
        data: {
          ApiKey.name: signUpName.text,
          ApiKey.phone: signUpPhoneNumber.text,
          ApiKey.email: signUpEmail.text,
          ApiKey.password: signUpPassword.text,
          ApiKey.confirmPassword: signUpPassword.text,
          ApiKey.location:
              '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
        },
        isFromData: true,
      );
      final signUpModel = SignUpModel.fromJson(resonse);
      emit(SignUpSuccess(message: signUpModel.message));
    } on ServerExceptions catch (e) {
      emit(SignUpFailure(message: e.errorModel.errorMessage));
    }
  }

  getUserDate() async {
    emit(GetUserLoading());
    try {
      final response = await api
          .get(EndPoint.getUserData(CacheHelper().getData(key: ApiKey.id)));
      emit(GetUserSuccess(user: UserModel.fromJson(response)));
    } on ServerExceptions catch (e) {
      emit(SignInFailure(message: e.errorModel.errorMessage));
    }
  }
}
