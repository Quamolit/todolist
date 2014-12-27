
# get list of components from tree
exports.flatten = (tree) ->
  collection = []

  resolve = (tree, parent) ->
    unless tree.category is 'component'
      throw new Error 'accepts component'

    {children} = tree
    tree.parent = -> parent or null
    tree.children = null
    collection.push tree
    children.forEach (child) ->
      if child.category is 'component'
        resolve child, tree

  resolve tree

  collection