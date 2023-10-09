String stringToPercentage(String stringValue) {
  try {
    // Mengonversi string menjadi double
    final double doubleValue = double.parse(stringValue);

    // Mengonversi double menjadi persentase dalam bentuk string
    final int percentage = (doubleValue * 100).round();
    return '$percentage %';
  } catch (e) {
    // Jika parsing gagal, mengembalikan string asli
    return stringValue;
  }
}
