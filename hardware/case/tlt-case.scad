// OpenSCAD version 2021.01 

// Library for raspberry pi model: https://github.com/RigacciOrg/openscad-rpi-library
include <common\openscad-rpi-library-master\openscad-rpi-library-master\misc_boards.scad>

screen_width = 155;
screen_height = 90;
screen_screw_height = 3.7;
screen_body_height = 9.05;
border_width = 10;
mx_width = 14;
mx_columns = 8;
mx_rows = 1;
key_width = 19.05;
key_spacing = key_width-mx_width;
tablet_width = screen_width + border_width*2;
tablet_height = screen_height + border_width*3 + mx_width;
cherry_plate_thickness = 1.5;
case_wall_thickness = 2;
// case_depth = 20;
midplate_mount_height = case_wall_thickness+screen_screw_height+screen_body_height;
case_depth = case_wall_thickness+26+screen_body_height+case_wall_thickness;
case_lid_lip = 8;
screw_mount_width = 8;
midplate_tab_width = 10;
midplate_tab_height = case_wall_thickness;
midplate_tab_depth = case_wall_thickness/2;
exploded = true;

module face(args) {
    difference() {
        square(size=[tablet_width, tablet_height]);

        // Screen border
        translate([border_width, border_width*2+ mx_width, 0])
            square(size=[screen_width, screen_height]);
        
        // Hole for mx grid
        translate([border_width, border_width, 0])
            square(size=[key_spacing+(mx_width+key_spacing)*mx_columns, key_spacing+(mx_width+key_spacing)*mx_rows]);

    }
}


module mx_grid(x, y) {
    linear_extrude(height=cherry_plate_thickness) {
        difference() {
            square(size=[key_spacing+(mx_width+key_spacing)*x, key_spacing+(mx_width+key_spacing)*y]);

            for (i=[0:x-1]) {
                for (j=[0:y-1]) {
                    translate([key_spacing+(mx_width+key_spacing)*i, key_spacing+(mx_width+key_spacing)*j, 0])
                        mxMount();
                }
            }
        }
    }
}

module mxMount(args) {
    square(size=[ mx_width, mx_width]);
}

module body(args) {
    linear_extrude(height=case_wall_thickness)
        face();
        translate([border_width, border_width, 0])
    mx_grid(mx_columns, mx_rows);
    // Case sides
    difference() {
        difference() {
            cube(size=[tablet_width, tablet_height, case_depth]);
            translate([case_wall_thickness, case_wall_thickness, 0])
                cube(size=[tablet_width-case_wall_thickness*2, tablet_height-case_wall_thickness*2, case_depth]);
            // Midplate tab holes
            translate([case_wall_thickness, tablet_height-midplate_tab_depth-case_wall_thickness/2, midplate_mount_height+case_wall_thickness])
                cube(size=[midplate_tab_width, midplate_tab_depth, midplate_tab_height]);
            translate([tablet_width-case_wall_thickness-10, tablet_height-midplate_tab_depth-case_wall_thickness/2, midplate_mount_height+case_wall_thickness])
                cube(size=[midplate_tab_width, midplate_tab_depth, midplate_tab_height]);
        }
    }
    
    // Case lid lip
    translate([0, tablet_height-case_lid_lip, case_depth])
        linear_extrude(height=case_wall_thickness)
            square(size=[tablet_width, case_lid_lip]);
    // Lid screw mounts
    translate([0, case_wall_thickness, 0])
        linear_extrude(height=case_depth)
            difference() {            
                square(size=[screw_mount_width, screw_mount_width]);
                translate([screw_mount_width/2, screw_mount_width/2, 0])
                    circle(d=3);
            }
    translate([tablet_width-screw_mount_width, case_wall_thickness, 0])
        linear_extrude(height=case_depth)
            difference() {            
                square(size=[screw_mount_width, screw_mount_width]);
                translate([screw_mount_width/2, screw_mount_width/2, 0])
                    circle(d=3);
            }
    // Midplate screw mounts
    translate([0, case_wall_thickness+border_width+mx_width, 0])
        linear_extrude(height=midplate_mount_height)
            difference() {            
                square(size=[screw_mount_width, screw_mount_width]);
                translate([screw_mount_width/2, screw_mount_width/2, 0])
                    circle(d=3);
            }
    translate([tablet_width-screw_mount_width, case_wall_thickness+border_width+mx_width, 0])
        linear_extrude(height=midplate_mount_height)
            difference() {            
                square(size=[screw_mount_width, screw_mount_width]);
                translate([screw_mount_width/2, screw_mount_width/2, 0])
                    circle(d=3);
            }
}

