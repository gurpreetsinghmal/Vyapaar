import 'package:mera_vyapaar/basecomponents/Myfunc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  final attendTable="attendence";
  final id= 'ID';
  final empcode = 'empcode';
  final image = 'image';
  final latitude = 'latitude';
  final longitude= 'longitude';
  final capdate= 'capdate';
  final sync = 'sync';
  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final empcodeType = 'TEXT NOT NULL';
  final imageType = 'TEXT NOT NULL';
  final latitudeType = 'TEXT NOT NULL';
  final longitudeType = 'TEXT NOT NULL';
  final capdateType = 'TEXT NOT NULL';
  final syncType = 'BOOLEAN NOT NULL';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('vyapaar.db');
    return _database!;
  }
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {


    await db.execute('''
        CREATE TABLE $attendTable (
        $id $idType,
        $empcode $empcodeType,
        $image $imageType,
        $latitude $latitudeType,
        $longitude $longitudeType,
        $capdate $capdateType,
        $sync $syncType)
        ''');
  }

  //insertion
  Future<int> insert_to_attendence(Map<String,dynamic> row) async{
    final db=await instance.database;
    return await db.insert(attendTable, row);
  }
  //updated sync
  Future<int> update_to_attendence(Map<String,dynamic> row) async{
    final db=await instance.database;
    return await db.update(attendTable,row,where: "$capdate=?",whereArgs:[row[capdate]]);
  }
  // all records
  Future<List<Map<String,dynamic>>> get_all_attendence() async{
    final db=await instance.database;
    return await db.query(attendTable,orderBy: id +" desc" ,);
  }
  // all records
  Future<List<Map<String,dynamic>>> get_custom_attendence_specdate(String d) async{

   // return await db.query(attendTable,where:"$capdate=?",whereArgs: [string_to_onlydate(date)],orderBy: id +" desc" ,);
    final db=await instance.database;
    String param=string_to_onlydate(d);
    String s="select * from $attendTable where $capdate like '$param%' order by $id desc";
    return await db.rawQuery(s);
  }
  // all some column records
  Future<Map<String,dynamic>> get_custom_attendence({required String d}) async{
    final db=await instance.database;
    String param=string_to_onlydate(d);
    String s="select $capdate,count($empcode) as c  from $attendTable where $capdate like '$param%'";
    final c=await db.rawQuery(s);
    Map<String,dynamic> data={
      "date":param,
      "count":c[0]["c"].toString()
    };
    return data;
  }
}