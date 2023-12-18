import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import './services/firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Bu satır, Flutter'ın bağlama (binding) işlemini başlatır
  await Firebase.initializeApp(  //Firebase'in çeşitli servislerini başlatır ve bu nedenle bu fonksiyonun tamamlanmasını beklemek için await anahtar kelimesi kullanılır.
  options: DefaultFirebaseOptions.currentPlatform, //Firebase servisini başlatmak için kullanılır
);
runApp(const MyApp()); // Uygulamayı başlatan Flutter fonksiyonudur
}


class MyApp extends StatelessWidget { // Bu satır, MyApp adında bir sınıf oluşturur ve bu sınıf, StatelessWidget sınıfından türetilir.StatelessWidget, uygulama içinde değişmeyen (state'i olmayan) widget'ları temsil eder
  const MyApp({super.key});//Bu satır, MyApp sınıfının yapılandırıcı methodunu tanımlar. super.key ifadesi, üst sınıftaki StatelessWidget'in yapılandırıcı metoduna bir anahtar (key) geçirme işlemini ifade eder.
  @override
  Widget build(BuildContext context) { //Bu satır, MyApp sınıfının build metodu tanımlar. build metodu, ilgili widget'ın görünümünü oluşturur ve döndürür
    return MaterialApp( // Burada, MaterialApp widget'ını ve uygulama başlığını içeren bir yapı oluşturulur.Bu widget, uygulamanın genel temasını ve davranışlarını belirleyen çeşitli özelliklere sahiptir.
      title: 'MKTKÜTÜPHANE', //Uygulamanın başlığını belirler.
      theme: ThemeData( // Uygulamanın temasını belirler.
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 223, 83, 83)),
        useMaterial3: true, //malzeme tasarımının üçüncü sürümünü (useMaterial3) etkinleştiren temel bir tema kullanılır.
      ),

      home: const MyHomePage(title: 'Mert Kağan Toy un Kütüphanesi'),  // Uygulamanın ana sayfasını belirler. MyHomePage sınıfı, uygulamanın başlangıç noktasını temsil eden bir sayfadır.
    );
  }
}

class MyHomePage extends StatefulWidget { // Bu satır, MyHomePage adında bir sınıf oluşturur ve bu sınıf, StatefulWidget sınıfından türetilir
  const MyHomePage({super.key, required this.title}); //super.key: Bu, üst sınıf olan StatefulWidget'in key parametresini alır. 
  //required this.title  Bu, MyHomePage sınıfının title adında bir zorunlu alan (required field) içerdiğini belirtir.
  final String title; // Bu satır, MyHomePage sınıfına ait olan ve title adında bir değişken tanımlar.

  @override //createState metodu, StatefulWidget sınıfındaki aynı adlı metodu geçersiz kılar.
  State<MyHomePage> createState() => _MyHomePageState();  //Bu satır, createState metodu ile birlikte State sınıfından türetilmiş özel bir durum sınıfı olan _MyHomePageState'i oluşturur.
  //Bu durum sınıfı, sayfanın iç durumunu (state) yönetir.
  //Bu kod parçası, genellikle bir uygulamanın ana sayfasını temsil eden MyHomePage sınıfını tanımlar. Bu sayfa, kullanıcıya belirli bir başlık gösterir ve 
  //iç durumu değiştirilebilir, bu nedenle StatefulWidget'den türetilmiştir. DİKKAT Stateless değil StatefulWidget
}

