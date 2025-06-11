import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationGuidelinesScreen extends StatefulWidget {
  const DonationGuidelinesScreen({super.key});

  @override
  _DonationGuidelinesScreenState createState() => _DonationGuidelinesScreenState();
}

class _DonationGuidelinesScreenState extends State<DonationGuidelinesScreen> {
  List<FaqItem> faqItems = [
    FaqItem(
      question: "Eligibility to Donate?",
      answer:
      "You must be at least 17 years old, weigh 50kg or more, and be in good health. Avoid donating if you’ve had recent illness, tattoos, or risky behavior.",
    ),
    FaqItem(
      question: "Best Practices Before Donation?",
      answer:
      "Stay hydrated, eat a healthy meal before donating, avoid fatty foods, and get plenty of sleep the night before.",
    ),
    FaqItem(
      question: "What to Expect During Donation?",
      answer:
      "The donation process takes about 10 minutes. You'll sit comfortably while blood is drawn, followed by refreshments to help you recover.",
    ),
    FaqItem(
      question: "Post-Donation Care?",
      answer:
      "Avoid heavy lifting or strenuous activity for the rest of the day. Drink extra fluids and eat well-balanced meals.",
    ),
    FaqItem(
      question: "Facts About Blood Donation?",
      answer:
      "One donation can save up to 3 lives. Blood has a shelf life, so regular donations are essential. All blood types are needed.",
    ),
    FaqItem(
      question: "Health Benefits of Donating?",
      answer:
      "Donating blood may reduce harmful iron stores, improve heart health, and give you a mini health check during each visit.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            "FAQ",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12),
            child: ElevatedButton(
              onPressed: () {
                // Add your ask-question logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Ask Question',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return _buildFaqCard(faqItems[index]);
        },
      ),
    );
  }

  Widget _buildFaqCard(FaqItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          border: item.isExpanded
              ? Border.all(color: Colors.red, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                item.question,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: item.isExpanded ? Colors.red : Colors.black87,
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    item.isExpanded = !item.isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            if (item.isExpanded)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  item.answer,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
