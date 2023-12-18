import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {  //FirestoreService adında bir Dart sınıfı oluşturuluyor.
  final CollectionReference booksCollection = //Firestore veritabanındaki 'books' koleksiyonuna erişimi temsil eden bir CollectionReference nesnesi oluşturuluyor.
      FirebaseFirestore.instance.collection('books');

  Stream<QuerySnapshot> getBook() { //getBook fonksiyonu, 'books' koleksiyonundaki değişiklikleri dinleyen ve bir Stream döndüren bir fonksiyondur. Bu Stream, QuerySnapshot tipinde veriler içerir.
    return booksCollection.snapshots();
  }

//
//

  Future<void> addBook(Map<String, dynamic> book) { //addBook fonksiyonu, parametre olarak alınan book haritasını 'books' koleksiyonuna eklemek için kullanılır. Ekledikten sonra bir Future nesnesi döner.
    return booksCollection.add(book);
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> book) { //updateBook fonksiyonu, belirli bir bookId ile belirtilen belirli bir kitabı güncellemek için kullanılır. book haritasındaki verilerle güncelleme yapar.
    return booksCollection.doc(bookId).update(book);
  }

  Future<void> delete(String bookId) { //delete fonksiyonu, belirli bir bookId ile belirtilen belirli bir kitabı 'books' koleksiyonundan silmek için kullanılır.
    return booksCollection.doc(bookId).delete();
  }
}

