extends Node

var all_questions: Array = [
	{
		"text": "🍎🍎🍎\nBerapa jumlah apel di atas?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "Yang mana 5 buah ikan?",
		"choices": ["🐟🐟", "🐟🐟🐟🐟", "🐟🐟🐟🐟🐟"],
		"correct": 2
	},
	{
		"text": "Ada 4 bintang ⭐⭐⭐⭐\nBerapa jumlah bintang?",
		"choices": ["3", "4", "5"],
		"correct": 1
	},
	{
		"text": "Angka berapa setelah 6?",
		"choices": ["5", "7", "8"],
		"correct": 1
	},
	{
		"text": "Pilih gambar yang jumlahnya 2 🐰",
		"choices": ["🐰🐰🐰", "🐰🐰", "🐰"],
		"correct": 1
	},
	{
		"text": "2 + 1 = ?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "5 - 2 = ?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "3 + 3 = ?",
		"choices": ["5", "6", "7"],
		"correct": 1
	},
	{
		"text": "4 - 1 = ?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "1 + 4 = ?",
		"choices": ["4", "5", "6"],
		"correct": 1
	},
	{
		"text": "Lengkapi urutan angka: 1, 2, __, 4, 5",
		"choices": ["2", "3", "6"],
		"correct": 1
	},
	{
		"text": "Polanya adalah 🔺⚫🔺⚫ …\nGambar selanjutnya?",
		"choices": ["🔺", "⚫", "🔵"],
		"correct": 0
	},
	{
		"text": "Mana yang lebih besar?",
		"choices": ["6", "9", "4"],
		"correct": 1
	},
	{
		"text": "Urutan angka: 5, 6, __, 8",
		"choices": ["7", "9", "6"],
		"correct": 0
	},
	{
		"text": "Mana yang lebih kecil?",
		"choices": ["3", "7", "5"],
		"correct": 0
	},
	{
		"text": "Seret 3 apel 🍎🍎🍎 ke keranjang dengan angka 3",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "Cocokkan angka 4 dengan gambar berikut",
		"choices": ["🍌🍌🍌", "🍌🍌🍌🍌", "🍌🍌"], 
		"correct": 1
	},
	{
		"text": "Tambahkan 2 bola ⚽⚽ ke kotak yang sudah ada 3 bola ⚽⚽⚽. Total bola?",
		"choices": ["4", "5", "6"],
		"correct": 2
	},
	{
		"text": "Hapus 1 dari 5 balon 🎈🎈🎈🎈🎈. Sisa balon?",
		"choices": ["4", "3", "5"],
		"correct": 0
	},
	{
		"text": "Pilih angka yang menunjukkan jumlah bintang ⭐⭐⭐⭐",
		"choices": ["3", "4", "5"],
		"correct": 1
	},
	{
		"text": "🍇🍇\nBerapa jumlah anggur di atas?",
		"choices": ["2", "3", "4"],
		"correct": 0
	},
	{
		"text": "Yang mana 6 buah jeruk?",
		"choices": ["🍊🍊🍊", "🍊🍊🍊🍊🍊🍊", "🍊🍊🍊🍊"],
		"correct": 1
	},
	{
		"text": "Ada 3 bintang ⭐⭐⭐\nBerapa jumlah bintang?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "Angka berapa sebelum 4?",
		"choices": ["3", "5", "6"],
		"correct": 0
	},
	{
		"text": "Pilih gambar yang jumlahnya 1 🐶",
		"choices": ["🐶🐶", "🐶", "🐶🐶🐶"],
		"correct": 1
	},
	{
		"text": "1 + 2 = ?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "6 - 3 = ?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "2 + 5 = ?",
		"choices": ["6", "7", "8"],
		"correct": 1
	},
	{
		"text": "5 - 1 = ?",
		"choices": ["3", "4", "5"],
		"correct": 1
	},
	{
		"text": "3 + 4 = ?",
		"choices": ["6", "7", "8"],
		"correct": 1
	},
	{
		"text": "Lengkapi urutan angka: 2, 3, __, 5",
		"choices": ["4", "6", "3"],
		"correct": 0
	},
	{
		"text": "Polanya: 🔵⚪🔵⚪ …\nGambar selanjutnya?",
		"choices": ["🔵", "⚪", "🔴"],
		"correct": 0
	},
	{
		"text": "Mana angka yang lebih besar?",
		"choices": ["8", "5", "6"],
		"correct": 0
	},
	{
		"text": "Urutan angka: 7, 8, __, 10",
		"choices": ["9", "11", "8"],
		"correct": 0
	},
	{
		"text": "Mana yang lebih kecil?",
		"choices": ["2", "5", "7"],
		"correct": 0
	},
	{
		"text": "Seret 4 apel 🍎🍎🍎🍎 ke keranjang dengan angka 4",
		"choices": ["3", "4", "5"],
		"correct": 1
	},
	{
		"text": "Cocokkan angka 3 dengan gambar berikut",
		"choices": ["🍌🍌", "🍌🍌🍌", "🍌🍌🍌🍌"], 
		"correct": 1
	},
	{
		"text": "Tambahkan 1 bola ⚽ ke kotak yang sudah ada 2 bola ⚽⚽. Total bola?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "Hapus 2 dari 5 balon 🎈🎈🎈🎈🎈. Sisa balon?",
		"choices": ["2", "3", "4"],
		"correct": 1
	},
	{
		"text": "Pilih angka yang menunjukkan jumlah bintang ⭐⭐⭐⭐",
		"choices": ["3", "4", "5"],
		"correct": 1
	}
]


# Ambil pertanyaan acak sejumlah "count"
func get_random_questions(count: int) -> Array:
	var shuffled = all_questions.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
