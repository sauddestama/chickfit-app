import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/base_repository.dart';
import 'package:chickfit/data/source/network/requests/start_consult_request.dart';
import 'package:chickfit/data/source/network/responses/base.dart';
import 'package:chickfit/data/source/network/responses/get_consul_messages_response.dart';
import 'package:chickfit/data/source/network/responses/get_consultations_response.dart';
import 'package:chickfit/data/source/network/responses/get_resep_response.dart';
import 'package:chickfit/data/source/network/responses/post_consul_message_request.dart';
import 'package:chickfit/data/source/network/responses/post_consul_message_response.dart';
import 'package:chickfit/data/source/network/responses/post_request_prescription.dart';
import 'package:chickfit/data/source/network/responses/reset_detail_response.dart';
import 'package:chickfit/data/source/network/responses/start_consult_response.dart';
import 'package:chickfit/models/base.dart';
import 'package:dio/dio.dart';

class ConsultationRepository extends BaseRepository {
  ConsultationRepository({
    required super.apiClient,
    required super.localDataSource,
  });

  Future<BaseDTOModel<List<ConsultationItemResponse>>>
      getConsultations() async {
    List<ConsultationItemResponse>? data;
    String? message;
    try {
      BaseObjectResponse<GetConsultationsResponse> response =
          await apiClient.getConsultations();
      if (response.success) {
        data = response.data?.consultations;
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<List<PrescriptionItemResponse>>> getPrescription(
      String userId) async {
    List<PrescriptionItemResponse>? data;
    String? message;
    try {
      BaseObjectResponse<GetResepsResponse> response =
          await apiClient.getPrescription(userId);

      if (response.success) {
        data = response.data?.prescriptions;
        // data = [
        //   PrescriptionItemResponse.fromJson(	{
        //     "id": 1,
        //     "medicine": "Amoxicillin 500mg",
        //     "usage_instructions": "Take 1 tablet twice daily for 7 days",
        //     "notes": "Monitor chicken for improvement. Contact if symptoms persist.",
        //     "status": "approved",
        //     "created_at": "2025-08-09T08:54:45.000Z",
        //     "diagnosis_label": "Coccidiosis",
        //     "doctor_name": "drh. Sarah"
        //   })
        // ];
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<bool>> requestPrescription(int diagnosisId) async {
    bool data;
    String? message;
    try {
      BaseObjectResponse response = await apiClient.requestPrescription(
          PostRequestPrescription(diagnosisId: diagnosisId));
      if (response.success) {
        data = true;
        // data = [
        //   PrescriptionItemResponse.fromJson(	{
        //     "id": 1,
        //     "medicine": "Amoxicillin 500mg",
        //     "usage_instructions": "Take 1 tablet twice daily for 7 days",
        //     "notes": "Monitor chicken for improvement. Contact if symptoms persist.",
        //     "status": "approved",
        //     "created_at": "2025-08-09T08:54:45.000Z",
        //     "diagnosis_label": "Coccidiosis",
        //     "doctor_name": "drh. Sarah"
        //   })
        // ];
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<ResepDetailResponse>> getResepDetail(int resepId) async {
    ResepDetailResponse? data;
    String? message;
    try {
      BaseObjectResponse<ResepDetailResponse> response =
          await apiClient.getResepDetail(resepId);
      if (response.success) {
        data = response.data!;
        // data = [
        //   PrescriptionItemResponse.fromJson(	{
        //     "id": 1,
        //     "medicine": "Amoxicillin 500mg",
        //     "usage_instructions": "Take 1 tablet twice daily for 7 days",
        //     "notes": "Monitor chicken for improvement. Contact if symptoms persist.",
        //     "status": "approved",
        //     "created_at": "2025-08-09T08:54:45.000Z",
        //     "diagnosis_label": "Coccidiosis",
        //     "doctor_name": "drh. Sarah"
        //   })
        // ];
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<StartConsultResponse>> startConsultation(
      int veterinarianId) async {
    StartConsultResponse? data;
    String? message;
    try {
      BaseObjectResponse<StartConsultResponse> response =
          await apiClient.startConsultation(
              StartConsultRequest(veterinarianId: veterinarianId));
      if (response.success) {
        data = response.data;
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<List<ConsulMessage>>> getConsulMessage(
      int consultationId) async {
    List<ConsulMessage>? data;
    String? message;
    try {
      BaseObjectResponse<GetConsultationMessagesResponse> response =
          await apiClient.getConsulMessage(consultationId.toString());
      if (response.success) {
        data = response.data?.messages ?? [];
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<ConsulMessage>> postConsulMessage(
    int consultationId,
    String consultMsg,
  ) async {
    ConsulMessage? data;
    String? message;
    try {
      BaseObjectResponse<PostConsultationMessagesResponse> response =
          await apiClient.postConsulMessage(
              consultationId.toString(),
              PostConsulMessageRequest(
                message: consultMsg,
              ));
      if (response.success) {
        data = response.data?.message;
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }
}
