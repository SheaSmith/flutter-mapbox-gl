// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'page.dart';

class PlaceFillPage extends Page {
  PlaceFillPage() : super(const Icon(Icons.check_circle), 'Place fill');

  @override
  Widget build(BuildContext context) {
    return const PlaceFillBody();
  }
}

class PlaceFillBody extends StatefulWidget {
  const PlaceFillBody();

  @override
  State<StatefulWidget> createState() => PlaceFillBodyState();
}

class PlaceFillBodyState extends State<PlaceFillBody> {
  PlaceFillBodyState();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  MapboxMapController controller;
  int _fillCount = 0;
  Fill _selectedFill;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onFillTapped.add(_onFillTapped);
  }

  @override
  void dispose() {
    controller?.onFillTapped?.remove(_onFillTapped);
    super.dispose();
  }

  void _onFillTapped(Fill fill) {
    if (_selectedFill != null) {
      _updateSelectedFill(
        const FillOptions(fillColor: "rgba(255, 255, 255, 1)"),
      );
    }
    setState(() {
      _selectedFill = fill;
    });
  }

  void _updateSelectedFill(FillOptions changes) {
    controller.updateFill(_selectedFill, changes);
  }

  void _add() {
    controller.addFill(
      FillOptions(
          geometry: [LatLng(0.0, 0.0), LatLng(10.0, 0.0), LatLng(20.0, 30.0), LatLng(0.0,0.0)],
          fillColor: "#FF0000"),
    );
    setState(() {
      _fillCount += 1;
    });
  }

  void _remove() {
    controller.removeFill(_selectedFill);
    setState(() {
      _selectedFill = null;
      _fillCount -= 1;
    });
  }

  Future<void> _changeFillOpacity() async {
    double current = _selectedFill.options.fillOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    _updateSelectedFill(
      FillOptions(fillOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changeFillColor() async {
    String current = _selectedFill.options.fillColor;
    if (current == null) {
      // default value
      current = "#FF0000";
    }

    _updateSelectedFill(
      FillOptions(
          fillColor: "#FFFF00"),
    );
  }

  Future<void> _changeFillStrokeColor() async {
    String current = _selectedFill.options.fillOutlineColor;
    if (current == null) {
      // default value
      current = "#FFFFFF";
    }

    _updateSelectedFill(
      FillOptions(
          fillOutlineColor: current == "#FFFFFF" ? "#FF0000" : "#FFFFFF"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: MapboxMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.852, 151.211),
                zoom: 11.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: (_fillCount == 12) ? null : _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: (_selectedFill == null) ? null : _remove,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change fill-opacity'),
                          onPressed:
                              (_selectedFill == null) ? null : _changeFillOpacity,
                        ),
                        FlatButton(
                          child: const Text('change fill-color'),
                          onPressed:
                          (_selectedFill == null) ? null : _changeFillColor,
                        ),
                        FlatButton(
                          child: const Text('change fill-stroke-color'),
                          onPressed: (_selectedFill == null)
                              ? null
                              : _changeFillStrokeColor,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}