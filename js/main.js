// =============================================
// EddieHub 💪 — Main JS (all pages)
// =============================================

document.addEventListener('DOMContentLoaded', () => {
  // ── Date display ──────────────────────────
  const dateEl = document.getElementById('dateDisplay');
  if (dateEl) {
    const now = new Date();
    dateEl.textContent = now.toLocaleDateString('en-US', {
      weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
    });
  }

  // ── Dashboard stats from localStorage ─────
  const acc = JSON.parse(localStorage.getItem('lsat_accuracy') || '{}');
  const total = parseInt(localStorage.getItem('lsat_total') || '0');

  function pctStr(section) {
    const d = acc[section];
    if (!d || d.total === 0) return '—';
    return Math.round((d.correct / d.total) * 100) + '%';
  }

  const lrEl = document.getElementById('lrAccuracy');
  const rcEl = document.getElementById('rcAccuracy');
  const totEl = document.getElementById('totalQuestions');

  if (lrEl) lrEl.textContent = pctStr('lr');
  if (rcEl) rcEl.textContent = pctStr('rc');
  if (totEl) totEl.textContent = total;

  // ── Target score on dashboard ──────────────
  const targetEl = document.getElementById('targetScore');
  if (targetEl) {
    const saved = localStorage.getItem('lsat_target');
    if (saved) targetEl.textContent = saved;
  }

  // ── Daily compliment ──────────────────────
  const complimentEl = document.getElementById('dailyCompliment');
  if (complimentEl) {
    const compliments = [
      { icon: '🏋️', text: 'Eddie, your dedication to this exam is incredibly attractive. Ambition looks very good on you — and so do the gains.' },
      { icon: '💪', text: 'You train harder than anyone in this gym. And somehow you\'re also the most charming person here. Genuinely unfair.' },
      { icon: '🖤', text: 'Eddie, your brain is as impressive as the rest of you. Future law firms have no idea what\'s about to walk through the door.' },
      { icon: '🔥', text: 'Hot take: the most attractive thing about you isn\'t the future law degree. It\'s the work ethic that\'s going to earn it. Straight savage.' },
      { icon: '💎', text: 'Most people quit at rep 3. You finish every set. That consistency is genuinely irresistible — and it\'s why you\'re going to crush this exam.' },
      { icon: '⚡', text: 'Eddie, the way you tackle logical reasoning? It\'s giving elite athlete energy. Keep repping.' },
      { icon: '🌟', text: 'You\'re not just studying for a score — you\'re building someone even more formidable than you already are. And that\'s saying something.' },
      { icon: '🖤', text: 'The LSAT doesn\'t know what it\'s up against. No law school waitlist does either. You\'re the type they scramble for.' },
      { icon: '💋', text: 'Brains, discipline, and good looks? Eddie, you\'re basically a cheat code. The LSAT just hasn\'t been patched yet.' },
      { icon: '🎯', text: 'Every question you nail is another rep locked in. You make mastering conditional logic look effortless. Genuinely unhinged talent.' },
      { icon: '💪', text: 'Law school is going to be lucky to have you. Almost as lucky as anyone who gets to know you.' },
      { icon: '🏆', text: 'You answered that last question correctly before you finished reading it. That\'s not studying anymore — that\'s pattern recognition at an elite level.' },
      { icon: '🖤', text: 'Confidence looks good on you, Eddie. Almost as good as that 175+ is going to look on your application. Almost.' },
      { icon: '🔥', text: 'Checking in to say: you\'re doing amazingly, and you were already doing amazingly before you started. That\'s just your baseline.' },
      { icon: '💎', text: 'Eddie, you make reading an RC passage about 18th century maritime law look like a flex. Truly elite behavior.' },
      { icon: '⚡', text: 'The gap between where you started and where you\'re going is going to be wild to look back on. Wild, and wildly impressive.' },
      { icon: '🌟', text: 'The discipline you bring to every session? That\'s the same quality that\'s going to make you an exceptional lawyer. Non-negotiable.' },
      { icon: '🎯', text: 'Plot twist: the most compelling argument in any LR section is the case you\'re making for yourself every single day you show up.' },
      { icon: '💋', text: 'Somewhere out there, a law school admissions officer is about to have a very good day when they open your application.' },
      { icon: '🏋️', text: 'Eddie, you just keep showing up and putting in reps. That alone puts you in rare company. The score will follow. It always does.' },
    ];
    // Pick a stable compliment per calendar day
    const dayIndex = Math.floor(Date.now() / 86400000) % compliments.length;
    const c = compliments[dayIndex];
    complimentEl.innerHTML = `
      <span class="compliment-icon">${c.icon}</span>
      <span><span class="compliment-label">Today's note</span>${c.text}</span>
    `;
  }

  // ── Per-type score badges (LR + RC study pages) ──
  const typeAcc = JSON.parse(localStorage.getItem('lsat_type_accuracy') || '{}');
  if (Object.keys(typeAcc).length > 0) {
    // LR page: inject into .qtype-header after .qtype-name
    document.querySelectorAll('.qtype-header').forEach(header => {
      const nameEl = header.querySelector('.qtype-name');
      if (!nameEl) return;
      const type = nameEl.textContent.trim();
      const data = typeAcc[type];
      if (!data || data.total === 0) return;
      injectTypeBadge(header, data);
    });

    // RC page: inject into rules-table rows where first cell has <strong>
    document.querySelectorAll('.rules-table tbody tr').forEach(row => {
      const first = row.querySelector('td strong');
      if (!first) return;
      const type = first.textContent.trim();
      const data = typeAcc[type];
      if (!data || data.total === 0) return;
      const td = first.closest('td');
      if (td) injectTypeBadge(td, data);
    });
  }

  function injectTypeBadge(el, data) {
    if (el.querySelector('.type-score-badge')) return; // already injected
    const pct = Math.round((data.correct / data.total) * 100);
    const bg   = pct >= 80 ? '#dcfce7' : pct >= 60 ? '#fef9c3' : '#fee2e2';
    const color = pct >= 80 ? '#166534' : pct >= 60 ? '#854d0e' : '#991b1b';
    const badge = document.createElement('span');
    badge.className = 'type-score-badge';
    badge.title = `${data.correct} correct out of ${data.total} attempted`;
    badge.style.cssText = `
      display:inline-flex;align-items:center;gap:.25rem;
      font-size:.7rem;font-weight:700;padding:.2rem .55rem;
      border-radius:99px;margin-left:.5rem;
      background:${bg};color:${color};
      vertical-align:middle;white-space:nowrap;cursor:default;
    `;
    badge.innerHTML = `${pct}% <span style="font-weight:400;opacity:.75;">${data.correct}/${data.total}</span>`;
    el.appendChild(badge);
  }

  // ── Active nav link ───────────────────────
  const path = window.location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a').forEach(a => {
    const href = a.getAttribute('href');
    if (href === path || (path === '' && href === 'index.html')) {
      a.classList.add('active');
    } else {
      a.classList.remove('active');
    }
  });
});
