class Itens{
  final String id;
  final String uid;
  final String titulo;
  final String autor;
  final String editora;
  final int volume;
  final double preco;
  final String modelo;

  Itens(
    this.id,
    this.uid,
    this.titulo,
    this.autor,
    this.editora,
    this.volume,
    this.preco, 
    this.modelo  
  );

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'uid' : uid,
      'titulo' : titulo,
      'autor' : autor,
      'editora' : editora,
      'volume' : volume,
      'preco' : preco,
      'modelo' : modelo
    };
  }

  factory Itens.fromJson(Map<String, dynamic> json, String id){
    return Itens(
      id,
      json['uid'],
      json['titulo'],
      json['autor'],
      json['editora'],
      json['volume'],
      json['preco'],
      json['modelo']
    );
  }
}