Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A542C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 12 Oct 2022 07:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665560007;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-unsubscribe-post:list-subscribe:list-post;
	bh=bJQ8nqnqQni/yJOdloaUDdNCRm2lSbG3ePBBtXcSJ44=;
	b=R330zXTQPYpfDWvnfeVTXMT9bDiLH/OC5RkuFARi4T1DP417zK/tebHW/twxUsZhV+HO9t
	BNRj6mVgcaGtbjbNUOZ6CMI6RXVGl8LSGCU5Lv9/v8W+z8F7VobDIsWcRtqtcS0KFJHXDS
	EhqHM7wom0AksoMTTxwm5Yg1U5tOc6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-nIgr3w7_OK-ozAhTa6I1Rw-1; Wed, 12 Oct 2022 03:33:26 -0400
X-MC-Unique: nIgr3w7_OK-ozAhTa6I1Rw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F1B6185A7AF;
	Wed, 12 Oct 2022 07:33:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 156402166B32;
	Wed, 12 Oct 2022 07:33:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D35FD194658F;
	Wed, 12 Oct 2022 07:33:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B6418194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 19:20:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FC022083A16; Tue, 11 Oct 2022 19:20:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98391207B36F
 for <dm-devel@redhat.com>; Tue, 11 Oct 2022 19:20:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 761CF85A583
 for <dm-devel@redhat.com>; Tue, 11 Oct 2022 19:20:35 +0000 (UTC)
