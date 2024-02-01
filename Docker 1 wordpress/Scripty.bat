@echo off

rem Definir uma variável de ambiente para armazenar a hora atual
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a

rem Formatar a hora atual para incluir apenas caracteres válidos em nomes de diretórios
set formatted_datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%

rem Iniciar o Docker Compose
docker-compose up -d

rem Aguardar alguns segundos para garantir que os serviços estejam totalmente iniciados
timeout /t 10

rem Iniciar a tarefa no Locust com os parâmetros especificados
locust -f .\path\to\locust-scripts\locustfile.py --headless -u 100 -r 10 -t 1m --csv result --host=http://localhost:80

rem Criar uma pasta com o nome formatado que inclui a hora atual
mkdir analysis_results_%formatted_datetime%

rem Mover os arquivos de análise para a pasta criada
move .\*.csv analysis_results_%formatted_datetime%\

rem Encerrar os serviços do Docker Compose
docker-compose down

@echo off
