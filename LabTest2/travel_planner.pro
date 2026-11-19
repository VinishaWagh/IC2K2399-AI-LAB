domains
    city = symbol
    city_list = city*
    distance, time, cost = integer
    preference = symbol
    message = string

database
    best_route(city_list, integer, integer, integer)
    avoid_city(city)
    blocked_edge(city, city)

predicates
    nondeterm edge(city, city, distance, time, cost)
    nondeterm connected(city, city, distance, time, cost)
    nondeterm valid_step(city, city, distance, time, cost)
    nondeterm member(city, city_list)
    nondeterm find_path(city, city, city_list, city_list, distance, time, cost)
    nondeterm search_all(city, city, preference)
    nondeterm list_candidate_routes(city, city)

    is_better(preference, distance, time, cost, distance, time, cost)
    clear_best
    init_best
    reverse_list(city_list, city_list, city_list)
    print_route(city_list)
    city_name(city, message)
    pref_label(preference, message)
    display_result(city, city, preference, city_list, distance, time, cost)
    display_reason(preference)
    plan_travel(city, city, preference)
    plan_travel_avoid(city, city, preference, city)
    plan_travel_block(city, city, preference, city, city)
    compare_cheapest_fastest(city, city)
    show_all_routes(city, city)
    test1
    test2
    test3
    handle_menu(integer)
    run

