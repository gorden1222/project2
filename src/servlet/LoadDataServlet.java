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
import load.GetKBOData;
import load.GetMLBData;
import load.GetNPBData;
import load.LoadData;

public class LoadDataServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	private String today = "";
	private boolean isspidering = false;
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		      throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String doAction = request.getParameter("doAction");
		List<JSONObject> json= new ArrayList<JSONObject>();
		if("loadData".equals(doAction)){
			
			//[Pony]0428-->Need to add datatype to separate which game????
			json = loadData(request, response, request.getParameter("type"));
			System.out.println("isSpidering = "+isspidering);
		} else if ("startGetData".equals(doAction)) {
			System.out.println("startGetData");
			isspidering = true;
			Timer timer = new Timer();
			timer.schedule(new GetData(), 1000, 60000);
			timer.schedule(new GetMLBData(), 1000, 60000);
			timer.schedule(new GetNPBData(), 1000, 60000);
			timer.schedule(new GetKBOData(), 1000, 60000);
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
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		      throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String doAction = request.getParameter("doAction");
		List<JSONObject> json= new ArrayList<JSONObject>();
		if("loadData".equals(doAction)){
			
			//[Pony]0428-->Need to add datatype to separate which game????
			json = loadData(request, response, request.getParameter("type"));
			System.out.println("isSpidering = "+isspidering);
		} else if ("startGetData".equals(doAction)) {
			System.out.println("startGetData");
			isspidering = true;
			Timer timer = new Timer();
			timer.schedule(new GetData(), 1000, 60000);
			timer.schedule(new GetMLBData(), 1000, 60000);
			timer.schedule(new GetNPBData(), 1000, 60000);
			timer.schedule(new GetKBOData(), 1000, 60000);
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
	
	public List<JSONObject> loadData(HttpServletRequest request, HttpServletResponse response,String type){
		List<JSONObject> rtnObj= new ArrayList<JSONObject>();
		JSONObject tmp;
		try {
			today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			String home = System.getProperty("user.home");
			String path = home + File.separator + "project2Data" + File.separator;
			File Filedirectory = new File(path + today + File.separator + type);
			File[] fList = Filedirectory.listFiles();
			for(File file : fList){
			tmp = new JSONObject();
			tmp.put("result", LoadData.LoadData(file));
		//	System.out.println(file.toString());
			rtnObj.add(tmp);
//			count++;
		}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rtnObj;
	}
	
}
