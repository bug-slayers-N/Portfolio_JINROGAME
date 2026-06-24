[_tb_system_call storage=system/_vote.ks]

*player_vote

[jump  storage="vote.ks"  target="*player_vote_end"  cond="f.player_death==1"  ]
[chara_hide_all  time="300"  wait="true"  ]
[tb_hide_message_window  ]
[tb_eval  exp="f.jump='vote'"  name="jump"  cmd="="  op="t"  val="vote"  val_2="undefined"  ]
[jump  storage="UI.ks"  target="*listB"  ]
*player_vote_back

[call  storage="UI.ks"  target="*name_change"  ]
[tb_show_message_window  ]
[bg  time="1000"  method="crossfade"  storage="92690259_p0.png"  ]
[tb_start_text mode=1 ]
#システム
[emb exp="f.name"]に投票しました。[p]
[_tb_end_text]

*player_vote_end

[mask_off  time="1000"  effect="fadeOut"  ]
[jump  storage="vote.ks"  target="*like_boost"  cond="f.revote==1"  ]
*vote_ai

[iscript]
var aliveArr=String(f.alive).split(",");
var n=parseInt(f.gamemode);
var vt=[];
for(var i=0;i<n;i++){if(aliveArr[i]==="1")vt.push(i+1);}
f.vote_target=vt.join(",");
var zeros=[];for(var i=0;i<n;i++)zeros.push("0");
f.votes=zeros.join(",");
[endscript]

