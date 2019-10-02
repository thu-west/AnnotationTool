package annotation.other;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.neo4j.cypher.internal.frontend.v2_3.perty.recipe.Pretty.section;

public class HibernateUtil {
		public static SessionFactory factory; 
		static {
			for(int times = 5; times > 0; times --) {
				try {
					factory = new Configuration().configure().buildSessionFactory();
					break;
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Connecting to DB Error");
					try {
						Thread.sleep(1000);
					} catch (InterruptedException ex) {
						ex.printStackTrace();
					}
				}
			}
	    }  
		 //生成session  
	    public static Session openSession(){  
	        Session session=factory.openSession();  
	        return session;
	    }
		//回滚session
		public static void rollbackSession(Session session){
			if(session != null){
				session.getTransaction().rollback();
			}
		}
	    //关闭session  
	    public static void closeSession(Session session){
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
	    }
}
