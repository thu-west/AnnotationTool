package annotation.AutomaticAnno.controller;

import entity.TestAnnotation;

public class main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String[] str={"空腹血糖7.72，现在吃二甲双胍，一天三次一次两片，可以吗"};
		try {
			TestAnnotation.main(str);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
