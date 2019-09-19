package annotation.AutomaticAnno.src.annotate;

import java.io.*;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.Set;

import annotation.AutomaticAnno.src.dict.DictGallary;
import annotation.AutomaticAnno.src.utils.GlobalSettings;
import annotation.AutomaticAnno.src.utils.database.DBConfig;
import annotation.AutomaticAnno.src.utils.database.MysqlConnection;
import utils.Trace;
import dict.DictReadWrite;
import dict.DictTree;
import dict.DictTree.Node;

public class DictTreeHelper {
	
	Node tree = new Node(null, null);
	
	static Trace t = new Trace().setValid(false, true);
	
	public DictTreeHelper(int type) throws Exception {
		if(type==0) {
			init_0();
		} else if(type==1){
			init_1();
		}
		else if(type==2){
			init_2();
		}
	}
	
	void init_0() throws Exception {
		t.debug("Loading full dict disease/check/sign/organ/organ_des/medicine/indicator/indicator_des/treat ...");
		Set<String> disease = DictReadWrite.loadDictInStringSet(DictGallary.disease);
		Set<String> check = DictReadWrite.loadDictInStringSet(DictGallary.check);
		Set<String> sign = DictReadWrite.loadDictInStringSet(DictGallary.sign);
		Set<String> organ = DictReadWrite.loadDictInStringSet(DictGallary.organ);
		Set<String> organ_des = DictReadWrite.loadDictInStringSet(DictGallary.organ_des);
		Set<String> medicine = DictReadWrite.loadDictInStringSet(DictGallary.medicine);
		Set<String> indicator = DictReadWrite.loadDictInStringSet(DictGallary.indicator);
		Set<String> indicator_des = DictReadWrite.loadDictInStringSet(DictGallary.indicator_des);
		Set<String> treat = DictReadWrite.loadDictInStringSet(DictGallary.treat);
		t.debug("Constructing the dict tree...");
		Iterator<String> it = disease.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "d");
		}
		it = check.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "c");
		}
		it = sign.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "s");
		}
		it = organ.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "o");
		}
		it = organ_des.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "os");
		}
		it = medicine.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "m");
		}
		it = indicator.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "i");
		}
		it = indicator_des.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "is");
		}
		it = treat.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "t");
		}
		t.debug("Done");
	}

	void init_1() throws Exception {
		t.debug("Loading pure dict disease/check/organ/medicine/indicator/treat ...");
		Set<String> disease = DictReadWrite.loadDictInStringSet(DictGallary.disease);
		Set<String> check = DictReadWrite.loadDictInStringSet(DictGallary.check);
		Set<String> organ = DictReadWrite.loadDictInStringSet(DictGallary.organ);
		Set<String> food = DictReadWrite.loadDictInStringSet(DictGallary.food);
		Set<String> medicine = DictReadWrite.loadDictInStringSet(DictGallary.medicine);
		Set<String> indicator = DictReadWrite.loadDictInStringSet(DictGallary.indicator);
		Set<String> treat = DictReadWrite.loadDictInStringSet(DictGallary.treat);
		t.debug("Constructing the dict tree...");
		Iterator<String> it = disease.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "d");
		}
		it = check.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "c");
		}
		it = organ.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "o");
		}
		it = medicine.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "m");
		}
		it = indicator.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "i");
		}
		it = food.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "y");
		}
		it = treat.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "t");
		}
		t.debug("Done");
	}
	void init_2() throws Exception {
		t.debug("Loading pure dict disease/test/sys/treat from database ...");
		Set<String> mesh_disease = DictReadWrite.loadDictInStringSet(getDictFromDatabase(DictGallary.mesh_disease,"C%' AND id NOT LIKE 'C23%"));
		Set<String> mesh_drug = DictReadWrite.loadDictInStringSet(getDictFromDatabase(DictGallary.mesh_drug,"D%"));
		Set<String> mesh_treatment = DictReadWrite.loadDictInStringSet(getDictFromDatabase(DictGallary.mesh_treatment,"E02%' OR id LIKE 'E03%' OR id LIKE 'E04%"));
		Set<String> mesh_symptom = DictReadWrite.loadDictInStringSet(getDictFromDatabase(DictGallary.mesh_symptom,"C23%"));
		t.debug("Constructing the dict tree...");
		Iterator<String> it = mesh_disease.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "d");
		}
		it = mesh_drug.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "m");
		}
		it = mesh_treatment.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "t");
		}
		it = mesh_symptom.iterator();
		while( it.hasNext() ) {
			DictTree.insertWithType(it.next(), tree, "s");
		}
		t.debug("Done");
	}
	public String getDictFromDatabase(String path,String id_string) throws IOException, SQLException{
		DBConfig c = new DBConfig();
		c.url =  GlobalSettings.mesh_db_url;
		c.username = GlobalSettings.database_username;
		c.password = GlobalSettings.database_password;
		MysqlConnection con = new MysqlConnection(c);
		con.connect();
		java.sql.ResultSet rSet=con.query("SELECT cname FROM mesh WHERE id LIKE '"+id_string+"'");
		
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(path), "utf8"));
		while (rSet.next()) {
			bw.write(rSet.getString(1)+"\r\n");
		}
		bw.close();
		return path;
	}
	public static void main(String[] args) throws Exception{
		new DictTreeHelper(2);
	}
}
