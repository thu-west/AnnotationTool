package annotation.user.controller;

import java.io.FileNotFoundException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
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

	public void insertByHibernate(User user) {

		Session session = null;
		try {
			session = HibernateUtil.factory.openSession();
			session.beginTransaction();
			// save time
			Date dt = new Date();
			DateFormat dformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = dformat.format(dt);
			Timestamp t1 = Timestamp.valueOf(time);
			user.setTime(t1);
			
			session.save(user);
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(session);
		}
	}

	@RequestMapping(value = "/registerCheck", method = RequestMethod.POST)
	public String registerCheck(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String username = request.getParameter("user");
		String password = request.getParameter("passwd");
		User user = new User();
		user.setUsername(username);
		user.setPassword(password);
		insertByHibernate(user);

		request.getSession().setAttribute("sessionusername", user.getUsername());
		return "views/entity/uploadFile";
	}
}
