/* Escenario de muestra independiente. No contiene reglas, colisiones ni guardado. */
(() => {
  const c = document.querySelector('#pixel-world').getContext('2d');
  c.imageSmoothingEnabled = false;
  let seed = 416;
  const rnd = () => ((seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0) / 4294967296);
  const rect = (x,y,w,h,color) => { c.fillStyle=color;c.fillRect(x,y,w,h); };
  const poly = (points,color) => {
    c.fillStyle=color;c.beginPath();points.forEach(([x,y],i)=>i?c.lineTo(x,y):c.moveTo(x,y));c.closePath();c.fill();
  };
  const sprite = (rows,x,y,palette) => rows.forEach((row,j)=>[...row].forEach((p,i)=>{if(palette[p])rect(x+i,y+j,1,1,palette[p]);}));
  rect(0,0,400,225,'#325847');
  const ground=['#375e4b','#3b644e','#294b40','#416b51','#4a7154'];
  for(let i=0;i<8000;i++){
    const x=Math.floor(rnd()*400),y=Math.floor(rnd()*225);
    rect(x,y,1+Math.floor(rnd()*3),1,ground[Math.floor(rnd()*ground.length)]);
  }
  // Sendero plano, visto desde arriba, sin horizonte ni fuga de perspectiva.
  const path = [[0,136],[80,132],[116,141],[161,136],[191,129],[232,111],[275,106],[316,111],[349,101],[400,102],[400,130],[352,130],[316,141],[276,135],[236,137],[196,153],[160,162],[112,166],[80,157],[0,164]];
  poly(path,'#7e7954');
  const mask=c.getImageData(0,0,400,225);
  for(let i=0;i<6000;i++){
    const x=Math.floor(rnd()*400),y=Math.floor(rnd()*225),k=(y*400+x)*4;
    if(mask.data[k]===126&&mask.data[k+1]===121){
      rect(x,y,1+Math.floor(rnd()*3),1,['#8c835c','#aaa071','#6b6c4e','#79734f'][Math.floor(rnd()*4)]);
    }
  }
  // Ramal y claro de las ruinas.
  poly([[231,114],[237,83],[266,69],[297,80],[305,107],[288,124],[251,132]],'#6d7554');
  for(let i=0;i<350;i++)rect(236+Math.floor(rnd()*63),82+Math.floor(rnd()*41),2,1,'#788261');
  const stone=(x,y,w=8,h=5)=>{
    rect(x+1,y+h,w,2,'#223c35');rect(x,y,w,h,'#596e61');rect(x+1,y,w-2,1,'#8d9b7b');rect(x+w-2,y+2,2,h-2,'#465b51');
    rect(x+1,y+2,2,1,'#7d8d70');
  };
  // Agua, con reflejos de píxeles y borde de hierba.
  poly([[308,160],[330,148],[366,151],[400,139],[400,225],[314,225],[301,197]],'#213f45');
  poly([[317,166],[337,156],[366,158],[400,149],[400,225],[324,225],[310,195]],'#2b5960');
  for(let i=0;i<110;i++){
    const x=321+Math.floor(rnd()*79),y=162+Math.floor(rnd()*63);
    rect(x,y,2+Math.floor(rnd()*6),1,['#3a7275','#34676b','#548d86'][Math.floor(rnd()*3)]);
  }
  for(let i=0;i<13;i++)stone(302+Math.floor(rnd()*22),166+i*4,5,3);
  // Losas y columnas de un pequeño recinto de piedra.
  for(const [x,y] of [[246,91],[260,89],[275,94],[245,104],[260,104],[276,109],[253,119]]){
    stone(x,y,12,8);rect(x+2,y+2,7,4,'#738675');rect(x+6,y+2,1,3,'#556e61');
  }
  for(const [x,y] of [[231,74],[244,69],[259,68],[275,71],[290,77]]){
    stone(x,y+8,13,8);stone(x+1,y,11,8);rect(x+2,y,6,2,'#98a183');
    rect(x+2,y+10,4,2,'#537459');
  }
  for(const [x,y] of [[230,90],[289,94]]){
    stone(x-2,y+9,15,6);rect(x,y-8,10,19,'#5f776b');rect(x+2,y-8,3,17,'#92a089');
    stone(x-2,y-11,14,5);rect(x+7,y-4,2,12,'#425d55');
  }
  // Guardián dormido: figura pequeña de piedra, no ilustración de jefe.
  rect(322,105,19,5,'#243f37');stone(322,99,18,6);
  rect(326,79,11,20,'#566e65');rect(328,72,8,9,'#839383');
  rect(326,72,3,8,'#4d645c');rect(329,75,2,1,'#bdd0a2');rect(334,75,1,1,'#bdd0a2');
  rect(322,82,4,12,'#61786a');rect(337,81,4,13,'#435e56');
  rect(327,98,4,4,'#394f48');rect(334,98,4,4,'#394f48');
  rect(330,84,3,7,'#b4a16e');rect(331,85,1,4,'#597e71');
  // Árboles en capas de pequeñas masas escalonadas de píxeles.
  const tree=(x,y,t=0)=>{
    rect(x-11,y+9,24,4,'#233e34');rect(x-3,y-1,7,13,'#68573e');rect(x-2,y,2,11,'#9a8055');
    rect(x-6,y+10,5,2,'#514e37');rect(x+3,y+9,4,3,'#514e37');
    const dark=t?'#1c3d36':'#203f35', mid=t?'#2a5647':'#315b43', light=t?'#477559':'#507751';
    const rows=[[-7,-27,14,3],[-12,-24,24,4],[-16,-20,31,5],[-19,-15,37,7],[-17,-8,34,8],[-12,0,25,5],[-6,5,13,3]];
    rows.forEach(([dx,dy,w,h])=>rect(x+dx,y+dy,w,h,dark));
    [[-10,-23,17,5],[-14,-17,25,6],[-13,-10,26,7],[-6,-3,19,5],[8,-16,8,8]].forEach(([dx,dy,w,h])=>rect(x+dx,y+dy,w,h,mid));
    for(let i=0;i<22;i++){
      const dx=Math.floor(rnd()*24)-12,dy=Math.floor(rnd()*22)-22;
      rect(x+dx,y+dy,2+Math.floor(rnd()*4),2,light);
    }
    rect(x-6,y-22,6,1,'#819465');rect(x-13,y-12,3,1,'#6e895c');
  };
  const trees=[];
  for(let row=0;row<3;row++)for(let x=0;x<425;x+=26)trees.push([x+(row%2)*10,row*21+5, row%2]);
  for(const p of [[6,93],[28,100],[58,90],[92,90],[110,104],[148,87],[185,70],[207,83],[366,77],[393,90],[9,130],[40,124],[17,194],[49,199],[77,203],[110,213],[138,223],[170,214],[210,225],[246,213],[275,224],[387,215]])trees.push(p);
  trees.sort((a,b)=>a[1]-b[1]).forEach(p=>tree(...p));
  const bush=(x,y)=>{
    rect(x-5,y,12,5,'#244c3b');rect(x-3,y-3,8,7,'#42734d');rect(x,y-5,3,4,'#668a55');rect(x+4,y-1,3,3,'#7d955f');
  };
  for(const p of [[61,117],[91,175],[133,119],[150,177],[217,174],[282,154],[296,136],[349,144],[46,169],[191,190],[228,67]])bush(...p);
  for(const [x,y] of [[108,178],[118,183],[207,158],[215,162],[287,149],[71,112],[66,108],[357,139],[345,151]]){
    rect(x,y,1,4,'#648456');rect(x-1,y-1,3,1,'#e2d8ad');rect(x,y-2,1,3,'#e9e7c7');rect(x,y-1,1,1,'#bf9858');
  }
  for(const [x,y] of [[39,172],[42,176],[143,107]]){rect(x,y,1,3,'#dece9c');rect(x-2,y-1,4,2,'#b16c55');rect(x-1,y-1,1,1,'#f0cf9d');}
  for(const p of [[153,115],[171,164],[206,120],[270,147],[350,98],[100,173]])stone(...p);
  // Cofre lateral: objeto de escala semejante al personaje.
  rect(109,101,15,4,'#263e32');rect(109,92,14,10,'#5e4635');rect(110,92,12,4,'#ac8654');rect(111,93,10,1,'#d0ad6c');rect(110,97,12,4,'#89603e');rect(115,93,2,8,'#d0b877');rect(115,97,2,2,'#f3dda0');
  // Altar y cristal: luz formada por píxeles, sin desenfoque.
  stone(252,121,22,7);stone(255,117,16,6);rect(257,118,12,2,'#63877a');
  rect(252,113,22,1,'#3d7566');rect(249,110,3,1,'#68b29a');rect(275,108,4,1,'#68b29a');
  const gem=['.....a.....','....aba....','...abbca...','..abbbcca..','.abbbbccca.','abbbbbcccca','.abbbbccca.','..abbbcca..','...abbca...','....aba....','.....a.....'];
  sprite(gem,258,102,{a:'#bdf6d6',b:'#6edec0',c:'#2d8c85'});
  rect(263,98,1,2,'#edffe3');rect(264,117,1,2,'#e5e3ad');
  for(const [x,y] of [[250,104],[275,117],[257,95],[279,102],[248,120]]){rect(x,y,1,2,'#b8efd2');rect(x-1,y+1,3,1,'#7dcbb6');}
  // Caelan: sprite pequeño original de prueba, túnica clara y pelo oscuro.
  rect(173,151,18,3,'#29483a');
  sprite([
    '.....hhh........',
    '...hhhhhhhh.....',
    '..hhhhhhhhhh....',
    '.hhHHhHHhhhhh...',
    '..hHHHHHHhhhh...',
    '.hhHsshssshhh...',
    '..hssssssshh....',
    '...sssesess.....',
    '...sssssss......',
    '....sssss.......',
    '...bbssbb.......',
    '..sLccccLss.....',
    '..sLccccLss.....',
    '..sLccccLss.....',
    '..sLccccLss.....',
    '...LbbbbL.......',
    '...LccccL.......',
    '...LccccL.......',
    '....pppp........',
    '....pppp........',
    '....pppp........',
    '...dd..dd.......',
    '...dd..ddd......'
  ],174,129,{h:'#252822',H:'#4c3d2a',s:'#d8b47e',e:'#725d2e',b:'#765437',c:'#e1d6a7',L:'#a79b72',p:'#4d4e3c',d:'#343a31'});
})();
