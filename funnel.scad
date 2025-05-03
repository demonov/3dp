/*
$fn = 200; // гладкость

wall_thickness = 4;
bottom_outer_diameter = 90;
cylinder_height = 40;
top_outer_diameter = 180;

// внутренние диаметры
bottom_inner_diameter = bottom_outer_diameter - 2 * wall_thickness;
top_inner_diameter = top_outer_diameter - 2 * wall_thickness;

module funnel() {
    union() {
        // нижний цилиндр
        translate([0, 0, - cylinder_height]) {
            difference() {
                cylinder(h = cylinder_height, d = bottom_outer_diameter);
                translate([0, 0, 0])
                    cylinder(h = cylinder_height, d = bottom_inner_diameter);
            }
        }

        // конус
        difference() {
            cylinder(h = 60, d1 = bottom_outer_diameter, d2 = top_outer_diameter);
            translate([0, 0, 0])
                cylinder(h = 60, d1 = bottom_inner_diameter, d2 = top_inner_diameter);
        }
    }
}

funnel();
*/

$fn = 200;

wall_thickness = 4;
bottom_outer_radius = 45; // 90mm diameter
top_outer_radius = 90;    // 180mm diameter
cone_height = 60;
steps = 100;

// Generate outer profile points
outer_points = [
    for (i = [0:steps]) 
        let (t = i / steps)
        [bottom_outer_radius + (top_outer_radius - bottom_outer_radius) * pow(t, 2), t * cone_height]
];

// Generate inner profile points (reversed)
inner_points = [
    for (i = [steps:-1:0])
        let (t = i / steps)
        [bottom_outer_radius + (top_outer_radius - bottom_outer_radius) * pow(t, 2) - wall_thickness, t * cone_height]
];

profile = concat(outer_points, inner_points);

module curved_funnel_wall() {
    rotate_extrude()
        polygon(points = profile);
}

// Bottom cylinder
module bottom_cylinder() {
    difference() {
        cylinder(h = 40, r = bottom_outer_radius);
        translate([0, 0, 0])
            cylinder(h = 40, r = bottom_outer_radius - wall_thickness);
    }
}

// Final model
union() {
    bottom_cylinder();
    translate([0, 0, 40])
        curved_funnel_wall();
}
