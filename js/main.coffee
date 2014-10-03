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
  console.log "row: #{row} / col: #{col}"


# merge = (board, direction, row, col) ->
#   if direction == "left" or direction == "right"
#     for e, i in row

#   else if direction == "up" or direction == "down"
#     for e, i in col

move = (board, direction) ->
  newBoard = buildBoard()

  for i in [0..3]
    if direction is 'right'
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)

  newBoard
  # board = newBoard
  # showBoard(board)

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

setRow = (row, index, board) ->
  board[index] = row

# getCol = (c, board) ->
#   [board[0][c], board[1][c], board[2][c], board[3][c]]

mergeCells = (row, direction) ->
  if direction == "right"
    for a in [3..1]
      for b in [a-1..0]
        if row[a] is 0 then break
        else if row[a] == row[b]
          console.log 'merge'
          row[a] *= 2
          row[b] = 0
        else if row[b] isnt 0 then break
  # else if direction == "left"
  #   for a in [1..3]
  #     for b in [1..a-1]
  #       # console.log a,b
  row

collapseCells = (row, direction) ->
  row = row.filter (x) -> x isnt 0
  if direction is 'right'
    while row.length < 4
      row.unshift 0
  # else if direction == 'left'
  #   while row.length < 4
  #     row.push 0
  row

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false

isGameOver = (board) ->
  boardIsFull(board) and noValidMoves(board)

boardIsFull = (board) ->
  true

noValidMoves = (board) ->
  true

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      $(".r#{row}.c#{col} > div").html(board[row][col])

printArray = (array) ->
  console.log "-- Start --"
  for row in array
    console.log row
  console.log "-- End --"

$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  showBoard(@board)

  $('body').keydown (event) =>

    key = event.which
    keys = [37..40]

    if key in keys
      event.preventDefault()
      console.log "key: ", key
      direction = switch key
        when 37 then "left"
        when 38 then "up"
        when 39 then "right"
        when 40 then "down"

      console.log "direction is #{direction}"

      #try moving
      newBoard = move(@board, direction)
      printArray newBoard
      #check move is valid
      if moveIsValid(@board, newBoard)
        console.log "valid"
        @board = newBoard
        #generate tile
        generateTile(@board)
        #show board
        showBoard(@board)
        #check game lost
        if isGameOver(@board)
          console.log "YOU LOSE!"
      else
        console.log "invalid"

    else