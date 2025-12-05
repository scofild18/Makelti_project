import 'package:flutter_bloc/flutter_bloc.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  FAQCubit() : super(FAQState(faqs: _initialFAQs));

  static final List<Map<String, String>> _initialFAQs = [
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

  void toggleExpanded(int index) {
    final newExpanded = Set<int>.from(state.expandedItems);
    if (newExpanded.contains(index)) {
      newExpanded.remove(index);
    } else {
      newExpanded.add(index);
    }
    emit(state.copyWith(expandedItems: newExpanded));
  }
}

