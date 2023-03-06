Esta parte do projeto tem como objetivo projetar objetos num mundo 3D, envolvendo os mesmo em caixas de linhas cuja cor, vermelho ou verde,
indica se aquele octante está dentro do campo de visão (se intersecta) do objeto denominado como a camara.

Para tal é usada a estrutura de Octree para calcular os volumes (caixas) que devem ser gerados, projetando-as no ambiente 3D desde
que estes estejam dentro do niverso original (definido previamente no código base). Estes volumes representam conceptualmente os 
gráficos que devem ser enviados para a placa gráficas para efeitos de rendering.

Para efeitos de teste, foi desenvolvido uma interface text-based que usa a consola de comandos como veiculo de input e um GUI.

As opercações são efectuadas na Octree consecutivamente, sendo esta guardada num ficheiro e projetada num ambiente 3D num momento unico no final
da execução da Aplicação TextBased.  

Para efeitos de conservação de estados foi considerada a seguinte estrutura:

Universo (Width,Height,Depth) translX translY translZ escX escY escZ Profundidade
World (Width,Height,Depth) translX translY translZ escX escY escZ
Objeto CorDifusa translX translY translZ escX escY escZ


O objeto Universe corresponde ao ultimo universo considerado para a projeção dos objetos. Foi necessário criar esta estrutura para
implementar os metodos de scale sem que houvesse perda de objetos. No entanto, mesmo considerando um universo diferente
do original, são apenas gerados volumes de rendering para aqueles que estejam dentro do universo original.
O obejto World corresponde ao volume ao qual devem pretencer os objectos para efeitos de rendering.
O campo "Profundidade" no final da alinea respeitante ao objeto Universo corresponde à ultima profundidade de geração de volumes
determinada pelo utilizador.
O campo CorDifusa corresponde a um triplo (r,g,b) onde constam os respetivos valores no intervalo [0,255] que determinam a cor do objeto.
Mediante a leitura de um ficheiro, para objetos que não sejam Universo podem ser otimidos todos os parametros exceto o nome do objeto 
e a cor difusa, havendo assim um valor por default para estes.
Os restantes campos foram já introduzidos no enunciado do projeto.

Na interface da consola de comandos são dados ao utilizador 6 escolhas diferentes: 
1. Load Objetos e escolha de profundidade
2. Last Saved World
3. Mudança de profundidade 
4. Scale com factor no intervalo ]0,2] 
5. Aplicação de filtro de cor
0. Exit 

O conjunto de opções 3-5 apenas ficam disponiveis ao utilizador mediande o load de uma tree.
A opção 5 tem ainda um sub-menu respetivo à escolha do filtro a aplicar ou ao cancelamento da operação.
Em todas as as escolhas exceto o Exit, é necessário escrever algum input na consola de comandos.

Caso a localização do ficheiro de upload não exista, não é gerada nem guardada nenhuma estrutura de objetos.
Caso seja feito um upload de objetos ou uma mudança de profundidade, qualquer valor negativo denomina profundidade sem limites.
Em todos os casos há sempre feedback na consola de dados.
Em todos os casos são tratadas as exceções para o input de dados errado e a inexistência de ficheiros.


Na pasta src do projeto encontram-se dois módulo essenciais: IOUtils.scala e FuncUtils.scala

IOUtils.scala
- Este módulo contém os métodos cuja implementação depende diretamente do input de dados pelo user na consola de comandos
fazendo chamadas ao módulo FuncUtils.scala, sendo que alguns destes não são funcionais.

FuncUtils.scala
- Este módulo contém todos os métodos funcionais que fazem as operações sobre octrees, fazendo algumas chamadas ao módulo
IOUtils.scala no caso em que os dados de input não são válidos.


Foi também implementada a funcionalidade de movimentação da camara nos dois sentidos, consoante o botão de rato usado.






