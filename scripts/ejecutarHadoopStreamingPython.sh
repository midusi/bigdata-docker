chmod 777 $3 $4

$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING_HOME/hadoop-streaming.jar \
    -input $1 \
    -output $2 \
    -mapper $3 \
    -reducer $4