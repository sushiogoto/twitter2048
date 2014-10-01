randomInt = (x) ->
  Math.floor(Math.random() * x)

randomCellIndices = ->
  [randomInt(4), randomInt(4)]

buildBoard = ->
  # board = []
  # for row in [0..3]
  #   board[row] = []
  #   for column in [0..3]
  #     board[row][column] = 0
  # console.log "build board"
  # console.log board
  # board
  [0..3].map -> [0..3].map -> 0

generateTileValue = ->
  tileValue = randomInt(5)
  if tileValue < 4
    tileValue = 2
  else
    tileValue = 4
  tileValue

generateTile = (board) ->
  [row, col] = randomCellIndices()
  tileValue = generateTileValue()
  if board[row][col] == 0
    board[row][col] = tileValue
  else
    generateTile(board)
    console.log "Reset tile generation"
  console.log board

printArray = (array) ->
  for row in array
    console.log row

$ ->
  board = buildBoard()
  generateTile(board)
  generateTile(board)

  printArray(board)