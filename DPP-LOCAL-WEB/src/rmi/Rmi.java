package rmi;
import java.rmi.Remote;
import java.rmi.RemoteException;
import util.*;

/**Զ�̷������ýӿ�
 * @author Cui
 *���� public MsgBean RmiExec(int pCmd, RmiBean pBean, int CurrPage) ����
 */
public interface Rmi extends Remote
{
	public boolean Test()throws RemoteException;
	
	
	/**����cmd���� , �����pBean , CurrPage��ǰҳ�� 
	 **case 0: ��ѯ ;
	 * case 1: ��ɾ�� ;
	 * case 2: Function�������� ;
	 * case 3: Package���� ;   ?oracle.jdbc����?
	 * case 4: Producer���� ;
	 * @see rmi.Rmi#RmiExec(int, rmi.RmiBean, int, int)
	 * @param PageSize TODO
	 */
	public MsgBean RmiExec(int pCmd, RmiBean pBean, int CurrPage, int PageSize) throws RemoteException;
}