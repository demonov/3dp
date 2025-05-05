// Module for creating a U-shaped bracket with lid slots
module u_bracket(width = 56.4, length = 46.1, profile = 10, slot_depth = 0.8, lid_thickness = 1, lower_border = 3) {

    fit = 0.3;
        
    difference() {
        // Outer rectangle
        cube([width + 2 * profile, length + profile, profile]);
        
        // Cut bottom 
        translate([profile + lower_border, 0, 0])
            cube([width - 2 * lower_border, length - lower_border, profile]);
            
        // Cut middle with the slot
        translate([profile - fit / 2, 0, profile / 2 - lid_thickness / 2 - fit / 2])
            cube([width + fit, length + fit, lid_thickness + fit]);
        
        // Cut top 
        translate([profile + slot_depth, 0, profile / 2 + lid_thickness / 2 + fit / 2])
            cube([width - 2 * slot_depth, length - slot_depth, profile / 2 + slot_depth]);

    }
}

module hdd_blank(hdd_length = 146, hdd_width  = 101.6, hdd_height = 25.4, hole_diameter = 4.0) {

    // Нижние отверстия (по длине 26.1 мм от краёв, по ширине на 82.5 мм между центрами)
    bottom_holes_x = [26.1, hdd_length - 26.1];
    bottom_holes_y = [(hdd_width - 82.5) / 2, (hdd_width + 82.5) / 2];

    // Боковые отверстия (по длине 25.4 мм от краёв, по высоте ~6.35 мм от низа)
    side_holes_x = [25.4, hdd_length - 25.4];
    side_holes_z = 6.35;
    difference() {
        // Корпус
        cube([hdd_length, hdd_width, hdd_height]);

        // Нижние отверстия
        for (x = bottom_holes_x)
            for (y = bottom_holes_y)
                translate([x, y, -1])
                    cylinder(h=5, d=hole_diameter, $fn=30);

        // Левая сторона
        for (x = side_holes_x)
            translate([x, -1, side_holes_z])
                rotate([270,0,0])
                    cylinder(h=5, d=hole_diameter, $fn=30);

        // Правая сторона
        for (x = side_holes_x)
            translate([x, hdd_width + 1, side_holes_z])
                rotate([90,0,0])
                    cylinder(h=5, d=hole_diameter, $fn=30);
    }
}

module hdd_bracket(hdd_length = 146, hdd_width  = 101.6, hdd_height = 25.4,thickness = 6) {

    difference() {
        hdd_blank(hdd_length, hdd_width, hdd_height);
        
        y_thickness = 14;
        translate([0, y_thickness, thickness]) {
            cube([hdd_length, hdd_width - 2 * y_thickness, hdd_height - thickness]);
        }
    }
}

difference() {
    union() {
        hdd_bracket();

        b_offset = 101.6 - (101.6 - (56.4 + 2 * 10))/2;

        for (i = [10, 75])
            translate([i, b_offset, 15])
                rotate([-15, 0, 270])
                    u_bracket();
    }
    
    for (i = [7, 101.6 - 7]) 
        translate([0, i, 18.4])
            rotate([0, 90, 0])
                cylinder(h=146, d=10, $fn=30);
    
}