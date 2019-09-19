package annotation.neo4j;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.neo4j.jdbc.Driver;

public class Neo4jConnection {
	public Connection con = null;

	public Connection connect() throws SQLException {
		Driver driver = new Driver();
		DriverManager.registerDriver(driver);

		/*Connection con = (Connection) DriverManager.getConnection("jdbc:neo4j:http://localhost:7474/", "neo4j",
				"123456");*/
		Connection con = (Connection) DriverManager.getConnection("jdbc:neo4j:http://localhost:7474/", "neo4j",
				"123456");
		if (con != null) {
			System.out.println("Succeed to link Neo4jdatabase!");
		}
		return con;
	}

	public void close() {
		try {
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
