// =============================================
// LSAT Study Hub — Practice Engine
// =============================================

// ── State ──────────────────────────────────
let state = {
  section: null,
  count: null,
  timer: null,
  questions: [],
  currentIndex: 0,
  answers: {},       // { questionId: choiceIndex | null }
  revealed: {},      // { questionId: true } — explanation shown
  startTime: null,
  timerInterval: null,
  secondsLeft: 0,
  questionTimes: {}  // { questionId: secondsTaken }
};

// ── Selections ─────────────────────────────
const selections = { section: null, count: null, timer: null };

function selectOption(group, el) {
  const grid = el.parentElement;
  grid.querySelectorAll('.option-card').forEach(c => c.classList.remove('selected'));
  el.classList.add('selected');
  selections[group] = el.dataset.value;
  updateStartBtn();
}

function updateStartBtn() {
  const btn = document.getElementById('startBtn');
  btn.disabled = !(selections.section && selections.count && selections.timer);
}

// ── URL Params → auto-select ───────────────
function applyURLParams() {
  const params = new URLSearchParams(window.location.search);
  const typeMap = { lr: 'lr', lg: 'lg', rc: 'rc', mixed: 'mixed' };
  const countMap = { '5': '5', '10': '10', '25': 'all', '1': '5' };

  const t = params.get('type');
  const c = params.get('count');

  if (t && typeMap[t]) {
    const el = document.querySelector(`#sectionOptions [data-value="${typeMap[t]}"]`);
    if (el) selectOption('section', el);
  }
  if (c && countMap[c]) {
    const el = document.querySelector(`#countOptions [data-value="${countMap[c]}"]`);
    if (el) selectOption('count', el);
  }

  // Default to timed
  const timedEl = document.querySelector('#timerOptions [data-value="timed"]');
  if (timedEl) selectOption('timer', timedEl);
}

// ── Start Practice ─────────────────────────
function startPractice() {
  state.section = selections.section;
  state.count = selections.count;
  state.timer = selections.timer;

  // Filter questions by section
  let pool = QUESTIONS.filter(q => {
    if (state.section === 'mixed') return true;
    return q.section === state.section;
  });

  // Shuffle
  pool = shuffle(pool);

  // Limit count
  if (state.count !== 'all') {
    pool = pool.slice(0, parseInt(state.count));
  }

  if (pool.length === 0) {
    alert('No questions available for this selection. More questions coming soon!');
    return;
  }

  state.questions = pool;
  state.currentIndex = 0;
  state.answers = {};
  state.revealed = {};
  state.questionTimes = {};
  state.startTime = Date.now();

  document.getElementById('selectionScreen').style.display = 'none';
  document.getElementById('practiceScreen').style.display = 'block';

  // Setup timer
  if (state.timer === 'timed') {
    const perQ = PER_QUESTION_TIMES[state.section] || 90;
    state.secondsLeft = perQ * pool.length;
    document.getElementById('timerContainer').style.display = 'block';
    startTimer();
  }

  renderQuestion();
}

// ── Timer ──────────────────────────────────
function startTimer() {
  updateTimerDisplay();
  state.timerInterval = setInterval(() => {
    state.secondsLeft--;
    updateTimerDisplay();
    if (state.secondsLeft <= 0) {
      clearInterval(state.timerInterval);
      finishSession(true);
    }
  }, 1000);
}

function updateTimerDisplay() {
  const el = document.getElementById('timerDisplay');
  const val = document.getElementById('timerValue');
  const m = Math.floor(state.secondsLeft / 60);
  const s = state.secondsLeft % 60;
  val.textContent = `${m}:${s.toString().padStart(2, '0')}`;

  el.classList.remove('warning', 'danger');
  if (state.secondsLeft <= 60) el.classList.add('danger');
  else if (state.secondsLeft <= 180) el.classList.add('warning');
}

function stopTimer() {
  if (state.timerInterval) {
    clearInterval(state.timerInterval);
    state.timerInterval = null;
  }
}

