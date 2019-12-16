class Doggy {
  String trigramme;
  String nom;
  String prenom;
  String surnom;
  String photo;
  String mail;
  String tribu;
  String signeParticulier;

  Doggy(
      {this.trigramme,
        this.nom,
        this.prenom,
        this.surnom,
        this.photo,
        this.tribu,
        this.mail,
        this.signeParticulier});

  factory Doggy.fromJson(Map<String, dynamic> json) {
    return Doggy(
      trigramme: json['trigramme'],
      nom: json['nom'],
      prenom: json['prenom'],
      surnom: json['surnom'],
      photo: json['photo'],
      tribu: json['tribu'],
      mail: json['email'],
      signeParticulier: json['signeParticulier'],
    );
  }

  factory Doggy.chacalAnonyme() {
    return Doggy(
      trigramme: '',
      nom: '',
      prenom: '',
      surnom: 'Chacal Anonyme',
      photo: '',
      tribu: '',
      mail: '',
      signeParticulier: '',
    );
  }
}