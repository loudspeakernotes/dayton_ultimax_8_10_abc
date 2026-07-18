// Aperiodic Bi-Chamber enclosure (ABC)
// for Dayton Ultimax 8" or 10" subwoofer
//
// Ultimax 8
// https://www.daytonaudio.com/product/2062/umii8-22-ultimax-ii-8-dvc-subwoofer-2-ohms-per-coil
// specs
// https://www.daytonaudio.com/images/resources/295-708--dayton-audio-UMII8-22-spec-sheet.pdf
//
// Ultimax 10
// https://www.daytonaudio.com/product/2062/umii8-22-ultimax-ii-8-dvc-subwoofer-2-ohms-per-coil
// specs
// https://www.daytonaudio.com/images/resources/295-708--dayton-audio-UMII8-22-spec-sheet.pdf


// Parameters that can be changed


// sub radius - the largest radius of the basket, ie no bevel
// 107 for 8" sub
// 133 for 10" sub
subr = 133;

ih = 815; // overall inner height

rh = 375; // rear chamber inner height (ie bottom chamber)

t = 13; // plywood timber thickness

mpy = 180; // hardcoded distance of midport from front wall

suby = 40; // how far set back the sub panel is

// Parameters that probably won't change

iw = 350; // inner width
id = 450; // inner depth

ph = 30; // port height

rpl = 900; // rear port length
fpl = 370; // front port length

mpw = 200; // mid port width
mpd = 50; // mid port depth
mpl = 130; // mid port length


// The panels

// left side
translate([0, 0, 0]) {
    d = t+id+t;
    h = t+ih+t;
    cube([t, d, h]);
    echo(str("Left side panel: ", d, " x ", h));
}

// right side
translate([t+iw, 0, 0]) {
    d = t+id+t;
    h = t+ih+t;
    //cube([t, t+id+t, h]);
    echo(str("Right side panel: ", d, " x ", h));
}

// bottom
translate([t, t, 0]) {
    w = iw;
    d = id;
    color("red") cube([iw, d, t]);
    echo(str("Bottom panel: ", w, " x ", d));
}

// top
translate([t, 0, ih+t]) {
    w = iw;
    d = t+id;
    color("red") cube([iw, d, t]);
    echo(str("Top panel: ", w, " x ", d));
}

// rear
translate([t, t+id, 0]) {
    w = iw;
    d = t;
    h = t+ih+t;
    color("green") cube([w, d, h]);
    echo(str("Rear panel: ", h, " x ", w));
}

// front
translate([t, 0, 0]) {
    w = iw;
    d = t;
    h = t + rh + t;
    color("green") cube([w, d, h]);
    echo(str("Front panel: ", h, " x ", w));
}

// sub panel
subph = ih - ph - t - ph - t - rh - t; // sub panel height
translate([t, suby, t+rh+t]) {
    h = subph;
    d = t;
    w = iw;
    difference() {
        color("green") cube([w, d, h]);
        // cutout for sub
        suboffset = (h - subr*2) / 2;
        translate([w/2, -1, h-suboffset-subr]) {
            rotate([-90, 0, 0]) {
                cylinder(r=subr, h=t+2);
            }
        }
    }
    echo(str("Sub panel: ", h, " x ", w));
}

// horizontal divider
translate([t, t, t+rh]) {
    w = iw;
    d = id - ph - t;
    echo(str("Divider: ", d, " x ", w));
    difference() {
        color("blue") cube([w, d, t]);
        // mid port hole
        mpx = (iw - mpw) / 2;
        translate([mpx, mpy, -1]) {
            cube([mpw, mpd, t+2]);
        }
    }
}

// rear port horizontal
rpd = t + id - ph - t; // rear port depth of the ply sheet
translate([t, 0, t+ih-ph-t]) {
    w = iw;
    d = rpd;
    color("blue") cube([w, d, t]);
    echo(str("Rear port horizontal: ", d, " x ", w));
}


// rear port depth path
// ie length of the horizontal part of the rear port
rpdp = rpd + ph/2;
// rear port remaining length after accounting for horizontal part of the part
rprl = rpl - rpdp - ph/2;
// the starting z value for the rear port vertical
rpz = t + ih - ph - rprl;
// rear port vertical
translate([t, rpd, rpz]) {
    w = iw;
    h = rprl;
    color("magenta") cube([w, t, h]);
    echo(str("Rear port vertical: ", h, " x ", w));
}

// front port horizontal
translate([t, 0, t+ih-ph-t-ph-t]) {
    w = iw;
    d = fpl;
    color("blue") cube([w, d, t]);
    echo(str("Front port horizontal: ", d, " x ", w));
}

// mid port
ompw = t + mpw + t; // outer mid port width
ompd = t + mpd + t; // outer mid port depth
mpz = t + rh - mpl;
mpv = ompw * ompd * mpl;
mpx = (t + (iw-mpw)) / 2;
translate([mpx, mpy, mpz]) {
    difference() {
        color("grey") cube([ompw, ompd, mpl]);
        translate([t, t, -1]) {
            cube([mpw, mpd, mpl+2]);
        }
    }
}

// calculate and report some volumes
// front chamber volume
fch = subph;
fcd = id - ph-t - suby;
fcw = iw;
fcv = fch*fcd*fch/1000000;
echo(str("Front chamber volume: ", fcv, " L"));
// rear chamber volume
rch = rh;
rcd = id;
rcw = iw;
rcvnmp = rch*rcd*rch; // rear chamber volume with no mid port
rcv = (rcvnmp - mpv)/1000000;
echo(str("Rear chamber volume: ", rcv, " L"));