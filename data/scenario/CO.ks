[_tb_system_call storage=system/_CO.ks]

*pCO_start

[jump  storage="CO.ks"  target="*pCO_lottery"  cond="f.ai_actor==0"  ]
[iscript]
f.name2 = parseInt(f.ai_actor);
f.ai_actor = 0;
[endscript]

[call  storage="mafutsu.ks"  target="*pCO"  cond="f.name2==1"  ]
[call  storage="sisigami.ks"  target="*pCO"  cond="f.name2==2"  ]
[call  storage="murasame.ks"  target="*pCO"  cond="f.name2==3"  ]
[call  storage="kano.ks"  target="*pCO"  cond="f.name2==4"  ]
[call  storage="tendo.ks"  target="*pCO"  cond="f.name2==5"  ]
[call  storage="shigure.ks"  target="*pCO"  cond="f.name2==6"  ]
[call  storage="yamabuki.ks"  target="*pCO"  cond="f.name2==7"  ]
[call  storage="gato.ks"  target="*pCO"  cond="f.name2==8"  ]
[call  storage="urushihara.ks"  target="*pCO"  cond="f.name2==9"  ]
[jump  storage="CO.ks"  target="*pCO_lottery"  cond="f.role>12"  ]
*pCO_choice_back

[glink  color="black"  storage="CO.ks"  size="20"  text="COする"  target="*pCO_player_co"  ]
[glink  color="black"  storage="CO.ks"  size="20"  text="COしない"  target="*pCO_lottery"  ]
[s  ]
*pCO_player_co

[jump  storage="CO.ks"  target="*true_CO"  cond="f.role==10"  ]
[jump  storage="CO.ks"  target="*player_fake_CO"  ]
*pCO_lottery

[iscript]
var n = parseInt(f.gamemode);
function getRole(i) { return parseInt(String(f.character).split(',')[i - 1]); }
function getCalm(i) { return parseFloat(String(f.calm).split(',')[i - 1]); }
function isAlive(c) { return String(f.alive).split(',')[c - 1] === '1'; }
function isAggressive(c) { return c === 1 || c === 4 || c === 7 || c === 8; }
function isPassive(c) { return c === 2 || c === 3 || c === 9; }
function isLowestCalm(c) {
var myCalm = getCalm(c);
for (var i = 1; i <= n; i++) {
if (i !== c && isAlive(i) && getCalm(i) < myCalm) return false;
}
return true;
}
var playerNum = parseInt(f.player);
var name2Num = parseInt(f.name2) || 0;
f.ai_actor = 0;
f.jump = 0;
// 役職順をシャッフル（狂人9→人狼<=5→占い師10）
var roleOrder = [9, 1, 10];
for (var i = roleOrder.length - 1; i > 0; i--) {
var j = Math.floor(Math.random() * (i + 1));
var tmp = roleOrder[i]; roleOrder[i] = roleOrder[j]; roleOrder[j] = tmp;
}
for (var r = 0; r < roleOrder.length; r++) {
var role = roleOrder[r];
for (var i = 1; i <= n; i++) {
if (!isAlive(i)) continue;
if (i === playerNum) continue;
if (i === name2Num) continue;
var charRole = getRole(i);
// 役職マッチング：人狼は<=5、狂人は9、占い師は10
if (role === 1 && charRole > 5) continue;
if (role === 9 && charRole !== 9) continue;
if (role === 10 && charRole !== 10) continue;
var prob = 0;
if (role === 9) {
if ((isPassive(i) || i === n) && isLowestCalm(i)) { prob = 0; }
else { prob = isPassive(i) ? 0.40 : (i === n) ? 0.60 : 0.80; }
} else if (role === 10) {
prob = isPassive(i) ? 0.40 : (i === n) ? 0.60 : 0.80;
} else if (role === 1) {
prob = isAggressive(i) ? 0.20 : 0.10;
}
if (prob > 0 && Math.random() < prob) {
f.ai_actor = i;
f.jump = (role === 10) ? 2 : 1;
break;
}
}
if (f.ai_actor > 0) break;
}
// フォールバック：name2がn（最後のキャラ）かつまだ誰も選ばれていない場合
if (f.ai_actor === 0 && name2Num === n) {
var rand = Math.random();
var forcedRole = rand < 0.40 ? 9 : rand < 0.50 ? 1 : 10;
var searchOrder = [forcedRole];
var allRoles = [1, 9, 10];
for (var k = 0; k < allRoles.length; k++) {
if (allRoles[k] !== forcedRole) searchOrder.push(allRoles[k]);
}
for (var s = 0; s < searchOrder.length; s++) {
if (f.ai_actor > 0) break;
for (var i = 1; i <= n; i++) {
if (!isAlive(i)) continue;
if (i === playerNum) continue;
if (i === name2Num) continue;
var charRole = getRole(i);
if (searchOrder[s] === 1 && charRole > 5) continue;
if (searchOrder[s] === 9 && charRole !== 9) continue;
if (searchOrder[s] === 10 && charRole !== 10) continue;
f.ai_actor = i;
f.jump = (searchOrder[s] === 10) ? 2 : 1;
break;
}
}
}
[endscript]

