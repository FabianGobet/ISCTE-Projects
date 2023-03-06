/* Trabalho realizado:
 * - Luis Viana, 98780
 * - Fabian Gobet, 97885
 *
 *  Notas:
 *  - Em todo este trabalho existem green cuts (!), pelo que a sua
 *  remocao nao tera qualquer impacto na logica, e apenas no
 *  performance.
 *  - Existem duas heuristicas presentes, estando uma delas em
 *  comentario (menos pesada em termos de performance, mas menos
 *  precisa) e outra nao. - Deve ser ajustado o valor de profundidade do
 *  algoritmo alfa-beta de acordo com o tamanho do board.
 *
 */


%A
generateList(NC,E,[E|L]):-NC>0,NC2 is NC-1,generateList(NC2,E,L),!.
generateList(0,_,[]).

initial_board(NR,NC,Board):-generateList(NC,0,Row),generateList(NR,Row,Board).

%B
printOneLine([X|Tail]):-print(X),write(' '),printOneLine(Tail),!.
printOneLine([]).

print_board([Board|Tail]):-printOneLine(Board),nl,print_board(Tail),!.
print_board([]):-write('__________________').

%C
valid_move(X,Y,[_|Tail]):-X>0,X2 is X-1,valid_move(X2,Y,Tail),!.
valid_move(0,Y,[[_|T1]|T2]):-Y>0,Y2 is Y-1,valid_move(0,Y2,[T1,T2]),!.
valid_move(0,0,[[E|_]|_]):-E=0.

%D
add_move(P,X,Y,[E|T1],[E|T2]):-X>0,X2 is X-1,add_move(P,X2,Y,T1,T2),!.
add_move(P,0,Y,[[E|T1]|T2],[[E|T3]|T2]):-Y>0,Y2 is Y-1,add_move(P,0,Y2,[T1|T2],[T3|T2]),!.
add_move(P,0,0,[[_|T1]|T2],[[P|T1]|T2]).

line_AllMoves(Player,[Slot|Tail],[Slot|BP]):-line_AllMoves(Player,Tail,BP).
line_AllMoves(Player,[0|Tail],[Player|Tail]).

generate_move(Player,[Line|Tail],[Moves|Tail]):-line_AllMoves(Player,Line,Moves).
generate_move(Player,[Line|Tail],[Line|BP]):-generate_move(Player,Tail,BP).

%F
transposta(Board,[Row|Tail]):-transCol(Board,Row,RestoBoard),transposta(RestoBoard,Tail),!.
transposta([[]|_],[]).
transCol([[Elemento|Tail1]|Tail2],[Elemento|Resto1],[Tail1|Resto2]):-transCol(Tail2,Resto1,Resto2),!.
transCol([],[],[]).

              % Gerar diagonal >3 elementos a partir de um conjunto de linhas e um indice Y
diagTrigger(A,B,C):-getDiagFromY(A,0,B,C).
getDiagFromY([[_|T]|T2],CY,TY,L):-CY<TY,CY2 is CY+1,getDiagFromY([T|T2],CY2,TY,L).
getDiagFromY([[E|_]|T],CY,TY,[E|T2]):-CY=TY,TY2 is TY+1,TY2>0,TY3 is TY-1,getDiagFromY(T,0,TY3,T2).
getDiagFromY([],_,_,[]).
getDiagFromY(_,_,TY,[]):-TY<0.

              %  Iterador do bordo superior e direito, enquanto gera diagonais, do Board
move_horizontal([[_|T],A,B,C|T2],Y,L):-Y<3,Y2 is Y+1,move_horizontal([T,A,B,C|T2],Y2,L),!.
move_horizontal([[E|T]|T2],Y,[[E|T3]|L]):-Y>2,Y2 is Y+1,move_horizontal([T|T2],Y2,L),Y3 is Y-1,diagTrigger(T2,Y3,T3),!.
move_horizontal([[]|T],Y,L):-Y>2,Y2 is Y-1, move_vertical(T,Y2,L),!.
move_horizontal([[]|_],Y,[]):-Y<3,!.
move_horizontal([_,_,_,_|_],Y,[]):-Y<3.
move_vertical([[_,A2|T],B,C,D|T2],Y,L):-move_vertical([[A2|T],B,C,D|T2],Y,L),!.
move_vertical([[A],B,C,D|T],Y,[[A|T2]|T3]):-move_vertical([B,C,D|T],Y,T3),Y3 is Y-1,diagTrigger([B,C,D|T],Y3,T2),!.
move_vertical(L,_,[]):-length(L,N),N<4.

            %  Todas as linhas possiveis (c/ diags >3 elementos) do Board
getAllNormLines(Board,Result):-move_horizontal(Board,0,L),append(Board,L,Result).
getAllTransLines(Board,Result):-transposta(Board,T),reverse(T,RT),move_horizontal(RT,0,L),append(T,L,Result).
getAllLines(Board,Result):-getAllTransLines(Board,R1),getAllNormLines(Board,R2),append(R1,R2,Result).

          %    Iterar sobre uma linha ate encontrar solucao�4 em linha diferente de, devolve P� ou chegar ao fim, devolve 0
