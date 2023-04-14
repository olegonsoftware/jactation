set D=%~dp0
set S=%~dpnx0

call %D%kits.bat
call %D%env.bat


REM ======================================================================================
:: Checking arguments

::-------------------------- has argument ?
if ["%~1"]==[""] (
    echo "Building JAR"
    call :makejar
    goto end
)
::-------------------------- argument exist ?
if not exist "%APPJAR%" (
        echo "The script must use your custom app, but it doesn't exist: %APPJAR%"
    ) else (
    if exist %APPJAR%\NUL (
      echo "The script must use your custom app as a JAR file, but the path points to a directory: %APPJAR%"
    ) else (
      echo "The script will use your custom app: %APPJAR%"
    )
)
::-------------------------- arguments are ok !

:end
REM ======================================================================================

call :maketools

(for %%a in (%KITS%) do (
   echo "Using build kit:   %%a"
   call :makeenv %%a
))

goto :EOF



REM ======================================================================================
:makejar

echo "Building Spring Petclinic into %APPJAR%"
docker buildx bake --progress plain --load -f bake.hcl jar

set SRCJAR=/home/myapp/spring-petclinic-main/target/spring-petclinic-3.0.0-SNAPSHOT.jar
docker run --rm --entrypoint cat petclinic-builder:v1 %SRCJAR% > %APPJAR%
echo "Building JAR [DONE]"

REM /:makejar
EXIT /B 0
REM ======================================================================================



REM ======================================================================================
:maketools

echo "Building Benchmark Tools"
docker buildx bake --progress plain --load -f bake.hcl tools
echo "Building Benchmark Tools [DONE]"

REM /:maketools
EXIT /B 0
REM ======================================================================================



REM ======================================================================================
:makeenv

set CONFIG=%~1
docker buildx bake --progress plain --load -f bake.hcl -f kit/Bakefile.petclinic-%CONFIG% %CONFIG%

REM /:makeenv
EXIT /B 0
REM ======================================================================================



:EOF