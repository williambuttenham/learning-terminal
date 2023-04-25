// OpenSCAD version 2021.01 

$fn = 70;
nozzle_diameter = 0.4;
screen_viewport_width = 154.25;
screen_viewport_height = 86.5;
screen_width = 165;
screen_height = 102;
screen_screw_height = 3.7;
screen_body_height = 9.05;
border_width = 8.5;
screen_button_border = 15;
mx_width = 14;
mx_columns = 8;
key_width = 19.05;
cherry_plate_thickness = 1.5;
mx_rows = 1;
case_lid_lip = 8;
lip_overlap = 5;
screw_mount_width = 8;
midplate_tab_width = 10;
heatset_insert_diameter = 3.7;
heatset_insert_height = 5.7;
heatset_bolt_diameter = 3;
exploded = true;
handle_diameter = 10;

magic_midplate_screw_height = 12.3;

print_clearance = nozzle_diameter/2;
screen_face_width = screen_viewport_width+print_clearance;
screen_face_height = screen_viewport_height+print_clearance;
key_spacing = key_width-mx_width;
mx_module_width = (mx_width+key_spacing)*mx_columns;
tablet_width = screen_face_width + border_width*2;
tablet_height = screen_face_height + border_width*2 + ((mx_width+key_spacing)*mx_rows) + screen_button_border;
wall_thickness = nozzle_diameter*5;
midplate_mount_height = wall_thickness/2+screen_screw_height+screen_body_height;
case_depth = wall_thickness+25+screen_body_height+wall_thickness;
midplate_tab_height = wall_thickness;
midplate_tab_depth = wall_thickness/2;
body_corner_radius = wall_thickness;
face_screen_height_offset = border_width+((mx_width+key_spacing)*mx_rows)+screen_button_border;
midplate_height = screen_face_height + border_width*2 + screw_mount_width +wall_thickness;
midplate_screw_height = face_screen_height_offset-magic_midplate_screw_height-screw_mount_width;

module face(args) {
    mx_center_offset = (tablet_width-wall_thickness-wall_thickness)/2-(mx_module_width)/2;
    difference() {
        cube(size=[tablet_width-wall_thickness-wall_thickness, tablet_height-wall_thickness-wall_thickness, wall_thickness]);
        // Screen viewport
        translate([7, face_screen_height_offset-wall_thickness, -wall_thickness])
            cube(size=[screen_face_width, screen_face_height, wall_thickness*2]);
        // Hole for mx grid
        translate([mx_center_offset, border_width-wall_thickness, -wall_thickness])
            cube(size=[mx_module_width, (mx_width+key_spacing)*mx_rows, wall_thickness*2]);

    }
    translate([mx_center_offset, border_width-wall_thickness, 0])
        mx_grid(mx_columns, mx_rows);
}

module mx_grid(x, y) {
    difference() {
        cube(size=[(mx_width+key_spacing)*x, (mx_width+key_spacing)*y, cherry_plate_thickness]);

        for (i=[0:x-1]) {
            for (j=[0:y-1]) {
                translate([key_spacing/2+(mx_width+key_spacing)*i, key_spacing/2-(mx_width+key_spacing)*j, -cherry_plate_thickness])
                    cube(size=[ mx_width, mx_width, cherry_plate_thickness*2]);
            }
        }
    }
}

module simpleHandle(args) {
    difference() {
        union(){
            translate([body_corner_radius, tablet_height-body_corner_radius, case_depth/2-(handle_diameter+wall_thickness+wall_thickness)/2])
                cube(size=[ handle_diameter, handle_diameter*2+wall_thickness+wall_thickness+body_corner_radius, handle_diameter+wall_thickness+wall_thickness]);
            translate([tablet_width-handle_diameter-body_corner_radius, tablet_height-body_corner_radius, case_depth/2-(handle_diameter+wall_thickness+wall_thickness)/2])
                cube(size=[ handle_diameter, handle_diameter*2+wall_thickness+wall_thickness+body_corner_radius, handle_diameter+wall_thickness+wall_thickness]);
        }
        translate([0, tablet_height+handle_diameter*1.5+wall_thickness, case_depth/2])
            rotate([0, 90, 0])
                cylinder(d=handle_diameter, h=tablet_width);
    }
}

module screw_mount (screw_mount_height=midplate_mount_height) {
    difference() {
        cube(size=[screw_mount_width, screw_mount_width, screw_mount_height]);
        translate([screw_mount_width/2, screw_mount_width/2, screw_mount_height-heatset_insert_height])
            cylinder(d=heatset_insert_diameter, h=heatset_insert_height);
    }
}

