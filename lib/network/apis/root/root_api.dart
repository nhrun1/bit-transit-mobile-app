import 'package:bit_transit/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'root_api.g.dart';

@RestApi()
abstract class RootApi {
  factory RootApi(Dio dio, {String? baseUrl}) = _RootApi;

  @GET('/currency-exchange-rate')
  Future<HttpResponse<bool>> getCurrencyExchangeRate({
    @Header(Constants.isShowLoading) bool? isShowLoading,
  });
}