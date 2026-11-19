# 2-Minute Demo Video Script & Recording Guide

**Student Name:** Vinisha Wagh  
**Roll Number:** IC-2K23-99  
**Assignment:** AI Lab Test 2 &mdash; Set 9: Intelligent Travel Planner  

---

## 1. Pre-Recording Setup Checklist (Do this first)

1. **Screen Layout:**
   - Left half (or Tab 1): VS Code / Editor showing `LabTest2/README.md` (scroll to graph) and `travel_planner.pl` / `travel_planner.pro`.
   - Right half (or Tab 2): Terminal / Command Prompt open in `D:\vinisha\IC-2K23-99-AI-LAB`.
2. **Terminal Preparation:**
   - Increase terminal and editor font size (`Ctrl + +`) so text is clearly visible on video.
   - In terminal, test your command beforehand:
     ```bash
     swipl -s LabTest2/travel_planner.pl -g test1,test2 -t halt
     ```
     *(Or if running Turbo Prolog in DOSBox, have DOSBox positioned nicely).*
3. **Recording Tool:**
   - **Windows Game Bar:** Press `Win + Alt + R` to start/stop recording (simplest, built into Windows).
   - **OBS Studio** or **Clipchamp** / **Loom** (if you prefer showing your webcam thumbnail in the corner).
4. **Target Time:** ~1 minute 50 seconds to 2 minutes 10 seconds.

---

## 2. Timed Presentation Script

### [0:00 &ndash; 0:20] Introduction (20 sec)
- **What to show on screen:** Show the top of `LabTest2/README.md` with your details and problem statement.
- **What to say:**
  > *"Hello everyone! My name is Vinisha Wagh, roll number IC-2K23-99.  
  > For Artificial Intelligence Lab Test 2, I was assigned Set 9: the Intelligent Travel Planner.  
  > The objective of this project is to build a Prolog-based system that analyzes a multi-city road network and automatically recommends the optimal route between any two cities based on the user's preference—whether they want the cheapest, fastest, or shortest route."*

---

### [0:20 &ndash; 0:45] Graph & Knowledge Representation (25 sec)
- **What to show on screen:** Scroll to the ASCII network diagram and the connection table in `README.md`.
- **What to say:**
  > *"Here is the transportation network we modeled. It consists of six cities from City A to City F with interconnected roads.  
  > Notice that every road segment has three independent weights: distance in kilometers, estimated travel time in hours, and travel cost in rupees.  
  > For instance, City A to City B costs 250 rupees and takes 2 hours, whereas the direct route via City D is an express highway—higher cost, but much faster."*

---

### [0:45 &ndash; 1:15] Core Prolog Logic (30 sec)
- **What to show on screen:** Switch to `travel_planner.pl` (or `travel_planner.pro`), highlighting lines for `connected`, `find_path`, and `is_better`.
- **What to say:**
  > *"Looking at the Prolog implementation:  
  > First, roads are bidirectional, represented by the `connected` rule.  
  > Second, path finding uses Depth-First Search with backtracking in `find_path`. We maintain a `Visited` list with a `member` check to prevent cycles and avoid infinite recursion.  
  > Third, to find the global optimum across all possible routes, we use a dynamic database fact `best_route` combined with a failure-driven loop. The `is_better` predicate compares candidates based on the selected preference, and even includes tie-breaking rules if primary metrics match."*

---

### [1:15 &ndash; 1:45] Live Demonstration & Execution (30 sec)
- **What to show on screen:** Switch to the terminal. Run the tests live so the output prints cleanly.
- **Run command:**
  ```bash
  swipl -s LabTest2/travel_planner.pl
  ```
  *(Then query `?- test1.` and `?- test2.`)*
- **What to say:**
  > *"Now let's run the demonstration.  
  > If we ask for the **Cheapest Route** from City A to City F:  
  > The system selects `City A -> City B -> City F` at Rs. 850, taking 6 hours over 350 km. This exactly matches our assignment problem statement!  
  > Now, if we switch preference to **Fastest Route**:  
  > It recommends `City A -> City D -> City F`. Even though distance is 340 km, it takes only 3 hours—saving 3 hours of travel time.  
  > The program also handles constraints like avoiding specific cities or closed roads."*

---

### [1:45 &ndash; 2:00] Conclusion (15 sec)
- **What to show on screen:** Show the clean GitHub repository or terminal summary.
- **What to say:**
  > *"In conclusion, this project demonstrates knowledge representation, search with cycle prevention, and multi-criteria optimization in Prolog.  
  > All source code and test outputs are documented in the repository. Thank you!"*

---

## 3. Quick Tips for a Confident Video

- **Keep a steady pace:** Don't rush; speak naturally and clearly.
- **Clear terminal before starting:** Type `cls` in PowerShell before recording so the screen looks clean.
- **Mouse cursor as a pointer:** Gently hover or highlight the line of code you are mentioning so the viewer's eyes follow your voice.
