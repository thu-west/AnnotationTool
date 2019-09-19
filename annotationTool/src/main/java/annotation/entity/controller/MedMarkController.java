package annotation.entity.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.sql.Insert;
import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;
import org.neo4j.register.Register.Int;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import annotation.model.Entity;
import annotation.model.MedicalHistory;
import annotation.model.OtherFeatures;
import annotation.neo4j.Neo4jConnection;
import annotation.other.HibernateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import scala.util.control.TailCalls.Done;

@Controller
public class MedMarkController {

	String path = "mark/";

	// 接收添加标注的请求并做读写数据库处理
	@RequestMapping(value = "/jsonmark", method = RequestMethod.POST, produces = { "text/html;charset=UTF-8;",
			"application/json;" })
	public String saveJsonUser(@RequestBody String str, Model model, HttpServletRequest request,
			HttpServletResponse response) throws SQLException {

		response.setContentType("text/html;charset=UTF-8");
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json.get("content"));
		// 得到文本框中所有内容，包括span标签
		String content = json.get("content").toString();

		// String filename =
		// request.getSession().getAttribute("filename").toString();
		String caseNumber = request.getSession().getAttribute("caseNumber").toString();

		// writeByFileOutputStream(content, filename);

		JSONArray jsonArray = new JSONArray();
		int count = 0;
		while (content.indexOf("<span") != -1) {
			JSONObject json1 = new JSONObject();
			int index = content.indexOf("<span");
			int mid = content.indexOf(">");
			mid += 1;

			int lab = content.indexOf("lab");
			lab += 5;
			String label = content.substring(lab, lab + 1);

			// 去除span前标签
			content = content.substring(0, index) + content.substring(mid, content.length());
			int endindex = content.indexOf("</span>");

			int markindex = content.indexOf("/");
			// 得到实体type
			String type = content.substring(markindex, endindex);

			// span后标签</span>
			content = content.substring(0, markindex) + content.substring(endindex + 7, content.length());
			json1.put("pos", index + "," + markindex);
			json1.put("content", content.substring(index, markindex));
			json1.put("type", type);
			json1.put("label", label);
			jsonArray.add(json1);

			count++;
		}
		JSONObject newAnno = new JSONObject();
		for (int i = 0; i < jsonArray.size(); i++) {
			System.out.println(count + " " + jsonArray.getJSONObject(i).getString("label"));

			if (count == Integer.parseInt(jsonArray.getJSONObject(i).getString("label"))) {
				newAnno = jsonArray.getJSONObject(i);
				break;
			}
			newAnno = jsonArray.getJSONObject(i);
		}
		// 去掉span标签和/d之后的字符串应和原文件的原数据一样
		System.out.println(content);
		// 要保存的标注列表
		for (int i = 0; i < jsonArray.size(); i++) {
			System.out.println(jsonArray.get(i).toString());
		}

		newAnno.put("caseNumber", caseNumber);

		String un = request.getSession().getAttribute("sessionusername").toString();
		Long number = judgeExist(newAnno);
		if (number<1) {
			insertByHibernate(newAnno, un);
		}
	//	insertByHibernate(newAnno, un);
		System.out.println(newAnno);

