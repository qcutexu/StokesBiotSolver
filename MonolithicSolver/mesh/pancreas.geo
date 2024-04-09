//Defining parameters
R=0.7;   //Radius of chanels
Length_inlet=0.4; //Length of inlet/outlet chanels
Angle=Pi/7;
Length_oblique=6; //Length of the oblique chanel
Length_straight=2; //Length of the straight chanel
Number_Levels=2; // Number of levels; we are not using it yet
Number_channels=3; // Number of chanels; we are not using it yet
DilatationFactor=1+R/(Length_oblique*Cos(Angle));
CutOff=R*Tan(Angle)/2-Length_inlet;
dx = 0.2;   //mesh size

//---------------------
//Reference hexagon
//----------------------
Point(1)={0,Length_oblique*Sin(Angle)+Length_straight/2,0,dx};
Point(2)={-Length_oblique*Cos(Angle),Length_straight/2,0,dx};
Point(3)={-Length_oblique*Cos(Angle),-Length_straight/2,0,dx};
Point(4)={0,-Length_oblique*Sin(Angle)-Length_straight/2,0,dx};
Point(5)={+Length_oblique*Cos(Angle),-Length_straight/2,0,dx};
Point(6)={Length_oblique*Cos(Angle),Length_straight/2,0,dx};


//------------------
//Translated Hexagons
//-------------------

HexTranslation1=-DilatationFactor*(Length_oblique*Sin(Angle)+Length_straight/2)+CutOff;
Translate {0,HexTranslation1,0} {Point{1,2,3,4,5,6};}
Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,6};
Line(6)={6,1};

Physical Line(51) = {1,2,3,4,5,6};

Curve Loop(1)={1,2,3,4,5,6};


HexTranslationR=R+2*Length_oblique*Cos(Angle);
Hex2Linija[]=Translate {HexTranslationR,0,0} {Duplicata{Line{1,2,3,4,5,6};}};
Physical Line(52) = {Hex2Linija[]};
Curve Loop(2)=Hex2Linija[];

Hex3Linija[]=Translate {2*HexTranslationR,0,0} {Duplicata{Line{1,2,3,4,5,6};}};
Physical Line(53) = {Hex3Linija[]};
Curve Loop(3)=Hex3Linija[];

HexTranslation2=-(Length_oblique*Sin(Angle)+Length_straight+R*(1/Cos(Angle))-R/2*Tan(Angle));
Hex4Linija[]=Translate {HexTranslationR/2,HexTranslation2,0} {Duplicata{Line{1,2,3,4,5,6};}};
Physical Line(54) = {Hex4Linija[]};
Curve Loop(4)=Hex4Linija[];

Hex5Linija[]=Translate {3*HexTranslationR/2,HexTranslation2,0} {Duplicata{Line{1,2,3,4,5,6};}};
Physical Line(55) = {Hex5Linija[]};
Curve Loop(5)=Hex5Linija[];

Hex6Linija[]=Translate {5*HexTranslationR/2,HexTranslation2,0} {Duplicata{Line{1,2,3,4,5,6};}};
Physical Line(56) = {Hex6Linija[]};
Curve Loop(6)=Hex6Linija[];







//-------------------
//Outer boundaries
//-------------------

// Left side

//Defining reference points (ccw)
y0[] = Point{1};
y1[] = Point{2};
y2[] = Point{3};
y4[] = Point{4};
y42[] = Point{42};
verticaltranslation=R*(1/Cos(Angle))-R/2*Tan(Angle);

Point(112)={-R/2,y0[1]+verticaltranslation,0,dx};
Point(113)={y1[0]-R, y1[1]-R*Tan(Angle)+R*(1/Cos(Angle)), 0, dx};
Point(114)={y2[0]-R, y2[1]+R*Tan(Angle)-R*(1/Cos(Angle)), 0, dx};
Point(115)={-R/2,y4[1]-verticaltranslation,0,dx};
//Point(125)={y42[0]+R,-Tan(Angle)*HexTranslationR/2+y0[1]+R*(1/Cos(Angle)), 0, dx};

//Inlet Channels
y112[] = Point{112};
Point(111)={y112[0], y112[1]+Length_inlet, 0, dx};
Point(309)={y112[0]+R,y112[1]+Length_inlet,0,dx};
Point(308)={y112[0]+R,y112[1],0,dx};

horiztranslation=2*Length_oblique*Cos(Angle)+R;

