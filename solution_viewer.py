import argparse
import json
import re
from pathlib import Path

def parse_objects(problem_text):
    objects = {}
    pattern = re.compile(r"\(:objects(.*?)\)", re.S)
    match = pattern.search(problem_text)
    if not match:
        return objects
    block = match.group(1)
    lines = []
    for line in block.splitlines():
        line = line.split(";", 1)[0]
        if line.strip():
            lines.append(line)
    tokens = []
    for line in lines:
        tokens.extend(line.strip().split())
    buffer = []
    current_type = None
    idx = 0
    while idx < len(tokens):
        tok = tokens[idx]
        if tok == "-":
            if buffer:
                current_type = tokens[idx + 1]
                for name in buffer:
                    objects[name] = current_type
                buffer = []
                idx += 2
                continue
        else:
            buffer.append(tok)
        idx += 1
    for name in buffer:
        objects[name] = current_type or "object"
    return objects

def parse_initial_state(problem_text, objects):
    init_pattern = re.compile(r"\(:init(.*?)\)\s*\(:goal", re.S)
    match = init_pattern.search(problem_text)
    initial_state = {
        name: {
            "type": obj_type,
            "location": None,
            "container": None,
            "attachedTo": None,
            "status": "",
            "checked": False,
        }
        for name, obj_type in objects.items()
    }
    if not match:
        return initial_state
    block = match.group(1)
    for raw_line in block.splitlines():
        line = raw_line.split(";", 1)[0].strip()
        if not line:
            continue
        fact = line.strip("()")
        parts = fact.split()
        if len(parts) < 3:
            continue
        pred, subject, target = parts[0], parts[1], parts[2]
        if pred == "esta-en" and subject in initial_state:
            initial_state[subject]["location"] = target
        elif pred == "enganchado" and subject in initial_state:
            initial_state[subject]["attachedTo"] = target
        elif pred == "sospechoso" and subject in initial_state:
            initial_state[subject]["status"] = "sospechoso"
        elif pred == "normal" and subject in initial_state:
            initial_state[subject]["status"] = "normal"
    return initial_state

def parse_plan(plan_text):
    actions = []
    for line in plan_text.splitlines():
        step_match = re.match(r"\s*(\d+):\s*\(([^\)]+)\)", line)
        if not step_match:
            continue
        idx = int(step_match.group(1))
        raw_action = step_match.group(2).strip()
        parts = raw_action.lower().split()
        actions.append({"index": idx, "name": parts[0], "args": parts[1:], "raw": raw_action})
    return actions

def build_payload(plan_path, problem_path):
    plan_text = Path(plan_path).read_text(encoding="utf-8")
    problem_text = Path(problem_path).read_text(encoding="utf-8")
    objects = parse_objects(problem_text)
    initial_state = parse_initial_state(problem_text, objects)
    actions = parse_plan(plan_text)
    return {
        "planFile": str(plan_path),
        "problemFile": str(problem_path),
        "objects": objects,
        "initialState": initial_state,
        "actions": actions,
    }

