import FuncUtils.getAllObj
import IOUtils.{Placement, errorAtAdding}
import javafx.application.Application
import javafx.scene.shape.{DrawMode, Shape3D}
import javafx.scene.{Node, Scene, SceneAntialiasing}
import javafx.stage.Stage

class Main extends Application with AuxTypes{


  override def start(stage: Stage): Unit = {

    val ls:(Dimension,Octree[Placement]) = MainLoop.loop()
    if (ls._1!=null && !Existence.addThemAll(ls._1._2 :: getAllObj(ls._2).filter(x => ls._1._2.getBoundsInParent.contains(x.getBoundsInParent) || !x.asInstanceOf[Shape3D].getDrawMode.equals(DrawMode.LINE))))
      errorAtAdding
    val scene = new Scene(Existence.getStackPane, 810, 610, true, SceneAntialiasing.BALANCED)
    Existence.getSubScene.widthProperty.bind(Existence.getStackPane.widthProperty)
    Existence.getSubScene.heightProperty.bind(Existence.getStackPane.heightProperty)
    stage.setTitle("PPM Project 21/22")
    stage.setScene(scene)
    stage.show()


  }

  override def init(): Unit = {
  }

  override def stop(): Unit = {
  }

}

object FxAppTUI{

  def main(args: Array[String]): Unit = {
    Application.launch(classOf[Main], args: _*)
  }
}
