import FuncUtils.{generateWiredBox, getAllObj, getTree}
import javafx.scene.Node
import javafx.scene.paint.{Color, PhongMaterial}
import javafx.scene.shape.{Box, Cylinder, DrawMode, Shape3D}

import java.io.PrintWriter
import scala.annotation.tailrec
import scala.io.Source

object IOUtils extends AuxTypes {

  private val saveLocation:String = "./lastSave.txt"
  private val options0: String = "\nChoose one option(0 to 2):\n1. Load new objects to 3D world and choose depth.\n2. Load previous save objects to 3D world.\n0. Save and Exit\n"
  private val options1: String = "\nChoose one option(0 to 5):\n1. Load new objects to 3D world and choose depth.\n2. Load previous save objects to 3D world.\n3. Redifine tree depth.\n4. Scale by factor\n5. Apply Filter\n0. Save and Exit\n"
  private val important: String = "IMPORTANT:\n- All the other options will be available once a tree of objects is loaded."

  def getSaveLocation:String = saveLocation

  def showprompt(first: Boolean = true): Unit = {
    if (first) {
      println(options0 + important)
    } else {
      println(options1 + important)
    }
    print("Option: ")
  }

  def invalidOpt():Unit = println("Invalid option. Try again.")
  def errorAtAdding():Unit = println("Oops! Couldn't add objects to worldRoot")

  @tailrec
  def getInt:Int={
    try
      scala.io.StdIn.readInt()
    catch {
      case _: NumberFormatException =>
        println("Wrong number format. Insert Integer.")
        getInt
    }
  }

  @tailrec
  def getWorldBySize: Node = {
    print("Enter World size (standard is 32): ")
    val size:Double = getDouble
    if(size<0)
      getWorldBySize
    else
      generateWiredBox((0,0,0),size)
  }


  def readPath:(Dimension,Octree[Placement])= {
    print("\nEnter file path: ")
    val filePath: String = scala.io.StdIn.readLine()
    if (!scala.reflect.io.File(filePath).exists) {
      println("Can't find file.")
      null
    } else {
      val world:Node = getWorldBySize
      val tmp:(Dimension,List[Node]) = readFromFile(filePath)
      val tmp2:(Octree[Placement],Int) = depthPart(world,tmp._2.filter(x => world.asInstanceOf[Shape3D].getBoundsInParent.contains(x.asInstanceOf[Shape3D].getBoundsInParent)))
      ((world,world,tmp2._2),tmp2._1)
    }
  }

  def getLastSavedTree:(Dimension,Octree[Placement])={
    if (!scala.reflect.io.File(saveLocation).exists) {
      println("Can't find file at "+saveLocation)
      (null,null)
    } else {
      val tmp:(Dimension,List[Node]) = readFromFile(saveLocation)
      (tmp._1,getTree(tmp._2,tmp._1._1,tmp._1._3))
    }
  }

  def depthPart(world:Node,priorNodes:List[Node]):(Octree[Placement],Int)={
    print("Define maximum tree depth integer (enter any negative Integer for unlimited depth): ")
    val depth: Int = getInt
    priorNodes match {
      case Nil => null
      case _ =>
        (getTree(priorNodes,world,depth),depth)
    }
  }

  @tailrec
  def getFilter:Int={
    print("\nChoose one filter(1 or 2):\n0. Exit \n1. RemoveGreen \n2. Serpia \nChosen Filter : ")
    try
      scala.io.StdIn.readInt()

    catch {
      case _:NumberFormatException =>
        println("Wrong number format. Insert integer between 0 and 2.")
        getFilter
    }
  }

  def getDoubleWithMessage:Double={
    print("Insert factor between 0 and 2: ")
    getDouble
  }

  @tailrec
  def getDouble:Double={
    try
      scala.io.StdIn.readDouble()
    catch {
      case _:NumberFormatException =>
        println("Wrong number format. Insert Double between 0 (non inclusive) and 2")
        getDouble
    }
  }

