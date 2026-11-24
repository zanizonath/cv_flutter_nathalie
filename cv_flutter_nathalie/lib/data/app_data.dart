import 'package:flutter/material.dart';

class AppData {

  // INFORMATIONS PERSONNELLES

  static const fullName = 'kasanani zanizo nathalie';

  static const headline =
      'Étudiante en sciences informatiques';

  static const location = 'Goma, Nord-Kivu, RDC';

  static const email = 'nathaliezanizo0@gmail.com';

  static const phone = '+243 998 068 057';

  static const address =
      'Goma, République démocratique du Congo';

  static const github =
      'https://github.com/zanizonath';


  // PRESENTATION

  static const about =
      "Passionné par les technologies, le développement logiciel "
      "et les réseaux informatiques. Curieux, motivé et désireux "
      "de mettre mes compétences au service de projets utiles.";


  // FORMATION

  static const education = [

    EducationItem(
      period: 'En cours',
      title: 'Sciences informatiques',
      subtitle: 'Réseaux et Télécommunications',
      detail: 'Établissement à compléter',
    ),

  ];


  // EXPERIENCES

  static const experiences = [

    ExperienceItem(
      period: 'JUIN 2026',
      title: 'Stage professionnel',
      organization: 'Hayatcom ',
      detail:
          'Grace à ce stage j ai acquéri un plus dans mes connaissances en réseau et télécommunication  ',
    ),

    ExperienceItem(
      period: 'OCTOBRE 2026',
      title: 'enquete en mission baseline',
      organization: 'AIDES',
      detail:
          'il est très important de se mettre au service de l humanité et cette expérience m a permi d y participer',
    ),

  ];


  // COMPETENCES TECHNIQUES

  static const technicalSkills = [

    'Flutter / Dart',
    'HTML / CSS / JavaScript',
    'Python',
    'Réseaux informatiques',
    'Microsoft Word, Excel et PowerPoint',
    'Git et GitHub',

  ];


  // LANGUES

  static const languages = [

    'Français',
    'Swahili',
    'Anglais',

  ];


  // CENTRES D'INTERET

  static const interests = [

    'Développement logiciel',
    'Intelligence artificielle',
    'Réseaux et cybersécurité',
    'Innovation technologique',

  ];


  // FAMILLE

  static const family = [

    FamilyMember(
      name: 'Jacques Mubalama',
      relationship: 'Père',
      profession: 'fonctionnaire',
      initials: 'P',
      color: Color(0xFF2563EB),
    ),

    FamilyMember(
      name: 'Esther Mugabo',
      relationship: 'Mère',
      profession: 'Commercante',
      initials: 'M',
      color: Color(0xFFDB2777),
    ),

    FamilyMember(
      name: 'Jeannette Mubalama',
      relationship: 'Sœur',
      profession: 'Entrepreneure',
      initials: 'S',
      color: Color(0xFF059669),
    ),

  ];

}


// CLASSE FORMATION

class EducationItem {

  final String period;
  final String title;
  final String subtitle;
  final String detail;

  const EducationItem({
    required this.period,
    required this.title,
    required this.subtitle,
    required this.detail,
  });

}


// CLASSE EXPERIENCE

class ExperienceItem {

  final String period;
  final String title;
  final String organization;
  final String detail;

  const ExperienceItem({
    required this.period,
    required this.title,
    required this.organization,
    required this.detail,
  });

}


// CLASSE MEMBRE DE FAMILLE

class FamilyMember {

  final String name;
  final String relationship;
  final String profession;
  final String initials;
  final Color color;

  const FamilyMember({
    required this.name,
    required this.relationship,
    required this.profession,
    required this.initials,
    required this.color,
  });

}


///////////////////////////////////////////////////////////////////////////////////////////////////
class ApiFamilyMember {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  const ApiFamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  String get fullName => '$prenom $postnom $nom'.trim();

  factory ApiFamilyMember.fromJson(Map<String, dynamic> json) {
    return ApiFamilyMember(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nom: json['nom']?.toString() ?? '',
      postnom: json['postnom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      lieuNaissance: json['lieu_naissance']?.toString() ?? '',
      dateNaissance: json['date_naissance']?.toString() ?? '',
      parente: json['parente']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
    };
  }
}
//////////////////////////////////////////////////////////////////////////////////////////
