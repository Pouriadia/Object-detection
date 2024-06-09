function [min_x, min_y, max_x, max_y] = visit(image,coordinates)
    visited_nodes = [];
    visited_nodes = dfs(image, coordinates(1), coordinates(2), visited_nodes);
    min_values = min(visited_nodes, [], 1);
    max_values = max(visited_nodes, [], 1);
    min_x = min_values(1);
    min_y = min_values(2);
    max_x = max_values(1);
    max_y = max_values(2);
end