Point(311)={y112[0]+horiztranslation,y112[1],0,dx};
Point(310)={y112[0]+horiztranslation,y112[1]+Length_inlet,0,dx};
Point(312)={y112[0]+horiztranslation+R,y112[1]+Length_inlet,0,dx};
Point(313)={y112[0]+horiztranslation+R,y112[1],0,dx};
Point(315)={y112[0]+2*horiztranslation,y112[1],0,dx};
Point(314)={y112[0]+2*horiztranslation,y112[1]+Length_inlet,0,dx};
Point(316)={y112[0]+2*horiztranslation+R,y112[1]+Length_inlet,0,dx};
Point(317)={y112[0]+2*horiztranslation+R,y112[1],0,dx};

//Addition
y96[]=Point{96};
y315[]=Point{315};
y79[]=Point{79};
y42[]=Point{42};
Point(401)={y315[0]+2*Length_oblique*Cos(Angle)+R, y315[1],0,dx};
Point(402)={y315[0]+2*Length_oblique*Cos(Angle)+R, y315[1]+Length_inlet, 0, dx};
Point(403)={y315[0]+2*Length_oblique*Cos(Angle)+2*R,y42[1]+Tan(Angle)*(Length_oblique*Cos(Angle)+R/2),0,dx};
Point(404)={y315[0]+2*Length_oblique*Cos(Angle)+2*R,y315[1]+Length_inlet,0,dx};
Point(405)={y79[0],-Tan(Angle)*HexTranslationR/2+y0[1]+R*(1/Cos(Angle)),0,dx};
Point(406)={y42[0]+R,y42[1],0,dx};


//Point(415)={y96[0]+R, y112[1]+Length_inlet, 0, dx};
//Point(414)={y96[0], y112[1]+Length_inlet, 0, dx};
//Line(414)={414, 415};
//Point(416)={y96[0],y1[1]-R*Tan(Angle)+R*(1/Cos(Angle))+Tan(Angle)*(Length_oblique*Cos(Angle)+R/2), 0, dx};
//Point(417)={y96[0]+R,y112[1], 0, dx};
//Point(417)={y96[0]+R,y1[1]-R/2*Tan(Angle)+Tan(Angle)*(Length_oblique*Cos(Angle)+R/2) , 0, dx};
//Line(416)={414, 416};
//Line(415)={415,417};
//Point(418)={y42[0]+R, y1[1]-R*Tan(Angle)+R*(1/Cos(Angle)), 0, dx};
//y418[]=Point{418};
//Point(416)={y96[0],y418[1]+Tan(Angle)*(Length_oblique*Cos(Angle)+R/2), 0, dx};
//Line(418)={416, 418};
//Point(419)={y42[0]+R,y1[1]-R/2*Tan(Angle),0, dx};

//UpperLinija1[]=Translate{HexTranslationR,0,dx} {Duplicata{Line{111};}};
//UpperLinija2[]=Translate{HexTranslationR+R,0,dx} {Duplicata{Line{111};}};
//UpperLinija3[]=Translate{2*HexTranslationR,0,dx} {Duplicata{Line{111};}};
//UpperLinija4[]=Translate{2*HexTranslationR+R,0,dx} {Duplicata{Line{111};}};

//Upper
Point(307)={HexTranslationR/2, -Tan(Angle)*HexTranslationR/2+y0[1]+R*(1/Cos(Angle)), 0, dx};
Point(302)={3*HexTranslationR/2, -Tan(Angle)*HexTranslationR/2+y0[1]+R*(1/Cos(Angle)), 0, dx};


//Right Side
y79[]= Point{79};
//y96[]=Point{96};
y92[]=Point{92};
Point(123)={y42[0]+R, y79[1]+verticaltranslation,0,dx};
Point(122)={y96[0]+R, -Tan(Angle)*(y96[0]+R)+y96[1]+Tan(Angle)*y96[0]+R*(1/Cos(Angle)), 0, dx};
Point(121)={y96[0]+R, Tan(Angle)*(y96[0]+R)+y92[1]-Tan(Angle)*y92[0]-R*(1/Cos(Angle)), 0, dx};

//Bottom
y84[] = Point{84};
y48[]=Point{48};
//Point(116)={-R/2, Tan(Angle)*(y96[0]+R)+y92[1]-Tan(Angle)*y92[0]-R*(1/Cos(Angle)), 0, dx};
Point(116)={-R/2, y48[1],0,dx};
Point(120)={y92[0]-Length_oblique*Cos(Angle)+R/2,Tan(Angle)*(y92[0]-Length_oblique*Cos(Angle)+R/2)+y92[1]-Tan(Angle)*y92[0]-R*(1/Cos(Angle)), 0, dx};
Point(207)={2*HexTranslationR,-Tan(Angle)*(2*HexTranslationR)+y84[1]+Tan(Angle)*y84[0]-R*(1/Cos(Angle)), 0, dx};
Point(202)={HexTranslationR,-Tan(Angle)*(2*HexTranslationR)+y84[1]+Tan(Angle)*y84[0]-R*(1/Cos(Angle)), 0, dx};


