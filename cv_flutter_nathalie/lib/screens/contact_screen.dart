import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_data.dart';
import '../widgets/section_title.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // COPIER UNE COORDONNEE

  void _copy(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copié dans le presse-papiers')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),

      children: [
        // EN-TETE
        Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            gradient: const LinearGradient(
              colors: [Color(0xFF101B32), Color(0xFF234777)],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(
                Icons.connect_without_contact,
                color: Color(0xFF38BDF8),
                size: 36,
              ),

              SizedBox(height: 14),

              Text(
                'Restons en contact',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),

              SizedBox(height: 6),

              Text(
                'Une question, une idée ou une opportunité ? '
                'Écris-moi.',

                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),

        // COORDONNEES
        const SectionTitle(title: 'Coordonnées', titleColor: Color(0xFFD1D5DB)),

        _ContactTile(
          icon: Icons.phone_outlined,

          label: 'Téléphone',

          value: AppData.phone,

          onTap: () => _copy(context, AppData.phone, 'Téléphone'),
        ),

        _ContactTile(
          icon: Icons.email_outlined,

          label: 'Adresse e-mail',

          value: AppData.email,

          onTap: () => _copy(context, AppData.email, 'E-mail'),
        ),

        _ContactTile(
          icon: Icons.location_on_outlined,

          label: 'Adresse',

          value: AppData.address,

          onTap: () => _copy(context, AppData.address, 'Adresse'),
        ),

        // RESEAUX SOCIAUX
        const SectionTitle(
          title: 'Réseaux sociaux',
          titleColor: Color(0xFFD1D5DB),
        ),

        _ContactTile(
          icon: Icons.code,

          label: 'GitHub',

          value: AppData.github,

          onTap: () => _copy(context, AppData.github, 'Lien GitHub'),
        ),

        const SizedBox(height: 14),

        // INFORMATION
        const Card(
          child: Padding(
            padding: EdgeInsets.all(15),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.info_outline, color: Color(0xFF0284C7)),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Appuie sur une coordonnée pour la copier. '
                    ' '
                    '',

                    style: TextStyle(
                      color: Color.fromARGB(255, 223, 224, 226),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// WIDGET DE CONTACT

class _ContactTile extends StatelessWidget {
  final IconData icon;

  final String label;
  final String value;

  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        onTap: onTap,

        leading: Container(
          height: 42,
          width: 42,

          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),

            borderRadius: BorderRadius.circular(13),
          ),

          child: Icon(icon, color: const Color(0xFF0369A1)),
        ),

        title: Text(
          label,

          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFFE5E7EB),
          ),
        ),

        subtitle: Text(
          value,

          maxLines: 2,

          overflow: TextOverflow.ellipsis,

          style: const TextStyle(color: Color(0xFFB8C0CC)),
        ),

        trailing: const Icon(
          Icons.copy_rounded,
          size: 18,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}