		// insert Neo4j
		// insertNeo4jByjdbc(newAnno);
		return null;
	}


	// 提交并更新数据库为done
	@RequestMapping(value = "/updatetext", method = RequestMethod.POST, produces = { "text/html;charset=UTF-8;",
			"application/json;" })
	public void updateText(Model model, HttpServletRequest request, HttpServletResponse response)
			throws SQLException {

		response.setContentType("text/html; charset=utf-8");
		String caseNumber = request.getSession().getAttribute("caseNumber").toString();
		int age = (int) request.getSession().getAttribute("age");
		String sex = (String) request.getSession().getAttribute("sex");
				
        String[] values = request.getParameterValues("history");
        String history = StringUtils.join(values, ";");
        String pain_level = request.getParameter("pain_level");
        String pain_frequency = request.getParameter("pain_frequency");
        String acute = request.getParameter("acute");
        String disease_name =request.getParameter("disease_name");
        String lvef = request.getParameter("LVEF");
        String[] ucgs= request.getParameterValues("UCG");
        String ucg = StringUtils.join(ucgs, ";");
        //String ucg = request.getParameter("ucg");
        //提交表单把其他特征插入数据库
        insertOtherFeatures(age,sex,caseNumber,history,pain_level,pain_frequency,acute,ucg,lvef,disease_name);
		
        Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			
	        //标注完成后更改状态  
			session.beginTransaction();			
			String hql = "update MedicalHistory m set m.status ='done' where jbxx_dengjihao = \'" + caseNumber + "\'";
			Query query = session.createQuery(hql);
			query.executeUpdate();
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}
		System.out.println(caseNumber);
		//return null;
	}


	public void insertOtherFeatures(int age,String sex,String casenumber,String history, String pain_level, String pain_frequency, String acute,
			String ucg, String lvef, String disease_name) {
		// 读取配置文件
		Configuration cfg = new Configuration().configure();
		SessionFactory factory = cfg.buildSessionFactory();
		Session session = null;
		try {
			session = factory.openSession();
			// 开启事务
			session.beginTransaction();
			OtherFeatures of = new OtherFeatures();
			if (sex.contains("男")) {
				sex = "1";
			}
			else {
				sex = "2";
			}
			of.setNianling(age);
			of.setXingbie(sex);
			of.setDengjihao(casenumber);
			of.setBingshi(history);
			of.setJixing(acute);
			of.setXiongtongchengdu(pain_level);
			of.setUcg(ucg);
			of.setLvef(lvef);
			of.setDiseasename(disease_name);
			// save time
			Date dt = new Date();
			DateFormat dformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = dformat.format(dt);
			Timestamp t1 = Timestamp.valueOf(time);
			of.setTime(t1);
			session.save(of);
			// 提交事务
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					// 关闭session
					session.close();
				}
			}
		}

	}

	public void insertNeo4jByjdbc(JSONObject json) throws SQLException {
		Neo4jConnection ncon = new Neo4jConnection();
		Connection con = ncon.connect();
		String type = json.getString("type");
		if (type.equals("/d")) {
			try (Statement stmt = con.createStatement()) {
				String str = "create (a:疾病{name:'" + json.getString("content") + "',type:'" + json.getString("type")
						+ "',filename:'" + json.getString("filename") + "'})";
				stmt.executeQuery(str);
				System.out.println("insert a diseaseNode");
				stmt.close();
				con.close();
			}
		} else if (type.equals("/s")) {
			try (Statement stmt = con.createStatement()) {
				String str = "create (b:症状{name:'" + json.getString("content") + "',type:'" + json.getString("type")
						+ "',filename:'" + json.getString("filename") + "'})";
				stmt.executeQuery(str);
				System.out.println("insert a symptomNode");
				stmt.close();
				con.close();
			}
		} else if (type.equals("/c")) {
			try (Statement stmt = con.createStatement()) {
				String str = "create (c:检查{name:'" + json.getString("content") + "',type:'" + json.getString("type")
						+ "',filename:'" + json.getString("filename") + "'})";
				stmt.executeQuery(str);
				System.out.println("insert a checkNode");
				stmt.close();
				con.close();
			}
		} else if (type.equals("/t")) {
			try (Statement stmt = con.createStatement()) {
				String str = "create (a:治疗{name:'" + json.getString("content") + "',type:'" + json.getString("type")
						+ "',filename:'" + json.getString("filename") + "'})";
				stmt.executeQuery(str);
				System.out.println("insert a treamentNode");
				stmt.close();
				con.close();
			}
		}
	}

	@RequestMapping(value = "/jsonDelLabel", method = RequestMethod.POST, produces = { "text/html;charset=UTF-8;",
			"application/json;" })
	public String jsonDelLabel(@RequestBody String str, Model model, HttpServletRequest request,
			HttpServletResponse response) {

		response.setContentType("text/html;charset=UTF-8");
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);
		deleteByContent(json.getString("content"));
		return null;
	}

	public void deleteByContent(String content) {
		Entity anno = null;
		Session session = null;
		List<Integer> results = new ArrayList<Integer>();
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			String hql = "SELECT id FROM Entity where content = \'" + content + "\'";
			Query query = session.createQuery(hql);
			results = query.list();
			// label = (Labels)session.get(Labels.class,
			// results.get(0).getId());
			System.out.println(results.get(0));

			anno = new Entity();
			anno.setId(results.get(0));
			session.delete(anno);
			session.getTransaction().commit();
			// System.out.println(results.get(0));

		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(session);
		}

		return;
	}

	public Entity query(String pos) {
		Entity a = null;
		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			String hql = "SELECT pos FROM entity where pos = \'" + pos + "\'";
			Query query = session.createQuery(hql);
			List<Integer> results = query.list();

			a = (Entity) session.get(Entity.class, results.get(0));
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}
		return a;
	}

	public void deleteAll() {
		Configuration cfg = new Configuration().configure();
		String hql = "delete from entity where pos = '*'";
		SessionFactory factory = cfg.buildSessionFactory();

		Session session = null;
		try {
			session = factory.openSession();
			// 开启事务
			session.beginTransaction();

			Query q = session.createQuery(hql);

			session.getTransaction().commit();

		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					// 关闭session
					session.close();
				}
			}
		}
	}
