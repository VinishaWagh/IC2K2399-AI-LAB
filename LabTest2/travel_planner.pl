/* ============================================================== */
/* Program: Intelligent Travel Planner                            */
/* Roll Number: IC-2K23-99                                        */
/* Student Name: Vinisha Wagh                                     */
/* Course: IC-709D | Artificial Intelligence Lab                  */
/* Lab Test 2 - Set 9 (Roll No 90 to all)                         */
/* Environment: SWI-Prolog / ISO Standard Prolog                  */
/* ============================================================== */

:- dynamic best_route/4.
:- dynamic avoid_city/1.
:- dynamic blocked_edge/2.

/* -------------------------------------------------------------- */
/* 1. Knowledge Base: Road Network Between Cities                 */
/* edge(City1, City2, Distance_km, Time_hours, Cost_INR)          */
/* -------------------------------------------------------------- */
edge(city_a, city_b, 100, 2, 250).
edge(city_b, city_f, 250, 4, 600).
edge(city_a, city_c, 120, 2, 400).
edge(city_c, city_f, 200, 3, 700).
edge(city_a, city_d, 160, 1, 600).
edge(city_d, city_f, 180, 2, 800).
edge(city_a, city_e, 110, 4, 450).
edge(city_e, city_f, 150, 4, 500).
edge(city_b, city_c, 80, 2, 150).
edge(city_c, city_d, 70, 1, 200).
edge(city_d, city_e, 90, 2, 250).
edge(city_b, city_e, 130, 3, 300).

/* Roads are bidirectional */
connected(X, Y, D, T, C) :- edge(X, Y, D, T, C).
connected(X, Y, D, T, C) :- edge(Y, X, D, T, C).

/* Valid road traversal check */
valid_step(X, Y, D, T, C) :-
    connected(X, Y, D, T, C),
    \+ avoid_city(Y),
    \+ blocked_edge(X, Y),
    \+ blocked_edge(Y, X).

/* Cycle prevention helper */
has_visited(X, [X|_]) :- !.
has_visited(X, [_|Tail]) :- has_visited(X, Tail).

/* -------------------------------------------------------------- */
/* 2. Graph Search with Backtracking                              */
/* -------------------------------------------------------------- */
find_path(Dest, Dest, Visited, Visited, 0, 0, 0).
find_path(Curr, Dest, Visited, FullPath, TotalD, TotalT, TotalC) :-
    valid_step(Curr, Next, D, T, C),
    \+ has_visited(Next, Visited),
    find_path(Next, Dest, [Next|Visited], FullPath, SubD, SubT, SubC),
    TotalD is D + SubD,
    TotalT is T + SubT,
    TotalC is C + SubC.

/* Reverse list helper */
reverse_path([], Acc, Acc).
reverse_path([H|T], Acc, Result) :-
    reverse_path(T, [H|Acc], Result).

/* -------------------------------------------------------------- */
/* 3. Decision Rules & Optimization Heuristics                    */
/* -------------------------------------------------------------- */
/* Cheapest: Minimize Cost; Tie-breaker: Minimize Time */
is_better(cheapest, _, _, C, _, _, BestC) :-
    C < BestC.
is_better(cheapest, _, T, C, _, BestT, BestC) :-
    C =:= BestC, T < BestT.

/* Fastest: Minimize Time; Tie-breaker: Minimize Cost */
is_better(fastest, _, T, _, _, BestT, _) :-
    T < BestT.
is_better(fastest, _, T, C, _, BestT, BestC) :-
    T =:= BestT, C < BestC.

/* Shortest: Minimize Distance; Tie-breaker: Minimize Time */
is_better(shortest, D, _, _, BestD, _, _) :-
    D < BestD.
is_better(shortest, D, T, _, BestD, BestT, _) :-
    D =:= BestD, T < BestT.

/* -------------------------------------------------------------- */
/* 4. Optimization Engine using Dynamic Database                  */
/* -------------------------------------------------------------- */
init_best :-
    retractall(best_route(_, _, _, _)),
    assertz(best_route([], 9999, 9999, 9999)).

/* Explore all paths via backtracking failure-driven loop */
search_all(Source, Dest, Pref) :-
    find_path(Source, Dest, [Source], RevPath, D, T, C),
    best_route(_, BestD, BestT, BestC),
    is_better(Pref, D, T, C, BestD, BestT, BestC),
    retractall(best_route(_, _, _, _)),
    reverse_path(RevPath, [], ForwardPath),
    assertz(best_route(ForwardPath, D, T, C)),
    fail.
search_all(_, _, _).

/* Main planner query */
plan_travel(Source, Dest, Pref) :-
    init_best,
    search_all(Source, Dest, Pref),
    best_route(Path, D, T, C),
    Path \= [],
    display_result(Source, Dest, Pref, Path, D, T, C),
    !.
plan_travel(Source, Dest, _) :-
    format('~nStatus: No valid route found between ~w and ~w.~n', [Source, Dest]).

/* -------------------------------------------------------------- */
/* 5. Formatting & Explanations                                   */
/* -------------------------------------------------------------- */
city_name(city_a, 'City A').
city_name(city_b, 'City B').
city_name(city_c, 'City C').
city_name(city_d, 'City D').
city_name(city_e, 'City E').
city_name(city_f, 'City F').

pref_label(cheapest, 'Cheapest Route').
pref_label(fastest, 'Fastest Route').
pref_label(shortest, 'Shortest Route').

