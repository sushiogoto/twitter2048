// Generated by CoffeeScript 1.8.0
(function() {
  var boardIsFull, buildBoard, collapseCells, endGame, generateTile, generateTileValue, getCol, getRow, hideEverything, isGameOver, mergeCells, move, moveIsValid, newGame, noValidMoves, printArray, randomCellIndices, randomInt, repeatGame, setCol, setRow, showBoard, shrinkStopFinal, totalScores,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  randomInt = function(x) {
    return Math.floor(Math.random() * x);
  };

  randomCellIndices = function() {
    return [randomInt(4), randomInt(4)];
  };

  buildBoard = function() {
    return [0, 1, 2, 3].map(function() {
      return [0, 1, 2, 3].map(function() {
        return 0;
      });
    });
  };

  generateTileValue = function() {
    var tileValue;
    tileValue = randomInt(5);
    if (tileValue < 4) {
      tileValue = 2;
    } else {
      tileValue = 4;
    }
    return tileValue;
  };

  generateTile = function(board) {
    var col, row, tileValue, _ref;
    _ref = randomCellIndices(), row = _ref[0], col = _ref[1];
    tileValue = generateTileValue();
    if (board[row][col] === 0) {
      board[row][col] = tileValue;
    } else {
      generateTile(board);
      console.log("Reset tile generation");
    }
    return console.log("row: " + row + " / col: " + col);
  };

  move = function(board, direction) {
    var column, growth, growthMultiplier, i, newBoard, row, _i, _ref, _ref1;
    newBoard = buildBoard();
    growthMultiplier = 0;
    for (i = _i = 0; _i <= 3; i = ++_i) {
      if (direction === 'right' || direction === 'left') {
        row = getRow(i, board);
        _ref = mergeCells(row, direction), row = _ref[0], growth = _ref[1];
        growthMultiplier += growth;
        row = collapseCells(row, direction);
        setRow(row, i, newBoard);
      } else if (direction === 'up' || direction === 'down') {
        column = getCol(i, board);
        _ref1 = mergeCells(column, direction), column = _ref1[0], growth = _ref1[1];
        growthMultiplier += growth;
        column = collapseCells(column, direction);
        setCol(column, i, newBoard);
      }
    }
    return [newBoard, growthMultiplier];
  };

  getRow = function(r, board) {
    return [board[r][0], board[r][1], board[r][2], board[r][3]];
  };

  getCol = function(c, board) {
    return [board[0][c], board[1][c], board[2][c], board[3][c]];
  };

  setRow = function(row, index, board) {
    return board[index] = row;
  };

  setCol = function(col, index, board) {
    var row, _i, _results;
    _results = [];
    for (row = _i = 0; _i <= 3; row = ++_i) {
      _results.push(board[row][index] = col[row]);
    }
    return _results;
  };

  mergeCells = function(cells, direction) {
    var growthMultiplier, merge;
    $('.dino').trigger("stop");
    $('.indiana').trigger("stop");
    growthMultiplier = 0;
    merge = function(cells) {
      var a, b, _i, _j, _ref;
      for (a = _i = 3; _i >= 1; a = --_i) {
        for (b = _j = _ref = a - 1; _ref <= 0 ? _j <= 0 : _j >= 0; b = _ref <= 0 ? ++_j : --_j) {
          if (cells[a] === 0) {
            break;
          } else if (cells[a] === cells[b]) {
            cells[a] *= 2;
            cells[b] = 0;
            growthMultiplier += cells[a];
          } else if (cells[b] !== 0) {
            break;
          }
        }
      }
      return cells;
    };
    switch (direction) {
      case "right":
      case "down":
        cells = merge(cells);
        break;
      case "left":
      case "up":
        cells = merge(cells.reverse()).reverse();
    }
    return [cells, growthMultiplier];
  };

  shrinkStopFinal = function(growthMulti, totalTime) {
    var timeLeft, x;
    x = parseFloat($('.board').css("zoom"));
    timeLeft = parseFloat($('.board').css("zoom")) * totalTime;
    if (growthMulti >= 8) {
      if (growthMulti >= 256) {
        $('.indiana').trigger("play");
      } else if (growthMulti >= 64) {
        $('.dino').trigger("play");
      }
      timeLeft += 1000;
      x += growthMulti / 5000;
      $('.board').stop();
      $('.board').css("zoom", x);
      return $(".board").animate({
        'zoom': 0
      }, timeLeft, void 0, (function(_this) {
        return function() {
          var _ref;
          return _ref = repeatGame(), _this.board = _ref[0], _this.score = _ref[1], _ref;
        };
      })(this));
    }
  };

  collapseCells = function(cells, direction) {
    cells = cells.filter(function(x) {
      return x !== 0;
    });
    while (cells.length < 4) {
      if (direction === 'right' || direction === 'down') {
        cells.unshift(0);
      } else if (direction === 'left' || direction === 'up') {
        cells.push(0);
      }
    }
    return cells;
  };

  moveIsValid = function(originalBoard, newBoard) {
    var col, row, _i, _j;
    for (row = _i = 0; _i <= 3; row = ++_i) {
      for (col = _j = 0; _j <= 3; col = ++_j) {
        if (originalBoard[row][col] !== newBoard[row][col]) {
          return true;
        }
      }
    }
    return false;
  };

  boardIsFull = function(board) {
    var row, _i, _len;
    for (_i = 0, _len = board.length; _i < _len; _i++) {
      row = board[_i];
      if (__indexOf.call(row, 0) >= 0) {
        return false;
      }
    }
    return true;
  };

  noValidMoves = function(board) {
    var direction, growth, newBoard, _i, _len, _ref, _ref1;
    _ref = ['left', 'right', 'up', 'down'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      direction = _ref[_i];
      _ref1 = move(board, direction), newBoard = _ref1[0], growth = _ref1[1];
      if (moveIsValid(board, newBoard)) {
        return false;
      }
    }
    return true;
  };

  isGameOver = function(board, direction) {
    return boardIsFull(board) && noValidMoves(board, direction);
  };

  showBoard = function(board) {
    var col, row, _i, _results;
    _results = [];
    for (row = _i = 0; _i <= 3; row = ++_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (col = _j = 0; _j <= 3; col = ++_j) {
          if (board[row][col] === 0) {
            _results1.push($(".r" + row + ".c" + col + " > div").html(" "));
          } else {
            _results1.push($(".r" + row + ".c" + col + " > div").html(board[row][col]));
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  printArray = function(array) {
    var row, _i, _len;
    console.log("-- Start --");
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      row = array[_i];
      console.log(row);
    }
    return console.log("-- End --");
  };

  totalScores = function(board, highscore) {
    var col, row, score, _i, _j;
    if (highscore == null) {
      highscore = 0;
    }
    score = 0;
    for (row = _i = 0; _i <= 3; row = ++_i) {
      for (col = _j = 0; _j <= 3; col = ++_j) {
        score += board[row][col];
      }
    }
    if (score > highscore) {
      highscore = score;
    }
    return [score, highscore];
  };

  repeatGame = function() {
    var newBoard, score;
    newBoard = buildBoard();
    generateTile(newBoard);
    generateTile(newBoard);
    score = 0;
    return [score, newBoard, $('#gameOverModal').modal('toggle'), $(".board").removeAttr("style"), showBoard(newBoard), $(".button-level").removeAttr("style")];
  };

  newGame = function() {
    var newBoard, score;
    newBoard = buildBoard();
    generateTile(newBoard);
    generateTile(newBoard);
    score = 0;
    return [score, newBoard, $(".board").removeAttr("style"), showBoard(newBoard), $(".button-level").removeAttr("style")];
  };

  hideEverything = function(board) {};

  endGame = function() {
    return [$(".board").stop(), $(".board").hide(), $(".button-level").removeAttr("style")];
  };

  $(function() {
    var _ref, _ref1;
    _ref = newGame(), this.score = _ref[0], this.board = _ref[1];
    _ref1 = totalScores(this.board, this.highscore), this.score = _ref1[0], this.highscore = _ref1[1];
    $(".button-level > button").click((function(_this) {
      return function(event) {
        var _ref2;
        _ref2 = newGame(), _this.score = _ref2[0], _this.board = _ref2[1];
        if (event.target.id === "easy") {
          _this.totalTime = 25000;
        } else if (event.target.id === "hard") {
          _this.totalTime = 10000;
        } else if (event.target.id === "extreme") {
          _this.totalTime = 5000;
        }
        $(".button-level").hide("fast");
        $(".title").css("display", "inline-block");
        $(".scores-container").css("display", "inline-block");
        $(".score-container").text(_this.score);
        $(".best-container").text(_this.highscore);
        $(".board").toggle();
        return $(".board").animate({
          'zoom': 0
        }, _this.totalTime, void 0, function() {
          var _ref3;
          return _ref3 = repeatGame(), _this.score = _ref3[0], _this.board = _ref3[1], _ref3;
        });
      };
    })(this));
    return $('body').keydown((function(_this) {
      return function(event) {
        var direction, growth, key, keys, newBoard, _ref2, _ref3, _ref4;
        key = event.which;
        keys = [37, 38, 39, 40];
        if (__indexOf.call(keys, key) >= 0) {
          event.preventDefault();
          console.log("key: ", key);
          direction = (function() {
            switch (key) {
              case 37:
                return "left";
              case 38:
                return "up";
              case 39:
                return "right";
              case 40:
                return "down";
            }
          })();
          console.log("direction is " + direction);
          _ref2 = move(_this.board, direction), newBoard = _ref2[0], growth = _ref2[1];
          $(".test").html(growth);
          if (moveIsValid(_this.board, newBoard)) {
            console.log("valid");
            _this.board = newBoard;
            generateTile(newBoard);
            shrinkStopFinal(growth, _this.totalTime);
            _ref3 = totalScores(_this.board, _this.highscore), _this.score = _ref3[0], _this.highscore = _ref3[1];
            $(".score-container").text(_this.score);
            $(".best-container").text(_this.highscore);
            if (isGameOver(_this.board, direction)) {
              return _ref4 = repeatGame(), _this.score = _ref4[0], _this.board = _ref4[1], _ref4;
            } else {
              return showBoard(_this.board);
            }
          } else {
            return console.log("invalid");
          }
        }
      };
    })(this));
  });

}).call(this);

//# sourceMappingURL=main.js.map
