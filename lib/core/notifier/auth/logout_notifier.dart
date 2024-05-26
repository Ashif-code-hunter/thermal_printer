import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants.dart';


class LogoutNotifier extends ChangeNotifier {

  // final LogoutApi _logoutNotifierApi = LogoutApi();
  bool _isLoading = false;


  bool get getIsLoading => _isLoading;




  Future<void> logout({
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      // final listData = await _logoutNotifierApi.logoutApi();
      if(true){
        _isLoading = false;
        notifyListeners();
      }else{
        // showAwesomeDialogue(title: "Warning", content: "Please try again later", type: DialogType.WARNING);
      }
      _isLoading = false;
      notifyListeners();
    } catch(error){
      // showAwesomeDialogue(title: "Error", content: "Please try again later", type: DialogType.ERROR);
      // showAwesomeDialogue(title: "Error", content: "Please log out and login again", type: DialogType.ERROR);
      showAwesomeDialogue(title: "Error", content: "Please log out and login again", type: DialogType.error);

      print("eroor $error");
      _isLoading = false;
      notifyListeners();
    }
  }
}