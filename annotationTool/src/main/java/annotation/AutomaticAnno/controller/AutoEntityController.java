package annotation.AutomaticAnno.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AutoEntityController {
	
	@RequestMapping(value="/ner", method = RequestMethod.GET)
	public String entityRecognition(Model model)
	{
		//第二个参数是自动实体识别后的结果，参照uploadFileRelationController中的biaozhuRelation方法
		model.addAttribute("result", "空腹血糖7.72，现在吃二甲双胍，一天三次一次两片，可以吗");
		return "views/entity/ner";
	}

}
