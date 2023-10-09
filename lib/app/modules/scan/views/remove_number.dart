extension RemoveLeadingNumber on String {
  String removeLeadingNumber() {
    // Mencari posisi pertama spasi dalam string
    final spaceIndex = indexOf(' ');

    // Jika ditemukan spasi, mengambil bagian dari string setelah spasi
    if (spaceIndex != -1) {
      return substring(spaceIndex + 1);
    }

    // Jika tidak ditemukan spasi, mengembalikan string asli
    return this;
  }
}
