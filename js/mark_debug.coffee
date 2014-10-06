# Each of the following blocks of code has only one error.
# Determine what it is by reading the code. Do not try to run it.

##############################
# What's wrong with this function?

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[col][row]
      # if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false


##############################
# What's wrong with this block of code? (unlike the others, this exercise has 3 things wrong!)

boardIsFull = (board) ->
  for row in board
    for elem in board
    # for elem in row
      if elem is 0
        return false
  return true

newBoard = createBoard()
# function not defined
canMove = boardIsFull(board)
# argument not defined -> should be newBoard


##############################
# What's wrong with the logic of this function?

canGameContinue = (board) ->
  not boardIsFull(board) and noValidMoves(board)

# noValidMoves returns true if there are no valid moves left
# if this is the case, the game cannot continue - it should
# be not noValidMoves(board)


##############################
# What's wrong with this function?

createEmptyBoard = () ->
  board = []
  for row in [0..3]
    for col in [0..3]
      board[row][col] = 0
  board

# row is not defined in board as an array, so cannot treat it as one
##############################
# What's wrong with this block of code?

setRow = (board, rowIndex, rowArray) ->
  board[rowIndex] = rowArray

# ...no idea these arguments aren't defined perhaps?

# (...other code...)
# (assume board is defined and the collapseRow function exists and works correctly)
  if direction == 'right'
    for r in [0..3]
      newRow = collapseRow(r)
      setRow(board, newRow, r)
# (...other code...)

# the collapseRow isn't needed
##############################
# What's wrong with this function? (don't look back at the earlier moveIsValid function!)

moveIsValid = () ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false

# it isn't taking in any arguments (namely, originalBoard and newBoard)
##############################
# What's wrong with this block of code?

nthElementFromLast = (array, n) ->
  arr[arr.length - n]

myNumbers = [4, 7, 11, 12]
# this should display 11
console.log nthElementFromLast myNumbers, 2
# it should be arr.length - n - 1

##############################
# What's wrong with this function?

areArraysSame = (array1, array2) ->
  areSame = true
  if array1.length isnt array2.length
    areSame = false
  for index in [0...array1.length]
    if array1[index] isnt array2[index]
      areSame = false
# areSame

##############################
# When this code is run, it displays "You want to go horizontally". Why?
# non empty strings in javascript are true, so the first if statement evalutes to false or true, which runs
direction = 'up'

if direction is 'left' or 'right'
  console.log "You want to go horizontally"
else if direction is 'up' or 'down'
  console.log "You want to go vertically"