  def readFromFile(fileName: String): (Dimension,List[Node]) = {
    val bufferedSource = Source.fromFile(fileName)
    var figures: List[Node] = List()
    var dim:Dimension = null
    def stringToObject(texto: String): Unit = {
      val temp0: Array[String] = texto.replaceAll("[()]","").split("[ ,]")
      val figure: Node = temp0(0) match {
        case "Cylinder" =>
          new Cylinder(0.5, 1, 10)
        case "Box" =>
          new Box(1,1,1)
        case x =>
          val uni:Node = new Box(temp0(1).toDouble, temp0(2).toDouble, temp0(3).toDouble)
          uni.asInstanceOf[Box].setDrawMode(DrawMode.LINE)
          if(x.equals("Universe")) dim =  (uni,if(dim==null) null else dim._2,temp0(10).toInt)
          else dim = if(dim==null) (null,uni,-1) else (dim._1,uni,dim._3)
          uni
      }
      if(temp0.length>4) {
        figure.setTranslateX(temp0(4).toDouble)
        figure.setTranslateY(temp0(5).toDouble)
        figure.setTranslateZ(temp0(6).toDouble)
        figure.setScaleX(temp0(7).toDouble)
        figure.setScaleY(temp0(8).toDouble)
        figure.setScaleZ(temp0(9).toDouble)
      }else{
        figure.setTranslateX(0)
        figure.setTranslateY(0)
        figure.setTranslateZ(0)
        figure.setScaleX(1)
        figure.setScaleY(1)
        figure.setScaleZ(1)
      }
      if(!(figure.isInstanceOf[Box] && figure.asInstanceOf[Box].getDrawMode.equals(DrawMode.LINE))) {
        val color = new PhongMaterial()
        color.setDiffuseColor(Color.rgb(temp0(1).toInt, temp0(2).toInt, temp0(3).toInt))
        figure.asInstanceOf[Shape3D].setMaterial(color)
        figures=figures:+figure
      }
    }
    for (line <- bufferedSource.getLines){
      stringToObject(line)
    }
    bufferedSource.close
    (dim,figures)
  }

  def writeToFile(dim:Dimension, tree: Octree[Placement]):Unit = {
    @tailrec
    def writeLines(lst: List[String], p: PrintWriter): Unit = {
      lst match {
        case Nil =>
          p.close()
        case x :: xs =>
          p.write(x + '\n')
          writeLines(xs, p)
      }
    }
    val lista:List[Node] = getAllObj(tree).filter(x=> !(x.isInstanceOf[Box] && x.asInstanceOf[Box].getDrawMode.equals(DrawMode.LINE)))
    val pw = new PrintWriter(new java.io.File(saveLocation))
    //////////////////////////////////////////////////////////HANDLE CASOS NULL
    val universe:String = "Universe "+getDimension(dim._1)+commonInfo(dim._1)+" "+dim._3.toString
    val world:String = "World "+getDimension(dim._2)+commonInfo(dim._2)
    writeLines(universe::world::objsToString(lista),pw)
  }

  private def getDimension(node: Node): String = {
    val dimension = node.asInstanceOf[Box]
    "("+dimension.getWidth+","+dimension.getHeight+","+dimension.getDepth+") "
  }

  private def commonInfo(node: Node): String = {
    val strTrans:String = node.getTranslateX.toString+" "+node.getTranslateY.toString+" "+node.getTranslateZ.toString+" "
    val strScale:String = node.getScaleX.toString+" "+node.getScaleY.toString+" "+node.getScaleZ.toString
    strTrans+strScale
  }

  private def objsToString(lst: List[Node]):List[String]={
    def nodeToString(node: Node):String={
      def getRGB(node: Node): String = {
        val color = node.asInstanceOf[Shape3D].getMaterial.asInstanceOf[PhongMaterial].getDiffuseColor
        "("+(color.getRed*255).toInt+","+(color.getGreen*255).toInt+","+(color.getBlue*255).toInt+") "
      }
      node match {
        case _: Cylinder =>
          "Cylinder " + getRGB(node) + commonInfo(node)
        case _: Box =>
          "Box " + getRGB(node) + commonInfo(node)
      }
    }
    lst.foldLeft(List[String]())((acc,obj)=>acc:+nodeToString(obj))
  }
}


