import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refresh_page/MyLoading.dart';
import 'package:refresh_page/User.dart';
import 'package:refresh_page/theme_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(theme: ThemeData()));
}

class MyApp extends StatelessWidget {
  MyApp({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: theme,
      builder: (_, theme) {
        return const MaterialApp(
          title: 'Localizations Sample App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('fa'), // farsi
          ],
          debugShowCheckedModeBanner: false,
          //theme: theme,
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  List<User> users = [];

  getUsers() async {
    setState(() {
      users.clear();
    });
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      users.addAll(FactoryData.users);
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("bio list"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: refreshController,
        header: WaterDropHeader(
          waterDropColor: Colors.deepPurple,
          refresh: MyLoading(),
          complete: Container(),
          completeDuration: Duration.zero,
        ),
        onRefresh: () => getUsers(),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) => item(users[index]),
        ),
      ),
    );
  }

  Widget item(User user) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: user.photo,
        imageBuilder: (context, imageProvider) => Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => SizedBox(
          height: 40,
          width: 40,
          child: MyLoading(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: () {},
    );
  }
}

class User {
  int id;
  String name, email, photo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });
}

class FactoryData {
  static List<User> users = [
    User(
      id: 1,
      name: "Yasin Mohammadi",
      email: "yasin.mohammadi@gmail.com",
      photo:
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    ),
    User(
      id: 2,
      name: "Zahra Karimi",
      email: "zahra.karimi@hotmail.com",
      photo:
          "https://images.unsplash.com/photo-1532074205216-d0e1f4b87368?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwcm9maWxlfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
    ),
    User(
      id: 3,
      name: "Zaman Ghulami",
      email: "zaman.ghulami@hotmail.com",
      photo:
          "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
    ),
    User(
      id: 4,
      name: "Sardar Omid",
      email: "sardar.omid@gmail.com",
      photo:
          "https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    ),
    User(
      id: 5,
      name: "Naim Mohammadi",
      email: "naim.mohammadi@afsat.af",
      photo:
          "https://i.pinimg.com/236x/a6/29/02/a62902c0458a23d705492bb701371a43--cool-wallpapers-for-iphone-wallpaper-for-iphone.jpg",
    ),
    User(
      id: 6,
      name: "Baqir Amiri",
      email: "baqir.amiri@gmail.com",
      photo:
          "https://i.pinimg.com/originals/2a/36/ad/2a36add932afa93c3c332b64e6298f2f.jpg",
    ),
    User(
      id: 7,
      name: "Reza Qazi zada",
      email: "reza.qazi.zada@kabul.af",
      photo:
          "https://www.adobe.com/express/create/media_1c6fc2df39cf891716e5986fbfed3870ea73e4a81.jpeg?width=400&format=jpeg&optimize=medium",
    ),
  ];
}

class MyLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
        ),
      ),
    );
  }
}
