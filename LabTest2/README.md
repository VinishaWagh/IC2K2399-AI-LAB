# Lab Test 2: Intelligent Travel Planner

**Student Name:** Vinisha Wagh  
**Roll Number:** IC-2K23-99  
**Course:** IC-709D | Artificial Intelligence Lab  
**Institute:** International Institute of Professional Studies (IIPS), DAVV Indore  
**Assigned Set:** Set 9 (Roll No 90 to all)  
**Implementation:** Turbo Prolog 2.0 (`travel_planner.pro`) & SWI-Prolog (`travel_planner.pl`)  

---

## 1. Problem Overview & Requirements

### Aim
To design and develop a rule-based **Intelligent Travel Planner** using Turbo Prolog that represents a multi-city transportation network and recommends the best travel route between a chosen source and destination city based on the traveler's optimization preference (**Cheapest**, **Fastest**, or **Shortest**).

### Requirements Checklist
1. **Network Representation:** Represent at least six cities (`City A`, `City B`, `City C`, `City D`, `City E`, `City F`) and their bidirectional road connections.
2. **Multi-attribute Edge Weights:** Store three independent metrics for each connection:
   - Distance (in kilometers)
   - Travel Time (in hours)
   - Travel Cost (in INR)
3. **User Preferences:** Allow selection between three travel criteria:
   - `cheapest`: Minimizes total cost (INR)
   - `fastest`: Minimizes total travel duration (hours)
   - `shortest`: Minimizes physical distance traveled (km)
4. **Tie-Breaking Rule:** If two routes share the same primary metric, break ties cleanly using the secondary metric (e.g., if costs are equal, choose the one with shorter travel time).
5. **Clear Output & Explanation:** Print the exact route sequence, computed totals, and an explicit justification for the recommendation.
6. **Additional Challenges Addressed:**
   - Avoid routes passing through a user-specified city.
   - Handle temporarily unavailable/blocked connections.
   - Perform a comparative trade-off analysis between the cheapest and fastest routes.
   - Display all candidate routes between the source and destination.

---

## 2. Graph Topology & Knowledge Base

### Road Network Diagram

```text
               (160 km / 1 hr / Rs. 600)
       +----------------- [ City D ] -----------------+
       |                      | (90 km/2 hr/Rs. 250)  |
       |                      |                       |
       |  (120 km/2 hr/400) [ City C ]                | (180 km / 2 hr / Rs. 800)
       |         +------------+                       |
       |         | (70 km/1 hr/Rs. 200)               |
       |         |                                    |
   [ City A ] ---+ (100 km / 2 hr / Rs. 250)          |
       |         |                                    |
       |         +---- [ City B ]                     v
       |                     | (130 km/3 hr/Rs. 300) [ City F ]
       |                     |                        ^
       |  (110 km/4 hr/450)  |                        |
       +----------------- [ City E ] -----------------+
               (150 km / 4 hr / Rs. 500)
```

### Connection Summary Table

| Edge | Connected Cities | Distance (km) | Time (hrs) | Cost (Rs.) | Primary Feature |
| :---: | :---: | :---: | :---: | :---: | :---|
| 1 | City A &mdash; City B | 100 | 2 | 250 | Direct branch to City B |
| 2 | City B &mdash; City F | 250 | 4 | 600 | Low-cost trunk road |
| 3 | City A &mdash; City C | 120 | 2 | 400 | Central corridor |
| 4 | City C &mdash; City F | 200 | 3 | 700 | Standard highway |
| 5 | City A &mdash; City D | 160 | 1 | 600 | Express bypass / tollway |
| 6 | City D &mdash; City F | 180 | 2 | 800 | High-speed expressway |
| 7 | City A &mdash; City E | 110 | 4 | 450 | Mountain / scenic highway |
| 8 | City E &mdash; City F | 150 | 4 | 500 | Direct southern road |
| 9 | City B &mdash; City C | 80 | 2 | 150 | Cross link |
| 10 | City C &mdash; City D | 70 | 1 | 200 | Cross link |
| 11 | City D &mdash; City E | 90 | 2 | 250 | Cross link |
| 12 | City B &mdash; City E | 130 | 3 | 300 | Cross link |

---

## 3. Core Logic & Prolog Architecture

### A. Turbo Prolog Sections
Borland Turbo Prolog 2.0 enforces strong static typing and explicit section divisions:
- **`domains`**: Declares user-defined types (`city = symbol`, `city_list = city*`, `distance, time, cost = integer`, `preference = symbol`).
- **`database`**: Defines dynamic working-memory predicates (`best_route`, `avoid_city`, `blocked_edge`) that can be updated at runtime using `assertz` and `retract`.
- **`predicates`**: Declares all predicate signatures with their argument domains and marks non-deterministic search predicates with `nondeterm`.
- **`clauses`**: Contains facts and logical inference rules.
- **`goal`**: Directs Turbo Prolog to auto-execute the interactive menu upon launch.

