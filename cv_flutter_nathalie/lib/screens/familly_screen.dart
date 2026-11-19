import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../widgets/section_title.dart';

class FamilyScreen extends StatelessWidget {

  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(

      padding: const EdgeInsets.fromLTRB(
        18, 18, 18, 28,
      ),

      children: [

        // EN-TETE

        Container(

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(

            color: const Color(0xFF101B32),

            borderRadius: BorderRadius.circular(22),

          ),

          child: const Row(

            children: [

              Icon(
                Icons.family_restroom,
                color: Color(0xFF38BDF8),
                size: 38,
              ),

              SizedBox(width: 14),

              Expanded(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Ma famille',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Les personnes qui comptent pour moi.',

                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                  ],

                ),

              ),

            ],

          ),

        ),


        const SectionTitle(

          title: 'Membres de ma famille',

          subtitle: 'Découvrez les personnes qui me sont chères.',

        ),


        // LISTE DES MEMBRES

        ...AppData.family.map(

          (member) => Card(

            margin: const EdgeInsets.only(
              bottom: 12,
            ),

            child: Padding(

              padding: const EdgeInsets.all(15),

              child: Row(

                children: [

                  // AVATAR

                  CircleAvatar(

                    radius: 29,

                    backgroundColor:
                        member.color.withValues(alpha: 0.13),

                    child: Text(

                      member.initials,

                      style: TextStyle(
                        color: member.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                     
                      ),

                    ),

                  ),

                  const SizedBox(width: 14),


                  // INFORMATIONS

                  Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(

                          member.name,

                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 246, 246, 247),
                            fontSize: 15,
                          ),

                        ),

                        const SizedBox(height: 3),

                        Text(

                          member.relationship,

                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.w600,
                          ),

                        ),

                        const SizedBox(height: 3),

                        Text(

                          member.profession,

                          style: TextStyle(
                            color: Colors.blueGrey.shade500,
                            fontSize: 12,
                          ),

                        ),

                      ],

                    ),

                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Colors.blueGrey,
                  ),

                ],

              ),

            ),

          ),

        ),


        const SizedBox(height: 8),

        const Text(

          ' ',
          

          style: TextStyle(
            color: Colors.blueGrey,
            height: 1.45,
          ),

        ),

      ],

    );

  }

}