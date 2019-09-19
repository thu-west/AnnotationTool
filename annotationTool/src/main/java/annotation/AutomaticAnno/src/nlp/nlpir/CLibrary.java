package annotation.AutomaticAnno.src.nlp.nlpir;

import com.sun.jna.Library;
import com.sun.jna.Native;

public interface CLibrary extends Library {
	
	// 定义并初始化接口的静态变量
	CLibrary Instance = (CLibrary) Native.loadLibrary(
			NLPIRSettings.NLPIR_DLL_SO , CLibrary.class);

	public int NLPIR_Init(String sDataPath, int encoding, String sLicenceCode);

	public String NLPIR_ParagraphProcess(String sSrc, int bPOSTagged);//对字符串进行分词  bPOSTaggedbPOSTagged参数为1时，输出结果显示词性标记；为0时，不现实标记，默认值为1。
	public String NLPIR_GetKeyWords(String sLine, int nMaxKeyLimit,
			boolean bWeightOut);// //从字符串中提取关键词 

	public int NLPIR_AddUserWord(String sWord);// add by qp 2008.11.10  //添加单条用户词典

	public int NLPIR_DelUsrWord(String sWord);// add by qp 2008.11.10 //删除单条用户词典

	public int NLPIR_ImportUserDict(String dict); //从TXT文件中导入用户词典
	
	 //获取报错日志
    public String NLPIR_GetLastErrorMsg();

	public void NLPIR_Exit();
	
	public String NLPIR_GetFileKeyWords(String sTextFile, int
			nMaxKeyLimit, boolean bWeightOut );  //从TXT文件中获取新词

}
