setlocal enableextensions enabledelayedexpansion

set D=%~dp0
set S=%~dpnx0

call %D%kits.bat
call %D%env.bat

set DEFAULT_URL=http://localhost:8080/owners
if not ["%~1"]==[""] (
    set DEFAULT_URL=%~1
)
echo Using URL: %DEFAULT_URL%

if ["%~1"]==[""] (
    (for %%a in (%KITS%) do (
       echo "Using build kit:   %%a"
       call :maketest %%a %DEFAULT_URL%
    ))
) else (
    echo "Skipping benchmarks"
)

SET ALLKITS=
for %%a in (%KITS%) do (
if .!ALLKITS!==. (
    SET ALLKITS=%%a
) ELSE (
    SET ALLKITS=!ALLKITS!,%%a
)
)
SET ALLKITS


call :makeplots %ALLKITS%

echo "DONE"

goto :EOF



REM ======================================================================================
:maketest

set CONFIG=%~1
set TEST_URL=%~2

echo "Running benchmarks for %CONFIG%"
docker rm petclinic-benchmark-%CONFIG%
docker run -e TEST_URL=%TEST_URL% --memory=3g --mount type=bind,source=%D%benchmark.sh,target=/home/myapp/benchmark.sh --name petclinic-benchmark-%CONFIG% petclinic-benchmark-%CONFIG%:v1

echo "Making copy of logs into %LOGDIR%"
mkdir %LOGDIR%
docker cp petclinic-benchmark-%CONFIG%:/home/myapp/log %LOGDIR%/%CONFIG%-log
echo "Benchmarks for %CONFIG% [DONE]"

REM /:maketest
EXIT /B 0
REM ======================================================================================



REM ======================================================================================
:makeplots

set PYTHON_PARAMS="%*"

echo "Creating plots for for %PYTHON_PARAMS%"
docker rm tools-python
docker run ^
--mount type=bind,source=%D%/plots.py,target=/home/myapp/plots.py ^
--mount type=bind,source=%D%/logs,target=/home/myapp/logs ^
--name tools-python ^
tools-python:v1 python ^
/home/myapp/plots.py %PYTHON_PARAMS%


echo "Making copy of logs into %LOGDIR%"
mkdir %LOGDIR%
docker cp tools-python:/home/myapp/plot/. %LOGDIR%
echo "Plots for %PYTHON_PARAMS% [DONE]"

REM /:makeplots
EXIT /B 0
REM ======================================================================================



:EOF