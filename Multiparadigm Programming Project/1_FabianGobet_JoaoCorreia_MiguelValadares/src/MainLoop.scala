import FuncUtils.{filterChoose, generateWiredBox, redefineDepth, scaleOct}
import IOUtils.{getDoubleWithMessage, getInt, getLastSavedTree, invalidOpt, readPath, showprompt, writeToFile}
import javafx.scene.Node
import javafx.scene.shape.Box

import scala.annotation.tailrec

case class MainLoop(){

  def loop(): Unit = MainLoop.loop()
}

object MainLoop extends AuxTypes {

  @tailrec
  def loop(dim:Dimension=null, tree: Octree[Placement]=null):(Dimension,Octree[Placement])={
    def handleOpt(tree: Octree[Placement],k:Int):((Dimension,Octree[Placement]),Int)={
      val opt:Int = getInt
      if(opt>=0 && opt<=k){
        opt match {
          case 0 =>
            if(tree!=null) {
              writeToFile(dim,tree)
            }
            ((dim,tree),opt)
          case 1 =>
            (readPath,opt)
          case 2 =>
            (getLastSavedTree,opt)
          case 3 =>
            val tpl:(Octree[Placement],Int) = redefineDepth(tree)
            (((dim._1,dim._2,tpl._2),tpl._1),opt)
          case 4 =>
            val tmp:Double = getDoubleWithMessage
            val uni:Node = generateWiredBox((0,0,0),tmp*dim._1.asInstanceOf[Box].getWidth)
            (((uni,dim._2,dim._3),scaleOct(tmp,tree)),opt)
          case 5 =>
            ((dim,filterChoose(tree)),opt)
        }
      } else
      {
        invalidOpt
        ((null,tree),opt)
      }
    }
    showprompt(tree==null)
    val res:((Dimension,Octree[Placement]),Int)=handleOpt(tree,if(tree==null) 2 else 5)
    if(res._2!=0)
      loop((res._1)._1,res._1._2)
    else (dim,tree)
  }

}





