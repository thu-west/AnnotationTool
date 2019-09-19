package annotation.other;

import java.io.FileNotFoundException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class noticeController {
	@RequestMapping(value="/notice", method = RequestMethod.GET)
	public String notice(Model model) throws FileNotFoundException
	{
		return "views/user/notice";
	}
}
