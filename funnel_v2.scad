$fn = 200;

function curve(x) = pow(2, x) - 1;

wall_thickness = 1.5;
bottom_radius = 45; // 90мм диаметр
top_radius = 85;    // 180мм диаметр
full_height = 100;
cylinder_height = 35;
cone_height = full_height - cylinder_height;

// Цилиндр
module round_cylinder() {
    

    difference() {
        cylinder(h = cylinder_height, r = bottom_radius);
        cylinder(h = cylinder_height, r = bottom_radius - wall_thickness);
    }
}

// Круговой конус с кривой
module curved_round_cone() {
    steps = 100;
    outer_points = [
        for (i = [0 : steps])
            let (t = i / steps)
            [bottom_radius + (top_radius - bottom_radius) * curve(t), t * cone_height]
    ];
    inner_points = [
        for (i = [steps : -1 : 0])
            let (t = i / steps)
            [bottom_radius + (top_radius - bottom_radius) * curve(t) - wall_thickness, t * cone_height]
    ];
    profile = concat(outer_points, inner_points);
    rotate_extrude()
        polygon(points = profile);
}

// Сборка и деформация в овал
scale([75/90, 65/90, 1])  // ← сжимаем в эллипс: 75×65 вместо 90×90
union() {
    round_cylinder();
    translate([0, 0, cylinder_height])
        curved_round_cone();
}
