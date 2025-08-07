import 'package:sqflite/sqflite.dart';

import '../../../../utils/logger.dart';
import '../../core/base_database_provider.dart';
import '../../core/base_table.dart';
import '../../providers/products_database_provider.dart';
import 'product_schema.dart';

class ProductsTable extends BaseTable<ProductSchema> {
  @override
  BaseDatabaseProvider get provider => ProductsDatabaseProvider.instance;

  @override
  String get tableName => "tbl_products";

  @override
  String get column4OrderBy => columnId;

  @override
  List<String> get columns4Query => [columnTitle, columnDescription];

  @override
  ProductSchema fromJson(json) => ProductSchema.fromJson(json);

  /// Columns
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnDescription = "description";
  static const String columnCategory = "category";
  static const String columnPrice = "price";
  static const String columnDiscountPercentage = "discount_percentage";
  static const String columnRating = "rating";
  static const String columnThumbnail = "thumbnail";
  static const String columnIsFavorite = "is_favorite";
  static const String columnCreatedAt = "created_at";
  static const String columnUpdatedAt = "updated_at";

  /// Private static instance, initialized lazily.
  ///
  static ProductsTable? _instance;

  /// Private Constructor
  ///
  ProductsTable._internal();

  /// Lazy-loaded singleton instance of this class
  ///
  static ProductsTable get instance {
    if (_instance == null) {
      Logger.logMessage("ProductsTable is initialized!");
    }
    _instance ??= ProductsTable._internal();
    return _instance!;
  }

  @override
  Future<void> createTable(Database database) async {
    database.execute(
      "CREATE TABLE IF NOT EXISTS $tableName ("
      "$columnId INTEGER PRIMARY KEY,"
      "$columnTitle TEXT,"
      "$columnDescription TEXT,"
      "$columnCategory TEXT,"
      "$columnPrice REAL,"
      "$columnDiscountPercentage REAL,"
      "$columnRating REAL,"
      "$columnThumbnail TEXT,"
      "$columnIsFavorite INTEGER,"
      "$columnCreatedAt TEXT,"
      "$columnUpdatedAt TEXT"
      ")",
    );
  }

  @override
  Future<void> migrateTable(Database db, int version) async {
    switch (version) {
      case 2:
        break;
      default:
        break;
    }
  }

  /// Method to toggle favorite status
  ///
  Future<void> toggleFavorite(ProductSchema schema) async {
    try {
      await update(schema.id!, schema.copy(isFavorite: !schema.isFavorite));
    } catch (e) {
      Logger.logError(e);
    }
  }

  /// Method to get the favorite status of given products id
  ///
  Future<Map<int, bool>> getFavoriteStatus(List<int> ids) async {
    try {
      final database = await provider.database;

      final res = await database?.query(
        tableName,
        columns: [columnId, columnIsFavorite],
        where: "$columnId IN (${ids.map((e) => '?').join(',')})",
        whereArgs: ids,
      );

      if (res == null) return {for (var id in ids) id: false};

      return {
        for (var row in res) row[columnId] as int: row[columnIsFavorite] == 1,
      };
    } catch (e) {
      Logger.logError(e.toString());
      return {for (var id in ids) id: false};
    }
  }
}
