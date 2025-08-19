import 'package:flutter/material.dart';

List<Shadow> getShadows() {
  return [
    Shadow(
      color: Color.fromARGB(230, 0, 0, 0),
      offset: Offset(0, 0),
      blurRadius: 4,
    ),
    Shadow(
      color: Color.fromARGB(153, 0, 0, 0),
      offset: Offset(0, 0),
      blurRadius: 8,
    ),
    Shadow(
      color: Color.fromARGB(77, 0, 0, 0),
      offset: Offset(0, 0),
      blurRadius: 12,
    ),
    //   Shadow(
    //     color: const Color.fromARGB(204, 0, 0, 0),
    //     offset: Offset(1, 1),
    //     blurRadius: 3,
    //   ),
    //   Shadow(
    //     color: const Color.fromARGB(102, 0, 0, 0),
    //     offset: Offset(2, 2),
    //     blurRadius: 6,
    //   ),
  ];
}
