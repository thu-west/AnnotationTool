package annotation.relation.controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;
import org.hibernate.Session;
import org.neo4j.graphdb.Relationship;
import org.neo4j.graphdb.ResourceIterator;
import org.neo4j.graphdb.Result;
import org.neo4j.graphdb.Transaction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import annotation.neo4j.Neo4jConnection;
import annotation.other.HibernateUtil;
import annotation.model.Relation;
import net.sf.json.JSONObject;


//jsonDelRelation

@Controller
public class relationController {
	@RequestMapping(value="/jsonRelation",method=RequestMethod.POST, produces={"text/html;charset=UTF-8;","application/json;"})
	public String saveJsonUser(@RequestBody String str, Model model,HttpServletRequest request,
			HttpServletResponse response) throws SQLException{
		
		response.setContentType("text/html;charset=UTF-8");  
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json.toString());
		
		
		String filename = request.getSession().getAttribute("filename").toString();
		String un = request.getSession().getAttribute("sessionusername").toString();
		json.put("filename", filename);
		insertByHibernate(json,un);
		// insert Neo4j
		insertNeo4jByjdbc(json);
		return null;
		
	}
	
	public void insertNeo4jByjdbc(JSONObject json) throws SQLException {
		// TODO Auto-generated method stub
		Neo4jConnection ncon = new Neo4jConnection();
		Connection con = ncon.connect();
		try (Statement stmt = con.createStatement()) {
			// match(n{name:"头晕"}),(d{name:"发作性心悸"}) create(n)-[r:症状导致疾病]->(d) return n,d,r
			String str = "match (a{name:'"+json.getString("model1")+"',"
					+ "filename:'"+json.getString("filename")+"'}),(b{name:'"+json.getString("model2")+"',"
					+ "filename:'"+json.getString("filename")+"'}) create(a)-[r:"+json.getString("relation")+"]->(b) return a,b,r";
		    stmt.executeQuery(str);
		    System.out.println("insert a relationship");
		    stmt.close();
		    con.close();
		}
	}


	public void insertByHibernate(JSONObject jo, String username){
		
		Session session = null;
		try{
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
	
			Relation relation = new Relation();
			relation.setEntity1(jo.getString("model1"));
			relation.setEntity2(jo.getString("model2"));
			relation.setColor1(jo.getString("color1"));
			relation.setColor2(jo.getString("color2"));
			relation.setUsername(username);
			relation.setFilename(jo.getString("filename"));
			relation.setRelation(jo.getString("relation"));
			
			session.save(relation);
		

			//提交事务
			session.getTransaction().commit();
			
		}catch(Exception e){
			e.printStackTrace();
			//回滚事务
			session.getTransaction().rollback();
		}finally{
			HibernateUtil.closeSession(session);
		}
	}
	
	@RequestMapping(value="/jsonDelRelation",method=RequestMethod.POST, produces={"text/html;charset=UTF-8;","application/json;"})
	public String jsonDelLabel(@RequestBody String str, Model model,HttpServletRequest request,
			HttpServletResponse response){
		
		response.setContentType("text/html;charset=UTF-8");  
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);
		deleteBy2Models(json);
		return null;
	}
	public void deleteBy2Models(JSONObject jo)
	{
		Relation rel = null;
		Session session = null;
		List<Integer> results = new ArrayList<Integer>();
		try{
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			String hql = "SELECT id FROM Relation where entity1 = \'"+jo.getString("model1")+"\'"+"and entity2 =\'"+jo.getString("model2")+"\'";
			Query query = session.createQuery(hql);
			results = query.list();			

			System.out.println(results.get(0));
			
			rel = new Relation();
			rel.setId(results.get(0));
			session.delete(rel);
			session.getTransaction().commit();
//			System.out.println(results.get(0));
			
		}catch(Exception e)
		{
			e.printStackTrace();
			session.getTransaction().rollback();
		}finally{
			HibernateUtil.closeSession(session);
		}
		
		return;
	}
	
}
