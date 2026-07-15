{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 5,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      70,
      70,
      1320,
      880
    ],
    "bglocked": 0,
    "openinpresentation": 0,
    "default_fontsize": 12.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 1,
    "gridsize": [
      15.0,
      15.0
    ],
    "gridsnaponopen": 1,
    "objectsnaponopen": 1,
    "statusbarvisible": 2,
    "toolbarvisible": 1,
    "lefttoolbarpinned": 0,
    "toptoolbarpinned": 0,
    "righttoolbarpinned": 0,
    "bottomtoolbarpinned": 0,
    "toolbars_unpinned_last_save": 0,
    "tallnewobj": 0,
    "boxanimatetime": 200,
    "enablehscroll": 1,
    "enablevscroll": 1,
    "devicewidth": 0.0,
    "description": "Four-family pulsing noise engine",
    "digest": "",
    "tags": "",
    "style": "",
    "subpatcher_template": "",
    "assistshowspatchername": 0,
    "boxes": [
      {
        "box": {
          "id": "title",
          "maxclass": "comment",
          "patching_rect": [
            25.0,
            20.0,
            860.0,
            26.0
          ],
          "text": "airforms_noise — breath / AM rumble / scanning radio / resonant fragments",
          "fontsize": 16.0,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "subtitle",
          "maxclass": "comment",
          "patching_rect": [
            25.0,
            48.0,
            1040.0,
            20.0
          ],
          "text": "Measured modulation regions: ~5.5, 8, 12.2, 19 Hz in the low band; ~0.6–5.8 Hz in radio-mid."
        }
      },
      {
        "box": {
          "id": "in",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            85.0,
            38.0,
            22.0
          ],
          "text": "in 1",
          "numinlets": 0,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "route",
          "maxclass": "newobj",
          "patching_rect": [
            90.0,
            85.0,
            205.0,
            22.0
          ],
          "text": "route breath rumble radio dust",
          "numinlets": 1,
          "numoutlets": 5,
          "outlettype": [
            "",
            "",
            "",
            "",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "breath-label",
          "maxclass": "comment",
          "patching_rect": [
            30.0,
            130.0,
            170.0,
            20.0
          ],
          "text": "BREATH",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "breath-unpack",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            160.0,
            130.0,
            22.0
          ],
          "text": "unpack f f f f",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "float",
            "float",
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "breath-pack",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            195.0,
            150.0,
            22.0
          ],
          "text": "pack 0. 1000. 200. 1000.",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "breath-msg",
          "maxclass": "message",
          "patching_rect": [
            30.0,
            230.0,
            178.0,
            22.0
          ],
          "text": "0., $1 $2 $1 $3 0. $4",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "breath-line",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            265.0,
            54.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "breath-noise",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            310.0,
            50.0,
            22.0
          ],
          "text": "noise~",
          "numinlets": 0,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-low",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            345.0,
            100.0,
            22.0
          ],
          "text": "lores~ 1700. 0.35",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-hip",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            380.0,
            55.0,
            22.0
          ],
          "text": "hip~ 30.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-reson",
          "maxclass": "newobj",
          "patching_rect": [
            145.0,
            345.0,
            112.0,
            22.0
          ],
          "text": "reson~ 0.35 320. 2.5",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-sum",
          "maxclass": "newobj",
          "patching_rect": [
            90.0,
            420.0,
            38.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-mul",
          "maxclass": "newobj",
          "patching_rect": [
            90.0,
            455.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-left",
          "maxclass": "newobj",
          "patching_rect": [
            55.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.42",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "breath-right",
          "maxclass": "newobj",
          "patching_rect": [
            125.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.35",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-label",
          "maxclass": "comment",
          "patching_rect": [
            320.0,
            130.0,
            250.0,
            20.0
          ],
          "text": "AM RUMBLE / TRACTOR",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "rumble-unpack",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            160.0,
            230.0,
            22.0
          ],
          "text": "unpack f f f f f f f",
          "numinlets": 1,
          "numoutlets": 7,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "float",
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-pack",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            195.0,
            150.0,
            22.0
          ],
          "text": "pack 0. 1000. 200. 1000.",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "rumble-msg",
          "maxclass": "message",
          "patching_rect": [
            320.0,
            230.0,
            178.0,
            22.0
          ],
          "text": "0., $1 $2 $1 $3 0. $4",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "rumble-line",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            265.0,
            54.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-noise",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            310.0,
            50.0,
            22.0
          ],
          "text": "noise~",
          "numinlets": 0,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-low",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            345.0,
            92.0,
            22.0
          ],
          "text": "lores~ 150. 0.72",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-noise-gain",
          "maxclass": "newobj",
          "patching_rect": [
            320.0,
            380.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.65",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "hum-a",
          "maxclass": "newobj",
          "patching_rect": [
            430.0,
            310.0,
            72.0,
            22.0
          ],
          "text": "cycle~ 49.8",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "hum-a-gain",
          "maxclass": "newobj",
          "patching_rect": [
            430.0,
            345.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.18",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "hum-b",
          "maxclass": "newobj",
          "patching_rect": [
            515.0,
            310.0,
            75.0,
            22.0
          ],
          "text": "cycle~ 55.18",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "hum-b-gain",
          "maxclass": "newobj",
          "patching_rect": [
            515.0,
            345.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.14",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-sum-a",
          "maxclass": "newobj",
          "patching_rect": [
            405.0,
            405.0,
            38.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-sum-b",
          "maxclass": "newobj",
          "patching_rect": [
            455.0,
            440.0,
            38.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-clip",
          "maxclass": "newobj",
          "patching_rect": [
            455.0,
            475.0,
            92.0,
            22.0
          ],
          "text": "clip~ -0.7 0.7",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-a",
          "maxclass": "newobj",
          "patching_rect": [
            610.0,
            310.0,
            55.0,
            22.0
          ],
          "text": "cycle~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-a-gain",
          "maxclass": "newobj",
          "patching_rect": [
            610.0,
            345.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.32",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-b",
          "maxclass": "newobj",
          "patching_rect": [
            680.0,
            310.0,
            55.0,
            22.0
          ],
          "text": "cycle~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-b-gain",
          "maxclass": "newobj",
          "patching_rect": [
            680.0,
            345.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.23",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-sum",
          "maxclass": "newobj",
          "patching_rect": [
            640.0,
            390.0,
            38.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "am-offset",
          "maxclass": "newobj",
          "patching_rect": [
            640.0,
            425.0,
            58.0,
            22.0
          ],
          "text": "+~ 0.55",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-am",
          "maxclass": "newobj",
          "patching_rect": [
            560.0,
            515.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-env",
          "maxclass": "newobj",
          "patching_rect": [
            560.0,
            550.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-left",
          "maxclass": "newobj",
          "patching_rect": [
            525.0,
            590.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.62",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "rumble-right",
          "maxclass": "newobj",
          "patching_rect": [
            595.0,
            590.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.48",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-label",
          "maxclass": "comment",
          "patching_rect": [
            770.0,
            130.0,
            250.0,
            20.0
          ],
          "text": "SCANNING RADIO INTERFERENCE",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "radio-unpack",
          "maxclass": "newobj",
          "patching_rect": [
            770.0,
            160.0,
            280.0,
            22.0
          ],
          "text": "unpack f f f f f f f f f",
          "numinlets": 1,
          "numoutlets": 9,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "float",
            "float",
            "float",
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "radio-centre-pack",
          "maxclass": "newobj",
          "patching_rect": [
            770.0,
            195.0,
            100.0,
            22.0
          ],
          "text": "pack 0. 0. 1000.",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "radio-centre-msg",
          "maxclass": "message",
          "patching_rect": [
            770.0,
            230.0,
            90.0,
            22.0
          ],
          "text": "$1, $2 $3",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "radio-centre-line",
          "maxclass": "newobj",
          "patching_rect": [
            770.0,
            265.0,
            54.0,
            22.0
          ],
          "text": "line~ 800.",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "radio-env-pack",
          "maxclass": "newobj",
          "patching_rect": [
            875.0,
            195.0,
            150.0,
            22.0
          ],
          "text": "pack 0. 1000. 200. 1000.",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "radio-env-msg",
          "maxclass": "message",
          "patching_rect": [
            875.0,
            230.0,
            178.0,
            22.0
          ],
          "text": "0., $1 $2 $1 $3 0. $4",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "radio-env-line",
          "maxclass": "newobj",
          "patching_rect": [
            875.0,
            265.0,
            54.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "radio-noise",
          "maxclass": "newobj",
          "patching_rect": [
            770.0,
            310.0,
            50.0,
            22.0
          ],
          "text": "noise~",
          "numinlets": 0,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-reson",
          "maxclass": "newobj",
          "patching_rect": [
            770.0,
            345.0,
            115.0,
            22.0
          ],
          "text": "reson~ 0.72 800. 12.",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-am-cycle",
          "maxclass": "newobj",
          "patching_rect": [
            900.0,
            310.0,
            55.0,
            22.0
          ],
          "text": "cycle~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-am-gain",
          "maxclass": "newobj",
          "patching_rect": [
            900.0,
            345.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.46",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-am-offset",
          "maxclass": "newobj",
          "patching_rect": [
            900.0,
            380.0,
            58.0,
            22.0
          ],
          "text": "+~ 0.54",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-am",
          "maxclass": "newobj",
          "patching_rect": [
            820.0,
            420.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-env",
          "maxclass": "newobj",
          "patching_rect": [
            820.0,
            455.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-left",
          "maxclass": "newobj",
          "patching_rect": [
            790.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.38",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "radio-right",
          "maxclass": "newobj",
          "patching_rect": [
            860.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.68",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dust-label",
          "maxclass": "comment",
          "patching_rect": [
            1065.0,
            130.0,
            210.0,
            20.0
          ],
          "text": "RESONANT FRAGMENTS",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "dust-unpack",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            160.0,
            130.0,
            22.0
          ],
          "text": "unpack f f f f",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "float",
            "float",
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "dust-pack",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            195.0,
            78.0,
            22.0
          ],
          "text": "pack 0. 100.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "dust-msg",
          "maxclass": "message",
          "patching_rect": [
            1065.0,
            230.0,
            105.0,
            22.0
          ],
          "text": "0., $1 5. 0. $2",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "dust-line",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            265.0,
            54.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "dust-noise",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            310.0,
            50.0,
            22.0
          ],
          "text": "noise~",
          "numinlets": 0,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dust-reson",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            345.0,
            120.0,
            22.0
          ],
          "text": "reson~ 0.8 1200. 10.",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dust-mul",
          "maxclass": "newobj",
          "patching_rect": [
            1065.0,
            380.0,
            38.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dust-left",
          "maxclass": "newobj",
          "patching_rect": [
            1030.0,
            420.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.55",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dust-right",
          "maxclass": "newobj",
          "patching_rect": [
            1100.0,
            420.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.75",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "out-left",
          "maxclass": "newobj",
          "patching_rect": [
            545.0,
            760.0,
            48.0,
            22.0
          ],
          "text": "out~ 1",
          "numinlets": 1,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "out-right",
          "maxclass": "newobj",
          "patching_rect": [
            655.0,
            760.0,
            48.0,
            22.0
          ],
          "text": "out~ 2",
          "numinlets": 1,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "out-label",
          "maxclass": "comment",
          "patching_rect": [
            520.0,
            805.0,
            245.0,
            20.0
          ],
          "text": "stereo sum to the main patch"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "in",
            0
          ],
          "destination": [
            "route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            0
          ],
          "destination": [
            "breath-unpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-unpack",
            0
          ],
          "destination": [
            "breath-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-unpack",
            1
          ],
          "destination": [
            "breath-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-unpack",
            2
          ],
          "destination": [
            "breath-pack",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-unpack",
            3
          ],
          "destination": [
            "breath-pack",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-pack",
            0
          ],
          "destination": [
            "breath-msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-msg",
            0
          ],
          "destination": [
            "breath-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-noise",
            0
          ],
          "destination": [
            "breath-low",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-noise",
            0
          ],
          "destination": [
            "breath-reson",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-low",
            0
          ],
          "destination": [
            "breath-hip",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-hip",
            0
          ],
          "destination": [
            "breath-sum",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-reson",
            0
          ],
          "destination": [
            "breath-sum",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-sum",
            0
          ],
          "destination": [
            "breath-mul",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-line",
            0
          ],
          "destination": [
            "breath-mul",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-mul",
            0
          ],
          "destination": [
            "breath-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-mul",
            0
          ],
          "destination": [
            "breath-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            1
          ],
          "destination": [
            "rumble-unpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            0
          ],
          "destination": [
            "rumble-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            1
          ],
          "destination": [
            "rumble-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            2
          ],
          "destination": [
            "rumble-pack",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            3
          ],
          "destination": [
            "rumble-pack",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-pack",
            0
          ],
          "destination": [
            "rumble-msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-msg",
            0
          ],
          "destination": [
            "rumble-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            4
          ],
          "destination": [
            "am-a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            5
          ],
          "destination": [
            "am-b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-unpack",
            6
          ],
          "destination": [
            "rumble-low",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-noise",
            0
          ],
          "destination": [
            "rumble-low",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-low",
            0
          ],
          "destination": [
            "rumble-noise-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "hum-a",
            0
          ],
          "destination": [
            "hum-a-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "hum-b",
            0
          ],
          "destination": [
            "hum-b-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-noise-gain",
            0
          ],
          "destination": [
            "rumble-sum-a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "hum-a-gain",
            0
          ],
          "destination": [
            "rumble-sum-a",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-sum-a",
            0
          ],
          "destination": [
            "rumble-sum-b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "hum-b-gain",
            0
          ],
          "destination": [
            "rumble-sum-b",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-sum-b",
            0
          ],
          "destination": [
            "rumble-clip",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-a",
            0
          ],
          "destination": [
            "am-a-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-b",
            0
          ],
          "destination": [
            "am-b-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-a-gain",
            0
          ],
          "destination": [
            "am-sum",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-b-gain",
            0
          ],
          "destination": [
            "am-sum",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-sum",
            0
          ],
          "destination": [
            "am-offset",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-clip",
            0
          ],
          "destination": [
            "rumble-am",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "am-offset",
            0
          ],
          "destination": [
            "rumble-am",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-am",
            0
          ],
          "destination": [
            "rumble-env",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-line",
            0
          ],
          "destination": [
            "rumble-env",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-env",
            0
          ],
          "destination": [
            "rumble-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-env",
            0
          ],
          "destination": [
            "rumble-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            2
          ],
          "destination": [
            "radio-unpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            0
          ],
          "destination": [
            "radio-centre-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            1
          ],
          "destination": [
            "radio-centre-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            2
          ],
          "destination": [
            "radio-centre-pack",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-centre-pack",
            0
          ],
          "destination": [
            "radio-centre-msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-centre-msg",
            0
          ],
          "destination": [
            "radio-centre-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            3
          ],
          "destination": [
            "radio-reson",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            4
          ],
          "destination": [
            "radio-am-cycle",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            5
          ],
          "destination": [
            "radio-env-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            6
          ],
          "destination": [
            "radio-env-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            7
          ],
          "destination": [
            "radio-env-pack",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-unpack",
            8
          ],
          "destination": [
            "radio-env-pack",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-env-pack",
            0
          ],
          "destination": [
            "radio-env-msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-env-msg",
            0
          ],
          "destination": [
            "radio-env-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-noise",
            0
          ],
          "destination": [
            "radio-reson",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-centre-line",
            0
          ],
          "destination": [
            "radio-reson",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-am-cycle",
            0
          ],
          "destination": [
            "radio-am-gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-am-gain",
            0
          ],
          "destination": [
            "radio-am-offset",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-reson",
            0
          ],
          "destination": [
            "radio-am",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-am-offset",
            0
          ],
          "destination": [
            "radio-am",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-am",
            0
          ],
          "destination": [
            "radio-env",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-env-line",
            0
          ],
          "destination": [
            "radio-env",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-env",
            0
          ],
          "destination": [
            "radio-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-env",
            0
          ],
          "destination": [
            "radio-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            3
          ],
          "destination": [
            "dust-unpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-unpack",
            0
          ],
          "destination": [
            "dust-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-unpack",
            1
          ],
          "destination": [
            "dust-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-unpack",
            2
          ],
          "destination": [
            "dust-reson",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-unpack",
            3
          ],
          "destination": [
            "dust-reson",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-pack",
            0
          ],
          "destination": [
            "dust-msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-msg",
            0
          ],
          "destination": [
            "dust-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-noise",
            0
          ],
          "destination": [
            "dust-reson",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-reson",
            0
          ],
          "destination": [
            "dust-mul",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-line",
            0
          ],
          "destination": [
            "dust-mul",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-mul",
            0
          ],
          "destination": [
            "dust-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-mul",
            0
          ],
          "destination": [
            "dust-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-left",
            0
          ],
          "destination": [
            "out-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-left",
            0
          ],
          "destination": [
            "out-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-left",
            0
          ],
          "destination": [
            "out-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-left",
            0
          ],
          "destination": [
            "out-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "breath-right",
            0
          ],
          "destination": [
            "out-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rumble-right",
            0
          ],
          "destination": [
            "out-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "radio-right",
            0
          ],
          "destination": [
            "out-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dust-right",
            0
          ],
          "destination": [
            "out-right",
            0
          ]
        }
      }
    ],
    "dependency_cache": [],
    "autosave": 0
  }
}
