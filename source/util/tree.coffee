
# get list of components from tree
exports.flatten = (tree) ->
  collection = []

  resolve = (tree, parent) ->
    tree.parent = -> parent or null
    {children} = tree
    tree.children = null
    collection.push tree
    if children?
      children.forEach (child) ->
        resolve child, tree

  resolve tree

  collection