import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Makelti/logic/cubit/faq/faq_cubit.dart';
import 'package:Makelti/logic/cubit/faq/faq_state.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FAQCubit, FAQState>(
      builder: (context, state) {
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
            itemCount: state.faqs.length,
            itemBuilder: (context, index) {
              final isExpanded = state.expandedItems.contains(index);
              return _buildFAQItem(
                context: context,
                question: state.faqs[index]['question']!,
                answer: state.faqs[index]['answer']!,
                index: index,
                isExpanded: isExpanded,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
    required int index,
    required bool isExpanded,
  }) {
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
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            context.read<FAQCubit>().toggleExpanded(index);
          },
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
