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

TOOL_HOLE_R = 3.0;

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
        translate([
                -WALL_THICKNESS - T,
                -WALL_THICKNESS - T,
                -WALL_THICKNESS - T]) {
            cube([
                    PS_WIDTH + WALL_THICKNESS + CABLING_WIDTH + T,
                    PS_DEPTH + (WALL_THICKNESS + T) * 2.0,
                    PS_HEIGHT + (WALL_THICKNESS + T) * 2.0,
            ]);
        }

        translate([
                -T + CABLING_WIDTH + PS_TERMINAL_WIDTH,
                -T,
                -T]) {
            cube([
                    PS_WIDTH - PS_TERMINAL_WIDTH + T + O,
                    PS_DEPTH + WALL_THICKNESS + T * 2.0 + O,
                    PS_HEIGHT + WALL_THICKNESS + T * 2.0 + O]);
        }

        translate([-T, -T, -T]) cube([
                PS_TERMINAL_WIDTH + CABLING_WIDTH + T + O,
                PS_DEPTH + T * 2.0,
                PS_HEIGHT + T * 2.0]);
    }
}


module mount_screw_holes() {
    // Horizontal plane.
    for (x = [PS_H_SCREW_1_X, PS_H_SCREW_2_X]) {
        translate([
                CABLING_WIDTH + x,
                PS_H_SCREWS_Y,
                -O]) {
            cylinder(
                    WALL_THICKNESS + O * 2.0,
                    PS_SCREW_R + T, PS_SCREW_R + T,
                    true, $fn=64);
        }
    }

    // Vertical plane.
    for (x = [PS_V_SCREW_1_X, PS_V_SCREW_2_X]) {
        translate([
                CABLING_WIDTH + x,
                -O,
                PS_V_SCREWS_Z]) {
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
                LEG_DISTANCE + LEG_TOP_R - (WALL_THICKNESS + T),
                PS_WIDTH + CABLING_WIDTH - (LEG_DISTANCE + LEG_TOP_R)],
            y = [
                LEG_DISTANCE + LEG_TOP_R - (WALL_THICKNESS + T),
                PS_DEPTH + WALL_THICKNESS + T
                    - (LEG_DISTANCE + LEG_TOP_R)]) {
        translate([
                x,
                y,
                -LEG_H - (WALL_THICKNESS + T)]) {
            cylinder(
                    LEG_H + OA,
                    LEG_BOTTOM_R,
                    LEG_TOP_R,
                    false, $fn=64);
        }
    }
}


module u_cut() {
    translate([0.0, 0.0, -O - WALL_THICKNESS - T]) {
        cylinder(
                WALL_THICKNESS + O * 2.0,
                PS_U_NOTCH_R + T,
                PS_U_NOTCH_R + T,
                false, $fn=64);
        translate([0.0, -(PS_U_NOTCH_R + T), 0.0]) cube([
                PS_U_NOTCH_WIDTH + O,
                (PS_U_NOTCH_R + T) * 2.0,
                WALL_THICKNESS + O * 2.0]);
    }
}


module u_notches() {
    // Horizontal plane.
    translate([
            CABLING_WIDTH + PS_U_NOTCH_X,
            PS_H_U_NOTCH_Y,
            0.0]) {
        u_cut();
    }

    // Vertical plane.
    translate([
            CABLING_WIDTH + PS_U_NOTCH_X,
            0.0,
            PS_V_U_NOTCH_Z]) {
        rotate([-90.0, 0.0, 0.0]) u_cut();
    }
}


module mnt_hole_plus_tool_hole(distance) {
    // Screw hole.
    translate([0.0, 0.0, -O - WALL_THICKNESS - T]) cylinder(
            WALL_THICKNESS + O * 2.0,
            PS_HOLE_R + T,
            PS_HOLE_R + T,
            false, $fn=64);

    // Screwdriver hole.
    translate([0.0, 0.0, distance - O - WALL_THICKNESS]) cylinder(
            WALL_THICKNESS + O * 2.0,
            TOOL_HOLE_R + T,
            TOOL_HOLE_R + T,
            false, $fn=64);
}


module additional_mount_holes() {
    // Horizontal plane.
    translate([
            CABLING_WIDTH + PS_H_HOLE_X,
            PS_H_HOLE_Y,
            0.0]) {
        mnt_hole_plus_tool_hole(WALL_THICKNESS + T + PS_HEIGHT);
    }

    // Vertical plane.
    translate([
            CABLING_WIDTH + PS_V_HOLE_X,
            0.0,
            PS_V_HOLE_Z]) {
        rotate([-90.0, 0.0, 0.0]) {
            mnt_hole_plus_tool_hole(WALL_THICKNESS + T + PS_DEPTH);
        }
    }
}


module final_enclosure() {
    difference() {
        basic_enclosure();
        mount_screw_holes();
        u_notches();

        if (PS_HAS_ADDITIONAL_MOUNT_HOLES) {
            additional_mount_holes();
        }
    }

    if (HAS_LEGS) {
        legs();
    }
}


final_enclosure();
