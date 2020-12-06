String appLanguage;
Language defaultLanguage;
Map<String, dynamic> languageJSON;

class Language {
  String visibleText;
  String a1;
  String a2;
  String a3;
  String a4;
  String a5;
  String a6;
  String a7;
  String a8;
  String a9;
  String a10;
  String a11;
  String a12;
  String a13;
  String a14;
  String a15;
  String a16;
  String a17;
  String a18;
  String a19;
  String a20;
  String a21;
  String a22;
  String a23;
  String a24;
  String a25;
  String a26;
  String a27;
  String a28;
  String a29;
  String a30;

  Language(
      {this.visibleText,
      this.a1,
      this.a2,
      this.a3,
      this.a4,
      this.a5,
      this.a6,
      this.a7,
      this.a8,
      this.a9,
      this.a10,
      this.a11,
      this.a12,
      this.a13,
      this.a14,
      this.a15,
      this.a16,
      this.a17,
      this.a18,
      this.a19,
      this.a20,
      this.a21,
      this.a22,
      this.a23,
      this.a24,
      this.a25,
      this.a26,
      this.a27,
      this.a28,
      this.a29,
      this.a30,
      });

  Language.fromJson(Map<String, dynamic> json) {
    visibleText = json["visibleText"];
    a1 = json['a1'];
    a2 = json['a2'];
    a3 = json['a3'];
    a4 = json['a4'];
    a5 = json['a5'];
    a6 = json['a6'];
    a7 = json['a7'];
    a8 = json['a8'];
    a9 = json['a9'];
    a10 = json['a10'];
    a11 = json['a11'];
    a12 = json['a12'];
    a13 = json['a13'];
    a14 = json['a14'];
    a15 = json['a15'];
    a16 = json['a16'];
    a17 = json['a17'];
    a18 = json['a18'];
    a19 = json['a19'];
    a20 = json['a20'];
    a21 = json['a21'];
    a22 = json['a22'];
    a23 = json['a23'];
    a24 = json['a24'];
    a25 = json['a25'];
    a26 = json['a26'];
    a27 = json['a27'];
    a28 = json['a28'];
    a29 = json['a29'];
    a30 = json['a30'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visibleText'] = this.visibleText;
    data['a1'] = this.a1;
    data['a2'] = this.a2;
    data['a3'] = this.a3;
    data['a4'] = this.a4;
    data['a5'] = this.a5;
    data['a6'] = this.a6;
    data['a7'] = this.a7;
    data['a8'] = this.a8;
    data['a9'] = this.a9;
    data['a10'] = this.a10;
    data['a11'] = this.a11;
    data['a12'] = this.a12;
    data['a13'] = this.a13;
    data['a14'] = this.a14;
    data['a15'] = this.a15;
    data['a16'] = this.a16;
    data['a17'] = this.a17;
    data['a18'] = this.a18;
    data['a19'] = this.a19;
    data['a20'] = this.a20;
    data['a21'] = this.a21;
    data['a22'] = this.a22;
    data['a23'] = this.a23;
    data['a24'] = this.a24;
    data['a25'] = this.a25;
    data['a26'] = this.a26;
    data['a27'] = this.a27;
    data['a28'] = this.a28;
    data['a29'] = this.a29;
    data['a30'] = this.a30;
    return data;
  }
}