module lid(args) {
    linear_extrude(height=case_wall_thickness)
        difference() {  
            // Main plate body          
            square(size=[tablet_width, tablet_height-case_lid_lip]);
            // Screw mount holes
            translate([screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=3);
            translate([tablet_width-screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=3);
        }
    // Lid lip
    // magic number 5 is to make the lip attach to the body
    translate([case_wall_thickness, tablet_height-case_lid_lip-5, -case_wall_thickness])
        linear_extrude(height=case_wall_thickness)
            square(size=[tablet_width-case_wall_thickness*2, case_lid_lip+5]);

}

module midplate(args) {
    midplate_height = tablet_height-(border_width+mx_width)-screw_mount_width/2;
    linear_extrude(height=case_wall_thickness)
        difference() {            
            // Main plate body          
            square(size=[tablet_width-case_wall_thickness*2, midplate_height]);
            // Screw mount holes
            translate([screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=3);
            translate([tablet_width-case_wall_thickness*2-screw_mount_width/2, screw_mount_width/2, 0])
                circle(d=3);
            translate([10, 5, 0])
                screen_holes(1);
        }
    // Lid lip
    // magic number 5 is to make the lip attach to the body
    translate([0, midplate_height-5, case_wall_thickness])
        linear_extrude(height=midplate_tab_height)
            square(size=[midplate_tab_width, midplate_tab_depth+5]);
    translate([tablet_width-case_wall_thickness*2-midplate_tab_width, midplate_height-5, case_wall_thickness])
        linear_extrude(height=midplate_tab_height)
            square(size=[midplate_tab_width, midplate_tab_depth+5]);

}

module screen_holes(screw_size=3) {
    translate([0, 0, 0])
        circle(r=screw_size);
    translate([0, 91.5, 0])
        circle(r=screw_size);
    translate([155, 91.5, 0])
        circle(r=screw_size);
    translate([155, 0, 0])
        circle(r=screw_size);
    translate([27, 8, 0])
        square(size=[92, 60]);
    translate([112.5, 28.5])
        square(size=[25, 17]);
}

module screen(){
    // screen screw mounts
    translate([5, 5, screen_body_height])
        linear_extrude(height=screen_screw_height)
            screen_holes();
    // basic raspberry pi 3 model b + ribbon cable
    // translate([5, 5, screen_body_height])
    //     linear_extrude(height=26)
    //         translate([15, 5.5, 0])
    //             square(size=[125, 62]);
    // ribbon cable
    translate([122-4.5, 33.5, screen_body_height])
        cube(size=[25, 17, 26]);
    // screen body
    difference() {
        cube(size=[165, 102, screen_body_height]);
        // screen viewing area
        translate([7, 11, 0])
            cube(size=[154.25, 86.5, 1]);
    }
    // advanced raspberry pi 3 model b
    translate([122, 13.5,screen_body_height+7.85 ])
        rotate([0, 0, 90])
            board_raspberrypi_3_model_b();

}

module assembly(explode = false, opacity = 1) {
    if (explode) {
        color("orange", opacity)
            body();
        color("purple", opacity)
            translate([200, border_width+mx_width-case_wall_thickness+screw_mount_width/2, midplate_mount_height])
                midplate();
        // color("green", opacity)
            translate([400, border_width+mx_width-case_wall_thickness+screw_mount_width/2, case_wall_thickness])
                screen();
        color("blue", opacity)
            translate([-200, 0, case_depth])
                lid();
    } else {
        color("orange", opacity)
            body();
        translate([case_wall_thickness, border_width+mx_width-case_wall_thickness+screw_mount_width/2, 0]) {
            color("purple", opacity)
                translate([0,0, midplate_mount_height])
                    midplate();
            color("green", opacity)
                translate([5,0, case_wall_thickness])
                    screen();
        }
        translate([0, 0, case_depth])
            color("blue", opacity)
                lid();
    }
}

assembly(exploded, 0.5);

// Todo
// make screw mounts fit heatset inserts with proper depth and diameter
// add tolerances to tabs and plates
// set screen into front of case
// tighter tolerances around the screen and switches
// add battery to model
// round corners
// add handle
// add cheese plate
// add battery mount