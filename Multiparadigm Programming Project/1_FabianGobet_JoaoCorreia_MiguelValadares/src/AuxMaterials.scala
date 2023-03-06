import javafx.scene.paint.{Color, PhongMaterial}

trait AuxMaterials {

  //Materials to be applied to the 3D objects
  val redMaterial = new PhongMaterial()
  redMaterial.setDiffuseColor(Color.rgb(150,0,0))

  val greenMaterial = new PhongMaterial()
  greenMaterial.setDiffuseColor(Color.rgb(0,255,255))

  val blueMaterial = new PhongMaterial()
  blueMaterial.setDiffuseColor(Color.rgb(0,0,150))
}
