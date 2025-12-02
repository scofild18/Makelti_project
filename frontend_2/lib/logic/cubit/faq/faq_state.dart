class FAQState {
  final List<Map<String, String>> faqs;
  final Set<int> expandedItems;

  FAQState({
    required this.faqs,
    Set<int>? expandedItems,
  }) : expandedItems = expandedItems ?? {};

  FAQState copyWith({
    List<Map<String, String>>? faqs,
    Set<int>? expandedItems,
  }) {
    return FAQState(
      faqs: faqs ?? this.faqs,
      expandedItems: expandedItems ?? this.expandedItems,
    );
  }
}

