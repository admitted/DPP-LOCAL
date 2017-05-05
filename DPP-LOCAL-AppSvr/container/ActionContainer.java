package container;

import bean.BaseCmdBean;
import util.CommUtil;

import java.net.InetAddress;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;

/**
 * 指令回复容器
 * 类里的方法都是 static 方法，相当于一个工具类
 */
public class ActionContainer {
    public static Hashtable<String, BaseCmdBean> objActionTable = null;  //登陆客户端列表
    private static Byte markActionTable = new Byte((byte) 1);            //锁

    private static TimeCheckThrd checkThrd = null;

    InetAddress addr = InetAddress.getLocalHost();                       //返回本地主机
    public String m_LocalIp = addr.getHostAddress().toString();          //获得本机 IP String

    public ActionContainer() throws Exception {
    }

    /**
     * 初始化 客户端列表objActionTable 、时间校验线程checkThrd
     * 并启动线程 checkThrd
     * @return
     */
    public static boolean Initialize() {
        boolean ret = false;
        try {
            objActionTable = new Hashtable<String, BaseCmdBean>();       //初始化客户端列表 (此时为空)
            checkThrd = new TimeCheckThrd(30);
            checkThrd.start();
            ret = true;                                                  //如果出现异常 ,执行不到这一步
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ret;
    }

    /**
     * 根据(实际上的objActionTable key值) 返回特定的 BaseCmdBean
     * 并删除此 key值
     * @param pKey
     * @return BaseCmdBean
     */
    public static BaseCmdBean GetAction(String pKey) {
        BaseCmdBean bean = null;
        try {
            synchronized (markActionTable) {
                if (!objActionTable.isEmpty() && objActionTable.containsKey(pKey)) {
                    bean = (BaseCmdBean) objActionTable.get(pKey);
                    objActionTable.remove(pKey);        //在哈希表里移除
                }
            }
        } catch (Exception exp) {
            exp.printStackTrace();
        }
        return bean;
    }

    /**
     * 向objActionTable 插入一个 键值对 (pKey,baseCmdBean)
     * @param pKey
     * @param bean
     */
    public static void InsertAction(String pKey, BaseCmdBean bean) {
        try {
            synchronized (markActionTable) {
                if (objActionTable.containsKey(pKey)) {
                    CommUtil.PRINT("Key[" + pKey + "] Already Exist!");
                    objActionTable.remove(pKey);        //在哈希表里移除客户端
                }
                objActionTable.put(pKey, bean);
            }
        } catch (Exception exp) {
            exp.printStackTrace();
        }
    }

    /**
     * 从objActionTable 删除 一个 键值对 (pKey,baseCmdBean)
     * @param pKey
     */
    public static void RemoveAction(String pKey) {
        try {
            synchronized (markActionTable) {
                if (!objActionTable.isEmpty() && objActionTable.containsKey(pKey)) {
                    objActionTable.remove(pKey);        //在哈希表里移除客户端
                }
            }
        } catch (Exception exp) {
            exp.printStackTrace();
        }
    }

    /**
     * 获取 登陆客户端 超时列表 (回应时间大于30秒的)
     * 并将 超时客户端列表 打印出来
     * @param mTimeOut 30
     * @return LinkedList<String>  client.getSeq()
     */
    public static LinkedList<String> GetTimeOutList(int mTimeOut)    // m_TimeOut = 30
    {
        LinkedList<String> checkList = new LinkedList<String>();          // 接收数据列表,用于客户端数据交换

        try {
            synchronized (markActionTable) {
                Enumeration<BaseCmdBean> en = objActionTable.elements();  // 返回此 objActionTable 值的枚举
                while (en.hasMoreElements()) {
                    BaseCmdBean client = en.nextElement();

                    int TestTime = (int) (new java.util.Date().getTime() / 1000);  // 当前时间值
                    if (TestTime > client.getTestTime() + mTimeOut)                // 如果时间 超过 30 秒
                    {
                        checkList.addLast(CommUtil.StrBRightFillSpace(client.getSeq(), 20));
                    }
                }
            }
            while (!checkList.isEmpty()) {
                String data = checkList.removeFirst();
                if (null == data) {
                    break;
                }
                BaseCmdBean bean = GetAction(data);  // 删除 objActionTable 超时客户端
                if (null != bean)
                    bean.noticeTimeOut();            // 因为子类没有重写，方法为空

                CommUtil.LOG(data + " 回应超时 111"); // 第一次打印超时
            }
        } catch (Exception e) {
        }
        return checkList;
    }
}//ActionContainer