iterateThroughLine([A,B,C,D|T],W):-(\+solution(A,B,C,D)),iterateThroughLine([B,C,D|T],W),!.
iterateThroughLine([_,_,_],0).
iterateThroughLine([A,A,A,A|_],A):-A\=0.
solution(A,A,A,A):-A\=0.

		% Iterar sobre todas as linhas ate encontrar winner ou chegar ao fim
searchWinner([E|T],W):-iterateThroughLine(E,0),searchWinner(T,W).
searchWinner([E|_],W):-iterateThroughLine(E,W),W\=0,!.
searchWinner([],0).

		% Procura Winner em todas as linhas possiveis do board. se nao houver e o board nao der para fazer jogadas, ha empate.
winner(Board,W):-getAllLines(Board,L),searchWinner(L,W).
evaluateW(_,W):-W\=0,!.
evaluateW(Board,0):-generate_move(_,Board,[]).

game_over(Board,W):-winner(Board,W),evaluateW(Board,W),!.



/*
                          % Esta heuristica tem como objetivo chegar a
                          um board com regioes mais densas(mais rapida)

	% Conta numero de elementos na sequencia(de 4) igual a P. 0 se algum for do Opositor
segmentValue(L,P,NFinal):-segment4Count(L,P,N),NFinal is max(0,N).
segment4Count([P|T],P,N):-segment4Count(T,P,N2),N is 1+N2,!.
segment4Count([0|T],P,N):-segment4Count(T,P,N),!.
segment4Count([P2|_],P,-4):-P2\=P,!.
segment4Count([],_,0).

	% Soma de todos os numeros do segmentValue das sequencias 4 a 4 da Linha
linePatterns([A,B,C,D|T],P,N):-linePatterns([B,C,D|T],P,N1),segmentValue([A,B,C,D],P,N2),N is N1+N2,!.
linePatterns(L,_,0):-length(L,N), N<4.

	 % Soma de todas os valores do linePatterns das linhas do Board
sumOfAllHeuristics([L|T],P,H):-sumOfAllHeuristics(T,P,H2),linePatterns(L,P,N),H is N+H2,!.
sumOfAllHeuristics([],_,0).

                                          % Fim da Heuristica
*/


	    % Esta heuristica tem como objetivo o Board que contem mais possibilidades de linhas de soluÃ§Ã£o

		% Conta numero de elementos na sequencia(de 4) igual a P. 0 se algum for do Opositor
segmentValue(L,P,NFinal):-segment4Count(L,P,N),NFinal is max(0,N).
segment4Count([P|T],P,N):-segment4Count(T,P,N2),N is 1+N2,!.
segment4Count([0|T],P,N):-segment4Count(T,P,N),!.
segment4Count([P2|_],P,-4):-P2\=P,!.
segment4Count([],_,0).

	% Forma Lista com os numeros do segmentValue das sequencias 4 a 4 da Linha
linePatterns([A,B,C,D|T],P,[E|T2]):-linePatterns([B,C,D|T],P,T2),segmentValue([A,B,C,D],P,E),!.
linePatterns(L,_,[]):-length(L,N), N<4.


/*
		% Soma apenas dos maximos iguais da lista do linePatterns
sumOfAllMax([L|T],Max,_,Result):-L>Max,sumOfAllMax(T,L,L,Result),!.
sumOfAllMax([L|T],Max,Taxi,Result):-L=Max,Taxi2 is Taxi+Max,sumOfAllMax(T,Max,Taxi2,Result),!.
sumOfAllMax([L|T],Max,Taxi,Result):-L<Max,sumOfAllMax(T,Max,Taxi,Result),!.
sumOfAllMax([],_,Taxi,Taxi).


        % Soma de todas os valores do sumOfAllMax das linhas do Board
sumOfAllHeuristics([L|T],P,H):-sumOfAllHeuristics(T,P,H2),linePatterns(L,P,L2),sumOfAllMax(L2,0,0,H3),H is H2+H3,!.
sumOfAllHeuristics([],_,0).

*/
		% Lista com a soma dos elementos iguais (ex. soma de todos os 1, soma de todos os 2), escolher o maximo da lista.
sumOfAllHeuristics([L|T],P,H):-sumOfAllHeuristics(T,P,H2),linePatterns(L,P,L2),
    findall(R,(list_to_set(L2,S),member(X,S),sumOfAllMax(L2,X,0,R)),Res),max_list(Res,H3),H is H2+H3,!.
sumOfAllHeuristics([],_,0).

sumOfAllMax([L|T],Max,Taxi,Result):-L=Max,Taxi2 is Taxi+Max,sumOfAllMax(T,Max,Taxi2,Result),!.
sumOfAllMax([L|T],Max,Taxi,Result):-L\=Max,sumOfAllMax(T,Max,Taxi,Result),!.
sumOfAllMax([],_,Taxi,Taxi).

                                           % Fim da Heuristica



calculate_board_heuristic(P,B,Val):-(\+game_over(B,_)),getHeuristic(P,B,Val),!.
getHeuristic(1,B,Val):-getAllLines(B,L),sumOfAllHeuristics(L,1,Val).
getHeuristic(2,B,Final):-getAllLines(B,L),sumOfAllHeuristics(L,2,Val),Final is 0-Val.

