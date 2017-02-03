From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: unable to send mails to christophe.varoqui@opensvc.com
	using git
Date: Fri, 3 Feb 2017 09:58:52 +0000
Message-ID: <2d3265b9e6094cb2a3807d7c248c0c1b@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6357273366809818405=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6357273366809818405==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_2d3265b9e6094cb2a3807d7c248c0c1bBRMWPEXMB12corpbrocadec_"

--_000_2d3265b9e6094cb2a3807d7c248c0c1bBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi ,
Iam sending the patch to the community using the below command


# git send-email --to "device-mapper development <dm-devel@redhat.com>" --cc "Christophe Varoqui <christophe.varoqui@opensvc.com>" --no-chain-reply-to --suppress-from <dir>

But iam getting the below error.Can anyone help me what could be the issue.

This is a MIME-encapsulated message.

--82D12C7A87CC.1486115491/localhost.localdomain
Content-Description: Notification
Content-Type: text/plain; charset=us-ascii

This is the mail system at host localhost.localdomain.

I'm sorry to have to inform you that your message could not
be delivered to one or more recipients. It's attached below.

For further assistance, please send mail to postmaster.

If you do so, please include this problem report. You can
delete your own text from the attached returned message.

                   The mail system

<christophe.varoqui@opensvc.com>: host spool.mail.gandi.net[217.70.184.6] said:
    550 5.1.8 <root@localhost.localdomain>: Sender address rejected: Domain not
    found (in reply to RCPT TO command)

--82D12C7A87CC.1486115491/localhost.localdomain
Content-Description: Delivery report
Content-Type: message/delivery-status

Reporting-MTA: dns; localhost.localdomain
X-Postfix-Queue-ID: 82D12C7A87CC
X-Postfix-Sender: rfc822; root@localhost.localdomain
Arrival-Date: Fri,  3 Feb 2017 15:20:59 +0530 (IST)

Final-Recipient: rfc822; christophe.varoqui@opensvc.com
Action: failed
Status: 5.1.8
Remote-MTA: dns; spool.mail.gandi.net
Diagnostic-Code: smtp; 550 5.1.8 <root@localhost.localdomain>: Sender address
    rejected: Domain not found

--82D12C7A87CC.1486115491/localhost.localdomain
Content-Description: Undelivered Message
Content-Type: message/rfc822

Return-Path: <root@localhost.localdomain>
Received: by localhost.localdomain (Postfix, from userid 0)
        id 82D12C7A87CC; Fri,  3 Feb 2017 15:20:59 +0530 (IST)
From: M Muneendra Kumar <mmandala@brocade.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 0/1] multipathd: deterministic io throughput in multipath
Date: Fri,  3 Feb 2017 15:20:58 +0530
Message-Id: <1486115459-13377-1-git-send-email-mmandala@brocade.com>
X-Mailer: git-send-email 1.8.3.1

This patch adds three configuration parameters, "san_path_err_threshold",
"san_path_err_recovery_time" and "san_path_err_forget_rate".


Regards,
Muneendra.

--_000_2d3265b9e6094cb2a3807d7c248c0c1bBRMWPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi ,<o:p></o:p></p>
<p class=3D"MsoNormal">Iam sending the patch to the community using the bel=
ow command<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText"># git send-email --to &quot;device-mapper develop=
ment &lt;dm-devel@redhat.com&gt;&quot; --cc &quot;Christophe Varoqui &lt;ch=
ristophe.varoqui@opensvc.com&gt;&quot; --no-chain-reply-to --suppress-from =
&lt;dir&gt;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">But iam getting the below error.Can anyone help me w=
hat could be the issue.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"color:red">This is a MIME-encapsulate=
d message.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">--82D12C7A87CC.1486115491/=
localhost.localdomain<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Description: Notif=
ication<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Type: text/plain; =
charset=3Dus-ascii<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">This is the mail system at=
 host localhost.localdomain.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">I'm sorry to have to infor=
m you that your message could not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">be delivered to one or mor=
e recipients. It's attached below.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">For further assistance, pl=
ease send mail to postmaster.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">If you do so, please inclu=
de this problem report. You can<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">delete your own text from =
the attached returned message.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; The mail system<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">&lt;christophe.varoqui@ope=
nsvc.com&gt;: host spool.mail.gandi.net[217.70.184.6] said:<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:red">&nbsp;&nbsp;&nbsp; 550 5.1=
.8 &lt;root@localhost.localdomain&gt;: Sender address rejected: Domain not<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">&nbsp; &nbsp;&nbsp;found (=
in reply to RCPT TO command)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">--82D12C7A87CC.1486115491/=
localhost.localdomain<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Description: Deliv=
ery report<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Type: message/deli=
very-status<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">Reporting-MTA: dns; localh=
ost.localdomain<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">X-Postfix-Queue-ID: 82D12C=
7A87CC<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">X-Postfix-Sender: rfc822; =
root@localhost.localdomain<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Arrival-Date: Fri,&nbsp; 3=
 Feb 2017 15:20:59 &#43;0530 (IST)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">Final-Recipient: rfc822; c=
hristophe.varoqui@opensvc.com<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Action: failed<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Status: 5.1.8<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Remote-MTA: dns; spool.mai=
l.gandi.net<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Diagnostic-Code: smtp; 550=
 5.1.8 &lt;root@localhost.localdomain&gt;: Sender address<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:red">&nbsp;&nbsp;&nbsp; rejecte=
d: Domain not found<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">--82D12C7A87CC.1486115491/=
localhost.localdomain<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Description: Undel=
ivered Message<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Content-Type: message/rfc8=
22<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">Return-Path: &lt;root@loca=
lhost.localdomain&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Received: by localhost.loc=
aldomain (Postfix, from userid 0)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; id 82D12C7A87CC; Fri,&nbsp; 3 Feb 2017 15:20:59 &#43;0530 =
(IST)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">From: M Muneendra Kumar &l=
t;mmandala@brocade.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">To: device-mapper developm=
ent &lt;dm-devel@redhat.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Cc: Christophe Varoqui &lt=
;christophe.varoqui@opensvc.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Subject: [PATCH 0/1] multi=
pathd: deterministic io throughput in multipath<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Date: Fri,&nbsp; 3 Feb 201=
7 15:20:58 &#43;0530<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">Message-Id: &lt;1486115459=
-13377-1-git-send-email-mmandala@brocade.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red">X-Mailer: git-send-email 1=
.8.3.1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">This patch adds three conf=
iguration parameters, &quot;san_path_err_threshold&quot;,<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:red">&quot;san_path_err_recover=
y_time&quot; and &quot;san_path_err_forget_rate&quot;.<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:red">Regards,<br>
Muneendra.<o:p></o:p></span></p>
</div>
</body>
</html>

--_000_2d3265b9e6094cb2a3807d7c248c0c1bBRMWPEXMB12corpbrocadec_--


--===============6357273366809818405==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6357273366809818405==--
