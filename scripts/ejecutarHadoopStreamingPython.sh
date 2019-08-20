$HADOOP_HOME/bin/hadoop  jar $HADOOP_STREAMING_HOME/hadoop-streaming.jar \
    -input myInputDirs \
    -output myOutputDir \
    -mapper /bin/cat \
    -reducer /bin/wc