calculate_board_value(1,1000).
calculate_board_value(2,-1000).
calculate_board_value(0,0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% next_player(Player1, Player2) - permite saber qual é ¯ pró¸©­o jogador
next_player(1,2).
next_player(2,1).

%play_game/0
% Este predicado começ¡ por criar um tabuleiro com a dimensao 6x6 e
% validar a jogada do computador (player 1).
play_game():-
    initial_board(6, 6, B0),
    play(1,B0).

%play/1
%O predicado play tem como argumentos o jogador que deve jogar e o tabuleiro sobre o qual deve fazer a sua jogada.
% Este predicado e' recursivo de modo a permitir a alternancia das
% jogadas. A sua implementaç¡¯ e constituida pela jogada do computador
% (play(1,B)) , pela jogada do jogador (play(2,B)) e pela verificaç¡¯
% do fim do jogo.
play(_,B0):-
    game_over(B0,T),
    calculate_board_value(T,Value),
    nl,
    print_board(B0),
    write('Game Over!'),
    nl,
    display(Value),
    !.

play(1,B0):-
    write('Player:'),nl,
    print_board(B0),
    alphabeta(B0,4,-100,100,B1,_,1),
    !,
    play(2,B1).

play(2,B0):-
    write('Computer:'),nl,
    print_board(B0),
    write('Where to play? (C,L)'),
    read(C),
    read(L),
    valid_move(C,L,B0),
    add_move(2,C,L,B0,B1),
    !,
    play(1,B1).

%alphabeta/7
%minimax-alpha-beta
% O predicado que implementa o minimax e' chamado alfabeta e tem como
% argumentos o tabuleiro, o valor de profundidade que ainda e' permitido
% explorar, o alfa, o beta, o tabuleiro resultado, o score da avaliaç¡¯
% do resultado na o'tica do computador e o jogador que se esta' a
% avaliar (minimizar ou a maximizar).
alphabeta(Bi, 0, _, _, Bi, Value, P):-
    calculate_board_heuristic(P,Bi,Value),
    !.

alphabeta(Bi, _, _, _, Bi, Value, _):-
    game_over(Bi,T),
    calculate_board_value(T,Value),
    !.


alphabeta(Bi, D, Alfa, Beta, Bf, Value, Player):-
    next_player(Player,Other),
    possible_moves(Player,Bi,L),
    !,
    evaluate_child(Other, L, D, Alfa, Beta, Bf, Value).

%evaluate_child/7
evaluate_child(Player, [B], D, Alfa, Beta, B, Value):-
    D1 is D-1,
    !,
    alphabeta(B, D1, Alfa, Beta, _, Value, Player).


evaluate_child(2, [Bi|T], D, Alfa, Beta,Bf, Value):-
    D1 is D-1,
    alphabeta(Bi, D1, Alfa, Beta, _, Value1, 2),
    !,
    evaluate_next_child_max(Value1,Bi, T, D, Alfa, Beta, Value, Bf).

evaluate_child(1, [Bi|T], D, Alfa, Beta,Bf, Value):-
    D1 is D-1,
    alphabeta(Bi, D1, Alfa, Beta, _, Value1, 1),
    !,
    evaluate_next_child_min(Value1,Bi, T, D, Alfa, Beta, Value, Bf).

%evaluate_next_child_max/8
evaluate_next_child_max(Value1,Bi, T, D, Alfa, Beta, Value, Bf):-
    Value1 < Beta,
    max(Value1,Alfa,NewAlfa),
    !,
    evaluate_child(2, T, D, NewAlfa, Beta, B2, Value2),
    max_board(Value1,Bi,Value2,B2,Value,Bf).

evaluate_next_child_max(Value1,Bi, _, _, _, _, Value1, Bi):- !.

%evaluate_next_child_min/8
evaluate_next_child_min(Value1,Bi, T, D, Alfa, Beta, Value, Bf):-
     Value1 > Alfa,
     min(Value1,Beta,NewBeta),
     !,
     evaluate_child(1, T, D, Alfa, NewBeta, B2, Value2),
     min_board(Value1,Bi,Value2,B2,Value,Bf).

evaluate_next_child_min(Value1,Bi, _, _, _, _, Value1, Bi):- !.


%possible_moves/3
possible_moves(X,B,L):-
    bagof(BP,generate_move(X,B,BP),L).

%max_board/6
max_board(Value1,B1,Value2,_,Value1,B1):-
    Value1 >= Value2.

max_board(Value1,_,Value2,B2,Value2,B2):-
    Value1 < Value2.

%min_board/6
min_board(Value1,B1,Value2,_,Value1,B1):-
    Value1 =< Value2.

min_board(Value1,_,Value2,B2,Value2,B2):-
    Value1 > Value2.

%max/3
max(X,Y,X):-
    X>=Y,!.
max(X,Y,Y):-
    Y>X.
%min/3
min(X,Y,X):-
    X=<Y,!.
min(X,Y,Y):-
    Y<X.
