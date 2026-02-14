import 'package:hive_ce/hive_ce.dart';
import 'package:text_edit/note.dart';
import 'package:text_edit/task.dart';

@GenerateAdapters([AdapterSpec<Task>(), AdapterSpec<Note>()])
part 'hive_adapters.g.dart';
