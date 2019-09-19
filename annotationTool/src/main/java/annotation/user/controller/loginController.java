package annotation.user.controller;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import annotation.other.HibernateUtil;
import annotation.model.User;


@Controller
public class loginController {
	@RequestMapping(value="/login", method = RequestMethod.GET)
	public String login(Model model) throws FileNotFoundException
	{
		return "views/user/login";
	}
	
	@RequestMapping(value="/logout", method = RequestMethod.GET)
	public String logout(Model model, HttpServletRequest request,
			HttpServletResponse response) throws FileNotFoundException
	{
		request.getSession().setAttribute("sessionusername", null);
		return "views/entity/uploadFile";
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String searchPasswordByUserName(String username)
	{
		@SuppressWarnings("unused")
		User user  = null;
		Session session = null;
		List<String> results = new ArrayList<String>();
		try{
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			String hql = "SELECT password FROM User where username = \'"+username+"\'";
			Query query = session.createQuery(hql);

			results = query.list();
//			System.out.println(results.get(0));
			
		}catch(Exception e)
		{
			e.printStackTrace();
			session.getTransaction().rollback();
		}finally{
			HibernateUtil.closeSession(session);
		}
		if(results.size()==0)
			return null;
		return results.get(0);
	}
	
	@RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
	public String loginCheck(ModelMap model, HttpServletRequest request,
				HttpServletResponse response) {
		String username = request.getParameter("user");
		String password = request.getParameter("passwd");
		System.out.println(username+" "+password);
		
//		UserHome userHome = new UserHome();
		String realPasswd = searchPasswordByUserName(username);
//		System.out.println(user.getPassword());
		if(realPasswd==null)
		{
			model.addAttribute("message", "username doesn't exist");
			return "views/user/notice";
		}
		else if(password.equals(realPasswd))
		{
			request.getSession().setAttribute("sessionusername", username);
			System.out.println("login success");
			return "views/entity/uploadFile";
		}
		else
		{
			model.addAttribute("message", "password wrong");
			return "views/user/notice";
		}
		
	}
}
