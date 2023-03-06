import javafx.geometry.{Insets, Pos}
import javafx.scene.layout.StackPane
import javafx.scene.paint.{Color, PhongMaterial}
import javafx.scene.shape.{Box, Cylinder, DrawMode, Line}
import javafx.scene.transform.Rotate
import javafx.scene.{Group, Node, PerspectiveCamera, SceneAntialiasing, SubScene}

object Existence extends AuxMaterials {


  //3D objects
  private val lineX = new Line(0, 0, 200, 0)
  lineX.setStroke(Color.GREEN)

  private val lineY = new Line(0, 0, 0, 200)
  lineY.setStroke(Color.YELLOW)

  private val lineZ = new Line(0, 0, 200, 0)
  lineZ.setStroke(Color.LIGHTSALMON)
  lineZ.getTransforms.add(new Rotate(-90, 0, 0, 0, Rotate.Y_AXIS))

  private val camVolume = new Cylinder(10, 50, 10)
  camVolume.setTranslateX(1)
  camVolume.getTransforms.add(new Rotate(45, 0, 0, 0, Rotate.X_AXIS))
  camVolume.setMaterial(blueMaterial)
  camVolume.setDrawMode(DrawMode.LINE)


  // 3D objects (group of nodes - javafx.scene.Node) that will be provide to the subScene
  private val worldRoot:Group = new Group(camVolume, lineX, lineY, lineZ)
  private val base:List[Node] = List[Node](camVolume, lineX, lineY, lineZ)

  // Camera
  private val camera = new PerspectiveCamera(true)

  private val cameraTransform = new CameraTransformer
  cameraTransform.setTranslate(0, 0, 0)
  cameraTransform.getChildren.add(camera)
  camera.setNearClip(0.1)
  camera.setFarClip(10000.0)

  camera.setTranslateZ(-500)
  camera.setFieldOfView(20)
  cameraTransform.ry.setAngle(-45.0)
  cameraTransform.rx.setAngle(-45.0)
  worldRoot.getChildren.add(cameraTransform)

  private val subsc:SubScene = new SubScene(worldRoot,200,200,true,SceneAntialiasing.BALANCED)
  subsc.setFill(Color.DARKSLATEGRAY)
  subsc.setCamera(camera)


  private val cameraView = new CameraView(subsc)
  cameraView.setFirstPersonNavigationEabled(true)
  cameraView.setFitWidth(350)
  cameraView.setFitHeight(225)
  cameraView.getRx.setAngle(-45)
  cameraView.getT.setZ(-100)
  cameraView.getT.setY(-500)
  cameraView.getCamera.setTranslateZ(-50)
  cameraView.startViewing()


  // Position of the CameraView: Right-bottom corner
  StackPane.setAlignment(cameraView, Pos.TOP_LEFT)
  StackPane.setMargin(cameraView, new Insets(5))
  val stpn:StackPane = new StackPane(subsc,cameraView)


  stpn.setOnMouseClicked(event => {
    event.getButton.toString match {
      case "PRIMARY" => camVolume.setTranslateX(camVolume.getTranslateX + 2)
      case "SECONDARY" => camVolume.setTranslateX(camVolume.getTranslateX - 2)
      case _ =>
    }
    wireColor
  })


  def wireColor: Unit={
    worldRoot.getChildren.toArray.map(n => {
      n match {
        case x:Box if(x.getDrawMode.equals(DrawMode.LINE)) =>
          if(x.getBoundsInParent.intersects(camVolume.getBoundsInParent)) x.setMaterial(greenMaterial)
          else x.setMaterial(redMaterial)
        case _ => n
      }
    })
  }

  def resetWorld:Unit={
    worldRoot.getChildren.removeIf(x=> !base.contains(x))
  }

  def addThemAll(lst:List[Node]):Boolean= {
    val b:Boolean=lst.foldLeft(true)((acc,n) =>acc && worldRoot.getChildren.add(n))
    wireColor
    b
  }

  def getWorldRoot:Group = worldRoot
  def getStackPane: StackPane = stpn
  def getSubScene:SubScene = subsc


}
