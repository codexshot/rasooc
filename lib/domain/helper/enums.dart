enum CampaignCategoryType {
  all,
  relevant,
  favorite,
}

extension CampaignCategoryTypeSearch on CampaignCategoryType {
  int? asId() => {
        CampaignCategoryType.all: 1,
        CampaignCategoryType.relevant: 2,
        CampaignCategoryType.favorite: 3,
      }[this];
  static CampaignCategoryType? fromId(int value) => {
        1: CampaignCategoryType.all,
        2: CampaignCategoryType.relevant,
        3: CampaignCategoryType.favorite,
      }[value];
  String? asString() => {
        CampaignCategoryType.all: "All",
        CampaignCategoryType.relevant: "Relevant",
        CampaignCategoryType.favorite: "Favourites",
      }[this];
}

enum CampaignSocialType { instagram, facebook, twitter }

extension CampaignSocialTypeSearch on CampaignSocialType {
  static CampaignSocialType? fromString(String value) => {
        "instagram": CampaignSocialType.instagram,
        "facebook": CampaignSocialType.facebook,
        "twitter": CampaignSocialType.twitter,
      }[value];

  String? asString() => {
        CampaignSocialType.instagram: "instagram",
        CampaignSocialType.facebook: "facebook",
        CampaignSocialType.twitter: "twitter"
      }[this];
}

enum CampaignSubmissionType { posts, carousel, stories }

extension CampaignSubmissionTypeSearch on CampaignSubmissionType {
  static CampaignSubmissionType? fromString(String value) => {
        "posts": CampaignSubmissionType.posts,
        "carousel": CampaignSubmissionType.carousel,
        "stories": CampaignSubmissionType.stories,
      }[value];

  String? asString() => {
        CampaignSubmissionType.posts: "posts",
        CampaignSubmissionType.carousel: "carousel",
        CampaignSubmissionType.stories: "stories"
      }[this];
}

enum SubmissionStatus { pending, approved, declined, published, withdrawn }

extension SubmissionStatusTypeSearch on SubmissionStatus {
  static SubmissionStatus? fromStatus(int value) => {
        0: SubmissionStatus.pending,
        2: SubmissionStatus.approved,
        3: SubmissionStatus.declined,
        5: SubmissionStatus.published,
        6: SubmissionStatus.withdrawn
      }[value];

  int? asStatus() => {
        SubmissionStatus.pending: 0,
        SubmissionStatus.approved: 2,
        SubmissionStatus.declined: 3,
        SubmissionStatus.published: 5,
        SubmissionStatus.withdrawn: 6,
      }[this];
}

enum ContentStatus { pending, approved, declined, withraw, sold }

extension ContentRightsStatusTypeSearch on ContentStatus {
  static ContentStatus? fromStatus(int value) => {
        0: ContentStatus.pending,
        1: ContentStatus.approved,
        2: ContentStatus.declined,
        3: ContentStatus.withraw,
        4: ContentStatus.sold,
      }[value];

  int? asStatus() => {
        ContentStatus.pending: 0,
        ContentStatus.approved: 1,
        ContentStatus.declined: 2,
        ContentStatus.withraw: 3,
        ContentStatus.sold: 4,
      }[this];
}

enum ContentDecision { accept, reject }

extension ContentDecisionTypeSearch on ContentDecision {
  static ContentDecision? fromStatus(int value) => {
        1: ContentDecision.accept,
        2: ContentDecision.reject,
      }[value];

  int? asStatus() => {
        ContentDecision.accept: 1,
        ContentDecision.reject: 2,
      }[this];
}

enum NotificationDecision { single, all }

extension NotificationDecisionTypeSearch on NotificationDecision {
  static NotificationDecision? fromStatus(int value) => {
        1: NotificationDecision.single,
        2: NotificationDecision.all,
      }[value];

  int? asStatus() => {
        NotificationDecision.single: 0,
        NotificationDecision.all: 1,
      }[this];
}

enum CampaignStatus {
  apply,
  applied,
  shortlisted,
  selected,
  declined,
  withdraw,
}

extension CampaignStatusTypeSearch on CampaignStatus {
  static CampaignStatus? fromStatus(int value) => {
        0: CampaignStatus.apply,
        1: CampaignStatus.applied,
        2: CampaignStatus.shortlisted,
        3: CampaignStatus.selected,
        4: CampaignStatus.declined,
        5: CampaignStatus.withdraw,
      }[value];

  int? asStatus() => {
        CampaignStatus.apply: 0,
        CampaignStatus.applied: 1,
        CampaignStatus.shortlisted: 2,
        CampaignStatus.selected: 3,
        CampaignStatus.declined: 4,
        CampaignStatus.withdraw: 5,
      }[this];

  String? asString() => {
        CampaignStatus.apply: "Apply",
        CampaignStatus.applied: "Applied",
        CampaignStatus.shortlisted: "Shortlisted",
        CampaignStatus.selected: "Selected",
        CampaignStatus.declined: "Declined",
        CampaignStatus.withdraw: "Withdrawn",
      }[this];
}

// enum UploadType { IMAGE, MULTI_IMAGE, VIDEO }
