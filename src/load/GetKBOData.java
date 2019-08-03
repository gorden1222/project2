package load;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;

import load.GetData.PinnacleGet;

public class GetKBOData extends TimerTask {
	static List<WebElement> teamname; //隊伍名稱
	static List<WebElement> moneyline; //PK盤賠率
	static List<WebElement> handicap; // 讓分盤
	static List<WebElement> total; // 大小分
	static int count = 0;
	static String writecontent = "";
	static String today;
	static final String CHROME_WINDOWS = "chromedriver.exe";
	static final String CHROME_MAC = "chromedriver";
	static final String DB_NAME = "pinnacledata";
	static final String TABLE_NAME = "kbodata";
	static final String driverName = "org.sqlite.JDBC";
	static String home = System.getProperty("user.home");
	static String os = System.getProperty("os.name");
	static String path = home + File.separator + "project2Data" + File.separator;
	private static String driverPath = "jdbc:sqlite:";
	static Connection dbConn;
	static int rowid = 0;
	
	public static class PinnacleGet {

		PinnacleGet() {
//			dbConn = db;
//			try {
//				Class.forName(driverName);
//	        	if(!CheckDB(DB_NAME)){
//	        		createNewDatabase(DB_NAME);
//	        		CreateTable();
//	        	}
//				dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
//			} catch (ClassNotFoundException | SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
		}
	


	/**
	* @param args
	*/
	}
	
