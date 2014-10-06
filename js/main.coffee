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
  # validDirection = ['right', 'left', 'up', 'down']
  for i in [0..3]
    if direction is 'right' or direction is 'left'
      row = getRow(i, board)
      [row, growth] = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
    else if direction is 'up' or direction is 'down'
      column = getCol(i, board)
      [column, growth] = mergeCells(column, direction)
      column = collapseCells(column, direction)
      setCol(column, i, newBoard)

  [newBoard, growth]
  # board = newBoard
  # showBoard(board)

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

getCol = (c, board) ->
  [board[0][c], board[1][c], board[2][c], board[3][c]]

setRow = (row, index, board) ->
  board[index] = row

setCol = (col, index, board) ->
  for row in [0..3]
    board[row][index] = col[row]

# getCol = (c, board) ->
#   [board[0][c], board[1][c], board[2][c], board[3][c]]

mergeCells = (cells, direction) ->
  $('.dino').trigger("stop")
  growthMultiplier = 0
  merge = (cells) ->
    for a in [3..1]
      for b in [a-1..0]
        if cells[a] is 0 then break
        else if cells[a] == cells[b]
          cells[a] *= 2
          cells[b] = 0
          growthMultiplier += cells[a]
          # if cells[a] >= 64
          #   $('.dino').trigger("play")
        else if cells[b] isnt 0 then break
    cells
  # else if direction == "left"
  #   for a in [1..3]
  #     for b in [0..a-1]
  #       if row[a] is 0 then break
  #       else if row[a] == row[b]
  #         row[b] *= 2
  #         row[a] = 0
  #       else if row[b] isnt a-1 then break
  switch direction
    when "right", "down"
      cells = merge cells
    when "left", "up"
      cells = merge(cells.reverse()).reverse()
  [cells, growthMultiplier]

shrinkStopFinal = (growthMulti, totalTime) ->
  x = parseFloat($('.board').css("zoom"))
  timeLeft = parseFloat($('.board').css("zoom")) * totalTime

  if growthMulti >= 8

    timeLeft += 1000
    x += growthMulti / 5000
    $('.board').stop()
    $('.board').css("zoom", x)
    $('.dino').trigger("play")
    $(".board" ).animate(
      'zoom': 0,
      timeLeft,
      undefined,
      =>
        [@board, @score] = newGame()
    )
# shrinkStop = (mergeValue) ->
#   finalValue = mergeValue
#   finalValue



collapseCells = (cells, direction) ->
  cells = cells.filter (x) -> x isnt 0
  while cells.length < 4
      if direction in ['right', 'down']
        cells.unshift 0
      else if direction in ['left', 'up']
        cells.push 0
  # if direction is 'left'
  #   while row.length < 4
  #     row.push 0
  cells

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
  for direction in ['left', 'right', 'up', 'down']
    [newBoard, growth] = move(board, direction)
    return false if moveIsValid(board, newBoard)
  true

isGameOver = (board, direction) ->
  boardIsFull(board) and noValidMoves(board, direction)

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

totalScores = (board, highscore = 0) ->
  score = 0
  for row in [0..3]
    for col in [0..3]
      score += board[row][col]
  if score > highscore
    highscore = score
  [score, highscore]

newGame = () ->
  newBoard = buildBoard()
  generateTile(newBoard)
  generateTile(newBoard)
  score = 0
  [score, newBoard, $(".board").removeAttr("style"), showBoard(newBoard), $(".button-level").removeAttr("style")]

hideEverything = (board) ->

  # [newGame(), $(".board").removeAttr("style"), $(".score-container").text(0), $(".best-container").text(@highscore), $(".button-level").removeAttr("style"), $(".board" ).stop(), $(".board" ).hide("fast")]

endGame = () ->
  [$(".board" ).stop(), $(".board" ).hide(), $(".button-level").removeAttr("style")]
$ ->
  # if $(".board").width() < 450
  #   alert "hello"
  # $('.board').scale(2);
  [@score, @board] = newGame()
  [@score, @highscore] = totalScores(@board, @highscore)
  $(".button-level > button" ).click (event) =>
    [@score, @board] = newGame()
    if event.target.id == "hard"
      @totalTime = 10000
    else if event.target.id == "easy"
      @totalTime = 50000
    $(".button-level").hide("fast")
    $(".title").css("display", "inline-block")
    $(".scores-container").css("display", "inline-block")
    $(".score-container").text(@score)
    $(".best-container").text(@highscore)
    $(".board" ).toggle()
    $(".board" ).animate(
      # left: "+=50",
      # : "toggle",
      'zoom': 0,
      @totalTime,
      undefined,
      =>
        # showBoard(@board)
        # $(".button-level").removeAttr("style")
        # $(".board" ).stop()
        # $(".board" ).hide("fast")
        [@score, @board] = newGame()
    )


    # setTimeout(=>
    #   [@score, @board] = newGame()
    # , 60500)

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
      [newBoard, growth] = move(@board, direction)
      #check move is valid
      if moveIsValid(@board, newBoard)
        console.log "valid"
        @board = newBoard
        generateTile(newBoard)
        shrinkStopFinal(growth, @totalTime)
        #generate tile
        #check game lost
        [@score, @highscore] = totalScores(@board, @highscore)
        $(".score-container").text(@score)
        $(".best-container").text(@highscore)
        if isGameOver(@board, direction)
          alert "YOU LOSE! YOU SUCK! HAHAHA"
          [@score, @board] = newGame()
          #show board
        else
          showBoard(@board)
          #show board

      else
          console.log "invalid"