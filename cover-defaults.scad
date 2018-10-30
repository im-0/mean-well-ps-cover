/*
 *  Parametric 3D printed covers for various Mean Well power supplies.
 *  Copyright (C) 2018  Ivan Mironov <mironov.ivan@gmail.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

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

WALL_THICKNESS = 3.0;

// Add some space for cables (near terminals).
CABLING_WIDTH = 30.0;

NEED_LEGS = true;
LEG_H = 3.5;
LEG_TOP_R = 16.0 / 2.0;
LEG_BOTTOM_R = 8.0 / 2.0;
// Distance to edge.
LEG_X_DISTANCE = 8.0;
LEG_Y_DISTANCE = 1.0;

TOOL_HOLE_R = 3.0;

// Cable holders.
ZIP_TIE_D = 2.7;
ZIP_TIE_H = 1.2;
ZIP_TIE_HEAD_W = 5.0;
ZIP_TIE_HEAD_D = 5.0;
ZIP_TIE_HEAD_H = 4.2;

ZIP_TIE_GUIDE_THICKNESS = 1.5;
ZIP_TIE_GUIDE_OVERLAP = 0.2;

CABLE_HOLDER_W_ADD = 2.0;
CABLE_HOLDER_D_ADD = 2.0;
CABLE_HOLDER_H_ADD = 1.0;

CABLE_HOLDERS = [
        [8.0 / 2.0 /* radius */, PS_DEPTH - 10.9 /* y */],
        [8.0 / 2.0,              PS_DEPTH - 34.2],
];

