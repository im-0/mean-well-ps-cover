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
PS_H_SCREWS_Y = 51.5;
PS_H_SCREW_1_X = 20.5;
PS_H_SCREW_2_X = PS_H_SCREW_1_X + 55.0;

// Screws on side (vertical plane).
PS_V_SCREWS_Z = 17.5;
PS_V_SCREW_1_X = 18.0;
PS_V_SCREW_2_X = PS_V_SCREW_1_X + 74.0;

// Mounting screw hole radius.
PS_SCREW_R = 3.0 / 2.0;  // For M3.

/*
 * Sizes not related to power supply itself.
 */

WALL_THICKNESS = 1.5;

// Add some space for cables (near terminals).
CABLING_WIDTH = 15.0;

// Tolerance, to make sure that everything will fit in.
T = 0.2;

HAS_LEGS = true;
LEG_H = 3.5;
LEG_TOP_R = 16.0 / 2.0;
LEG_BOTTOM_R = 8.0 / 2.0;
// Distance to edge.
LEG_DISTANCE = 1.0;

/*
 * Other sizes.
 * Most probably you do not need to modify this.
 */

// Overlap, used only for geometry subtraction.
O = 1.0;
// Overlap, used only for geometry addition.
OA = 0.1;


module basic_enclosure() {
    difference() {
        cube([
                PS_WIDTH + WALL_THICKNESS + CABLING_WIDTH + T,
                PS_DEPTH + (WALL_THICKNESS + T) * 2.0,
                PS_HEIGHT + (WALL_THICKNESS + T) * 2.0,
        ]);

        translate([
                WALL_THICKNESS + CABLING_WIDTH + PS_TERMINAL_WIDTH,
                WALL_THICKNESS,
                WALL_THICKNESS]) {
            cube([
                PS_WIDTH - PS_TERMINAL_WIDTH + T + O,
                PS_DEPTH + WALL_THICKNESS + T * 2.0 + O,
                PS_HEIGHT + WALL_THICKNESS + T * 2.0 + O]);
        }

        translate([
                WALL_THICKNESS,
                WALL_THICKNESS,
                WALL_THICKNESS]) {
            cube([
                PS_TERMINAL_WIDTH + CABLING_WIDTH + T + O,
                PS_DEPTH + T * 2.0,
                PS_HEIGHT + T * 2.0]);
        }
    }
}


module mount_screw_holes() {
    // Horizontal plane.
    for (x = [PS_H_SCREW_1_X, PS_H_SCREW_2_X]) {
        translate([
                WALL_THICKNESS + T + CABLING_WIDTH + x,
                WALL_THICKNESS + T + PS_DEPTH - PS_H_SCREWS_Y,
                WALL_THICKNESS / 2.0]) {
            cylinder(
                    WALL_THICKNESS + O * 2.0,
                    PS_SCREW_R + T, PS_SCREW_R + T,
                    true, $fn=64);
        }
    }

    // Vertical plane.
    for (x = [PS_V_SCREW_1_X, PS_V_SCREW_2_X]) {
        translate([
                WALL_THICKNESS + T + CABLING_WIDTH + x,
                WALL_THICKNESS / 2.0,
                WALL_THICKNESS + T + PS_V_SCREWS_Z]) {
            rotate([90.0, 0.0, 0.0]) cylinder(
                    WALL_THICKNESS + O * 2.0,
                    PS_SCREW_R + T, PS_SCREW_R + T,
                    true, $fn=64);
        }
    }
}


module legs() {
    for (
            x = [
                LEG_DISTANCE + LEG_TOP_R,
                PS_WIDTH + WALL_THICKNESS + CABLING_WIDTH + T
                    - (LEG_DISTANCE + LEG_TOP_R)],
            y = [
                LEG_DISTANCE + LEG_TOP_R,
                PS_DEPTH + (WALL_THICKNESS + T) * 2.0
                    - (LEG_DISTANCE + LEG_TOP_R)]) {
        translate([
                x,
                y,
                -LEG_H]) {
            cylinder(
                    LEG_H + OA,
                    LEG_BOTTOM_R,
                    LEG_TOP_R,
                    false, $fn=64);
        }
    }
}


module final_enclosure() {
    difference() {
        basic_enclosure();
        mount_screw_holes();
    }

    if (HAS_LEGS) {
        legs();
    }
}


final_enclosure();
