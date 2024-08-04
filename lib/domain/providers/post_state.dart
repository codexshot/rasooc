import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/models/content_campaigns_model.dart';
import 'package:rasooc/domain/models/content_rights_model.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';

class PostState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _error = "";
  List<PostSubmissionsModel> _listOfSubmissions = <PostSubmissionsModel>[];
  List<ContentRightsModel> _listOfContentRights = <ContentRightsModel>[];
  List<ContentCampaignsModel> _listOfContentCampaigns =
      <ContentCampaignsModel>[];

  List<CampaignShortModel> _listOfInfluencerCampaignsStatus =
      <CampaignShortModel>[];

  ///`<<<<<========================Getters========================>>>>>`
  bool get isLoading => _isLoading;
  String get error => _error;
  List<PostSubmissionsModel> get listOfSubmissions => _listOfSubmissions;
  List<ContentRightsModel> get listOfContentRights => _listOfContentRights;
  List<ContentCampaignsModel> get listOfContentCampaigns =>
      _listOfContentCampaigns;
  List<CampaignShortModel> get listOfInfluencerCampaignsStatus =>
      _listOfInfluencerCampaignsStatus;

  ///`<<<<<========================API calls========================>>>>>`
  Future<void> getSubmissionList(SubmissionStatus status) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      _listOfSubmissions.clear();
      final list = await gateway.getSubmissionList(status);
      if (list.isNotEmpty) {
        _listOfSubmissions = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PostSubmissionsModel> getSubmissionDetail(int submissionId) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final model = await gateway.getSubmissionDetail(submissionId);
      _isLoading = false;
      notifyListeners();
      return model;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-getSubmissionDetail", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return PostSubmissionsModel();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-getSubmissionDetail", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return PostSubmissionsModel();
    }
  }

  Future<bool> withdrawSubmission(int submissionId) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();

      final success = await gateway.withdrawSubmission(submissionId);
      _isLoading = false;
      notifyListeners();
      if (success) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-withdrawSubmission", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-withdrawSubmission", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> publishSingleMedia(PostSubmissionsModel submissionsModel) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final success = await gateway.publishSingleMedia(submissionsModel);
      _isLoading = false;
      notifyListeners();
      if (success) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-publishSingleMedia", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-publishSingleMedia", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> publishStoryAndCarousel(
      String url, PostSubmissionsModel submissionsModel) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final success =
          await gateway.publishStoryAndCarousel(url, submissionsModel);
      _isLoading = false;
      notifyListeners();
      if (success) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-publishStoryAndCarousel", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-publishStoryAndCarousel", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> publishToTwitter(PostSubmissionsModel submissionsModel) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final success = await gateway.publishToTwitter(submissionsModel);
      _isLoading = false;
      notifyListeners();
      if (success) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-publishToTwitter", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-publishToTwitter", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getContentRights(ContentStatus status) async {
    try {
      _error = "";
      _isLoading = true;
      _listOfContentRights.clear();
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getContentRights(status);
      if (list.isNotEmpty) {
        _listOfContentRights = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-getContentRights", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-getContentRights", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> contentRightDecision(int id, ContentDecision status) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final model = await gateway.contentRightDecision(id, status);
      _isLoading = false;
      notifyListeners();
      if (model.id != null) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-contentRightDecision", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-contentRightDecision", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getContentCampaigns(ContentStatus status) async {
    try {
      _error = "";
      _isLoading = true;
      _listOfContentCampaigns.clear();
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getContentCampaign(status);
      if (list.isNotEmpty) {
        _listOfContentCampaigns = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-getContentCampaigns", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-getContentCampaigns", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> contentCampaignDecision(int id, ContentDecision status) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final model = await gateway.contentCampaignDecision(id, status);
      _isLoading = false;
      notifyListeners();
      if (model.id != null) {
        return true;
      } else {
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-contentCampaignDecision", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-contentCampaignDecision", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getInfluencerCampaignStatus(CampaignStatus status,
      {int pageId = 1}) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getInfluencerCampaigns(status, pageId: pageId);

      _listOfInfluencerCampaignsStatus = [...list];

      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-getInfluencerCampaignStatus",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-getInfluencerCampaignStatus",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> withdrawInfluencerCampaign(int campaignId) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();

      final isWithdrawn = await gateway.withdrawInfluencerCampaign(campaignId);
      if (isWithdrawn) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "PostState-withdrawInfluencerCampaign", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "PostState-withdrawInfluencerCampaign", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
