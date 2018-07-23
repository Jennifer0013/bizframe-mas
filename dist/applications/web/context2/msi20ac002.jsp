<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ServiceBindingVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppPerformerVO"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
	/**
	 * @author Gemini Kim
	 * @author Ho-Jin Seo
	 * @author Mi-Young Kim
	 * @version 1.0
	 */

	// ============ get cpaList ================
	String cpa_obid	 = request.getParameter("cpa.obid");

	int totalRows  = 0;

	ArrayList performerVOList				  = null;
	CpaVO cpaVO	 = null;

	ServiceBindingVO  serviceBindingVO  = null;
	ArrayList actionVOList				  = null;
	ActionVO actionVO						 = null;
	AppPerformerVO performerVO			 = null;
	// CanSend ���� CanReceive �� �����ϱ� ���� �ĺ��� ����... "(*)" �� ǥ����...
	//String optional_flag					 = null;

	MxsEngine engine  = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();

	qc.add("obid", cpa_obid);
	cpaVO = (CpaVO)engine.getObject("Cpa", qc, DAOFactory.EBMS);


	qc = new QueryCondition();
	qc.add("cpa_obid", cpa_obid);
	qc.add("party_name", cpaVO.getPartyName());
	serviceBindingVO = (ServiceBindingVO)engine.getObject("ServiceBinding", qc, DAOFactory.EBMS);

	qc = new QueryCondition();
	qc.add("service_binding_obid", serviceBindingVO.getObid());
	actionVOList = (ArrayList)engine.getObjects("Action", qc, DAOFactory.EBMS);

	qc = new QueryCondition();
	qc.add("servicebinding.obid", serviceBindingVO.getObid());
	performerVOList = (ArrayList)engine.getObjects("AppPerformer", qc, DAOFactory.EBMS);

	if(performerVOList==null)
		performerVOList = new ArrayList();

	int service_action_num  = actionVOList.size();
	int performer_size		= performerVOList.size();

	totalRows = actionVOList.size();

	JSONObject json		= new JSONObject();
	JSONArray json_array = new JSONArray();

	json.put("list", json_array);
	json.put("totalRows", totalRows);
	json.put("cpaid", cpaVO.getCpaId());
	json.put("cpaName", cpaVO.getCpaName());
	json.put("cpaRole", cpaVO.getPartyName());

	// CPA, Service �ؿ� �ִ� ��� Action �� ���ؼ� Performer �� ������...
	// Action�� �ش��ϴ� Performer�� ���� ���� [performerVO.setPerformerName("UnDefined");] �� �ؼ�
	// �űԷ� �����Ͽ� performerVOList[ArrayList]�� �߰���...

	for(int i=0; i<service_action_num; i++) {
		boolean find = false;
		actionVO = (ActionVO)actionVOList.get(i);

		if(actionVO.getType() == EbConstants.ACTION_CANSEND) {
			continue;
		}
		// cansend�� canreceive�� dispacher�� �ȳѱ������� by MY-Kim on 2008.03.14
		// cansend�� canreceive�� performer�� �����Ǿ������� thread�� dispatcher�ѱ⵵��  by MY-Kim on 2008.11.27
	    /*if(actionVO.getParentObid() != null && actionVO.getParentObid().length() > 0) {
	    	continue;
	    }*/
		//optional_flag = actionVO.getParentObid() != null?optional_flag="(*)":"";
		for(int j=0; j<performer_size; j++) {
			performerVO = (AppPerformerVO)performerVOList.get(j);
			if(performerVO.getCanReceiveObid().equals(actionVO.getObid())) {
				find = true;
				performerVO.setAction(actionVO.getAbAction());
				break;
			}
		}

		if(!find) {
			performerVO = new AppPerformerVO();
			performerVO.setCpaId(cpaVO.getObid());
			performerVO.setService(serviceBindingVO.getService());
			performerVO.setServiceBindingObid(serviceBindingVO.getObid());
			performerVO.setCanReceiveObid(actionVO.getObid());
			performerVO.setAppType(EbConstants.APP_PERFORMER);
			//performerVO.setPerformerName("UnDefined");
			performerVO.setPerformerName("");
			performerVO.setAction(actionVO.getAbAction());
			performerVOList.add(performerVO);
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("cpaObid",		cpaVO.getObid());
		jsonObj.put("service",		performerVO.getService());
		jsonObj.put("serviceObid",	performerVO.getServiceBindingObid());
		jsonObj.put("actionObid",	performerVO.getCanReceiveObid());
		jsonObj.put("appType",		performerVO.getAppType());
		jsonObj.put("performObid",	performerVO.getObid());
		jsonObj.put("performName",	StringUtil.nullCheck(performerVO.getPerformerName()));
		// by bumma on 2008.05.22 channelObid �߰�(������ �����־ �α��� ó������ ������ư�� ������ ä����������� ����)
		jsonObj.put("channelObid",	performerVO.getQueueObid());
		jsonObj.put("action",		performerVO.getAction());

		String perform_selected = performerVO.getAppType()==EbConstants.APP_PERFORMER?" selected":"";
		String channel_selected = performerVO.getAppType()==EbConstants.APP_CONSUMEER_QUEUE?" selected":"";
		String remote_selected = performerVO.getAppType()==EbConstants.APP_REMOTE_PERFORMER?" selected":"";
		String visible_val		= channel_selected.equals("selected")?"visible":"hidden";
		jsonObj.put("visible",			visible_val);

		jsonObj.put("perform_selected",			  perform_selected);
		jsonObj.put("channel_selected",			  channel_selected);
		jsonObj.put("remote_selected",			  remote_selected);
		json_array.put(jsonObj);
	}
	out.print(json);
%>
