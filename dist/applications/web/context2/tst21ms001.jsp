<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="javax.mail.internet.MimeUtility" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.msi.EbClientMessage"%>
<%@ page import="kr.co.bizframe.mxs.ebms.msi.EbClientPayload"%>
<%
/**
 * ebXML Test Report Page
 *
 * @author Mi-Young Kim
 * @version 1.0
 */
 EbClientMessage msg = null;
try {
    String cpaId = "";
	byte[] payloadByte1 = null; //÷������
	String payloadName = null;
	byte[] bodyBytes = null; //�Է��� �ؽ�Ʈ����
	String bodyMsg="";

	String fromPartyId = "";
	String fromPartyIdType = "";
	String toPartyId = "";
	String toPartyIdType = "";

	String service = "";
	String action="";

	DiskFileUpload upload = new DiskFileUpload();
	List items = null;

	try{
		items = upload.parseRequest(request);
	}
	catch(Exception e){
		throw new Exception("Failed to upload the file: "+e.getMessage());
	}

	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem)ob;
		if( !item.isFormField()){
			if(item.getName() != null && !item.getName().equals("") && item != null ){
				try{
					payloadName = item.getName();
					InputStream uploadedStream = item.getInputStream();
					payloadByte1 = null;
					int size2;
					byte[] buffer2 = new byte[4096];
					final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
					while((size2 = uploadedStream.read(buffer2)) != -1){
						baos2.write(buffer2, 0, size2);
					}
					payloadByte1 = baos2.toByteArray();
					baos2.close();
					uploadedStream.close();
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else //���ʵ�
		{
			if(item.getFieldName().equals("cpaIdVal")) {
				cpaId = item.getString();
			}

			if(item.getFieldName().equals("body_content")) {
				 bodyMsg = item.getString();
				 if(bodyMsg !=null && !bodyMsg.equals("") && bodyMsg.length() > 0)
					 bodyBytes = bodyMsg.getBytes();
			}

		    if(item.getFieldName().equals("serviceVal")) {
				 service = item.getString();
			}

		    if(item.getFieldName().equals("actionVal")) {
				 action = item.getString();
			}

		    if(item.getFieldName().equals("fromPartyId")) {
		    	fromPartyId = item.getString();
			}

		    if(item.getFieldName().equals("fromPartyIdType")) {
		    	fromPartyIdType = item.getString();
			}

		    if(item.getFieldName().equals("toPartyId")) {
		    	toPartyId = item.getString();
			}

		    if(item.getFieldName().equals("toPartyIdType")) {
		    	toPartyIdType = item.getString();
			}

		}
	} //while end

	msg = new EbClientMessage();
    SimpleDateFormat sdf = new SimpleDateFormat("MMddhhmmss");
    String date = sdf.format(Calendar.getInstance().getTime());
    msg.setFromPartyId(fromPartyId);
    msg.setToPartyId(toPartyId);
    msg.setFromPartyIdType(fromPartyIdType);
    msg.setToPartyIdType(toPartyIdType);
    msg.setCpaId(cpaId);
    msg.setConversationId(cpaId + ":" + date.toString());
    msg.setService(service);
    msg.setAction(action);

	if (bodyBytes != null && bodyBytes.length > 0) {
		EbClientPayload p1 = new EbClientPayload();
		p1.setSource(new ByteArrayInputStream(bodyBytes));
		msg.addPayload(p1);
	}

	// Payload ÷��
	if (payloadByte1 != null && payloadByte1.length > 0 ) {
		EbClientPayload p1 = new EbClientPayload();
		p1.setSource(new ByteArrayInputStream(payloadByte1));
		p1.setOriFilename(payloadName);

		msg.addPayload(p1);
	}

	EbClientMessage ret = (EbClientMessage)MxsEngine.getInstance().sendMessage(msg,MxsConstants.EBMS);

	/*if (ret != null) {
		for (int k=0; k<ret.getPayloads().size(); k++) {
			EbClientPayload payload = (EbClientPayload)ret.getPayloads().get(k);
		}
	}*/
} catch (Exception e) {
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
</head>
<body>
<!-- �������̺� -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.result")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<%= I18nStrings.getInstance().get("tst.result.fail") %>
<br>
<%= e.getMessage() %>
<br>
<!-- ��ư���̺� -->
<table class="TableLayout" >
  <tr>
    <td align="left" style="padding-top:15">
      <a href="tst00ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
<%
	return;
}
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function viewMessage(id)
{
	window.open("msg21ms001.jsp?id=" + id, "_blank");
}
function viewRefMessage(id)
{
	window.open("msg21ms001.jsp?refId=" + id, "_blank");
}

//-->
</script>
</head>
<body>
<!-- �������̺� -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.result")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- ������ ���̺�-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.sent") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewMessage('<%=msg.getMessageId()%>')"><%=msg.getMessageId()%></a></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.received") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewRefMessage('<%=msg.getMessageId()%>')"><%= _i18n.get("tst.result.view") %></a></td>
  </tr>
</table>

<!-- ��ư���̺� -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="tst00ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</body>
</html>
