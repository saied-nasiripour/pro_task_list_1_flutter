
// This is the Data Source rulebook (interface) --- (like a dance rulebook)
abstract class DataSource<T> {
  Future<List<T>> getAll({String searchKeyword}); // return (or get) all task as output
  Future<T> findById(dynamic id); // Find (or get) an item based on ID number and return an item as output
  Future<void> deleteAll(); // delete all items in the DataSource
  Future<void> delete(T data); // in the DataSource
  Future<void> deleteById(dynamic id); // Delete based on ID
  Future<T> createOrUpdate(T data); // If it exists in the DataSource, update it, otherwise create it
}