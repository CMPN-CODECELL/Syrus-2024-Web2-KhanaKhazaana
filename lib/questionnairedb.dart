class Questionnaire {
  final List questions = [
    {
      'question':
          'Can you recall the current date, including the month, day, and year?',
      'options': ['Yes', 'Partially', 'No'],
      'scores': [0, 1, 2] // Assigning scores: Yes-0, Partially-1, No-2
    },
    {
      'question':
          'Do you remember the names of close family members or caregivers?',
      'options': ['Yes', 'Some of them', 'No'],
      'scores': [0, 1, 2]
    },
    {
      'question':
          'Are you able to perform basic daily tasks independently, such as dressing, eating, or grooming?',
      'options': ['Yes', 'Sometimes need assistance', 'No'],
      'scores': [0, 1, 2]
    },
    {
      'question':
          'Do you experience confusion or disorientation in familiar surroundings, such as your home or neighborhood?',
      'options': ['Rarely', 'Sometimes', 'Frequently'],
      'scores': [0, 1, 2]
    },
    {
      'question':
          'Do you have difficulty finding the right words or expressing yourself verbally?',
      'options': ['Rarely', 'Sometimes', 'Frequently'],
      'scores': [0, 1, 2]
    },
  ];
}