*like_boost

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,val){var arr=String(a).split(',');arr[b]=String(val);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
var n=parseInt(f.gamemode);
if(isAlive(1)){
for(var i=2;i<=n;i++){f.like=si(f.like,gi(i,1),getEl(f.like,gi(i,1))+20);}
}
[endscript]

*ai_wolf

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,v){var arr=String(a).split(',');arr[b]=String(v);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function hasCO(i){return parseInt(String(f.co).split(',')[i-1])===1;}
function getRole(i){return parseInt(String(f.character).split(",")[i-1]);}
function getCalm(i){return parseFloat(String(f.calm).split(",")[i-1]);}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
function getLiar(a,b){return getEl(f.liar,gi(a,b));}
function getPC(a,b){return getCalm(b)+getEl(f.like,gi(a,b));}
function getClaim1(i){var b=(i-1)*2;return{target:getEl(f.claim,b),result:getEl(f.claim,b+1)};}
function getClaim2(i){var b=(i-1)*2;return{target:getEl(f.claim2,b),result:getEl(f.claim2,b+1)};}
function getVotable(a){
var vt=String(f.vote_target).split(",");
var t=[];
for(var i=0;i<vt.length;i++){var c=parseInt(vt[i]);if(c!==a)t.push(c);}
return t;
}
function pickLowest(a,arr){var best=-1,bc=999999;for(var i=0;i<arr.length;i++){var c=arr[i],pc=getPC(a,c);if(pc<bc||(pc===bc&&c<best)){bc=pc;best=c;}}return best;}
function pickHighest(a,arr){var best=-1,bc=-999999;for(var i=0;i<arr.length;i++){var c=arr[i],pc=getPC(a,c);if(pc>bc||(pc===bc&&c<best)){bc=pc;best=c;}}return best;}
var pn=parseInt(f.player);
var n=parseInt(f.gamemode);
for(var actor=1;actor<=n;actor++){
if(actor===pn||!isAlive(actor)||getRole(actor)>5)continue;
var votable=getVotable(actor),target=-1;
for(var i=0;i<votable.length;i++){
var t=votable[i];
var ok=true;
for(var v=1;v<=n;v++){if(isAlive(v)&&v!==t&&v!==actor&&getLiar(v,t)!==1){ok=false;break;}}
if(ok){target=t;break;}
}
if(target===-1){
var acc=[];
for(var i=0;i<votable.length;i++){
var t=votable[i];
if(!hasCO(t))continue;
var c1=getClaim1(t),c2=getClaim2(t);
if((c1.target===actor&&c1.result===1)||(c2.target===actor&&c2.result===1))acc.push(t);
}
if(acc.length>0)target=pickHighest(actor,acc);
}
if(target===-1&&hasCO(actor)){
var opp=[];
for(var i=0;i<votable.length;i++){if(hasCO(votable[i]))opp.push(votable[i]);}
if(opp.length>0)target=pickLowest(actor,opp);
}
if(target===-1)target=pickLowest(actor,votable);
f.votes=si(f.votes,actor-1,target);
}
[endscript]

*ai_mad

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,v){var arr=String(a).split(',');arr[b]=String(v);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function hasCO(i){return parseInt(String(f.co).split(',')[i-1])===1;}
function getRole(i){return parseInt(String(f.character).split(",")[i-1]);}
function getCalm(i){return parseFloat(String(f.calm).split(",")[i-1]);}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
function getLiar(a,b){return getEl(f.liar,gi(a,b));}
function getPC(a,b){return getCalm(b)+getEl(f.like,gi(a,b));}
function getVotable(a){
var vt=String(f.vote_target).split(",");
var t=[];
for(var i=0;i<vt.length;i++){var c=parseInt(vt[i]);if(c!==a)t.push(c);}
return t;
}
function pickLowest(a,arr){var best=-1,bc=999999;for(var i=0;i<arr.length;i++){var c=arr[i],pc=getPC(a,c);if(pc<bc||(pc===bc&&c<best)){bc=pc;best=c;}}return best;}
var pn=parseInt(f.player);
var n=parseInt(f.gamemode);
for(var actor=1;actor<=n;actor++){
if(actor===pn||!isAlive(actor)||getRole(actor)!==9)continue;
var votable=getVotable(actor),target=-1;
if(hasCO(actor)){
var opp=[];
for(var i=0;i<votable.length;i++){if(hasCO(votable[i]))opp.push(votable[i]);}
if(opp.length>0)target=pickLowest(actor,opp);
}
if(target===-1){
var pool=[];
for(var i=0;i<votable.length;i++){if(getLiar(actor,votable[i])!==1)pool.push(votable[i]);}
if(pool.length===0)pool=votable;
target=pickLowest(actor,pool);
}
f.votes=si(f.votes,actor-1,target);
}
[endscript]

*ai_seer

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,v){var arr=String(a).split(',');arr[b]=String(v);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function getRole(i){return parseInt(String(f.character).split(",")[i-1]);}
function getCalm(i){return parseFloat(String(f.calm).split(",")[i-1]);}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
function getLiar(a,b){return getEl(f.liar,gi(a,b));}
function getPC(a,b){return getCalm(b)+getEl(f.like,gi(a,b));}
function getVotable(a){
var vt=String(f.vote_target).split(",");
var t=[];
for(var i=0;i<vt.length;i++){var c=parseInt(vt[i]);if(c!==a)t.push(c);}
return t;
}
function pickLowest(a,arr){var best=-1,bc=999999;for(var i=0;i<arr.length;i++){var c=arr[i],pc=getPC(a,c);if(pc<bc||(pc===bc&&c<best)){bc=pc;best=c;}}return best;}
var pn=parseInt(f.player);
var n=parseInt(f.gamemode);
for(var actor=1;actor<=n;actor++){
if(actor===pn||!isAlive(actor)||getRole(actor)!==10)continue;
var votable=getVotable(actor),target=-1;
var wolves=[];
for(var i=0;i<votable.length;i++){if(getLiar(actor,votable[i])===3)wolves.push(votable[i]);}
if(wolves.length>0)target=pickLowest(actor,wolves);
var liars=[];
for(var i=0;i<votable.length;i++){if(getLiar(actor,votable[i])===1)liars.push(votable[i]);}
if(target===-1&&liars.length>0)target=pickLowest(actor,liars);
if(target===-1)target=pickLowest(actor,votable);
f.votes=si(f.votes,actor-1,target);
}
[endscript]

*ai_vill

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,v){var arr=String(a).split(',');arr[b]=String(v);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function getRole(i){return parseInt(String(f.character).split(",")[i-1]);}
function getCalm(i){return parseFloat(String(f.calm).split(",")[i-1]);}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
function getLiar(a,b){return getEl(f.liar,gi(a,b));}
function getPC(a,b){return getCalm(b)+getEl(f.like,gi(a,b));}
function getVotable(a){
var vt=String(f.vote_target).split(",");
var t=[];
for(var i=0;i<vt.length;i++){var c=parseInt(vt[i]);if(c!==a)t.push(c);}
return t;
}
function pickLowest(a,arr){var best=-1,bc=999999;for(var i=0;i<arr.length;i++){var c=arr[i],pc=getPC(a,c);if(pc<bc||(pc===bc&&c<best)){bc=pc;best=c;}}return best;}
var pn=parseInt(f.player);
var n=parseInt(f.gamemode);
for(var actor=1;actor<=n;actor++){
if(actor===pn||!isAlive(actor)||getRole(actor)<15)continue;
var votable=getVotable(actor),target=-1;
var wolves=[];
for(var i=0;i<votable.length;i++){if(getLiar(actor,votable[i])===3)wolves.push(votable[i]);}
if(wolves.length>0)target=pickLowest(actor,wolves);
var liars=[];
for(var i=0;i<votable.length;i++){if(getLiar(actor,votable[i])===1)liars.push(votable[i]);}
if(target===-1&&liars.length>0)target=pickLowest(actor,liars);
if(target===-1)target=pickLowest(actor,votable);
f.votes=si(f.votes,actor-1,target);
}
[endscript]

*ai_calc

[iscript]
var pn=parseInt(f.player);
var n=parseInt(f.gamemode);
var aliveArr=String(f.alive).split(",");
var votes=String(f.votes).split(",");
votes[pn-1]=parseInt(f.target);
var count=[];for(var i=0;i<n;i++)count.push(0);
for(var i=0;i<n;i++){var v=parseInt(votes[i]);if(v>=1&&v<=n)count[v-1]++;}
var maxVote=0;
for(var i=0;i<n;i++){if(count[i]>maxVote)maxVote=count[i];}
var top=[];
for(var i=0;i<n;i++){if(aliveArr[i]==="0")continue;if(count[i]===maxVote)top.push(i+1);}
if(top.length===1){
f.result=top[0];
f.revote=0;
}else if(parseInt(f.revote)===1){
f.result=0;
f.revote=2;
}else{
f.result=0;
f.vote_target=top.join(",");
f.revote=1;
}
f.votes=votes.join(",");
[endscript]

[iscript]
function getEl(a,b){return parseInt(String(a).split(',')[b],10);}
function si(a,b,val){var arr=String(a).split(',');arr[b]=String(val);return arr.join(',');}
function isAlive(i){return parseInt(String(f.alive).split(',')[i-1])===1;}
function gi(a,b){var n=parseInt(f.gamemode);var o=(a-1)*(n-1);var t=[];for(var i=1;i<=n;i++){if(i!==a)t.push(i);}return o+t.indexOf(b);}
var n=parseInt(f.gamemode);
if(isAlive(1)){
for(var i=2;i<=n;i++){f.like=si(f.like,gi(i,1),getEl(f.like,gi(i,1))-20);}
}
[endscript]

*text

[tb_ptext_hide  time="0"  ]
[tb_start_text mode=1 ]
投票結果が集計されました。[p]
[_tb_end_text]

[iscript]
var names=["","真経津","獅子神","村雨","叶","天堂","時雨","山吹","牙頭","漆原"];
var votes=String(f.votes).split(",");
var aliveArr=String(f.alive).split(",");
var n=parseInt(f.gamemode);
var lines=[];
for(var i=0;i<n;i++){
if(aliveArr[i]==="0")continue;
var v=parseInt(votes[i]);
if(v>=1&&v<=n)lines.push(names[i+1]+"→"+names[v]);
}
f.display01="";f.display02="";f.display03="";f.display04="";f.display05="";
f.display06="";f.display07="";f.display08="";f.display09="";
f.display01=lines[0]||"";
f.display02=lines[1]||"";
f.display03=lines[2]||"";
f.display04=lines[3]||"";
f.display05=lines[4]||"";
f.display06=lines[5]||"";
f.display07=lines[6]||"";
f.display08=lines[7]||"";
f.display09=lines[8]||"";
[endscript]

[tb_start_text mode=1 ]
[emb exp="f.display01"]  [emb exp="f.display02"]  [emb exp="f.display03"]  [emb exp="f.display04"]  [emb exp="f.display05"] [emb exp="f.display05"] [emb exp="f.display06"] [emb exp="f.display07"] [emb exp="f.display08"] [emb exp="f.display09"][p]
[_tb_end_text]

[jump  storage="vote.ks"  target="*reset"  cond="f.revote==1"  ]
[jump  storage="vote.ks"  target="*no_kill"  cond="f.revote==2"  ]
[iscript]
var names=["","真経津","獅子神","村雨","叶","天堂","時雨","山吹","牙頭","漆原"];
f.name=names[parseInt(f.result)];
[endscript]

[tb_start_text mode=1 ]
投票の結果、[emb exp="f.name"]の処刑が決まりました。[p]
[_tb_end_text]

[tb_eval  exp="f.jump='vote'"  name="jump"  cmd="="  op="t"  val="vote"  val_2="undefined"  ]
[jump  storage="mafutsu.ks"  target="*death"  cond="f.result==1"  ]
[jump  storage="sisigami.ks"  target="*death"  cond="f.result==2"  ]
[jump  storage="murasame.ks"  target="*death"  cond="f.result==3"  ]
[jump  storage="kano.ks"  target="*death"  cond="f.result==4"  ]
[jump  storage="tendo.ks"  target="*death"  cond="f.result==5"  ]
*reset

[tb_start_text mode=1 ]
#システム
同票だったので、再投票します。(AIは同票キャラにしか投票しなくなります)[p]
[_tb_end_text]

[jump  storage="vote.ks"  target="*vote_ai"  cond="f.player_death==1"  ]
[jump  storage="vote.ks"  target="*player_vote"  ]
*no_kill

[tb_start_text mode=1 ]
#システム
再び同票だったので処刑無しで進みます。[p]
[_tb_end_text]

[jump  storage="night.ks"  target="*night"  ]