//Bottom Channels
ybottom[] = Point{120};
Point(119)={ybottom[0], ybottom[1]-Length_inlet, 0, dx};
Point(118)={ybottom[0]-R, ybottom[1]-Length_inlet, 0, dx};
Point(117)={ybottom[0]-R, ybottom[1], 0, dx};
Point(319)={ybottom[0]-horiztranslation,ybottom[1],0,dx};
Point(318)={ybottom[0]-horiztranslation,ybottom[1]-Length_inlet,0,dx};
Point(321)={ybottom[0]-horiztranslation-R,ybottom[1]-Length_inlet,0,dx};
Point(320)={ybottom[0]-horiztranslation-R,ybottom[1],0,dx};
Point(322)={ybottom[0]-2*horiztranslation,ybottom[1]-Length_inlet,0,dx};
Point(323)={ybottom[0]-2*horiztranslation,ybottom[1],0,dx};
Point(324)={ybottom[0]-2*horiztranslation-R,ybottom[1],0,dx};
Point(325)={ybottom[0]-2*horiztranslation-R,ybottom[1]-Length_inlet,0,dx};

//Addition
y325[]=Point{325};
y52[]=Point{52};
y202[]=Point{202};
y116[]=Point{116};
Point(407)={y325[0]-2*Length_oblique*Cos(Angle)-R, y116[1]-Tan(Angle)*(Length_oblique*Cos(Angle)+R/2),0,dx};
Point(408)={y325[0]-2*Length_oblique*Cos(Angle)-R,y325[1],0,dx};
Point(409)={y325[0]-2*Length_oblique*Cos(Angle),y325[1]+Length_inlet,0,dx};
Point(410)={y325[0]-2*Length_oblique*Cos(Angle),y325[1],0,dx};
Point(411)={y4[0],y202[1],0,dx};







//+
Point(412) = {-6.8, -14.1247, 0, 1.0};
//+
Point(413) = {-6.8, -17, 0, 1.0};
//+
Point(414) = {5.8, -17, -0, 1.0};
//+
Point(415) = {5.8, -21, -0, 1.0};
//+
Point(416) = {8.2, -21, -0, 1.0};
//+
Point(417) = {8.2, -17, -0, 1.0};
//+
Point(418) = {20, -17, -0, 1.0};
//+
Point(419) = {20, -21, -0, 1.0};
//+
Point(420) = {22.4, -21, -0, 1.0};
//+
Point(421) = {22.4, -17, -0, 1.0};
//+
Point(422) = {35.7, -17, -0, 1.0};
//+
Point(423) = {35.7, -14.1247, -0, 1.0};
//+
Point(424) = {35.7, 0.3, -0, 1.0};
//+
Point(425) = {35.7, 3.4, -0, 1.0};
//+
Point(426) = {-6.8, 3.4, -0, 1.0};
//+
Point(427) = {-6.8, 0.3, -0, 1.0};

