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
  validDirection = ['right', 'left', 'up', 'down']
  for i in [0..3]
    if direction in validDirection
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)

  newBoard
  # board = newBoard
  # showBoard(board)

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

getCol = (c, board) ->
  [board[0][c], board[1][c], board[2][c], board[3][c]]

setRow = (row, index, board) ->
  board[index] = row

# getCol = (c, board) ->
#   [board[0][c], board[1][c], board[2][c], board[3][c]]

mergeCells = (row, direction) ->

  merge = (row) ->
    for a in [3..1]
      for b in [a-1..0]
        if row[a] is 0 then break
        else if row[a] == row[b]
          row[a] *= 2
          row[b] = 0
        else if row[b] isnt 0 then break
    row
  # else if direction == "left"
  #   for a in [1..3]
  #     for b in [0..a-1]
  #       if row[a] is 0 then break
  #       else if row[a] == row[b]
  #         row[b] *= 2
  #         row[a] = 0
  #       else if row[b] isnt a-1 then break
  switch direction
    when "right"
      row = merge row
    when "left"
      row = merge(row.reverse()).reverse()
  row

collapseCells = (row, direction) ->
  row = row.filter (x) -> x isnt 0
  while row.length < 4
      if direction is 'right'
        row.unshift 0
      else if direction == 'left'
        row.push 0
  # if direction is 'left'
  #   while row.length < 4
  #     row.push 0
  row

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false

boardIsFull = (board) ->
  # for row in board
  #   for e in row
  #     if e is 0
  #       return false
  # true
  for row in board
    if 0 in row
      return false
  true

noValidMoves = (board) ->
  direction = 'right'
  newBoard = move(board, direction)
  if moveIsValid(board, newBoard)
    return false
  true

isGameOver = (board) ->
  boardIsFull(board) and noValidMoves(board)

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      if board[row][col] == 0
        $(".r#{row}.c#{col} > div").html(" ")
      else
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
  # $('.board').scale(2);
  $( "#clickme" ).click =>
    $( ".board" ).animate(
      opacity: "toggle",
      left: "+=50",
      height: "toggle",
      # 'zoom': 0,
      5000)

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
        generateTile(newBoard)
        @board = newBoard
        #generate tile
        showBoard(@board)
        #show board
        #check game lost
        if isGameOver(@board)
          console.log "YOU LOSE!"
      else
          console.log "invalid"

    else