package annotation.AutomaticAnno.src.annotate;

import java.util.Iterator;
import java.util.Set;

import dict.DictGallary;
import dict.DictReadWrite;
import dict.DictTree;
import dict.DictTree.Node;
import utils.Trace;

public class KmeansTreeHelper {
	String work_dir = "K-means_combine/";
	public String workDir(String filename) {
		return work_dir + filename;
	}
	Node tree = new Node(null, null);

	static Trace t = new Trace().setValid(false, true);
	public KmeansTreeHelper(String filename) throws Exception {
		// TODO Auto-generated constructor stub
		t.debug("Loading Kmeans");
		Set<String> disease = DictReadWrite.loadDictInStringSet(filename);
		t.debug("Constructing the Kmeans dict tree...");
		Iterator<String> it = disease.iterator();
		while( it.hasNext() ) {
			String[] line=it.next().split(" ");
			String name=line[0];
			String type=line[1];
			DictTree.insertWithType(name, tree, type);
		}
		t.debug("Done");
	}
}