[jump  storage="CO.ks"  target="*pCO_end"  cond="f.ai_actor==0"  ]
[jump  storage="CO.ks"  target="*true_CO"  cond="f.jump==2"  ]
[jump  storage="CO.ks"  target="*fake_CO"  cond="f.jump==1"  ]
*pCO_end

[tb_start_text mode=1 ]
#システム
誰もCOしなかった…[p]
[_tb_end_text]

[jump  storage="end.ks"  target="*turn_set"  ]
*player_fake_CO

[tb_eval  exp="f.jump='CO'"  name="jump"  cmd="="  op="t"  val="CO"  val_2="undefined"  ]
[tb_eval  exp="f.ai_actor=0"  name="ai_actor"  cmd="="  op="t"  val="0"  val_2="undefined"  ]
[jump  storage="UI.ks"  target="*listA"  ]
*CO_back

[glink  color="black"  storage="CO.ks"  size="20"  text="人間"  target="*human"  ]
[glink  color="black"  storage="CO.ks"  size="20"  text="人狼"  target="*wolf"  ]
[s  ]
*human

[tb_eval  exp="f.result=0"  name="result"  cmd="="  op="t"  val="0"  val_2="undefined"  ]
[jump  storage="CO.ks"  target="*player_fake_CO_end"  ]
*wolf

[tb_eval  exp="f.result=1"  name="result"  cmd="="  op="t"  val="1"  val_2="undefined"  ]
*player_fake_CO_end

[jump  storage="night.ks"  target="*fake"  cond="f.name2=='fake'"  ]
[iscript]
var actorNum = parseInt(f.player);
var claim = String(f.claim).split(",");
var coArr = String(f.co).split(",");
var idx = (actorNum-1)*2;
claim[idx] = parseInt(f.target);
claim[idx+1] = parseInt(f.result);
coArr[actorNum-1] = "1";
f.claim = claim.join(",");
f.co = coArr.join(",");
[endscript]

[jump  storage="CO.ks"  target="*CO_jump"  ]
*fake_CO

[call  storage="uranai.ks"  target="*fake_CO"  ]
[jump  storage="CO.ks"  target="*CO_jump"  ]
*true_CO

[call  storage="uranai.ks"  target="*true_CO"  ]
*CO_jump

[iscript]
var n = parseInt(f.gamemode);
function gi(a,b){ var o=(a-1)*(n-1); var t=[]; for(var i=1;i<=n;i++){if(i!==a)t.push(i);} return o+t.indexOf(b); }
function si(a,b,val){ var arr=String(a).split(','); arr[b]=String(val); return arr.join(','); }
function addCalm(i,val){
var calmArr = String(f.calm).split(',');
calmArr[i-1] = String(parseFloat(calmArr[i-1]) + val);
f.calm = calmArr.join(',');
}
var actorNum = parseInt(f.ai_actor)>0 ? parseInt(f.ai_actor) : parseInt(f.player);
var idx = (actorNum-1)*2;
var claim = String(f.claim).split(",");
var target = parseInt(claim[idx]);
var result = parseInt(claim[idx+1]);
var lk = String(f.like).split(',');
// COしたキャラの平常心ダメージ
addCalm(actorNum, -10);
// 報告されたキャラの平常心：人狼報告-15、人間報告+15
addCalm(target, result===1 ? -15 : 15);
// 被報告者→報告者の好感度：人狼報告-20、人間報告+20
var targetToActor = gi(target, actorNum);
lk[targetToActor] = parseInt(lk[targetToActor]) + (result===1 ? -20 : 20);
f.like = lk.join(',');
f.name = ["","真経津","獅子神","村雨","叶","天堂","時雨","山吹","牙頭","漆原"][target];
f.name2 = result===1?"人狼":"人間";
[endscript]

