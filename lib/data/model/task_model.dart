import 'package:hive_flutter/adapters.dart';

// custom adapter to serialize and deserialize complex objects for storage in Hive.
part 'task_model.g.dart'; // Adapter
/*
In the context of Hive or other data storage libraries, an "adapter" is a software component responsible for facilitating the conversion of complex data structures, objects, or models into a format that can be stored in a database or serialized for transmission over a network.
Adapters are commonly used in object-relational mapping (ORM) or object-document mapping (ODM) frameworks to bridge the gap between application code and data storage.

Here's a more detailed explanation of what an adapter does:
1- Serialization: An adapter is responsible for serializing (converting) complex objects or data structures into a format that can be easily stored or transmitted. This typically involves converting objects into a simpler representation, such as binary data or JSON.
2- Deserialization: Conversely, an adapter also handles the deserialization process, which is the reverse of serialization. It takes stored or transmitted data and reconstructs complex objects or data structures from that data.
3- Mapping: Adapters often involve mapping the fields or properties of objects to corresponding fields in a database or serialized format. This mapping ensures that data is correctly stored and retrieved.
4- Data Type Conversion: Adapters may handle data type conversions, ensuring that data types used in the application code match those expected by the storage or transmission format.
5- Customization: In many cases, custom adapters can be created to handle specific types of data or complex object structures. These adapters allow developers to define how their custom objects should be serialized and deserialized.

In the context of Hive (a local NoSQL database library for Flutter and Dart),
adapters are used to define how specific Dart classes or objects should be serialized and deserialized for storage in the Hive database.
Hive adapters implement the `TypeAdapter` interface and provide `read` and `write` methods for handling the serialization and deserialization process.
This customization is necessary when working with non-primitive data types or complex data structures that require special handling for storage and retrieval.
* */

// Define a Hive data model class
@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  int id = -1;
  @HiveField(0)
  String name='';
  @HiveField(1)
  bool isCompleted=false;
  @HiveField(2)
  Priority priority = Priority.low;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high
}