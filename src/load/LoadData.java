package load;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;

import org.json.JSONArray;
import org.json.JSONObject;

public class LoadData {

	static String today;
	static String yesterday;
	
	public static JSONArray LoadData(File file) throws Exception{
		FileInputStream f = new FileInputStream(file);
		BufferedReader br;
		JSONArray rtnAry = new JSONArray();
		System.out.println("[Pony] file = " + file.getPath());
		yesterday = new SimpleDateFormat("yyyyMMdd").format(yesterday());
		System.out.println("[Pony] yesterday = "+yesterday);
		File yes_file = new File(file.getPath().replace(file.getPath().split("\\\\")[4], yesterday));
		System.out.println("[Pony] Yesterday file = " + yes_file.getPath());
		Deletecloseddata(file);
		try {
			if(yes_file.exists()){
				FileInputStream yes_f = new FileInputStream(yes_file);
				BufferedReader yes_br = new BufferedReader(new InputStreamReader(yes_f));
				String strLine= "";
//				String dataDate = "";//資料日期
				String dataTime = "";//資料時間
//				String Systime = "";//系統時間(ms),for 圖表時間用
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
					for(int a=0;a< dataArray.length;a++)System.out.println(dataArray[a]);
//					dataDate = dataArray[0].split("_")[0];
					dataTime = dataArray[0];
//					Systime = dataArray[0].split("_")[2];
					awayTeam = dataArray[1];
					homeTeam = dataArray[5];
					awayMoneyLineOdds = dataArray[2].split(":")[1];
					awayHandicap = dataArray[3].split(":")[1].split(" ")[0];
					awayHandicapOdds = dataArray[3].split(":")[1].split(" ")[1];
					bigTotalOdds = dataArray[4].split(":")[1].split(" ")[2];
					homeMoneyLineOdds = dataArray[6].split(":")[1];
					homeHandicap = dataArray[7].split(":")[1].split(" ")[0];
					homeHandicapOdds = dataArray[7].split(":")[1].split(" ")[1];
					smallTotalOdds = dataArray[8].split(":")[1].split(" ")[2];
					total = dataArray[8].split(":")[1].split(" ")[1];
					if(!lastawayMoneyLineOdds.equals(awayMoneyLineOdds) || !lastawayHandicap.equals(awayHandicap)
					   || !lastawayHandicapOdds.equals(awayHandicapOdds) || !lastbigTotalOdds.equals(bigTotalOdds)
					   || !lasthomeMoneyLineOdds.equals(homeMoneyLineOdds) || !lasthomeHandicap.equals(homeHandicap)
					   || !lasthomeHandicapOdds.equals(homeHandicapOdds) || !lastsmallTotalOdds.equals(smallTotalOdds)
					   || !lasttotal.equals(total))
					{
//						rtnObj.put("dataDate", dataDate);
						rtnObj.put("dataTime", dataTime);
//						rtnObj.put("sysTime", Systime);
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
					for(int a=0;a< dataArray.length;a++)System.out.println(dataArray[a]);
//					dataDate = dataArray[0].split("_")[0];
					dataTime = dataArray[0];
//					Systime = dataArray[0].split("_")[2];
					awayTeam = dataArray[1];
					homeTeam = dataArray[5];
					awayMoneyLineOdds = dataArray[2].split(":")[1];
					awayHandicap = dataArray[3].split(":")[1].split(" ")[0];
					awayHandicapOdds = dataArray[3].split(":")[1].split(" ")[1];
					bigTotalOdds = dataArray[4].split(":")[1].split(" ")[2];
					homeMoneyLineOdds = dataArray[6].split(":")[1];
					homeHandicap = dataArray[7].split(":")[1].split(" ")[0];
					homeHandicapOdds = dataArray[7].split(":")[1].split(" ")[1];
					smallTotalOdds = dataArray[8].split(":")[1].split(" ")[2];
					total = dataArray[8].split(":")[1].split(" ")[1];
//					rtnObj.put("dataDate", dataDate);
					rtnObj.put("dataTime", dataTime);
//					rtnObj.put("sysTime", Systime);
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
	
	private static Date yesterday() {
	    final Calendar cal = Calendar.getInstance();
	    cal.add(Calendar.DATE, -1);
	    return cal.getTime();
	}
	private static void Deletecloseddata(File file){
		
		for(int i = 3;i <= 7; i++){
		    final Calendar cal = Calendar.getInstance();
		    cal.add(Calendar.DATE, -i);
			String date = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			System.out.println("[Pony] date = "+date);
			String delfileStr = file.getPath().replace(file.getPath().split("\\\\")[4], date);
			delfileStr = delfileStr.replace(delfileStr.split("\\\\")[6], "\\");
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