// ── Render Question ────────────────────────
function renderQuestion() {
  const q = state.questions[state.currentIndex];
  const total = state.questions.length;
  const idx = state.currentIndex;

  // Progress bar
  document.getElementById('progressBar').style.width = `${((idx + 1) / total) * 100}%`;

  // Title
  const sectionNames = { lr: 'Logical Reasoning', lg: 'Logic Games', rc: 'Reading Comprehension' };
  document.getElementById('practiceTitle').textContent = sectionNames[q.section] || 'Practice';
  document.getElementById('practiceSubtitle').textContent = `Question ${idx + 1} of ${total} · ${q.type}`;

  // Question area
  const area = document.getElementById('questionArea');
  const selectedAnswer = state.answers[q.id] !== undefined ? state.answers[q.id] : null;
  const isRevealed = !!state.revealed[q.id];

  const choicesHTML = q.choices.map((choice, i) => {
    let cls = 'answer-choice';
    if (isRevealed) {
      if (i === q.correct) cls += ' revealed-correct';
      else if (i === selectedAnswer && i !== q.correct) cls += ' incorrect';
    } else if (i === selectedAnswer) {
      cls += ' selected';
    }
    return `
      <div class="${cls}" onclick="selectAnswer(${i})" id="choice-${i}">
        <span class="choice-letter">${String.fromCharCode(65 + i)}.</span>
        <span>${choice}</span>
      </div>`;
  }).join('');

  let explanationHTML = '';
  if (isRevealed) {
    const correct = selectedAnswer === q.correct;
    explanationHTML = `
      <div class="explanation-box">
        <div class="${correct ? 'correct-note' : 'wrong-note'}">
          ${correct ? '✓ Correct!' : `✗ Incorrect — The correct answer was ${String.fromCharCode(65 + q.correct)}.`}
        </div>
        <h4>Explanation</h4>
        <p>${q.explanation}</p>
      </div>`;
  }

  area.innerHTML = `
    <div class="question-card">
      <div class="question-meta">
        <span class="q-number">Q${idx + 1}</span>
        <span class="q-type-badge ${q.section}">${q.type}</span>
      </div>
      <div class="stimulus">${q.stimulus.replace(/\n/g, '<br>')}</div>
      <div class="question-stem">${q.stem}</div>
      <div class="answer-choices">${choicesHTML}</div>
      ${explanationHTML}
    </div>`;

  // Controls
  document.getElementById('prevBtn').disabled = idx === 0;
  const submitBtn = document.getElementById('submitBtn');
  const nextBtn = document.getElementById('nextBtn');
  const skipBtn = document.getElementById('skipBtn');

  if (isRevealed) {
    submitBtn.style.display = 'none';
    nextBtn.style.display = 'inline-block';
    skipBtn.style.display = 'none';
    if (idx === total - 1) {
      nextBtn.textContent = 'Finish →';
    } else {
      nextBtn.textContent = 'Next →';
    }
  } else {
    submitBtn.style.display = 'inline-block';
    nextBtn.style.display = 'none';
    skipBtn.style.display = 'inline-block';
    submitBtn.disabled = selectedAnswer === null;
  }
}

function selectAnswer(i) {
  const q = state.questions[state.currentIndex];
  if (state.revealed[q.id]) return; // already submitted
  state.answers[q.id] = i;
  renderQuestion();
}

function submitAnswer() {
  const q = state.questions[state.currentIndex];
  if (state.answers[q.id] === undefined) return;
  state.revealed[q.id] = true;
  // Record time
  if (!state.questionTimes[q.id]) {
    state.questionTimes[q.id] = Math.round((Date.now() - state.startTime) / 1000);
  }
  renderQuestion();
}

function skipQuestion() {
  const q = state.questions[state.currentIndex];
  state.answers[q.id] = null; // mark as skipped (null = unanswered)
  navigateQuestion(1);
}

function navigateQuestion(dir) {
  const newIdx = state.currentIndex + dir;
  if (newIdx < 0 || newIdx > state.questions.length) return;
  if (newIdx === state.questions.length) {
    finishSession(false);
    return;
  }
  state.currentIndex = newIdx;
  renderQuestion();
}

