[_tb_system_call storage=system/_debate.ks]

[cm  ]
[mask  time="300"  effect="fadeIn"  color="0x000000"  ]
[tb_show_message_window  ]
[chara_hide_all  time="0"  wait="true"  ]
[call  storage="UI.ks"  target="*myrole"  ]
[bg  time="0"  method="crossfade"  storage="93853245_p0.png"  ]
[mask_off  time="300"  effect="fadeOut"  ]
[call  storage="uranai.ks"  target="*uranai_randam"  ]
*debate_dialogue

[call  storage="mafutsu.ks"  target="*debate01"  cond="f.player==1"  ]
[call  storage="sisigami.ks"  target="*debate01"  cond="f.player==2"  ]
[call  storage="murasame.ks"  target="*debate01"  cond="f.player==3"  ]
[call  storage="kano.ks"  target="*debate01"  cond="f.player==4"  ]
[call  storage="tendo.ks"  target="*debate01"  cond="f.player==5"  ]
[jump  storage="end.ks"  target="*turn_count"  ]
*debate_top

[iscript]
var aliveArr = String(f.alive).split(",");
if(aliveArr[parseInt(f.player)-1] === "0") f.player_death = 1;
[endscript]

[jump  storage="debate.ks"  target="*auto"  cond="f.player_death==1"  ]
[glink  color="btn_08_red"  storage="debate.ks"  size="20"  text="疑う"  x="100"  y="50"  width="150"  height=""  _clickable_img=""  target="*doubt"  ]
[glink  color="btn_08_white"  storage="debate.ks"  size="20"  text="かばう"  x="100"  y="125"  width="150"  height=""  _clickable_img=""  target="*cover"  ]
[glink  color="btn_08_lime"  storage="debate.ks"  size="20"  text="様子を見る"  x="100"  y="200"  width="150"  height=""  _clickable_img=""  target="*watch"  ]
[jump  storage="debate.ks"  target="*s_human"  cond="f.say_human==1"  ]
[glink  color="btn_08_black"  storage="debate.ks"  size="20"  text="人間と言え"  x="300"  y="275"  width="150"  height=""  _clickable_img=""  target="*say_human"  ]
*s_human

[jump  storage="debate.ks"  target="*push_done"  cond="f.push==1"  ]
[glink  color="btn_08_yellow"  storage="debate.ks"  size="20"  text="強く疑う"  x="100"  y="275"  width="150"  height=""  _clickable_img=""  target="*push"  ]
*push_done

[iscript]
var coArr=String(f.co).split(",");
f.result=coArr.some(function(v){return v!=="0";})?1:0;
[endscript]

[jump  storage="debate.ks"  target="*liar"  cond="f.result==1"  ]
[glink  color="btn_08_purple"  storage="debate.ks"  size="20"  text="COを求める"  x="300"  y="200"  width="150"  height=""  _clickable_img=""  target="*plz_CO"  ]
[jump  storage="debate.ks"  target="*seer"  cond="f.role!=10"  ]
[glink  color="btn_08_blue"  storage="debate.ks"  size="20"  text="COする"  x="300"  y="50"  width="150"  height=""  _clickable_img=""  target="*CO"  ]
*seer

[jump  storage="debate.ks"  target="*liar"  cond="f.role>=10"  ]
[glink  color="btn_08_black"  storage="debate.ks"  size="20"  text="偽COする"  x="300"  y="125"  width="150"  height=""  _clickable_img=""  target="*fCO"  ]
*liar

[glink  color="btn_07_red"  storage="debate.ks"  size="20"  text="状況確認"  target="*check"  x="213"  y="369"  width=""  height=""  _clickable_img=""  ]
[s  ]
*doubt

[call  storage="system.ks"  target="*action"  ]
[jump  storage="mafutsu.ks"  target="*doubt"  cond="f.player==1"  ]
[jump  storage="sisigami.ks"  target="*doubt"  cond="f.player==2"  ]
[jump  storage="murasame.ks"  target="*doubt"  cond="f.player==3"  ]
[jump  storage="kano.ks"  target="*doubt"  cond="f.player==4"  ]
[jump  storage="tendo.ks"  target="*doubt"  cond="f.player==5"  ]
*cover

[call  storage="system.ks"  target="*action"  ]
[jump  storage="mafutsu.ks"  target="*cover"  cond="f.player==1"  ]
[jump  storage="sisigami.ks"  target="*cover"  cond="f.player==2"  ]
[jump  storage="murasame.ks"  target="*cover"  cond="f.player==3"  ]
[jump  storage="kano.ks"  target="*cover"  cond="f.player==4"  ]
[jump  storage="tendo.ks"  target="*cover"  cond="f.player==5"  ]
*watch

[call  storage="system.ks"  target="*quiet"  ]
[jump  storage="AI.ks"  target="*randam_ai"  ]
*push

[call  storage="system.ks"  target="*action"  ]
[tb_eval  exp="f.win='push'"  name="win"  cmd="="  op="t"  val="push"  val_2="undefined"  ]
[jump  storage="doubt.ks"  target="*doubt"  ]
*plz_CO