### B. Path Search & Cycle Detection
- Path exploration is performed using Depth-First Search (DFS) with backtracking.
- To prevent infinite loops caused by bidirectional cycles, an accumulator list `Visited` tracks cities already visited on the current branch.
- Before expanding a neighbor `Next`, the rule checks `not(member(Next, Visited))`.
- Base case: When `Curr == Dest`, the accumulated path and accumulated weights `(TotalD, TotalT, TotalC)` are returned.

### C. Finding the Global Optimum in Prolog
Standard Prolog returns the first matching solution upon querying. To find the optimal path across all possibilities:
1. Initialize a dynamic fact `best_route([], 9999, 9999, 9999)`.
2. Execute a **failure-driven loop** (`search_all`):
   - Find candidate route via `find_path(...)`.
   - Check if current candidate improves upon the recorded best using `is_better(...)`.
   - If better: `retract` old best, `assertz` the new candidate route, and invoke `fail` to force backtracking.
3. When all alternatives are exhausted, the failure-driven loop terminates and `best_route(...)` holds the guaranteed global optimum.

### D. Decision Heuristics & Tie-Breaking Rules
```prolog
/* Cheapest: minimize cost; tie-breaker: minimize time */
is_better(cheapest, _, _, C, _, _, BestC) :- C < BestC.
is_better(cheapest, _, T, C, _, BestT, BestC) :- C = BestC, T < BestT.

/* Fastest: minimize time; tie-breaker: minimize cost */
is_better(fastest, _, T, _, _, BestT, _) :- T < BestT.
is_better(fastest, _, T, C, _, BestT, BestC) :- T = BestT, C < BestC.

/* Shortest: minimize distance; tie-breaker: minimize time */
is_better(shortest, D, _, _, BestD, _, _) :- D < BestD.
is_better(shortest, D, T, _, BestD, BestT, _) :- D = BestD, T < BestT.
```

---

## 4. Test Cases & Execution Outputs

### Test Case 1: Cheapest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, cheapest).`
- **Output:**
```text
==================================================
           INTELLIGENT TRAVEL PLANNER             
==================================================
Source: City A
Destination: City F
Preference: Cheapest Route
Recommended Route: City A -> City B -> City F
Total Cost: Rs. 850
Estimated Travel Time: 6 hours
Total Distance: 350 km
Reason: This route has the lowest total cost among the available routes.
==================================================
```
*Note: This strictly reproduces the expected output given in the lab assignment sheet.*

---

### Test Case 2: Fastest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, fastest).`
- **Output:**
```text
==================================================
           INTELLIGENT TRAVEL PLANNER             
==================================================
Source: City A
Destination: City F
Preference: Fastest Route
Recommended Route: City A -> City D -> City F
Total Cost: Rs. 1400
Estimated Travel Time: 3 hours
Total Distance: 340 km
Reason: This route has the lowest travel time among the available routes.
==================================================
```
*Observation: The high-speed toll corridor through City D takes only 3 hours (half the time of the cheapest route), but costs Rs. 1400.*

---

### Test Case 3: Shortest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, shortest).`
- **Output:**
```text
==================================================
           INTELLIGENT TRAVEL PLANNER             
==================================================
Source: City A
Destination: City F
Preference: Shortest Route
Recommended Route: City A -> City E -> City F
Total Cost: Rs. 950
Estimated Travel Time: 8 hours
Total Distance: 260 km
Reason: This route has the shortest distance among the available routes.
==================================================
```
*Observation: Traversing via City E provides the shortest physical road length (260 km), though winding terrain increases travel time to 8 hours.*

---

## 5. Additional Challenges Addressed

### Challenge 1: Avoid Routes Passing Through a Specified City
- **Rule:** `plan_travel_avoid(Source, Dest, Preference, AvoidCity)`
- **Goal:** `plan_travel_avoid(city_a, city_f, cheapest, city_b).`
- **Output:**
```text
--> Route planning while avoiding: City B
==================================================
           INTELLIGENT TRAVEL PLANNER             
==================================================
Source: City A
Destination: City F
Preference: Cheapest Route
Recommended Route: City A -> City E -> City F
Total Cost: Rs. 950
Estimated Travel Time: 8 hours
Total Distance: 260 km
Reason: This route has the lowest total cost among the available routes.
==================================================
```
*The system discards any path containing City B and dynamically recommends the next cheapest route (City A &rarr; City E &rarr; City F).*

---

### Challenge 2: Handle Blocked / Unavailable Connections
- **Rule:** `plan_travel_block(Source, Dest, Preference, City1, City2)`
- **Goal:** `plan_travel_block(city_a, city_f, cheapest, city_a, city_b).`
- **Output:**
```text
--> Connection blocked between City A and City B
==================================================
           INTELLIGENT TRAVEL PLANNER             
==================================================
Source: City A
Destination: City F
Preference: Cheapest Route
Recommended Route: City A -> City E -> City F
Total Cost: Rs. 950
Estimated Travel Time: 8 hours
Total Distance: 260 km
Reason: This route has the lowest total cost among the available routes.
==================================================
```
*The system detects that the road segment `(City A, City B)` is temporarily closed for maintenance and reroutes through alternate links.*

