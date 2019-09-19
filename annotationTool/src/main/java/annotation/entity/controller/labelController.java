package annotation.entity.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import annotation.model.EntityLabel;
import annotation.other.HibernateUtil;
import net.sf.json.JSONObject;

@Controller
public class labelController {
	String path = "mark/";

	@RequestMapping(value = "/addLabel", method = RequestMethod.POST, produces = { "text/html;charset=UTF-8;",
			"application/json;" })
	public String addLabel(@RequestBody String str, Model model, HttpServletRequest request,
			HttpServletResponse response) {

		response.setContentType("text/html;charset=UTF-8");
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);

		//String filename = request.getSession().getAttribute("filename").toString();
		//writeByFileOutputStream(str, filename);
		String caseNumber = request.getSession().getAttribute("caseNumber").toString();
		
		String un = request.getSession().getAttribute("sessionusername").toString();
		insertByHibernate(json, un);
		return null;
	}

	@RequestMapping(value = "/jsonDelEntityBtn", method = RequestMethod.POST, produces = { "text/html;charset=UTF-8;",
			"application/json;" })
	public String jsonDelLabel(@RequestBody String str, Model model, HttpServletRequest request,
			HttpServletResponse response) {

		response.setContentType("text/html;charset=UTF-8");
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);
		deleteByContent(json.getString("value"));
		return null;
	}

	public void deleteByContent(String content) {
		EntityLabel label = null;
		Session session = null;
		List<Integer> results = new ArrayList<Integer>();
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			String hql = "SELECT id FROM EntityLabel where content = \'" + content + "\'";
			Query query = session.createQuery(hql);
			results = query.list();
			// label = (Labels)session.get(Labels.class,
			// results.get(0).getId());
			System.out.println(results.get(0));

			label = new EntityLabel();
			label.setId(results.get(0));
			session.delete(label);
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

	public void insertByHibernate(JSONObject jo, String username) {

		Session session = null;
		try {

			session = HibernateUtil.factory.openSession();
			session.beginTransaction();

			EntityLabel label = new EntityLabel();
			label.setTag(jo.getString("id"));
			label.setColor(jo.getString("color"));
			label.setContent(jo.getString("value"));
			label.setUsername(username);
			// save time
			Date dt = new Date();
			DateFormat dformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = dformat.format(dt);
			Timestamp t1 = Timestamp.valueOf(time);
			label.setTime(t1);
			
			session.save(label);
			
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(session);
		}
	}

	public void writeByFileOutputStream(String l, String filename) {

		FileOutputStream fop = null;
		File file;
		String newLine = "\r\n";

		try {

			if (filename.substring(filename.length() - 4, filename.length()).equals(".new")) {
				filename = filename.substring(0, filename.length() - 4);
				file = new File(path + "label/" + filename + ".label");

			} else
				file = new File(path + "label/" + filename + ".label");

			// file = new
			// File("C:/Users/Administrator/Desktop/"+filename+".ent");
			File fileParent = file.getParentFile();
			if (!fileParent.exists()) {
				fileParent.mkdirs();
			}
			file.createNewFile();
			fop = new FileOutputStream(file, true);

			BufferedWriter rd = new BufferedWriter(new OutputStreamWriter(fop, "utf-8"));
			// get the content in bytes
			// byte[] contentInBytes = (str+newLine).getBytes();

			rd.write(l + newLine);

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
