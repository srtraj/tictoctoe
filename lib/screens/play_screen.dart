import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

enum MatchingType { row, column, diagonal, crossDiagonal }

class _PlayScreenState extends State<PlayScreen> {
  late List lst;
  late List colList;
  late bool isX;
  int? matchIndex;
  MatchingType? matchingType;

  @override
  void initState() {
    isX = true;
    lst = [];
    colList = [];
    for (int i = 0; i < 3; i++) {
      lst.add(["", "", ""]);
      colList.add(["", "", ""]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wt = MediaQuery.of(context).size.width;
    final ticTokSize = (wt * 0.7) / 3;
    const padding = 8.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Toc Toe"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: ticTokSize * 3 + padding * 8,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          3,
                          (colIndex) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  3,
                                  (rowIndex) => Padding(
                                    padding: EdgeInsets.all(padding),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          setValue(x: colIndex, y: rowIndex);
                                        });
                                      },
                                      child: Container(
                                        width: ticTokSize,
                                        height: ticTokSize,
                                        color: Colors.orange,
                                        child: Center(
                                            child: Text(
                                          lst[colIndex][rowIndex],
                                          style: TextStyle(
                                              color:
                                                  lst[colIndex][rowIndex] == "X"
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                  if (matchIndex != null)
                    matchingType == MatchingType.row
                        ? Positioned.fill(
                            top: matchIndex != 2
                                ? 0.0
                                : ticTokSize * 2 + padding * 4,
                            bottom: matchIndex != 0
                                ? 0
                                : ticTokSize * 2 + padding * 4,
                            child: const Divider(
                              thickness: 10,
                              color: Colors.black,
                            ),
                          )
                        : Positioned.fill(
                            left: matchIndex != 2
                                ? 0.0
                                : ticTokSize * 2 + padding * 4,
                            right: matchIndex != 0
                                ? 0
                                : ticTokSize * 2 + padding * 4,
                            child: IntrinsicHeight(
                              child: const VerticalDivider(
                                thickness: 10,
                                color: Colors.black,
                              ),
                            ),
                          )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  setValue({required int x, required int y}) {
    print("pos::::::::::::($x,$y)");
    if (lst[x][y] == "") {
      setState(() {
        lst[x][y] = isX ? "X" : "O";
        colList[y][x] = isX ? "X" : "O";
        isX = !isX;
        List diagList = [];
        List crossDiagList = [];
        for (int i = 0; i < lst.length; i++) {
          if (checkMatching(lst[i])) {
            print("row matchingg........$i");
            matchIndex = i;
            matchingType = MatchingType.row;
            return;
          }
          diagList.add(lst[i][i]);
        }
        for (int i = 0; i < colList.length; i++) {
          if (checkMatching(colList[i])) {
            print("col matchingg........");
            matchIndex = i;
            matchingType = MatchingType.column;
            return;
          }
        }
        crossDiagList = [lst[0][2], lst[1][1], lst[2][0]];
        if (checkMatching(diagList) || checkMatching(crossDiagList)) {
          print("diagonal matching.......");
          return;
        }
      });
    }
  }

  checkMatching(list) {
    return ("X".allMatches(list.join("")).length == 3 ||
        "O".allMatches(list.join("")).length == 3);
  }
}
