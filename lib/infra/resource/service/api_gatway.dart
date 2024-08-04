import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/access_token_model.dart';
import 'package:rasooc/domain/models/account_response_model.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/models/chat_model.dart';
import 'package:rasooc/domain/models/content_campaigns_model.dart';
import 'package:rasooc/domain/models/content_rights_model.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/models/notifications_model.dart';
import 'package:rasooc/domain/models/page_model.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/models/profile_model.dart';
import 'package:rasooc/domain/models/location_response_model.dart';
import 'package:rasooc/domain/models/social_accounts_model.dart';
import 'package:rasooc/domain/models/submission_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';

abstract class ApiGateway {
  Future<dynamic> fbLoginUser();
  Future<bool> logoutUser();
  Future<bool> addInstaAccount();
  Future<AccessTokenModel> checkAccessTokenStatus();
  Future<List<CategoryModel>> getCampaginCategoires();
  Future<AccountResponseModel> createUserAccount(ProfileModel model);
  Future<ProfileModel> getUserProfile();
  Future<List<CampaignShortModel>> getCampaigns(
      int type, List<int> categoryIds, int limit);
  Future<CampaignDetailModel> getCampaignDetail(int campaignId);
  Future<List<CampaignShortModel>> searchCampaigns(String query);
  Future<ProfileModel> checkUserExistUsingFBID(int fbId, String? fbAccessToken);
  Future<CampaignShortModel> favoriteCampgain(bool isFav, int campaignId);
  Future<ProfileModel> updateUserProfile(ProfileModel model);
  Future<List<FacebookPageAccount>> linkFacebookPages();
  Future<InstaAccount> linkInstagramAccount();
  Future<TwitterAccount> linkTwitterAccount();
  Future<void> getFBPageDetails(PageModel pageModel);
  Future<SocialAccountsModel> getConnectedAccounts();
  Future<SocialAccountsModel> removeConnectedAccount(int id, String provider);
  Future<bool> submitSubmission(
      SubmissionModel submissionModel, List<dynamic> files);
  Future<List<PostSubmissionsModel>> getSubmissionList(SubmissionStatus status);
  Future<bool> withdrawSubmission(int id);
  Future<bool> publishSingleMedia(PostSubmissionsModel submissionsModel);
  Future<List<ContentRightsModel>> getContentRights(ContentStatus status);
  Future<ContentRightsModel> contentRightDecision(
      int id, ContentDecision status);
  Future<List<ContentCampaignsModel>> getContentCampaign(ContentStatus status);
  Future<ContentCampaignsModel> contentCampaignDecision(
      int id, ContentDecision status);
  Future<List<ChatModel>> postComment(int submissionId, String message);
  Future<List<ChatModel>> getSubmissionComments(int submissionId);
  Future<List<ChatModel>> getInfluencerChats();
  Future<List<ChatModel>> sendInfluencerChat(String message);
  Future<List<NotificationsModel>> getNotifications();
  Future<bool> publishToTwitter(PostSubmissionsModel postSubmissionsModel);
  Future<PostSubmissionsModel> getSubmissionDetail(int submissionId);
  Future<bool> clearNotification(
      NotificationDecision notificationDecision, int id);
  Future<bool> publishStoryAndCarousel(String url, PostSubmissionsModel model);
  Future<bool> applyToCampaign(int campaignId);
  Future<List<CampaignShortModel>> getInfluencerCampaigns(CampaignStatus status,
      {int pageId = 1});
  Future<bool> withdrawInfluencerCampaign(int campaignId);
  Future<bool> goDaddyWhitelistIp();
  Future<List<GeographicEntity>> getCountries();
  Future<List<GeographicEntity>> getStates(int countryId);
  Future<List<GeographicEntity>> getCities(int stateId);
}
