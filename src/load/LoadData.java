package load;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
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

import org.json.JSONArray;
import org.json.JSONObject;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;

public class LoadData {

	static String today;
	static String yesterday;
	static final String CHROME_WINDOWS = "chromedriver.exe";
	static final String CHROME_MAC = "chromedriver";
	static final String DB_NAME = "pinnacledata";
	static final String driverName = "org.sqlite.JDBC";
	private static String driverPath = "jdbc:sqlite:";
	private static WebDriver driver = null;
	private static String tablename = "";
	public static JSONArray LoadData(File file) throws Exception{
		FileInputStream f = new FileInputStream(file);
		BufferedReader br;
		JSONArray rtnAry = new JSONArray();
		System.out.println("[Pony] file = " + file.getPath());
		today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		yesterday = new SimpleDateFormat("yyyyMMdd").format(yesterday());
		System.out.println("[Pony] yesterday = "+yesterday);
		File yes_file = new File(file.getPath().replace(today, yesterday));
		System.out.println("[Pony] Yesterday file = " + yes_file.getPath());
		
//		Deletecloseddata(file);
		try {
			if(yes_file.exists()){
				FileInputStream yes_f = new FileInputStream(yes_file);
				BufferedReader yes_br = new BufferedReader(new InputStreamReader(yes_f));
				String strLine= "";
//				String dataDate = "";//資料日期
				String dataTime = "";//資料時間
				String dataSecond = "";//系統時間(ms),for 圖表時間用
				String homeTeam = "";//主場隊伍
				String awayTeam = "";//客場隊伍
				String awayMoneyLineOdds = "" , lastawayMoneyLineOdds = "";//客隊moneyline賠率
				String awayHandicapOdds = "" , lastawayHandicapOdds = "";//客隊讓分賠率
				String awayHandicap = "" , lastawayHandicap = "";//客隊讓分
				String homeMoneyLineOdds = "" , lasthomeMoneyLineOdds = "";//主隊moneyline賠率
				String homeHandicapOdds = "" , lasthomeHandicapOdds = "";//主隊讓分賠率
				String homeHandicap = "" , lasthomeHandicap = "";//主隊讓分
				String bigTotalOdds = "" , lastbigTotalOdds = "";//大分賠率
				String smallTotalOdds= "" , lastsmallTotalOdds = "";//小分賠率
				String total = "" , lasttotal = "";//大小分
				while((strLine = yes_br.readLine()) != null){
					JSONObject rtnObj = new JSONObject();
					String[] dataArray = strLine.split("@");
				//	for(int a=0;a< dataArray.length;a++)System.out.println(dataArray[a]);
//					dataDate = dataArray[0].split("_")[0];
					dataTime = dataArray[0].split("_")[0];
					dataSecond = dataArray[0].split("_")[1];
					awayTeam = dataArray[1];
					homeTeam = dataArray[5];
					if(dataArray[2].split(":").length > 1) awayMoneyLineOdds = dataArray[2].split(":")[1];
					if("".equals(awayMoneyLineOdds)) awayMoneyLineOdds = "0";
					if(dataArray[3].split(":").length > 1)  awayHandicap = dataArray[3].split(":")[1].split(" ")[0];
					if("".equals(awayHandicap)) awayHandicap = "0";
					if(dataArray[3].split(":").length > 1) awayHandicapOdds = dataArray[3].split(":")[1].split(" ")[1];
					if("".equals(awayHandicapOdds)) awayHandicapOdds = "0";
					if(dataArray[4].split(":").length > 1) bigTotalOdds = dataArray[4].split(":")[1].split(" ")[2];
					if("".equals(bigTotalOdds)) bigTotalOdds = "0";
					if(dataArray[6].split(":").length > 1) homeMoneyLineOdds = dataArray[6].split(":")[1];
					if("".equals(homeMoneyLineOdds)) homeMoneyLineOdds = "0";
					if(dataArray[7].split(":").length > 1) homeHandicap = dataArray[7].split(":")[1].split(" ")[0];
					if("".equals(homeHandicap)) homeHandicap = "0";
					if(dataArray[7].split(":").length > 1) homeHandicapOdds = dataArray[7].split(":")[1].split(" ")[1];
					if("".equals(homeHandicapOdds)) homeHandicapOdds = "0";
					if(dataArray[8].split(":").length > 1) smallTotalOdds = dataArray[8].split(":")[1].split(" ")[2];
					if("".equals(smallTotalOdds)) smallTotalOdds = "0";
					if(dataArray[8].split(":").length > 1) total = dataArray[8].split(":")[1].split(" ")[1];
					if("".equals(total)) total = "0";
					System.out.println(awayTeam);
					System.out.println(homeTeam);
					System.out.println(awayMoneyLineOdds);
					System.out.println(awayHandicap);
					System.out.println(awayHandicapOdds);
					System.out.println(bigTotalOdds);
					System.out.println(homeMoneyLineOdds);
					if(!lastawayMoneyLineOdds.equals(awayMoneyLineOdds) || !lastawayHandicap.equals(awayHandicap)
					   || !lastawayHandicapOdds.equals(awayHandicapOdds) || !lastbigTotalOdds.equals(bigTotalOdds)
					   || !lasthomeMoneyLineOdds.equals(homeMoneyLineOdds) || !lasthomeHandicap.equals(homeHandicap)
					   || !lasthomeHandicapOdds.equals(homeHandicapOdds) || !lastsmallTotalOdds.equals(smallTotalOdds)
					   || !lasttotal.equals(total))
					{
//						rtnObj.put("dataDate", dataDate);
						rtnObj.put("dataTime", dataTime);
						rtnObj.put("dataSecond", dataSecond);
						rtnObj.put("awayTeam", awayTeam);
						rtnObj.put("awayMoneyLineOdds", awayMoneyLineOdds);
						rtnObj.put("awayHandicap", awayHandicap);
						rtnObj.put("awayHandicapOdds", awayHandicapOdds);
						rtnObj.put("homeTeam", homeTeam);
						rtnObj.put("homeMoneyLineOdds", homeMoneyLineOdds);
						rtnObj.put("homeHandicap", homeHandicap);
						rtnObj.put("homeHandicapOdds", homeHandicapOdds);
						rtnObj.put("total", total);
						rtnObj.put("bigTotalOdds", bigTotalOdds);
						rtnObj.put("smallTotalOdds", smallTotalOdds);
						rtnAry.put(rtnObj);
						lastawayMoneyLineOdds = awayMoneyLineOdds;
						lastawayHandicap = awayHandicap;
						lastawayHandicapOdds = awayHandicapOdds;
						lastbigTotalOdds = bigTotalOdds;
						lasthomeMoneyLineOdds = homeMoneyLineOdds;
						lasthomeHandicap = homeHandicap;
						lasthomeHandicapOdds = homeHandicapOdds;
						lastsmallTotalOdds = smallTotalOdds;
						lasttotal = total;
					}

				}
				yes_br.close();
			}
			if(file.exists()) {
				br = new BufferedReader(new InputStreamReader(f));
				String strLine= "";
//				String dataDate = "";//資料日期
				String dataTime = "";//資料時間
				String dataSecond = "";
//				String Systime = "";//系統時間(ms),for 圖表時間用
				String homeTeam = "";//主場隊伍
				String awayTeam = "";//客場隊伍
				String awayMoneyLineOdds = "";//客隊moneyline賠率
				String awayHandicapOdds = "";//客隊讓分賠率
				String awayHandicap = "";//客隊讓分
				String homeMoneyLineOdds = "";//主隊moneyline賠率
				String homeHandicapOdds = "";//主隊讓分賠率
				String homeHandicap = "";//主隊讓分
				String bigTotalOdds = "";//大分賠率
				String smallTotalOdds= "";//小分賠率
				String total = "";//大小分
				while((strLine = br.readLine()) != null){
					JSONObject rtnObj = new JSONObject();
					String[] dataArray = strLine.split("@");
//					for(int a=0;a< dataArray.length;a++)System.out.println(dataArray[a]);
					System.out.println(dataArray[0]);
//					dataDate = dataArray[0].split("_")[0];
					dataTime = dataArray[0].split("_")[0];
					dataSecond = dataArray[0].split("_")[1];
//					Systime = dataArray[0].split("_")[2];
					awayTeam = dataArray[1];
					homeTeam = dataArray[5];
					if(dataArray[2].split(":").length > 1) awayMoneyLineOdds = dataArray[2].split(":")[1];
					if("".equals(awayMoneyLineOdds)) awayMoneyLineOdds = "0";
					if(dataArray[3].split(":").length > 1)  awayHandicap = dataArray[3].split(":")[1].split(" ")[0];
					if("".equals(awayHandicap)) awayHandicap = "0";
					if(dataArray[3].split(":").length > 1) awayHandicapOdds = dataArray[3].split(":")[1].split(" ")[1];
					if("".equals(awayHandicapOdds)) awayHandicapOdds = "0";
					if(dataArray[4].split(":").length > 1) bigTotalOdds = dataArray[4].split(":")[1].split(" ")[2];
					if("".equals(bigTotalOdds)) bigTotalOdds = "0";
					if(dataArray[6].split(":").length > 1) homeMoneyLineOdds = dataArray[6].split(":")[1];
					if("".equals(homeMoneyLineOdds)) homeMoneyLineOdds = "0";
					if(dataArray[7].split(":").length > 1) homeHandicap = dataArray[7].split(":")[1].split(" ")[0];
					if("".equals(homeHandicap)) homeHandicap = "0";
					if(dataArray[7].split(":").length > 1) homeHandicapOdds = dataArray[7].split(":")[1].split(" ")[1];
					if("".equals(homeHandicapOdds)) homeHandicapOdds = "0";
					if(dataArray[8].split(":").length > 1) smallTotalOdds = dataArray[8].split(":")[1].split(" ")[2];
					if("".equals(smallTotalOdds)) smallTotalOdds = "0";
					if(dataArray[8].split(":").length > 1) total = dataArray[8].split(":")[1].split(" ")[1];
					if("".equals(total)) total = "0";
					System.out.println(awayTeam);
					System.out.println(homeTeam);
					System.out.println(awayMoneyLineOdds);
					System.out.println(awayHandicap);
					System.out.println(awayHandicapOdds);
					System.out.println(bigTotalOdds);
					System.out.println(homeMoneyLineOdds);
//					rtnObj.put("dataDate", dataDate);
					rtnObj.put("dataTime", dataTime);
					rtnObj.put("dataSecond", dataSecond);
					rtnObj.put("awayTeam", awayTeam);
					rtnObj.put("awayMoneyLineOdds", awayMoneyLineOdds);
					rtnObj.put("awayHandicap", awayHandicap);
					rtnObj.put("awayHandicapOdds", awayHandicapOdds);
					rtnObj.put("homeTeam", homeTeam);
					rtnObj.put("homeMoneyLineOdds", homeMoneyLineOdds);
					rtnObj.put("homeHandicap", homeHandicap);
					rtnObj.put("homeHandicapOdds", homeHandicapOdds);
					rtnObj.put("total", total);
					rtnObj.put("bigTotalOdds", bigTotalOdds);
					rtnObj.put("smallTotalOdds", smallTotalOdds);
					rtnAry.put(rtnObj);
				}
				br.close();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rtnAry;
	}
	//20190721先從網站得到game Name，再到DB搭配timestamp作select
	public static List<JSONObject> LoadDBData(int type) throws Exception{
//		List<JSONArray> result = new ArrayList<>();
		List<JSONObject> result= new ArrayList<JSONObject>();
		DesiredCapabilities capabilities = DesiredCapabilities.chrome(); // 設定使用的webdriver為google chrome
		ChromeOptions chromeOptions = new ChromeOptions();
		chromeOptions.addArguments("--headless");
		chromeOptions.addArguments("--disable-gpu");
		String home = System.getProperty("user.home");
		String os = System.getProperty("os.name");
		
		today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		yesterday = new SimpleDateFormat("yyyyMMdd").format(yesterday());
//		System.out.println("[Pony] : "+home);
		String path = home + File.separator + "project2Data" + File.separator;
		System.out.println("[Pony] : "+os);
		//======[Pony]Mac版把"chromedriver.exe"改回"chromedriver"就能用了
		if(os.contains("indows"))System.setProperty("webdriver.chrome.driver", path + CHROME_WINDOWS); // 設定要使用的webdriver exe file路徑
		else System.setProperty("webdriver.chrome.driver", path + CHROME_MAC);
		System.setProperty("webdriver.chrome.silentOutput", "true");
//		count = 0;
		driver = new ChromeDriver(chromeOptions);
		WebDriverWait wait = new WebDriverWait(driver, 3); // wait for webdriver start working
		switch (type){
		case 1:
			driver.get("https://www.pinnacle.com/en/odds/match/basketball/usa/nba?sport=True");
			tablename = "nbadata";
			break;
		case 2:
			driver.get("https://www.pinnacle.com/en/odds/match/baseball/usa/mlb?sport=True");
			tablename = "mlbdata";
			break;
		case 3:
			driver.get("https://www.pinnacle.com/en/odds/match/baseball/japan/nippon-professional-baseball");
			tablename = "npbdata";
			break;
		case 4:
			driver.get("https://www.pinnacle.com/en/odds/match/baseball/south-korea/korea-professional-baseball");
			tablename = "kbodata";
			break;
		}
		
		wait.until(new ExpectedCondition<Boolean>() {
		@Override
		public Boolean apply(WebDriver d) {
//		System.out.println("## login User and Password!");
		String s = driver.getPageSource(); //取得該page之source(html程式碼)

			today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			long todayval = Long.parseLong(today);
//			System.out.println(todayval);
				List<WebElement> teamname = driver.findElements(By.className("game-name")); //隊伍名稱
			try{
				Class.forName(driverName);
				Connection dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
				Statement st;
				st = dbConn.createStatement();
				for (int count = 0; count < teamname.size(); count ++ ){
					if(0 == (count % 2) && count < teamname.size()){
						String query = "select * from  " + tablename + " where ";
						query += "awayTeam = '" + teamname.get(count).getText().replace("\n","_") + "' and ";
						query += "homeTeam = '" + teamname.get(count+1).getText().replace("\n","_") + "'";
					
						//20190721,用Long來裝parseLong, +-超過5的話就不要裝進result中
						st = dbConn.createStatement();
					      // execute the query, and get a java resultset
					    ResultSet rs = st.executeQuery(query);
					    JSONArray rtnAry = new JSONArray();
				        while (rs.next())
				        {
				        	
				        	long gtime = Long.parseLong(rs.getString(11));
//				        	System.out.println(gtime);
				        	if((todayval - 4) < gtime){
//				        		System.out.println("parsing game");
				        		JSONObject rtnObj = new JSONObject();
								rtnObj.put("dataTime", rs.getString(2).split("_")[0]);
								rtnObj.put("dataSecond", rs.getString(2).split("_")[1]);
								rtnObj.put("awayTeam", rs.getString(3));
								rtnObj.put("awayMoneyLineOdds", rs.getString(4));
								rtnObj.put("awayHandicap", rs.getString(5).split(" ")[0]);
								rtnObj.put("awayHandicapOdds", rs.getString(5).split(" ")[1]);
								rtnObj.put("homeTeam", rs.getString(7));
								rtnObj.put("homeMoneyLineOdds", rs.getString(8));
								rtnObj.put("homeHandicap", rs.getString(9).split(" ")[0]);
								rtnObj.put("homeHandicapOdds", rs.getString(9).split(" ")[1]);
								if(rs.getString(6).split(" ").length > 2){
									rtnObj.put("total", rs.getString(6).split(" ")[1]);
									rtnObj.put("bigTotalOdds", rs.getString(6).split(" ")[2]);
								}else{
									rtnObj.put("total", "0");
									rtnObj.put("bigTotalOdds", "0");
								}
								if(rs.getString(10).split(" ").length > 2){
									rtnObj.put("smallTotalOdds", rs.getString(10).split(" ")[2]);
								}else{
									rtnObj.put("smallTotalOdds", "0");
								}
								
								rtnAry.put(rtnObj);
				        	}
				        }
				        JSONObject tmp = new JSONObject();
				        tmp.put("result", rtnAry);
				        result.add(tmp);
					}

			}
		}catch (Exception e){
			e.printStackTrace();
		}

        driver.quit();
		return true;
		}
		});

		return result;
	}
	
	//20190721先從網站得到game Name，再到DB搭配timestamp作select
	public static List<JSONObject> LoadHistoryData(int type,long timestamp) throws Exception{
//		List<JSONArray> result = new ArrayList<>();
		List<JSONObject> result= new ArrayList<JSONObject>();
		List<String> games = new ArrayList<>();
		String home = System.getProperty("user.home");
		String os = System.getProperty("os.name");

//		System.out.println("[Pony] : "+home);
		String path = home + File.separator + "project2Data" + File.separator;
		System.out.println("[Pony] : "+os);

		switch (type){
		case 1:
//			driver.get("https://www.pinnacle.com/en/odds/match/basketball/usa/nba?sport=True");
			tablename = "nbadata";
			break;
		case 2:
//			driver.get("https://www.pinnacle.com/en/odds/match/baseball/usa/mlb?sport=True");
			tablename = "mlbdata";
			break;
		case 3:
//			driver.get("https://www.pinnacle.com/en/odds/match/baseball/japan/nippon-professional-baseball");
			tablename = "npbdata";
			break;
		case 4:
//			driver.get("https://www.pinnacle.com/en/odds/match/baseball/south-korea/korea-professional-baseball");
			tablename = "kbodata";
			break;
		}
		
		try{
			Class.forName(driverName);
			Connection dbConn = DriverManager.getConnection(driverPath + path + DB_NAME + ".db");
			
			//20190803 Firstly select game at that timestamp
			Statement st;
//			st = dbConn.createStatement();

			String query = "select * from  " + tablename + " where timestamp = " + timestamp;
		
			//20190721,用Long來裝parseLong, +-超過5的話就不要裝進result中
			st = dbConn.createStatement();
		      // execute the query, and get a java resultset
		    ResultSet rs = st.executeQuery(query);
//		    if(!rs.first()) return null;
		    while(rs.next()){
		    	String gamename = rs.getString("awayTeam")+"&"+rs.getString("homeTeam");
		    	if(games.size()!=0){
		    		if(!games.contains(gamename))
		    			games.add(gamename);
		    	}else games.add(gamename);	
		    }
		    
		    for(String game : games){
//		    	System.out.println(game);
		    	String query_game = "select * from  " + tablename + " where awayTeam='"+game.split("&")[0]
		    						+ "' and homeTeam='"+game.split("&")[1]+"'";
		    	ResultSet rs_game = st.executeQuery(query_game);
		    	JSONArray rtnAry = new JSONArray();
		        while (rs_game.next())
		        {  	
		        	long gtime = Long.parseLong(rs.getString(11));

		        	if((timestamp - 3) < gtime || (timestamp + 3) > gtime){
//					        		System.out.println("parsing game");
		        		JSONObject rtnObj = new JSONObject();
						rtnObj.put("dataTime", rs_game.getString(2).split("_")[0]);
						rtnObj.put("dataSecond", rs_game.getString(2).split("_")[1]);
						rtnObj.put("awayTeam", rs_game.getString(3));
						rtnObj.put("awayMoneyLineOdds", rs_game.getString(4));
						rtnObj.put("awayHandicap", rs_game.getString(5).split(" ")[0]);
						rtnObj.put("awayHandicapOdds", rs_game.getString(5).split(" ")[1]);
						rtnObj.put("homeTeam", rs_game.getString(7));
						rtnObj.put("homeMoneyLineOdds", rs_game.getString(8));
						rtnObj.put("homeHandicap", rs_game.getString(9).split(" ")[0]);
						rtnObj.put("homeHandicapOdds", rs_game.getString(9).split(" ")[1]);
						if(rs_game.getString(6).split(" ").length > 2){
							rtnObj.put("total", rs_game.getString(6).split(" ")[1]);
							rtnObj.put("bigTotalOdds", rs_game.getString(6).split(" ")[2]);
						}else{
							rtnObj.put("total", "0");
							rtnObj.put("bigTotalOdds", "0");
						}
						if(rs.getString(10).split(" ").length > 2){
							rtnObj.put("smallTotalOdds", rs_game.getString(10).split(" ")[2]);
						}else{
							rtnObj.put("smallTotalOdds", "0");
						}
						rtnAry.put(rtnObj);
		        	}
		        }
		        JSONObject tmp = new JSONObject();
		        tmp.put("result", rtnAry);
		        result.add(tmp);
		    }
		}catch (Exception e){
			e.printStackTrace();
		}

		return result;
	}
	
	
	private static Date yesterday() {
	    final Calendar cal = Calendar.getInstance();
	    cal.add(Calendar.DATE, -1);
	    return cal.getTime();
	}
	public static void Deletecloseddata(File file){
		try{
			for(int i = 5;i <= 16; i++){
			    final Calendar cal = Calendar.getInstance();
			    cal.add(Calendar.DATE, -i);
				String date = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				System.out.println("[Pony] date = "+date);
				String delfileStr = file.getPath().replace(today, date);
//				delfileStr = delfileStr.replace(delfileStr.split("////")[6], "//");
				File del_file = new File(delfileStr);
				
				System.out.println("[Pony] del_file = "+del_file.getPath());
				if(del_file.exists()){
					if (del_file.isDirectory()) {
						System.out.println("[Pony] del_file.isDirectory()");
					    File[] entries = del_file.listFiles();
					    if (entries != null) {
					      for (File entry : entries) {
					    	  System.out.println("[Pony] delete entry");
					    	  if (!entry.delete()) {
					    		  	System.out.println("Failed to delete " + entry);
								  }
					      }
					    }
					  }
					  if (!del_file.delete()) {
						  System.out.println("Failed to delete " + del_file);
					  }
				}
			}
		}catch (Exception e){
			e.printStackTrace();
		}

	}
	
	public static void main(String args[])
	{
		Timer timer = new Timer();
		timer.schedule(new GetData(), 1000, 30000);
		timer.schedule(new GetMLBData(), 1000, 30000);
		timer.schedule(new GetNPBData(), 1000, 30000);
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//-------主要呼叫抓data function的兩行，可以把main這個function取消掉然後在別的java class呼叫
		today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		String home = System.getProperty("user.home");
		String path = home + File.separator + "project2Data" + File.separator;
		File NBAdirectory = new File(path + today + File.separator + "NBA");
		File MLBdirectory = new File(path + today + File.separator + "MLB");
		File NPBdirectory = new File(path + today + File.separator + "NPB");
		File[] fNBAList = NBAdirectory.listFiles();
		File[] fMLBList = MLBdirectory.listFiles();
		File[] fNPBList = NPBdirectory.listFiles();
		for(File file : fNBAList)
		try {
			
//			System.out.println(LoadData(file));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(File file : fMLBList)
		try {
			
			System.out.println(LoadData(file));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(File file : fNPBList)
		try {
			
//			System.out.println(LoadData(file));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//-------------------------------------------------------------------------
	}
}