clauses
    % Knowledge base: edge(From, To, Distance_km, Time_hours, Cost_Rs)
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

    % Bidirectional connectivity
    connected(X, Y, D, T, C) :- edge(X, Y, D, T, C).
    connected(X, Y, D, T, C) :- edge(Y, X, D, T, C).

    % Valid step check
    valid_step(X, Y, D, T, C) :-
        connected(X, Y, D, T, C),
        not(avoid_city(Y)),
        not(blocked_edge(X, Y)),
        not(blocked_edge(Y, X)).

    % Cycle prevention
    member(X, [X|_]) :- !.
    member(X, [_|Tail]) :- member(X, Tail).

    % Path search (DFS)
    find_path(Dest, Dest, Visited, Visited, 0, 0, 0).
    find_path(Curr, Dest, Visited, FullPath, TotalD, TotalT, TotalC) :-
        valid_step(Curr, Next, D, T, C),
        not(member(Next, Visited)),
        find_path(Next, Dest, [Next|Visited], FullPath, SubD, SubT, SubC),
        TotalD = D + SubD,
        TotalT = T + SubT,
        TotalC = C + SubC.

    reverse_list([], Acc, Acc).
    reverse_list([H|T], Acc, Result) :-
        reverse_list(T, [H|Acc], Result).

    % Decision rules
    is_better(cheapest, _, _, C, _, _, BestC) :- C < BestC.
    is_better(cheapest, _, T, C, _, BestT, BestC) :- C = BestC, T < BestT.

    is_better(fastest, _, T, _, _, BestT, _) :- T < BestT.
    is_better(fastest, _, T, C, _, BestT, BestC) :- T = BestT, C < BestC.

    is_better(shortest, D, _, _, BestD, _, _) :- D < BestD.
    is_better(shortest, D, T, _, BestD, BestT, _) :- D = BestD, T < BestT.

    % Global optimum search via failure-driven loop
    clear_best :-
        retract(best_route(_, _, _, _)),
        fail.
    clear_best.

    init_best :-
        clear_best,
        assertz(best_route([], 9999, 9999, 9999)).

    search_all(Source, Dest, Pref) :-
        find_path(Source, Dest, [Source], RevPath, D, T, C),
        best_route(_, BestD, BestT, BestC),
        is_better(Pref, D, T, C, BestD, BestT, BestC),
        retract(best_route(_, _, _, _)),
        reverse_list(RevPath, [], ForwardPath),
        assertz(best_route(ForwardPath, D, T, C)),
        fail.
    search_all(_, _, _).

    plan_travel(Source, Dest, Pref) :-
        init_best,
        search_all(Source, Dest, Pref),
        best_route(Path, D, T, C),
        not(Path = []),
        display_result(Source, Dest, Pref, Path, D, T, C),
        !.
    plan_travel(Source, Dest, _) :-
        nl,
        write("Status: No valid route found between "), write(Source),
        write(" and "), write(Dest), nl.

    % Output formatting
    city_name(city_a, "City A").
    city_name(city_b, "City B").
    city_name(city_c, "City C").
    city_name(city_d, "City D").
    city_name(city_e, "City E").
    city_name(city_f, "City F").

    pref_label(cheapest, "Cheapest Route").
    pref_label(fastest, "Fastest Route").
    pref_label(shortest, "Shortest Route").

    print_route([]) :- nl.
    print_route([H]) :-
        city_name(H, Name), write(Name), nl, !.
    print_route([H]) :-
        write(H), nl, !.
    print_route([H|T]) :-
        city_name(H, Name), write(Name), write(" -> "), !,
        print_route(T).
    print_route([H|T]) :-
        write(H), write(" -> "),
        print_route(T).

    display_reason(cheapest) :-
        write("This route has the lowest total cost among the available routes.").
    display_reason(fastest) :-
        write("This route has the lowest travel time among the available routes.").
    display_reason(shortest) :-
        write("This route has the shortest distance among the available routes.").

    display_result(Source, Dest, Pref, Path, D, T, C) :-
        nl,
        write("=================================================="), nl,
        write("           INTELLIGENT TRAVEL PLANNER             "), nl,
        write("=================================================="), nl,
        city_name(Source, SName),
        city_name(Dest, DName),
        pref_label(Pref, PLabel),
        write("Source: "), write(SName), nl,
        write("Destination: "), write(DName), nl,
        write("Preference: "), write(PLabel), nl,
        write("Recommended Route: "), print_route(Path),
        write("Total Cost: Rs. "), write(C), nl,
        write("Estimated Travel Time: "), write(T), write(" hours"), nl,
        write("Total Distance: "), write(D), write(" km"), nl,
        write("Reason: "), display_reason(Pref), nl,
        write("=================================================="), nl.

    % Additional challenges
    plan_travel_avoid(Source, Dest, Pref, AvoidCity) :-
        assertz(avoid_city(AvoidCity)),
        city_name(AvoidCity, AName),
        nl, write("--> Route planning while avoiding: "), write(AName), nl,
        plan_travel(Source, Dest, Pref),
        retract(avoid_city(AvoidCity)),
        !.
    plan_travel_avoid(_, _, _, AvoidCity) :-
        retract(avoid_city(AvoidCity)),
        fail.

    plan_travel_block(Source, Dest, Pref, City1, City2) :-
        assertz(blocked_edge(City1, City2)),
        city_name(City1, N1),
        city_name(City2, N2),
        nl, write("--> Connection blocked between "), write(N1),
        write(" and "), write(N2), nl,
        plan_travel(Source, Dest, Pref),
        retract(blocked_edge(City1, City2)),
        !.
    plan_travel_block(_, _, _, City1, City2) :-
        retract(blocked_edge(City1, City2)),
        fail.

    compare_cheapest_fastest(Source, Dest) :-
        nl,
        write("=================================================="), nl,
        write("      ROUTE COMPARISON: CHEAPEST vs FASTEST       "), nl,
        write("=================================================="), nl,
        plan_travel(Source, Dest, cheapest),
        best_route(CPath, CD, CT, CC),
        plan_travel(Source, Dest, fastest),
        best_route(FPath, FD, FT, FC),
        TimeSaved = CT - FT,
        CostDiff = FC - CC,
        nl,
        write("Fastest route saves: "), write(TimeSaved), write(" hours."), nl,
        write("Cheapest route saves: Rs. "), write(CostDiff), nl,
        write("=================================================="), nl.

    show_all_routes(Source, Dest) :-
        nl,
        write("=================================================="), nl,
        write("         ALL AVAILABLE CANDIDATE ROUTES           "), nl,
        write("=================================================="), nl,
        list_candidate_routes(Source, Dest),
        fail.
    show_all_routes(_, _) :-
        write("=================================================="), nl.

    list_candidate_routes(Source, Dest) :-
        find_path(Source, Dest, [Source], RevPath, D, T, C),
        reverse_list(RevPath, [], ForwardPath),
        write("Route: "), print_route(ForwardPath),
        write("       Distance: "), write(D), write(" km | Time: "),
        write(T), write(" hrs | Cost: Rs. "), write(C), nl.

    % Quick test shortcuts
    test1 :- plan_travel(city_a, city_f, cheapest).
    test2 :- plan_travel(city_a, city_f, fastest).
    test3 :- plan_travel(city_a, city_f, shortest).

    handle_menu(1) :- test1.
    handle_menu(2) :- test2.
    handle_menu(3) :- test3.
    handle_menu(4) :- plan_travel_avoid(city_a, city_f, cheapest, city_b).
    handle_menu(5) :- plan_travel_block(city_a, city_f, cheapest, city_a, city_b).
    handle_menu(6) :- compare_cheapest_fastest(city_a, city_f).
    handle_menu(7) :- show_all_routes(city_a, city_f).
    handle_menu(8) :- write("Exiting. Thank you!"), nl.
    handle_menu(_) :- write("Invalid choice! Enter 1-8."), nl.

    run :-
        nl,
        write("=================================================="), nl,
        write("       INTELLIGENT TRAVEL PLANNER - MENU          "), nl,
        write("       Roll No: IC-2K23-99 | Set 9                "), nl,
        write("=================================================="), nl,
        write(" 1. Test Case 1: Cheapest Route (City A -> City F)"), nl,
        write(" 2. Test Case 2: Fastest Route  (City A -> City F)"), nl,
        write(" 3. Test Case 3: Shortest Route (City A -> City F)"), nl,
        write(" 4. Challenge 1: Avoid City B                     "), nl,
        write(" 5. Challenge 2: Block Connection (A - B)         "), nl,
        write(" 6. Challenge 3: Compare Cheapest vs Fastest      "), nl,
        write(" 7. Challenge 4: Show All Candidate Routes        "), nl,
        write(" 8. Exit                                          "), nl,
        write("=================================================="), nl,
        write("Enter choice (1-8): "),
        readint(Choice),
        handle_menu(Choice).

goal
    run.
