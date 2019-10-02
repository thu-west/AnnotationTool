package annotation.user.controller;

import java.io.FileNotFoundException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
public class registerController {
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String register(Model model) throws FileNotFoundException {
		return "views/user/register";
	}

	public String insertByHibernate(User user) {
		boolean username_exists = false;

		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			List<User> exists_users = session.createCriteria(User.class).add(Restrictions.eq("username", user.getUsername())).list();
			if (exists_users.size() == 0) {
				// save time
				Date dt = new Date();
				DateFormat dformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String time = dformat.format(dt);
				Timestamp t1 = Timestamp.valueOf(time);
				user.setTime(t1);

				session.save(user);
			} else {
				username_exists = true;
			}
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			HibernateUtil.rollbackSession(session);
		} finally {
			HibernateUtil.closeSession(session);
		}

		if (username_exists) {
			return "Username already exists.";
		} else {
			return null;
		}
	}

	@RequestMapping(value = "/registerCheck", method = RequestMethod.POST)
	public String registerCheck(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String username = request.getParameter("user");
		String password = request.getParameter("passwd");
		User user = new User();
		user.setUsername(username);
		user.setPassword(password);
		String error_msg = insertByHibernate(user);
		if(error_msg != null)
		{
			model.addAttribute("message", error_msg);
			return "views/user/notice";
		} else {
			request.getSession().setAttribute("sessionusername", user.getUsername());
			// return "views/entity/uploadFile";
			return "redirect:/";
		}
	}
}
