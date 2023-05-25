import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/shared/app_color.dart';
import 'package:todo_app/shared/app_image.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/views/todo/add_update_todo_page.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  @override
  void initState() {
    super.initState();
    final todoProvider = Provider.of<ToDoProvider>(context, listen: false);
    todoProvider.readNote();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://c4.wallpaperflare.com/wallpaper/559/691/625/landscape-abstract-red-mountains-wallpaper-preview.jpg"))),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Your\nThings",
                        style: TextStyle(
                            fontSize: 34,
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        Utils.dateToString(DateTime.now(),
                            format: AppDateFormat.shortMonthFormat),
                        style: TextStyle(color: AppColor.whiteColor),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.whiteColor.withOpacity(0.4)),
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "${value.data?.length ?? 0}\n",
                            style: TextStyle(
                                fontSize: 24, color: AppColor.whiteColor)),
                        TextSpan(
                            text: "TODOs",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColor.whiteColor.withOpacity(0.6)))
                      ]),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await value.readNote();
                  debugPrint("refresh data");
                },
                child: value.data == null
                    ? Center(
                        child: Image.asset(
                          AppImage.emptyNote,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        itemCount: value.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var title = value.data?[index]["title"] ?? "";
                          var description =
                              value.data?[index]["description"] ?? "";
                          var lastEdit = value.data?[index]["lastEdit"];
                          var docId = value.data?[index]["docId"];
                          Timestamp? time =
                              value.data?[index]["time"] as Timestamp?;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddUpdateToDoPage(
                                        title: title,
                                        description: description,
                                        lastEdit: lastEdit,
                                        docId: docId,
                                        time: time?.toDate()),
                                  )).then((_) async {
                                await value.readNote();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0)),
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor:
                                          AppColor.red.withOpacity(0.1),
                                      child: Text(
                                        title.split("")[0].toUpperCase() ?? '-',
                                        style: TextStyle(
                                            fontSize: 25, color: AppColor.red),
                                      )),
                                  trailing: Text(
                                    time != null
                                        ? Utils.dateUTCtoLocal(time.toDate(),
                                            format:
                                                AppDateFormat.dayMonthFormat)
                                        : '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.blackColor
                                            .withOpacity(0.5)),
                                  ),
                                  title: Text(title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    description,
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: AppColor.blackColor
                                            .withOpacity(0.5)),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  visualDensity: VisualDensity.compact),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
