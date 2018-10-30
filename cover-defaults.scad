// Units: mm.

/*
 * Sizes not related to power supply itself.
 */

// Tolerance for small objects (like holes), to make sure that everything
// will fit in.
T = 0.2;
// Tolerance for power supply sizes. It is expected to be ~1mm larger than
// on draws from the specification.
TPS = 0.8;  // This value really applied twice in most cases.

WALL_THICKNESS = 1.5;

// Add some space for cables (near terminals).
CABLING_WIDTH = 25.0;

HAS_LEGS = true;
LEG_H = 3.5;
LEG_TOP_R = 16.0 / 2.0;
LEG_BOTTOM_R = 8.0 / 2.0;
// Distance to edge.
LEG_DISTANCE = 1.0;

TOOL_HOLE_R = 3.0;

// Cable holders.
ZIP_TIE_D = 2.7;
ZIP_TIE_H = 1.2;
ZIP_TIE_HEAD_W = 4.8;
ZIP_TIE_HEAD_D = 4.8;
ZIP_TIE_HEAD_H = 4.1;
CABLE_HOLDER_W_ADD = 4.0;
CABLE_HOLDER_D_ADD = 4.0;
CABLE_HOLDER_H_ADD = 4.0;

CABLE_HOLDERS = [
        [7.5 / 2.0 /* radius */, PS_DEPTH - 25.0 /* y */],
        [7.5 / 2.0, 48.0],
];