module body(handle=true, display_sides=true) {
    lid_lip_angle = 32;
    difference() {
        union() {
            translate([wall_thickness, wall_thickness, 0])
                face();
            // Midplate screw mounts
            translate([wall_thickness, midplate_screw_height, 0]){
                screw_mount();
                translate([tablet_width-screw_mount_width-wall_thickness*2, 0, 0])
                    screw_mount();
            }
            // lid side rails
            difference() {
                translate([wall_thickness, wall_thickness+screw_mount_width, case_depth-wall_thickness*2])
                    cube(size=[wall_thickness, tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, wall_thickness]);
                translate([wall_thickness, wall_thickness+screw_mount_width, case_depth-wall_thickness*2])
                    rotate([0, lid_lip_angle, 0])
                        cube(size=[wall_thickness, tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, wall_thickness*2]);
            }
            translate([tablet_width-wall_thickness, wall_thickness+screw_mount_width+tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, case_depth-wall_thickness*2]){
                difference() {
                    rotate([0, 0, 180])
                        cube(size=[wall_thickness, tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, wall_thickness]);
                    rotate([0, lid_lip_angle, 180])
                        cube(size=[wall_thickness, tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, wall_thickness*2]);
            }}
            // bottom rail
            translate([(tablet_width-wall_thickness*2-screw_mount_width*2)+(wall_thickness+screw_mount_width), wall_thickness, case_depth-wall_thickness*2]){
                difference() {
                    rotate([0, 0, 90])
                        cube(size=[wall_thickness, tablet_width-wall_thickness*2-screw_mount_width*2, wall_thickness]);
                    rotate([0, lid_lip_angle, 90])
                        cube(size=[wall_thickness, tablet_width-wall_thickness*2-screw_mount_width*2, wall_thickness*2]);
            }}
            // top rail
            translate([wall_thickness*4, tablet_height-wall_thickness, case_depth-wall_thickness*3-print_clearance]){
                difference() {
                    rotate([0, 0, -90])
                        cube(size=[wall_thickness, tablet_width-wall_thickness*8, wall_thickness]);
                    rotate([0, lid_lip_angle, -90])
                        cube(size=[wall_thickness, tablet_width-wall_thickness*8, wall_thickness*2]);
            }}
            // translate([tablet_width-wall_thickness*2, wall_thickness+screw_mount_width, case_depth-wall_thickness*2])
            //     cube(size=[wall_thickness, tablet_height-wall_thickness*2-lip_overlap*2-screw_mount_width, wall_thickness]);
            // Case sides
            if(display_sides == true) {
                difference() {
                    roundedcube(size=[tablet_width, tablet_height, case_depth], radius=body_corner_radius);
                    translate([wall_thickness, wall_thickness, 0])
                        cube(size=[tablet_width-wall_thickness*2, tablet_height-wall_thickness*2, case_depth-wall_thickness]);
                    // Case lid lip
                    translate([wall_thickness, wall_thickness, 0])
                        cube(size=[tablet_width-wall_thickness*2, tablet_height-wall_thickness*2-lip_overlap, case_depth+1]);
                    translate([wall_thickness, wall_thickness, case_depth-wall_thickness])
                        cube(size=[tablet_width-wall_thickness*2, tablet_height-wall_thickness*2-lip_overlap, wall_thickness+1]);
                    // Midplate tab holes
                    translate([wall_thickness, tablet_height-midplate_tab_depth-wall_thickness/2, midplate_mount_height])
                        cube(size=[midplate_tab_width+print_clearance, midplate_tab_depth+print_clearance, midplate_tab_height+print_clearance]);
                    translate([tablet_width-wall_thickness-10-print_clearance, tablet_height-midplate_tab_depth-wall_thickness/2, midplate_mount_height])
                        cube(size=[midplate_tab_width+print_clearance, midplate_tab_depth+print_clearance, midplate_tab_height+print_clearance]);
                }
            }
        }
        // Set screen into face
        translate([wall_thickness-print_clearance, face_screen_height_offset-11, wall_thickness/2])
            cube(size=[screen_width+print_clearance*2, screen_height+print_clearance*2, screen_body_height]);
    }
    // Lid screw mounts
    translate([wall_thickness, wall_thickness, 0]){
        screw_mount(case_depth-wall_thickness);
        translate([tablet_width-screw_mount_width-wall_thickness*2, 0, 0])
            screw_mount(case_depth-wall_thickness);
    }
    if (handle) {
        simpleHandle();
    }
}

