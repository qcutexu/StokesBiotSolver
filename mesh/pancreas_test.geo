Merge "Feb20_one_chamber.step";
Coherence;
//+
SetFactory("OpenCASCADE");


//+
Translate {0, 0, -0.0075} {
  Duplicata { Volume{75}; }
}

//+
BooleanUnion{ Volume{74}; Delete; }{ Volume{76}; Delete; }
//+
BooleanUnion{ Volume{76}; Delete; }{ Volume{75}; Delete; }
//+
BooleanUnion{ Volume{74}; Delete; }{ Volume{30}; Volume{29}; Volume{22}; Volume{21}; Volume{8}; Volume{7}; Volume{6}; Volume{32}; Volume{31}; Volume{28}; Volume{23}; Volume{20}; Volume{9}; Volume{10}; Volume{11}; Volume{33}; Volume{27}; Volume{24}; Volume{19}; Volume{17}; Volume{35}; Volume{12}; Volume{13}; Volume{34}; Volume{26}; Volume{25}; Volume{18}; Volume{16}; Volume{15}; Volume{14}; Volume{36}; Volume{37}; Volume{38}; Volume{39}; Volume{40}; Volume{41}; Volume{42}; Volume{48}; Volume{47}; Volume{46}; Volume{45}; Volume{44}; Volume{43}; Volume{55}; Volume{56}; Volume{49}; Volume{50}; Volume{51}; Volume{52}; Volume{53}; Volume{65}; Volume{64}; Volume{54}; Volume{57}; Volume{63}; Volume{62}; Volume{61}; Volume{60}; Volume{59}; Volume{58}; Volume{72}; Volume{71}; Volume{70}; Volume{69}; Volume{68}; Volume{67}; Volume{66}; Delete; }
//+
BooleanUnion{ Volume{74}; Delete; }{ Volume{5}; Volume{4}; Volume{3}; Volume{1}; Volume{2}; Delete; }
//+
BooleanUnion{ Volume{74}; Delete; }{ Volume{73}; }
//+
BooleanDifference{ Volume{74}; Delete; }{ Volume{73}; }

