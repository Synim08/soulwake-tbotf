(() => {
  const hud=document.querySelector('#hud'), viewport=document.querySelector('.viewport');
  const health=document.querySelector('#health-control'), bag=document.querySelector('#bag'), details=document.querySelector('#bag-details');
  const message=document.querySelector('#demo-message');
  function fit(){hud.style.setProperty('--scale',viewport.clientWidth/1600);}
  new ResizeObserver(fit).observe(viewport);fit();
  function setHealth(value){
    const hp=Math.max(0,Math.min(38,Number(value)));
    health.value=hp;document.querySelector('#health-fill').style.width=`calc((100% - 4px) * ${hp/38})`;
    document.querySelector('#health-value').textContent=`${hp}/38`;document.querySelector('#health-output').textContent=`${hp}/38`;
    document.querySelector('.health').setAttribute('aria-valuenow',hp);
    const low=hp<=14;hud.classList.toggle('is-low',low);document.querySelector('#low-health').hidden=!low;
    document.querySelectorAll('[data-preset]').forEach(b=>b.setAttribute('aria-pressed','false'));
  }
  function setMana(value){document.querySelector('#mana-fill').style.width=`calc((100% - 4px) * ${value/22})`;document.querySelector('#mana-value').textContent=`${value}/22`;document.querySelector('.mana').setAttribute('aria-valuenow',value);}
  document.querySelectorAll('[data-preset]').forEach(b=>b.addEventListener('click',()=>{
    setHealth(b.dataset.preset==='normal'?38:14);setMana(b.dataset.preset==='normal'?22:12);
    const full=b.dataset.preset==='full';document.querySelector('#bag-value').textContent=full?'12/12':'6/12';bag.classList.toggle('is-full',full);
    b.setAttribute('aria-pressed','true');message.textContent='Estado visual actualizado. No afecta a una partida.';
  }));
  health.addEventListener('input',()=>setHealth(health.value));
  document.querySelector('#retreat-control').addEventListener('change',e=>{
    const blocked=e.target.value==='blocked', state=document.querySelector('#retreat');
    state.classList.toggle('blocked',blocked);state.querySelector('span').textContent=blocked?'Retirada bloqueada':'Retirada disponible';
  });
  function closeBag(){details.hidden=true;bag.setAttribute('aria-expanded','false');}
  bag.addEventListener('click',()=>{details.hidden=!details.hidden;bag.setAttribute('aria-expanded',String(!details.hidden));});
  function announce(text){message.textContent=text;}
  document.querySelector('#map').addEventListener('click',()=>announce('Acceso Mapa seleccionado. El mapa queda fuera de esta muestra de la HUD.'));
  document.querySelector('#menu').addEventListener('click',()=>{closeBag();announce('Acceso Menú seleccionado. Aquí se agruparían diario, personaje y ajustes.');});
  document.querySelector('#potion').addEventListener('click',()=>announce('Poción seleccionada. Esta muestra no consume objetos ni aplica curación.'));
  document.addEventListener('keydown',e=>{
    if(e.ctrlKey||e.altKey||e.metaKey||e.repeat||/INPUT|SELECT|TEXTAREA/.test(e.target.tagName))return;
    const key=e.key.toLowerCase();
    if(key==='escape'){if(!details.hidden)closeBag();else document.querySelector('#menu').click();return;}
    if(key==='m'){e.preventDefault();document.querySelector('#map').click();}
    if(key==='q'){e.preventDefault();document.querySelector('#potion').click();}
  });
  document.addEventListener('pointerdown',e=>{if(!bag.contains(e.target)&&!details.contains(e.target))closeBag();});
  setHealth(14);setMana(12);document.querySelector('[data-preset="low"]').setAttribute('aria-pressed','true');
})();