// ── Finish ─────────────────────────────────
function finishSession(timedOut) {
  stopTimer();

  const total = state.questions.length;
  let correct = 0;
  let skipped = 0;
  const byType = {};

  state.questions.forEach(q => {
    const ans = state.answers[q.id];
    const type = q.type;
    if (!byType[type]) byType[type] = { correct: 0, total: 0 };

    if (ans === null || ans === undefined) {
      skipped++;
    } else {
      byType[type].total++;
      if (state.revealed[q.id] && ans === q.correct) {
        correct++;
        byType[type].correct++;
      }
    }
  });

  const attempted = total - skipped;
  const pct = attempted > 0 ? Math.round((correct / attempted) * 100) : 0;

  // Save to localStorage (includes per-type breakdown)
  saveResult({ section: state.section, total, correct, skipped, pct, byType, date: new Date().toISOString() });

  // Show results
  document.getElementById('practiceScreen').style.display = 'none';
  document.getElementById('resultsScreen').style.display = 'block';

  document.getElementById('resultsScore').textContent = `${correct}/${attempted}`;
  document.getElementById('resultsLabel').textContent = `${pct}% Correct${timedOut ? ' (Time Ran Out)' : ''}`;

  const emoji = pct >= 80 ? '🎉' : pct >= 60 ? '💪' : '📚';
  document.getElementById('resultsEmoji').textContent = emoji;

  document.getElementById('resultsBreakdown').innerHTML = `
    <div class="breakdown-item"><div class="breakdown-num" style="color:var(--lg)">${correct}</div><div class="breakdown-label">Correct</div></div>
    <div class="breakdown-item"><div class="breakdown-num" style="color:#ef4444">${attempted - correct}</div><div class="breakdown-label">Wrong</div></div>
    <div class="breakdown-item"><div class="breakdown-num" style="color:var(--text-muted)">${skipped}</div><div class="breakdown-label">Skipped</div></div>
  `;

  // By type — show this session + cumulative
  const cumTypeAcc = JSON.parse(localStorage.getItem('lsat_type_accuracy') || '{}');
  const typeRows = Object.entries(byType)
    .filter(([, d]) => d.total > 0)
    .map(([type, data]) => {
      const sessionPct = Math.round((data.correct / data.total) * 100);
      const cum = cumTypeAcc[type];
      const cumPct = cum && cum.total > 0 ? Math.round((cum.correct / cum.total) * 100) : null;
      const barColor = sessionPct >= 80 ? 'var(--lg)' : sessionPct >= 60 ? 'var(--rc)' : '#ef4444';
      const cumBadge = cumPct !== null
        ? `<span style="font-size:.7rem;color:var(--text-muted);margin-left:.5rem;">all-time: ${cumPct}%</span>`
        : '';
      return `<div class="bar-row">
        <span class="bar-label">${type}</span>
        <div class="bar-track"><div class="bar-fill" style="width:${sessionPct}%;background:${barColor}"></div></div>
        <span class="bar-pct">${sessionPct}%${cumBadge}</span>
      </div>`;
    }).join('');

  document.getElementById('resultsByType').innerHTML = typeRows
    ? `<div style="font-size:.8rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.04em;margin-bottom:.75rem;">This Session — By Type</div>
       <div class="bar-chart">${typeRows}</div>`
    : '';
}

function restartPractice() {
  document.getElementById('resultsScreen').style.display = 'none';
  document.getElementById('selectionScreen').style.display = 'block';
}

// ── Storage ────────────────────────────────
function saveResult(result) {
  const history = JSON.parse(localStorage.getItem('lsat_history') || '[]');
  history.unshift(result);
  if (history.length > 100) history.pop();
  localStorage.setItem('lsat_history', JSON.stringify(history));

  // Update section accuracy
  const acc = JSON.parse(localStorage.getItem('lsat_accuracy') || '{}');
  const section = result.section === 'mixed' ? 'mixed' : result.section;
  if (!acc[section]) acc[section] = { correct: 0, total: 0 };
  acc[section].correct += result.correct;
  acc[section].total += (result.total - result.skipped);
  localStorage.setItem('lsat_accuracy', JSON.stringify(acc));

  // Update per-question-type accuracy
  if (result.byType) {
    const typeAcc = JSON.parse(localStorage.getItem('lsat_type_accuracy') || '{}');
    Object.entries(result.byType).forEach(([type, data]) => {
      if (data.total === 0) return;
      if (!typeAcc[type]) typeAcc[type] = { correct: 0, total: 0 };
      typeAcc[type].correct += data.correct;
      typeAcc[type].total += data.total;
    });
    localStorage.setItem('lsat_type_accuracy', JSON.stringify(typeAcc));
  }

  // Total questions done
  const done = parseInt(localStorage.getItem('lsat_total') || '0') + (result.total - result.skipped);
  localStorage.setItem('lsat_total', done.toString());
}

// ── Utilities ──────────────────────────────
function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

// ── Init ───────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  applyURLParams();
  document.getElementById('selectionScreen').style.display = 'block';
});
