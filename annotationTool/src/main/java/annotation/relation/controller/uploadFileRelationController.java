package annotation.relation.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import annotation.model.Entity;
import annotation.other.HibernateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
public class uploadFileRelationController {
	JSONObject jo = JSONObject.fromObject("{'/d':'background: rgb(255, 0, 0)','/s':'background: rgb(0, 128, 0)','/c':'background: rgb(255, 128, 192)'}");
	

	@RequestMapping(value="/openfileRelation", method = RequestMethod.GET)
	public String openfileRelation(Model model)
	{
		return "views/relation/openfileRelation";
	}
		
	//上传文件，跳转到标注页面
		@RequestMapping(value="/biaozhuRelation",method = RequestMethod.POST)
		public String biaozhuRelation(HttpServletRequest request,@RequestParam MultipartFile file, Model model) throws IOException
		{
			
			//读取上传的文件内容
			InputStream is = file.getInputStream();
			
			BufferedReader in = new BufferedReader(new InputStreamReader(is, "utf-8"));
			   StringBuffer buffer = new StringBuffer();
			   String line = "";
			   while ((line = in.readLine()) != null){
			     buffer.append(line);
			   }
			System.out.println(buffer.toString());
			
			
			//上传文件的文件名
			String fileName =  file.getOriginalFilename();
			System.out.println(fileName);
			
			request.getSession().setAttribute("filename", fileName);
			
			String fileContent = buffer.toString();
			String showFileContent = new String();
			List<Entity> annoList = getAnnoList(request.getSession().getAttribute("sessionusername").toString(), fileName);
			if(annoList.size()==0)
				showFileContent = fileContent;
			else
			{
				showFileContent = addAnnoFileContent(annoList, fileContent);
			}
			model.addAttribute("message", showFileContent);
			
			return "views/relation/relation";
		}
		
		public String addAnnoFileContent(List<Entity> annoList, String fileContent)
		{
			List<Integer> index = new ArrayList<Integer>();
			JSONObject jo = new JSONObject();
			for(int i = 0;i<annoList.size();i++)
			{
				String pos = annoList.get(i).getPos();
				
				String startpos = pos.split(",")[0];
				jo.put(startpos, i);
				System.out.println(jo);
				
				index.add(Integer.parseInt(startpos));
			}
			Collections.sort(index);
			
			for(int i= 0;i<index.size();i++)
				System.out.println(index.get(i));
			
			for(int i = 0;i<index.size();i++)
			{
				Integer posin = index.get(index.size()-i-1);
				int annoIndex = jo.getInt(posin.toString());
				Entity anno = annoList.get(annoIndex);
//				generateSpan(anno);
				String []pos = anno.getPos().split(",");
				int startpos  = Integer.parseInt(pos[0]);
				int endpos = Integer.parseInt(pos[1]);
				
				fileContent = fileContent.substring(0,endpos)+anno.getTag()+"</span>"+fileContent.substring(endpos,fileContent.length());
				String fspan = "<span class=\""+anno.getTag()+"\" "+"lab=\""+(i+1)+"\" "+"style=\""+getColor(anno)+";\">";
				fileContent = fileContent.substring(0,startpos)+fspan+fileContent.substring(startpos, fileContent.length());
				System.out.println(fileContent);
			}
			return fileContent;
		}
		public String getColor(Entity anno)
		{
			if(jo.containsKey(anno.getTag()))
			{
				return jo.getString(anno.getTag());
			}
			
			Session session = null;
			List<String> results = new ArrayList<String>();
			try{
				session = HibernateUtil.factory.openSession();
				session.beginTransaction();
				String hql = "SELECT color FROM EntityLabel where type = \'"+anno.getTag()+"\'";
				Query query = session.createQuery(hql);
				results = query.list();
			}catch(Exception e)
			{
				e.printStackTrace();
				session.getTransaction().rollback();
			}finally{
			if(session!=null){
				if(session.isOpen()){
					session.close();
				}
			}
			}
			if(results.size()==0)
				return null;
			return "background: "+results.get(0);
		}
		public List<Entity> getAnnoList(String username, String filename)
		{
			JSONArray ja = new JSONArray();
			JSONObject jo = new JSONObject();
			List<Entity> results = new ArrayList<Entity>();
			Session session = null;
			try{
				session = HibernateUtil.factory.openSession();
				session.beginTransaction();
				String hql = "from Entity anno where anno.username = :username and anno.filename = :filename";
				Query query = session.createQuery(hql).setParameter("username", username)
														.setParameter("filename", filename);
				
				results = query.list();
				for(Entity a:results)
				{
//					jo.put("size", oi.getSize());
//					jo.put("insize", oi.getInsize());
//					jo.put("inrate", oi.getInrate());
//					jo.put("time", oi.getTime());
//					System.out.println(jo);
//					ja.add(jo);
					
				}
				
				
				session.getTransaction().commit();
			}catch(Exception e)
			{
				e.printStackTrace();
				session.getTransaction().rollback();
			}finally{
				HibernateUtil.closeSession(session);
			}
			return results;
		}
}
