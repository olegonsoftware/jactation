set LOGSIZE=5000000000

docker buildx rm larger_log

docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=%LOGSIZE% --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=-1