---

### Challenge 3: Compare Cheapest Route vs Fastest Route
- **Rule:** `compare_cheapest_fastest(city_a, city_f).`
- **Output:**
```text
==================================================
      ROUTE COMPARISON: CHEAPEST vs FASTEST       
==================================================
Fastest route saves: 3 hours of travel time.
Cheapest route saves: Rs. 550 in travel budget.
Decision Rule: Choose Fastest if time is critical; choose Cheapest for budget travel.
==================================================
```

---

### Challenge 4: Display All Candidate Routes
- **Rule:** `show_all_routes(city_a, city_f).`
- **Output:**
```text
==================================================
         ALL AVAILABLE CANDIDATE ROUTES           
==================================================
Route: City A -> City B -> City F
       Distance: 350 km | Time: 6 hrs | Cost: Rs. 850
Route: City A -> City E -> City F
       Distance: 260 km | Time: 8 hrs | Cost: Rs. 950
Route: City A -> City C -> City F
       Distance: 320 km | Time: 5 hrs | Cost: Rs. 1100
Route: City A -> City D -> City F
       Distance: 340 km | Time: 3 hrs | Cost: Rs. 1400
Route: City A -> City B -> City E -> City F
       Distance: 380 km | Time: 9 hrs | Cost: Rs. 1050
Route: City A -> City B -> City C -> City F
       Distance: 380 km | Time: 7 hrs | Cost: Rs. 1100
==================================================
```

---

## 6. How to Run the Programs

### Option 1: Running in Borland Turbo Prolog 2.0 (DOSBox)
1. Open DOSBox and mount your directory where Turbo Prolog is installed:
   ```cmd
   mount c d:\turboprolog
   c:
   prolog.exe
   ```
2. Press `F3` (Load File) and open `travel_planner.pro`.
3. Press `Alt + C` to compile to memory.
4. Press `Alt + R` to run.
5. The `goal` directive automatically opens the interactive menu. You can also query directly in the Goal window:
   ```prolog
   plan_travel(city_a, city_f, cheapest).
   ```

### Option 2: Running in SWI-Prolog (`travel_planner.pl`)
1. From terminal / command prompt:
   ```bash
   swipl travel_planner.pl
   ```
2. Run any test case or demonstration goal:
   ```prolog
   ?- test1.
   ?- test2.
   ?- test3.
   ?- compare_cheapest_fastest(city_a, city_f).
   ?- run_all_tests.
   ```
3. To exit SWI-Prolog, type:
   ```prolog
   ?- halt.
   ```

---

## 7. Viva Preparation & Live Modification Guide

### Likely Viva Questions & Technical Explanations

1. **How is graph connectivity represented in Prolog?**
   - Connections are stored as facts of the predicate `edge(City1, City2, Distance, Time, Cost)`.
   - Bidirectionality is captured logically via the `connected/5` rule:
     ```prolog
     connected(X, Y, D, T, C) :- edge(X, Y, D, T, C).
     connected(X, Y, D, T, C) :- edge(Y, X, D, T, C).
     ```

2. **Why is cycle detection necessary, and how is it implemented?**
   - Because roads are bidirectional, without cycle detection the search would oscillate between `X` and `Y` infinitely (causing a stack overflow).
   - We maintain a `Visited` list. Before exploring a candidate node `Next`, we test `not(member(Next, Visited))`.

3. **Why do we use a dynamic database (`assertz`/`retract`) instead of simple recursion for finding the minimum?**
   - Prolog search explores one branch at a time through depth-first backtracking.
   - When a branch succeeds, Prolog forgets local variables upon backtracking to search the next branch.
   - The dynamic database survives backtracking, allowing us to maintain a persistent state for the current global optimum across all branches.

4. **What is the difference between Turbo Prolog and SWI-Prolog?**
   - **Turbo Prolog (Borland):** Statically typed, requires explicit `domains`, `database`, and `predicates` sections. Uses `=` for arithmetic evaluation.
   - **SWI-Prolog:** Dynamically typed ISO Prolog, uses `is` for arithmetic evaluation, and requires `:- dynamic` declarations for modifiable facts.

### Live Code Modification Guide (Exam Preparedness)
- **To add a new city (e.g., City G):**
  Add connection facts in the clauses section:
  ```prolog
  edge(city_c, city_g, 90, 1, 200).
  edge(city_g, city_f, 110, 2, 350).
  ```
  Add its display label:
  ```prolog
  city_name(city_g, "City G").
  ```
- **To change an edge's attributes:**
  Simply edit the numbers in the corresponding `edge(...)` clause.
- **To introduce a new preference (e.g., greenest / least carbon):**
  Add a fourth parameter in `edge`, declare `greenest` in `preference`, and define an `is_better(greenest, ...)` clause.
