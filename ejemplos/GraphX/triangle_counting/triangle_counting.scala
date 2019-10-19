import org.apache.spark.graphx.{GraphLoader, PartitionStrategy}
import org.apache.spark.sql.SparkSession

/**
 * A vertex is part of a triangle when it has two adjacent vertices with an edge between them.
 * GraphX implements a triangle counting algorithm in the [`TriangleCount` object][TriangleCount]
 * that determines the number of triangles passing through each vertex,
 * providing a measure of clustering.
 * We compute the triangle count of the social network dataset.
 *
 * Note that `TriangleCount` requires the edges to be in canonical orientation (`srcId < dstId`)
 * and the graph to be partitioned using [`Graph.partitionBy`][Graph.partitionBy].
 */

// Creates a SparkSession.
val spark = SparkSession
    .builder
    .appName(s"${this.getClass.getSimpleName}")
    .getOrCreate()
val sc = spark.sparkContext

// Load the edges in canonical order and partition the graph for triangle count
val graph = GraphLoader.edgeListFile(sc, "../data/followers.txt", true)
    .partitionBy(PartitionStrategy.RandomVertexCut)
// Find the triangle count for each vertex
val triCounts = graph.triangleCount().vertices
// Join the triangle counts with the usernames
val users = sc.textFile("../data/users.txt").map { line =>
    val fields = line.split(",")
    (fields(0).toLong, fields(1))
}
val triCountByUsername = users.join(triCounts).map { case (id, (username, tc)) =>
    (username, tc)
}

// Print the result
println(triCountByUsername.collect().mkString("\n"))
spark.stop()

// Close Spark-shell
System.exit(0)