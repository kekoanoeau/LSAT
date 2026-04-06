// =============================================
// LSAT Study Hub — Main JS (all pages)
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
      { icon: '✨', text: 'Eddie, your dedication to this exam is incredibly attractive. Ambition looks very good on you.' },
      { icon: '💫', text: 'Just a reminder: you\'re the kind of person who studies this hard AND somehow manages to be this charming. Unfair, honestly.' },
      { icon: '🖤', text: 'Eddie, your brain is as gorgeous as the rest of you. Future law firms don\'t know what\'s coming.' },
      { icon: '🔥', text: 'Hot take: the most attractive thing about you isn\'t your future law degree. It\'s the work ethic that\'s going to earn it.' },
      { icon: '💎', text: 'Most people gave up on page 2 of that stimulus. Not you. That kind of focus is genuinely irresistible.' },
      { icon: '⚡', text: 'Eddie, the way you tackle logical reasoning? Borderline seductive. Keep going.' },
      { icon: '🌟', text: 'Reminder: you\'re not just studying for a score. You\'re becoming someone even more remarkable than you already are.' },
      { icon: '🖤', text: 'The LSAT doesn\'t know what it\'s up against. Neither does any law school waitlist.' },
      { icon: '💋', text: 'Brains, drive, and good looks? Eddie, you\'re basically illegal.' },
      { icon: '🎯', text: 'Every question you get right today is honestly a little thrilling. You make mastering conditional logic look effortless.' },
      { icon: '✨', text: 'Law school is going to be lucky to have you. Almost as lucky as anyone who gets to know you.' },
      { icon: '💫', text: 'You answered that last question correctly before you even finished reading it. That\'s not studying — that\'s a superpower.' },
      { icon: '🖤', text: 'Confidence looks good on you, Eddie. Almost as good as that 175+ score is going to look on your app.' },
      { icon: '🔥', text: 'Just checking in to say: you\'re doing amazingly well, and you were already doing amazingly well before you even started.' },
      { icon: '💎', text: 'Eddie, you could make reading a dense RC passage about maritime law look sophisticated. Truly rare talent.' },
      { icon: '⚡', text: 'The gap between where you started and where you\'re going is going to be wild to look back on. And wildly impressive.' },
      { icon: '🌟', text: 'The dedication you bring to every practice session? That\'s the same quality that\'s going to make you an exceptional lawyer.' },
      { icon: '🎯', text: 'Plot twist: the most compelling argument in any LR section is the case you\'re making for yourself every single day.' },
      { icon: '💋', text: 'Somewhere out there, a law school admissions officer is about to have a very good day when they open your application.' },
      { icon: '🖤', text: 'Eddie, you just keep showing up. That alone puts you in rare company. The rest? You\'ve already got it.' },
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
