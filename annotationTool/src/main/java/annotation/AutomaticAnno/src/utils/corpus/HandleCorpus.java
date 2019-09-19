package annotation.AutomaticAnno.src.utils.corpus;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

public class HandleCorpus {
	public String INFOLDER = "";
	public String OUTFILE = "";
	public HandleCorpus(String _INFOLDER,String _OUTFILE) {
		INFOLDER = _INFOLDER;
		OUTFILE = _OUTFILE;
	}
	public String Stringinsert(String a,String b,int t){     
	    return a.substring(0,t)+b+a.substring(t,a.length());
	}    
	class Entity implements Comparable{
		String name="";
		int posStart=-1;
		int posEnd=-1;
		String type="";
		String ass="";//修饰
		@Override
		public int compareTo(Object arg0) {
			// TODO Auto-generated method stub
			Entity ent=(Entity)arg0;
			//return this.posStart-ent.posStart;
			return ent.posStart-this.posStart;
		}
	}
	private void textInsertEntitys(File fe,ArrayList<Entity> ents,boolean wholeName,boolean insert) throws IOException{
		//在flc中找到对应的文档
		String fname=fe.getName();
		fname=fname.substring(0,fname.length()-4);
		File fc = new File(INFOLDER+"/tmp/"+fname);
		BufferedReader brc = new BufferedReader(new InputStreamReader(
				new FileInputStream(
						fc), "utf8"));
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(
						OUTFILE,true), "utf8"));
		String text=brc.readLine();
		if(insert==true){
			for(Entity e: ents){
				String insertStr=e.type;
				if(wholeName==false){
					insertStr=insertStr.substring(0, 2);
				}
				if(text.substring(e.posStart,e.posEnd).equals(e.name)){
					text=Stringinsert(text, "\\"+insertStr+" ", e.posEnd);
					text=Stringinsert(text," ",e.posStart);
				}else{
					//注：发现了一些因为重复标注引起的不一致，这里判断后自动忽略掉了，并不影响。
					System.out.println(e.name+"\n"+text.substring(e.posStart,e.posEnd)+"\n"+fname);
				}
			}
		}
		bw.write(text+"\n");
		brc.close();
		bw.close();
	}
	//把所有的标注语料整合到一起
	private void getAllEnts(boolean wholeName,boolean insert) throws IOException {//拿到该目录下的所有.af类型的文件
		Map<String,Integer> dict=new HashMap<String,Integer>();
		Map<String,Integer> dict2=new HashMap<String,Integer>();
		File folderEnt  = new File(INFOLDER+"/ent");
		File[] fle=folderEnt.listFiles();
		for (File fe: fle){
			//读这两个文档，汇总信息至输出文件中。
			BufferedReader bre = new BufferedReader(new InputStreamReader(
					new FileInputStream(
							fe), "utf8"));
			String line;
			ArrayList<Entity> ents=new ArrayList();
			while ((line = bre.readLine()) != null) {
				String[] strs=line.split("=");
				Entity ent=new Entity();
				ent.name=strs[1].substring(0, strs[1].length()-2);
				ent.posStart=Integer.parseInt(strs[2].split(":")[0]);
				String tmp=strs[2].split(":")[1];
				ent.posEnd=Integer.parseInt(tmp.substring(0, tmp.length()-2));
				if (strs.length>4){
					ent.type=strs[3].substring(0,strs[3].length()-2);
					ent.ass=strs[4];
				}else{//有的实体没有标注断言
					ent.type=strs[3];
				}
				if(dict.containsKey(ent.type)){
					Integer x=dict.get(ent.type)+1;
					dict.put(ent.type, x);
				}else{
					dict.put(ent.type, 1);
				}
				if(dict2.containsKey(ent.type)){
					Integer x=dict2.get(ent.type)+ent.name.length();
					dict2.put(ent.type, x);
				}else{
					dict2.put(ent.type, ent.name.length());
				}
				ents.add(ent);
			}
			//倒序进行插入标签
			Collections.sort(ents);
			textInsertEntitys(fe,ents,wholeName,insert);
			bre.close();
		}
		for(Map.Entry<String, Integer> entry:dict.entrySet()){
			System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());  
		}
		for(Map.Entry<String, Integer> entry:dict2.entrySet()){
			double value=entry.getValue()*1.0/dict.get(entry.getKey());
			System.out.println("Key = " + entry.getKey() + ", length = " + value); 
		}
	}

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String str1="res/train-lkx/",str2="res/train-lkx/train_lkx.orig";//,str2="res/train-lkx/lkx.man.af";
		HandleCorpus hc=new HandleCorpus(str1,str2);
		boolean wholeName=true;//标注是全名还是缩写，现在只能全称因为异常检查结果testresult和检查test重合的很多。。。
		boolean insert=false;//false时，给出纯文本；true时，给出添加标签后的文本。
		hc.getAllEnts(wholeName,insert);
	}

}
