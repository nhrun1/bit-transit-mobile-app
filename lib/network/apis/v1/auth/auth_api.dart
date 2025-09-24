import 'package:bit_transit/constants/constants.dart';
import 'package:bit_transit/network/models/v1/auth/login/login_request.dart';
import 'package:bit_transit/network/models/v1/auth/login/login_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/login')
  Future<HttpResponse<LoginResponse>> login(
      @Body() LoginRequest request, {
        @Header(Constants.isShowLoading) bool? isShowLoading,
      });
}