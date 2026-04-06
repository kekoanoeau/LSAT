// =============================================
// LSAT Study Hub — Progress Page
// =============================================

const SECTION_LABELS = { lr: 'Logical Reasoning', lg: 'Logic Games', rc: 'Reading Comp', mixed: 'Mixed' };
const SECTION_COLORS = { lr: 'var(--lr)', lg: 'var(--lg)', rc: 'var(--rc)', mixed: '#7c3aed' };

// LSAT score percentile context
const SCORE_CONTEXT = {
  180: "Perfect score — 99.9th percentile. Top law schools.",
  175: "99th percentile. Competitive for any law school.",
  170: "97th percentile. Extremely competitive.",
  165: "92nd percentile. Very strong for T14 schools.",
  160: "80th percentile. Competitive for top-50 programs.",
  155: "66th percentile. Median for many law schools.",
  150: "44th percentile. Above average.",
  145: "26th percentile. Below median for most programs.",
  140: "13th percentile. Significant improvement needed.",
  135: "5th percentile. Major foundational work required."
};

function getScoreContext(score) {
  const keys = Object.keys(SCORE_CONTEXT).map(Number).sort((a, b) => b - a);
  for (const k of keys) {
    if (score >= k) return SCORE_CONTEXT[k];
  }
  return "Keep studying — every point counts!";
}

function renderAccuracyChart(acc) {
  const chart = document.getElementById('accuracyChart');
  // Aug 2024+: LG removed. Show LR, RC, mixed only.
  const sections = ['lr', 'rc', 'mixed'];
  let html = '';

  let hasData = false;
  sections.forEach(s => {
    if (!acc[s] || acc[s].total === 0) return;
    hasData = true;
    const pct = Math.round((acc[s].correct / acc[s].total) * 100);
    html += `
      <div class="bar-row">
        <span class="bar-label">${SECTION_LABELS[s]}</span>
        <div class="bar-track">
          <div class="bar-fill" style="width:${pct}%;background:${SECTION_COLORS[s]}"></div>
        </div>
        <span class="bar-pct">${pct}%</span>
      </div>
      <div style="font-size:.75rem;color:var(--text-muted);padding-left:calc(140px + .75rem);margin-top:-.5rem;margin-bottom:.25rem;">
        ${acc[s].correct} correct of ${acc[s].total} attempted
      </div>`;
  });

  if (!hasData) {
    chart.innerHTML = '<div style="color:var(--text-muted);font-size:.875rem;">Complete some practice sessions to see your accuracy here.</div>';
  } else {
    chart.innerHTML = html;
  }

  return hasData;
}

// Updated scoring: LR ~65% of exam (~50 questions), RC ~35% (~27 questions)
// Total scored questions ≈ 77
function estimateScore(lrPct, rcPct) {
  const raw = (lrPct / 100) * 50 + (rcPct / 100) * 27;
  const scaled = Math.round(120 + (raw / 77) * 60);
  return Math.min(180, Math.max(120, scaled));
}

function renderScoreEstimate(acc) {
  const el = document.getElementById('scoreEstimate');
  const lrData = acc['lr'];
  const rcData = acc['rc'];

  if (!lrData && !rcData) {
    el.innerHTML = '<div style="font-size:.875rem;color:var(--text-muted);">Complete LR and RC practice to see a score estimate.</div>';
    return;
  }

  const lrPct = lrData && lrData.total > 0 ? (lrData.correct / lrData.total) * 100 : 65;
  const rcPct = rcData && rcData.total > 0 ? (rcData.correct / rcData.total) * 100 : 65;

  const score = estimateScore(lrPct, rcPct);
  const low = Math.max(120, score - 3);
  const high = Math.min(180, score + 3);

  const missing = [];
  if (!lrData || lrData.total === 0) missing.push('LR');
  if (!rcData || rcData.total === 0) missing.push('RC');

  el.innerHTML = `
    <div style="font-size:.82rem;color:var(--text-muted);margin-bottom:.5rem;">Based on your practice accuracy (LR + RC only — Aug 2024 format)</div>
    <div style="font-size:3.5rem;font-weight:800;color:var(--lr);line-height:1;">${score}</div>
    <div style="font-size:.9rem;color:var(--text-muted);margin-bottom:.5rem;">Estimated range: ${low}–${high}</div>
    <div style="font-size:.85rem;color:var(--text)">${getScoreContext(score)}</div>
    ${missing.length > 0 ? `<div style="font-size:.78rem;color:var(--rc);margin-top:.5rem;">⚠ Using estimated 65% for ${missing.join(', ')} (no data yet)</div>` : ''}
  `;
}

