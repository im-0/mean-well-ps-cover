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
 * Sizes of power supply.
 */

PS_WIDTH = 78.0;
PS_DEPTH = 51.0;
PS_HEIGHT = 28.0;

// Width of overlap for terminals. Value should be slightly bigger than
// real terminal width.
PS_TERMINAL_OVERLAP = 6.0;
// Set to non-zero value if terminal width is not included in PS_WIDTH.
PS_TERMINAL_WIDTH = 14.0;

// Screws on bottom (horizontal plane).
PS_H_SCREWS = [
        [PS_WIDTH - 55.0 - 10.5 /* x */, 25.4 /* y */],
        [PS_WIDTH - 10.5,                25.4],
];

// Screws on side (vertical plane).
PS_V_SCREWS = [
        [PS_WIDTH - 66.5 - 2.75 /* x */, 14.0 /* z */],
        [PS_WIDTH - 2.75,                14.0],
];

// Mounting screw hole radius.
PS_SCREW_R = 3.0 / 2.0;  // For M3.

// U-shaped notches.
PS_HAS_U_NOTCHES = false;

// Additional mounting holes.
PS_HAS_ADDITIONAL_MOUNT_HOLES = false;

// Voltage adjustment potentiometer.
PS_VOLT_ADJ_X = 0 / 0;
PS_VOLT_ADJ_Y = 6.0;
PS_VOLT_ADJ_Z = 11.0;

