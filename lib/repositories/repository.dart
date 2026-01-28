abstract class Repository<T> {
  Future<int> insert(T item);
  Future<int> update (T item , int id);
  Future<int> delete ( int id);
  Future<List<T>> getAll ();
}