def render_html(payload, output_path):
    template = r"""<!DOCTYPE html>
<html lang=\"es\">
<head>
<meta charset=\"UTF-8\" />
<title>Visor de planes del aeropuerto</title>
<style>
body {
  font-family: 'Segoe UI', sans-serif;
  background: #f7f8fb;
  color: #222;
  margin: 0;
  padding: 0;
}
header {
  background: linear-gradient(120deg, #243c64, #1d2e4f);
  color: white;
  padding: 16px 24px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.15);
}
main {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 16px;
  padding: 16px;
}
svg {
  width: 100%;
  height: 520px;
  background: #fff;
  border: 1px solid #d6d9e1;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}
.node {
  fill: #e8edf6;
  stroke: #243c64;
  stroke-width: 2;
}
.node-label {
  font-size: 12px;
  fill: #1b2738;
  font-weight: 600;
}
.connector {
  stroke: #b4bfd3;
  stroke-width: 3;
}
#panel {
  background: #fff;
  border: 1px solid #d6d9e1;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.controls button {
  background: #243c64;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 8px 12px;
  cursor: pointer;
}
.controls button:disabled {
  background: #a7b4c9;
  cursor: not-allowed;
}
.action-log {
  max-height: 360px;
  overflow-y: auto;
  border: 1px solid #e0e4ec;
  border-radius: 6px;
}
.action-log ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.action-log li {
  padding: 8px 10px;
  border-bottom: 1px solid #eef1f6;
}
.action-log li.active {
  background: #e9f2ff;
  border-left: 4px solid #4a90e2;
}
.badge {
  display: inline-block;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 11px;
  margin-right: 6px;
  font-weight: 700;
}
.badge.machine { background: #f6c34433; color: #b58100; }
.badge.vagon { background: #71c4e833; color: #1c7395; }
.badge.equipaje { background: #67d49a33; color: #2b8c5c; }
.badge.suspicious { background: #f17d7d33; color: #b12222; }
.legend { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
.legend span { font-size: 12px; }
.entity-label {
  font-size: 10px;
  fill: #1b2738;
  font-weight: 700;
}
.connection-line { stroke: #8ea1c7; stroke-dasharray: 5 3; stroke-width: 2; }
.machine-body { fill: #f6c344; stroke: #243c64; stroke-width: 2; }
.machine-cabin { fill: #ffe08a; stroke: #243c64; stroke-width: 1.5; }
.wagon-body { fill: #71c4e8; stroke: #1b2738; stroke-width: 2; }
.wagon-top { fill: #9dd8f3; stroke: #1b2738; stroke-width: 1.5; }
.wheel { fill: #1b2738; }
.bag { stroke: #1b2738; stroke-width: 1.5; }
.bag.normal .bag-body { fill: #67d49a; }
.bag.suspicious .bag-body { fill: #e87272; }
.bag.checked .bag-body { filter: brightness(1.05); }
.bag-handle { fill: none; stroke: #1b2738; stroke-width: 1.5; }
</style>
</head>
<body>
<header>
  <h1>Visor de soluciones PDDL — Aeropuerto</h1>
  <p>Plan: __PLAN__ | Problema: __PROBLEM__</p>
</header>
<main>
  <div>
    <svg id="map" viewBox="0 0 760 520" aria-label="Plano del aeropuerto"></svg>
  </div>
  <div id="panel">
    <div class="controls">
      <button id="back">⏮️ Atrás</button>
      <button id="play">▶️ Reproducir</button>
      <button id="next">⏭️ Siguiente</button>
      <span id="status"></span>
    </div>
    <div class="legend">
      <span class="badge machine">M</span><span>Máquina</span>
      <span class="badge vagon">V</span><span>Vagón</span>
      <span class="badge equipaje">E</span><span>Equipaje</span>
      <span class="badge suspicious">S</span><span>Equipaje sospechoso</span>
    </div>
    <div class="action-log" aria-label="Secuencia de acciones">
      <ul id="log"></ul>
    </div>
  </div>
</main>
<script>
const nodes = {
  facturacion: { x: 220, y: 80, label: 'Zona de facturación' },
  recogida: { x: 540, y: 80, label: 'Recogida de equipajes' },
  inspeccion: { x: 380, y: 180, label: 'Oficina de inspección' },
  puerta1: { x: 200, y: 420, label: 'Puerta1' },
  puerta2: { x: 220, y: 220, label: 'Puerta2' },
  puerta3: { x: 260, y: 320, label: 'Puerta3' },
  puerta4: { x: 160, y: 300, label: 'Puerta4' },
  puerta5: { x: 600, y: 420, label: 'Puerta5' },
  puerta6: { x: 560, y: 220, label: 'Puerta6' },
  puerta7: { x: 520, y: 320, label: 'Puerta7' },
  puerta8: { x: 640, y: 300, label: 'Puerta8' }
};

const edges = [
  ['facturacion','inspeccion'],['recogida','inspeccion'],['facturacion','recogida'],
  ['facturacion','puerta2'],['recogida','puerta6'],['inspeccion','puerta1'],['inspeccion','puerta5'],
  ['puerta2','puerta4'],['puerta4','puerta3'],['puerta3','puerta1'],
  ['puerta6','puerta8'],['puerta8','puerta7'],['puerta7','puerta5'],
  ['facturacion','puerta3'],['recogida','puerta7']
];

const payload = PAYLOAD_DATA;

let actions = payload.actions;
let baseState = payload.initialState;

function locationFor(objName, state){
  const obj = state[objName];
  if(!obj) return null;
  if(obj.location) return obj.location;
  if(obj.container && state[obj.container]) return locationFor(obj.container, state);
  return null;
}

function cloneState(state){
  return JSON.parse(JSON.stringify(state));
}

function computeState(upTo){
  let st = cloneState(baseState);
  for(let i=0;i<=upTo && i<actions.length;i++){
    applyAction(st, actions[i]);
  }
  return st;
}

function applyAction(st, action){
  const [type, ...rest] = [action.name, ...action.args];
  const lower = type.toLowerCase();
  if(lower.startsWith('mover-maquina')){
    const [machine, , to] = rest;
    if(st[machine]){
      st[machine].location = to;
      for(const obj of Object.values(st)){
        if(obj.attachedTo === machine){
          obj.location = to;
        }
      }
    }
  } else if(lower.startsWith('enganchar-vagon')){
    const [vagon, target] = rest;
    if(st[vagon]){
      st[vagon].attachedTo = target;
      if(st[target] && st[target].location){
        st[vagon].location = st[target].location;
      }
    }
  } else if(lower.startsWith('desenganchar-vagon')){
    const [vagon] = rest;
    if(st[vagon]){
      st[vagon].attachedTo = null;
    }
  } else if(lower.startsWith('cargar-equipaje')){
    const [equipaje, vagon] = rest;
    if(st[equipaje]){
      st[equipaje].container = vagon;
      st[equipaje].location = null;
    }
  } else if(lower.startsWith('descargar')){
    const [equipaje, , , destino] = rest;
    if(st[equipaje]){
      st[equipaje].container = null;
      st[equipaje].location = destino;
    }
  } else if(lower.startsWith('inspeccionar-equipaje')){
    const [equipaje, lugar] = rest;
    if(st[equipaje]){
      st[equipaje].checked = true;
      st[equipaje].inspectedAt = lugar;
    }
  }
}

function drawMap(svg){
  svg.innerHTML = '';
  edges.forEach(([a,b])=>{
    const na = nodes[a];
    const nb = nodes[b];
    const line = document.createElementNS('http://www.w3.org/2000/svg','line');
    line.setAttribute('x1', na.x);
    line.setAttribute('y1', na.y);
    line.setAttribute('x2', nb.x);
    line.setAttribute('y2', nb.y);
    line.setAttribute('class','connector');
    svg.appendChild(line);
  });
  Object.entries(nodes).forEach(([name,info])=>{
    const rect = document.createElementNS('http://www.w3.org/2000/svg','rect');
    rect.setAttribute('x', info.x - 60);
    rect.setAttribute('y', info.y - 30);
    rect.setAttribute('width', 120);
    rect.setAttribute('height', 60);
    rect.setAttribute('rx', 8);
    rect.setAttribute('class','node');
    svg.appendChild(rect);

    const label = document.createElementNS('http://www.w3.org/2000/svg','text');
    label.setAttribute('x', info.x);
    label.setAttribute('y', info.y);
    label.setAttribute('text-anchor', 'middle');
    label.setAttribute('class','node-label');
    label.textContent = info.label;
    svg.appendChild(label);
  });
}

function renderTokens(svg, state){
  const perLocation = {};
  Object.entries(state).forEach(([name,obj])=>{
    const loc = locationFor(name, state);
    if(!loc || !nodes[loc]) return;
    if(!perLocation[loc]) perLocation[loc] = {machines:[], vagones:[], equipajes:[]};
    if(obj.type === 'maquina') perLocation[loc].machines.push({name,obj});
    else if(obj.type === 'vagon') perLocation[loc].vagones.push({name,obj});
    else if(obj.type === 'equipaje') perLocation[loc].equipajes.push({name,obj});
  });

  const machinePositions = new Map();
  const wagonPositions = new Map();

  function slot(baseX, total, idx, spacing=130){
    return baseX + (idx - (total-1)/2) * spacing;
  }

  function drawMachine(x,y,label){
    const group = document.createElementNS('http://www.w3.org/2000/svg','g');
    const body = document.createElementNS('http://www.w3.org/2000/svg','rect');
    body.setAttribute('x', x-32); body.setAttribute('y', y-18);
    body.setAttribute('width', 64); body.setAttribute('height', 36);
    body.setAttribute('rx', 8); body.setAttribute('class','machine-body');
    group.appendChild(body);
    const cabin = document.createElementNS('http://www.w3.org/2000/svg','rect');
    cabin.setAttribute('x', x-12); cabin.setAttribute('y', y-30);
    cabin.setAttribute('width', 24); cabin.setAttribute('height', 16);
    cabin.setAttribute('rx', 4); cabin.setAttribute('class','machine-cabin');
    group.appendChild(cabin);
    [ -18, 18].forEach(offset=>{
      const wheel = document.createElementNS('http://www.w3.org/2000/svg','circle');
      wheel.setAttribute('cx', x+offset);
      wheel.setAttribute('cy', y+18);
      wheel.setAttribute('r', 6);
      wheel.setAttribute('class','wheel');
      group.appendChild(wheel);
    });
    const text = document.createElementNS('http://www.w3.org/2000/svg','text');
    text.setAttribute('x', x);
    text.setAttribute('y', y+34);
    text.setAttribute('text-anchor','middle');
    text.setAttribute('class','entity-label');
    text.textContent = label.toUpperCase();
    group.appendChild(text);
    svg.appendChild(group);
  }

  function drawWagon(x,y,label){
    const group = document.createElementNS('http://www.w3.org/2000/svg','g');
    const body = document.createElementNS('http://www.w3.org/2000/svg','rect');
    body.setAttribute('x', x-32); body.setAttribute('y', y-14);
    body.setAttribute('width', 64); body.setAttribute('height', 28);
    body.setAttribute('rx', 4); body.setAttribute('class','wagon-body');
    group.appendChild(body);
    const top = document.createElementNS('http://www.w3.org/2000/svg','rect');
    top.setAttribute('x', x-28); top.setAttribute('y', y-22);
    top.setAttribute('width', 56); top.setAttribute('height', 10);
    top.setAttribute('rx', 4); top.setAttribute('class','wagon-top');
    group.appendChild(top);
    [-18, 18].forEach(offset=>{
      const wheel = document.createElementNS('http://www.w3.org/2000/svg','circle');
      wheel.setAttribute('cx', x+offset);
      wheel.setAttribute('cy', y+18);
      wheel.setAttribute('r', 6);
      wheel.setAttribute('class','wheel');
      group.appendChild(wheel);
    });
    const text = document.createElementNS('http://www.w3.org/2000/svg','text');
    text.setAttribute('x', x);
    text.setAttribute('y', y+34);
    text.setAttribute('text-anchor','middle');
    text.setAttribute('class','entity-label');
    text.textContent = label.toUpperCase();
    group.appendChild(text);
    svg.appendChild(group);
  }

  function drawBag(x,y,label,status,checked){
    const group = document.createElementNS('http://www.w3.org/2000/svg','g');
    group.setAttribute('class', `bag ${status || 'normal'} ${checked ? 'checked' : ''}`.trim());
    const body = document.createElementNS('http://www.w3.org/2000/svg','rect');
    body.setAttribute('x', x-12); body.setAttribute('y', y-12);
    body.setAttribute('width', 24); body.setAttribute('height', 18);
    body.setAttribute('rx', 4); body.setAttribute('class','bag-body');
    group.appendChild(body);
    const handle = document.createElementNS('http://www.w3.org/2000/svg','path');
    handle.setAttribute('d', `M ${x-6} ${y-12} Q ${x} ${y-18} ${x+6} ${y-12}`);
    handle.setAttribute('class','bag-handle');
    group.appendChild(handle);
    const text = document.createElementNS('http://www.w3.org/2000/svg','text');
    text.setAttribute('x', x);
    text.setAttribute('y', y+18);
    text.setAttribute('text-anchor','middle');
    text.setAttribute('class','entity-label');
    text.textContent = label.toUpperCase();
    group.appendChild(text);
    svg.appendChild(group);
  }

  Object.entries(perLocation).forEach(([loc, groups])=>{
    const base = nodes[loc];
    const baseY = base.y + 55;
    groups.machines.forEach((entry, idx)=>{
      const x = slot(base.x, groups.machines.length, idx, 140);
      drawMachine(x, baseY, entry.name);
      machinePositions.set(entry.name, {x, y: baseY});
      const attached = groups.vagones.filter(v=>v.obj.attachedTo === entry.name);
      attached.forEach((wag, widx)=>{
        const wx = x + (widx+1)*80;
        const wy = baseY + 70;
        drawWagon(wx, wy, wag.name);
        wagonPositions.set(wag.name, {x: wx, y: wy});
        const line = document.createElementNS('http://www.w3.org/2000/svg','line');
        line.setAttribute('x1', x);
        line.setAttribute('y1', baseY+12);
        line.setAttribute('x2', wx);
        line.setAttribute('y2', wy-16);
        line.setAttribute('class','connection-line');
        svg.appendChild(line);
      });
    });

    const freeWagons = groups.vagones.filter(v=>!v.obj.attachedTo || !machinePositions.has(v.obj.attachedTo));
    freeWagons.forEach((wag, idx)=>{
      const wx = slot(base.x, freeWagons.length, idx, 120);
      const wy = baseY + 70;
      drawWagon(wx, wy, wag.name);
      wagonPositions.set(wag.name, {x: wx, y: wy});
    });

    const looseBags = groups.equipajes.filter(b=>!b.obj.container);
    looseBags.forEach((bag, idx)=>{
      const bx = slot(base.x, looseBags.length, idx, 80);
      const by = baseY - 14;
      drawBag(bx, by, bag.name, bag.obj.status, bag.obj.checked);
    });
  });

  Object.entries(state).forEach(([name,obj])=>{
    if(obj.type !== 'equipaje' || !obj.container) return;
    const hostPos = wagonPositions.get(obj.container) || machinePositions.get(obj.container);
    if(!hostPos) return;
    const siblings = Object.entries(state).filter(([n,o])=> o.type==='equipaje' && o.container === obj.container);
    const idx = siblings.findIndex(([n])=> n===name);
    const bx = hostPos.x + (idx - (siblings.length-1)/2)*18;
    const by = hostPos.y - 22;
    drawBag(bx, by, name, obj.status, obj.checked);
  });
}

function populateLog(log){
  const initial = document.createElement('li');
  initial.id = 'action--1';
  initial.textContent = 'Estado inicial (máquinas, vagones y equipajes)';
  log.appendChild(initial);
  actions.forEach((act)=>{
    const li = document.createElement('li');
    li.id = `action-${act.index}`;
    li.textContent = `${act.index}. ${act.raw}`;
    log.appendChild(li);
  });
}

function update(step){
  const svg = document.getElementById('map');
  drawMap(svg);
  const state = computeState(step);
  renderTokens(svg, state);
  document.getElementById('status').textContent = step < 0 ? 'Estado inicial' : `Acción ${step + 1} / ${actions.length}`;
  document.querySelectorAll('.action-log li').forEach(li=>li.classList.remove('active'));
  const active = document.getElementById(`action-${step}`);
  if(active){ active.classList.add('active'); active.scrollIntoView({behavior:'smooth', block:'center'}); }
  document.getElementById('back').disabled = step <= -1;
  document.getElementById('next').disabled = step >= actions.length -1;
}

function init(){
  const log = document.getElementById('log');
  populateLog(log);
  let step = -1;
  let timer = null;
  update(step);
  const back = document.getElementById('back');
  const next = document.getElementById('next');
  const play = document.getElementById('play');

  back.addEventListener('click', ()=>{
    step = Math.max(-1, step-1);
    update(step);
  });
  next.addEventListener('click', ()=>{
    step = Math.min(actions.length-1, step+1);
    update(step);
  });
  play.addEventListener('click', ()=>{
    if(timer){
      clearInterval(timer); timer = null; play.textContent='▶️ Reproducir';
      return;
    }
    play.textContent = '⏸️ Pausar';
    timer = setInterval(()=>{
      if(step >= actions.length -1){
        clearInterval(timer); timer=null; play.textContent='▶️ Reproducir'; return;
      }
      step +=1;
      update(step);
    }, 900);
  });
}

document.addEventListener('DOMContentLoaded', init);
</script>
</body>
</html>"""
    html = template.replace("__PLAN__", str(payload["planFile"]))
    html = html.replace("__PROBLEM__", str(payload["problemFile"]))
    html = html.replace("PAYLOAD_DATA", json.dumps(payload))
    Path(output_path).write_text(html, encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Genera un visor HTML para planes del aeropuerto.")
    parser.add_argument("--plan", default="plan_ff.soln", help="Ruta del fichero de plan (por defecto plan_ff.soln)")
    parser.add_argument("--problem", default="problem.pddl", help="Ruta del problema PDDL")
    parser.add_argument("--output", default="solution_viewer.html", help="HTML de salida")
    args = parser.parse_args()

    payload = build_payload(Path(args.plan), Path(args.problem))
    render_html(payload, Path(args.output))
    print(f"Visor generado en {args.output}")


if __name__ == "__main__":
    main()
