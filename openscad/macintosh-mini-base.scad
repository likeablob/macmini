$fn=40;
include <mylib.scad>
include <scad-utils/morphology.scad>

WH_RATIO = 22.7/29.2;
DH_RATIO = 46.0/63.4;

BODY_Z = 90;
BODY_X = BODY_Z * WH_RATIO;
BODY_Y = BODY_Z * DH_RATIO;

module copy_mirror(vec=[0,1,0]){
    children();
    mirror(vec) children();
}

module base(mscale=1) {
  difference() {
    hull() {
      // upper
      translate([0, 0, (BODY_X)/2 + (BODY_Z-BODY_X)/2])
      rotate([0, 5, 0])
      cube(size=[BODY_X, BODY_Y, BODY_X], center=true);

      // lower
      translate([0, 0, (BODY_Z-BODY_X)/2])
      cube(size=[BODY_X, BODY_Y, BODY_Z-BODY_X], center=true);

      // display
      rotate([0, 5, 0])
      translate([-BODY_X/2-6, 0, (BODY_Z-BODY_X)/2-1])
      translate([0, 0, BODY_X/2])
      cube(size=[0.1, BODY_Y*0.97, BODY_X*0.93], center=true);
    }

    // under the display
    minkowski() {
      UD_Z = (BODY_Z-BODY_X)/2*0.6;
      translate([-BODY_Y/2-10/2, 0, UD_Z-1.5])
      hull() {
        rotate([0, 5, 0])
        cube(size=[BODY_Y*0.2+10, BODY_Y+1, UD_Z*2], center=true);

        /* translate([BODY_Y*0.2/2+8, 0, -UD_Z])
        rotate([90, 0, 0])
        cylinder(d=0.01, h=BODY_Y+1, center=true); */
        translate([BODY_Y*0.2/2+1, 0, -UD_Z])
        rotate([90, 0, 0])
        cylinder(d=0.01, h=BODY_Y+1, center=true);
      }

      rotate([90, 0, 0])
      cylinder(d=1, h=10, center=true);
    }

    // top mizo
    translate([BODY_X*0.4, 0, BODY_Z-BODY_Z*0.27])
    rotate([0, 5, 0])
    scale([mscale, mscale, mscale])
    linear_extrude(height=BODY_Z*0.3, scale=1.1,  center=false, convexity=10, twist=0)
    square(size=[BODY_X, BODY_Y/2], center=true);

    // back edge
    translate([BODY_Y, 0, BODY_X/2 + BODY_Z*0.5])
    rotate([0, 60, 0])
    cube(size=[BODY_X, BODY_Y+3, BODY_X], center=true);

    // back
    translate([BODY_X/2+BODY_X*0.1/2-1, 0, (BODY_Z)/2])
    cube(size=[BODY_X*0.1, BODY_Y*1.2, BODY_Z], center=true);

    // side edge
    *copy_mirror([0,1,0])
    translate([-BODY_X/2, BODY_Y/2, 0])
    translate([0, 0, BODY_Z/2*1.1])
    rotate([0, 5, 0])
    rotate([0, 0, 60])
    cube(size=[5, 5, BODY_Z], center=true);
  }
}

THICK=-5;

// variables for partB
OPIZ_X = 48;
OPIZ_Y = 46;
OPIZ_Z = 10;

OPI_HOLE_POS = 2.8;

HDMI_Z=5.5;
HDMI_Y=15;

OPIZ_HLD_Z = BODY_Z*0.6;
OPIZ_HLD_Y = 5;
OPIZ_HLD_X = 10;

OPIZ_OFFSET_Z = 6;
OPIZ_OFFSET_X = -1.5;

BACKPANEL_X = 1.0;

