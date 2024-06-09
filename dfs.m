function visited_nodes = dfs(image, x, y, visited_nodes)
    visited_nodes = [visited_nodes; [x, y]];
    if image(x, y - 1) ~= 255 && ismember([x (y-1)], visited_nodes, "rows") == 0
        visited_nodes = dfs(image, x, y - 1, visited_nodes);
    end
    if image(x, y + 1) ~= 255 && ismember([x (y+1)], visited_nodes, "rows") == 0
        visited_nodes = dfs(image, x, y + 1, visited_nodes);
    end
    if image(x + 1, y) ~= 255 && ismember([(x+1) y], visited_nodes, "rows") == 0
        visited_nodes = dfs(image, x + 1, y, visited_nodes);
    end
    if image(x - 1, y) ~= 255 && ismember([(x-1) y], visited_nodes, "rows") == 0
        visited_nodes = dfs(image, x - 1, y, visited_nodes);
    end
end

