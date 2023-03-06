import FuncUtils._
import IOUtils.{getLastSavedTree, getSaveLocation, readFromFile, writeToFile}
import javafx.collections.FXCollections
import javafx.fxml.{FXML, Initializable}
import javafx.scene.control.Alert.AlertType
import javafx.scene.control._
import javafx.scene.layout.{GridPane, HBox}
import javafx.scene.paint.Color
import javafx.scene.shape.{Box, DrawMode, Shape3D}
import javafx.scene.{Node, SubScene}
import javafx.stage.FileChooser

import java.io.File
import java.net.URL
import java.util.ResourceBundle


class Controller extends AuxTypes with Initializable{

  private var dim:(Dimension,Octree[Placement]) = _

  @FXML
  private var sbscnExistence:SubScene = _
  @FXML
  private var gridpaneSbscn:GridPane = _
  @FXML
  private var comb:ComboBox[String] = _
  @FXML
  private var hboxSize:HBox = _
  @FXML
  private var hboxDepth:HBox = _
  @FXML
  private var hboxFile:HBox = _
  private var newWorldWidgets:List[HBox] = _
  @FXML
  private var hboxScale:HBox = _
  @FXML
  private var hboxFilter:HBox = _
  @FXML
  private var hboxRDepth:HBox = _
  @FXML
  private var sliderScale:Slider = _
  private var treeOpsWidgets:List[HBox] = _
  @FXML
  private var labelLastSave:Label = _
  @FXML
  private var labelPath:Label = _
  @FXML
  private var textDepth:TextField = _
  @FXML
  private var redDepth:TextField = _
  @FXML
  private var textSize:TextField = _
  @FXML
  private  var checkboxDepth:CheckBox = _
  @FXML
  private  var checkboxSize:CheckBox = _
  @FXML
  private  var buttonExit:Button = _
  @FXML
  private var labelSliderValue:Label = _
  @FXML
  private var filters:ToggleGroup = _

  override def initialize(url: URL, resourceBundle: ResourceBundle): Unit = {
    Existence.getSubScene.widthProperty.bind(sbscnExistence.widthProperty)
    Existence.getSubScene.heightProperty.bind(sbscnExistence.heightProperty)
    sbscnExistence.widthProperty.bind(gridpaneSbscn.widthProperty)
    sbscnExistence.heightProperty.bind(gridpaneSbscn.heightProperty)
    sbscnExistence.setRoot(Existence.getStackPane)
    comb.setValue("-- Choose Option --")
    comb.setItems(FXCollections.observableArrayList("New World","Last Saved World"))
    newWorldWidgets = List(hboxDepth,hboxFile,hboxSize)
    treeOpsWidgets = List(hboxScale,hboxFilter,hboxRDepth)
  }

  def actionChooseFile():Unit={
    val fc:FileChooser = new FileChooser()
    fc.setInitialDirectory(new File("./"))
    val f:File = fc.showOpenDialog(null)
    if(f!=null && !f.getPath.equals(labelPath.getText))
      labelPath.setText(f.getPath)
  }

  def checkboxDepthAction():Unit={
    textDepth.setText("Infinite")
    textDepth.setDisable(!checkboxDepth.isSelected)
  }
  def checkboxSizeAction():Unit={
    textSize.setText("32")
    textSize.setDisable(!checkboxSize.isSelected)
  }

  def comboboxAction():Unit={
    comb.getSelectionModel.getSelectedItem match {
      case "New World" =>
        newWorldWidgets.map(x=>x.setVisible(true))
        labelLastSave.setVisible(false)
        labelLastSave.setPrefHeight(0)
      case "Last Saved World" =>
        newWorldWidgets.map(x=>x.setVisible(false))
        labelLastSave.setVisible(true)
        labelLastSave.setPrefHeight(45)
        if(!scala.reflect.io.File(getSaveLocation).exists) {
          labelLastSave.setText("No last saved file found and save location:\n"+getSaveLocation)
          labelLastSave.setTextFill(Color.RED)
        } else{
          labelLastSave.setText("Path:\n"+scala.reflect.io.File(getSaveLocation).toAbsolute.path)
          labelLastSave.setTextFill(Color.BLACK)
        }
    }
  }

