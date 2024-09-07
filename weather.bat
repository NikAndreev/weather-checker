@echo off
chcp 65001

if not exist .env (
  echo .env файл не найден!
  pause
  exit /b
)

set /p userName=Как тебя зовут? 

echo Рад видеть тебя, %userName%! Выбери город:

choice /c mlt /m "Москва, Лондон или Токио"

if errorlevel 1 set city=Moscow
if errorlevel 2 set city=London
if errorlevel 3 set city=Tokyo

setlocal enabledelayedexpansion

for /f "tokens=1,2 delims==" %%a in (.env) do (
  if "%%a"=="WEATHER_API_KEY" set "WEATHER_API_KEY=%%b"
)

curl "https://api.openweathermap.org/data/2.5/weather?q=%city%&units=metric&appid=!WEATHER_API_KEY!" -s -o weather.json

endlocal

powershell -Command ^
    "$data = Get-Content weather.json | ConvertFrom-Json; " ^
    "Write-Host ('Погода в ' + $data.name + ':'); " ^
    "Write-Host ('Температура: ' + [string]$data.main.temp + ' °C'); " ^
    "Write-Host ('Ощущается как: ' + [string]$data.main.feels_like + ' °C'); " ^
    "Write-Host ('Описание: ' + $data.weather[0].description); " ^
    "Write-Host ('Влажность: ' + [string]$data.main.humidity + '%%'); " ^
    "Write-Host ('Скорость ветра: ' + [string]$data.wind.speed + ' м/с'); "

pause
