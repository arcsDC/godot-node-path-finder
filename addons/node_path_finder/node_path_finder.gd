@tool
class_name NodePathFinder
extends RefCounted

## Finds nodes by exact name.
static func find_by_name(root: Node, name: String, recursive: bool = true) -> Array[Node]:
    var results: Array[Node] = []
    _search(root, name, recursive, results)
    return results

## Finds nodes by script path.
static func find_by_script(root: Node, script_path: String, recursive: bool = true) -> Array[Node]:
    var results: Array[Node] = []
    for node in _get_all_nodes(root, recursive):
        if node is Node and node.get_script() and node.get_script().resource_path == script_path:
            results.append(node)
    return results

## Finds nodes by class name.
static func find_by_class(root: Node, class_name: String, recursive: bool = true) -> Array[Node]:
    var results: Array[Node] = []
    for node in _get_all_nodes(root, recursive):
        if node is Node and node.get_class() == class_name:
            results.append(node)
    return results

## Returns the first node matching the name, or null.
static func find_first(root: Node, name: String) -> Node:
    var matches = find_by_name(root, name)
    return matches[0] if matches.size() > 0 else null

static func _search(node: Node, name: String, recursive: bool, results: Array[Node]) -> void:
    if node.name == name:
        results.append(node)
    if recursive:
        for child in node.get_children():
            _search(child, name, true, results)

static func _get_all_nodes(root: Node, recursive: bool) -> Array[Node]:
    var nodes: Array[Node] = []
    if recursive:
        _collect_all(root, nodes)
    else:
        for child in root.get_children():
            nodes.append(child)
    return nodes

static func _collect_all(node: Node, nodes: Array[Node]) -> void:
    for child in node.get_children():
        nodes.append(child)
        _collect_all(child, nodes)
