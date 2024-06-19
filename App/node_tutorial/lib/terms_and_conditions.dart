import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF4B6363),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/term_cond.png',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text(
                "TERMS AND CONDITIONS",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Last updated March 06, 2024",
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "AGREEMENT TO OUR LEGAL TERMS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We are MentPhysique ('Company,' 'we,' 'us,' 'our'), a company registered in Pakistan at Near Hotel Stop, Jhangi Syedan, Islamabad, Islamabad 45211.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              "We operate the mobile application MentPhysique (the 'App'), as well as any other related products and services that refer or link to these legal terms (the 'Legal Terms') (collectively, the 'Services').",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              "MentPhysique: Your all-in-one health companion for personalized support, insights, and tools for mental and physical well-being.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "You can contact us by phone at 0318-5580682, email at mentphysique@gmail.com, or by mail to Near Hotel Stop, Jhangi Syedan, Islamabad, Islamabad 45211, Pakistan.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ('you'), and MentPhysique, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "We will provide you with prior notice of any scheduled changes to the Services you are using. The modified Legal Terms will become effective upon posting or notifying you by mentphysique@gmail.com, as stated in the email message. By continuing to use the Services after the effective date of any changes, you agree to be bound by the modified terms.\n\nThe Services are intended for users who are at least 18 years old. Persons under the age of 18 are not permitted to use or register for the Services.\n\nWe recommend that you print a copy of these Legal Terms for your records.\n\n",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "TABLE OF CONTENTS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "1. OUR SERVICES\n2. INTELLECTUAL PROPERTY RIGHTS\n3. USER REPRESENTATIONS\n4. USER REGISTRATION\n5. PURCHASES AND PAYMENT\n6. SUBSCRIPTIONS\n7. POLICY\n8. PROHIBITED ACTIVITIES\n9. USER GENERATED CONTRIBUTIONS\n10. CONTRIBUTION LICENSE\n11. GUIDELINES FOR REVIEWS\n12. MOBILE APPLICATION LICENSE\n13. ADVERTISERS\n14. SERVICES MANAGEMENT\n15. PRIVACY POLICY\n16. COPYRIGHT INFRINGEMENTS\n17. CONTACT US\n",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              "1. OUR SERVICES",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.\n The Services are not tailored to comply with industry-specific regulations (Health Insurance \nPortability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use the Services. You may not use the Services in a way that would violate the Gramm-Leach-Bliley Act (GLBA). ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "2. INTELLECTUAL PROPERTY RIGHTS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Our intellectual property \nWe are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the Content), as well as the trademarks, service marks, and logos contained therein (the Marks). \nOur Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties in the United States and around the world. \nThe Content and Marks are provided in or through the Services AS IS for your personal, non-commercial use only.\nYour use of our Services \nSubject to your compliance with these Legal Terms, including the PROHIBITED ACTIVITIES section below, we grant you a non-exclusive, non-transferable, revocable license to: access the Services; and download or print a copy of any portion of the Content to which you have properly gained access. solely for your personal, non-commercial use.\nExcept as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.\n If you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: mentphysique@gmail.com. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content.\nWe reserve all rights not expressly granted to you in and to the Services, Content, and Marks. \nAny breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately. \nYour submissions and contributions \nPlease review this section and the PROHIBITED ACTIVITIES section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services. \nSubmissions: By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services (Submissions), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "3. USER REPRESENTATIONS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "By using the Services, you represent and warrant that: \n\nAll registration information you submit will be true, accurate, current, and complete; \nYou will maintain the accuracy of such information and promptly update such registration information as necessary; \nYou have the legal capacity and you agree to comply with these Legal Terms; \nYou are not under the age of 18; \nNot a minor in the jurisdiction in which you reside, or if a minor, you have received parental permission to use the Services; \nYou will not access the Services through automated or non-human means, whether through a bot, script, or otherwise; \nYou will not use the Services for any illegal or unauthorized purpose; \nYour use of the Services will not violate any applicable law or regulation. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "4. USER REGISTRATION",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "You may be required to register with the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "5. PURCHASES AND PAYMENT",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We accept Visa and MasterCard for all purchases. You agree to provide current, complete, and accurate purchase and account information for all purchases made via the Services. You further agree to promptly update account and payment information, including email address, payment method, and payment card expiration date, so that we can complete your transactions and contact you as needed. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "6. SUBSCRIPTIONS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We may, from time to time, make changes to the subscription fee and will communicate any price changes to you in accordance with applicable law.\nWe may, from time to time, make changes to the subscription fee and will communicate any price changes to you in accordance with applicable law. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "7. POLICY",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "All sales are final and no refund will be issued. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "8. PROHIBITED ACTIVITIES",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "In addition to other prohibitions as set forth in the Legal Terms, you are prohibited from using the Services or Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "9. USER GENERATED CONTRIBUTIONS",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on the Services, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, Contributions). ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "10. PRIVACY POLICY",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We care about data privacy and security. Please review our Privacy Policy: __________. By using the Services, you agree to be bound by our Privacy Policy, which is incorporated into these Legal Terms. Please be advised the Services are hosted in Pakistan. If you access the Services from any other region of the world with laws or other requirements governing personal data collection, use, or disclosure that differ from applicable laws in Pakistan, then through your continued use of the Services, you are transferring your data to Pakistan, and you expressly consent to have your data transferred to and processed in Pakistan. ",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "11. Contact Us",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "MentPhysique \nNear Hotel Stop, Jhangi Syedan ,Islamabad \nIslamabad, Islamabad 45211 \nPakistan \nPhone: 0318-5580682\nEmail:mentphysique@gmail.com",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
