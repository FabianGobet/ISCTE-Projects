class Model {
  String label;
  double min;
  double max;
  double value;
  String id;
  double initialValue;
  double oldValue;

  Model(this.label, this.min, this.max, this.value, this.id, this.initialValue,this.oldValue);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['min'] = min;
    data['max'] = max;
    data['value'] = value;
    data['id'] = id;
    data['initialValue'] = initialValue;
    return data;
  }
}
