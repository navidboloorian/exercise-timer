import 'package:flutter/material.dart';

class TimeValidation {
  static int toSeconds(String time) {
    if (time.isEmpty) {
      return 0;
    }

    // because of right-to-left, substring indices are flipped
    int minutes = int.parse(time.substring(0, 2));
    int seconds = int.parse(time.substring(3, 5));

    seconds += minutes * 60;

    return seconds;
  }

  static String toTime(int seconds) {
    int minutes = seconds ~/ 60;

    seconds -= 60 * minutes;

    String minutesString = minutes.toString();
    String secondsString = seconds.toString();

    if (minutesString.length < 2) {
      if (minutesString.isEmpty) {
        minutesString = '00';
      } else {
        minutesString = '0$minutes';
      }
    }

    if (secondsString.length < 2) {
      if (minutesString.isEmpty) {
        secondsString = '00';
      } else {
        secondsString = '0$seconds';
      }
    }

    return '$minutesString:$secondsString';
  }

  // converts overflowing minutes/seconds (> 60 in either field) to a valid time
  static void validate(String time, TextEditingController controller) {
    if (time.isNotEmpty) {
      // because of right-to-left input, substring indices are flipped
      int minutes = int.parse(time.substring(0, 2));
      int seconds = int.parse(time.substring(3, 5));

      if (seconds >= 60 || minutes >= 60) {
        if (seconds >= 60) {
          minutes++;
          seconds -= 60;
        }

        if (minutes >= 60) {
          minutes = 59;
        }

        String validatedTime = '$minutes:$seconds';

        if (validatedTime.length < 5) {
          // pad extra zero in minutes column
          validatedTime = '0$validatedTime';
        }

        controller.text = validatedTime;
      }
    }
  }
}
