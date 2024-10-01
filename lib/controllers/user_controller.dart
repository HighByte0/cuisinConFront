import 'package:food_delivery_flutter/data/repository/user_repo.dart';
import 'package:food_delivery_flutter/models/response_model.dart';
import 'package:food_delivery_flutter/models/user_info_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({
    required this.userRepo
  });

  bool _isLoaded = false;
  late UserInfoModel _userInfoModel = UserInfoModel(id: 0, name: '', phone: '', orderCount: 0, email: '', autoEntrepreneurNumber: '',); // Initialize with a default instance
  bool get isLoaded => _isLoaded;
  UserInfoModel get userInfoModel => _userInfoModel;

  Future<ResponseModel> getuserinfo() async {
    ResponseModel responseModel;

    Response response = await userRepo.getUserInfo();

    if (response.statusCode == 200) {
  print("Response body: ${response.body}");
  try {
    _userInfoModel = UserInfoModel.fromJson(response.body);
    print("Parsed user info: $_userInfoModel");
    _isLoaded = true;
    responseModel = ResponseModel(true, "successfully");
  } catch (e) {
    print("Error parsing user info: $e");
    responseModel = ResponseModel(false, "Failed to parse user info");
  }
} else {
  print("Failed to retrieve user info: ${response.statusText}");
  responseModel = ResponseModel(false, response.statusText ?? "Unknown error");
}
   update();
    return responseModel;
  }
  }
