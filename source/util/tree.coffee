
# get list of components from tree
exports.flatten = (tree) ->
  collection = []

  resolve = (tree, parent) ->
    unless tree.category is 'component'
      throw new Error 'accepts component'

    {children} = tree
    tree.parent = -> parent or null
    collection.push tree
    children.forEach (child) ->
      if child.category is 'component'
        tree.children = null
        resolve child, tree
      else # sould be canvas
        collection.push child

  resolve tree

  collection