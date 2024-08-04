import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/submission_model.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';

class SubmissionState extends ChangeNotifier {
  String _error = "";
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _noteForBrand = "";
  String _caption = "";
  double _amount = 0.0;
  int _campaignId = 0;
  File _postFile = File("");
  List<Asset> _caraouselImages = <Asset>[];
  CampaignSubmissionType _submissionType = CampaignSubmissionType.posts;

  ///`<<<<<========================Getters========================>>>>>`

  String get error => _error;
  bool get isLoading => _isLoading;
  String get noteForBrand => _noteForBrand;
  String get caption => _caption;
  double get amount => _amount;
  File get postFile => _postFile;
  CampaignSubmissionType get submissionType => _submissionType;
  List<Asset> get caraouselImages => _caraouselImages;

  ///`<<<<<========================Functions========================>>>>>`

  void setNoteForBrand(String note) {
    _noteForBrand = note;
    notifyListeners();
  }

  void setCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void setAmountToBePaid(String price) {
    _amount = double.tryParse(price) ?? 0.0;
    print("Amount: $_amount");
    notifyListeners();
  }

  void setPostFile(File postFile, CampaignSubmissionType submissionType) {
    _postFile = postFile;
    _submissionType = submissionType;
    _caraouselImages = [];
    notifyListeners();
  }

  void multipleImages(List<Asset> caraouselImages) {
    _caraouselImages = List<Asset>.from(caraouselImages);
    _postFile = File("");
    _submissionType = CampaignSubmissionType.carousel;
  }

  void setCampaignId(int id) {
    _campaignId = id;
    print("CAMPAIGN ID -> $_campaignId");

    notifyListeners();
  }

  void clearState() {
    _noteForBrand = "";
    _caption = "";
    _amount = 0.0;
    _noteForBrand = "";
    _caption = "";
    _postFile = File("");
    _caraouselImages = <Asset>[];
    _submissionType = CampaignSubmissionType.posts;
    notifyListeners();
  }

  ///`<<<<<========================API calls========================>>>>>`

  Future<void> submitSubmission(
      CampaignSocialType accountType, dynamic selectedAccount) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();

      print("CAMPAINGGGGG -> $_campaignId");

      int? accountId;
      List<dynamic> files = [];

      switch (accountType) {
        case CampaignSocialType.instagram:
          accountId = selectedAccount.instagramId;
          switch (_submissionType) {
            case CampaignSubmissionType.posts:
              files.add(_postFile);
              break;
            case CampaignSubmissionType.carousel:
              files = List.from(_caraouselImages);
              break;
            case CampaignSubmissionType.stories:
              files.add(_postFile);
              break;
          }
          break;
        case CampaignSocialType.facebook:
          accountId = selectedAccount.pageId;
          files.add(_postFile);
          break;
        case CampaignSocialType.twitter:
          accountId = selectedAccount.userId;
          files.add(_postFile);
          break;
      }
      final submissionModel = SubmissionModel(
        accountId: accountId,
        caption: _caption,
        accountType: accountType,
        campaignId: _campaignId,
        notes: _noteForBrand,
        submissionType: _submissionType,
      );
      final response = await gateway.submitSubmission(
        submissionModel,
        files,
      );
      if (response) {
        print("YAYAY");
      } else {
        _error =
            "We are not able to process submission right now. Please try again in sometime.";
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SubmissionState-submitSubmission", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = "Sorry! Your Submission failed. Pleae try again later.";
      log(error.toString(),
          name: "SubmissionState-submitSubmission", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }
}
