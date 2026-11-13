import java.util.*;

/**
 * 8-Puzzle Solver using Breadth-First Search (BFS)
 * Finds the shortest sequence of moves from an initial state to the goal state.
 * 0 represents the blank space.
 */
public class EightPuzzleSolver {
    static final String GOAL = "123456780";

    static class State {
        String board;
        State parent;

        State(String board, State parent) {
            this.board = board;
            this.parent = parent;
        }
    }

    // Swap characters at index i and j
    static String swap(String str, int i, int j) {
        char[] arr = str.toCharArray();
        char temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
        return new String(arr);
    }

    // Print the 3x3 board cleanly
    static void printBoard(String b) {
        for (int i = 0; i < 9; i++) {
            System.out.print(b.charAt(i) + " ");
            if ((i + 1) % 3 == 0) {
                System.out.println();
            }
        }
        System.out.println();
    }

    public static void main(String[] args) {
        // Initial state (0 is empty space)
        String start = "123046758";

        solve(start);
    }

    static void solve(String start) {
        Queue<State> queue = new LinkedList<>();
        Set<String> visited = new HashSet<>();

        // Start with the initial board state
        queue.add(new State(start, null));
        visited.add(start);

        State goalState = null;

        while (!queue.isEmpty()) {
            State curr = queue.poll();

            // Check if goal reached
            if (curr.board.equals(GOAL)) {
                goalState = curr;
                break;
            }

            int zero = curr.board.indexOf('0');
            int row = zero / 3;
            int col = zero % 3;

            // 4 possible directions: Up, Down, Left, Right
            int[] dRow = {-1, 1, 0, 0};
            int[] dCol = {0, 0, -1, 1};

            for (int i = 0; i < 4; i++) {
                int nRow = row + dRow[i];
                int nCol = col + dCol[i];

                if (nRow >= 0 && nRow < 3 && nCol >= 0 && nCol < 3) {
                    int nZero = nRow * 3 + nCol;
                    String nextBoard = swap(curr.board, zero, nZero);

                    if (!visited.contains(nextBoard)) {
                        visited.add(nextBoard);
                        queue.add(new State(nextBoard, curr));
                    }
                }
            }
        }

        if (goalState == null) {
            System.out.println("No solution found.");
            return;
        }

        // Reconstruct solution path
        List<State> path = new ArrayList<>();
        for (State s = goalState; s != null; s = s.parent) {
            path.add(s);
        }
        Collections.reverse(path);

        System.out.println("8-Puzzle Solution Steps:\n");
        for (int i = 0; i < path.size(); i++) {
            System.out.println("Step " + i + ":");
            printBoard(path.get(i).board);
        }
    }
}
