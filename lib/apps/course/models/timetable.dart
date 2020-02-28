class TimetableDay {
  Map<String, String> time = {
    '1': '',
    'A': '',
    '2': '',
    'B': '',
    '3': '',
    '4': '',
    'C': '',
    '5': '',
    'D': '',
    '6': '',
    '7': '',
    'E': '',
    '8': '',
    'F': '',
    '9': '',
    '10': '',
    'G': '',
    '11': '',
    'H': '',
    '12': '',
    '13': '',
    'I': '',
    '14': '',
    'J': '',
    '15': '',
  };
}

class TimetableWeek {
  Map<String, TimetableDay> day = {
    '一': TimetableDay(),
    '二': TimetableDay(),
    '三': TimetableDay(),
    '四': TimetableDay(),
    '五': TimetableDay(),
  };
}
