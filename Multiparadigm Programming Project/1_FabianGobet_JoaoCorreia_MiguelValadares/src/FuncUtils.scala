import IOUtils.{depthPart, getFilter}
import javafx.scene.Node
import javafx.scene.paint.{Color, PhongMaterial}
import javafx.scene.shape.{Box, DrawMode, Shape3D}

import scala.annotation.tailrec

object FuncUtils extends AuxTypes with AuxMaterials{

  def getTree(objList:List[Node],cube:Node,depth:Int):Octree[Placement]=getTree(objList,cube.asInstanceOf[Box],depth)
  def getTree(objList:List[Node],cube:Box,depth:Int = -1):Octree[Placement]={
    val intrct:List[Node] = objList.filter(x=>cube.getBoundsInParent.contains(x.asInstanceOf[Shape3D].getBoundsInParent))
    intrct match {
      case Nil=> OcEmpty
      case _=>
        val caixas:List[Node] = caixinhas(cube)
        val place:Placement = ((cube.getTranslateX-cube.getWidth/2,cube.getTranslateY-cube.getHeight/2,cube.getTranslateZ-cube.getDepth/2),cube.getWidth)
        if (intrct.foldLeft(true)((acc,nod)=>acc && isInOne(caixas,nod)) && depth!=0)
          new OcNode[Placement](place,
            getTree(intrct,getLittleBox(cube,(0,0,1)),depth-1),
            getTree(intrct,getLittleBox(cube,(0,1,1)),depth-1),
            getTree(intrct,getLittleBox(cube,(1,0,1)),depth-1),
            getTree(intrct,getLittleBox(cube,(1,1,1)),depth-1),
            getTree(intrct,getLittleBox(cube,(0,0,0)),depth-1),
            getTree(intrct,getLittleBox(cube,(0,1,0)),depth-1),
            getTree(intrct,getLittleBox(cube,(1,0,0)),depth-1),
            getTree(intrct,getLittleBox(cube,(1,1,0)),depth-1)
          )
        else
          OcLeaf[Placement,Section]((place,intrct))
    }
  }


  def getLittleBox(greatBox:Box,tpl:(Int,Int,Int)):Box={
    val side = greatBox.getWidth
    val newBox = new Box(side/2,side/2,side/2)
    newBox.setTranslateX(greatBox.getTranslateX+side*((tpl._1/2.0)-0.25))
    newBox.setTranslateY(greatBox.getTranslateY+side*((tpl._2/2.0)-0.25))
    newBox.setTranslateZ(greatBox.getTranslateZ+side*((tpl._3/2.0)-0.25))
    newBox
  }
  private def caixinhas(box: Box, x:(Int,Int,Int)=null): List[Box]={
    x match {
      case null =>
        List((0,0,0),(0,0,1),(0,1,0),(0,1,1),(1,0,0),(1,0,1),(1,1,0),(1,1,1)).map(x=>getLittleBox(box,x))
      case _ => List(getLittleBox(box,x))
    }
  }

  @tailrec
  private def isInOne(list: List[Node],obj: Node): Boolean ={
    list match {
      case Nil => false
      case x::xs =>
        if(x.asInstanceOf[Shape3D].getBoundsInParent.contains(obj.asInstanceOf[Shape3D].getBoundsInParent))
          true
        else
          isInOne(xs,obj)
    }
  }

  def generateWiredBox(place: Placement):Node={
    val side:Double = place._2
    val box:Node = new Box(side,side,side)
    box.setTranslateX(side/2+place._1._1)
    box.setTranslateY(side/2+place._1._2)
    box.setTranslateZ(side/2+place._1._3)
    box.asInstanceOf[Box].setDrawMode(DrawMode.LINE)
    box
  }

  def redefineDepth(tree: Octree[Placement]):(Octree[Placement],Int)={
    val lst:List[Node] = getAllObj(tree).filter(x=> !x.asInstanceOf[Shape3D].getDrawMode.equals(DrawMode.LINE))
    tree match {
      case OcNode(place,_,_,_,_,_,_,_,_) =>
        depthPart(generateWiredBox(place),lst)
      case OcLeaf(section) =>
        depthPart(generateWiredBox(section.asInstanceOf[Section]._1),lst)
    }
  }