[call  storage="system.ks"  target="*action"  ]
[tb_eval  exp="f.ai_actor=0"  name="ai_actor"  cmd="="  op="t"  val="0"  ]
[call  storage="mafutsu.ks"  target="*pCO"  cond="f.player==1"  ]
[call  storage="sisigami.ks"  target="*pCO"  cond="f.player==2"  ]
[call  storage="murasame.ks"  target="*pCO"  cond="f.player==3"  ]
[call  storage="kano.ks"  target="*pCO"  cond="f.player==4"  ]
[call  storage="tendo.ks"  target="*pCO"  cond="f.player==5"  ]
[jump  storage="CO.ks"  target="*pCO_start"  ]
*CO

[call  storage="system.ks"  target="*action"  ]
[jump  storage="CO.ks"  target="*true_CO"  ]
*fCO

[tb_eval  exp="f.name2=0"  name="name2"  cmd="="  op="t"  val="0"  val_2="undefined"  ]
[call  storage="system.ks"  target="*action"  ]
[jump  storage="CO.ks"  target="*player_fake_CO"  ]
*say_human

[call  storage="system.ks"  target="*action"  ]
[tb_eval  exp="f.ai_actor=0"  name="ai_actor"  cmd="="  op="t"  val="0"  val_2="undefined"  ]
[jump  storage="say_human.ks"  target="*say_human"  ]
*auto

[glink  color="btn_08_lime"  storage="AI.ks"  size="20"  text="様子を見る"  x="100"  y="200"  width="150"  height=""  _clickable_img=""  target="*randam_ai"  ]
[s  ]
*check

[iscript]
f.display01="";
f.display02="";
f.display03="";
f.display04="";
f.display05="";
f.display06="";
f.display07="";
f.display08="";
f.display09="";
[endscript]

[iscript]
var names=["","真経津","獅子神","村雨","叶","天堂","時雨","山吹","牙頭","漆原"];
var n=parseInt(f.gamemode);
var aliveArr=String(f.alive).split(",");
var aliveNames=[];
for(var i=0;i<n;i++){
if(aliveArr[i]==="1")aliveNames.push(names[i+1]);
}
f.result=aliveNames.join("、");
[endscript]

[iscript]
var charNames=["","真経津","獅子神","村雨","叶","天堂","時雨","山吹","牙頭","漆原"];
var n=parseInt(f.gamemode);
var resultNames=["人間","人狼"];
var coArr=String(f.co).split(",");
var claim=String(f.claim).split(",");
var claim2=String(f.claim2).split(",");
var aliveArr=String(f.alive).split(",");
var disps=[];
for(var i=1;i<=n;i++){
if(coArr[i-1]==="0")continue;
var c1t=parseInt(claim[(i-1)*2]);
var c1r=parseInt(claim[(i-1)*2+1]);
if(c1t>0){
disps.push(charNames[i]+" → "+charNames[c1t]+"："+resultNames[c1r]+"、");
}
if(aliveArr[i-1]==="1"){
var c2t=parseInt(claim2[(i-1)*2]);
var c2r=parseInt(claim2[(i-1)*2+1]);
if(c2t>0){
disps.push(charNames[i]+" → "+charNames[c2t]+"："+resultNames[c2r]+"、");
}
}
}
f.display01=disps.length>0?disps[0]:"";
f.display02=disps.length>1?disps[1]:"";
f.display03=disps.length>2?disps[2]:"";
f.display04=disps.length>3?disps[3]:"";
f.display05=disps.length>4?disps[4]:"";
f.display06=disps.length>5?disps[5]:"";
f.display07=disps.length>6?disps[6]:"";
f.display08=disps.length>7?disps[7]:"";
f.display09=disps.length>8?disps[8]:"";
[endscript]

[tb_start_text mode=1 ]
#ガイド
残りの生存者は[emb exp="f.result"]です。[p]


[_tb_end_text]

[iscript]
var coArr2=String(f.co).split(",");
f.result=coArr2.some(function(v){return v!=="0";})?0:1;
[endscript]

[jump  storage="debate.ks"  target="*0CO"  cond="f.result==1"  ]
[tb_start_text mode=1 ]
占い師の報告は[emb exp="f.display01"][emb exp="f.display02"][emb exp="f.display03"][emb exp="f.display04"][emb exp="f.display05"][emb exp="f.display06"][emb exp="f.display07"][emb exp="f.display08"][emb exp="f.display09"]です。[p]

[_tb_end_text]

*0CO

[jump  storage="tutorial.ks"  target="*text"  cond="f.tutorial==1"  ]
[call  storage="mafutsu.ks"  target="*debate01"  cond="f.player==1"  ]
[call  storage="sisigami.ks"  target="*debate01"  cond="f.player==2"  ]
[call  storage="murasame.ks"  target="*debate01"  cond="f.player==3"  ]
[call  storage="kano.ks"  target="*debate01"  cond="f.player==4"  ]
[call  storage="tendo.ks"  target="*debate01"  cond="f.player==5"  ]
[jump  storage="debate.ks"  target="*debate_top"  ]
