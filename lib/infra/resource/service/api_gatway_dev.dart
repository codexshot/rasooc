import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rasooc/domain/helper/constants.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/secrets.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/access_token_model.dart';
import 'package:rasooc/domain/models/account_response_model.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/models/chat_model.dart';
import 'package:rasooc/domain/models/content_campaigns_model.dart';
import 'package:rasooc/domain/models/content_rights_model.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/models/insta_link_response_model.dart';
import 'package:rasooc/domain/models/location_response_model.dart';
import 'package:rasooc/domain/models/notifications_model.dart';
import 'package:rasooc/domain/models/page_model.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/models/profile_model.dart';
import 'package:rasooc/domain/models/social_accounts_model.dart';
import 'package:rasooc/domain/models/submission_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/infra/resource/dio_client.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class ApiGatewayDev implements ApiGateway {
  final DioClient _dioClient;

  ApiGatewayDev(this._dioClient);

  @override
  Future<dynamic> fbLoginUser() async {
    try {
      final facebookLogin = FacebookLogin();
      final pref = GetIt.instance<SharedPreferenceHelper>();

      final facebookLoginResult = await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        // FacebookPermission.userPhotos,
        // FacebookPermission.userGender,
        // FacebookPermission.userHometown,
        // FacebookPermission.userBirthday,
      ]);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          throw "Error ";

        case FacebookLoginStatus.cancel:
          throw "Action Cancelled by user ";

        case FacebookLoginStatus.success:
          final String shortToken = facebookLoginResult.accessToken!.token;

          final exchangeResponse = await _dioClient.get(
              '${Constants.facebookBaseURL}v2.12/oauth/access_token?grant_type=fb_exchange_token&client_id=${Secrets.appId}&client_secret=${Secrets.appSecret}&fb_exchange_token=$shortToken');

          final longLivedToken = exchangeResponse.data["access_token"];

          final graphResponse = await _dioClient.get(
              '${Constants.facebookBaseURL}v2.12/me?fields=name,first_name,last_name,email,birthday,hometown,gender,picture.type(large)&access_token=$longLivedToken');

          final response = json.decode(graphResponse.data);

          //
          final ProfileModel profileModel = ProfileModel.fromFacebook(response)
              .copyWith(fbAccessToken: longLivedToken);

          //Setting to Shared pref
          await pref.setFBToken(longLivedToken);
          await pref.setFBUserId(profileModel.fbUserId!);

          print("SUPER TOKEN : ${profileModel.fbAccessToken}");
          print("ID: ${profileModel.fbUserId}");

          return profileModel;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logoutUser() async {
    try {
      final facebookLogin = FacebookLogin();
      await facebookLogin.logOut();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccessTokenModel> checkAccessTokenStatus() async {
    try {
      final token = await GetIt.instance<SharedPreferenceHelper>().getFBToken();
      final graphResponse = await _dioClient.get(
          '${Constants.facebookBaseURL}debug_token?input_token=$token&access_token=$token');

      final response = json.decode(graphResponse.data);
      final AccessTokenModel accessTokenModel =
          AccessTokenModel.fromJson(response);
      print(accessTokenModel.data);
      return accessTokenModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addInstaAccount() async {
    try {
      final response = await _dioClient.get(
        "https://api.instagram.com/oauth/authorize?client_id=${Secrets.clientId}&redirect_uri=${Constants.instaAuthUrl}/auth?scope=user_profile,user_media?response_type=code",
      );
      print(response);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<LocationResponseModel> getLocations() async {
  //   try {
  //     final response =
  //         await _dioClient.get(Constants.rasoocDevUrl + Constants.location);
  //     final json = _dioClient.getJsonBody(response);
  //     final model = LocationResponseModel.fromJson(json);
  //     return model;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<List<CategoryModel>> getCampaginCategoires() async {
    try {
      final List<CategoryModel> list = [];
      final response = await _dioClient
          .get(Constants.rasoocDevUrl + Constants.campaignCategories);
      final json = _dioClient.getJsonBody(response);
      if (json["data"] != null && json["data"].isNotEmpty) {
        json["data"].forEach((element) {
          list.add(CategoryModel.fromJson(element));
        });
      }

      final pref = GetIt.instance<SharedPreferenceHelper>();
      await pref.setCategories(list);

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccountResponseModel> createUserAccount(ProfileModel model) async {
    try {
      final data = model.toBackendJson();
      AccountResponseModel accountResponseModel;
      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.createAccount,
        data: data,
      );
      final json = _dioClient.getJsonBody(response);
      if (json["error"] != null) {
        accountResponseModel = AccountResponseModel(
          accessToken: "",
          error: json["error"],
        );
      } else {
        accountResponseModel = AccountResponseModel.fromJson(json);
      }

      return accountResponseModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> getUserProfile() async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      // print("TOKEN: $token");

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getProfile,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final json = _dioClient.getJsonBody(response);

      final profile = ProfileModel.fromBackendJson(json["data"]);
      return profile;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CampaignShortModel>> getCampaigns(
      int type, List<int> categoryIds, int limit) async {
    try {
      final List<CampaignShortModel> list = [];
      final data = {"type": type, "category": categoryIds, "page": limit};

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response =
          await _dioClient.post(Constants.rasoocDevUrl + Constants.getCampagins,
              data: data,
              options: Options(
                headers: headers,
              ));
      final json = _dioClient.getJsonBody(response);

      if (json['data']['data'] != null && json['data']['data'].isNotEmpty) {
        json['data']['data'].forEach((element) {
          list.add(CampaignShortModel.fromJson(element));
        });
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CampaignDetailModel> getCampaignDetail(int campaignId) async {
    try {
      CampaignDetailModel model = CampaignDetailModel();
      final data = {"campaign_id": campaignId};

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        // 'Authorization': 'Bearer $token' + 'asdgajs', //TODO: TEST UNAUTHORIZED
      };

      final response = await _dioClient.post(
          Constants.rasoocDevUrl + Constants.getCampaignDetail,
          data: data,
          options: Options(
            headers: headers,
          ));
      final json = _dioClient.getJsonBody(response);
      if (json['data'] != null) {
        model = CampaignDetailModel.fromJson(json['data']);
      }

      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CampaignShortModel>> searchCampaigns(String query) async {
    try {
      final data = {"keyword": query};
      final List<CampaignShortModel> list = [];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _dioClient.post(
          Constants.rasoocDevUrl + Constants.searchCampaign,
          data: data,
          options: Options(
            headers: headers,
          ));
      final json = _dioClient.getJsonBody(response);
      if (json['data'] != null && json['data'].isNotEmpty) {
        json['data'].forEach((element) {
          list.add(CampaignShortModel.fromJson(element));
        });
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> checkUserExistUsingFBID(
      int fbId, String? fbAccessToken) async {
    try {
      final data = {
        "provider_id": fbId,
        "fbAccessToken": fbAccessToken,
      };
      ProfileModel profileModel = ProfileModel();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.checkUserExistFBID,
        data: data,
      );
      final json = _dioClient.getJsonBody(response);
      if (json['data'] != null && json['data'].isNotEmpty) {
        profileModel = ProfileModel.fromBackendJson(json["data"])
            .copyWith(userAccessToken: json['access_token']);

        print(profileModel.userAccessToken);

        // Setting to Shared pref
        await pref.setFBToken(profileModel.fbAccessToken ?? "");
        await pref.setFBUserId(profileModel.fbUserId ?? 0);
        await pref.setAccessToken(profileModel.userAccessToken ?? "");
        await pref.setUserProfile(profileModel);
      }

      return profileModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CampaignShortModel> favoriteCampgain(
      bool isFav, int campaignId) async {
    try {
      final data = {
        "campaign_id": campaignId,
        "favorite": isFav ? 1 : 0,
      };
      CampaignShortModel model = CampaignShortModel();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response =
          await _dioClient.post(Constants.rasoocDevUrl + Constants.favCampagin,
              data: data,
              options: Options(
                headers: headers,
              ));
      final json = _dioClient.getJsonBody(response);
      if (json['data'] != null && json['data'].isNotEmpty) {
        model = CampaignShortModel.fromJson(json['data']);
      }

      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> updateUserProfile(ProfileModel model) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final data = model.toUpdateJson();

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.updateProfile,
        data: data,
        options: Options(headers: headers),
      );
      final json = _dioClient.getJsonBody(response);

      final ProfileModel profileModel =
          ProfileModel.fromBackendJson(json["data"]);
      return profileModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FacebookPageAccount>> linkFacebookPages() async {
    try {
      final facebookLogin = FacebookLogin();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final List<FacebookPageAccount> facebookPageAccountsList =
          <FacebookPageAccount>[];

      final List<PageModel> _listOfPages = [];

      final facebookLoginResult = await facebookLogin.logIn(
        permissions: [FacebookPermission.pagesShowList],
        customPermissions: [
          // "pages_manage_metadata",
          "public_profile",
          "email",
          "pages_show_list",
          "pages_manage_posts",
          "pages_read_user_content",
          "pages_manage_metadata",
          "pages_manage_engagement"
        ],
      );
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          throw "Error ";

        case FacebookLoginStatus.cancel:
          throw "Action Cancelled by user";

        case FacebookLoginStatus.success:
          final shortToken = facebookLoginResult.accessToken?.token;
          final exchangeResponse = await _dioClient.get(
              '${Constants.facebookBaseURL}v2.12/oauth/access_token?grant_type=fb_exchange_token&client_id=${Secrets.appId}&client_secret=${Secrets.appSecret}&fb_exchange_token=$shortToken');

          final longLivedToken = exchangeResponse.data["access_token"];
          if (longLivedToken != null) {
            await pref.setFBToken(longLivedToken);
            final pageResponse = await _dioClient.get(
                '${Constants.facebookBaseURL}v2.12/me/accounts?access_token=$longLivedToken');

            final jsonResonse = json.decode(pageResponse.data);

            if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
              for (final element in jsonResonse['data']) {
                final model = PageModel.fromJson(element);
                _listOfPages.add(model);
                // await getFBPageDetails(model);
              }
            }
          }

          ///`CALL API TO SEND FB ACCOUNT DETAILS`
          if (_listOfPages.isNotEmpty) {
            final List<Map<String, dynamic>> list = [];
            for (final element in _listOfPages) {
              list.add(element.toJson());
            }

            final accessToken = await pref.getAccessToken();
            final headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            };
            final data = {
              "data": list,
              // "access_token": longLivedToken,
            };

            final resp = await _dioClient.post(
              Constants.rasoocDevUrl + Constants.linkFBAccounts,
              data: data,
              options: Options(headers: headers),
            );
            final jsonResp = _dioClient.getJsonBody(resp);
            if (jsonResp["data"] != null && jsonResp["data"].isNotEmpty) {
              jsonResp["data"].forEach((element) {
                facebookPageAccountsList
                    .add(FacebookPageAccount.fromJson(element));
              });
            }
          }

          return facebookPageAccountsList;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<InstaAccount> linkInstagramAccount() async {
    try {
      final facebookLogin = FacebookLogin();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      InstaAccountLinkResponseModel instaLinlResponse =
          InstaAccountLinkResponseModel();
      InstaAccount instaAccount = InstaAccount();

      final facebookLoginResult = await facebookLogin.logIn(
        permissions: [
          FacebookPermission.email,
          FacebookPermission.publicProfile
        ],
        customPermissions: [
          "instagram_basic",
          "instagram_manage_insights",
          // "instagram_manage_comments",
          "instagram_content_publish",
          "pages_read_user_content",
          "pages_manage_metadata",
          "pages_read_engagement"
        ],
      );

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          throw "Error ";

        case FacebookLoginStatus.cancel:
          throw "Action Cancelled by user";

        case FacebookLoginStatus.success:
          final String shortToken = facebookLoginResult.accessToken!.token;

          final exchangeResponse = await _dioClient.get(
              '${Constants.facebookBaseURL}v2.12/oauth/access_token?grant_type=fb_exchange_token&client_id=${Secrets.appId}&client_secret=${Secrets.appSecret}&fb_exchange_token=$shortToken');

          final longLivedToken = exchangeResponse.data["access_token"];
          if (longLivedToken != null) await pref.setFBToken(longLivedToken);

          final pageResponse = await _dioClient.get(
              '${Constants.facebookBaseURL}v2.12/me?fields=accounts{connected_instagram_account}&access_token=$longLivedToken');

          final jsonResonse = json.decode(pageResponse.data);

          if (jsonResonse["accounts"] != null &&
              jsonResonse["accounts"]["data"] != null &&
              jsonResonse["accounts"]["data"].isNotEmpty) {
            jsonResonse["accounts"]["data"].forEach((map) {
              if (map["connected_instagram_account"] != null) {
                instaLinlResponse = InstaAccountLinkResponseModel.fromJson(map);
              }
            });
          }

          ///`CALL API TO SEND INSTA ACCOUNT DETAILS`
          if (instaLinlResponse.pageId != null) {
            final accessToken = await pref.getAccessToken();
            final headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            };
            final data = {
              "instagram_id": instaLinlResponse.connectedInstagramAccount?.id,
              "access_token": longLivedToken,
            };

            final resp = await _dioClient.post(
              Constants.rasoocDevUrl + Constants.linkInstaAccount,
              data: data,
              options: Options(headers: headers),
            );
            final jsonResp = _dioClient.getJsonBody(resp);
            if (jsonResp["data"] != null &&
                jsonResp["data"]["insta_details"] != null) {
              instaAccount =
                  InstaAccount.fromJson(jsonResp["data"]["insta_details"]);
            }
          }

          return instaAccount;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TwitterAccount> linkTwitterAccount() async {
    try {
      final TwitterLogin twitterLogin = TwitterLogin(
          apiKey: Secrets.twitterApiKey,
          apiSecretKey: Secrets.twitterApiSecretKey,
          redirectURI: "");

      final AuthResult result = await twitterLogin.login();

      if (result.status != null) {
        switch (result.status) {
          case TwitterLoginStatus.loggedIn:
            final pref = GetIt.instance<SharedPreferenceHelper>();
            final accessToken = await pref.getAccessToken();
            final data = TwitterAccount(
              userId: result.user!.id,
              userName: result.user!.screenName,
              secret: result.authTokenSecret,
              token: result.authToken,
            );

            final headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            };

            final resp = await _dioClient.post(
              Constants.rasoocDevUrl + Constants.linkTwitterAccount,
              data: data.toJson(),
              options: Options(headers: headers),
            );
            final jsonResp = _dioClient.getJsonBody(resp);
            if (jsonResp["data"] != null && jsonResp["data"].isNotEmpty) {
              final twitterAccount =
                  TwitterAccount.fromJson(jsonResp["data"][0]);
              return twitterAccount;
            }
            break;
          case TwitterLoginStatus.cancelledByUser:
            throw 'Linking cancelled by user.';
          case TwitterLoginStatus.error:
          case null:
            throw 'Some unexpected error occurred while logging in.';
        }
      }

      return TwitterAccount();
    } catch (e) {
      rethrow;
    }
  }

  ///Api call to get meta data for any single page
  ///from facebook
  @override
  Future<void> getFBPageDetails(PageModel pageModel) async {
    try {
      final pageResponse = await _dioClient.get(
          '${Constants.facebookBaseURL}${pageModel.id}?fields=about,attire,bio,location,parking,hours,emails,website&access_token=${pageModel.accessToken}');

      final jsonResonse = json.decode(pageResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SocialAccountsModel> getConnectedAccounts() async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      SocialAccountsModel socialAccountsModel = SocialAccountsModel();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await _dioClient.get(
        Constants.rasoocDevUrl + Constants.getConnectedAccounts,
        options: Options(headers: headers),
      );

      final jsonResonse = _dioClient.getJsonBody(response);
      if (jsonResonse["data"] != null) {
        socialAccountsModel = SocialAccountsModel.fromJson(jsonResonse["data"]);
      }
      return socialAccountsModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SocialAccountsModel> removeConnectedAccount(
      int id, String provider) async {
    try {
      SocialAccountsModel socialAccountsModel = SocialAccountsModel();

      final data = {provider: id};
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final token = await pref.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _dioClient.post(
          Constants.rasoocDevUrl + Constants.removedConnectedAccount,
          data: data,
          options: Options(
            headers: headers,
          ));
      final json = _dioClient.getJsonBody(response);
      if (json['data'] != null) {
        socialAccountsModel = SocialAccountsModel.fromJson(json['data']);
      }
      return socialAccountsModel;
    } catch (e) {
      rethrow;
    }
  }

  ///`Creating Submissions`
  @override
  Future<bool> submitSubmission(
      SubmissionModel submissionModel, List files) async {
    try {
      final accessToken = await SharedPreferenceHelper().getAccessToken();
      final List<String> _images = [];
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      for (final file in files) {
        ///`For Carousel`
        if (file is Asset) {
          final ByteData byteData = await file.getByteData();
          final tempFile =
              File("${(await getTemporaryDirectory()).path}/${file.name}");
          final finalFile = await tempFile.writeAsBytes(
            byteData.buffer
                .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          );
          final String fileName = finalFile.path.split("/").last;
          final multipartFile =
              await MultipartFile.fromFile(finalFile.path, filename: fileName);

          print("UPLOADING IMAGE MULTIPLE");
          final uploadRes = await _dioClient.post(
              Constants.rasoocDevUrl + Constants.uploadImage,
              options: Options(
                headers: headers,
              ),
              data: FormData.fromMap({
                "post_image": multipartFile,
              }));

          final decodeRes = _dioClient.getJsonBody(uploadRes);
          if (decodeRes["data"] != null) {
            _images.add(decodeRes["data"]);
          }
        }

        ///`For Post`
        if (file is File) {
          final String fileName = file.path.split("/").last;

          print("UPLOADING IMAGE");
          final uploadRes = await _dioClient.post(
            Constants.rasoocDevUrl + Constants.uploadImage,
            options: Options(
              headers: headers,
            ),
            data: FormData.fromMap({
              "post_image":
                  await MultipartFile.fromFile(file.path, filename: fileName)
            }),
          );

          final decodeRes = _dioClient.getJsonBody(uploadRes);
          if (decodeRes["data"] != null) {
            _images.add(decodeRes["data"]);
          }
        }
      }

      final data = {
        "images": List<dynamic>.from(_images.map((x) => x)),
        "campaign_id": submissionModel.campaignId,
        "caption": submissionModel.caption,
        "account_type": submissionModel.accountType?.asString(),
        "account_id": submissionModel.accountId,
        "notes": submissionModel.notes,
        "submission_type": submissionModel.submissionType?.asString(),
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.submitSubmission,
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      final json = _dioClient.getJsonBody(response);
      if (json["data"] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostSubmissionsModel>> getSubmissionList(
      SubmissionStatus status) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final List<PostSubmissionsModel> listOfSubmissions =
          <PostSubmissionsModel>[];

      final data = {"status": status.asStatus()};

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getSubmissionsListDetails,
        options: Options(headers: headers),
        data: data,
      );

      final jsonResonse = _dioClient.getJsonBody(response);
      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final json in jsonResonse["data"]) {
          listOfSubmissions.add(PostSubmissionsModel.fromJson(json));
        }
      }
      return listOfSubmissions;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> withdrawSubmission(int id) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final data = {"submission_id": id};

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.withdrawSubmission,
        options: Options(headers: headers),
        data: data,
      );

      final jsonResonse = _dioClient.getJsonBody(response);
      if (jsonResonse["message"] != null &&
          jsonResonse["message"].contains("Sucessfully")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> publishSingleMedia(PostSubmissionsModel submissionsModel) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      String fileType = "image";
      String mediaUrl = "";

      if (submissionsModel.image != null &&
          submissionsModel.image!.isNotEmpty) {
        fileType = "image";
        mediaUrl = submissionsModel.image!;
      } else {
        fileType = "video";
        mediaUrl = submissionsModel.video!;
      }

      final data = {
        "submission_id": submissionsModel.id,
        "account_type": submissionsModel.accountType?.asString(),
        "file_type": fileType,
        "account_id": submissionsModel.accountId,
        "media_url": mediaUrl,
        "access_token": submissionsModel.accessToken
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.publishPostToInstagram,
        options: Options(headers: headers),
        data: data,
      );

      final jsonResonse = _dioClient.getJsonBody(response);
      if (jsonResonse["message"] != null &&
          jsonResonse["message"].contains("Sucessfully")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContentRightsModel>> getContentRights(
      ContentStatus status) async {
    try {
      final List<ContentRightsModel> _list = [];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {"status": status.asStatus()};
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getContentRights,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ContentRightsModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContentRightsModel> contentRightDecision(
      int id, ContentDecision status) async {
    try {
      ContentRightsModel _model = ContentRightsModel();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {
        "request_id": id,
        "status": status.asStatus(),
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.contentRightDecision,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        _model = ContentRightsModel.fromMap(jsonResonse["data"]);
      }
      return _model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContentCampaignsModel>> getContentCampaign(
      ContentStatus status) async {
    try {
      final List<ContentCampaignsModel> _list = [];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {"status": status.asStatus()};
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getContentCampaigns,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ContentCampaignsModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContentCampaignsModel> contentCampaignDecision(
      int id, ContentDecision status) async {
    try {
      ContentCampaignsModel _model = ContentCampaignsModel();
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {
        "request_id": id,
        "status": status.asStatus(),
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.contentCampaignDecision,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        _model = ContentCampaignsModel.fromMap(jsonResonse["data"]);
      }
      return _model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> postComment(int submissionId, String message) async {
    try {
      List<ChatModel> _list = <ChatModel>[];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {
        "submission_id": submissionId,
        "message": message,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.sendComment,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ChatModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> getSubmissionComments(int submissionId) async {
    try {
      final List<ChatModel> _list = <ChatModel>[];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {
        "submission_id": submissionId,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getSubmissionChat,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ChatModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> getInfluencerChats() async {
    try {
      final List<ChatModel> _list = <ChatModel>[];
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.get(
        Constants.rasoocDevUrl + Constants.getInfluencerChats,
        options: Options(headers: headers),
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ChatModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> sendInfluencerChat(String message) async {
    try {
      final List<ChatModel> _list = <ChatModel>[];

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final data = {
        "message": message,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.sendInfluencerChat,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ChatModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NotificationsModel>> getNotifications() async {
    try {
      final List<NotificationsModel> _list = <NotificationsModel>[];

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.get(
        Constants.rasoocDevUrl + Constants.getNotifications,
        options: Options(headers: headers),
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(NotificationsModel.fromMap(element));
        }
      }
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> publishToTwitter(
      PostSubmissionsModel postSubmissionsModel) async {
    try {
      final List<ChatModel> _list = <ChatModel>[];

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      String fileType = "image";
      String mediaUrl = "";

      if (postSubmissionsModel.image != null &&
          postSubmissionsModel.image!.isNotEmpty) {
        fileType = "image";
        mediaUrl = postSubmissionsModel.image!;
      } else {
        fileType = "video";
        mediaUrl = postSubmissionsModel.video!;
      }

      final data = {
        "submission_id": postSubmissionsModel.id,
        "twitter_user_id": postSubmissionsModel.accountId,
        "image_url": mediaUrl,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.publishToTwtitter,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null && jsonResonse["data"].isNotEmpty) {
        for (final element in jsonResonse["data"]) {
          _list.add(ChatModel.fromMap(element));
        }
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostSubmissionsModel> getSubmissionDetail(int submissionId) async {
    try {
      PostSubmissionsModel model = PostSubmissionsModel();

      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final data = {"submission_id": submissionId};

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getSingleSubmissionDetail,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"] != null) {
        model = PostSubmissionsModel.fromJson(jsonResonse["data"]);
      }
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> clearNotification(NotificationDecision decision, int id) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final data = {
        "notification_id": id,
        "type": decision.asStatus(),
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.clearNotifications,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["message"] != null &&
          jsonResonse["message"].toLowerCase().contains("success")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> publishStoryAndCarousel(
      String url, PostSubmissionsModel model) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      int type = 0; //STORY

      if (model.carousel != null && model.carousel!.isNotEmpty) {
        type = 1;
      }

      final data = {
        "submission_id": model.id,
        "url": url,
        "account_id": model.accountId,
        "access_token": model.accessToken,
        "type": type,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.submitUrl,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["message"] != null &&
          jsonResonse["message"].toLowerCase().contains("success")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> applyToCampaign(int campaignId) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final data = {"campaign_id": campaignId};

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.applyCampaign,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["message"] != null &&
          jsonResonse["message"].toLowerCase().contains("success")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CampaignShortModel>> getInfluencerCampaigns(CampaignStatus status,
      {int pageId = 1}) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();
      final List<CampaignShortModel> list = <CampaignShortModel>[];

      final data = {
        "status": status.asStatus(),
        "page": pageId,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.getInfluencerCampaigns,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["data"]["data"] != null &&
          jsonResonse["data"]["data"].isNotEmpty) {
        for (final json in jsonResonse["data"]["data"]) {
          list.add(CampaignShortModel.fromJson(json));
        }
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> withdrawInfluencerCampaign(int campaignId) async {
    try {
      final pref = GetIt.instance<SharedPreferenceHelper>();
      final accessToken = await pref.getAccessToken();

      final data = {"campaign_id": campaignId};

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dioClient.post(
        Constants.rasoocDevUrl + Constants.withdrawInfluencerCampaigns,
        options: Options(headers: headers),
        data: data,
      );
      final jsonResonse = _dioClient.getJsonBody(response);

      if (jsonResonse["message"] != null &&
          jsonResonse["message"].toLowerCase().contains("success")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> goDaddyWhitelistIp() async {
    return true;
  }

  @override
  Future<List<GeographicEntity>> getCities(int stateId) {
    // TODO: implement getCities
    throw UnimplementedError();
  }

  @override
  Future<List<GeographicEntity>> getCountries() {
    // TODO: implement getCountries
    throw UnimplementedError();
  }

  @override
  Future<List<GeographicEntity>> getStates(int countryId) {
    // TODO: implement getStates
    throw UnimplementedError();
  }
}
