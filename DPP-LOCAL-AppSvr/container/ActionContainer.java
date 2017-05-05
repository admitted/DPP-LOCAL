package container;

import bean.BaseCmdBean;
import util.CommUtil;

import java.net.InetAddress;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;

public class ActionContainer
{
	public static Hashtable<String, BaseCmdBean> objActionTable = null;//?????????��?
	private static Byte markActionTable = new Byte((byte)1);	
	
	private static TimeCheckThrd checkThrd = null;

	InetAddress addr = InetAddress.getLocalHost();
	public String m_LocalIp = addr.getHostAddress().toString();//??????IP
	
	public ActionContainer()throws Exception
	{	  
		
	}
	
	public static boolean Initialize()
	{
		boolean ret = false;
		try
		{
			objActionTable = new Hashtable<String, BaseCmdBean>(); 
			checkThrd = new TimeCheckThrd(30);
			checkThrd.start();
			ret = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return ret;
	}
	
	/*
	 * ???
	 */
	public static BaseCmdBean GetAction(String pKey)
	{
		BaseCmdBean bean = null;
		try
		{			
			synchronized(markActionTable)
			{
				if(!objActionTable.isEmpty() && objActionTable.containsKey(pKey))
				{
					bean = (BaseCmdBean) objActionTable.get(pKey);
					objActionTable.remove(pKey);		//???????????
				}
			}
		}
		catch(Exception exp)
		{		
			exp.printStackTrace();	
		}
		return bean;
	}
	
	/*
	 * ????
	 */
	public static void InsertAction(String pKey, BaseCmdBean bean)
	{
		try
		{			
			synchronized(markActionTable)					
			{
				if(objActionTable.containsKey(pKey))
				{
					CommUtil.PRINT("Key[" + pKey + "] Already Exist!");
					objActionTable.remove(pKey);		//????????????????
				}		
				objActionTable.put(pKey , bean);
			}
		}
		catch(Exception exp)
		{		
			exp.printStackTrace();	
		}
	}
	/*
	 * ???
	 */
	public static void RemoveAction(String pKey)
	{
		try
		{			
			synchronized(markActionTable)
			{
				if(!objActionTable.isEmpty() && objActionTable.containsKey(pKey))
				{
						objActionTable.remove(pKey);		//????????????????
					
				}
			}
		}
		catch(Exception exp)
		{		
			exp.printStackTrace();	
		}
	}
	public static LinkedList<String> GetTimeOutList(int mTimeOut)
	{
		LinkedList<String> checkList = new LinkedList<String>();		 //?????????��?,???????????????
	
		try
		{
			synchronized(markActionTable)
			{
				Enumeration<BaseCmdBean> en = objActionTable.elements();  
				while(en.hasMoreElements())
				{    
					BaseCmdBean client = en.nextElement();
				
					int TestTime = (int)(new java.util.Date().getTime()/1000);
					if(TestTime > client.getTestTime() + mTimeOut)
					{
						checkList.addLast(CommUtil.StrBRightFillSpace(client.getSeq(), 20));
					}
				}
			}
			while(!checkList.isEmpty())
			{
				String data = checkList.removeFirst();
				if(null ==  data)
				{
					break;
				}						
				BaseCmdBean bean = GetAction(data);
				if(null != bean)
					bean.noticeTimeOut();
				CommUtil.LOG(data + " ?????? 111");
			}
		}catch(Exception e)
		{}		
		return checkList;
	}	
}//ActionContainer