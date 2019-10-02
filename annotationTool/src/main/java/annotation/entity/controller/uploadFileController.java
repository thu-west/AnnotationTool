package annotation.entity.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import annotation.model.RelationLabel;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.hibernate.query.Query;
import org.neo4j.cypher.internal.compiler.v2_3.commands.predicates.And;
import org.neo4j.cypher.internal.frontend.v2_3.perty.recipe.Pretty.listAppender;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MultipartFile;

import annotation.model.EntityLabel;
import annotation.model.Entity;
import annotation.model.MedicalHistory;
import annotation.other.HibernateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class uploadFileController {

	JSONObject jo = JSONObject.fromObject(
			"{'/d':'background: rgb(255, 0, 0)','/s':'background: rgb(0, 128, 0)','/c':'background: rgb(255, 128, 192)'}");

	@RequestMapping(value = "/uploadFile", method = RequestMethod.GET)
	public String uploadFile(Model model) {
		System.out.println("hahah");
		return "views/entity/uploadFile";
	}

	/**
	 * 从数据库中读取病例信息，跳转到编辑页面
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST)
	public String annotate2(HttpServletRequest request, Model model) {
		if (request.getSession().getAttribute("sessionusername") == null) {
			model.addAttribute("message", "please login first");
			return "views/user/notice";
		}

		List<MedicalHistory> results = new ArrayList<MedicalHistory>();
		String xianbingshi = null;
		String binglihao = null;
		int fid;
		int age = 0;
		String sex = null;
		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			List<MedicalHistory> histories = session.createCriteria(MedicalHistory.class).add(Restrictions.isNull("status")).setMaxResults(1).list();
			System.out.println(histories);
			session.getTransaction().commit();
			if (histories.size() > 0) {
				MedicalHistory mh = histories.get(0);
				fid = mh.getId();
				xianbingshi = mh.getDzblXianbingshi();
				binglihao = (mh.getJbxxDengjihao()).toString();
				age = mh.getJbxxNianling();
				sex = mh.getJbxxXingbie();
			}
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}

		// labels
		List<EntityLabel> entity_labels = null;
		List<RelationLabel> relation_labels = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			entity_labels = session.createCriteria(EntityLabel.class).add(Restrictions.eq("username", "admin")).list();
			relation_labels = session.createCriteria(RelationLabel.class).add(Restrictions.eq("username", "admin")).list();
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}

		model.addAttribute("message", xianbingshi);
		request.setAttribute("entity_labels", entity_labels);
		request.setAttribute("relation_labels", relation_labels);
		request.getSession().setAttribute("caseNumber", binglihao);
		request.getSession().setAttribute("age", age);
		request.getSession().setAttribute("sex", sex);
		return "views/entity/edit";
	}
	
	/**
	 * 保存编辑后内容，跳转到标注页面
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/biaozhu", method = RequestMethod.POST, produces = {"text/html;charset=UTF-8;",
			"application/json;"})
	public String annotateLabel(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		if (request.getSession().getAttribute("sessionusername") == null) {
			model.addAttribute("message", "please login first");
			return "views/user/notice";
		}

		String message = request.getParameter("edit-message");
		System.out.println("aaaaa "+message);
		String caseNumber = request.getSession().getAttribute("caseNumber").toString();
		
		List<MedicalHistory> results = new ArrayList<MedicalHistory>();
		List<String> list1 = new ArrayList<>();
		Session session =null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			List<MedicalHistory> histories = session.createCriteria(MedicalHistory.class).add(Restrictions.eq("jbxxDengjihao", caseNumber)).list();
			for(MedicalHistory mh : histories) {
				mh.setEditXianbingshi(message);
				session.update(mh);
			}
			session.getTransaction().commit();
			//list1.add(message);
			list1 = getMedHistory(caseNumber,message);
			
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
	//	list1.add(message);

		// labels
		List<EntityLabel> entity_labels = null;
		List<RelationLabel> relation_labels = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			entity_labels = session.createCriteria(EntityLabel.class).add(Restrictions.eq("username", "admin")).list();
			relation_labels = session.createCriteria(RelationLabel.class).add(Restrictions.eq("username", "admin")).list();
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
		
		model.addAttribute("message", list1);
		request.setAttribute("entity_labels", entity_labels);
		request.setAttribute("relation_labels", relation_labels);
		return "views/entity/label";		
	}
	
	/**
	 * 根据病例号，输出病史相关信息
	 * @param caseNumber
	 * @return
	 */
	public List<String> getMedHistory(String caseNumber,String message) {
		List<String> list = new ArrayList<String>();
		List<MedicalHistory> results = new ArrayList<MedicalHistory>();
		Session session =null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			results = session.createCriteria(MedicalHistory.class).add(Restrictions.eq("jbxxDengjihao", caseNumber)).list();
			session.getTransaction().commit();
			Iterator it = results.iterator();
			while (it.hasNext()) {
				MedicalHistory history = (MedicalHistory) it.next();
				String zhusu = history.getDzblZhusu();
				String jiwangbingshi = history.getDzblJiwangbingshi();
				String chuanranbingshi = history.getDzblChuanranbingshi();
				String yichuanbingshi = history.getDzblYichuanbingshi();
				String shiyan = history.getDzblShiyan();
				String shijiu = history.getDzblShijiu();
				String guominshi = history.getDzblGuominshi();
				String waishangshi = history.getDzblWaishangshi();
				String shoushushi = history.getDzblShoushushi();
				String lvef = history.getJcChuangpangJcsjHqsyz();
				String ruyuan = history.getJszdRuyuanzhenduanmenzhenzeweimenzhenzhenduan();
				String chuyuan = history.getJszdChuyuanzhenduansuoyou();
				String age = (history.getJbxxNianling()).toString();
				String sex = history.getJbxxXingbie();
				//String illage = "11";
				//String xingbie="女";
				//String ruyuan="222";
				//String chuyuan="444";
				
				//System.out.println(jiwangbingshi);
				list.add(message);//0
				list.add(zhusu);//1
				list.add(jiwangbingshi);//2
				list.add(chuanranbingshi);//3
				list.add(yichuanbingshi);//4
				list.add(shiyan);//5
				list.add(shijiu);//6
				list.add(guominshi);//7
				list.add(waishangshi);//8
				list.add(shoushushi);//9
				list.add(lvef);//10
				list.add(ruyuan);//11
				list.add(chuyuan);//12
				list.add(age);//13
				list.add(sex);//14
				
				//list.add(illage);//11
				//list.add(xingbie);//12
				//list.add(ruyuan);//13
				//list.add(chuyuan);//14
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
		return list;
	}
	
	/**
	 * 把标注好的实体拼接，并展示
	 * @param annoList
	 * @param fileContent
	 * @return
	 */
	public String addAnnoFileContent(List<Entity> annoList, String fileContent) {
		List<Integer> index = new ArrayList<Integer>();
		JSONObject jo = new JSONObject();
		for (int i = 0; i < annoList.size(); i++) {
			String pos = annoList.get(i).getPos();

			String startpos = pos.split(",")[0];
			jo.put(startpos, i);
			System.out.println(jo);

			index.add(Integer.parseInt(startpos));
		}
		Collections.sort(index);

		for (int i = 0; i < index.size(); i++)
			System.out.println(index.get(i));

		for (int i = 0; i < index.size(); i++) {
			Integer posin = index.get(index.size() - i - 1);
			int annoIndex = jo.getInt(posin.toString());
			Entity anno = annoList.get(annoIndex);
			// generateSpan(anno);
			String[] pos = anno.getPos().split(",");
			int startpos = Integer.parseInt(pos[0]);
			int endpos = Integer.parseInt(pos[1]);

			fileContent = fileContent.substring(0, endpos) + anno.getTag() + "</span>"
					+ fileContent.substring(endpos, fileContent.length());
			String fspan = "<span class=\"" + anno.getTag() + "\" " + "lab=\"" + (i + 1) + "\" " + "style=\""
					+ getColor(anno) + ";\">";
			fileContent = fileContent.substring(0, startpos) + fspan
					+ fileContent.substring(startpos, fileContent.length());
			System.out.println(fileContent);
		}
		return fileContent;
	}

	public String getColor(Entity anno) {
		if (jo.containsKey(anno.getTag())) {
			return jo.getString(anno.getTag());
		}

		Session session = null;
		List<String> results = new ArrayList<String>();
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			List<EntityLabel> labels = session.createCriteria(EntityLabel.class).add(Restrictions.eq("type", anno.getTag())).list();
			for(EntityLabel label : labels) {
				results.add(label.getColor());
			}
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
		if (results.size() == 0)
			return null;
		return "background: " + results.get(0);
	}

	public List<Entity> getEntityList(String username, int number) {
		JSONArray ja = new JSONArray();
		JSONObject jo = new JSONObject();
		List<Entity> results = new ArrayList<Entity>();
		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			results = session.createCriteria(EntityLabel.class).add(Restrictions.eq("username", username)).add(Restrictions.eq("number", 00001)).list();
			for (Entity a : results) {
				// jo.put("size", oi.getSize());
				// jo.put("insize", oi.getInsize());
				// jo.put("inrate", oi.getInrate());
				// jo.put("time", oi.getTime());
				// System.out.println(jo);
				// ja.add(jo);

			}

			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
		return results;
	}

	public List<Entity> getAnnoList(String username, String filename) {
		JSONArray ja = new JSONArray();
		JSONObject jo = new JSONObject();
		List<Entity> results = new ArrayList<Entity>();
		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			results = session.createCriteria(Entity.class).add(Restrictions.eq("username", username)).add(Restrictions.eq("filename", filename)).list();
			for (Entity a : results) {
				// jo.put("size", oi.getSize());
				// jo.put("insize", oi.getInsize());
				// jo.put("inrate", oi.getInrate());
				// jo.put("time", oi.getTime());
				// System.out.println(jo);
				// ja.add(jo);
			}
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}
		return results;
	}
}