	public static void getdata(){
//		WebDriver driver = null;
		DesiredCapabilities capabilities = DesiredCapabilities.chrome(); // 設定使用的webdriver為google chrome
		ChromeOptions chromeOptions = new ChromeOptions();
		
		chromeOptions.addArguments("--headless");
		chromeOptions.addArguments("--disable-gpu");
		String home = System.getProperty("user.home");
		String os = System.getProperty("os.name");
//		System.out.println("[Pony] : "+home);
		String path = home + File.separator + "project2Data" + File.separator;
		System.out.println("[Pony] : "+os);
		//======[Pony]Mac版把"chromedriver.exe"改回"chromedriver"就能用了
		if(os.contains("indows"))System.setProperty("webdriver.chrome.driver", path + CHROME_WINDOWS); // 設定要使用的webdriver exe file路徑
		else System.setProperty("webdriver.chrome.driver", path + CHROME_MAC);

		System.setProperty("webdriver.chrome.silentOutput", "true");
		count = 0;
		final WebDriver driver = new ChromeDriver(chromeOptions);
		WebDriverWait wait = new WebDriverWait(driver, 10); // wait for webdriver start working
		driver.get("https://www.pinnacle.com/en/odds/match/baseball/south-korea/korea-professional-baseball"); // 設定webdriver要讀取的url名稱
		//System.out.println("##[Pony]Start getting source from betting website ");//屌之print step
		// Login
		wait.until(new ExpectedCondition<Boolean>() {
		@Override
		public Boolean apply(WebDriver d) {

//		String s = driver.getPageSource(); //取得該page之source(html程式碼)

			today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());

	//---------測試用，把所有的html source print出來方便爬element用，之後可以砍掉	
		
	//------------獲取html語法中的各項所需之element----------------------		
		teamname = driver.findElements(By.className("game-name")); //隊伍名稱
		moneyline = driver.findElements(By.className("game-moneyline")); //PK盤賠率
		handicap = driver.findElements(By.className("game-handicap")); // 讓分盤
		total = driver.findElements(By.className("game-total")); // 大小分
		
        if (teamname.isEmpty()) {
//        	driver.quit();
       //     throw new RuntimeException("No text area found");
        }
        else {
        	if(!CheckDB(DB_NAME)){
        		System.out.println("!CheckDB(DB_NAME)");
        		createNewDatabase(DB_NAME);
        		
        	}else{
        		try{
        			CreateTable();
        		}catch(Exception e){
//        			e.printStackTrace();
        		}
        		
        		rowid = getLastRowId();
        	}
        	try {
        		for (count = 0; count < teamname.size(); count ++ ){
        			if(0 == (count % 2) && count < teamname.size()){
            		
	        			String query = "insert into kbodata(rowid, dataTime,awayTeam,awayMoneyLine,awayHandicap,totalbig,"
	            				+ "homeTeam,homeMoneyLine,homeHandicap,totalsmall,timestamp)"
	            		        + " values (?, ? ,? ,?, ?, ?, ?, ?, ?, ?, ?)";
	
	        		    java.sql.PreparedStatement preparedStmt;
	            		String name = teamname.get(count).getText().replace("\n","_");
	            		String writename = teamname.get(count+1).getText().replace("\n","_");
	//            		System.out.println("Before insert");
	            		String dataTime = new Date()  + "_" + (new Date().getTime())/1000;
	            		String moneylinestr = "",handicapstr = "",totalstr="";
	            		
	            		//20190716, 兩邊都是""的時候會有IndexoutofNound Exception
	            		if("".equals(moneyline.get(count).getText()) || "".equals(moneyline.get(count+1).getText())){
	            			if("".equals(moneyline.get(count).getText())) moneylinestr += "0";
	            			else moneylinestr += moneyline.get(count).getText();
	            			moneylinestr += "@";
	            			if("".equals(moneyline.get(count+1).getText())) moneylinestr += "0";
	            			else moneylinestr += moneyline.get(count+1).getText();
	            		}else moneylinestr = moneyline.get(count).getText()+"@"+moneyline.get(count+1).getText();
	            		if("".equals(handicap.get(count).getText()) || "".equals(handicap.get(count+1).getText())){
	            			if("".equals(handicap.get(count).getText())) handicapstr += "0 0";
	            			else handicapstr += handicap.get(count).getText();
	            			handicapstr+="@";
	            			if("".equals(handicap.get(count+1).getText())) handicapstr += "0 0";
	            			else handicapstr += handicap.get(count+1).getText();
	            		}else handicapstr = handicap.get(count).getText() + "@" +handicap.get(count+1).getText();
	            		if(total.get(count).getText().replace("\n", " ").split(" ").length < 3
	            				||total.get(count+1).getText().replace("\n", " ").split(" ").length <3){
	            			if(total.get(count).getText().replace("\n", " ").split(" ").length < 3) totalstr += "Over 0 0";
	            			else totalstr += total.get(count).getText().replace("\n", " ");
	            			totalstr += "@";
	            			if(total.get(count+1).getText().replace("\n", " ").split(" ").length <3) totalstr += "Under 0 0";
	            			else totalstr += total.get(count+1).getText().replace("\n", " ");
	            		}else totalstr = total.get(count).getText().replace("\n", " ")+"@"+total.get(count+1).getText().replace("\n", " ");
//	            			Class.forName(driverName);
	            			dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
	            			if(DifffromLast(name,writename,moneylinestr,handicapstr,totalstr)){
	//            				System.out.println("dbConn.prepareStatement(query)");
	            				preparedStmt = dbConn.prepareStatement(query);
	//            				System.out.println("after dbConn.prepareStatement(query)");
	            				rowid++;
	            				preparedStmt.setInt(1, rowid);
	            			    preparedStmt.setString(2, dataTime);
	            			    preparedStmt.setString(3, name);
	            			    if("".equals(moneyline.get(count).getText()))preparedStmt.setString(4,"0");
	            			    else preparedStmt.setString(4, moneyline.get(count).getText());
	            			    if("".equals(handicap.get(count).getText())) preparedStmt.setString(5, "0 0");
	            			    else preparedStmt.setString(5, handicap.get(count).getText());
	            			    if("Over ".equals(total.get(count).getText().replace("\n", " "))) preparedStmt.setString(6, "Over 0 0");
	            			    else preparedStmt.setString(6, total.get(count).getText().replace("\n", " "));
	            			    preparedStmt.setString(7, writename);
	            			    if("".equals(moneyline.get(count+1).getText()))preparedStmt.setString(8, "0");
	            			    else preparedStmt.setString(8, moneyline.get(count+1).getText());
	            			    if("".equals(handicap.get(count+1).getText())) preparedStmt.setString(9, "0 0");
	            			    else preparedStmt.setString(9, handicap.get(count+1).getText());
	            			    if("Under ".equals(total.get(count+1).getText().replace("\n", " ")))preparedStmt.setString(10, "Under 0 0");
	            			    else preparedStmt.setString(10, total.get(count+1).getText().replace("\n", " "));
	            			    preparedStmt.setString(11, today);
	
	            			    System.out.println("preparedStmt.execute()");
	            			    preparedStmt.execute();
	            			
	            			}
            		} 
            		
            	}
        		dbConn.close();
            }catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
            
        }
   //-----------------編好寫入的檔案名稱、內容格式等並執行寫入function-----------	    
        

        driver.quit();
		return true;
		}
		});

		}
	
	public static int getLastRowId(){
		String query = "SELECT MAX(rowid) FROM kbodata";
		int result=0;
		try {
//			Class.forName(driverName);
			dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
			Statement st;
			st = dbConn.createStatement();
		    // execute the query, and get a java resultset
		    ResultSet rs = st.executeQuery(query);
//		    rs.last();
		    rs.next();
		    result = rs.getInt(1);
		    st.close();
		    dbConn.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		}
		return result;
	}
	
	public static boolean DifffromLast(String awayteam,String hometeam,String moneyline,String handicap,String total){
	     String query = "SELECT * FROM kbodata where homeTeam = '" +
	    		 hometeam + "' and awayTeam ='" + awayteam + "'" +
	    		 "ORDER BY rowid DESC LIMIT 1 ";
	      // create the java statement
	     boolean result = true;
	     Statement st = null;

		try {
//			Class.forName(driverName);
//			dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
			st = dbConn.createStatement();
		      // execute the query, and get a java resultset
		      ResultSet rs = st.executeQuery(query);
		      int count = 1;
//		      rs.next();
		      if(rs.next()){
			      if(moneyline.split("@")[0].equals(rs.getString("awayMoneyLine")) || moneyline.split("@")[1].equals(rs.getString("homeMoneyLine"))
					    	 || handicap.split("@")[0].equals(rs.getString("awayHandicap")) || handicap.split("@")[1].equals(rs.getString("homeHandicap"))
					    	 || total.split("@")[0].equals(rs.getString("totalbig")) || total.split("@")[1].equals(rs.getString("totalsmall"))){
					    	  result = false;
//					    	  System.out.println("Insert flag true");
				  }
		      }

		      st.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
//			System.out.println("moneyline = "+moneyline+" , handicap = " + handicap + " , total = " + total);
			e.printStackTrace();
//			return false;
		} catch(Exception e){
			System.out.println("moneyline = " + moneyline + " , handicap = " + handicap + " , total = " + total);
			try {
				st.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	
	public static void createNewDatabase(String fileName) {
		 
        String url = driverPath + path + fileName + ".db";
 
        try (Connection conn = DriverManager.getConnection(url)) {
            if (conn != null) {
                DatabaseMetaData meta = conn.getMetaData();
                System.out.println("The driver name is " + meta.getDriverName());
                System.out.println("A new database has been created.");
            }
 
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

    }
	
	public static boolean CheckDB(String fileName) {
		 
        String url = path + fileName + ".db";
        File f = new File(url);
 
        if(f.exists()) return true;
        else return false;

    }
	
	public static void CreateTable(){
		 
		  Connection c = null;
		  Statement stmt = null;
		  
		   try {
			c = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
			stmt = c.createStatement();
			stmt.executeUpdate(getTable());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
//				e.printStackTrace();
			}finally{
			   try {
				    if(null != stmt){
				     stmt.close();
				    }
				   } catch (SQLException e) {
//				    e.printStackTrace();
				   }
				   try {
				    if(null != c){
				     c.close();
				    }
				   } catch (SQLException e) {
//				    e.printStackTrace();
				   }
			  }
		  
		}
		public static String getTable() {
			  return  "CREATE TABLE if not exists " + TABLE_NAME + "(rowid INT AUTO_INCREMENT,dataTime VARCHAR(3000), awayTeam VARCHAR(3000), "
			  		+ "awayMoneyLine VARCHAR(3000), awayHandicap VARCHAR(3000), totalbig VARCHAR(3000),"
			  		+ "homeTeam VARCHAR(3000), homeMoneyLine VARCHAR(3000), homeHandicap VARCHAR(3000),"
			  		+ "totalsmall VARCHAR(3000), timestamp VARCHAR(3000))";
		}
		
	public static void main(String args[])
	{
		try {
			Class.forName(driverName);
        	if(!CheckDB(DB_NAME)){
        		createNewDatabase(DB_NAME);
        		CreateTable();
        	}
			dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//-------主要呼叫抓data function的兩行，可以把main這個function取消掉然後在別的java class呼叫
		Timer timer = new Timer();
		timer.schedule(new GetKBOData(), 1000, 30000);
		//-------------------------------------------------------------------------
	}
	/*
	 2018/3/3 Pony 
	 public static boolean writeText(String text,String filename,String format,boolean append)
	 function概述:一個簡單的寫入string到檔案的utility
	 String text: 欲寫入的string內容
	 String filename: 欲寫入的檔案名稱(含路徑)
	 String format: 輸入的string buffer格式
	 boolean append: 是否把之前的內容清掉(0為要，1為不要，接在上次寫入的string後面繼續寫入)
	 * 
	 * 
	 */
	public static boolean writeText(String text,String filename,String format,boolean append){
        if(text.equals("")){
            return false;
        }
        File file = new File(filename);//建立檔案，準備寫檔
        try{
            BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,append),format));
            bufWriter.write(text);
            bufWriter.close();
        }catch(IOException e){
            e.printStackTrace();
            System.out.println(filename + "寫檔發生錯誤");
            return false;
        }
        return true;
    }
	

	public void run() { //Thread所執行的工作內容，主要工作為new一個新的get data function並開始執行
		// TODO Auto-generated method stub
		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		getdata();
	}

}
