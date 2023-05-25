import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/shared/app_color.dart';
import 'package:todo_app/utils/utils.dart';
import '../../service/database_service.dart';

class AddUpdateToDoPage extends StatefulWidget {
  final String? title, description, lastEdit, docId;
  final DateTime? time;

  const AddUpdateToDoPage({Key? key, this.title, this.description, this.lastEdit, this.docId, this.time})
      : super(key: key);

  @override
  AddUpdateToDoPageState createState() => AddUpdateToDoPageState();
}

class AddUpdateToDoPageState extends State<AddUpdateToDoPage> {
  late TextEditingController _title, _description;
  var lastEdit = DateFormat(AppDateFormat.fullDateTimeFormat).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.title);
    _description = TextEditingController(text: widget.description);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todoProvider = Provider.of<ToDoProvider>(context, listen: false);
      todoProvider.setDate(widget.time);
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    final ToDoProvider todoProvider = Provider.of<ToDoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                databaseProvider.deleteNote(widget.docId);
                Navigator.pop(context);
              }),
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_title.text.isNotEmpty || _description.text.isNotEmpty) {
              if (widget.docId == null) {
                databaseProvider.addNote(_title.text, _description.text, date: todoProvider.date);
              } else {
                databaseProvider.updateNote("${databaseProvider.uid}", widget.docId, _title.text, _description.text,
                    date: todoProvider.date);
              }
            } else {
              Utils.showSnackBar(context, text: "Empty note discarded");
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration:
                      BoxDecoration(color: AppColor.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: TextField(
                    controller: _title,
                    maxLines: null,
                    cursorColor: Colors.black54,
                    decoration: inputDecoration.copyWith(hintText: "Title"),
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    margin: const EdgeInsets.only(top: 1),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration:
                        BoxDecoration(color: AppColor.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(
                        todoProvider.date != null
                            ? Utils.dateToString(todoProvider.date!, format: AppDateFormat.shortMonthFormat)
                            : "Select Date",
                        style: TextStyle(
                            fontSize: 20.0,
                            color:
                                todoProvider.date != null ? Theme.of(context).colorScheme.primary : AppColor.blackColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: size.height * 0.50,
                  child: TextField(
                    controller: _description,
                    maxLines: null,
                    cursorColor: Colors.black54,
                    decoration: inputDecoration.copyWith(hintText: "Note"),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      if (_title.text.isNotEmpty || _description.text.isNotEmpty) {
                        if (widget.docId == null) {
                          await databaseProvider.addNote(_title.text, _description.text, date: todoProvider.date);
                        } else {
                          await databaseProvider.updateNote(
                              "${databaseProvider.uid}", widget.docId, _title.text, _description.text , date: todoProvider.date);
                        }
                      } else {
                        Utils.showSnackBar(context, text: "Empty note discarded");
                      }
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text("Add your thing".toUpperCase()))),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Last Edit ${widget.lastEdit ?? lastEdit} "),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    FocusScope.of(context).unfocus();
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1000)));

    if (!mounted) return;
    context.read<ToDoProvider>().setDate(selectedDate);
  }
}

const inputDecoration = InputDecoration(border: InputBorder.none);
