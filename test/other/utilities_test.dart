import 'package:challenge_box/utilities.dart';
import 'package:test/test.dart';

void main() {
  test('Can escape and unescape apostrophes for SQL insertion', () {
    const unescapedString = "Mr O'Leary & Mr O'Reily";
    const escapedString = "Mr O''Leary & Mr O''Reily";

    expect(escapeApostrophes(unescapedString), equals(escapedString));

    expect(unescapeApostrophes(escapedString), equals(unescapedString));
  });
}
