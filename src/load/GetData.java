package load;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
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
public class GetData extends TimerTask {
	
	static List<WebElement> teamname; //隊伍名稱
	static List<WebElement> moneyline; //PK盤賠率
	static List<WebElement> handicap; // 讓分盤
	static List<WebElement> total; // 大小分
	static int count = 0;
	static String writecontent = "";
	static String today;
	
	public static class PinnacleGet {

		WebDriver driver = null;
		DesiredCapabilities capabilities = DesiredCapabilities.chrome(); // 設定使用的webdriver為google chrome
		ChromeOptions chromeOptions = new ChromeOptions();
		PinnacleGet() {
			chromeOptions.addArguments("--headless");
			chromeOptions.addArguments("--disable-gpu");
		}
	
 
	public void getdata(){
		String home = System.getProperty("user.home");
		String path = home + File.separator + "project2Data" + File.separator;
		//======[Pony]Mac版把"chromedriver.exe"改回"chromedriver"就能用了
		System.setProperty("webdriver.chrome.driver", path + "chromedriver.exe"); // 設定要使用的webdriver exe file路徑
		
		System.setProperty("webdriver.chrome.silentOutput", "true");
		count = 0;
		driver = new ChromeDriver(chromeOptions);
		WebDriverWait wait = new WebDriverWait(driver, 3); // wait for webdriver start working
		driver.get("https://www.pinnacle.com/en/odds/match/basketball/usa/nba?sport=True"); // 設定webdriver要讀取的url名稱
		System.out.println("##[Pony]Start getting source from betting website ");//屌之print step
		// Login
		wait.until(new ExpectedCondition<Boolean>() {
		@Override
		public Boolean apply(WebDriver d) {
//		System.out.println("## login User and Password!");
		String s = driver.getPageSource(); //取得該page之source(html程式碼)
//		System.out.print(s);
	//---------測試用，把所有的html source print出來方便爬element用，之後可以砍掉
//		try {
			today = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			File todaydir = new File(path + today + File.separator + "NBA");
			
			if(!todaydir.exists()) todaydir.mkdirs();
//			FileWriter fileWriter = new FileWriter(file);
//			fileWriter.write(s);
////			fileWriter.write("a test");
//			fileWriter.flush();
//			fileWriter.close();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
	//---------測試用，把所有的html source print出來方便爬element用，之後可以砍掉	
		
	//------------獲取html語法中的各項所需之element----------------------		
		teamname = driver.findElements(By.className("game-name")); //隊伍名稱
		moneyline = driver.findElements(By.className("game-moneyline")); //PK盤賠率
		handicap = driver.findElements(By.className("game-handicap")); // 讓分盤
		total = driver.findElements(By.className("game-total")); // 大小分
	//------------獲取html語法中的各項所需之element----------------------
		
	//-----------------編好寫入的檔案名稱、內容格式等並執行寫入function-----------	
        if (teamname.isEmpty()) {
//        	driver.quit();
       //     throw new RuntimeException("No text area found");
        }
        else {
            for (count = 0; count < teamname.size(); count ++ ){
            	if(0 == (count % 2) && count < teamname.size()){//yyyy/MM/dd_HHmmss
            		writecontent = new Date() // + "_" + System.currentTimeMillis()
							+ "@" + teamname.get(count).getText() + "@moneyline:" + moneyline.get(count).getText()
							+ "@handicap:" + handicap.get(count).getText() + "@total:" + total.get(count).getText().replace("\n", " ")
							+ "@" + teamname.get(count+1).getText() + "@moneyline:" + moneyline.get(count+1).getText()
							+ "@handicap:" + handicap.get(count+1).getText() + "@total:" + total.get(count+1).getText().replace("\n", " ") + "\n";
            		try {
            			File file = new File(path + today + File.separator + "NBA" + File.separator + "game_at_" + teamname.get(count+1).getText() + ".txt");
            			if(!file.exists()){
            				file.createNewFile();
            			}
            			writeText(writecontent, path + today + File.separator + "NBA" + File.separator + "game_at_" + teamname.get(count+1).getText() + ".txt", "utf8", true);
            		} catch (IOException e) {
            			e.printStackTrace();
            		}
            	}
            }
        }
   //-----------------編好寫入的檔案名稱、內容格式等並執行寫入function-----------	    
        

        driver.quit();
		return true;
		}
		});

		}
	/**
	* @param args
	*/
	}
	
	public static void main(String args[]){
		//-------主要呼叫抓data function的兩行，可以把main這個function取消掉然後在別的java class呼叫
		Timer timer = new Timer();
		timer.schedule(new GetData(), 1000, 30000);
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
	

	@Override
	public void run() { //Thread所執行的工作內容，主要工作為new一個新的get data function並開始執行
		// TODO Auto-generated method stub
		PinnacleGet gl = new PinnacleGet(); 
		gl.getdata();
	}

	
}
