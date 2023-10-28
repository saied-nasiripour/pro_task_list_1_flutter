import 'package:flutter/cupertino.dart';
import 'package:task_list_flutter/data/source/source.dart';

// Repository follows the DataSource rulebook
class Repository<T> extends ChangeNotifier implements DataSource<T>{

  // Constructor
  /*
  Here, we inject the `DataSource` dependency as a parameter to the `Repository` class
   */
  Repository(this.localDataSource);


  final DataSource<T> localDataSource; // Currently, Hive is used
  /*
  // like Firebase, and custom server
  final DataSource<T> remoteDataSource;
  */

  @override
  Future<T> createOrUpdate(T data) async{
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async{
    await localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async{
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async{
    await localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword=''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }

}