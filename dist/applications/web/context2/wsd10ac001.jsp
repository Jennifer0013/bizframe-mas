<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsdlManager" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.BizFrame" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%

/**
 * Insert WSDL
 *
 * @author Ho-Jin Seo
 * @author My-Kim
 * @version 1.0
 */

I18nStrings _i18n = I18nStrings.getInstance();
session = request.getSession(false);
String wsdlName = request.getParameter("wsdlName");
String keystoreObid = request.getParameter("keystore");
// wsd10ac002�� beClient���� �ٸ��� ������ �� �����Ƿ� wsd10ac001�� ����ϵ��� ���� myKim 2009.04.06
String beClientStr = request.getParameter("beClient");
int  beClient = Integer.parseInt(beClientStr);
String storageType = request.getParameter("storage_type");
storageType = (storageType== null ? String.valueOf(MxsConstants.AGREEMENT_STORAGE_TYPE_FILE) : storageType);

String actionUrl = "wsd20ms001.jsp";
String msg = "";
Wsdl wsdl = (Wsdl) session.getAttribute("wsdlVO");
wsdl.setStorageType(Integer.parseInt(storageType));
wsdl.setName(wsdlName);
wsdl.setKeystoreObid(keystoreObid);
wsdl.setBeClient(beClient);
wsdl.setCreatedBy(BizFrame.SYSTEM_USER_OBID);

//ServletContext ctx = session.getServletContext();
//ServletMapper mapper = new ServletMapper(ctx.getRealPath(""), wsdlName);
//mapper.add();

// J-.H. Kim on 2008.02.28
//MxsEngine engine = MxsEngine.getInstance();
//engine.storeWsdl("insert", wsdl);

WsdlManager wsdlMgr = new WsdlManager();
wsdlMgr.storeWsdl("insert", wsdl);
wsdlMgr.removeCacheWSDL(wsdl.getName());

%>
