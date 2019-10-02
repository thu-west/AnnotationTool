package annotation.user.controller;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
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
		// return "views/entity/uploadFile";
		return "redirect:/";
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
			List<User> users = session.createCriteria(User.class).add(Restrictions.eq("username", username)).list();
			session.getTransaction().commit();
			for(User u : users) {
				results.add(u.getPassword());
			}
		}catch(Exception e)
		{
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		}finally{
			HibernateUtil.closeSession(session);
		}
		if(results.size()==0) return null;
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
			// return "views/entity/uploadFile";
			return "redirect:/";
		}
		else
		{
			model.addAttribute("message", "password wrong");
			return "views/user/notice";
		}
		
	}
}