//+
Point(428) = {-1.5, 3.4, 0, 1.0};
//+
Point(429) = {9.1, 3.4, 0, 1.0};
//+
Point(430) = {19.7, 3.4, 0, 1.0};
//+
Point(431) = {30.3, 3.4, 0, 1.0};
//+
Line(82) = {426, 428};
//+
Line(83) = {428, 429};
//+
Line(84) = {429, 430};
//+
Line(85) = {430, 431};
//+
Line(86) = {431, 425};
//+
Line(87) = {425, 424};
//+
Line(88) = {424, 423};
//+
Line(89) = {423, 422};
//+
Line(90) = {422, 421};
//+
Line(91) = {421, 420};
//+
Line(92) = {420, 419};
//+
Line(93) = {419, 418};
//+
Line(94) = {418, 417};
//+
Line(95) = {417, 416};
//+
Line(96) = {416, 415};
//+
Line(97) = {415, 414};
//+
Line(98) = {414, 413};
//+
Line(99) = {413, 412};
//+
Line(100) = {412, 427};
//+
Line(101) = {427, 426};
//+
Line(102) = {427, 111};
//+
Line(103) = {111, 112};
//+
Line(104) = {112, 113};
//+
Line(105) = {113, 114};
//+
Line(106) = {114, 115};
//+
Line(107) = {115, 116};
//+
Line(108) = {116, 407};
//+
Line(109) = {407, 408};
//+
Line(110) = {408, 412};
//+
Line(111) = {410, 409};
//+
Line(112) = {409, 411};
//+
Line(113) = {411, 324};
//+
Line(114) = {324, 325};
//+
Line(115) = {325, 410};
//+
Line(116) = {322, 323};
//+
Line(117) = {323, 202};
//+
Line(118) = {202, 320};
//+
Line(119) = {320, 321};
//+
Line(120) = {321, 322};
//+
Line(121) = {318, 319};
//+
Line(122) = {319, 207};
//+
Line(123) = {207, 117};
//+
Line(124) = {117, 118};
//+
Line(125) = {118, 318};
//+
Line(126) = {119, 120};
//+
Line(127) = {120, 121};
//+
Line(128) = {121, 122};
//+
Line(129) = {122, 123};
//+
Line(130) = {123, 406};
//+
Line(131) = {406, 403};
//+
Line(132) = {403, 404};
//+
Line(133) = {404, 424};
//+
Line(134) = {119, 423};
//+
Line(135) = {402, 401};
//+
Line(136) = {401, 405};
//+
Line(137) = {405, 317};
//+
Line(138) = {317, 316};
//+
Line(139) = {316, 402};
//+
Line(140) = {314, 315};
//+
Line(141) = {315, 302};
//+
Line(142) = {302, 313};
//+
Line(143) = {313, 312};
//+
Line(144) = {312, 314};
//+
Line(145) = {310, 311};
//+
Line(146) = {311, 307};
//+
Line(147) = {307, 308};
//+
Line(148) = {308, 309};
//+
Line(149) = {309, 310};
//+
Curve Loop(7) = {102, 103, 104, 105, 106, 107, 108, 109, 110, 100};
//+
Plane Surface(1) = {7};
//+
Plane Surface(2) = {1};
//+
Plane Surface(3) = {2};
//+
Plane Surface(4) = {3};
//+
Curve Loop(8) = {131, 132, 133, 88, -134, 126, 127, 128, 129, 130};
//+
Plane Surface(5) = {8};
//+
Plane Surface(6) = {6};
//+
Plane Surface(7) = {5};
//+
Plane Surface(8) = {4};
//+
Curve Loop(9) = {113, 114, 115, 111, 112};
//+
Plane Surface(9) = {9};
//+
Curve Loop(10) = {118, 119, 120, 116, 117};
//+
Plane Surface(10) = {10};
//+
Curve Loop(11) = {123, 124, 125, 121, 122};
//+
Plane Surface(11) = {11};
//+
Curve Loop(12) = {147, 148, 149, 145, 146};
//+
Plane Surface(12) = {12};
//+
Curve Loop(13) = {142, 143, 144, 140, 141};
//+
Plane Surface(13) = {13};
//+
Curve Loop(14) = {137, 138, 139, 135, 136};
//+
Plane Surface(14) = {14};
//+

//+
Curve Loop(15) = {82, 83, 84, 85, 86, 87, -133, -132, -131, -130, -129, -128, -127, -126, 134, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, -110, -109, -108, -107, -106, -105, -104, -103, -102, 101};
//+
Plane Surface(15) = {1, 2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 14, 15};
//+
Extrude {0, 0, 10} {
  Surface{15}; Surface{3}; Surface{13}; Surface{14}; Surface{5}; Surface{4}; Surface{6}; Surface{11}; Surface{7}; Surface{10}; Surface{8}; Surface{2}; Surface{9}; Surface{1}; Surface{12}; 
}
//+
Physical Volume("1", 1) = {1};
//+
Physical Volume("2", 2) = {15, 3, 4, 6, 5, 7, 8, 9, 10, 2, 11, 12, 14, 13};
//+
Physical Surface("5", 5) = {524, 468, 488, 508, 636, 532, 256, 460, 300, 480, 324, 500, 628, 476, 276, 496, 280, 516, 304, 620, 376, 316, 352, 312, 396, 288, 372, 292, 328, 268, 348, 264, 540, 260, 536, 296, 272, 320, 284, 308, 624, 340, 416, 364, 436, 388, 456, 384, 612, 360, 440, 336, 420, 548, 400, 408, 428, 448, 604, 544, 344, 332, 368, 356, 392, 380, 616, 632, 504, 484, 512, 608, 452, 444, 432, 464, 492, 424, 412, 472, 528, 404, 556, 552};
//+
Physical Surface("3", 3) = {656, 648};
//+
Physical Surface("12", 12) = {572, 588};
//+
Physical Surface("8", 8) = {660, 652, 644, 596, 580, 564, 560, 661, 600, 592, 584, 576, 568, 15, 640, 520};
//+
Physical Surface("6", 6) = {1092, 1, 5, 799, 1013, 2, 981, 8, 693, 3, 12, 1119, 4, 831, 922, 7, 6, 863, 890, 11, 949, 10, 1040, 9, 13, 14, 720, 747, 1091, 774};
