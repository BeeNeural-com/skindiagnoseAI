import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/common_disease_details.dart';

// ✅ Updated Skin Disease Data
const data = [
  {
    "id": "1",
    "title": "Acne",
    "subtitle":
        "Acne causes pimples, blackheads, and cysts, mainly on the face and back.",
    "buttonTxt": "Details",
    "img": "assets/images/acne.jpeg",
    "details":
        "Acne is a common skin condition that occurs when hair follicles become clogged with oil and dead skin cells. It often causes whiteheads, blackheads, or pimples, and typically appears on the face, forehead, chest, upper back, and shoulders. Acne is most common among teenagers, though it affects people of all ages. Treatments include over-the-counter creams, prescription medications, and proper skincare routines."
  },
  {
    "id": "2",
    "title": "Eczema",
    "subtitle": "Eczema causes red, itchy, and inflamed patches of skin.",
    "buttonTxt": "Details",
    "img": "assets/images/eczema.jpeg",
    "details":
        "Eczema, also known as atopic dermatitis, is a condition that makes your skin red and itchy. It's common in children but can occur at any age. Eczema is long-lasting (chronic) and tends to flare periodically. No cure has been found for eczema, but treatments and self-care measures can relieve itching and prevent new outbreaks."
  },
  {
    "id": "3",
    "title": "Psoriasis",
    "subtitle": "Psoriasis leads to thick, scaly patches on the skin.",
    "buttonTxt": "Details",
    "img": "assets/images/psoriasis.jpeg",
    "details":
        "Psoriasis is a chronic autoimmune condition that causes the rapid build-up of skin cells, leading to scaling on the skin’s surface. Inflammation and redness around the scales are common. Psoriasis scales are typically whitish-silver and develop in thick, red patches. Treatments include topical ointments, light therapy, and medications."
  },
  {
    "id": "4",
    "title": "Rosacea",
    "subtitle": "Rosacea causes redness and visible blood vessels on the face.",
    "buttonTxt": "Details",
    "img": "assets/images/rosacea.jpeg",
    "details":
        "Rosacea is a common skin condition that causes blushing or flushing and visible blood vessels in your face. It may also produce small, pus-filled bumps. Rosacea can be mistaken for acne, other skin problems, or natural ruddiness. While there's no cure, treatments can control and reduce the signs and symptoms."
  },
  {
    "id": "5",
    "title": "Vitiligo",
    "subtitle":
        "Vitiligo leads to the loss of skin pigment, causing white patches.",
    "buttonTxt": "Details",
    "img": "assets/images/vitiligo.jpeg",
    "details":
        "Vitiligo is a disease that causes loss of skin color in patches. The discolored areas usually get bigger with time. The condition can affect the skin on any part of the body, and it may also affect hair and the inside of the mouth. Treatment may improve the appearance of the affected skin but does not cure the disease."
  }
];

class CommonDisease extends StatelessWidget {
  const CommonDisease({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final disease = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                DetailScreen.routeName,
                arguments: disease,
              );
            },
            child: SizedBox(
              width: 240.0,
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Hero(
                          tag: disease['title']!,
                          child: Image.asset(
                            disease['img']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              disease['title']!,
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color.fromARGB(255, 236, 116, 12),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
