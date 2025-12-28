/* --------------------------
   ГАМБУРГЕР-МЕНЮ
--------------------------- */
function toggleMenu() {
    document.getElementById('navMenu').classList.toggle('show');
}

/* --------------------------
   КАЛЬКУЛЯТОР ВОЛНЫ
--------------------------- */
function calculateWave() {
    // Считываем данные
    let GE = parseFloat(document.getElementById('GE').value);
    let HM = parseFloat(document.getElementById('HM').value);
    let T = parseFloat(document.getElementById('T').value);
    let AP = parseFloat(document.getElementById('AP').value);
    let WR = parseFloat(document.getElementById('WR').value);
    let D = parseFloat(document.getElementById('D').value);
    let rho = parseFloat(document.getElementById('rho').value);

    // Расчеты
    let EE = GE * HM * T * Math.exp(AP/10);
    let HS = T/HM + GE*WR;
    let GK = HM / (T + HS);
    let SVU = (D * rho) / (EE * WR * Math.log(AP+1));
    let energyWarning = EE > GK * 15 ? "⚠️ Энергокатастрофа!" : "✅ Волна безопасна";

    // Вывод
    document.getElementById('result').innerHTML = `
        <strong>Энергия волны (ЭЕ):</strong> ${EE.toFixed(2)} <br>
        <strong>Штормовой индекс (HS):</strong> ${HS.toFixed(2)} <br>
        <strong>Волновой коэффициент (GK):</strong> ${GK.toFixed(3)} <br>
        <strong>Сверх-Волновая Устойчивость (SVU):</strong> ${SVU.toFixed(2)} <br>
        <strong>Предупреждение:</strong> ${energyWarning}
    `;

    // Обновление графика
    if(typeof updateChart === 'function') updateChart(GE, EE);
}

/* --------------------------
   GRAPHS.JS - ДИНАМИЧЕСКИЕ ГРАФИКИ
--------------------------- */
let ctx = document.getElementById('chart') ? document.getElementById('chart').getContext('2d') : null;

let chart = ctx ? new Chart(ctx, {
    type: 'line',
    data: {
        labels: [],
        datasets: [{
            label: 'ЭЕ',
            data: [],
            borderColor: '#006064',
            backgroundColor: 'rgba(0,96,100,0.1)',
            fill: true,
            tension: 0.3
        }]
    },
    options: {
        scales: {
            x: { title: { display:true, text:'ГЕ' } },
            y: { title: { display:true, text:'ЭЕ' } }
        },
        plugins: {
            tooltip: {
                callbacks: {
                    label: function(context) {
                        let GE = context.label;
                        let EE = context.raw;
                        return `ГЕ: ${GE}, ЭЕ: ${EE.toFixed(2)}`;
                    }
                }
            }
        }
    }
}) : null;

// Добавление волны на график
function addWave() {
    let GE = parseFloat(document.getElementById('GE').value);
    let HM = parseFloat(document.getElementById('HM').value);
    let T = parseFloat(document.getElementById('T').value);
    let AP = parseFloat(document.getElementById('AP').value);
    let WR = parseFloat(document.getElementById('WR').value);

    let EE = GE * HM * T * Math.exp(AP/10);

    if(chart){
        chart.data.labels.push(GE);
        chart.data.datasets[0].data.push(EE);
        chart.update();
    }
}

// Сброс графика
function resetChart() {
    if(chart){
        chart.data.labels = [];
        chart.data.datasets[0].data = [];
        chart.update();
    }
}

// Функция для калькулятора обновления графика (если есть)
function updateChart(GE, EE){
    if(chart){
        chart.data.labels.push(GE);
        chart.data.datasets[0].data.push(EE);
        chart.update();
    }
}

/* --------------------------
   ПОП-АП ПРЕДУПРЕЖДЕНИЯ
--------------------------- */
function showWarning(message){
    let warningDiv = document.createElement('div');
    warningDiv.textContent = message;
    warningDiv.style.position = 'fixed';
    warningDiv.style.bottom = '20px';
    warningDiv.style.right = '20px';
    warningDiv.style.backgroundColor = 'rgba(255,0,0,0.8)';
    warningDiv.style.color = '#fff';
    warningDiv.style.padding = '10px 15px';
    warningDiv.style.borderRadius = '5px';
    warningDiv.style.zIndex = 1000;
    document.body.appendChild(warningDiv);
    setTimeout(()=>warningDiv.remove(), 4000);
}