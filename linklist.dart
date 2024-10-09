import 'dart:io';
import 'dart:async';
import 'dart:math';

// Node class untuk membuat linked list
class Node {
  String data;
  Node? next;

  Node(this.data);
}

// Fungsi untuk menunda eksekusi animasi
Future<void> pause(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

// Fungsi untuk mendapatkan ukuran terminal
List<int> getTerminalSize() {
  return [stdout.terminalColumns, stdout.terminalLines];
}

// Fungsi untuk memindahkan posisi kursor pada terminal
void moveCursor(int row, int col) {
  stdout.write('\x1B[${row};${col}H');
}

// Fungsi untuk membersihkan layar terminal
void clearTerminal() {
  stdout.write('\x1B[2J\x1B[H');
}

// Fungsi untuk membuat warna acak
String randomColor(String currentColor) {
  const List<String> colors = [
    '\x1B[31m', // Merah
    '\x1B[32m', // Hijau
    '\x1B[33m', // Kuning
    '\x1B[34m', // Biru
    '\x1B[35m', // Magenta
    '\x1B[36m', // Cyan
  ];

  String newColor;
  Random random = Random();
  
  do {
    newColor = colors[random.nextInt(colors.length)];
  } while (newColor == currentColor); // Pastikan warna baru berbeda

  return newColor;
}

// Fungsi untuk membuat linked list dari string
Node createLinkedList(String text) {
  Node head = Node(text[0]);
  Node current = head;

  for (int i = 1; i < text.length; i++) {
    current.next = Node(text[i]);
    current = current.next!;
  }

  // Membuat linked list melingkar
  current.next = head;
  return head;
}

// Fungsi utama untuk animasi
void main() async {
  // Kata yang akan dianimasikan
  String word = "Levin";

  // Membuat linked list dari kata
  Node head = createLinkedList(word);

  // Bersihkan layar terminal sebelum animasi dimulai
  clearTerminal();

  Node? current = head; // Pointer untuk melacak posisi saat ini pada linked list
  String color = randomColor(""); // Pilih warna acak baru sebelum memulai setiap siklus animasi

  while (true) {
    // Ukuran terminal (lebar dan tinggi)
    List<int> terminalSize = getTerminalSize();
    int width = terminalSize[0];
    int height = terminalSize[1];

    // Loop untuk setiap baris di layar terminal
    for (int row = 1; row <= height; row++) {
      // Terapkan warna baru untuk setiap siklus
      stdout.write(color);

      if (row % 2 == 1) {
        // Gerakan dari kiri ke kanan
        for (int col = 1; col <= width; col++) {
          moveCursor(row, col);
          stdout.write(current!.data);
          current = current.next;
          await pause(1); // Pause yang lebih cepat
        }
      } else {
        // Gerakan dari kanan ke kiri
        for (int col = width; col > 0; col--) {
          moveCursor(row, col);
          stdout.write(current!.data);
          current = current.next;
          await pause(1); // Pause yang lebih cepat
        }
      }
    }

    // Setelah satu putaran penuh, pilih warna baru yang berbeda
    String previousColor = color;
    color = randomColor(previousColor);

    // Reset warna ke default setelah setiap refresh layar
    stdout.write('\x1B[0m');
  }
}
