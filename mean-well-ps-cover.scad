include <./ps/default.scad>
include <./cover-defaults.scad>
include <./local-overrides.scad>

/*
 * Other sizes.
 * Most probably you do not need to modify this.
 */

// Overlap, used only for geometry subtraction.
O = 1.0;
// Overlap, used only for geometry addition.
OA = 0.1;


module extruded_cylinder(h, r, e_y) {
    for (y_off = [-e_y / 2.0, e_y / 2.0]) {
        translate([0.0, y_off, 0.0]) {
            cylinder(h, r, r, false, $fn=64);
        }
    }
    translate([-r, -e_y / 2.0, 0.0]) cube([r * 2.0, e_y, h]);
}


module basic_enclosure() {
    difference() {
        translate([
                -WALL_THICKNESS - TPS - CABLING_WIDTH,
                -WALL_THICKNESS - TPS,
                -WALL_THICKNESS - TPS]) {
            cube([
                    PS_WIDTH + WALL_THICKNESS + CABLING_WIDTH + TPS,
                    PS_DEPTH + (WALL_THICKNESS + TPS) * 2.0,
                    PS_HEIGHT + (WALL_THICKNESS + TPS) * 2.0,
            ]);
        }

        translate([
                -TPS + PS_TERMINAL_WIDTH,
                -TPS,
                -TPS]) {
            cube([
                    PS_WIDTH - PS_TERMINAL_WIDTH + TPS + O,
                    PS_DEPTH + WALL_THICKNESS + TPS * 2.0 + O,
                    PS_HEIGHT + WALL_THICKNESS + TPS * 2.0 + O]);
        }

        translate([-TPS - CABLING_WIDTH, -TPS, -TPS]) cube([
                PS_TERMINAL_WIDTH + CABLING_WIDTH + TPS + O,
                PS_DEPTH + TPS * 2.0,
                PS_HEIGHT + TPS * 2.0]);
    }
}


module mount_screw_holes() {
    cutter_h = WALL_THICKNESS + O * 2.0;

    // Horizontal plane.
    for (x = [PS_H_SCREW_1_X, PS_H_SCREW_2_X]) {
        translate([
                x,
                PS_H_SCREWS_Y,
                -cutter_h - TPS + O]) {
            #extruded_cylinder(
                    cutter_h,
                    PS_SCREW_R + T,
                    TPS * 2.0);
        }
    }

    // Vertical plane.
    for (x = [PS_V_SCREW_1_X, PS_V_SCREW_2_X]) {
        translate([
                x,
                -TPS + O,
                PS_V_SCREWS_Z]) {
            rotate([90.0, 0.0, 0.0]) #extruded_cylinder(
                    cutter_h,
                    PS_SCREW_R + T,
                    TPS * 2.0);
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
    translate([0.0, 0.0, -O - WALL_THICKNESS - TPS]) {
        #cylinder(
                WALL_THICKNESS + O * 2.0,
                PS_U_NOTCH_R + TPS,
                PS_U_NOTCH_R + TPS,
                false, $fn=64);
        translate([0.0, -(PS_U_NOTCH_R + TPS), 0.0]) #cube([
                PS_U_NOTCH_WIDTH + O,
                (PS_U_NOTCH_R + TPS) * 2.0,
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
    translate([0.0, 0.0, -O - WALL_THICKNESS - TPS]) #extruded_cylinder(
            WALL_THICKNESS + O * 2.0,
            PS_HOLE_R + T,
            TPS * 2.0);

    // Screwdriver hole.
    translate([0.0, 0.0, distance - O + TPS]) #cylinder(
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
        mnt_hole_plus_tool_hole(PS_HEIGHT);
    }

    // Vertical plane.
    translate([
            PS_V_HOLE_X,
            0.0,
            PS_V_HOLE_Z]) {
        rotate([-90.0, 0.0, 0.0]) {
            mnt_hole_plus_tool_hole(PS_DEPTH);
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
        #cube([
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
            #cube([
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
            #cube([
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
        #cube([
                holder_w / 2.0 + zip_tie_hole_w / 2.0 + O,
                d2,
                cable_r + T + O]);
    }

    translate([
            -WALL_THICKNESS - O,
            0.0,
            cable_r + T + ZIP_TIE_HEAD_H + T + CABLE_HOLDER_H_ADD]) {
        rotate([0.0, 90.0, 0.0]) #cylinder(
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

        translate([-TPS - CABLING_WIDTH, holder_y, -TPS]) {
            cable_holder(cable_r, negative_only);
        }
    }
}


module voltage_adjust_hole() {
    translate([PS_VOLT_ADJ_X, PS_VOLT_ADJ_Y, PS_HEIGHT + TPS - O]) #cylinder(
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
