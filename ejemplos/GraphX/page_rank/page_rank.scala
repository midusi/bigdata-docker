import org.apache.spark.graphx.GraphLoader
import org.apache.spark.sql.SparkSession


/**
 * A PageRank example on social network dataset
 */

// Creates a SparkSession.
val spark = SparkSession
    .builder
    .appName(s"${this.getClass.getSimpleName}")
    .getOrCreate()
val sc = spark.sparkContext

// Load the edges as a graph
val graph = GraphLoader.edgeListFile(sc, "../data/followers.txt")
// Run PageRank
val ranks = graph.pageRank(0.0001).vertices
// Join the ranks with the usernames
val users = sc.textFile("../data/users.txt").map { line =>
    val fields = line.split(",")
    (fields(0).toLong, fields(1))
}
val ranksByUsername = users.join(ranks).map {
    case (id, (username, rank)) => (username, rank)
}

// Print the result
println(ranksByUsername.collect().mkString("\n"))
spark.stop()

// Close Spark-shell
System.exit(0)