  private def checkAllFields:Boolean={
    if(checkboxDepth.isSelected)
      if(!textDepth.getText.forall(Character.isDigit)) {
        errorMessage("Only non-negative integers allowed for depth.","Invalid input: Depth")
        return false
      }
    if(checkboxSize.isSelected) {
      if(!textSize.getText.forall(Character.isDigit) || textSize.getText.toInt<1) {
        errorMessage("Only positive integers allowed for world size.","Invalid input: Size")
        return false
      }
    }
    if(!scala.reflect.io.File(labelPath.getText).exists) {
      errorMessage("File doesn't exist at specified location\n"+labelPath.getText,"File not found")
      false
    }
    else true
  }

  private def errorMessage(message:String,header:String="Invalid Input"):Unit={
    val errorAlert = new Alert(AlertType.ERROR)
    errorAlert.setHeaderText(header)
    errorAlert.setContentText(message)
    errorAlert.showAndWait
  }

  private def turnSaveOpsOn():Unit={
    if(dim!=null && dim._2!=null) {
      buttonExit.setText("Save & Exit")
      treeOpsWidgets.map(x=>x.setDisable(false))
      sliderScale.setDisable(false)
    }
  }

  def sendSuffFlying(): Unit={
    comb.getSelectionModel.getSelectedItem match {
      case "New World" =>
        if(checkAllFields) {
          val depth: Int = if (checkboxDepth.isSelected) textDepth.getText.toInt else -1
          val size: Int = if (checkboxSize.isSelected) textSize.getText.toInt else 32
          Existence.resetWorld
          val world: Node = generateWiredBox((0, 0, 0), size)
          dim = ((world, world, depth), getTree(readFromFile(labelPath.getText)._2, world, depth))
          Existence.addThemAll(world :: getAllObj(dim._2))
        }
      case "Last Saved World" =>
        if(scala.reflect.io.File(getSaveLocation).exists) {
          dim = getLastSavedTree
          refreshWorld
        }
        else
          errorMessage("File not found at :\n"+getSaveLocation,"No previous save")
      case _ =>
        errorMessage("No option from loader menu selected.","Invalid Option.")
    }
    turnSaveOpsOn()
  }

  def sliderSetText:Unit={
    labelSliderValue.setText("x"+sliderScale.getValue.toString)
  }

  def scaleTree:Unit={
    val tmp:Double = sliderScale.getValue
    dim = ((generateWiredBox((0,0,0),dim._1._1.asInstanceOf[Box].getWidth*tmp),dim._1._2,dim._1._3),scaleOct(tmp,dim._2))
    refreshWorld
  }

  def applyFilter:Unit={
    filters.getSelectedToggle.asInstanceOf[RadioButton].getText match{
      case "Green Remove" => mapColourEffect(greenRemove,dim._2)
      case "Sepia" => mapColourEffect(serpia,dim._2)
    }
  }

  def newDepth:Unit= {
    if(!redDepth.getText.forall(Character.isDigit) || textSize.getText.toInt<0)
      errorMessage("Only non-negative integers allowed for depth.","Invalid input: Redefine Depth")
    else {
      val newDepth: Int = redDepth.getText.toInt
      val tmpTree: Octree[Placement] = getTree(getAllObj(dim._2).filter(x => !x.asInstanceOf[Shape3D].getDrawMode.equals(DrawMode.LINE)), dim._1._1, newDepth)
      dim = ((dim._1._1, dim._1._2, newDepth), tmpTree)
      refreshWorld
    }
  }

  def refreshWorld:Unit={
    Existence.resetWorld
    Existence.addThemAll(dim._1._2::getAllObj(dim._2).filter(x => dim._1._2.getBoundsInParent.contains(x.getBoundsInParent) || !x.asInstanceOf[Shape3D].getDrawMode.equals(DrawMode.LINE)))
  }

  def exitFunc:Unit = {
    buttonExit.getText match {
      case "Exit" => System.exit(0)
      case "Save & Exit" =>
        writeToFile(dim._1,dim._2)
        System.exit(0)
    }
  }

}
