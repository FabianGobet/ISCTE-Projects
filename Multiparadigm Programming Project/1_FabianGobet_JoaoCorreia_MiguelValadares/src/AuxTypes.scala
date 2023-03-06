import javafx.scene.Node


trait AuxTypes {
  type Point = (Double, Double, Double)
  type Size = Double
  type Placement = (Point, Size)
  type Section = (Placement, List[Node])
  type Dimension = (Node,Node,Int)
}