  def getAllObj(tree: Octree[Placement]): List[Node] ={
    tree match {
      case OcNode(place,a,b,c,d,e,f,g,h)=>
        generateWiredBox(place)::getAllObj(a)++getAllObj(b)++getAllObj(c)++getAllObj(d)++getAllObj(e)++getAllObj(f)++getAllObj(g)++getAllObj(h)
      case OcLeaf(section) =>
        generateWiredBox(section.asInstanceOf[Section]._1)::section.asInstanceOf[Section]._2
      case OcEmpty =>
        List()
    }
  }

  private def getMaxDepth(tree: Octree[Placement]):Int={
    tree match {
      case OcNode(_,a,b,c,d,e,f,g,h) =>
        List[Octree[Placement]](b,c,d,e,f,g,h).foldLeft(1+getMaxDepth(a))((acc,tr) => acc max 1+getMaxDepth(tr))
      case _ => 0
    }
  }

  def scaleOct(fact :Double, tree: Octree[Placement]): Octree[Placement] = {
    tree match {
      case OcEmpty => tree
      case _ =>
        val allObj: List[Node] = getAllObj(tree)
        val list:List[Node] = (allObj.head::allObj.tail.filter(x => !(x.isInstanceOf[Box] && x.asInstanceOf[Box].getDrawMode.equals(DrawMode.LINE)))).map(x => {
          x.setScaleX(x.getScaleX * fact)
          x.setScaleY(x.getScaleY * fact)
          x.setScaleZ(x.getScaleZ * fact)
          x.setTranslateX(x.getTranslateX * fact)
          x.setTranslateY(x.getTranslateY * fact)
          x.setTranslateZ(x.getTranslateZ * fact)
          x
        })
        getTree(list.tail,list.head,getMaxDepth(tree))
    }
  }

  //T5
  def mapColourEffect[A](func: Color => Color, oct:Octree[A]): Octree[A] ={
    if(func!=null) {
      oct match {
        case OcEmpty => OcEmpty
        case OcNode(coords, up_00, up_01, up_10, up_11, down_00, down_01, down_10, down_11) =>
          OcNode(coords, mapColourEffect(func, up_00), mapColourEffect(func, up_01), mapColourEffect(func, up_10), mapColourEffect(func, up_11),
            mapColourEffect(func, down_00), mapColourEffect(func, down_01), mapColourEffect(func, down_10), mapColourEffect(func, down_11))
        case OcLeaf(section) =>
          OcLeaf(section.asInstanceOf[Section]._1,
            section.asInstanceOf[Section]._2 map (x => {
              x.asInstanceOf[Shape3D].setMaterial(changeColorObj(x, func))
              x
            }))
      }
    } else oct
  }

  private def changeColorObj(obj: Node,func: Color=>Color) :PhongMaterial = {
    val c = obj.asInstanceOf[Shape3D].getMaterial.asInstanceOf[PhongMaterial].getDiffuseColor
    val color = new PhongMaterial()
    color.setDiffuseColor(func(Color.color(c.getRed,c.getGreen,c.getBlue)))
    color
  }

  // Filtros:

  // Remove greens
  def greenRemove(color: Color) : Color = {
    val colorS = Color.color(color.getRed,0,color.getBlue)
    colorS
  }

  // Serpia
  def serpia(color: Color) : Color = {
    val r = color.getRed
    val g = color.getGreen
    val b = color.getBlue
    val colorS = Color.color( if(r*0.4 + g*0.77 + b*0.2 > 1) 1 else r*0.4 + g*0.77 + b*0.2,
                              if(r*0.35 + g*0.69 + b*0.17 > 1) 1 else r*0.35 + g*0.69 + b*0.17,
                              if(r*0.27 + g*0.53 + b*0.13 > 1) 1 else r*0.27 + g*0.53 + b*0.13 )
    colorS
  }

  def filterChoose(tree: Octree[Placement]):Octree[Placement] = {
    getFilter match {
      case 0 => null
      case 1 => mapColourEffect(greenRemove,tree)
      case 2 => mapColourEffect(serpia,tree)
    }
  }

}