module partB() {
  difference() {
    union() {
      difference() {
        intersection(){
          difference(){
            minkowski() {
              base();
              rotate([0, 90, 0])
              cylinder(d=5, h=0.01, center=true);
            }
            // inner space
            difference() {
              translate([-0.5, 0, 0])
              scale([0.95, 1, 1])
              resize([BODY_X-THICK, 0, 0], auto=[false, true, true])
              base(1.15);

              translate([BODY_X/2+10/2-3, 0, 0])
              cube(size=[10, BODY_Y*2, BODY_Z*2], center=true);
            }

            copy_mirror([0,1,0])
            translate([BODY_X/2-10, BODY_Y*0.91/2, BODY_Z*0.68])
            rotate([0, 90, 0]){
              screw(2);
              translate([0, 0, 8.5])
              screw(4);
            }

            copy_mirror([0,1,0])
            translate([BODY_X/2-10, BODY_Y*0.91/2, BODY_Z*0.1])
            rotate([0, 90, 0]){
              screw(2);
              translate([0, 0, 8.5])
              screw(4);
            }

            copy_mirror([0,1,0])
            translate([-BODY_X*0.2, BODY_Y*0.91/2, BODY_Z*0.1/3])
            union(){
              screwB(3);
              translate([0, 0, -15])
              screwB(4);
            }

          }

          // partB

          union() {
            H2 = (BODY_Z-BODY_X);
            Y=BODY_Y-THICK-4-1;
            // front
            hull() {
              translate([-(BODY_X/2 + BODY_Y*0.2)/2-1, 0, H2/2-2])
              cube(size=[1, Y+8, 2], center=true);

              translate([-(BODY_X/2 + BODY_Y*0.2)/2-1.3, 0, -2])
              cube(size=[2, Y+8, 2], center=true);

              translate([-(BODY_X/2)/2, 0, -4])
              cube(size=[2, Y+8, 2], center=true);
            }

            // bottom
            cube(size=[BODY_X, Y, BODY_X*0.1], center=true);

            // back
            translate([(BODY_X/2), 0, BODY_Z*0.75/2-1-0.3])
            cube(size=[BODY_X*0.2, Y, BODY_Z*0.70], center=true);
          }

        }

        // hdmi
        color("red")
        translate([BODY_X/2-OPIZ_X/2-3, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
        rotate([90, 0, 0])
        translate([OPIZ_X/2+3, OPIZ_Y/2-HDMI_Y/2-6.5, 2.5])
        hdmi(0.3);

        // micro usb for power
        translate([BODY_X/2-USBM_BOARD[0]/2+OPIZ_OFFSET_X-1.1, -BODY_Y/4, 2])
        rotate([0, 0, 180])
        usbm_board(0.2);

        // micro usb for keyboards
        translate([-BODY_X*0.1-USBM_BOARD[0]/2-2, -BODY_Y/4,1])
        usbm_board(0.2);

        // switch
        translate([BODY_X/2, -BODY_Y/4, BODY_Z*0.6])
        rotate([0, 90, 0])
        linear_extrude(height=10, center=true, convexity=10, twist=0)
        circle(d=4);

      } // diff

      // opi holder
      translate([OPIZ_OFFSET_X, 0, 0])
      difference() {
        union() {
          translate([BODY_X/2-OPIZ_HLD_X/2-1, OPIZ_HLD_Y/2 + BODY_Y/3.5  + 1, OPIZ_HLD_Z/2])
          cube(size=[OPIZ_HLD_X, OPIZ_HLD_Y, OPIZ_HLD_Z], center=true);

          translate([BODY_X/2+OPIZ_HLD_X/2-5-OPIZ_X, OPIZ_HLD_Y/2 + BODY_Y/3.5  + 1, OPIZ_HLD_Z/4.5/2])
          cube(size=[OPIZ_HLD_X, OPIZ_HLD_Y, OPIZ_HLD_Z/4], center=true);

          // screw base A
          translate([BODY_X/2-OPIZ_X/2-3, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
          rotate([90, 0, 0])
          mirror_y()
          translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, -1])
          cylinder(d=6, h=1, d2=5, center=!true);

          // screw base B
          translate([BODY_X/2-OPIZ_X/2-3, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
          rotate([90, 0, 0])
          mirror([1, 0, 0])
          mirror([0, 1, 0])
          translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, -1])
          cylinder(d=6, h=1, d2=5, center=!true);
        }

        // screws A
        translate([BODY_X/2-OPIZ_X/2-3, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
        rotate([90, 0, 0])
        mirror_y()
        translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, -1])
        cylinder(d=2, h=10, center=true);

        // screws B
        translate([BODY_X/2-OPIZ_X/2-3, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
        rotate([90, 0, 0])
        mirror([1, 0, 0])
        mirror([0, 1, 0])
        translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, -1])
        cylinder(d=2, h=10, center=true);

      }

      // micro usb for power - screws
      translate([BODY_X/2-USBM_BOARD[0]/2+OPIZ_OFFSET_X-1.1, -BODY_Y/4, 0])
      rotate([0, 0, 180])
      usbm_board_screws(d=8, h=2, center=false);

      // micro usb for keyboards - screws
      translate([-BODY_X*0.1-USBM_BOARD[0]/2-2, -BODY_Y/4, 0])
      usbm_board_screws(d=8, h=1, center=false);

      // magnets - holder
      mirror_y()
      translate([7, BODY_Y/2.6, 0])
      cylinder(d=12, h=4, center=!true);
      } // union

      // micro usb for power
      translate([BODY_X/2-USBM_BOARD[0]/2+OPIZ_OFFSET_X-1.1, -BODY_Y/4, -2.2])
      rotate([0, 0, 180])
      usbm_board_screws(d=2, h=5, center=false);

      // micro usb for keyboards
      translate([-BODY_X*0.1-USBM_BOARD[0]/2-2, -BODY_Y/4, -2.2])
      usbm_board_screws(d=2, h=5, center=false);

      // magnets - holder
      mirror_y()
      translate([7, BODY_Y/2.6, -2.6]) {
        cylinder(d=11, h=3+0.01, center=!true);
        translate([0, 0, 3])
        cylinder(d=11, d2=3, h=2, center=!true);
      }

      // magnets - holder
      mirror_y()
      translate([7, BODY_Y/2.6, -2.6]) {
        cylinder(d=1.5, h=10, center=!true);
      }

      // back panel A
      color("red")
      translate([BODY_X/2+10/2-1-BACKPANEL_X, BODY_Y/3.5-5, OPIZ_Y/2+14])
      rotate([0, 90, 0])
      linear_extrude(height=10, center=true, convexity=10, twist=0)
      rounding(0.8)
      square(size=[35, 8], center=true);

      // back panel B
      color("red")
      translate([BODY_X/2+10/2-1-BACKPANEL_X, 0, 2])
      rotate([0, 90, 0])
      linear_extrude(height=10, center=true, convexity=10, twist=0, scale=1.2)
      rounding(0.8)
      square(size=[20, 60], center=true);

      // back panel C
      color("red")
      translate([BODY_X/2+10/2-1.5, -5, BODY_Z*0.35])
      rotate([0, 90, 0])
      linear_extrude(height=10, center=true, convexity=10, twist=0)
      rounding(0.8)
      square(size=[35, 25], center=true);

    }


    module pport(y=10, z=3) {
      rotate([0, 90, 0])
      linear_extrude(height=1.0, center=true, convexity=10, twist=0)

      difference() {
        union() {
          rounding(0.8)
          hull() {
            square(size=[0.1, y], center=true);
            translate([z, 0, 0])
            square(size=[0.1, y*0.85], center=true);
          }
          mirror_y()
          translate([z/2, y/2+0.5, 0])
          circle(d=1.9);
        }
        for (i=[-y/3:y/3]) {
          translate([z/3, i*1.2, 0])
          circle(d=1);
        }
        for (i=[-y/4:y/4+1]) {
          translate([z/1.5, i*1.2-1.2/2, 0])
          circle(d=1);
        }
        mirror_y()
        translate([z/2, y/2+0.5, 0])
        circle(d=1);
      }
    }

    // parallel port
    color("green")
    translate([BODY_X/2-1-BACKPANEL_X, 1, 7])
    pport(14, 4);

    // ps/2 port
    color("green")
    translate([BODY_X/2-1-BACKPANEL_X, BODY_Y/4, 5])
    rotate([0, 90, 0])
    linear_extrude(height=1, center=true, convexity=10, twist=0)
    union() {
      shell(0.3)
      circle(d=3);
      translate([-3/2+1/2, 0, 0])
      square(size=[1, 1], center=true);
    }

    // ps/2 port
    color("green")
    translate([BODY_X/2-1-BACKPANEL_X, BODY_Y/4+6, 5])
    rotate([0, 90, 0])
    linear_extrude(height=1.0, center=true, convexity=10, twist=0)
    union() {
      shell(0.3)
      circle(d=3);
      translate([-3/2+1/2, 0, 0])
      square(size=[1, 1], center=true);
    }

    // display holder
    difference() {
      hull() {
        translate([-(BODY_X-THICK)*0.9/2+3, 0, BODY_Z/1.6])
        rotate([0, 5, 0])
        cube(size=[1, 15, 15], center=true);

        translate([-BODY_X*0.1, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=1, h=15, center=true);

        translate([-BODY_X*0.27, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=1, h=12, center=true);
      }

      translate([2, 0, 0])
      scale([1, 0.7, 1])
      hull() {
        translate([-(BODY_X-THICK)*0.9/2+3, 0, BODY_Z/1.6])
        rotate([0, 5, 0])
        cube(size=[1, 15, 15], center=true);

        translate([-BODY_X*0.1, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=1, h=15, center=true);

        translate([-BODY_X*0.27, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=1, h=12, center=true);
      }

      // screw base
      translate([BODY_X/2-OPIZ_X/2-3 + OPIZ_OFFSET_X, 0, OPIZ_Y/2 + OPIZ_OFFSET_Z])
      rotate([90, 0, 0])
      mirror([1, 0, 0])
      mirror([0, 1, 0])
      translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, -1])
      cylinder(d=6, h=20, center=true);

      // pin header
      translate([BODY_X/2-OPIZ_X/2-3 + OPIZ_OFFSET_X, 0, OPIZ_Y/2 + OPIZ_OFFSET_Z])
      rotate([90, 0, 0])
      translate([-OPIZ_X/2+33/2+7.7, -OPIZ_Y/2+5/2, -1])
      cube(size=[33, 5, 20], center=true);
    }

    // switch holder
    translate([BODY_X/2-10/2-3, -BODY_Y/4, BODY_Z*0.6-5.5])
    difference() {
      cube(size=[10, 5, 15], center=true);

      translate([0, 0, -10])
      rotate([0, -60, 0])
      cube(size=[10, 5+1, 25], center=true);

      translate([-6/2+10/2, 0, 15-5])
      cube(size=[6, 5+1, 15], center=true);
    }
}

module hdmi(offset=0.1) {
  translate([0, 0, HDMI_Z]) {
    rotate([-90, 0, 90])
    linear_extrude(height=10, center=!true, convexity=10, twist=0)
    outset(offset)
    hull() {
      translate([0, 4/2, 0])
      square(size=[HDMI_Y, 4], center=true);
      translate([0, HDMI_Z/2, 0])
      square(size=[11, HDMI_Z], center=true);
    }
  }
}

// opi
%translate([BODY_X/2-OPIZ_X/2-3+OPIZ_OFFSET_X, BODY_Y/3.5, OPIZ_Y/2 + OPIZ_OFFSET_Z])
rotate([90, 0, 0]){
  translate([0, 0, OPIZ_Z/2])
  cube(size=[OPIZ_X, OPIZ_Y, OPIZ_Z], center=true);

  //screw
  mirror_x()
  mirror_y()
  translate([OPIZ_X/2-OPI_HOLE_POS, OPIZ_Y/2-OPI_HOLE_POS, 0])
  cylinder(d=3, h=10, center=true);

  // hdmi
  translate([OPIZ_X/2+3, OPIZ_Y/2-HDMI_Y/2-6.5, 2])
  hdmi();
}

// partA
module partA() {
  difference() {
    minkowski() {
      base();
      rotate([0, 95, 0])
      cylinder(d=5, h=0.01, center=true);
    }

    // display
    translate([0, 0, BODY_X/2 + (BODY_Z-BODY_X)/2*1.8])
    rotate([0, 5, 0])
    hull() {
      DISP_Y = 72.6;
      translate([-BODY_X/2-4, 0, 0])
      cube(size=[0.1, DISP_Y*0.9, DISP_Y*0.9*0.75], center=true);

      translate([-30, 0, 0])
      sphere(d=20);
    }

    // inner space
    scale([0.9, 1, 1])
    resize([BODY_X-THICK, 0, 0], auto=[false, true, true])
    base(1.15);

    // floppy
    floppy();

    // partB
    union() {
      H2 = (BODY_Z-BODY_X);
      Y=BODY_Y-THICK-4;
      // front
      hull() {
        translate([-(BODY_X/2 + BODY_Y*0.2)/2-1, 0, H2/2-2])
        cube(size=[2, Y+8, 2], center=true);

        translate([-(BODY_X/2 + BODY_Y*0.2)/2-1.2, 0, -2])
        cube(size=[2, Y+8, 2], center=true);

        translate([-(BODY_X/2)/2, 0, -4])
        cube(size=[2, Y+8, 2], center=true);
      }

      // bottom
      cube(size=[BODY_X, Y, BODY_X*0.1], center=true);

      // back
      translate([(BODY_X/2), 0, BODY_Z*0.75/2-1])
      cube(size=[BODY_X*0.2, Y, BODY_Z*0.70], center=true);
    }

    // air intake
    copy_mirror([0,1,0])
    translate([BODY_X/2-BODY_X*0.2/2, BODY_Y/2-BODY_Y/8.5, BODY_Z-BODY_Z*0.141])
    for (i=[0:4]) {
      translate([0, 0, -i*0.6*3])
      cube(size=[BODY_X*0.2, BODY_Y/5, 0.9], center=true);
    }

    // air intake
    translate([-BODY_X*0.1, 0, BODY_Z-BODY_Z*0.175])
    for (i=[-4:4]) {
      translate([0, -i*0.8*3, 0])
      rotate([90, 0, 0])
      cube(size=[BODY_X*0.2, BODY_Y/12, 0.8], center=true);
    }

    /* translate([-BODY_X/2+4, 0, BODY_Z/2*0.88])
    rotate([0, 5, 0])
    rotate([90, 0, 90])
    linear_extrude(height=0.5, center=true, convexity=10, twist=0)
    shell(d=1)
    square(size=[BODY_Y+4, BODY_Z], center=true); */

  }


  // top cover
  translate([-3, 0, BODY_Z-BODY_Z*0.105])
  union() {
    rotate([0, 5, 0])
    cube(size=[BODY_X*0.18, BODY_Y/2, 2], center=true);

    translate([0, 0, -1])
    rotate([0, 5, 0])
    hull() {
      cube(size=[BODY_X*0.18, BODY_Y/3, 0.01], center=true);
      translate([0, 0, -2])
      cube(size=[BODY_X*0.18, BODY_Y/4, 0.01], center=true);
    }
  }

  copy_mirror([0,1,0])
  translate([BODY_X/2-10-3.5, BODY_Y*0.91/2, BODY_Z*0.68])
  rotate([0, 90, 0])
  screwBase();

  copy_mirror([0,1,0])
  translate([BODY_X/2-10-3.5, BODY_Y*0.91/2, BODY_Z*0.1])
  rotate([0, 90, 0])
  screwBase();

  copy_mirror([0,1,0])
  translate([-BODY_X*0.2, BODY_Y*0.91/2, BODY_Z*0.1/3])
  screwBaseB();
}


USBM_BOARD = [15, 14.3, 1.5];
module usbm_board(soffset=0.1) {
  difference() {
    translate([0, 0, USBM_BOARD[2]/2])
    cube(size=USBM_BOARD, center=true);

    // holes
    mirror_y()
    translate([USBM_BOARD[0]/2-5.5, USBM_BOARD[1]/2-2.5, 0])
    cylinder(d=3, h=10, center=true);
  }

  // socket
  translate([0, 0, USBM_BOARD[2]+0.3])
  rotate([90, 0, -90])
  linear_extrude(height=10, center=!true, convexity=10, twist=0)
  offset(soffset)
  hull() {
    translate([0, 2.7, 0])
    square(size=[6.8, 0.1], center=true);
    translate([0, 1.4, 0])
    square(size=[7.8, 0.1], center=true);
    square(size=[5.3, 0.1], center=true);
  }
}

module usbm_board_screws(d=3, h=10, center=true) {
  USBM_BOARD = [15, 14.3, 1.5];

  // holes
  mirror_y()
  translate([USBM_BOARD[0]/2-5.5, USBM_BOARD[1]/2-2.5, 0])
  cylinder(d=d, h=h, center=center);
}

module floppy(args) {
  // body...
  module floppy_baseA() {
    square(size=[BODY_Y/2.5, BODY_Z*0.01], center=true);
  }
  module floppy_baseB() {
    translate([-BODY_Y/2.5/2+BODY_Y/9/2, -BODY_Z*0.01, 0])
    square(size=[BODY_Y/9, BODY_Z*0.03], center=true);
  }
  module floppy_baseC() {
    /* offset(r=2) */
    translate([-BODY_Y/2.5/2+BODY_Y/9/2, BODY_Z*0.01, 0])
    square(size=[BODY_Y/9, BODY_Z*0.02], center=true);
  }
  module floppy_baseD() {
    translate([-BODY_Y/2.5/2+BODY_Y/9/2, 0, 0])
    square(size=[BODY_Y/9, BODY_Z*0.02*2], center=true);
  }

  FLOPPY_Z = BODY_Z*0.26;

  translate([-BODY_X/2, -BODY_Y*0.2, FLOPPY_Z])
  rotate([0, 5, 0])
  rotate([90, 0, 90])
  linear_extrude(height=7, center=true, convexity=10, twist=0){
    floppy_baseA();
    floppy_baseB();
  }

  translate([-BODY_X/2-3, -BODY_Y*0.2, FLOPPY_Z])
  rotate([0, 5, 0])
  rotate([90, 0, 90])
  offset(r=2)
  linear_extrude(height=5, center=true, convexity=10, twist=0)
  floppy_baseC();

  // front
  translate([-BODY_X/2-2, -BODY_Y*0.2, FLOPPY_Z])
  rotate([0, 5, 0])
  rotate([90, 0, 90]){
    hull() {
      linear_extrude(height=1, center=true, convexity=10, twist=0)
      floppy_baseA();

      translate([0, 0, -2])
      linear_extrude(height=1, center=true, convexity=10, twist=0, scale=1.1)
      offset(delta=1)
      offset(r=0.1)
      floppy_baseA();
    }
    hull() {
      linear_extrude(height=1, center=true, convexity=10, twist=0)
      offset(r=0.1)
      floppy_baseD();

      translate([0, 0, -2])
      linear_extrude(height=1, center=true, convexity=10, twist=0, scale=1.1)
      offset(delta=1)
      offset(r=0.1)
      floppy_baseD();
    }
  }
}

module screwBase() {
  XY = 8;
  Z = 10;

  difference() {
    translate([0, 0, Z/2])
    cube(size=[XY, XY, 10], center=true);

    cylinder(d=2, h=Z+1, center=!true);

    rotate([-40, 0, 0])
    translate([0, 0, -2])
    cube(size=[XY*2, XY*3, XY], center=true);

  }
}

module screwBaseB() {
  XY = 8;
  Z = 10;
  translate([0, 0, -XY/2])
  difference() {
    translate([0, 0, Z/2])
    cube(size=[XY*2, XY, XY], center=true);

    translate([XY/2, 0, 0])
    cylinder(d=2, h=Z+1, center=!true);

    rotate([0, 0, -90-60])
    translate([XY, 0, Z/2])
    cube(size=[XY*2, XY*3, Z+1], center=true);

  }
}

module screwB(d=2) {
  XY = 8;
  Z = 10;
  translate([XY/2, 0, 0])
  cylinder(d=d, h=Z*2, center=true);
}

module screw(d=2) {
  XY = 8;
  Z = 10;

  cylinder(d=d, h=Z+1, center=!true);
}
