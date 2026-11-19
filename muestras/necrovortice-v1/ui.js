(() => {
  const frame = document.querySelector('.frame');
  const stage = document.querySelector('#stage');
  const dialogue = document.querySelector('#dialogue');
  const panel = document.querySelector('#mini-panel');
  const backdrop = document.querySelector('#panel-backdrop');
  const reviewBar = document.querySelector('.review-bar');
  function setPanelBlocking(blocked) {
    backdrop.hidden = !blocked;
    [...stage.children].forEach(child => { if (child !== panel && child !== backdrop) child.inert = blocked; });
    reviewBar.inert = blocked;
  }
  const heading = document.querySelector('#panel-heading');
  const panelContent = document.querySelector('#panel-content');
  const explore = document.querySelector('#view-explore');
  const dialogueTab = document.querySelector('#view-dialogue');
  let activeView = 'explore';
  let panelTrigger = null;
  let activePanel = '';

  function fit() { stage.style.setProperty('--scale', frame.clientWidth / 1600); }
  new ResizeObserver(fit).observe(frame);
  fit();

  function closePanel() {
    panel.hidden = true;
    setPanelBlocking(false);
    activePanel = '';
    document.querySelectorAll('[data-panel]').forEach(b => b.setAttribute('aria-expanded', 'false'));
    if (panelTrigger) panelTrigger.focus({ preventScroll: true });
  }
  function setView(view) {
    closePanel();
    activeView = view;
    stage.classList.toggle('dialogue-view', view === 'dialogue');
    dialogue.hidden = view !== 'dialogue';
    explore.setAttribute('aria-pressed', String(view === 'explore'));
    dialogueTab.setAttribute('aria-pressed', String(view === 'dialogue'));
  }

  const panels = {
    map: {
      title: 'Mapa del sendero',
      html: `<p>El faro permanece apagado. Una resonancia llega desde el bosque.</p><svg class="mini-map" viewBox="0 0 430 140" role="img" aria-label="Ruta ilustrativa desde el refugio al fragmento"><path d="M60 70h100l50-35h70l90 35" fill="none"/><path d="M160 70l55 40h75" fill="none" stroke-dasharray="4 6"/><rect class="node" x="49" y="59" width="22" height="22" transform="rotate(45 60 70)"/><rect class="node" x="149" y="59" width="22" height="22" transform="rotate(45 160 70)"/><rect class="node current" x="359" y="59" width="22" height="22" transform="rotate(45 370 70)"/><text x="60" y="118" text-anchor="middle">Refugio</text><text x="160" y="28" text-anchor="middle">Sendero</text><text x="370" y="118" text-anchor="middle">Fragmento</text></svg><p class="setting-help">Composición de ejemplo para el mapa. Las rutas del prólogo aún están por concretar.</p>`
    },
    journal: {
      title: 'Diario de Caelan',
      html: `<p><strong>Una luz entre las raíces</strong></p><p>Hay algo en este sendero que me llama. Quiero descubrir de dónde viene esa luz.</p><p class="setting-help">Texto de muestra. Esta vista enseña cómo se vería un objetivo y su entrada de diario.</p>`
    },
    character: {
      title: 'Caelan',
      html: `<div class="character-row"><div class="character-thumb"><div class="portrait-art" role="img" aria-label="Retrato de Caelan"></div></div><div><h3>Caelan</h3><span>Curioso · Optimista</span><p>Vida 38 / 38<br>Maná 12 / 12</p></div></div><p>La montaña guarda una resonancia que todavía no comprende.</p><p class="setting-help">Identidad y atributos ilustrativos para revisar la presentación visual.</p>`
    },
    settings: {
      title: 'Ajustes de la muestra',
      html: `<label class="setting"><input id="effects" type="checkbox" ${document.body.classList.contains('no-effects') ? '' : 'checked'}> Energía y animación de interfaz</label><label class="setting">Brillo de los detalles <input id="glow" type="range" min="0" max="100" value="${Math.round(parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--glow')) * 100)}"><output class="setting-output" id="glow-output"></output></label><p class="setting-help">Estos controles afectan solo a esta muestra visual. No modifican el juego ni sus guardados.</p>`
    }
  };

  function showPanel(key, trigger) {
    if (activePanel === key && !panel.hidden) { closePanel(); return; }
    if (activeView !== 'explore') setView('explore');
    panelTrigger = trigger || document.querySelector(`[data-panel="${key}"]`);
    activePanel = key;
    heading.textContent = panels[key].title;
    panelContent.innerHTML = panels[key].html;
    panel.hidden = false;
    setPanelBlocking(true);
    document.querySelectorAll('[data-panel]').forEach(b => b.setAttribute('aria-expanded', String(b.dataset.panel === key)));
    document.querySelector('#close-panel').focus({ preventScroll: true });
    if (key === 'settings') {
      const effects = document.querySelector('#effects');
      effects.checked = !document.body.classList.contains('no-effects');
      effects.addEventListener('change', e => document.body.classList.toggle('no-effects', !e.target.checked));
      const range = document.querySelector('#glow');
      range.value = Math.round(parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--glow')) * 100);
      const output = document.querySelector('#glow-output');
      const update = () => {
        document.documentElement.style.setProperty('--glow', range.value / 100);
        output.textContent = `${range.value}%`;
      };
      range.addEventListener('input', update);
      update();
    }
  }

  document.querySelectorAll('[data-panel]').forEach(b => {
    b.setAttribute('aria-expanded', 'false');
    b.setAttribute('aria-controls', 'mini-panel');
    b.addEventListener('click', () => showPanel(b.dataset.panel, b));
  });
  backdrop.addEventListener('click', closePanel);
  document.querySelector('#close-panel').addEventListener('click', closePanel);
  document.querySelector('#return').addEventListener('click', closePanel);
  explore.addEventListener('click', () => setView('explore'));
  dialogueTab.addEventListener('click', () => setView('dialogue'));
  document.querySelector('#inspect').addEventListener('click', () => setView('dialogue'));
  document.querySelector('#continue').addEventListener('click', () => setView('explore'));
  document.querySelector('#quest-toggle').addEventListener('click', e => {
    const button = e.currentTarget;
    const expanded = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', String(!expanded));
    document.querySelector('#quest-body').hidden = expanded;
    button.querySelector('b').textContent = expanded ? '+' : '−';
  });

  document.addEventListener('keydown', e => {
    if (e.altKey || e.ctrlKey || e.metaKey || e.repeat) return;
    if (e.key === 'Escape') {
      if (!panel.hidden) closePanel();
      else if (activeView === 'dialogue') setView('explore');
      return;
    }
    if (!panel.hidden) {
      if (e.key === 'Tab') {
        const focusable = [...panel.querySelectorAll('button,input,[tabindex="0"]')];
        const first = focusable[0], last = focusable.at(-1);
        if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
        else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
      }
      return;
    }
    if (/INPUT|TEXTAREA|SELECT/.test(e.target.tagName)) return;
    const key = e.key.toLowerCase();
    if (key === 'e') { e.preventDefault(); setView(activeView === 'dialogue' ? 'explore' : 'dialogue'); }
    const shortcuts = { m: 'map', j: 'journal', c: 'character', o: 'settings' };
    if (shortcuts[key]) { e.preventDefault(); showPanel(shortcuts[key]); }
  });
})();
