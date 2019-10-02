package annotation.relation.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.stereotype.Controller;

import annotation.other.HibernateUtil;
import annotation.model.RelationLabel;
import net.sf.json.JSONObject;
//jsonDelRelationBtn
//jsonRelationBtn
@Controller
public class relationLabelController {
	@RequestMapping(value="/jsonRelationBtn",method=RequestMethod.POST, produces={"text/html;charset=UTF-8;","application/json;"})
	public String addLabel(@RequestBody String str, Model model,HttpServletRequest request,
			HttpServletResponse response){
		
		response.setContentType("text/html;charset=UTF-8");  
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);
		String un = request.getSession().getAttribute("sessionusername").toString();
		insertByHibernate(json, un);
		return null;
	}
	
	@RequestMapping(value="/jsonDelRelationBtn",method=RequestMethod.POST, produces={"text/html;charset=UTF-8;","application/json;"})
	public String jsonDelLabel(@RequestBody String str, Model model,HttpServletRequest request,
			HttpServletResponse response){
		
		response.setContentType("text/html;charset=UTF-8");  
		JSONObject json = JSONObject.fromObject(str);
		System.out.println(json);
		deleteByContent(json.getString("value"));
		return null;
	}
	public void deleteByContent(String content)
	{
		RelationLabel rl = null;
		Session session = null;
		List<Integer> results = new ArrayList<Integer>();
		try{
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			List<RelationLabel> labels = session.createCriteria(RelationLabel.class).add(Restrictions.eq("label", content)).list();
			for(RelationLabel label : labels) {
				results.add(label.getId());
			}
			System.out.println(results.get(0));
			
			rl = new RelationLabel();
			rl.setId(results.get(0));
			session.delete(rl);
			session.getTransaction().commit();
//			System.out.println(results.get(0));
			
		}catch(Exception e)
		{
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		}finally{
			HibernateUtil.closeSession(session);
		}
		
		return;
	}
	
	public void insertByHibernate(JSONObject jo, String username){
		Session session = null;
		try{
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
	
			RelationLabel rl = new RelationLabel();
			rl.setLabel(jo.getString("value"));
			rl.setUsername(username);
			session.save(rl);
		
			session.getTransaction().commit();
			
		}catch(Exception e){
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		}finally{
			HibernateUtil.closeSession(session);
		}
	}
	
}
