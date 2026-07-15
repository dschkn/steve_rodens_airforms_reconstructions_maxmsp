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
      90,
      90,
      760,
      480
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
    "description": "One independently delayed spectral partial",
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
            520.0,
            24.0
          ],
          "text": "airforms_partial — independently delayed spectral crystal",
          "fontsize": 14.0,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "in",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            75.0,
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
            30.0,
            115.0,
            104.0,
            22.0
          ],
          "text": "route event stop",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "unpack",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            160.0,
            240.0,
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
          "id": "freq-comment",
          "maxclass": "comment",
          "patching_rect": [
            30.0,
            205.0,
            220.0,
            20.0
          ],
          "text": "frequency + event-to-event glide"
        }
      },
      {
        "box": {
          "id": "freq-pack",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            235.0,
            84.0,
            22.0
          ],
          "text": "pack 0. 500.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "freq-line",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            275.0,
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
          "id": "cycle",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            315.0,
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
          "id": "env-comment",
          "maxclass": "comment",
          "patching_rect": [
            300.0,
            205.0,
            360.0,
            20.0
          ],
          "text": "delay → attack → hold → release (compound line~ ramp)"
        }
      },
      {
        "box": {
          "id": "env-pack",
          "maxclass": "newobj",
          "patching_rect": [
            300.0,
            235.0,
            190.0,
            22.0
          ],
          "text": "pack 0. 0. 1000. 200. 1000.",
          "numinlets": 5,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "env-message",
          "maxclass": "message",
          "patching_rect": [
            300.0,
            275.0,
            225.0,
            22.0
          ],
          "text": "0., 0. $2 $1 $3 $1 $4 0. $5",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "env-line",
          "maxclass": "newobj",
          "patching_rect": [
            300.0,
            315.0,
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
          "id": "stop-message",
          "maxclass": "message",
          "patching_rect": [
            560.0,
            150.0,
            58.0,
            22.0
          ],
          "text": "0. 200.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "multiply",
          "maxclass": "newobj",
          "patching_rect": [
            150.0,
            360.0,
            45.0,
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
          "id": "out",
          "maxclass": "newobj",
          "patching_rect": [
            150.0,
            410.0,
            48.0,
            22.0
          ],
          "text": "out~ 1",
          "numinlets": 1,
          "numoutlets": 0
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
            "unpack",
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
            "stop-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stop-message",
            0
          ],
          "destination": [
            "env-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            0
          ],
          "destination": [
            "freq-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            6
          ],
          "destination": [
            "freq-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freq-pack",
            0
          ],
          "destination": [
            "freq-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freq-line",
            0
          ],
          "destination": [
            "cycle",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            1
          ],
          "destination": [
            "env-pack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            2
          ],
          "destination": [
            "env-pack",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            3
          ],
          "destination": [
            "env-pack",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            4
          ],
          "destination": [
            "env-pack",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "unpack",
            5
          ],
          "destination": [
            "env-pack",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "env-pack",
            0
          ],
          "destination": [
            "env-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "env-message",
            0
          ],
          "destination": [
            "env-line",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cycle",
            0
          ],
          "destination": [
            "multiply",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "env-line",
            0
          ],
          "destination": [
            "multiply",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "multiply",
            0
          ],
          "destination": [
            "out",
            0
          ]
        }
      }
    ],
    "dependency_cache": [],
    "autosave": 0
  }
}
