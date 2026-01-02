// Неоновый эффект на карточках
document.querySelectorAll('.card').forEach(card => {
  card.addEventListener('mousemove', e => {
    const rect = card.getBoundingClientRect();
    // Считаем позицию мыши внутри карточки
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    // Передаем CSS переменные для ::before
    card.style.setProperty('--x', x + 'px');
    card.style.setProperty('--y', y + 'px');
  });

  // Сброс эффекта, когда мышь уходит
  card.addEventListener('mouseleave', () => {
    card.style.setProperty('--x', '50%');
    card.style.setProperty('--y', '50%');
  });
});