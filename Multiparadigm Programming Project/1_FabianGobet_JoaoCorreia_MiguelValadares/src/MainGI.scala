import javafx.application.Application
import javafx.fxml.FXMLLoader
import javafx.scene.{Parent, PerspectiveCamera, Scene}
import javafx.stage.Stage

class MainGI extends Application {
  override def start(primaryStage: Stage): Unit = {
    primaryStage.setTitle("My Main App")
    val fxmlLoader =
      new FXMLLoader(getClass.getResource("Controller.fxml"))
    val mainViewRoot: Parent = fxmlLoader.load()
    val scene = new Scene(mainViewRoot)
    scene.setCamera(new PerspectiveCamera(false))
    primaryStage.setScene(scene)
    primaryStage.setMinWidth(600)
    primaryStage.setMinHeight(500)
    primaryStage.show()
  }
}

object FxAppGI {
  def main(args: Array[String]): Unit = {
    Application.launch(classOf[MainGI], args: _*)
  }
}