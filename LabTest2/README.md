# Lab Test 2: Intelligent Travel Planner

**Student Name:** Vinisha Wagh  
**Roll Number:** IC-2K23-99  
**Course:** IC-709D | Artificial Intelligence Lab  
**Institute:** IIPS, DAVV Indore  
**Assigned Set:** Set 9 (Roll No 90 to all)  

---

## 1. Problem Statement

Develop a Prolog-based travel planner that represents a multi-city road network and finds the optimal route between a source and destination city based on user preference:
- **Cheapest:** Minimizes total travel cost (Rs.)
- **Fastest:** Minimizes total travel time (hours)
- **Shortest:** Minimizes total distance (km)

---

## 2. Graph Network

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

### Connection Data

| Edge | Connection | Distance (km) | Time (hrs) | Cost (Rs.) |
|:---:|:---|:---:|:---:|:---:|
| 1 | City A &mdash; City B | 100 | 2 | 250 |
| 2 | City B &mdash; City F | 250 | 4 | 600 |
| 3 | City A &mdash; City C | 120 | 2 | 400 |
| 4 | City C &mdash; City F | 200 | 3 | 700 |
| 5 | City A &mdash; City D | 160 | 1 | 600 |
| 6 | City D &mdash; City F | 180 | 2 | 800 |
| 7 | City A &mdash; City E | 110 | 4 | 450 |
| 8 | City E &mdash; City F | 150 | 4 | 500 |
| 9 | City B &mdash; City C | 80 | 2 | 150 |
| 10 | City C &mdash; City D | 70 | 1 | 200 |
| 11 | City D &mdash; City E | 90 | 2 | 250 |
| 12 | City B &mdash; City E | 130 | 3 | 300 |

---

## 3. Core Logic

1. **Facts:** `edge(City1, City2, Distance, Time, Cost)`.
2. **Bidirectionality:** `connected(X, Y, D, T, C) :- edge(X, Y, D, T, C); edge(Y, X, D, T, C)`.
3. **DFS Search & Cycle Prevention:** `find_path` traverses connections while ensuring `not(member(Next, Visited))` to avoid infinite loops.
4. **Optimization:** A dynamic fact `best_route(...)` stores the best result. A failure-driven loop (`search_all`) explores all paths, replacing the stored route whenever a candidate has a lower cost/time/distance.
5. **Tie-breaking:** If the primary metric is tied, the secondary metric decides the winner (e.g., if costs are equal, the faster route is chosen).

---

## 4. Test Cases & Outputs

### Test Case 1: Cheapest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, cheapest).`
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

### Test Case 2: Fastest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, fastest).`
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

### Test Case 3: Shortest Route (City A &rarr; City F)
- **Goal:** `plan_travel(city_a, city_f, shortest).`
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

---

## 5. Additional Challenges

### 1. Avoid a Specified City (Avoid City B)
- **Goal:** `plan_travel_avoid(city_a, city_f, cheapest, city_b).`
- **Output:** Selects **City A &rarr; City E &rarr; City F** (Cost: Rs. 950, Time: 8 hrs, Dist: 260 km).

### 2. Blocked Connection (Road A &mdash; B Closed)
- **Goal:** `plan_travel_block(city_a, city_f, cheapest, city_a, city_b).`
- **Output:** Automatically reroutes via **City A &rarr; City E &rarr; City F**.

### 3. Compare Cheapest vs Fastest Route
- **Goal:** `compare_cheapest_fastest(city_a, city_f).`
- **Output:**
```text
Fastest route saves: 3 hours.
Cheapest route saves: Rs. 550.
```

### 4. Display All Candidate Routes
- **Goal:** `show_all_routes(city_a, city_f).`
- **Output:** Lists all valid routes with distance, travel time, and cost.

---

## 6. How to Run

### In Borland Turbo Prolog 2.0 (DOSBox)
1. Load `travel_planner.pro` (`F3`).
2. Compile to memory (`Alt + C`).
3. Run (`Alt + R`) to open the menu, or query directly:
   ```prolog
   plan_travel(city_a, city_f, cheapest).
   ```

### In SWI-Prolog
```bash
swipl travel_planner.pl
```
Query:
```prolog
?- test1.
?- test2.
?- test3.
?- halt.
```

---

## 7. Viva Quick Reference

1. **How does Prolog avoid getting stuck in loops?**  
   It tracks visited cities in a list `[Next|Visited]` and skips cities already present in that list using `not(member(Next, Visited))`.
2. **Why use `assertz` and `retract` for finding the best route?**  
   Prolog variables reset during backtracking. Dynamic database facts persist across backtracking, allowing us to retain the best route found so far.
3. **How to add a new city or change a road during the exam?**  
   Add or edit an `edge/5` fact in the clauses section.
