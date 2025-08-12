import 'dart:io';

import 'package:alice/alice.dart';
import 'package:chickfit/data/source/network/requests/change_password_request.dart';
import 'package:chickfit/data/source/network/requests/login_request.dart';
import 'package:chickfit/data/source/network/requests/register_request.dart';
import 'package:chickfit/data/source/network/requests/start_consult_request.dart';
import 'package:chickfit/data/source/network/responses/diagnose_result_response.dart';
import 'package:chickfit/data/source/network/responses/get_article_response.dart';
import 'package:chickfit/data/source/network/responses/get_consul_messages_response.dart';
import 'package:chickfit/data/source/network/responses/get_consultations_response.dart';
import 'package:chickfit/data/source/network/responses/get_detail_article_response.dart';
import 'package:chickfit/data/source/network/responses/get_diagnose_histories_response.dart';
import 'package:chickfit/data/source/network/responses/get_resep_response.dart';
import 'package:chickfit/data/source/network/responses/post_consul_message_request.dart';
import 'package:chickfit/data/source/network/responses/post_consul_message_response.dart';
import 'package:chickfit/data/source/network/responses/post_request_presciption_response.dart';
import 'package:chickfit/data/source/network/responses/post_request_prescription.dart';
import 'package:chickfit/data/source/network/responses/post_update_profile_picture_response.dart';
import 'package:chickfit/data/source/network/responses/reset_detail_response.dart';
import 'package:chickfit/data/source/network/responses/responses.dart';
import 'package:chickfit/data/source/network/responses/start_consult_response.dart';
import 'package:chickfit/data/source/network/responses/veterinarian_response.dart';
import 'package:chickfit/data/source/network/services/api_interceptor.dart';
import 'package:chickfit/locator.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi() // dev server
abstract class ApiService {
  factory ApiService(Dio dio) {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(locator<Alice>().getDioInterceptor());

    return _ApiService(
      dio,
    );
  }

  // ========================= Start Auth Endpoint =========================
  @POST('/api/auth/login')
  Future<BaseObjectResponse<LoginResponseData>> login(
      @Body() LoginRequest loginPayload);

  @POST('/api/auth/register')
  Future<BaseObjectResponse<LoginResponseData>> register(
      @Body() RegisterRequest registerPayload);

  @GET('/api/users/veterinarians')
  Future<BaseObjectResponse<GetVeterinarianResponse>> getVeterinarian();

  @GET('/api/auth/profile')
  Future<BaseObjectResponse<LoginResponseData>> getUserData();

  @GET('/api/articles')
  Future<BaseObjectResponse<GetArticleResponse>> getPublishedArticle();

  @GET('/api/articles/{articleId}')
  Future<BaseObjectResponse<GetDetailArticleResponse>> getDetailArticle(
      @Path("articleId") int articleId);

  @GET('/api/diagnoses/history/{userId}')
  Future<BaseObjectResponse<GetDiagnoseHistoriesResponse>>
      getDiagnoseHistories({
    @Path("userId") required String userId,
  });

  @POST('/api/auth/change-password')
  Future<BaseObjectResponse> updatePassword(
      @Body() ChangePasswordRequest registerPayload);

  @POST('/api/auth/logout')
  Future<BaseObjectResponse> logout();

  @POST("/api/images/upload")
  Future<BaseObjectResponse<DiagnoseResultResponse>> postDiagnose(
      @Part(name: "image", contentType: 'image/jpeg') File image);

  @POST("/api/users/profile-picture")
  Future<BaseObjectResponse<PostUpdateProfilePictureResponse>>
      postUpdateProfilePicture(
    @Part(name: "avatar", contentType: 'image/jpeg') File avatar,
  );

  @GET("/api/consultations")
  Future<BaseObjectResponse<GetConsultationsResponse>> getConsultations();

  @GET("/api/prescriptions/{userId}")
  Future<BaseObjectResponse<GetResepsResponse>> getPrescription(
    @Path("userId") String userId,
  );

  @POST("/api/prescriptions/request")
  Future<BaseObjectResponse<PostRequestPrescriptionResponse>>
      requestPrescription(
    @Body() PostRequestPrescription request,
  );

  @POST("/api/consultations")
  Future<BaseObjectResponse<StartConsultResponse>> startConsultation(
      @Body() StartConsultRequest request);

  @GET("/api/consultations/{consultationId}/messages")
  Future<BaseObjectResponse<GetConsultationMessagesResponse>> getConsulMessage(
      @Path() String consultationId);

  @GET("/api/prescriptions/detail/{prescriptionId}")
  Future<BaseObjectResponse<ResepDetailResponse>> getResepDetail(
      @Path("prescriptionId") int prescriptionId);

  @GET("/api/diagnoses/{id}")
  Future<BaseObjectResponse<DiagnoseResultResponse>> getDiagnoseResultDetail(
      @Path("id") int diagnoseId);

  @POST("/api/consultations/{consultationId}/messages")
  Future<BaseObjectResponse<PostConsultationMessagesResponse>>
      postConsulMessage(@Path() String consultationId,
          @Body() PostConsulMessageRequest request);
}
