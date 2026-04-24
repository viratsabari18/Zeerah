import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zeerah/core/providers/address_provider.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/firebase_options.dart';
import 'package:zeerah/core/providers/user_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
    // Continue anyway to avoid black screen
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
    );
  }
}
