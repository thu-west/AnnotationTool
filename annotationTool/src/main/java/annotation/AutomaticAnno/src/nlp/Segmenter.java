package annotation.AutomaticAnno.src.nlp;

import nlp.Word;

public interface Segmenter {
	public Word[][] segParagraph( String aParagraph ) throws Exception;
	
//	public Set<String> findNoun( String s );
	//LTPIDSegment中使用了
}
