import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationGuidelinesScreen extends StatefulWidget {
  const DonationGuidelinesScreen({super.key});

  @override
  _DonationGuidelinesScreenState createState() => _DonationGuidelinesScreenState();
}

class _DonationGuidelinesScreenState extends State<DonationGuidelinesScreen> {
  late String _username;
  late String _bloodType;
  late String _ageGroup;
  late String _gender;
  late double _height;
  late double _weight;
  late bool _takenAntibiotics;
  late bool _recentInfection;

  List<FaqItem> faqItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username') ?? 'Donor';
      _bloodType = prefs.getString('bloodGroup') ?? 'Unknown';
      _ageGroup = prefs.getString('ageGroup') ?? '21-30';
      _gender = prefs.getString('gender') ?? 'Male';
      _height = prefs.getDouble("height") ?? 170.0;
      _weight = prefs.getDouble('weight') ?? 70.0;
    });

    _buildPersonalizedFaq();
  }

  void _buildPersonalizedFaq() {
    final postDonationAdvice = _gender == 'Female'
        ? "Because of your gender, you are not allowed to donate blood until after 4 months."
        : "You are not allowed to donate blood until after 3 months.";

    faqItems = [
      FaqItem(
        question: "Hi $_username, are you eligible to donate?",
        answer:
        "Based on your '$_ageGroup' age group, $_height cm and $_weight kg is considered a healthy weight, you can keep this by using Samsung Health app."
            " As a $_bloodType donor, your blood is especially valuable! "
            "Avoid donating if you’ve been ill recently or taking antibiotics one week before donating date",
      ),
      FaqItem(
        question: "Best Practices Before Donation?",
        answer:
        "Stay hydrated by drinking 2,000 ml (2L) of water a day, eat a healthy meal at least three meals per day, avoid fatty foods, and get plenty of sleep at least 6-8 hours before the donation date."
          " Make 6,000 steps a day. Currently, you can use some apps for this like Samsung Health."
      ),
      FaqItem(
        question: "What to Expect During Donation?",
        answer:
        "The donation itself takes about 10 minutes. Our staff will make sure you're comfortable, "
            "and you'll get refreshments after!",
      ),
      FaqItem(
        question: "Post-Donation Care?",
        answer:
        "Avoid heavy lifting or strenuous activity that day like push-ups, high jumps. Drink extra fluids and eat well-balanced meals. "
            "$postDonationAdvice",
      ),
      FaqItem(
        question: "How often can $_username donate?",
        answer:
        "Generally, every 3–4 months for whole blood. Plasma donations can be more frequent. "
            "We’ll guide you individually.",
      ),
      FaqItem(
        question: "Want to talk to us?",
        answer:
        "Call us at +255-7176-11117 or visit your nearest blood bank. We're always here to help you.",
      ),
    ];
  }


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
