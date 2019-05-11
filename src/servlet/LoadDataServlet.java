package servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Timer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import load.GetData;
import load.GetMLBData;
import load.LoadData;

public class LoadDataServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	private String today = "";
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		      throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String doAction = request.getParameter("doAction");
		List<JSONObject> json= new ArrayList<JSONObject>();
		if("loadData".equals(doAction)){
			
			//[Pony]0428-->Need to add datatype to separate which game????
			json = loadData(request, response);
		} else if ("startGetData".equals(doAction)) {
			Timer timer = new Timer();
			timer.schedule(new GetData(), 1000, 30000);
			timer.schedule(new GetMLBData(), 1000, 30000);
			timer.schedule(new GetData(), 1000, 30000);
			try {
				Thread.sleep(15000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		PrintWriter out = response.getWriter();
		out.println(json.toString());		
	}
	
	public List<JSONObject> loadData(HttpServletRequest request, HttpServletResponse response){
		List<JSONObject> rtnObj= new ArrayList<JSONObject>();
		JSONObject tmp;
		try {
			today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			String home = System.getProperty("user.home");
			String path = home + File.separator + "project2Data" + File.separator;
			File NBAdirectory = new File(path + today + File.separator + "NBA");
			File MLBdirectory = new File(path + today + File.separator + "MLB");
			File NPBdirectory = new File(path + today + File.separator + "NPB");
			File[] fNBAList = NBAdirectory.listFiles();
			File[] fMLBList = MLBdirectory.listFiles();
			File[] fNPBList = NPBdirectory.listFiles();
//			int count = 0;
			for(File file : fNBAList){
				tmp = new JSONObject();
				tmp.put("result", LoadData.LoadData(file));
				System.out.println(file.toString());
				rtnObj.add(tmp);
//				count++;
			}
			for(File file : fMLBList){
				tmp = new JSONObject();
				tmp.put("result", LoadData.LoadData(file));
				System.out.println(file.toString());
				rtnObj.add(tmp);
//				count++;
			}
			for(File file : fNPBList){
				tmp = new JSONObject();
				tmp.put("result", LoadData.LoadData(file));
				System.out.println(file.toString());
				rtnObj.add(tmp);
//				count++;
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
//			if(e.toString().equals("java.lang.NullPointerException"))
//			{
//				GetData.main(null);
//				File directory = new File("C:\\" + today);
//				File[] fList = directory.listFiles();
//				int count = 0;
//				for(File file : fList){
//					tmp = new JSONObject();
//					try {
//						tmp.put("result", LoadData.LoadData(file));
//					} catch (JSONException e1) {
//						// TODO Auto-generated catch block
//						e1.printStackTrace();
//					} catch (Exception e1) {
//						// TODO Auto-generated catch block
//						e1.printStackTrace();
//					}
//					System.out.println(file.toString());
//					rtnObj.add(tmp);
//					count++;
//				}
//				return rtnObj;
//			}
//				
//			else e.printStackTrace();
			e.printStackTrace();
		}
		return rtnObj;
	}
	
}
