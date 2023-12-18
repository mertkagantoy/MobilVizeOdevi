import 'package:bookapp/main.dart';
import 'package:bookapp/services/firestore.dart';
import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget { // Anasayfa sınıfı, bir State nesnesi oluşturmak üzere StatefulWidget sınıfından türetilmiştir.
  
  @override
  State<Anasayfa> createState() => _AnasayfaState(); // createState() metodu, Anasayfa sınıfının bir durum nesnesi oluşturmasını sağlar.
}


class _AnasayfaState extends State<Anasayfa> { // _AnasayfaState sınıfı, Anasayfa sınıfının durumunu yönetmek için kullanılır.
  Map<String, dynamic> kitap = {}; // // 'kitap' adında bir Map, kitap bilgilerini depolamak için kullanılır. Başlangıçta boş bir Map olarak tanımlanmıştır.
  bool shouldPublish = false; //// 'shouldPublish', bir kitabın yayınlanıp yayınlanmayacağını belirten bir boolean değeridir.
  bool intDenetleyici = false;

  final FirestoreService firestore = FirestoreService(); // // 'firestore', FirestoreService sınıfından bir nesnedir. Firestore ile etkileşim için kullanılır.
  final TextEditingController adController = TextEditingController();
  final TextEditingController yayinController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController yazarController = TextEditingController();
  final TextEditingController sayfaController = TextEditingController();
  final TextEditingController basimController = TextEditingController();
  final TextEditingController listeController = TextEditingController();

  // Yukarıdaki TextEditingController'lar, kullanıcıdan alınan metin girişlerini kontrol etmek için kullanılır.
  // Her biri bir form alanını temsil eder (örneğin, kitap adı, yazar adı, vb.).
  //?******************************************************
    void dispose() {// dispose metodu, State nesnesi yok edildiğinde kullanılan bir metodur. Burada, TextEditingController'ların
  // kaynaklarını serbest bırakmak için kullanılmıştır.
    adController.dispose();
    yayinController.dispose();
    kategoriController.dispose();
    yazarController.dispose();
    sayfaController.dispose();
    basimController.dispose();
    listeController.dispose();
    super.dispose();
  }
  //************************************************************************************************************** */