function renderHistory() {
  const history = JSON.parse(localStorage.getItem('lsat_history') || '[]');
  const container = document.getElementById('historyContainer');
  const clearBtn = document.getElementById('clearBtn');

  if (history.length === 0) {
    container.innerHTML = '<div style="color:var(--text-muted);font-size:.875rem;">No sessions recorded yet. Start a practice session to track your progress!</div>';
    return;
  }

  clearBtn.style.display = 'inline-block';

  const rows = history.slice(0, 20).map(h => {
    const date = new Date(h.date);
    const dateStr = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    const timeStr = date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
    const pct = h.pct || 0;
    const pctColor = pct >= 80 ? 'var(--lg)' : pct >= 60 ? 'var(--rc)' : '#ef4444';
    return `<tr>
      <td>${dateStr} ${timeStr}</td>
      <td>${SECTION_LABELS[h.section] || h.section}</td>
      <td class="badge-correct">${h.correct}</td>
      <td class="badge-wrong">${(h.total - h.skipped) - h.correct}</td>
      <td>${h.skipped}</td>
      <td style="font-weight:700;color:${pctColor}">${pct}%</td>
    </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="history-table">
      <thead>
        <tr>
          <th>Date &amp; Time</th>
          <th>Section</th>
          <th>Correct</th>
          <th>Wrong</th>
          <th>Skipped</th>
          <th>Score</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

function renderTips(acc) {
  const content = document.getElementById('tipsContent');
  const tips = [];

  // Aug 2024+: LG removed from LSAT
  const sections = ['lr', 'rc'];
  sections.forEach(s => {
    if (!acc[s] || acc[s].total === 0) return;
    const pct = (acc[s].correct / acc[s].total) * 100;
    if (pct < 60) {
      tips.push({ section: s, level: 'critical', tip: `Your ${SECTION_LABELS[s]} accuracy is ${Math.round(pct)}%. Focus on foundational concepts — review the study guide and work untimed drills until you reach 70%.` });
    } else if (pct < 75) {
      tips.push({ section: s, level: 'improve', tip: `Your ${SECTION_LABELS[s]} accuracy is ${Math.round(pct)}%. You're building a foundation. Focus on understanding WHY wrong answers are wrong on every missed question.` });
    } else if (pct < 88) {
      tips.push({ section: s, level: 'good', tip: `${SECTION_LABELS[s]} at ${Math.round(pct)}% — solid progress. Now work on speed without sacrificing accuracy. Time yourself per-question.` });
    } else {
      tips.push({ section: s, level: 'excellent', tip: `${SECTION_LABELS[s]} at ${Math.round(pct)}% — excellent! Maintain this under timed conditions. Focus your remaining energy on weaker sections.` });
    }
  });

  if (tips.length === 0) {
    content.innerHTML = '<p style="font-size:.875rem;color:var(--text-muted);">Complete some practice to get personalized recommendations.</p>';
    return;
  }

  const levelColors = { critical: '#ef4444', improve: 'var(--rc)', good: 'var(--lr)', excellent: 'var(--lg)' };
  const levelLabels = { critical: 'Needs Work', improve: 'Improving', good: 'Good', excellent: 'Strong' };

  content.innerHTML = tips.map(t => `
    <div style="display:flex;gap:.75rem;align-items:flex-start;margin-bottom:.75rem;padding:.75rem;background:#f8fafc;border-radius:8px;border-left:3px solid ${levelColors[t.level]}">
      <span style="font-size:.72rem;font-weight:700;padding:.2rem .55rem;border-radius:99px;background:${levelColors[t.level]}20;color:${levelColors[t.level]};white-space:nowrap;margin-top:.15rem;">${levelLabels[t.level]}</span>
      <span style="font-size:.875rem;">${t.tip}</span>
    </div>`).join('');
}

function renderTargetContext() {
  const target = parseInt(localStorage.getItem('lsat_target') || '175');
  document.getElementById('targetInput').value = target;
  document.getElementById('targetContext').textContent = getScoreContext(target);
}