module lid(args) {
    lid_width = tablet_width-wall_thickness*2-print_clearance;
    lid_height = tablet_height-wall_thickness-case_lid_lip-print_clearance+1;
    linear_extrude(height=wall_thickness)
        difference() {  
            // Main plate body   
            translate([print_clearance/2, print_clearance/2, 0])       
                square(size=[lid_width, lid_height]);
            // Screw mount holes
            translate([screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=heatset_bolt_diameter);
            translate([lid_width+print_clearance-screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=heatset_bolt_diameter);
            // Cheeseplate mount holes
            translate([10+lid_width/2-(20.75+6.35)/2, 33.75, 0]){
                circle(d=6.35);
                translate([20.75+6.35, 0, 0])
                    circle(d=6.35);
            }
            // V mount holes
            // translate([lid_width/2+(20.75+6.35)+10, lid_height/2-(45.35/2), 0]){
            translate([19, 36, 0]){
                circle(d=4);
                translate([25.7+4, 0, 0])
                    circle(d=4);
                translate([25.7+4, 45.35+4, 0])
                    circle(d=4);
                translate([0, 45.35+4, 0])
                    circle(d=4);
            }
        }
    // Lid lip
    translate([wall_thickness, tablet_height-wall_thickness-2-case_lid_lip-lip_overlap-print_clearance, -wall_thickness])
        cube(size=[tablet_width-wall_thickness*4, case_lid_lip+lip_overlap, wall_thickness]);

}

module midplate(args) {
    linear_extrude(height=wall_thickness)
        difference() {            
            // Main plate body
            square(size=[tablet_width-wall_thickness*2-print_clearance, midplate_height-print_clearance]);
            // Screw mount holes
            translate([screw_mount_width/2-print_clearance/2, screw_mount_width/2, 0])
                circle(d=heatset_bolt_diameter);
            translate([tablet_width-wall_thickness*2-screw_mount_width/2-print_clearance, screw_mount_width/2, 0])
                circle(d=heatset_bolt_diameter);
            translate([5,magic_midplate_screw_height+3, 0])
                screen_holes(2.5);
        }
    // Lid lip
    translate([0, midplate_height-lip_overlap, 0])
        cube(size=[midplate_tab_width, midplate_tab_depth+lip_overlap, midplate_tab_height]);
    translate([tablet_width-wall_thickness*2-print_clearance-midplate_tab_width, midplate_height-lip_overlap, 0])
        cube(size=[midplate_tab_width, midplate_tab_depth+lip_overlap, midplate_tab_height]);

}

module screen_holes(screw_size=3) {
    translate([0, 0, 0])
        circle(d=screw_size);
    translate([0, 92, 0])
        circle(d=screw_size);
    translate([149.2+5.5, 92, 0])
        circle(d=screw_size);
    translate([149.2+5.5, 0, 0])
        circle(d=screw_size);
    // raspberry pi hole
    translate([27, 8, 0])
        square(size=[92, 62]);
    // ribbon cable hole
    translate([112.5, 8])
        square(size=[25, 40]);
}

module screen(opacity = 1){
    // screen screw mounts
    translate([2.37+5.5/2, 2.31+5.5/2, screen_body_height])
        linear_extrude(height=screen_screw_height)
            screen_holes(5.5);
    // ribbon cable
    translate([122-4.5, 33.5, screen_body_height])
        cube(size=[25, 17, 25]);
    // screen body
    color("green", opacity)
        difference() {
            cube(size=[screen_width, screen_height, screen_body_height]);
            // screen viewing area
            translate([7, 11, 0])
                cube(size=[154.25, 86.5, 1]);
        }

}

module assembly(explode = false, opacity = 1) {
    if (explode) {
        color("orange", opacity)
            body(false, true);
        color("purple", opacity)
            translate([200, midplate_screw_height, midplate_mount_height])
                midplate();
        translate([400, midplate_screw_height+wall_thickness+6, wall_thickness/2+print_clearance])
            screen(opacity);
        color("blue", opacity)
            translate([-200, wall_thickness, case_depth-wall_thickness])
                lid();
    } else {
        color("orange", opacity)
            body(false, true);
        color("purple", opacity)
            translate([wall_thickness+print_clearance/2, midplate_screw_height, midplate_mount_height])
                midplate();
        translate([ wall_thickness+print_clearance/2, midplate_screw_height+wall_thickness+7.5, wall_thickness/2+print_clearance])
            screen(opacity);
        translate([wall_thickness, wall_thickness, case_depth-wall_thickness])
            color("blue", opacity)
                lid();
    }
}

assembly(true);