package annotation.AutomaticAnno.src.entity;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.UUID;

import annotate.AnnotateByDict;
import annotate.AnnotateByKmeans;
import annotate.AnnotateByPostag;
import mltools.CRF;
import mltools.CRFPPDataHandler;
import utils.GlobalSettings;

public class TestAnnotation {
	
	static String work_dir = null;
	public static String workDir(String filename) {
		return work_dir + filename;
	}
	//static String model_path = GlobalSettings.contextDir("/res/model/crf.model_lkx_1");
	static String model_path = GlobalSettings.contextDir("/res/model/abb_model.model");
	private static String annotate(String input_string) throws Exception{
		UUID uuid = UUID.randomUUID();
		work_dir = "tmp/"+ uuid.toString()+"/";
		work_dir="tmp/lkx/";
		File f = new File(work_dir);
		f.mkdirs();
		
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(workDir("input.orig")), "utf8"));
		bw.write(input_string);
		bw.close();
		//dict
		new AnnotateByDict(2).annotateFile(workDir("input.orig"), workDir("1.dict.af"), "utf8");
		//postag
		AnnotateByPostag.label(workDir("input.orig"), workDir("2.postag.af"));
		//kmeans
		new AnnotateByKmeans(GlobalSettings.contextDir("K-means/500")).annotateFile(workDir("input.orig"),workDir("3.kmeans.af"), "utf8");
		
		// transfer to crf++ format
		CRFPPDataHandler td = new CRFPPDataHandler(work_dir);
		td.transferAllAggFilesToSingleSegFiles();
		td.combineAllSingleSegFilesToMultiSegFile("input.msf");
		
		//annotation
		CRF crf =  new CRF(model_path);
		//String aString = crf.test(workDir("input.msf"),workDir("output"),workDir("result"));
		String aString = crf.test(workDir("input.msf"));
		return aString;
	}
	public static void main(String[] args) throws Exception{
		//String string = annotate("空腹血糖7.72，现在吃二甲双胍，一天三次一次两片，可以吗。");
		//
		String str = annotate("患者自3年前开始反复出现胸闷，心前区为著，伴心悸，多在活动时发作，持续10余分钟，休息后可缓解，曾就诊当地医院诊断为“冠心病、心绞痛”，给予药物治疗效果欠佳。近2月感胸闷加重，每于快步行走或上楼时即有发作，性质同前，持续数分钟不等，含服硝酸甘油可缓解，就诊于北京阜外医院查冠脉造影提示三支病变，LCX远端闭塞，建议外科CABG术，口服抗血小板、调脂等药物，仍反复发作，家属为行PCI术入我科。");
		System.out.println(str);
		/*if (args.length>1) {
			model_path=args[1];
		}
		String str = annotate(args[0]);
		System.out.println(str);	*/
	}

	

}