  @override
  Widget build(BuildContext context) { // build metodu, widget'ın kullanıcı arayüzünü oluşturmak için kullanılır.
    
    return Container( // Container, diğer widget'ları düzenlemek ve stil vermek için kullanılan bir konteynerdir
      height: 6000, // Container'ın yüksekliği 6000 piksel olarak ayarlanmıştır.
      color: Colors.white, // Container'ın arkaplan rengi beyaz olarak ayarlanmıştır.
      alignment: const FractionalOffset(0.5, 0.75),  // Container içindeki içeriğin hizalaması belirlenmiştir
      margin: const EdgeInsets.all(0), // Container'ın kenar boşlukları (margin) sıfır olarak ayarlanmıştır.
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Container içindeki içeriğin kenar boşlukları (padding) ayarlanmıştır.
      constraints: const BoxConstraints(maxHeight: 500), // Container'ın maksimum yüksekliği 500 piksel olarak sınırlanmıştır.
      //************************* */
      child:Scaffold( // Scaffold, temel materyal tasarım yapısını sağlayan bir widget'tır.
        appBar: AppBar( // AppBar, sayfa başlığını ve diğer üst bilgileri içeren bir app barı oluşturur.
          automaticallyImplyLeading: false, // Otomatik olarak geri düğmesini gösterme özelliği kapatılmıştır.
          title: const Text("Kitap Ekle veya Düzenle"), // AppBar'ın başlık kısmına "Kitap Ekle veya Düzenle" metni eklenmiştir.
          actions: [ // AppBar'ın sağ tarafına eklenen eylemler (actions).
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Geri dönme işlemi
              },
            ),
          ], 
        ),

          //********************************************************************** */

        body: Center( // Center widget'ı, içindeki child widget'ları merkeze hizalar.
        child: Column( // Column widget'ı, dikey yönde bir sütun oluşturur.
          mainAxisAlignment: MainAxisAlignment.center, // Column içindeki child widget'ların dikey hizalaması, orta hizaya alınmıştır.
          
          children:<Widget>[ // Column içinde bulunan çocuk widget'larını tanımlayan liste başlıyor.
            TextField(
              controller: adController, // TextField, metin girişini almak için kullanılır. adController, bu TextField'ın kontrolcüsüdür.
              obscureText: false, // Metni gizleme özelliği kapalı.
              decoration: const InputDecoration( // ad bilgisini girmek için bir giriş alanı oluşturulmuştur.
              border: UnderlineInputBorder(), // border, TextField'ın etrafındaki çerçeve veya kenarlık stilini belirler.
              // UnderlineInputBorder, alt çizgili bir çerçeve kullanılmasını sağlar
              labelText: 'Kitap adı',), //// labelText, TextField'ın üzerinde görünen açıklama metnidir.
              onChanged:(value) { // onChanged, TextField içindeki metin her değiştiğinde çağrılır.
                kitap['ad'] = value; // / Değişen metni kitap haritasındaki 'ad' anahtarına atar.

              },
            ),
            //****************************************************************************************************** */
             TextField(
              controller: yayinController, // Bir başka TextField widget'ı. yayinController, bu TextField'ın kontrolcüsüdür.
              obscureText: false, // Metni gizleme özelliği kapalı.
              decoration: const InputDecoration( // Yayınevi bilgisini girmek için bir giriş alanı oluşturulmuştur.
              border: UnderlineInputBorder(),
              labelText: 'Yayınevi',),
              onChanged:(value) { // onChanged, TextField içindeki metin her değiştiğinde çağrılır.
                kitap['yayin'] = value; // Değişen metni kitap haritasındaki 'yayin' anahtarına atar.
              },
            ),
            //******************************************************************************* */

            DropdownButtonFormField( // DropdownButtonFormField, bir açılır menü (dropdown) oluşturan bir form alanıdır.
              hint: const Text("Kategori Seç"),items: const [ // hint, açılır menüde varsayılan olarak görünen metni belirtir. Kullanıcı seçim yapmadığında gösterilir
              //  Bu durumda, "Kategori Seç" metni kullanıcının bir kategori seçmesi gerektiğini belirtir.
              // items, açılır menünün içinde bulunan öğeleri (DropdownMenuItem'ları) belirtir.

              DropdownMenuItem(value: "Roman",child: Text("Roman"),), // Birinci öğe: "Roman" değeriyle ve içinde "Roman" yazan bir DropdownMenuItem.
              DropdownMenuItem(value: "Tarih",child: Text("Tarih"),), // İkinci öğe: "Tarih" değeriyle ve içinde "Tarih" yazan bir DropdownMenuItem.
              DropdownMenuItem(value: "Edebiyat",child: Text("Edebiyat"),), // Üçüncü öğe: "Edebiyat" değeriyle ve içinde "Edebiyat" yazan bir DropdownMenuItem.
              DropdownMenuItem(value: "Şiir",child: Text("Şiir"),), // Dördüncü öğe: "Şiir" değeriyle ve içinde "Şiir" yazan bir DropdownMenuItem.
              DropdownMenuItem(value: "Ansiklopedi",child: Text("Ansiklopedi"),), // Beşinci öğe: "Ansiklopedi" değeriyle ve içinde "Ansiklopedi" yazan bir DropdownMenuItem.
            ],onChanged: (value) => {kitap['kategori']=value}  // onChanged, kullanıcı bir seçim yaptığında tetiklenen bir fonksiyondur.
            //                                                  // Burada, kullanıcının seçtiği değeri 'kategori' anahtarına atayarak kitap haritasını güncelliyoruz.
            ),

            //************************************************************************** */
            TextField(
              controller: yazarController,
              obscureText: false,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Yazarlar',),
              onChanged:(value) {
                kitap['yazar'] = value;
              },
            ),
            //***************************************************************************** */
            TextField(
              controller: sayfaController,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Sayfa Sayısı',),
              onChanged:(value) { // onChanged, TextField içindeki metin her değiştiğinde çağrılır.
                if (value.isNotEmpty) { // Eğer giriş alanı boş değilse:
                  if (int.tryParse(value) == null) { // Eğer girilen değer bir sayıya dönüştürülemezse:
                    intDenetleyici = true; // intDenetleyici'yi true olarak ayarla. Bu, kullanıcıya geçerli bir sayı girmesi gerektiğini belirten bir kontrol mekanizmasıdır
                  }
                    else{kitap['sayfa'] = value; // kitap haritasındaki 'sayfa' anahtarına, kullanıcının girdiği sayfa sayısını ata.
                    intDenetleyici=false;} // intDenetleyici'yi false olarak ayarla, çünkü geçerli bir sayı girişi yapılmıştır.
                
              }
              }
            ),

            //******************************************************************************************* */
            TextField(
              controller: basimController,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Basım Yılı',),
              onChanged:(value) { // onChanged, TextField içindeki metin her değiştiğinde çağrılır.
                if (value.isNotEmpty) { // Eğer giriş alanı boş değilse:
                  if (int.tryParse(value) == null) { // Eğer girilen değer bir sayıya dönüştürülemezse:
                    intDenetleyici = true; // intDenetleyici'yi true olarak ayarla. Bu, kullanıcıya geçerli bir sayı girmesi gerektiğini belirten bir kontrol mekanizmasıdır
                  }
                    else{kitap['yil'] = value; // kitap haritasındaki 'sayfa' anahtarına, kullanıcının girdiği sayfa sayısını at
                    intDenetleyici=false;} // intDenetleyici'yi false olarak ayarla, çünkü geçerli bir sayı girişi yapılmıştır
                
              }
              },
            ),

            //******************************************************************* */
            CheckboxListTile( // CheckboxListTile, bir onay kutusu (checkbox) ve başlık içeren bir liste öğesidir.
            title: Text('Kitap Yayınlansın mı?'), // CheckboxListTile'ın başlığını belirler. Bu durumda, "Kitap Yayınlansın mı?" metni görünecektir.
            value: shouldPublish, // CheckboxListTile'ın mevcut durumunu belirler. shouldPublish, kitabın yayınlanıp yayınlanmayacağını tutan bir boolean değerdir.
            onChanged: (bool? newValue) { // onChanged, kullanıcı onay kutusunu değiştirdiğinde çağrılır
              setState(() {
                shouldPublish = newValue ?? false; // onChanged, kullanıcı onay kutusunu değiştirdiğinde çağrılır
              });
              kitap['liste'] = shouldPublish;} // kitap haritasındaki 'liste' anahtarına, kullanıcının seçtiği yayın durumunu atar.
              ),
            ElevatedButton(onPressed: ()=>{ // ElevatedButton, yüksek öncelikli bir düğme oluşturan bir widget'tır.

              if(int.tryParse(kitap['sayfa'])==null|| int.tryParse(kitap['yil']) ==null){ // Sayfa sayısı veya yayın yılı bir sayıya dönüştürülemezse:
              //                                                                          // Burada yapılacak bir şey yok, ancak bir şeyler eklenirse buraya eklenir.
              }
              else{
              if(kitap['ad']==null){
                kitap['ad'] = 'Tanımlanmadı'
              },
              if(kitap['yayin']==null){
                kitap['yayin'] = 'Tanımlanmadı'
              },
              if(kitap['yazar']==null){
                kitap['yazar']="Tanımlanmadı"
              },
              if(kitap['kategori']==null){
                kitap['kategori']="Tanımlanmadı"
              },
              if(kitap['liste']==null){
                kitap['liste']=false
              },
            firestore.addBook(kitap), // FirestoreService sınıfındaki addBook metodu kullanılarak kitap bilgileri Firestore veritabanına eklenir.
            Navigator.push(  // Navigator ile bir sonraki sayfaya geçiş yapılır (MyApp sayfasına).
              context,
              MaterialPageRoute(builder: (context) =>MyApp()))
              },
        }, child: Text("Kaydet"),), // ElevatedButton'ın üzerindeki metni belirler. Bu durumda "Kaydet" metni görünecektir.
  ],
        ),
        
      ),
      ),
    );
  }
}