[jump  storage="CO.ks"  target="*ai_jump"  cond="f.ai_actor!=0"  ]
[call  storage="mafutsu.ks"  target="*CO"  cond="f.player==1"  ]
[call  storage="sisigami.ks"  target="*CO"  cond="f.player==2"  ]
[call  storage="murasame.ks"  target="*CO"  cond="f.player==3"  ]
[call  storage="kano.ks"  target="*CO"  cond="f.player==4"  ]
[call  storage="tendo.ks"  target="*CO"  cond="f.player==5"  ]
[call  storage="shigure.ks"  target="*CO"  cond="f.player==6"  ]
[call  storage="yamabuki.ks"  target="*CO"  cond="f.player==7"  ]
[call  storage="gato.ks"  target="*CO"  cond="f.player==8"  ]
[call  storage="urushihara.ks"  target="*CO"  cond="f.player==9"  ]
[jump  storage="CO.ks"  target="*vsCO_ask"  ]
*ai_jump

[call  storage="mafutsu.ks"  target="*CO"  cond="f.ai_actor==1"  ]
[call  storage="sisigami.ks"  target="*CO"  cond="f.ai_actor==2"  ]
[call  storage="murasame.ks"  target="*CO"  cond="f.ai_actor==3"  ]
[call  storage="kano.ks"  target="*CO"  cond="f.ai_actor==4"  ]
[call  storage="tendo.ks"  target="*CO"  cond="f.ai_actor==5"  ]
[call  storage="shigure.ks"  target="*CO"  cond="f.ai_actor==6"  ]
[call  storage="yamabuki.ks"  target="*CO"  cond="f.ai_actor==7"  ]
[call  storage="gato.ks"  target="*CO"  cond="f.ai_actor==8"  ]
[call  storage="urushihara.ks"  target="*CO"  cond="f.ai_actor==9"  ]
[jump  storage="CO.ks"  target="*vsCO_ask"  ]
*vsCO_ask

[tb_eval  exp="f.role2='co'"  name="role2"  cmd="="  op="t"  val="co"  val_2="undefined"  ]
[jump  storage="CO.ks"  target="*AIvsCO"  cond="f.role>12"  ]
[iscript]
f.name2 = String(f.co).split(',')[parseInt(f.player)-1]==='1' ? 1 : 0;
[endscript]

[jump  storage="CO.ks"  target="*AIvsCO"  cond="f.name2==1"  ]
[jump  storage="CO.ks"  target="*AIvsCO"  cond="f.win=='no'"  ]
[call  storage="mafutsu.ks"  target="*vsCO"  cond="f.player==1"  ]
[call  storage="sisigami.ks"  target="*vsCO"  cond="f.player==2"  ]
[call  storage="murasame.ks"  target="*vsCO"  cond="f.player==3"  ]
[call  storage="kano.ks"  target="*vsCO"  cond="f.player==4"  ]
[call  storage="tendo.ks"  target="*vsCO"  cond="f.player==5"  ]
[call  storage="shigure.ks"  target="*vsCO"  cond="f.player==6"  ]
[call  storage="yamabuki.ks"  target="*vsCO"  cond="f.player==7"  ]
[call  storage="gato.ks"  target="*vsCO"  cond="f.player==8"  ]
[call  storage="urushihara.ks"  target="*vsCO"  cond="f.player==9"  ]
*vsCO_back

[glink  color="black"  storage="CO.ks"  size="20"  text="する"  target="*pCO_player_co"  ]
[glink  color="black"  storage="CO.ks"  size="20"  text="しない"  target="*vsCO_no"  ]
[s  ]
*vsCO_no

[tb_eval  exp="f.win='no'"  name="win"  cmd="="  op="t"  val="no"  val_2="undefined"  ]
[jump  storage="CO.ks"  target="*AIvsCO"  ]
*AIvsCO