print_route([]) :- nl.
print_route([H]) :-
    ( city_name(H, Name) -> write(Name) ; write(H) ),
    nl, !.
print_route([H|T]) :-
    ( city_name(H, Name) -> write(Name) ; write(H) ),
    write(' -> '),
    print_route(T).

display_reason(cheapest) :-
    write('This route has the lowest total cost among the available routes.').
display_reason(fastest) :-
    write('This route has the lowest travel time among the available routes.').
display_reason(shortest) :-
    write('This route has the shortest distance among the available routes.').

display_result(Source, Dest, Pref, Path, D, T, C) :-
    nl,
    write('=================================================='), nl,
    write('           INTELLIGENT TRAVEL PLANNER             '), nl,
    write('=================================================='), nl,
    ( city_name(Source, SName) -> true ; SName = Source ),
    ( city_name(Dest, DName) -> true ; DName = Dest ),
    ( pref_label(Pref, PLabel) -> true ; PLabel = Pref ),
    format('Source: ~w~n', [SName]),
    format('Destination: ~w~n', [DName]),
    format('Preference: ~w~n', [PLabel]),
    write('Recommended Route: '), print_route(Path),
    format('Total Cost: Rs. ~w~n', [C]),
    format('Estimated Travel Time: ~w hours~n', [T]),
    format('Total Distance: ~w km~n', [D]),
    write('Reason: '), display_reason(Pref), nl,
    write('=================================================='), nl.

/* -------------------------------------------------------------- */
/* 6. Additional Challenges                                       */
/* -------------------------------------------------------------- */
/* Avoid a specified city */
plan_travel_avoid(Source, Dest, Pref, AvoidCity) :-
    assertz(avoid_city(AvoidCity)),
    ( city_name(AvoidCity, AName) -> true ; AName = AvoidCity ),
    format('~n--> Route planning while avoiding: ~w~n', [AName]),
    plan_travel(Source, Dest, Pref),
    retractall(avoid_city(AvoidCity)),
    !.
plan_travel_avoid(_, _, _, AvoidCity) :-
    retractall(avoid_city(AvoidCity)),
    fail.

/* Handle blocked connection */
plan_travel_block(Source, Dest, Pref, City1, City2) :-
    assertz(blocked_edge(City1, City2)),
    ( city_name(City1, N1) -> true ; N1 = City1 ),
    ( city_name(City2, N2) -> true ; N2 = City2 ),
    format('~n--> Connection blocked between ~w and ~w~n', [N1, N2]),
    plan_travel(Source, Dest, Pref),
    retractall(blocked_edge(City1, City2)),
    !.
plan_travel_block(_, _, _, City1, City2) :-
    retractall(blocked_edge(City1, City2)),
    fail.

/* Compare Cheapest vs Fastest route */
compare_cheapest_fastest(Source, Dest) :-
    nl,
    write('=================================================='), nl,
    write('      ROUTE COMPARISON: CHEAPEST vs FASTEST       '), nl,
    write('=================================================='), nl,
    plan_travel(Source, Dest, cheapest),
    best_route(CPath, CD, CT, CC),
    plan_travel(Source, Dest, fastest),
    best_route(FPath, FD, FT, FC),
    TimeSaved is CT - FT,
    CostDiff is FC - CC,
    nl,
    write('--- TRADE-OFF ANALYSIS ---'), nl,
    format('Fastest route saves: ~w hours of travel time.~n', [TimeSaved]),
    format('Cheapest route saves: Rs. ~w in travel budget.~n', [CostDiff]),
    write('Decision Rule: Choose Fastest if time is critical; choose Cheapest for budget travel.'), nl,
    write('=================================================='), nl.

/* Display all candidate routes */
show_all_routes(Source, Dest) :-
    nl,
    write('=================================================='), nl,
    write('         ALL AVAILABLE CANDIDATE ROUTES           '), nl,
    write('=================================================='), nl,
    find_path(Source, Dest, [Source], RevPath, D, T, C),
    reverse_path(RevPath, [], ForwardPath),
    write('Route: '), print_route(ForwardPath),
    format('       Distance: ~w km | Time: ~w hrs | Cost: Rs. ~w~n', [D, T, C]),
    fail.
show_all_routes(_, _) :-
    write('=================================================='), nl.

/* -------------------------------------------------------------- */
/* 7. Ready-to-Run Test Predicates                                */
/* -------------------------------------------------------------- */
test1 :-
    nl, write('>>> RUNNING TEST CASE 1: CHEAPEST ROUTE <<<'), nl,
    plan_travel(city_a, city_f, cheapest).

test2 :-
    nl, write('>>> RUNNING TEST CASE 2: FASTEST ROUTE <<<'), nl,
    plan_travel(city_a, city_f, fastest).

test3 :-
    nl, write('>>> RUNNING TEST CASE 3: SHORTEST ROUTE <<<'), nl,
    plan_travel(city_a, city_f, shortest).

run_all_tests :-
    test1,
    test2,
    test3,
    nl, write('>>> ADDITIONAL CHALLENGE 1: AVOID CITY B <<<'), nl,
    plan_travel_avoid(city_a, city_f, cheapest, city_b),
    nl, write('>>> ADDITIONAL CHALLENGE 2: BLOCKED ROAD (A - B) <<<'), nl,
    plan_travel_block(city_a, city_f, cheapest, city_a, city_b),
    compare_cheapest_fastest(city_a, city_f).