//判断数据库中是否已插入相同位置的相同内容
	public Long judgeExist(JSONObject jo) {
		Configuration cfg = new Configuration().configure();

		SessionFactory factory = cfg.buildSessionFactory();

		Session session = null;
		Long count = null;
		try {
			session = factory.openSession();
			// 开启事务
			session.beginTransaction();		
			String hql = "SELECT count(*) FROM Entity where content = \'" + jo.getString("content") + "\' and pos =\'" + jo.getString("pos") + "\' and number =\'" + jo.getString("caseNumber") + "\' ";
			Query query = session.createQuery(hql);
		    count = (Long) query.uniqueResult();
			System.out.println("数据库中已存在"+count);
			
			// 提交事务
			session.getTransaction().commit();		

		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					// 关闭session
					session.close();
				}
			}
		}
		return count;
	}

	public void insertByHibernate(JSONObject jo, String username) {
		// 读取配置文件
		Configuration cfg = new Configuration().configure();

		SessionFactory factory = cfg.buildSessionFactory();

		Session session = null;
		try {
			session = factory.openSession();
			// 开启事务
			session.beginTransaction();		
			
			Entity annotation = new Entity();
			annotation.setPos(jo.getString("pos"));
			annotation.setContent(jo.getString("content"));
			annotation.setTag(jo.getString("type"));
			// annotation.setFilename(jo.getString("filename"));
			annotation.setNumber(Integer.parseInt(jo.getString("caseNumber")));
			annotation.setUsername(username);
			// save time
			Date dt = new Date();
			DateFormat dformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = dformat.format(dt);
			Timestamp t1 = Timestamp.valueOf(time);
			annotation.setTime(t1);
			// save operation
			annotation.setOperation("add");
			session.save(annotation);

			// 提交事务
			session.getTransaction().commit();		

		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			session.getTransaction().rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					// 关闭session
					session.close();
				}
			}
		}
	}

	public ArrayList<String> readTxtFile(String filePath) {
		try {
			String encoding = "UTF-8";
			File file = new File(filePath);
			if (file.isFile() && file.exists()) { // 判断文件是否存在
				InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);// 考虑到编码格式
				BufferedReader bufferedReader = new BufferedReader(read);
				String lineTxt = null;
				ArrayList<String> list = new ArrayList<String>();
				while ((lineTxt = bufferedReader.readLine()) != null) {
					// System.out.println(lineTxt);
					list.add(lineTxt);
				}
				read.close();
				return list;
			} else {
				System.out.println("找不到指定的文件");
				return null;
			}
		} catch (Exception e) {
			System.out.println("读取文件内容出错");
			e.printStackTrace();
			return null;
		}

	}

	public void writeByFileOutputStream(JSONArray mark, String filename) {

		FileOutputStream fop = null;
		File file;
		String newLine = "\r\n";

		try {

			if (filename.substring(filename.length() - 4, filename.length()).equals(".new")) {
				filename = filename.substring(0, filename.length() - 4);
				file = new File(path + filename + ".ent");

			} else
				file = new File(path + filename + ".ent");

			// file = new
			// File("C:/Users/Administrator/Desktop/"+filename+".ent");
			File fileParent = file.getParentFile();
			if (!fileParent.exists()) {
				fileParent.mkdirs();
			}
			file.createNewFile();
			fop = new FileOutputStream(file, false);

			BufferedWriter rd = new BufferedWriter(new OutputStreamWriter(fop, "utf-8"));
			// get the content in bytes
			// byte[] contentInBytes = (str+newLine).getBytes();

			String allmark = "";
			for (int i = 0; i < mark.size(); i++) {
				String str = mark.get(i).toString();
				allmark += str + newLine;
			}
			rd.write(allmark + newLine);

			// rd.write(contentInBytes);
			fop.flush();
			rd.close();
			fop.close();

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fop != null) {
					fop.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void writeByFileOutputStream(String str, String filename) {

		FileOutputStream fop = null;
		File file;
		String newLine = "\r\n";

		try {
			if (filename.substring(filename.length() - 4, filename.length()).equals(".new"))
				file = new File(path + filename);
			else
				file = new File(path + filename + ".new");

			File fileParent = file.getParentFile();
			if (!fileParent.exists()) {
				fileParent.mkdirs();
			}
			file.createNewFile();
			fop = new FileOutputStream(file, false);

			BufferedWriter rd = new BufferedWriter(new OutputStreamWriter(fop, "utf-8"));
			// get the content in bytes
			// byte[] contentInBytes = (str+newLine).getBytes();
			rd.write(str + newLine);

			// rd.write(contentInBytes);
			fop.flush();
			rd.close();
			fop.close();

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fop != null) {
					fop.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

}

class SortByStart implements Comparator {
	public int compare(Object o1, Object o2) {
		String s1 = (String) o1;
		String s2 = (String) o2;
		JSONObject mark1 = JSONObject.fromObject(s1);
		JSONObject mark2 = JSONObject.fromObject(s2);
		if (Integer.parseInt(mark1.get("start").toString()) < Integer.parseInt(mark2.get("start").toString()))
			return 1;
		return 0;
	}
}