class _MyHomePageState extends State<MyHomePage> { // _MyHomePageState sınıfı oluştutut ve state<MyHomePage> ile MyHomePage sınıfında değişiklik yapabilir içeriğiyle ilgili
  final FirestoreService firestore = FirestoreService(); // Bu satır, _MyHomePageState sınıfında bir FirestoreService örneği oluşturur. FirestoreService, Firestore veritabanı işlemlerini yöneten bir sınıftır.
  @override
  Widget build(BuildContext context) { //Bu metot, _MyHomePageState sınıfının ana gövdesidir ve MyHomePage widget'ının görünümünü oluşturur. Bu metot, her widget yeniden çizildiğinde otomatik olarak çağrılır.
    
    return Scaffold(// Bu widget, genellikle bir uygulamanın temel yapı taşıdır. Scaffold widget'ı, genellikle bir app bar, bir body (gövde), ve bir bottomNavigationBar içerir.
      appBar: AppBar(//Sayfanın üst kısmında bulunan app bar'ı temsil eder. App bar, genellikle sayfa başlığını ve diğer ek kontrolleri içerir. Burada, app bar'ın rengi ve başlığı belirlenir.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      floatingActionButton: FloatingActionButton( //Bu, sayfa üzerinde yüzen bir eylem düğmesidir. Kullanıcı bu düğmeye tıkladığında, belirli bir işlem gerçekleştirilebilir. 
        onPressed:()=>  Navigator.push(//Burada, düğme tıklandığında Navigator.push ile Anasayfa sayfasına geçiş yapılır.
            context,
            MaterialPageRoute(builder: (context) =>Anasayfa())),
        child: const Icon(Icons.add),
      ),

      body:Container(//Sayfanın ana içeriğini temsil eder. Burada bir Container widget'ı içerisinde StreamBuilder kullanılarak Firestore veritabanındaki kitap verilerini dinleyen bir listeleme yapısı oluşturulmuştur.
        alignment: const FractionalOffset(1, 0.75), //İçeriklerin konumlandırılma düzenini belirler. Burada, sağ üst köşeye (1, 0.75) oranında konumlandırılmıştır.
        margin: const EdgeInsets.all(10), //  Dış kısımdaki boşluğu belirler. Tüm kenarlar için 10 birimlik bir boşluk bırakılmıştır.
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), //  İçerideki boşluğu belirler. Yatayda 10 birim, dikeyde 10 birim boşluk bırakılmıştır.
        constraints: const BoxConstraints(maxHeight: 900), //İçeriğin maksimum boyutunu belirler. Burada, yükseklik için maksimum 900 birim belirlenmiştir.
        child:StreamBuilder<QuerySnapshot>( //Bu widget, bir asenkron işlem olan Firestore'dan gelen veriyi dinleyerek sayfayı otomatik olarak günceller. getBook() fonksiyonu ile alınan kitap verileri üzerinde işlem yapılır.
            stream:firestore.getBook(), //stream: Firestore'dan gelen verilerin akışını temsil eder.
            builder:(context, snapshot) {  //builder: Veri geldiğinde yapılacak işlemleri içerir.
              if(snapshot.hasData){ //snapshot: Anlık veri durumunu temsil eder.,,,, hasData: Veri mevcut mu kontrol edilir.
                List bookList = snapshot.data!.docs;
                return ListView.builder( //Verilerle dinamik bir liste oluşturur. Her bir kitap için bir Container oluşturulmuş ve bu container içinde kitap adı, yazarı, sayfa sayısı gibi bilgiler görüntülenmiştir.
                  itemCount: bookList.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot document = bookList[index];
                    String bookId = document.id;
                    Map<String,dynamic> data = 
                    document.data() as Map<String,dynamic>;
                  String kitapAd = data['ad'];
                  String kitapSayfa = data['sayfa'];
                  String kitapYazar = data['yazar'];
                  bool yayin = data['liste'];
                  if (yayin==true) {
                  return Container(
                    margin: const EdgeInsets.all(3),

                    padding:const EdgeInsets.symmetric(horizontal: 0, vertical: 5),

                    decoration: BoxDecoration(

                    color:Color.fromARGB(255, 218, 17, 17) ,

                    borderRadius: BorderRadius.circular(20.0),),

                    child:ListTile(
                    title: Text(kitapAd,style:TextStyle(fontWeight: FontWeight.bold,)),

                    subtitle: Text("Yazar=> "+kitapYazar+", Sayfa Sayısı=> "+kitapSayfa,style:TextStyle(fontSize:14,)),

                    trailing:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Anasayfa()));
                      firestore.delete(bookId);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                                
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Silmek İstediğinize Emin Misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('VAZGEÇ'),
                          ),
                          TextButton(
                            onPressed: () {
                            firestore.delete(bookId);
                             Navigator.of(context).pop();
                            },
                            child: Text('EMİNİM'),
                          )
                          ]
                          );
                          }
                          );
                          },
                        )
                        ]
                        )
                        )
                        );
                        }
                  return null;
                      });
                    }
              else{
                return const Text("Kitap Ekle");
              }
            },
            ),
    ),
          bottomNavigationBar: BottomNavigationBar(//Sayfanın alt kısmında bulunan bir gezinme çubuğunu temsil eder. Burada, kitaplar, satın alma ve ayarlar için üç farklı ikonlu gezinme çubuğu bulunmaktadır.
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Kitaplar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Satın Al',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
    )
    );
  }
}
