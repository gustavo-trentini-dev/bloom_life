class Tree{
  String _treeName;
  String _treeSpecie;
  String _treeBirth;

  Tree(this._treeName,this._treeSpecie,this._treeBirth);

  Tree.map(dynamic obj){
    this._treeName = obj['tree_name'];
    this._treeSpecie = obj['tree_specie'];
    this._treeBirth = obj['tree_birth'];
  }

  String get treeName => _treeName;
  String get treeSpecie  => _treeSpecie;
  String get treeBirth => _treeBirth;

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['tree_name'] = _treeName;
    map['tree_specie'] = _treeSpecie;
    map['tree_birth'] = _treeBirth;
    return map;
  }

  Tree.fromMap(Map<String,dynamic> map){
    this._treeName = map['tree_name'];
    this._treeSpecie = map['tree_specie'];
    this._treeBirth = map['tree_birth'];
  }
}