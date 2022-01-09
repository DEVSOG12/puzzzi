import 'dart:developer';

bool platformCheck(bool Function() block) {
  try {
    return block();
  } catch (e) {
    log(e.toString());
  }
  return false;
}

bool platformCheckIsWeb() => platformCheck(() => true);
