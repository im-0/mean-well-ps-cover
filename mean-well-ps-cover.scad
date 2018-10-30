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

/*
 * Sizes not related to power supply itself.
 */

WALL_THICKNESS = 1.5;

// Add some space for cables (near terminals).
CABLING_WIDTH = 25.0;

// Tolerance, to make sure that everything will fit in.
T = 0.2;

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
                -WALL_THICKNESS - T - CABLING_WIDTH,
                -WALL_THICKNESS - T,
                -WALL_THICKNESS - T]) {
            cube([
                    PS_WIDTH + WALL_THICKNESS + CABLING_WIDTH + T,
                    PS_DEPTH + (WALL_THICKNESS + T) * 2.0,
                    PS_HEIGHT + (WALL_THICKNESS + T) * 2.0,
            ]);
        }

        translate([
                -T + PS_TERMINAL_WIDTH,
                -T,
                -T]) {
            cube([
                    PS_WIDTH - PS_TERMINAL_WIDTH + T + O,
                    PS_DEPTH + WALL_THICKNESS + T * 2.0 + O,
                    PS_HEIGHT + WALL_THICKNESS + T * 2.0 + O]);
        }

        translate([-T - CABLING_WIDTH, -T, -T]) cube([
                PS_TERMINAL_WIDTH + CABLING_WIDTH + T + O,
                PS_DEPTH + T * 2.0,
                PS_HEIGHT + T * 2.0]);
    }
}


module mount_screw_holes() {
    // Horizontal plane.
    for (x = [PS_H_SCREW_1_X, PS_H_SCREW_2_X]) {
        translate([
                x,
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
                x,
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
                x - CABLING_WIDTH,
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
            PS_U_NOTCH_X,
            PS_H_U_NOTCH_Y,
            0.0]) {
        u_cut();
    }

    // Vertical plane.
    translate([
            PS_U_NOTCH_X,
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
            PS_H_HOLE_X,
            PS_H_HOLE_Y,
            0.0]) {
        mnt_hole_plus_tool_hole(WALL_THICKNESS + T + PS_HEIGHT);
    }

    // Vertical plane.
    translate([
            PS_V_HOLE_X,
            0.0,
            PS_V_HOLE_Z]) {
        rotate([-90.0, 0.0, 0.0]) {
            mnt_hole_plus_tool_hole(WALL_THICKNESS + T + PS_DEPTH);
        }
    }
}


module cable_holder_holes(cable_r, holder_w, holder_d, holder_h) {
    zip_tie_head_notch_w = ZIP_TIE_HEAD_D + T * 2.0;
    zip_tie_head_notch_d = ZIP_TIE_HEAD_W * 2.0 + (cable_r + T) * 2.0;
    translate([
            holder_w / 2.0 - zip_tie_head_notch_w / 2.0,
            -zip_tie_head_notch_d / 2.0,
            -WALL_THICKNESS - O]) {
        cube([
                zip_tie_head_notch_w,
                zip_tie_head_notch_d,
                ZIP_TIE_HEAD_H + T + WALL_THICKNESS + O]);
    }

    zip_tie_hole_w = ZIP_TIE_D + T * 2.0;
    zip_tie_hole_d = ZIP_TIE_H + T * 2.0;
    for (y = [cable_r + T - T * 2.0, -zip_tie_hole_d - cable_r - T]) {
        translate([
                holder_w / 2.0 - zip_tie_hole_w / 2.0,
                y,
                0.0]) {
            cube([
                    zip_tie_hole_w,
                    zip_tie_hole_d + T * 2.0,
                    holder_h + O]);
        }
    }

    d = holder_d / 2.0 - cable_r - T + O;
    for (y = [cable_r + T - T * 2.0, -d - cable_r - T]) {
        translate([
                holder_w / 2.0 + zip_tie_hole_w / 2.0 - T,
                y,
                holder_h - cable_r - T]) {
            cube([
                    holder_w / 2.0 - zip_tie_hole_w / 2.0 + O + T,
                    d + T * 2.0,
                    cable_r + T + O]);
        }
    }

    d2 = (cable_r + T) * 2.0 + zip_tie_hole_d;
    translate([
            holder_w / 2.0 - zip_tie_hole_w / 2.0,
            -d2 / 2.0,
            holder_h - cable_r * 0.8 - T]) {
        cube([
                holder_w / 2.0 + zip_tie_hole_w / 2.0 + O,
                d2,
                cable_r + T + O]);
    }

    translate([
            -WALL_THICKNESS - O,
            0.0,
            cable_r + T + ZIP_TIE_HEAD_H + T + CABLE_HOLDER_H_ADD]) {
        rotate([0.0, 90.0, 0.0]) cylinder(
                WALL_THICKNESS + O * 2.0
                    + CABLE_HOLDER_W_ADD + ZIP_TIE_HEAD_D + T * 2.0,
                cable_r + T,
                cable_r + T,
                false, $fn=64);
    }
}


module cable_holder(cable_r, negative_only=false) {
    holder_w = CABLE_HOLDER_W_ADD + ZIP_TIE_HEAD_D + T * 2.0;
    holder_d = CABLE_HOLDER_D_ADD + ZIP_TIE_HEAD_W * 2.0 + (cable_r + T) * 2.0;
    holder_h = CABLE_HOLDER_H_ADD + ZIP_TIE_HEAD_H + T + (cable_r + T);

    difference() {
        if (!negative_only) {
            translate([-OA, -holder_d / 2.0, -OA]) cube([
                    holder_w + OA,
                    holder_d,
                    holder_h + OA]);
        }

        cable_holder_holes(cable_r, holder_w, holder_d, holder_h);
    }
}


module cable_holders(negative_only=false) {
    for (holder = CABLE_HOLDERS) {
        cable_r = holder[0];
        holder_y = holder[1];

        translate([-T - CABLING_WIDTH, holder_y, -T]) {
            cable_holder(cable_r, negative_only);
        }
    }
}


module voltage_adjust_hole() {
    translate([PS_VOLT_ADJ_X, PS_VOLT_ADJ_Y, PS_HEIGHT + T - O]) cylinder(
            WALL_THICKNESS + O * 2.0,
            TOOL_HOLE_R + T,
            TOOL_HOLE_R + T,
            false, $fn=64);
}


module final_enclosure() {
    difference() {
        basic_enclosure();
        mount_screw_holes();
        u_notches();

        if (PS_HAS_ADDITIONAL_MOUNT_HOLES) {
            additional_mount_holes();
        }

        cable_holders(true);
        voltage_adjust_hole();
    }

    if (HAS_LEGS) {
        legs();
    }

    cable_holders();
}


final_enclosure();
