extension DateFromString on String {
  DateTime toDate() {
    try {
      final parts = this.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Handle parsing errors as needed
    }
    // Return null or a default DateTime if parsing fails
    return DateTime.now();
  }
}