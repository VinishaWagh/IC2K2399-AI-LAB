# Lab 2: Heuristic Search & Graph Traversal Algorithms
---

## 1. Graph Traversal (`GraphTraversal.java`)

### Aim
Traverse all vertices of a given graph using Breadth-First Search (BFS) and Depth-First Search (DFS).

### Core Logic (Beginner Explanation)
- **Breadth-First Search (BFS):**
  - Visits nodes level by level (explores immediate neighbors first).
  - Uses a **Queue** (First-In, First-Out).
  - Mark start vertex as visited and push to Queue. While the Queue is not empty, dequeue a vertex, print it, and enqueue all its unvisited neighbors.
- **Depth-First Search (DFS):**
  - Explores as far along each branch as possible before backtracking.
  - Uses **Recursion** (call stack).
  - Mark current vertex as visited, print it, and recursively call DFS for each unvisited neighbor.

### Graph Used
```
  0 --- 1
  |   / |
  |  /  |
  2 --- 3 --- 4
```

### Run Command
```bash
javac Lab2/GraphTraversal.java
java -cp Lab2 GraphTraversal
```

### Output
```text
BFS Traversal: 0 1 2 3 4 
DFS Traversal: 0 1 2 3 4 
```

---

## 2. 8-Puzzle Solver (`EightPuzzleSolver.java`)

### Aim
Find the shortest sequence of sliding tile moves to transition an 8-puzzle board from an initial configuration to the goal configuration.

### Core Logic (Beginner Explanation)
- **Representation:** The 3×3 grid is represented as a simple 9-character string (e.g., `"123046758"`, where `0` is the blank space).
- **Goal State:** `"123456780"` (tiles 1 to 8 in order, blank tile at the end).
- **Search Strategy (BFS):**
  - Maintains a **Queue** of `State` objects with a `parent` pointer (identical to the pattern used in Lab 1).
  - At each step, finds the index of `0` and checks up to 4 possible slide directions: **Up**, **Down**, **Left**, **Right**.
  - Swaps the blank tile with the adjacent tile to generate the next state.
  - Uses a `HashSet` of visited board strings to prevent loops.
  - Backtracks from the goal state using `parent` pointers to display each step.

### Run Command
```bash
javac Lab2/EightPuzzleSolver.java
java -cp Lab2 EightPuzzleSolver
```

### Output
```text
8-Puzzle Solution Steps:

Step 0:
1 2 3 
0 4 6 
7 5 8 

Step 1:
1 2 3 
4 0 6 
7 5 8 

Step 2:
1 2 3 
4 5 6 
7 0 8 

Step 3:
1 2 3 
4 5 6 
7 8 0 
```

---

## 3. Maze Solver (`MazeSolver.java`)

### Aim
Find the shortest path for an agent from the top-left start cell `(0, 0)` to the bottom-right exit `(rows-1, cols-1)` in a 2D grid containing obstacles.

### Core Logic (Beginner Explanation)
- **Grid Representation:**
  - `0`: Open passable cell
  - `1`: Wall / Obstacle
- **Search Strategy (BFS):**
  - BFS is guaranteed to find the shortest path in an unweighted grid.
  - Starts at `(0, 0)` with a `Point` holding `(r, c)` and a `parent` pointer.
  - Explores 4 adjacent neighbors (Up, Down, Left, Right).
  - Validates that neighbor coordinates are inside grid boundaries, not a wall (`maze[r][c] == 0`), and not yet visited.
  - When the bottom-right cell is reached, follows `parent` pointers back to the start and marks the path cells with `*`.

### Run Command
```bash
javac Lab2/MazeSolver.java
java -cp Lab2 MazeSolver
```

### Output
```text
Solved Maze (* = Path, # = Wall, . = Open):
* * # . 
# * # . 
. * * * 
. # # * 
```