[iscript]
var n = parseInt(f.gamemode);
function getRole(i) { return parseInt(String(f.character).split(',')[i - 1]); }
function getCalm(i) { return parseFloat(String(f.calm).split(',')[i - 1]); }
function isAlive(c) { return String(f.alive).split(',')[c - 1] === '1'; }
function isCO(c) { return String(f.co).split(',')[c - 1] === '1'; }
function isAggressive(c) { return c === 1 || c === 4 || c === 7 || c === 8; }
function isPassive(c) { return c === 2 || c === 3 || c === 9; }
function isLowestCalm(c) {
var myCalm = getCalm(c);
for (var i = 1; i <= n; i++) {
if (i !== c && isAlive(i) && getCalm(i) < myCalm) return false;
}
return true;
}
var playerNum = parseInt(f.player);
var name2Num = parseInt(f.name2) || 0;
var coCount = String(f.co).split(",").filter(function(c) { return c === "1"; }).length;
f.ai_actor = 0;
f.jump = 0;
var roleOrder = [9, 1, 10];
for (var i = roleOrder.length - 1; i > 0; i--) {
var j = Math.floor(Math.random() * (i + 1));
var tmp = roleOrder[i]; roleOrder[i] = roleOrder[j]; roleOrder[j] = tmp;
}
for (var r = 0; r < roleOrder.length; r++) {
var role = roleOrder[r];
for (var i = 1; i <= n; i++) {
if (!isAlive(i)) continue;
if (isCO(i)) continue;
if (i === playerNum) continue;
var charRole = getRole(i);
if (role === 1 && charRole > 5) continue;
if (role === 9 && charRole !== 9) continue;
if (role === 10 && charRole !== 10) continue;
var prob = 0;
if (role === 10) {
if (name2Num === n) { prob = 1.0; }
else { prob = isPassive(i) ? 0.75 : (i === n) ? 0.95 : 0.99; }
} else if (role === 9) {
if ((isPassive(i) || i === n) && isLowestCalm(i)) { prob = 0; }
else if (coCount === 1) { prob = isAggressive(i) ? 1.0 : (i === 2 || i === n) ? 0.80 : 0.50; }
else if (coCount === 2) { prob = isAggressive(i) ? 0.25 : 0.15; }
} else if (role === 1) {
prob = isAggressive(i) ? 0.25 : 0.15;
}
if (prob > 0 && Math.random() < prob) {
f.ai_actor = i;
f.jump = (role === 10) ? 0 : 1;
break;
}
}
if (f.ai_actor > 0) break;
}
if (f.ai_actor === 0 && coCount === 1) {
for (var i = 1; i <= n; i++) {
if (!isAlive(i)) continue;
if (isCO(i)) continue;
if (i === playerNum) continue;
var charRole = getRole(i);
if (charRole > 5) continue;
var fallbackProb = isAggressive(i) ? 0.90 : (i === n) ? 0.75 : 0.60;
if (Math.random() < fallbackProb) { f.ai_actor = i; f.jump = 1; }
break;
}
}
[endscript]

[jump  storage="CO.ks"  target="*end"  cond="f.ai_actor==0"  ]
[jump  storage="CO.ks"  target="*true_CO"  cond="f.jump==0"  ]
[jump  storage="CO.ks"  target="*fake_CO"  cond="f.jump==1"  ]
*end

[iscript]
var coCount = String(f.co).split(",").filter(function(c){return c==="1";}).length;
if(coCount >= 2) f.jump = "CO3";
[endscript]

[jump  storage="CO.ks"  target="*CO3"  cond="f.jump=='CO3'"  ]
*CO3_back

[call  storage="system.ks"  target="*liar"  ]
[jump  storage="end.ks"  target="*turn_set"  ]
*CO3

[iscript]
var n = parseInt(f.gamemode);
var coArr = String(f.co).split(",");
var cands = [];
for(var i = 1; i <= n; i++){
if(coArr[i-1] === "0") cands.push(i);
}
f.target = cands[Math.floor(Math.random() * cands.length)];
[endscript]

[call  storage="mafutsu.ks"  target="*CO3"  cond="f.target==1"  ]
[call  storage="sisigami.ks"  target="*CO3"  cond="f.target==2"  ]
[call  storage="murasame.ks"  target="*CO3"  cond="f.target==3"  ]
[call  storage="kano.ks"  target="*CO3"  cond="f.target==4"  ]
[call  storage="tendo.ks"  target="*CO3"  cond="f.target==5"  ]
[call  storage="shigure.ks"  target="*CO3"  cond="f.target==6"  ]
[call  storage="yamabuki.ks"  target="*CO3"  cond="f.target==7"  ]
[call  storage="gato.ks"  target="*CO3"  cond="f.target==8"  ]
[call  storage="urushihara.ks"  target="*CO3"  cond="f.target==9"  ]
[jump  storage="CO.ks"  target="*CO3_back"  ]
