class DatabaseCustomException  implements Exception{
  final String massage;
  DatabaseCustomException(this.massage);
  
  @override
  String toString()=>massage;

}