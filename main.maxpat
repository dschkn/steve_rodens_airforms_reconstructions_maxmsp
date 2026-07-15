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
      40.0,
      55.0,
      1380.0,
      900.0
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
    "description": "",
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
            920.0,
            30.0
          ],
          "text": "AIRFORMS — compact behavioural reconstruction",
          "fontsize": 20.0,
          "fontface": 1,
          "textcolor": [
            0.18,
            0.23,
            0.28,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "subtitle",
          "maxclass": "comment",
          "patching_rect": [
            27.0,
            52.0,
            1130.0,
            42.0
          ],
          "text": "24 partials per bank, stochastic spectral crystallisation, complex pulsing noise and A × B intermodulation.",
          "fontsize": 12.0,
          "textcolor": [
            0.32,
            0.38,
            0.42,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "start-toggle",
          "maxclass": "toggle",
          "patching_rect": [
            30.0,
            105.0,
            28.0,
            28.0
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "int"
          ],
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "start-label",
          "maxclass": "comment",
          "patching_rect": [
            67.0,
            109.0,
            105.0,
            20.0
          ],
          "text": "START / DSP",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "start-select",
          "maxclass": "newobj",
          "patching_rect": [
            30.0,
            145.0,
            58.0,
            22.0
          ],
          "text": "sel 1 0",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "dsp-switch",
          "maxclass": "newobj",
          "patching_rect": [
            100.0,
            145.0,
            92.0,
            22.0
          ],
          "text": "adstatus switch",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "start-message",
          "maxclass": "message",
          "patching_rect": [
            30.0,
            182.0,
            40.0,
            22.0
          ],
          "text": "start",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "stop-message",
          "maxclass": "message",
          "patching_rect": [
            82.0,
            182.0,
            38.0,
            22.0
          ],
          "text": "stop",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "tempo-label",
          "maxclass": "comment",
          "patching_rect": [
            185.0,
            87.0,
            110.0,
            20.0
          ],
          "text": "tempo (0.2–4.0)"
        }
      },
      {
        "box": {
          "id": "tempo",
          "maxclass": "flonum",
          "patching_rect": [
            185.0,
            108.0,
            70.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "minimum": 0.2,
          "maximum": 4.0
        }
      },
      {
        "box": {
          "id": "tempo-prepend",
          "maxclass": "newobj",
          "patching_rect": [
            185.0,
            145.0,
            90.0,
            22.0
          ],
          "text": "prepend tempo",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "tempo-load",
          "maxclass": "newobj",
          "patching_rect": [
            185.0,
            182.0,
            76.0,
            22.0
          ],
          "text": "loadmess 1.",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "density-label",
          "maxclass": "comment",
          "patching_rect": [
            315.0,
            87.0,
            105.0,
            20.0
          ],
          "text": "density (0–1)"
        }
      },
      {
        "box": {
          "id": "density",
          "maxclass": "flonum",
          "patching_rect": [
            315.0,
            108.0,
            70.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "minimum": 0.0,
          "maximum": 1.0
        }
      },
      {
        "box": {
          "id": "density-prepend",
          "maxclass": "newobj",
          "patching_rect": [
            315.0,
            145.0,
            100.0,
            22.0
          ],
          "text": "prepend density",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "density-load",
          "maxclass": "newobj",
          "patching_rect": [
            315.0,
            182.0,
            91.0,
            22.0
          ],
          "text": "loadmess 0.82",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "seed-label",
          "maxclass": "comment",
          "patching_rect": [
            450.0,
            87.0,
            80.0,
            20.0
          ],
          "text": "random seed"
        }
      },
      {
        "box": {
          "id": "seed",
          "maxclass": "number",
          "patching_rect": [
            450.0,
            108.0,
            78.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": 1
        }
      },
      {
        "box": {
          "id": "seed-prepend",
          "maxclass": "newobj",
          "patching_rect": [
            450.0,
            145.0,
            84.0,
            22.0
          ],
          "text": "prepend seed",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "seed-load",
          "maxclass": "newobj",
          "patching_rect": [
            450.0,
            182.0,
            111.0,
            22.0
          ],
          "text": "loadmess 22004",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "reset-button",
          "maxclass": "button",
          "patching_rect": [
            585.0,
            108.0,
            24.0,
            24.0
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "reset-label",
          "maxclass": "comment",
          "patching_rect": [
            617.0,
            110.0,
            195.0,
            20.0
          ],
          "text": "reset sequence to current seed"
        }
      },
      {
        "box": {
          "id": "reset-message",
          "maxclass": "message",
          "patching_rect": [
            585.0,
            145.0,
            38.0,
            22.0
          ],
          "text": "reset",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "reset-load",
          "maxclass": "newobj",
          "patching_rect": [
            585.0,
            182.0,
            91.0,
            22.0
          ],
          "text": "loadmess reset",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "engine",
          "maxclass": "newobj",
          "patching_rect": [
            300.0,
            225.0,
            145.0,
            22.0
          ],
          "text": "js airforms_engine.js",
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
          "id": "engine-label",
          "maxclass": "comment",
          "patching_rect": [
            300.0,
            251.0,
            290.0,
            20.0
          ],
          "text": "JS schedules delayed partials and four noise families; MSP generates all audio."
        }
      },
      {
        "box": {
          "id": "status-prepend",
          "maxclass": "newobj",
          "patching_rect": [
            570.0,
            225.0,
            75.0,
            22.0
          ],
          "text": "prepend set",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "status",
          "maxclass": "message",
          "patching_rect": [
            660.0,
            225.0,
            500.0,
            22.0
          ],
          "text": "ready",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "a-label",
          "maxclass": "comment",
          "patching_rect": [
            55.0,
            295.0,
            245.0,
            20.0
          ],
          "text": "A — 24 partials / new SDIF + sums",
          "fontface": 1,
          "textcolor": [
            0.93,
            0.56,
            0.25,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "poly-a",
          "maxclass": "newobj",
          "patching_rect": [
            55.0,
            325.0,
            225.0,
            22.0
          ],
          "text": "poly~ airforms_partial 24 @parallel 1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "b-label",
          "maxclass": "comment",
          "patching_rect": [
            325.0,
            295.0,
            245.0,
            20.0
          ],
          "text": "B — 24 partials / new SDIF + sums",
          "fontface": 1,
          "textcolor": [
            0.46,
            0.4,
            0.78,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "poly-b",
          "maxclass": "newobj",
          "patching_rect": [
            325.0,
            325.0,
            225.0,
            22.0
          ],
          "text": "poly~ airforms_partial 24 @parallel 1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "c-label",
          "maxclass": "comment",
          "patching_rect": [
            595.0,
            295.0,
            245.0,
            20.0
          ],
          "text": "C-residue — sparse side-band crystals",
          "fontface": 1,
          "textcolor": [
            0.24,
            0.62,
            0.62,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "poly-c",
          "maxclass": "newobj",
          "patching_rect": [
            595.0,
            325.0,
            225.0,
            22.0
          ],
          "text": "poly~ airforms_partial 24 @parallel 1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "a-left",
          "maxclass": "newobj",
          "patching_rect": [
            55.0,
            375.0,
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
          "id": "a-right",
          "maxclass": "newobj",
          "patching_rect": [
            150.0,
            410.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.36",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "b-left",
          "maxclass": "newobj",
          "patching_rect": [
            325.0,
            375.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.34",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "b-right",
          "maxclass": "newobj",
          "patching_rect": [
            420.0,
            410.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.64",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "c-left",
          "maxclass": "newobj",
          "patching_rect": [
            595.0,
            375.0,
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
          "id": "c-right",
          "maxclass": "newobj",
          "patching_rect": [
            690.0,
            410.0,
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
          "id": "master-label",
          "maxclass": "comment",
          "patching_rect": [
            810.0,
            685.0,
            130.0,
            20.0
          ],
          "text": "MASTER (start at −3 dB)",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "master",
          "maxclass": "live.gain~",
          "patching_rect": [
            830.0,
            715.0,
            52.0,
            125.0
          ],
          "numinlets": 2,
          "numoutlets": 5,
          "outlettype": [
            "signal",
            "signal",
            "",
            "float",
            "list"
          ],
          "parameter_enable": 1,
          "varname": "master_gain",
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                -3.0
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "Master",
              "parameter_mmax": 6.0,
              "parameter_mmin": -70.0,
              "parameter_shortname": "Master",
              "parameter_type": 0,
              "parameter_unitstyle": 4
            }
          }
        }
      },
      {
        "box": {
          "id": "dac",
          "maxclass": "newobj",
          "patching_rect": [
            930.0,
            780.0,
            54.0,
            32.0
          ],
          "text": "ezdac~",
          "numinlets": 2,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "dac-label",
          "maxclass": "comment",
          "patching_rect": [
            915.0,
            817.0,
            110.0,
            20.0
          ],
          "text": "connected stereo out"
        }
      },
      {
        "box": {
          "id": "spectrum-label",
          "maxclass": "comment",
          "patching_rect": [
            40.0,
            490.0,
            370.0,
            20.0
          ],
          "text": "OUTPUT SPECTRUM — low bands should dominate",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "spectrum",
          "maxclass": "spectroscope~",
          "patching_rect": [
            40.0,
            515.0,
            720.0,
            310.0
          ],
          "numinlets": 2,
          "numoutlets": 0,
          "domain": [
            20.0,
            18000.0
          ],
          "range": [
            -100.0,
            0.0
          ],
          "logfreq": 1,
          "logamp": 1,
          "sonogram": 0
        }
      },
      {
        "box": {
          "id": "noise-label",
          "maxclass": "comment",
          "patching_rect": [
            895.0,
            295.0,
            340.0,
            20.0
          ],
          "text": "COMPLEX PULSING NOISE",
          "fontface": 1,
          "textcolor": [
            0.35,
            0.42,
            0.46,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "noise-engine",
          "maxclass": "newobj",
          "patching_rect": [
            895.0,
            325.0,
            110.0,
            22.0
          ],
          "text": "airforms_noise",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "noise-explain",
          "maxclass": "comment",
          "patching_rect": [
            895.0,
            353.0,
            400.0,
            42.0
          ],
          "text": "breath + 5.5/8/12.2/19 Hz rumble + scanning radio + resonant fragments"
        }
      },
      {
        "box": {
          "id": "intermod-label",
          "maxclass": "comment",
          "patching_rect": [
            895.0,
            420.0,
            360.0,
            20.0
          ],
          "text": "A × B INTERMODULATION (sum / difference field)",
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "intermod-ring",
          "maxclass": "newobj",
          "patching_rect": [
            895.0,
            450.0,
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
          "id": "intermod-boost",
          "maxclass": "newobj",
          "patching_rect": [
            945.0,
            450.0,
            58.0,
            22.0
          ],
          "text": "*~ 18.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "intermod-hip",
          "maxclass": "newobj",
          "patching_rect": [
            1015.0,
            450.0,
            58.0,
            22.0
          ],
          "text": "hip~ 25.",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "intermod-low",
          "maxclass": "newobj",
          "patching_rect": [
            1085.0,
            450.0,
            105.0,
            22.0
          ],
          "text": "lores~ 3500. 0.2",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "intermod-left",
          "maxclass": "newobj",
          "patching_rect": [
            1045.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.24",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "intermod-right",
          "maxclass": "newobj",
          "patching_rect": [
            1115.0,
            495.0,
            58.0,
            22.0
          ],
          "text": "*~ 0.31",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "start-toggle",
            0
          ],
          "destination": [
            "start-select",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-toggle",
            0
          ],
          "destination": [
            "dsp-switch",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-select",
            0
          ],
          "destination": [
            "start-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-select",
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
            "start-message",
            0
          ],
          "destination": [
            "engine",
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
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tempo",
            0
          ],
          "destination": [
            "tempo-prepend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tempo-prepend",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tempo-load",
            0
          ],
          "destination": [
            "tempo",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density",
            0
          ],
          "destination": [
            "density-prepend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density-prepend",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density-load",
            0
          ],
          "destination": [
            "density",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seed",
            0
          ],
          "destination": [
            "seed-prepend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seed-prepend",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seed-load",
            0
          ],
          "destination": [
            "seed",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset-button",
            0
          ],
          "destination": [
            "reset-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset-message",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset-load",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            0
          ],
          "destination": [
            "poly-a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            1
          ],
          "destination": [
            "poly-b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            2
          ],
          "destination": [
            "poly-c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            4
          ],
          "destination": [
            "status-prepend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-prepend",
            0
          ],
          "destination": [
            "status",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-a",
            0
          ],
          "destination": [
            "a-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-a",
            0
          ],
          "destination": [
            "a-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-b",
            0
          ],
          "destination": [
            "b-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-b",
            0
          ],
          "destination": [
            "b-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-c",
            0
          ],
          "destination": [
            "c-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-c",
            0
          ],
          "destination": [
            "c-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "a-left",
            0
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "b-left",
            0
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "c-left",
            0
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "a-right",
            0
          ],
          "destination": [
            "master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "b-right",
            0
          ],
          "destination": [
            "master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "c-right",
            0
          ],
          "destination": [
            "master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            0
          ],
          "destination": [
            "dac",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            1
          ],
          "destination": [
            "dac",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            0
          ],
          "destination": [
            "spectrum",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            3
          ],
          "destination": [
            "noise-engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noise-engine",
            0
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noise-engine",
            1
          ],
          "destination": [
            "master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-a",
            0
          ],
          "destination": [
            "intermod-ring",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "poly-b",
            0
          ],
          "destination": [
            "intermod-ring",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-ring",
            0
          ],
          "destination": [
            "intermod-boost",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-boost",
            0
          ],
          "destination": [
            "intermod-hip",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-hip",
            0
          ],
          "destination": [
            "intermod-low",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-low",
            0
          ],
          "destination": [
            "intermod-left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-low",
            0
          ],
          "destination": [
            "intermod-right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-left",
            0
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "intermod-right",
            0
          ],
          "destination": [
            "master",
            1
          ]
        }
      }
    ],
    "dependency_cache": [
      {
        "name": "airforms_engine.js",
        "bootpath": "",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "airforms_partial.maxpat",
        "bootpath": "",
        "patcherrelativepath": ".",
        "type": "JSON",
        "implicit": 1
      },
      {
        "name": "airforms_noise.maxpat",
        "bootpath": "",
        "patcherrelativepath": ".",
        "type": "JSON",
        "implicit": 1
      }
    ],
    "autosave": 0,
    "parameters": {
      "master": [
        "Master",
        "Master",
        0
      ]
    },
    "parameterbanks": {
      "0": {
        "index": 0,
        "name": "",
        "parameters": [
          "-",
          "-",
          "-",
          "-",
          "-",
          "-",
          "-",
          "-"
        ]
      }
    }
  }
}
