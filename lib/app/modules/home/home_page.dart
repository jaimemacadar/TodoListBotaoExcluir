import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, Widget _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectedTab,
            onSelectTab: (index) => controller.changeSelectedTab(context, index),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar Data',
              )
            ],
            theme: FFNavigationBarTheme(
                itemWidth: 60,
                barHeight: 70,
                barBackgroundColor: Theme.of(context).primaryColor,
                unselectedItemIconColor: Colors.white,
                unselectedItemLabelColor: Colors.white,
                selectedItemBorderColor: Colors.white,
                selectedItemIconColor: Colors.white,
                selectedItemBackgroundColor: Theme.of(context).primaryColor,
                selectedItemLabelColor: Colors.black),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: controller.listTodos?.keys?.length ?? 0,
                itemBuilder: (_, index) {
                  var dateFormat = DateFormat('dd/MM/yyyy');
                  var listTodos = controller.listTodos;
                  var daykey = listTodos.keys.elementAt(index);
                  var day = daykey;
                  var todos = listTodos[daykey];

                  if (todos.isEmpty && controller.selectedTab == 0) {
                    return SizedBox.shrink();
                  }

                  var today = DateTime.now();
                  if (daykey == dateFormat.format(today)) {
                    day = 'HOJE';
                  } else if (daykey == dateFormat.format(today.add(Duration(days: 1)))) {
                    day = 'AMANHÃ';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            IconButton(
                                onPressed: () async {
                                  await Navigator.of(context).pushNamed(NewTaskPage.routerName, arguments: daykey);
                                  controller.update();
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: todos.length,
                          itemBuilder: (_, index) {
                            var todo = todos[index];
                            return ListTile(
                              leading: Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                value: todo.finalizado,
                                onChanged: (bool value) => controller.checkedOrUncheck(todo),
                              ),
                              title: Text(
                                todo.descricao,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              trailing: Container(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        decoration: todo.finalizado ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => controller.deleteTodo(todo),
                                      child: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}
