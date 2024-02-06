@echo off
setlocal EnableDelayedExpansion

:: Definindo os valores do array
set array[0]=100
set array[1]=200
set array[2]=300
set array[3]=400
set array[4]=500
set array[5]=650

rem Definir uma variável de ambiente para armazenar a hora atual
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a

rem Formatar a hora atual para incluir apenas caracteres válidos em nomes de diretórios
set formatted_datetime=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!-!datetime:~10,2!

:: Acessando e exibindo os valores do array
for /l %%i in (0,1,5) do (
    set /a numeroDeUsuarios=!array[%%i]!

    rem Iniciar o Docker Compose
    docker-compose up -d

    rem Aguardar alguns segundos para garantir que os serviços estejam totalmente iniciados
    timeout /t 10

    rem Iniciar a tarefa no Locust com os parâmetros especificados
    locust -f .\path\to\locust-scripts\locustfile.py --headless -u !numeroDeUsuarios! -r 10 -t 5m --csv result --host=http://localhost:80

    rem Renomear e mover os arquivos de análise para a pasta criada com o número de usuários no nome
    set result_path=analysis_results_!formatted_datetime!_!numeroDeUsuarios!_user
    mkdir !result_path!
    move .\result_stats.csv !result_path!\result_stats_!numeroDeUsuarios!.csv

    rem Encerrar os serviços do Docker Compose
    docker-compose down
)

endlocal
