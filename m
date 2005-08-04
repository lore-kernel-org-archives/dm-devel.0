From: "Qi, Yanling" <yanling.qi@engenio.com>
Subject: hw_handler_type callback functions
Date: Thu, 4 Aug 2005 12:28:27 -0500
Message-ID: <53CF1076699CD711B7DD0002A51363F10D92DDEE@exw-ks.ks.lsil.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1492447222=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============1492447222==
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C59919.43231272"

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C59919.43231272
Content-Type: text/plain;
	charset="iso-8859-1"

Hi All,
 
Is there any documents that describe what the 5 callback functions do and when do they invoked?
 
struct hw_handler_type {
 char *name;
 struct module *module;
 
 hwh_ctr_fn ctr;
 hwh_dtr_fn dtr;
 
 hwh_pg_init_fn pg_init;
 hwh_err_fn err;
 hwh_status_fn status;
};
 
Thanks,
 
Yanling 

------_=_NextPart_001_01C59919.43231272
Content-Type: text/html;
	charset="iso-8859-1"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">


<META content="MSHTML 6.00.2800.1400" name=GENERATOR></HEAD>
<BODY>
<DIV><FONT face=Arial size=2><SPAN class=790342517-04082005>Hi 
All,</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=790342517-04082005></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2><SPAN class=790342517-04082005>Is there any 
documents that describe what the 5 callback functions do and when do they 
invoked?</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>struct hw_handler_type {<BR>&nbsp;char 
*name;<BR>&nbsp;struct module *module;</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>&nbsp;hwh_ctr_fn ctr;<BR>&nbsp;hwh_dtr_fn 
dtr;</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>&nbsp;hwh_pg_init_fn pg_init;<BR>&nbsp;hwh_err_fn 
err;<BR>&nbsp;hwh_status_fn status;<BR>};</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><SPAN class=790342517-04082005><FONT face=Arial 
size=2>Thanks,</FONT></SPAN></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>Yanling </FONT></DIV></BODY></HTML>

------_=_NextPart_001_01C59919.43231272--


--===============1492447222==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1492447222==--
