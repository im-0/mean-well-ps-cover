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
PS_H_SCREWS_Y = PS_DEPTH - 51.5;
PS_H_SCREW_1_X = 20.5;
PS_H_SCREW_2_X = PS_H_SCREW_1_X + 55.0;

// Screws on side (vertical plane).
PS_V_SCREWS_Z = 17.5;
PS_V_SCREW_1_X = 18.0;
PS_V_SCREW_2_X = PS_V_SCREW_1_X + 74.0;

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

