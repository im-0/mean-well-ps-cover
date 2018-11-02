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

include <MCAD/2Dshapes.scad>
include <MCAD/regular_shapes.scad>

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

// HACK: very small value to make resulting STL valid 2-manifold.
E = 0.00001;

// For cases when width of terminals is not included in PS_WIDTH.
CABLING_PLUS_TERMINALS = CABLING_WIDTH + PS_TERMINAL_WIDTH;

ROTATE_FOR_3D_PRINTER = false;


// Hack to suppress warning from MCAD.
module test_square_pyramid() {}


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
                -WALL_THICKNESS - TPS - CABLING_PLUS_TERMINALS,
                -WALL_THICKNESS - TPS,
                -WALL_THICKNESS - TPS]) {
            cube([
                    PS_WIDTH + WALL_THICKNESS + CABLING_PLUS_TERMINALS + TPS,
                    PS_DEPTH + (WALL_THICKNESS + TPS) * 2.0,
                    PS_HEIGHT + (WALL_THICKNESS + TPS) * 2.0,
            ]);
        }

        translate([
                -TPS + PS_TERMINAL_OVERLAP,
                -TPS,
                -TPS]) {
            cube([
                    PS_WIDTH - PS_TERMINAL_OVERLAP + TPS + O,
                    PS_DEPTH + WALL_THICKNESS + TPS * 2.0 + O,
                    PS_HEIGHT + WALL_THICKNESS + TPS * 2.0 + O]);
        }

        translate([-TPS - CABLING_PLUS_TERMINALS, -TPS, -TPS]) cube([
                PS_TERMINAL_OVERLAP + CABLING_PLUS_TERMINALS + TPS + O,
                PS_DEPTH + TPS * 2.0,
                PS_HEIGHT + TPS * 2.0]);
    }
}


module mount_screw_holes() {
    cutter_h = WALL_THICKNESS + O * 2.0;

    // Horizontal plane.
    for (screw = PS_H_SCREWS) {
        x = screw[0];
        y = screw[1];
        translate([
                x,
                y,
                -cutter_h - TPS + O]) {
            #extruded_cylinder(
                    cutter_h,
                    PS_SCREW_R + T,
                    TPS * 2.0);
        }
    }

    // Vertical plane.
    for (screw = PS_V_SCREWS) {
        x = screw[0];
        z = screw[1];
        translate([
                x,
                -TPS + O,
                z]) {
            rotate([90.0, 0.0, 0.0]) #extruded_cylinder(
                    cutter_h,
                    PS_SCREW_R + T,
                    TPS * 2.0);
        }
    }
}


