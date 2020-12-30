import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/database/connection.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';
import 'app/database/migrations/database_adm_connection.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseAdmConnection databaseAdmConnection = DatabaseAdmConnection();

  @override
  void initState() {
    super.initState();
    Connection().instance;
    WidgetsBinding.instance.addObserver(databaseAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(databaseAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF9129),
      statusBarBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodosRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Todo List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoCondensedTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;
                  return NewTaskController(repository: context.read<TodosRepository>(), day: day);
                },
                child: NewTaskPage(),
              )
        },
        home: ChangeNotifierProvider(
          create: (context) {
            // ! Anterior a 4.1
            //var repository = Provider.of<TodosRepository>(context);

            // ! A Partir da 4.1
            var repository = context.read<TodosRepository>();
            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
