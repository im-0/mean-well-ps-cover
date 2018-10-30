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

PS_WIDTH = 99.0;
PS_DEPTH = 97.0;
PS_HEIGHT = 36.0;

// Value should be slightly bigger than real width to make overlapping cover.
PS_TERMINAL_WIDTH = 20.0;

// Screws on bottom (horizontal plane).
PS_H_SCREWS = [
        [20.5 /* x */, PS_DEPTH - 51.5 /* y */],
        [20.5 + 55.0,  PS_DEPTH - 51.5],
];

// Screws on side (vertical plane).
PS_V_SCREWS = [
        [18.0 /* x */, 17.5 /* z */],
        [18.0 + 74.0,  17.5],
];

// Mounting screw hole radius.
PS_SCREW_R = 3.0 / 2.0;  // For M3.

// U-shaped notch on bottom (horizontal plane).
PS_H_U_NOTCH_Y = PS_DEPTH - 36.0;
PS_V_U_NOTCH_Z = 28.0;

PS_U_NOTCH_X = 4.5 + 89.0;
PS_U_NOTCH_R = 3.5 / 2;
PS_U_NOTCH_WIDTH = 5.5;

// Additional mounting holes.
PS_HAS_ADDITIONAL_MOUNT_HOLES = true;

PS_H_HOLE_X = 4.5;
PS_H_HOLE_Y = PS_H_U_NOTCH_Y - 55.5;

PS_V_HOLE_X = 6.5;
PS_V_HOLE_Z = PS_HEIGHT - 7.0;

PS_HOLE_R = 3.5 / 2.0;

// Voltage adjustment potentiometer.
PS_VOLT_ADJ_X = 5.5;
PS_VOLT_ADJ_Y = 22.5;