module legs() {
    for (leg = LEGS) {
        x = leg[0];
        y = leg[1];
        translate([
                x,
                y,
                -LEG_H - (WALL_THICKNESS + TPS)]) {
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


function diagonal(a, b) = sqrt(a * a + b * b);
ZIP_TIE_DIAG = diagonal(ZIP_TIE_HEAD_W, ZIP_TIE_HEAD_H);


module cable_holder_external_holes(cable_r, holder_w) {
    zip_tie_head_notch_w = ZIP_TIE_HEAD_D + T * 2.0;
    zip_tie_head_notch_d = ZIP_TIE_DIAG * 2.0 + (cable_r + T) * 2.0;
    zip_tie_head_notch_h = ZIP_TIE_HEAD_H + T + WALL_THICKNESS + O;
    translate([
            holder_w / 2.0 - zip_tie_head_notch_w / 2.0,
            -zip_tie_head_notch_d / 2.0,
            -WALL_THICKNESS - O]) {
        difference() {
            #cube([
                    zip_tie_head_notch_w,
                    zip_tie_head_notch_d,
                    zip_tie_head_notch_h]);

            translate([-O, zip_tie_head_notch_d / 2.0, zip_tie_head_notch_h]) {
                zip_tie_tail_cyl_r = ZIP_TIE_HEAD_H + T + WALL_THICKNESS + O / 2.0;
                zip_tie_tail_cyl_y_scale = (cable_r + T) / zip_tie_tail_cyl_r;
                scale([1.0, zip_tie_tail_cyl_y_scale, 1.0]) {
                    rotate([0.0, 90.0, 0.0]) cylinder(
                            zip_tie_head_notch_w + O * 2.0,
                            zip_tie_tail_cyl_r,
                            zip_tie_tail_cyl_r,
                            false, $fn = 64);
                }
            }
        }
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


module cable_holder_guide_hole(hole_w, hole_r) {
    rotate([0.0, 90.0, 0.0]) difference() {
        cylinder(
                hole_w,
                hole_r,
                hole_r,
                false, $fn=64);
        translate([0.0, -(hole_r + O), -O]) cube([
                hole_r + O,
                (hole_r + O) * 2.0,
                hole_w + O * 2.0]);
    }
}


module cable_holder_holes(cable_r, holder_w, holder_h) {
    zip_tie_hole_w = ZIP_TIE_D + T * 2.0;
    zip_tie_hole_d = ZIP_TIE_H + T * 2.0;

    for (y = [cable_r + T, -zip_tie_hole_d - cable_r - T]) {
        translate([
                holder_w / 2.0 - zip_tie_hole_w / 2.0 + E,
                y,
                0.0]) {
            cube([
                    zip_tie_hole_w,
                    zip_tie_hole_d,
                    holder_h + OA]);
        }
    }

    zip_tie_guide_hole_r = cable_r + T + zip_tie_hole_d;
    zip_tie_guide_hole_r_o = zip_tie_guide_hole_r - ZIP_TIE_GUIDE_OVERLAP;

    translate([
            (holder_w - zip_tie_hole_w) / 2.0,
            0.0,
            cable_r + T + ZIP_TIE_HEAD_H + T + CABLE_HOLDER_H_ADD]) {
        cable_holder_guide_hole(zip_tie_hole_w, zip_tie_guide_hole_r);

        translate([zip_tie_hole_w - OA, 0.0, 0.0]) {
            cable_holder_guide_hole(
                    (holder_w - zip_tie_hole_w) / 2.0 + O + OA,
                    zip_tie_guide_hole_r_o);
        }

        translate([0.0, -zip_tie_guide_hole_r, -cable_r / 2.0]) {
            cube([
                    (holder_w + zip_tie_hole_w) / 2.0 + O,
                    zip_tie_guide_hole_r * 2.0,
                    cable_r / 2.0 + OA]);
        }
    }
}


module cable_holder(cable_r, only_external_holes=false) {
    zip_tie_guide_r = (cable_r + T)
            + (ZIP_TIE_H + T * 2.0) + ZIP_TIE_GUIDE_THICKNESS;

    holder_w = CABLE_HOLDER_W_ADD + ZIP_TIE_HEAD_D + T * 2.0;
    holder_d_bottom = CABLE_HOLDER_D_ADD + ZIP_TIE_DIAG * 2.0 + (cable_r + T) * 2.0;
    holder_h_bottom = CABLE_HOLDER_H_ADD + ZIP_TIE_HEAD_H + T;
    holder_d_top = zip_tie_guide_r * 2.0;
    holder_h_top = CABLE_HOLDER_H_ADD + ZIP_TIE_HEAD_H + T + (cable_r + T);

    difference() {
        if (!only_external_holes) {
            translate([-OA, 0.0, -OA]) {
                translate([0.0, -holder_d_bottom / 2.0, 0.0]) cube([
                        holder_w + OA,
                        holder_d_bottom,
                        holder_h_bottom + OA]);
                translate([0.0, -holder_d_top / 2.0, 0.0]) cube([
                        holder_w + OA,
                        holder_d_top,
                        holder_h_top + OA]);

                translate([0.0, 0.0, holder_h_top]) rotate([0.0, 90.0, 0.0]) {
                    difference() {
                        cylinder(
                                holder_w + OA,
                                zip_tie_guide_r,
                                zip_tie_guide_r,
                                false, $fn=128);
                        // Cut bottom half.
                        translate([OA, -zip_tie_guide_r - O, -O]) cube([
                                zip_tie_guide_r + O - OA,
                                (zip_tie_guide_r + O) * 2.0,
                                holder_w + O * 2.0]);
                    }
                }
            }
        }

        if (!only_external_holes) {
            #cable_holder_holes(cable_r, holder_w, holder_h_top);
        }
        cable_holder_external_holes(cable_r, holder_w);
    }
}


module cable_holders(only_external_holes=false) {
    for (holder = CABLE_HOLDERS) {
        cable_r = holder[0];
        holder_y = holder[1];

        translate([-TPS - CABLING_PLUS_TERMINALS, holder_y, -TPS]) {
            cable_holder(cable_r, only_external_holes);
        }
    }
}


function is_nan(x) = (x != x);


module voltage_adjust_symbol() {
    inner_r = TOOL_HOLE_R + T + VOLT_ADJ_SYM_INDENT;
    half_a = VOLT_ADJ_SYM_ARC_A / 2.0;
    donutSlice(inner_r, inner_r + VOLT_ADJ_SYM_THICHNESS, -half_a - OA, half_a + OA, $fn=64);
    for (a = [
                [0.0,   half_a],
                [180.0, 180 - half_a]]) {
        rotate([0.0, a[0], a[1]]) {
            translate([
                    inner_r + VOLT_ADJ_SYM_THICHNESS / 2.0,
                    VOLT_ADJ_SYM_ARROW_R / 2.0,
                    0.0]) {
                triangle(VOLT_ADJ_SYM_ARROW_R);
            }
        }
    }
}

module voltage_adjust_hole() {
    trans_horiz = [
            PS_VOLT_ADJ_X,
            PS_VOLT_ADJ_Y,
            PS_HEIGHT + TPS - O];
    trans_vert = [
            -TPS - CABLING_PLUS_TERMINALS + O,
            PS_VOLT_ADJ_Y,
            PS_VOLT_ADJ_Z];
    trans = is_nan(PS_VOLT_ADJ_X)? trans_vert : trans_horiz;
    rot_horiz = [0.0, 0.0, 0.0];
    rot_vert = [0.0, -90.0, 0.0];
    rot = is_nan(PS_VOLT_ADJ_X)? rot_vert : rot_horiz;

    translate(trans) rotate(rot) {
        #cylinder(
            WALL_THICKNESS + O * 2.0,
            TOOL_HOLE_R + T,
            TOOL_HOLE_R + T,
            false, $fn=64);

        translate([0.0, 0.0, WALL_THICKNESS + O - VOLT_ADJ_SYM_D]) {
            #linear_extrude(VOLT_ADJ_SYM_D + O) voltage_adjust_symbol();
        }
    }
}


module final_enclosure() {
    difference() {
        basic_enclosure();
        mount_screw_holes();

        if (PS_HAS_U_NOTCHES) {
            u_notches();
        }

        if (PS_HAS_ADDITIONAL_MOUNT_HOLES) {
            additional_mount_holes();
        }

        cable_holders(true);
        voltage_adjust_hole();
    }

    legs();
    cable_holders();
}


module local_prepare() {
    rot = ROTATE_FOR_3D_PRINTER? [0.0, -90.0, 90.0] : [0.0, 0.0, 0.0];

    rotate(rot) {
        difference() {
            final_enclosure();
            subtract_geometry();
        }

        additional_geometry();
    }
}


local_prepare();
