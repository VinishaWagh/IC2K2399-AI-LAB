# Artificial Intelligence Lab (IC-709D)

**Student Name:** Vinisha Wagh  
**Roll Number:** IC-2K23-99  
**Course:** IC-709D | Artificial Intelligence  
**Institute:** International Institute of Professional Studies (IIPS), DAVV Indore  

---

## Repository Overview

This repository contains laboratory assignments, clean implementations, outputs, and documentation for the Artificial Intelligence Lab course.

Each laboratory session is organized in its own folder (`Lab1`, `Lab2`, etc.) containing:
- Source code implementations
- Output files
- A `README.md` with problem explanations, algorithms, and step-by-step guides.

---

## Lab Index

| Lab | Experiment / Topic | Language | Status |
|:---:|:---|:---:|:---:|
| **Lab 1** | [Water Jug, Missionaries & Cannibals, Sudoku Solver](Lab1/) | Java | Completed |
| **Lab 2** | [Graph Traversal, 8-Puzzle Solver, Maze Solver](Lab2/) | Java | Completed |
| **Lab 3** | Data Preprocessing, EDA, NumPy, Pandas, Visualization | - | Pending |
| **Lab 4** | Knowledge Representation, Rule-Based Systems, Semantic Networks | - | Pending |
| **Lab 5** | Decision Tree Classifier, Model Evaluation | - | Pending |
| **Lab 6** | PyTorch Basics, Linear Regression, Neural Network Fundamentals | - | Pending |
| **Lab 7** | Explainable AI (Grad-CAM), Adversarial AI (FGSM), PCA/SVD | - | Pending |

---

## Folder Structure

```
IC-2K23-99-AI-LAB/
├── Lab1/
│   ├── WaterJugProblem.java       # Simplified Water Jug Problem
│   ├── MissionariesCannibals.java # Simplified Missionaries and Cannibals Problem
│   ├── SudokuSolver.java          # Clean 9x9 Sudoku Backtracking Solver
│   └── README.md                  # Beginner-friendly lab explanations & algorithms
├── Lab2/
│   ├── GraphTraversal.java        # Graph Traversal using BFS and DFS
│   ├── EightPuzzleSolver.java     # 8-Puzzle Solver using BFS
│   ├── MazeSolver.java            # Maze Shortest Path Solver using BFS
│   └── README.md                  # Beginner-friendly lab explanations & algorithms
├── datasets/                      # Datasets used across experiments
├── models/                        # Saved models / checkpoints
├── docs/                          # Documentation and diagrams
│   └── algorithm-flowcharts/
├── README.md                      # Repository overview
└── .gitignore                     # Git ignore rules for Java
```

---

## Running Lab 1 Programs

```bash
# Compile all programs in Lab 1
javac Lab1/WaterJugProblem.java Lab1/MissionariesCannibals.java Lab1/SudokuSolver.java

# Run Water Jug Problem
java -cp Lab1 WaterJugProblem

# Run Missionaries and Cannibals Problem
java -cp Lab1 MissionariesCannibals

# Run Sudoku Solver
java -cp Lab1 SudokuSolver
```

---

## Running Lab 2 Programs

```bash
# Compile all programs in Lab 2
javac Lab2/GraphTraversal.java Lab2/EightPuzzleSolver.java Lab2/MazeSolver.java

# Run Graph Traversal (BFS & DFS)
java -cp Lab2 GraphTraversal

# Run 8-Puzzle Solver
java -cp Lab2 EightPuzzleSolver

# Run Maze Solver
java -cp Lab2 MazeSolver
```
