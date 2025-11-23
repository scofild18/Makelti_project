import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I order a meal?',
      'answer':
          'Browse the available meals, select the one you like, add it to your cart, and proceed to confirmation phase.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'we accept hand to hand payment with the seller and in the future we may add an online payment',
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'Yes, you can cancel your order only if the seller didint prepare it and make it as confirmed on the commands sections',
    },
    {
      'question': 'How do I become a seller?',
      'answer':
          'Create an account, go to your profile and click "Become a seller". You will need to provide some information ',
    },
    {
      'question': 'Are meals prepared on the same day?',
      'answer':
          'Yes, all meals are freshly prepared on the day of order by our local home cooks.',
    },
    {
      'question': 'What if I have dietary restrictions?',
      'answer':
          'Each meal listing includes detailed ingredients and allergen information. You can also filter meals by dietary preferences.',
    },
    {
      'question': 'Is there a minimum order amount?',
      'answer':
          'Minimum order amounts may vary by seller and location. This information is displayed before checkout.',
    },
  ];

   FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('FAQ', style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQItem(
            question: faqs[index]['question']!,
            answer: faqs[index]['answer']!,
          );
        },
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE8E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Color(0xFFFF6B35), size: 20),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(72, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
