import java.util.*;

/**
 * Graph Traversal using Breadth-First Search (BFS) and Depth-First Search (DFS)
 * - BFS explores level by level using a Queue (FIFO).
 * - DFS explores as deep as possible along each branch using Recursion.
 */
public class GraphTraversal {
    static int V = 5; // Vertices: 0, 1, 2, 3, 4
    static List<List<Integer>> adj = new ArrayList<>();

    // Add an undirected edge between u and v
    static void addEdge(int u, int v) {
        adj.get(u).add(v);
        adj.get(v).add(u);
    }

    // Breadth-First Search
    static void bfs(int start) {
        boolean[] visited = new boolean[V];
        Queue<Integer> queue = new LinkedList<>();

        visited[start] = true;
        queue.add(start);

        System.out.print("BFS Traversal: ");
        while (!queue.isEmpty()) {
            int node = queue.poll();
            System.out.print(node + " ");

            for (int neighbor : adj.get(node)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    queue.add(neighbor);
                }
            }
        }
        System.out.println();
    }

    // Depth-First Search
    static void dfs(int node, boolean[] visited) {
        visited[node] = true;
        System.out.print(node + " ");

        for (int neighbor : adj.get(node)) {
            if (!visited[neighbor]) {
                dfs(neighbor, visited);
            }
        }
    }

    public static void main(String[] args) {
        // Initialize adjacency list
        for (int i = 0; i < V; i++) {
            adj.add(new ArrayList<>());
        }

        // Construct graph:
        //   0 --- 1
        //   |   / |
        //   |  /  |
        //   2 --- 3 --- 4
        addEdge(0, 1);
        addEdge(0, 2);
        addEdge(1, 2);
        addEdge(1, 3);
        addEdge(2, 3);
        addEdge(3, 4);

        // Run BFS starting from vertex 0
        bfs(0);

        // Run DFS starting from vertex 0
        System.out.print("DFS Traversal: ");
        boolean[] visited = new boolean[V];
        dfs(0, visited);
        System.out.println();
    }
}