function saveTarget() {
  const val = parseInt(document.getElementById('targetInput').value);
  if (val < 120 || val > 180) {
    alert('Please enter a score between 120 and 180.');
    return;
  }
  localStorage.setItem('lsat_target', val.toString());
  document.getElementById('targetContext').textContent = getScoreContext(val);
  const saved = document.getElementById('targetSaved');
  saved.style.display = 'block';
  setTimeout(() => { saved.style.display = 'none'; }, 2000);
}

function clearHistory() {
  if (!confirm('Clear all practice history? This cannot be undone.')) return;
  localStorage.removeItem('lsat_history');
  localStorage.removeItem('lsat_accuracy');
  localStorage.removeItem('lsat_type_accuracy');
  localStorage.removeItem('lsat_total');
  location.reload();
}

// ── Per-type accuracy chart ────────────────
function renderTypeAccuracyChart() {
  const typeAcc = JSON.parse(localStorage.getItem('lsat_type_accuracy') || '{}');
  const container = document.getElementById('typeAccuracyChart');
  if (!container) return;

  const entries = Object.entries(typeAcc)
    .filter(([, d]) => d.total > 0)
    .sort((a, b) => (b[1].correct / b[1].total) - (a[1].correct / a[1].total));

  if (entries.length === 0) return;

  // Group by section using known type names
  const lrTypes = new Set(['Assumption','Weaken','Strengthen','Flaw','Inference','Main Conclusion',
    'Parallel Reasoning','Principle (Apply)','Point at Issue / Agree','Role of Statement',
    'Sufficient Assumption','Resolve the Paradox','Inference / Must Be True']);
  const rcTypes = new Set(['Main Point','Author\'s Attitude','Detail / Specific Information',
    'Inference','Organization / Structure','Function of Paragraph / Phrase',
    'Analogy / Parallel Structure','Comparative (Passage A vs. B)','Strengthen / Weaken the Argument',
    'Main Point / Primary Purpose', 'Author\'s Attitude / Tone']);

  const lr = entries.filter(([t]) => lrTypes.has(t));
  const rc = entries.filter(([t]) => rcTypes.has(t));
  const other = entries.filter(([t]) => !lrTypes.has(t) && !rcTypes.has(t));

  function renderGroup(label, sectionColor, items) {
    if (!items.length) return '';
    const rows = items.map(([type, data]) => {
      const pct = Math.round((data.correct / data.total) * 100);
      const barColor = pct >= 80 ? 'var(--lg)' : pct >= 60 ? 'var(--rc)' : '#ef4444';
      const star = pct >= 90 ? ' ⭐' : pct < 50 ? ' ⚠' : '';
      return `<div class="bar-row">
        <span class="bar-label" style="font-size:.8rem;">${type}${star}</span>
        <div class="bar-track">
          <div class="bar-fill" style="width:${pct}%;background:${barColor}"></div>
        </div>
        <span class="bar-pct" style="min-width:60px;font-size:.8rem;">
          ${pct}%
          <span style="font-size:.7rem;color:var(--text-muted);display:block;line-height:1;">${data.correct}/${data.total}</span>
        </span>
      </div>`;
    }).join('');
    return `<div style="margin-bottom:1.25rem;">
      <div style="font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:${sectionColor};margin-bottom:.6rem;">${label}</div>
      <div class="bar-chart">${rows}</div>
    </div>`;
  }

  container.innerHTML =
    renderGroup('Logical Reasoning', 'var(--lr)', lr) +
    renderGroup('Reading Comprehension', 'var(--rc)', rc) +
    renderGroup('Other', 'var(--text-muted)', other);
}

// ── Init ───────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  const acc = JSON.parse(localStorage.getItem('lsat_accuracy') || '{}');
  const total = parseInt(localStorage.getItem('lsat_total') || '0');

  document.getElementById('totalDone').textContent = total;

  // Aug 2024+: LG removed from LSAT
  const sections = ['lr', 'rc'];
  sections.forEach(s => {
    const el = document.getElementById(`${s}Pct`);
    if (el && acc[s] && acc[s].total > 0) {
      const pct = Math.round((acc[s].correct / acc[s].total) * 100);
      el.textContent = pct + '%';
    }
  });

  renderAccuracyChart(acc);
  renderScoreEstimate(acc);
  renderTypeAccuracyChart();
  renderHistory();
  renderTips(acc);
  renderTargetContext();
});
