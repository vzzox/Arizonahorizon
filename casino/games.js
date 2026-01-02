// --- СТЕЙТ ПОЛЬЗОВАТЕЛЯ ---
let currentUser = null;
let users = {}; // структура: {username: {password, balance}}

// --- ФУНКЦИЯ РЕГИСТРАЦИИ ---
function register(username, password) {
  if (users[username]) {
    alert("Пользователь уже существует!");
    return false;
  }
  users[username] = { password: password, balance: 1000 }; // стартовый баланс 1000 фишек
  alert("Регистрация успешна! Баланс: 1000 фишек");
  currentUser = username;
  renderCasino();
  return true;
}

// --- ФУНКЦИЯ ВХОДА ---
function login(username, password) {
  if (!users[username]) {
    alert("Пользователь не найден!");
    return false;
  }
  if (users[username].password !== password) {
    alert("Неверный пароль!");
    return false;
  }
  currentUser = username;
  alert(`Добро пожаловать, ${username}! Баланс: ${users[username].balance}`);
  renderCasino();
  return true;
}

// --- ФУНКЦИЯ СДЕЛАТЬ СТАВКУ ---
function placeBet(gameId, amount) {
  if (!currentUser) {
    alert("Сначала войдите в аккаунт!");
    return;
  }
  const game = games.find(g => g.id === gameId);
  if (!game) return;

  if (amount < game.minBet || amount > game.maxBet) {
    alert(`Ставка должна быть от ${game.minBet} до ${game.maxBet} фишек.`);
    return;
  }

  if (users[currentUser].balance < amount) {
    alert("Недостаточно фишек на балансе!");
    return;
  }

  // Генерация выигрыша/проигрыша (50/50)
  const win = Math.random() < 0.5;
  if (win) {
    const winnings = amount * 2; // двойной выигрыш
    const tax = winnings * 0.2; // 20% в казну
    users[currentUser].balance += winnings - tax;
    alert(`Вы выиграли ${winnings - tax} фишек! 20% (${tax}) ушло в казну.`);
  } else {
    users[currentUser].balance -= amount;
    alert(`Вы проиграли ${amount} фишек.`);
  }

  renderCasino();
}

// --- ФУНКЦИЯ РЕНДЕРА КАЗИНО ---
function renderCasino() {
  const container = document.getElementById("casino");
  container.innerHTML = "";

  // Если не авторизован — показываем форму входа/регистрации
  if (!currentUser) {
    const loginCard = document.createElement("div");
    loginCard.className = "card";
    loginCard.innerHTML = `
      <h2>Вход / Регистрация</h2>
      <input id="username" placeholder="Логин"><br><br>
      <input id="password" type="password" placeholder="Пароль"><br><br>
      <button id="btnLogin">Войти</button>
      <button id="btnRegister">Зарегистрироваться</button>
    `;
    container.appendChild(loginCard);

    document.getElementById("btnLogin").onclick = () => login(
      document.getElementById("username").value,
      document.getElementById("password").value
    );

    document.getElementById("btnRegister").onclick = () => register(
      document.getElementById("username").value,
      document.getElementById("password").value
    );

    return;
  }

  // Показ баланса пользователя
  const balanceCard = document.createElement("div");
  balanceCard.className = "card";
  balanceCard.innerHTML = `<h2>Баланс: ${users[currentUser].balance} фишек</h2>`;
  container.appendChild(balanceCard);

  // Рендер всех игр
  games.forEach(game => {
    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
      <h2>${game.name}</h2>
      <p>${game.description}</p>
      <p>Ставка: от ${game.minBet} до ${game.maxBet} фишек</p>
      <input type="number" id="bet${game.id}" placeholder="Сумма ставки"><br>
      <button onclick="placeBet(${game.id}, Number(document.getElementById('bet${game.id}').value))">Сделать ставку</button>
    `;
    container.appendChild(card);
  });
}

// --- ПЕРВОНАЧАЛЬНЫЙ РЕНДЕР ---
renderCasino();