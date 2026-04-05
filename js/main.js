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
  const lgEl = document.getElementById('lgAccuracy');
  const rcEl = document.getElementById('rcAccuracy');
  const totEl = document.getElementById('totalQuestions');

  if (lrEl) lrEl.textContent = pctStr('lr');
  if (lgEl) lgEl.textContent = pctStr('lg');
  if (rcEl) rcEl.textContent = pctStr('rc');
  if (totEl) totEl.textContent = total;

  // ── Target score on dashboard ──────────────
  const targetEl = document.getElementById('targetScore');
  if (targetEl) {
    const saved = localStorage.getItem('lsat_target');
    if (saved) targetEl.textContent = saved;
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
