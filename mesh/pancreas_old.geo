Merge "Feb20_one_chamber.step";
Coherence;
//+
SetFactory("OpenCASCADE");
//+
BooleanDifference{ Volume{73}; Delete; }{ Volume{65}; Volume{48}; Volume{35}; Volume{32}; Volume{72}; Volume{49}; Volume{36}; Volume{33}; Volume{30}; Volume{64}; Volume{47}; Volume{34}; Volume{71}; Volume{50}; Volume{31}; Volume{37}; Volume{27}; Volume{63}; Volume{29}; Volume{46}; Volume{26}; Volume{28}; Volume{70}; Volume{51}; Volume{38}; Volume{24}; Volume{22}; Volume{62}; Volume{45}; Volume{25}; Volume{23}; Volume{69}; Volume{52}; Volume{39}; Volume{19}; Volume{21}; Volume{61}; Volume{44}; Volume{18}; Volume{20}; Volume{68}; Volume{53}; Volume{40}; Volume{17}; Volume{8}; Volume{60}; Volume{9}; Volume{7}; Volume{16}; Volume{43}; Volume{12}; Volume{10}; Volume{41}; Volume{6}; Volume{15}; Volume{13}; Volume{11}; Volume{54}; Volume{55}; Volume{67}; Volume{42}; Volume{14}; Volume{57}; Volume{56}; Volume{66}; Volume{58}; Volume{59}; }

//+
BooleanUnion{ Volume{75}; Delete; }{ Volume{74}; Volume{4}; Volume{3}; Volume{5}; Volume{2}; Volume{1}; Volume{72}; Volume{71}; Volume{65}; Volume{70}; Volume{64}; Volume{69}; Volume{63}; Volume{49}; Volume{68}; Volume{62}; Volume{50}; Volume{48}; Volume{61}; Volume{67}; Volume{51}; Volume{66}; Volume{47}; Volume{60}; Volume{52}; Volume{46}; Volume{59}; Volume{36}; Volume{53}; Volume{45}; Volume{37}; Volume{58}; Volume{54}; Volume{35}; Volume{44}; Volume{38}; Volume{57}; Volume{34}; Volume{43}; Volume{39}; Volume{26}; Volume{55}; Volume{33}; Volume{40}; Volume{25}; Volume{56}; Volume{27}; Volume{41}; Volume{32}; Volume{18}; Volume{24}; Volume{31}; Volume{42}; Volume{16}; Volume{19}; Volume{28}; Volume{15}; Volume{30}; Volume{17}; Volume{23}; Volume{14}; Volume{29}; Volume{12}; Volume{20}; Volume{22}; Volume{13}; Volume{9}; Volume{21}; Volume{10}; Volume{8}; Volume{11}; Volume{7}; Volume{6}; Delete; }

//+
BooleanUnion{ Volume{74}; Delete; }{ Volume{73}; }
//+
BooleanDifference{ Volume{74}; Delete; }{ Volume{73}; }
//+
Translate {0, 0, -0.007} {
  Duplicata { Curve{1365}; }
}
//+
Extrude {0, 0.00095, 0} {
  Curve{1662}; Layers{5}; Recombine;
}
//+
Curve Loop(1189) = {1662};
//+
Plane Surface(716) = {1189};
//+
Curve Loop(1190) = {1664};
//+
Plane Surface(717) = {1190};
//+
Surface Loop(1) = {715, 717, 716};
//+
Volume(75) = {1};
//+
BooleanUnion{ Volume{74}; Delete;}{ Volume{75}; Delete; }
//+
Physical Volume("2", 2) = {73};
//+
Physical Volume("1", 1) = {74};
//+
Physical Surface("5", 5) = {528};
//+
Physical Surface("5", 5) += {542, 548, 561, 564, 582, 572, 578, 599, 590, 552, 543, 562, 565, 583, 573, 579, 598, 591, 553, 544, 563, 566, 584, 574, 603, 597, 592, 554, 545, 559, 567, 585, 575, 602, 596, 593, 555, 546, 558, 568, 586, 576, 601, 588, 594, 540, 547, 557, 569, 587, 577, 600, 589, 595, 541, 560, 556, 570, 538, 539, 580, 581, 537, 571, 549, 550, 551};
//+
Physical Surface("5", 5) += {526, 525, 524, 523, 527, 520, 518, 519, 521, 506, 501, 502, 510, 513, 515, 522, 517, 514, 512, 511, 516, 508, 507, 509, 503, 504, 505, 500, 499, 498, 497, 492, 493, 494, 489, 488, 484, 478, 483, 473, 465, 461, 466, 470, 474, 480, 471, 476, 485, 481, 462, 467, 472, 477, 490, 495, 491, 486, 496, 487, 482, 469, 464, 479, 475, 468, 463};
//+
Physical Surface("6", 6) = {531, 530, 529, 535, 534, 536, 533, 532, 460};
//+
//+
Physical Surface("12", 12) = {796, 795};
//+
Physical Surface("3", 3) = {828, 825, 826, 827};
//+
Physical Surface("8", 8) = {820, 819, 818, 817, 815, 813, 816, 814, 812, 824, 823, 822, 821, 809, 810, 811, 807, 808, 726, 721, 723, 717, 724, 725, 722, 718, 716, 720, 715, 719, 802, 804, 806, 797, 803, 805, 798, 799, 800, 801};
//+
Physical Surface("8", 8) += {728, 730, 733, 737, 744, 742, 741, 747, 731, 732, 729, 793, 736, 735, 734, 738, 743, 740, 739, 745, 794, 772, 767, 757, 768, 751, 766, 765, 764, 769, 774, 790, 791, 786, 787, 773, 792, 756, 759, 779, 778, 777, 780, 750, 758, 755, 754, 748, 781, 782, 785, 788, 784, 789, 770, 761, 762, 749, 783, 760, 753, 752, 775, 771, 763, 776, 746};
