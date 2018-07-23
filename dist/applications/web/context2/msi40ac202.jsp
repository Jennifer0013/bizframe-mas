<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChToSubRelVO"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%
/**
 * @author Gemini Kim
 * @author Mi-Young Kim
 * @version 1.0
 */
   String[] obid_arr       = request.getParameterValues("chToSubObid");
   try {
      if(obid_arr == null) return;
      //DAOFactory df                 = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      //MxsDAO appchtosubrel_dao      = df.getDAO("AppChToSubRel");
      //MxsDAO appchannel_dao         = df.getDAO("AppChannel");
      MxsEngine engine = MxsEngine.getInstance();

      for (int i = 0; i <obid_arr.length; i++) {
         // Step.1 [������-ä��]���̺���  �������� ����...
         AppChToSubRelVO vo = new AppChToSubRelVO();
         vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
         vo.setObid(obid_arr[i]);
         String channelObid = request.getParameter(obid_arr[i]+"_channelObid");
         vo.setQueueObid(channelObid);
         engine.deleteObject("AppChToSubRel", vo, DAOFactory.EBMS);
         //appchtosubrel_dao.deleteObject(vo);

		 // 1�� �ܰ迡�� ��� �����ϵ��� ���� by Mi-Young Kim on 2008.05.22
         // Step.2 [������-ä��]���̺��� �����ڼ� ����(�����ڼ� <= �����ڼ�-1)
         //String channelObid = request.getParameter(obid_arr[i]+"_channelObid");
         //QueryCondition qc = new QueryCondition();
         //qc.add("obid", channelObid);
         //AppChannelVO channel_vo = (AppChannelVO)engine.getObject("AppChannel", qc, DAOFactory.EBMS);
         //int num_subscriber = channel_vo.getNumSubscriber();
         //num_subscriber--;
         //channel_vo.setNumSubscriber(num_subscriber);
         //engine.updateObject("AppChannel", channel_vo, DAOFactory.EBMS);
         //appchannel_dao.updateObject(channel_vo);

      }
   } catch (Exception e) {
      e.printStackTrace();
   }

%>