Received: from o29.p25.mailjet.com (o29.p25.mailjet.com [185.189.236.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-250-qm_Qkt6pNsCsqRvxG2iqUQ-1; Tue,
 11 Oct 2022 15:20:33 -0400
X-MC-Unique: qm_Qkt6pNsCsqRvxG2iqUQ-1
Message-Id: <2bfe964b.AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_@mailjet.com>
MIME-Version: 1.0
From: Jesse Dougherty <jesse@cypress-tech.com>
To: dm-devel@redhat.com
Date: Tue, 11 Oct 2022 19:20:30 +0000 (UTC)
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Feedback-Id: 42.1189921.1191387:MJ
Precedence: bulk
X-CampaignID: 7663542710
X-CSA-Complaints: csa-complaints@eco.de
X-MJ-Mid: AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwASLds
X-MJ-SMTPGUID: cdcb3013-4387-44f3-807a-135ab054a927
X-REPORT-ABUSE-TO: Message sent by Mailjet please report to
 abuse@mailjet.com with a copy of the message
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 12 Oct 2022 07:33:20 +0000
Subject: [dm-devel] HP PA-RISC / IA64 hardware platform for Linux Debian,
 Gentoo, NetBSD, OpenBSD and HP-UX Unix
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0841529662948085536=="

--===============0841529662948085536==
Content-Type: multipart/alternative; boundary="=-xsdjpNxWuY6X1oK9ZO3h"

--=-xsdjpNxWuY6X1oK9ZO3h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi, I'm Jesse at Cypress Technology Inc. We at Cypress sell HP hardware. Be=
low are some links to HP PA-RISC and IA64 boxes that support the Linux Debi=
an, Gentoo, NetBSD, OpenBSD Linux and HP-UX Unix platforms. If you are in n=
eed of systems, feel free to email back with any question or requests. We a=
lso sell / buy all boxes and parts that HP made for the HP-UX / Unix (PA-RI=
SC & ia64) line.

PA-RISC
www.ebay.com/itm/385130495455
www.ebay.com/itm/384211227917

IA64
www.ebay.com/itm/384272059488
www.ebay.com/itm/384211228177

IA64 - For Telco / Data Center users / 48v DC
www.ebay.com/itm/384966825704

Thanks
Jesse Dougherty
Resellers of HP hardware
Jesse@cypress-tech.com
www.cypress-tech.com
--=-xsdjpNxWuY6X1oK9ZO3h
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!doctype html><html xmlns=3D"http://www.w3.org/1999/xhtml" xmlns:v=3D"urn:=
schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-microsoft-com:office:offi=
ce"><head><title>HP PA-RISC / IA64 hardware platform for Linux Debian, Gent=
oo, NetBSD, OpenBSD and HP-UX Unix</title><!--[if !mso]><!--><meta http-equ=
iv=3D"X-UA-Compatible" content=3D"IE=3Dedge"><!--<![endif]--><meta http-equ=
iv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8"><meta name=3D"vi=
ewport" content=3D"width=3Ddevice-width,initial-scale=3D1"><style type=3D"t=
ext/css">#outlook a { padding:0; }
          body { margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-=
size-adjust:100%; }
          table, td { border-collapse:collapse;mso-table-lspace:0pt;mso-tab=
le-rspace:0pt; }
          img { border:0;height:auto;line-height:100%; outline:none;text-de=
coration:none;-ms-interpolation-mode:bicubic; }
          p { display:block;margin:13px 0; }</style><!--[if mso]>
        <noscript>
        <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
        </xml>
        </noscript>
        <![endif]--><!--[if lte mso 11]>
        <style type=3D"text/css">
          .mj-outlook-group-fix { width:100% !important; }
        </style>
        <![endif]--><style type=3D"text/css">@media only screen and (min-wi=
dth:480px) {
        .mj-column-per-100 { width:100% !important; max-width: 100%; }
      }</style><style media=3D"screen and (min-width:480px)">.moz-text-html=
 .mj-column-per-100 { width:100% !important; max-width: 100%; }</style><sty=
le type=3D"text/css">[owa] .mj-column-per-100 { width:100% !important; max-=
width: 100%; }</style><style type=3D"text/css"></style></head><body style=
=3D"word-spacing:normal;background-color:#F4F4F4;"><div style=3D"background=
-color:#F4F4F4;"><!--[if mso | IE]><table align=3D"center" border=3D"0" cel=
lpadding=3D"0" cellspacing=3D"0" class=3D"" role=3D"presentation" style=3D"=
width:600px;" width=3D"600" bgcolor=3D"#ffffff" ><tr><td style=3D"line-heig=
ht:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--><div style=
=3D"background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:6=
00px;"><table align=3D"center" border=3D"0" cellpadding=3D"0" cellspacing=
=3D"0" role=3D"presentation" style=3D"background:#ffffff;background-color:#=
ffffff;width:100%;"><tbody><tr><td style=3D"direction:ltr;font-size:0px;pad=
ding:20px 0px 20px 0px;text-align:center;"><!--[if mso | IE]><table role=3D=
"presentation" border=3D"0" cellpadding=3D"0" cellspacing=3D"0"><tr><td cla=
ss=3D"" style=3D"vertical-align:top;width:600px;" ><![endif]--><div class=
=3D"mj-column-per-100 mj-outlook-group-fix" style=3D"font-size:0px;text-ali=
gn:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">=
<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentatio=
n" style=3D"vertical-align:top;" width=3D"100%"><tbody><tr><td align=3D"lef=
t" style=3D"font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding=
-bottom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-s=
erif;font-size:13px;letter-spacing:normal;line-height:1;text-align:left;col=
or:#000000;"><h1 class=3D"text-build-content" data-testid=3D"Jz34KW14Tt" st=
yle=3D"margin-top: 10px; margin-bottom: 10px; font-weight: normal;"><span s=
tyle=3D"color:#55575d;font-family:Arial;font-size:20px;line-height:22px;"><=
b>HP PA-RISC / IA64 hardware platform for Linux Debian, Gentoo, NetBSD, Ope=
nBSD and HP-UX Unix</b></span></h1></div></td></tr><tr><td align=3D"left" s=
tyle=3D"font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding-bot=
tom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-serif=
;font-size:14px;letter-spacing:normal;line-height:1;text-align:left;color:#=
000000;"><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=
=3D"margin: 10px 0; margin-top: 10px;"><span style=3D"color:#55575d;font-fa=
mily:Arial;font-size:14px;line-height:22px;">Hi, I'm Jesse at Cypress Techn=
ology Inc. We at Cypress sell and purchase HP hardware. Below are some link=
s to HP PA-RISC and IA64 boxes that support the Linux Debian, Gentoo, NetBS=
D, OpenBSD Linux and HP-UX Unix platforms. If you are in need of systems, f=
eel free to email back with any question or requests. We also sell / buy al=
l boxes and parts that HP made for the HP-UX / Unix (PA-RISC &amp; ia64) li=
ne.</span></p><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" st=
yle=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font=
-size:14px;line-height:22px;"><b>PA-RISC</b></span></p><ul><li><a class=3D"=
link-build-content" style=3D"color:inherit;; text-decoration: none;" target=
=3D"_blank" href=3D"http://xz01x.mjt.lu/lnk/AXQAAACMQ5YAAcjIYbYAAM5EefsAAYC=
rYzIAnGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwASLds/1/pqCDZ1DoWzh26PEXPbWR0A/a=
HR0cDovL3d3dy5lYmF5LmNvbS9pdG0vMzg1MTMwNDk1NDU1"><span style=3D"color:#5557=
5d;font-family:Arial;font-size:14px;line-height:22px;"><u>www.ebay.com/itm/=
385130495455</u></span></a></li><li><a class=3D"link-build-content" style=
=3D"color:inherit;; text-decoration: none;" target=3D"_blank" href=3D"http:=
//xz01x.mjt.lu/lnk/AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_zcsw=
E0OHRPOAehNasFSpJwASLds/2/UrLba3SK8wrALrHmB8iVjw/aHR0cDovL3d3dy5lYmF5LmNvbS=
9pdG0vMzg0MjExMjI3OTE3"><span style=3D"color:#55575d;font-family:Arial;font=
-size:14px;line-height:22px;"><u>www.ebay.com/itm/384211227917</u></span></=
a></li></ul><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" styl=
e=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-s=
ize:14px;line-height:22px;"><b>IA64</b></span></p><ul><li><a class=3D"link-=
build-content" style=3D"color:inherit;; text-decoration: none;" target=3D"_=
blank" href=3D"http://xz01x.mjt.lu/lnk/AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIA=
nGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwASLds/3/lsE-6K3RTLT_DaQIsjAJxw/aHR0cD=
ovL3d3dy5lYmF5LmNvbS9pdG0vMzg0MjcyMDU5NDg4"><span style=3D"color:#55575d;fo=
nt-family:Arial;font-size:14px;line-height:22px;"><u>www.ebay.com/itm/38427=
2059488</u></span></a></li><li><a class=3D"link-build-content" style=3D"col=
or:inherit;; text-decoration: none;" target=3D"_blank" href=3D"http://xz01x=
.mjt.lu/lnk/AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_zcswE0OHRPO=
AehNasFSpJwASLds/4/zFWKrL_pqf8M3OPY4Y8tZw/aHR0cDovL3d3dy5lYmF5LmNvbS9pdG0vM=
zg0MjExMjI4MTc3"><span style=3D"color:#55575d;font-family:Arial;font-size:1=
4px;line-height:22px;"><u>www.ebay.com/itm/384211228177</u></span></a></li>=
</ul><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=3D"ma=
rgin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-size:14p=
x;line-height:22px;"><b>IA64 - For Telco </b>/ Data Center users / 48v DC</=
span></p><ul><li><a class=3D"link-build-content" style=3D"color:inherit;; t=
ext-decoration: none;" target=3D"_blank" href=3D"http://xz01x.mjt.lu/lnk/AX=
QAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwASL=
ds/5/UMv3r8-fiH9Dbmn2J88gAA/aHR0cDovL3d3dy5lYmF5LmNvbS9pdG0vMzg0OTY2ODI1NzA=
0"><span style=3D"color:#55575d;font-family:Arial;font-size:14px;line-heigh=
t:22px;"><u>www.ebay.com/itm/384966825704</u></span></a></li></ul><p class=
=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=3D"margin: 10px 0;=
">&nbsp;</p><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" styl=
e=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-s=
ize:14px;line-height:22px;">Thanks&nbsp;</span></p><p class=3D"text-build-c=
ontent" data-testid=3D"xnDQWx__cn" style=3D"margin: 10px 0; margin-bottom: =
10px;"><span style=3D"color:#55575d;font-family:Arial;font-size:14px;line-h=
eight:22px;">Jesse Dougherty / Jesse@Cypress-Tech.com</span></p></div></td>=
</tr></tbody></table></div><!--[if mso | IE]></td></tr></table><![endif]-->=
</td></tr></tbody></table></div><!--[if mso | IE]></td></tr></table><table =
align=3D"center" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"=
" role=3D"presentation" style=3D"width:600px;" width=3D"600" ><tr><td style=
=3D"line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-=
-><div style=3D"margin:0px auto;max-width:600px;"><table align=3D"center" b=
order=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" style=
=3D"width:100%;"><tbody><tr><td style=3D"direction:ltr;font-size:0px;paddin=
g:20px 0px 20px 0px;text-align:center;"><!--[if mso | IE]><table role=3D"pr=
esentation" border=3D"0" cellpadding=3D"0" cellspacing=3D"0"><tr><td class=
=3D"" style=3D"vertical-align:top;width:600px;" ><![endif]--><div class=3D"=
mj-column-per-100 mj-outlook-group-fix" style=3D"font-size:0px;text-align:l=
eft;direction:ltr;display:inline-block;vertical-align:top;width:100%;"><tab=
le border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" s=
tyle=3D"vertical-align:top;" width=3D"100%"><tbody><tr><td align=3D"left" s=
tyle=3D"font-size:0px;padding:0px 20px 0px 20px;padding-top:0px;padding-bot=
tom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-serif=
;font-size:13px;letter-spacing:normal;line-height:1;text-align:left;color:#=
000000;"><p style=3D"text-align: center; margin: 10px 0; margin-top: 10px; =
margin-bottom: 10px;"><span style=3D"line-height:22px;font-family:Arial;col=
or:#55575d;text-align:center;font-size:13px;">This e-mail has been sent to =
dm-devel@redhat.com, <a href=3D"http://xz01x.mjt.lu/unsub2?hl=3Den&amp;m=3D=
AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzIAnGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwA=
SLds&amp;b=3D2bfe964b&amp;e=3Df8c44aea&amp;x=3DiqAIjtzUiXdt7GQAvMyV5P13GlBf=
RC-flSlZda0hciM" style=3D"color:inherit;text-decoration:none;" target=3D"_b=
lank">click here to unsubscribe</a>.</span></p></div></td></tr></tbody></ta=
ble></div><!--[if mso | IE]></td></tr></table><![endif]--></td></tr></tbody=
></table></div><!--[if mso | IE]></td></tr></table><![endif]--></div>
<br/><img src=3D"http://xz01x.mjt.lu/oo/AXQAAACMQ5YAAcjIYbYAAM5EefsAAYCrYzI=
AnGIiABIoIQBjRcH_zcswE0OHRPOAehNasFSpJwASLds/97979ff7/e.gif" height=3D"1" w=
idth=3D"1" alt=3D"" border=3D"0" style=3D"height:1px;width:1px;border:0;"/>
</body></html>
--=-xsdjpNxWuY6X1oK9ZO3h--

--===============0841529662948085536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0841529662948085536==--

