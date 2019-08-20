$HADOOP_HOME/bin/hadoop  jar $HADOOP_STREAMING_HOME/hadoop-streaming.jar \
    -input file:///home/big_data/practica/WordCount/pruebaPalabras.txt \
    -output /resultados_python_streaming \
    -mapper /home/big_data/practica/WordCount/Python/mapper.py \
    -reducer /home/big_data/practica/WordCount/Python/reducer.py