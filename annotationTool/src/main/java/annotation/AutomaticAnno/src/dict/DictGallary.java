package annotation.AutomaticAnno.src.dict;

import utils.GlobalSettings;

public class DictGallary {

	public static String dict_path = GlobalSettings.contextDir("dict/");
	public static String final_path = dict_path+"final/";
	public static String temp_path = dict_path+"temp/";
	public static String stat_path = dict_path+"stat/";

	public static String disease = final_path + "疾病及独立症状.dict";
	public static String medicine = final_path + "药物.dict";
	public static String check = final_path + "检查.dict";
	public static String treat = final_path + "治疗.dict";
	public static String food = final_path + "食物.dict";
	public static String sign = final_path + "体征.dict";
	public static String equipment = final_path + "器械.dict";
	public static String organ = final_path + "器官.dict";
	public static String organ_des = final_path + "器官描述.dict";
	public static String indicator = final_path + "指标.dict";
	public static String indicator_des = final_path + "指标描述.dict";
	
	public static String pro_disease = final_path + "pro_disease.txt";
	public static String pro_drug = final_path + "pro_drug.txt";
	public static String pro_inspection = final_path + "pro_inspection.txt";
	public static String pro_symptom = final_path + "pro_symptom.txt";
	
	public static String combine_disease = final_path + "combine_disease.txt";
	public static String combine_drug = final_path + "combine_drug.txt";
	public static String combine_inspection = final_path + "combine_inspection.txt";
	public static String combine_symptom = final_path + "combine_symptom.txt";
	
	public static String mesh_disease = final_path + "mesh_disease.txt";
	public static String mesh_drug = final_path + "mesh_drug.txt";
	public static String mesh_treatment = final_path + "mesh_treatment.txt";
	public static String mesh_symptom = final_path + "mesh_symptom.txt";
	
	public static String baike = dict_path + "baike2-6.dic";
	public static String cilin = dict_path+"cilin.dict";
	
	public static String med_all = dict_path + "med.dict";
}
