[_tb_system_call storage=system/_AI.ks]

*randam_ai

[chara_hide_all  time="1000"  wait="true"  ]
[iscript]
var playerNum = parseInt(f.player);
var n = parseInt(f.gamemode);
var aliveArr = String(f.alive).split(",");
var baseW = [0, 12, 8, 8, 12, 10, 10, 12, 12, 8];
var calmArr = [0].concat(String(f.calm).split(",").map(parseFloat));
function getRole(i){ return parseInt(String(f.character).split(",")[i-1]); }
var cands = [];
for(var i = 1; i <= n; i++){
if(i === playerNum) continue;
if(aliveArr[i-1] === "0") continue;
cands.push(i);
}
var pinchId = -1;
var sorted = cands.slice().sort(function(a,b){ return calmArr[a] - calmArr[b]; });
if(sorted.length >= 2 && calmArr[sorted[1]] - calmArr[sorted[0]] >= 25){
pinchId = sorted[0];
}
var zeros = [];for(var i=0;i<n;i++)zeros.push("0");
var coPromote = (parseInt(f.turn) >= 6 && String(f.co) === zeros.join(","));
var totalW = 0;
var weights = [];
for(var j = 0; j < cands.length; j++){
var c = cands[j];
var mult = 1;
if(c === pinchId) mult = Math.max(mult, 3);
if(coPromote && getRole(c) <= 10) mult = Math.max(mult, 3);
weights.push(baseW[c] * mult);
totalW += baseW[c] * mult;
}
var r = Math.random() * totalW;
var cum = 0;
f.ai_actor = cands[cands.length - 1];
for(var k = 0; k < cands.length; k++){
cum += weights[k];
if(r < cum){ f.ai_actor = cands[k]; break; }
}
[endscript]

*command

[iscript]
var actor = parseInt(f.ai_actor);
var p = [0, 2, 0, 0, 2, 1, 1, 2, 2, 0][actor];
function getRole(i){ return parseInt(String(f.character).split(",")[i-1]); }
var role = getRole(actor);
var coUsed = String(f.co).indexOf("1") !== -1;
var sayUsed = parseInt(f.say_human) === 1;
// [疑う, かばう, 人間と言え, CO系, COを求める]
var weightTable = {
wolf: { 2:[5,2,15,2,10], 1:[5,2,10,2,8], 0:[6,4,7,1,10] },
mad:  { 2:[5,2,2,15,2],  1:[5,2,2,8,5],  0:[7,4,1,5,2]  },
seer: { 0:[5,2,7,15,7],  1:[5,2,3,15,8], 2:[5,2,3,15,8] },
vill: [5,2,10,0,15]
};
var w;
if(role <= 5)       w = weightTable.wolf[p];
else if(role === 9) w = weightTable.mad[p];
else if(role === 10) w = weightTable.seer[p];
else if(role >= 15) w = weightTable.vill;
var cmds = [];
cmds.push([1, w[0]]);
cmds.push([2, w[1]]);
if(!sayUsed)                        cmds.push([4, w[2]]);
if(!coUsed && (role <= 5 || role === 9)) cmds.push([6, w[3]]);
if(!coUsed && role === 10)          cmds.push([5, w[3]]);
if(!coUsed)                         cmds.push([3, w[4]]);
function pickCmd(cmds){
var total = 0;
for(var j=0;j<cmds.length;j++) total += cmds[j][1];
var r = Math.random()*total, cum = 0;
for(var k=0;k<cmds.length;k++){
cum += cmds[k][1];
if(r < cum) return cmds[k][0];
}
return cmds[cmds.length-1][0];
}
f.jump = pickCmd(cmds);
[endscript]

[jump  storage="doubt.ks"  target="*doubt_ai"  cond="f.jump==1"  ]
[jump  storage="cover.ks"  target="*cover_ai"  cond="f.jump==2"  ]
[jump  storage="CO.ks"  target="*pCO_start"  cond="f.jump==3"  ]
[jump  storage="say_human.ks"  target="*say_human"  cond="f.jump==4"  ]
[jump  storage="CO.ks"  target="*true_CO"  cond="f.jump==5"  ]
[jump  storage="CO.ks"  target="*fake_CO"  cond="f.jump==6"  ]
*nothing

[jump  storage="AI.ks"  target="*command"  ]
