class ProgramManagerModel {
  final int prmaId;
  final String prmaName;
  final String prmaEmail;
  final int prmaPhoneNum;
  final String prmaUsername;
  final String? prmaImage;
  final bool prmaIsactive;
  final int idProgram;

  ProgramManagerModel({
    required this.prmaId,
    required this.prmaName,
    required this.prmaEmail,
    required this.prmaPhoneNum,
    required this.prmaUsername,
    this.prmaImage,
    required this.prmaIsactive,
    required this.idProgram,
  });

  factory ProgramManagerModel.fromJson(Map<String, dynamic> json) {
    return ProgramManagerModel(
      prmaId: (json['prma_id'] as num).toInt(),
      prmaName: json['prma_name'] as String,
      prmaEmail: json['prma_email'] as String,
      prmaPhoneNum: (json['prma_phone_num'] as num).toInt(),
      prmaUsername: json['prma_username'] as String,
      prmaImage: json['prma_image'] as String?,
      prmaIsactive: json['prma_isactive'] as bool,
      idProgram: (json['id_program'] as num).toInt(),
    );
  }
}
