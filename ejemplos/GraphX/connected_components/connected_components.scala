import org.apache.spark.graphx.GraphLoader
import org.apache.spark.sql.SparkSession

/**
 * A connected components algorithm example.
 * The connected components algorithm labels each connected component of the graph
 * with the ID of its lowest-numbered vertex.
 * For example, in a social network, connected components can approximate clusters.
 * GraphX contains an implementation of the algorithm in the
 * [`ConnectedComponents` object][ConnectedComponents],
 * and we compute the connected components of the example social network dataset.
 */

// Creates a SparkSession.
val spark = SparkSession
    .builder
    .appName(s"${this.getClass.getSimpleName}")
    .getOrCreate()
val sc = spark.sparkContext

// Load the graph as in the PageRank example
val graph = GraphLoader.edgeListFile(sc, "../data/followers.txt")
// Find the connected components
val cc = graph.connectedComponents().vertices
// Join the connected components with the usernames
val users = sc.textFile("../data/users.txt").map { line =>
    val fields = line.split(",")
    (fields(0).toLong, fields(1))
}
val ccByUsername = users.join(cc).map {
    case (id, (username, cc)) => (username, cc)
}

// Print the result
println(ccByUsername.collect().mkString("\n"))
spark.stop()

// Close Spark-shell
System.exit(0)