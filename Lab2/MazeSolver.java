import java.util.*;

/**
 * Maze Solver using Breadth-First Search (BFS)
 * Finds the shortest path in a 2D grid from Start (0, 0) to Goal (bottom-right).
 * 0 = open path, 1 = wall / obstacle
 */
public class MazeSolver {

    static class Point {
        int r, c;
        Point parent;

        Point(int r, int c, Point parent) {
            this.r = r;
            this.c = c;
            this.parent = parent;
        }
    }

    public static void main(String[] args) {
        // 0 = open path, 1 = wall
        int[][] maze = {
            {0, 0, 1, 0},
            {1, 0, 1, 0},
            {0, 0, 0, 0},
            {0, 1, 1, 0}
        };

        solve(maze);
    }

    static void solve(int[][] maze) {
        int rows = maze.length;
        int cols = maze[0].length;

        Queue<Point> queue = new LinkedList<>();
        boolean[][] visited = new boolean[rows][cols];

        // 4 directions: Up, Down, Left, Right
        int[] dr = {-1, 1, 0, 0};
        int[] dc = {0, 0, -1, 1};

        // Start at top-left corner (0, 0)
        queue.add(new Point(0, 0, null));
        visited[0][0] = true;

        Point goal = null;

        while (!queue.isEmpty()) {
            Point curr = queue.poll();

            // Check if goal reached (bottom-right corner)
            if (curr.r == rows - 1 && curr.c == cols - 1) {
                goal = curr;
                break;
            }

            for (int i = 0; i < 4; i++) {
                int nr = curr.r + dr[i];
                int nc = curr.c + dc[i];

                if (nr >= 0 && nr < rows && nc >= 0 && nc < cols 
                        && maze[nr][nc] == 0 && !visited[nr][nc]) {
                    visited[nr][nc] = true;
                    queue.add(new Point(nr, nc, curr));
                }
            }
        }

        if (goal == null) {
            System.out.println("No solution path exists.");
            return;
        }

        // Prepare visual grid: '.' = open, '#' = wall, '*' = shortest path
        char[][] display = new char[rows][cols];
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                display[r][c] = (maze[r][c] == 1) ? '#' : '.';
            }
        }

        // Trace path back to start
        for (Point p = goal; p != null; p = p.parent) {
            display[p.r][p.c] = '*';
        }

        System.out.println("Solved Maze (* = Path, # = Wall, . = Open):");
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                System.out.print(display[r][c] + " ");
            }
            System.out.println();
        }
    }
}
