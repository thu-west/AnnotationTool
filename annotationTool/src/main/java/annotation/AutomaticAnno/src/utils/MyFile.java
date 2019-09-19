package annotation.AutomaticAnno.src.utils;

import java.io.File;
import java.io.IOException;

import utils.Trace;

/*
 * 自己定义的对于文件的操作，主要是删除目录及目录下文件，和判断是否一个文件是否存在。
 */
public class MyFile {
	
	static Trace t = new Trace();
	
	static boolean deleteHelper(File dir) {
		if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i=0; i<children.length; i++) {
                boolean success = deleteHelper(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
		}
       	return dir.delete();
	}
	
	public static boolean delete(String dir_path) {//这里为啥不直接写成deleteHelper的逻辑？
		return deleteHelper(new File(dir_path));
	}
	
	public static void main(String[] args) {
		System.out.println(delete("D:/Project/healthqa/tmp/ed2c421e-99c8-446f-9d0d-aa970f8f0537"));
	}
	
	public static boolean exist(String filename) throws IOException {//判断文件是否存在
		if(!new File(filename).exists()) {
			t.error(filename+" doesn't exist");
			throw new IOException(filename+" doesn't exist");
		}
		return true;
	}

}
