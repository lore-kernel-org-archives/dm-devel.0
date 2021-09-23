Return-Path: <SRS0=YvnR=ON=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MIME_HTML_MOSTLY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59C3C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 23 Sep 2021 07:23:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FAD4610A0
	for <dm-devel@archiver.kernel.org>; Thu, 23 Sep 2021 07:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1FAD4610A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lixiang.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-7PjNUr_QOMurhlWUWrd7Fg-1; Thu, 23 Sep 2021 03:23:39 -0400
X-MC-Unique: 7PjNUr_QOMurhlWUWrd7Fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C390802921;
	Thu, 23 Sep 2021 07:23:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F0611972D;
	Thu, 23 Sep 2021 07:23:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ADF494E58F;
	Thu, 23 Sep 2021 07:23:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18N1coI3028335 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 22 Sep 2021 21:38:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E6A5101043F; Thu, 23 Sep 2021 01:38:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69DA7100912E
	for <dm-devel@redhat.com>; Thu, 23 Sep 2021 01:38:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE9DF800B26
	for <dm-devel@redhat.com>; Thu, 23 Sep 2021 01:38:47 +0000 (UTC)
Received: from u05.bc.larksuite.com (u05.bc.larksuite.com [130.44.212.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-417-0awZC1eYPoyzwVSArLULWQ-3; Wed, 22 Sep 2021 21:38:44 -0400
X-MC-Unique: 0awZC1eYPoyzwVSArLULWQ-3
Mime-Version: 1.0
Date: Thu, 23 Sep 2021 09:33:40 +0800
Message-Id: <e24c85d63b888d1837ed2a8336eedc906ce08878.ac8516ec.e05e.4d3b.9a64.59e4e334e2f7@feishu.cn>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
From: =?utf-8?q?=E6=9D=8E=E5=B9=B3?= <liping3@lixiang.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 23 Sep 2021 03:23:24 -0400
Subject: [dm-devel] dm-init.c: boot up race with partitions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0776326592527578395=="

--===============0776326592527578395==
Content-Type: multipart/alternative;
	boundary=b1a56137d6a0663e0728c211bfbc0c308d8d482dbce76eb6a7474c966873

--b1a56137d6a0663e0728c211bfbc0c308d8d482dbce76eb6a7474c966873
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Dear dm-devel: I encountered the same problem as this one. Is there a solut=
ion? refer:https://listman.redhat.com/archives/dm-devel/2021-April/msg00017=
.html [dm-devel] dm-init.c: boot up race with part
--b1a56137d6a0663e0728c211bfbc0c308d8d482dbce76eb6a7474c966873
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<div id=3D"appVersion:=E9=A3=9E=E4=B9=A6-4.8.3-editorVersion:0.9.6"></div><=
div><div style=3D"hyphens: auto; line-height: 1.68;"><div data-gramm=3D"fal=
se" data-last-height=3D"698" data-last-width=3D"899.333" style=3D"hyphens: =
auto; font-family: arial, helvetica, sans-serif; color: rgb(31, 35, 41); li=
ne-height: 1.68;"><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><=
span class=3D" fontfamily  fontsize fontcolor " style=3D"font-family: arial=
, helvetica, sans-serif; font-size: 14px; color: #1F2329;">Dear dm-devel:</=
span></div><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span cl=
ass=3D" fontfamily  fontsize fontcolor " style=3D"font-family: arial, helve=
tica, sans-serif; font-size: 14px; color: #1F2329;">I encountered the same =
problem as this one. Is there a solution?</span></div><div class=3D"" dir=
=3D"auto" style=3D"margin: 4px 0px;"><br></div><div class=3D"" dir=3D"auto"=
 style=3D"margin: 4px 0px;"><span class=3D" fontfamily  fontsize fontcolor =
" style=3D"font-family: arial, helvetica, sans-serif; font-size: 14px; colo=
r: #1F2329;">refer:</span><span class=3D"outer-u-container "><span class=3D=
" hyperlink-href:https://listman.redhat.com/archives/dm-devel/2021-April/ms=
g00017.html fontfamily  fontsize fontcolor " style=3D"font-family: arial, h=
elvetica, sans-serif; font-size: 14px; color: #1F2329;"><a href=3D"https://=
listman.redhat.com/archives/dm-devel/2021-April/msg00017.html" rel=3D"noope=
ner" target=3D"_blank" style=3D"cursor: pointer; transition: color 0.3s eas=
e 0s; text-decoration: none; color: rgb(51, 112, 255);">https://listman.red=
hat.com/archives/dm-devel/2021-April/msg00017.html</a></span></span></div><=
div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" font=
family  fontcolor " style=3D"font-family: arial, helvetica, sans-serif; col=
or: #000000;">[dm-devel] dm-init.c: boot up race with partitions</span></di=
v><ul style=3D"margin-top: 0px; margin-bottom: 0px; padding-left: 0px; list=
-style-position: inside;"><li class=3D"list-backgroundcolor:rgb(222,&amp;nb=
sp;224,&amp;nbsp;227) " style=3D"padding-left: 0px; display: list-item;"><s=
pan style=3D"position: inherit; display: none; margin-left: 0px;"></span><s=
pan class=3D"pocket-ignore pocket-ignore-faketext" data-faketext=3D"" data-=
contentcollector-ignore-space-at=3D"end" style=3D"background-color: rgb(222=
,&amp;nbsp;224,&amp;nbsp;227); background-color: rgb(222,&amp;nbsp;224,&amp=
;nbsp;227);">=E2=80=8B</span><span class=3D" fontfamily  fontcolor " style=
=3D"font-family: arial, helvetica, sans-serif; color: #1F2329;">=E2=80=8B</=
span><span class=3D" i fontfamily fontweight  fontsize fontcolor " style=3D=
"font-family: arial, helvetica, sans-serif; font-weight: 400; font-size: 14=
px; color: #000000;"><i>From</i></span><span class=3D" fontfamily fontweigh=
t  fontsize fontcolor " style=3D"font-family: arial, helvetica, sans-serif;=
 font-weight: 400; font-size: 14px; color: #000000;">: Steven Walter &lt;st=
even stevenwalter org&gt;</span></li><li class=3D"list-backgroundcolor:rgb(=
222,&amp;nbsp;224,&amp;nbsp;227) " style=3D"padding-left: 0px; display: lis=
t-item;"><span style=3D"position: inherit; display: none; margin-left: 0px;=
"></span><span class=3D"pocket-ignore pocket-ignore-faketext" data-faketext=
=3D"" data-contentcollector-ignore-space-at=3D"end" style=3D"background-col=
or: rgb(222,&amp;nbsp;224,&amp;nbsp;227); background-color: rgb(222,&amp;nb=
sp;224,&amp;nbsp;227);">=E2=80=8B</span><span class=3D" fontfamily  fontcol=
or " style=3D"font-family: arial, helvetica, sans-serif; color: #1F2329;">=
=E2=80=8B</span><span class=3D" i fontfamily fontweight  fontsize fontcolor=
 " style=3D"font-family: arial, helvetica, sans-serif; font-weight: 400; fo=
nt-size: 14px; color: #000000;"><i>To</i></span><span class=3D" fontfamily =
fontweight  fontsize fontcolor " style=3D"font-family: arial, helvetica, sa=
ns-serif; font-weight: 400; font-size: 14px; color: #000000;">: "dm-devel r=
edhat com" &lt;dm-devel redhat com&gt;</span></li><li class=3D"list-backgro=
undcolor:rgb(222,&amp;nbsp;224,&amp;nbsp;227) " style=3D"padding-left: 0px;=
 display: list-item;"><span style=3D"position: inherit; display: none; marg=
in-left: 0px;"></span><span class=3D"pocket-ignore pocket-ignore-faketext" =
data-faketext=3D"" data-contentcollector-ignore-space-at=3D"end" style=3D"b=
ackground-color: rgb(222,&amp;nbsp;224,&amp;nbsp;227); background-color: rg=
b(222,&amp;nbsp;224,&amp;nbsp;227);">=E2=80=8B</span><span class=3D" fontfa=
mily  fontcolor " style=3D"font-family: arial, helvetica, sans-serif; color=
: #1F2329;">=E2=80=8B</span><span class=3D" i fontfamily fontweight  fontsi=
ze fontcolor " style=3D"font-family: arial, helvetica, sans-serif; font-wei=
ght: 400; font-size: 14px; color: #000000;"><i>Subject</i></span><span clas=
s=3D" fontfamily fontweight  fontsize fontcolor " style=3D"font-family: ari=
al, helvetica, sans-serif; font-weight: 400; font-size: 14px; color: #00000=
0;">: [dm-devel] dm-init.c: boot up race with partitions</span></li><li cla=
ss=3D"list-backgroundcolor:rgb(222,&amp;nbsp;224,&amp;nbsp;227) " style=3D"=
padding-left: 0px; display: list-item;"><span style=3D"position: inherit; d=
isplay: none; margin-left: 0px;"></span><span class=3D"pocket-ignore pocket=
-ignore-faketext" data-faketext=3D"" data-contentcollector-ignore-space-at=
=3D"end" style=3D"background-color: rgb(222,&amp;nbsp;224,&amp;nbsp;227); b=
ackground-color: rgb(222,&amp;nbsp;224,&amp;nbsp;227);">=E2=80=8B</span><sp=
an class=3D" fontfamily  fontcolor " style=3D"font-family: arial, helvetica=
, sans-serif; color: #1F2329;">=E2=80=8B</span><span class=3D" i fontfamily=
 fontweight  fontsize fontcolor " style=3D"font-family: arial, helvetica, s=
ans-serif; font-weight: 400; font-size: 14px; color: #000000;"><i>Date</i><=
/span><span class=3D" fontfamily fontweight  fontsize fontcolor " style=3D"=
font-family: arial, helvetica, sans-serif; font-weight: 400; font-size: 14p=
x; color: #000000;">: Mon, 05 Apr 2021 21:38:15 +0000</span></li></ul><div =
class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfami=
ly backgroundcolor fontweight  fontcolor " style=3D"font-family: arial, hel=
vetica, sans-serif; background-color: rgb(222, 224, 227); font-weight: 400;=
 color: #000000;">I am using the dm-mod.create kernel command line paramete=
r to create a verity device at boot. &nbsp;Both the data device and hash de=
vice are partitions on an eMMC device. &nbsp;Seemingly at random, the verit=
y device fails to be created at boot because dm_init_init() (and wait_for_d=
evice_probe()) returned before the partitions had been scanned:</span></div=
><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><br></div><div cla=
ss=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfamily =
backgroundcolor fontweight  fontcolor " style=3D"font-family: arial, helvet=
ica, sans-serif; background-color: rgb(222, 224, 227); font-weight: 400; co=
lor: #000000;">mmc1: new high speed MMC card at address 0001</span></div><d=
iv class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontf=
amily backgroundcolor fontweight  fontcolor " style=3D"font-family: arial, =
helvetica, sans-serif; background-color: rgb(222, 224, 227); font-weight: 4=
00; color: #000000;">device-mapper: table: 253:0: verity: Data device looku=
p failed</span></div><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;=
"><span class=3D" fontfamily backgroundcolor fontweight  fontcolor " style=
=3D"font-family: arial, helvetica, sans-serif; background-color: rgb(222, 2=
24, 227); font-weight: 400; color: #000000;">device-mapper: ioctl: error ad=
ding target to table</span></div><div class=3D"" dir=3D"auto" style=3D"marg=
in: 4px 0px;"><span class=3D" fontfamily backgroundcolor fontweight  fontco=
lor " style=3D"font-family: arial, helvetica, sans-serif; background-color:=
 rgb(222, 224, 227); font-weight: 400; color: #000000;">mmcblk1: mmc1:0001 =
064G30 58.2 GiB</span></div><div class=3D"" dir=3D"auto" style=3D"margin: 4=
px 0px;"><span class=3D" fontfamily backgroundcolor fontweight  fontcolor "=
 style=3D"font-family: arial, helvetica, sans-serif; background-color: rgb(=
222, 224, 227); font-weight: 400; color: #000000;">mmcblk1boot0: mmc1:0001 =
064G30 partition 1 4.00 MiB</span></div><div class=3D"" dir=3D"auto" style=
=3D"margin: 4px 0px;"><span class=3D" fontfamily backgroundcolor fontweight=
  fontcolor " style=3D"font-family: arial, helvetica, sans-serif; backgroun=
d-color: rgb(222, 224, 227); font-weight: 400; color: #000000;">mmcblk1boot=
1: mmc1:0001 064G30 partition 2 4.00 MiB</span></div><div class=3D"" dir=3D=
"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfamily backgroundcolo=
r fontweight  fontcolor " style=3D"font-family: arial, helvetica, sans-seri=
f; background-color: rgb(222, 224, 227); font-weight: 400; color: #000000;"=
>mmcblk1rpmb: mmc1:0001 064G30 partition 3 4.00 MiB, chardev (247:0)</span>=
</div><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=
=3D" fontfamily backgroundcolor fontweight  fontcolor " style=3D"font-famil=
y: arial, helvetica, sans-serif; background-color: rgb(222, 224, 227); font=
-weight: 400; color: #000000;">&nbsp;mmcblk1: p1 p2 p3 p4 p5 p6 p7</span></=
div><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><br></div><div =
class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfami=
ly backgroundcolor fontweight  fontcolor " style=3D"font-family: arial, hel=
vetica, sans-serif; background-color: rgb(222, 224, 227); font-weight: 400;=
 color: #000000;">I don't see how wait_for_device_probe() knows when partit=
ion scanning has been completed. &nbsp;Is this a race or am I missing somet=
hing?</span></div><div class=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><=
span class=3D" fontfamily backgroundcolor fontweight  fontcolor " style=3D"=
font-family: arial, helvetica, sans-serif; background-color: rgb(222, 224, =
227); font-weight: 400; color: #000000;">--</span></div><div class=3D"" dir=
=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfamily backgroundc=
olor fontweight  fontcolor " style=3D"font-family: arial, helvetica, sans-s=
erif; background-color: rgb(222, 224, 227); font-weight: 400; color: #00000=
0;">- Steven Walter &lt;steven stevenwalter org&gt;</span></div><div class=
=3D"" dir=3D"auto" style=3D"margin: 4px 0px;"><span class=3D" fontfamily ba=
ckgroundcolor fontweight  fontcolor " style=3D"font-family: arial, helvetic=
a, sans-serif; background-color: rgb(222, 224, 227); font-weight: 400; colo=
r: #000000;">Sent from ProtonMail, encrypted email based in Switzerland.</s=
pan></div></div></div></div><html><head></head><body><div><div data-gramm=
=3D"false" data-is-loading-text=3D"=E6=AD=A3=E5=9C=A8=E5=8A=A0=E8=BD=BD..."=
 data-last-height=3D"88" data-last-width=3D"762" style=3D"line-height: 1.6;=
 position: relative; hyphens: auto; font-size: 14px;"><div class=3D"" dir=
=3D"auto"><br></div><div class=3D"" dir=3D"auto"><span class=3D" fontfamily=
  fontsize fontcolor " style=3D"font-family: helvetica; font-size: 12px; co=
lor: #262626;">=E5=A3=B0=E6=98=8E=EF=BC=9A=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=
=B6=E5=8F=AA=E5=85=81=E8=AE=B8=E6=96=87=E4=BB=B6=E6=8E=A5=E6=94=B6=E8=80=85=
=E9=98=85=E8=AF=BB=EF=BC=8C=E6=9C=89=E5=BE=88=E9=AB=98=E7=9A=84=E6=9C=BA=E5=
=AF=86=E6=80=A7=E8=A6=81=E6=B1=82=E3=80=82=E7=A6=81=E6=AD=A2=E5=85=B6=E4=BB=
=96=E4=BA=BA=E4=BD=BF=E7=94=A8=E3=80=81=E6=89=93=E5=BC=80=E3=80=81=E5=A4=8D=
=E5=88=B6=E6=88=96=E8=BD=AC=E5=8F=91=E9=87=8C=E9=9D=A2=E7=9A=84=E4=BB=BB=E4=
=BD=95=E5=86=85=E5=AE=B9=E3=80=82</span></div><div class=3D"" dir=3D"auto">=
<span class=3D" fontfamily  fontsize fontcolor " style=3D"font-family: helv=
etica; font-size: 12px; color: #262626;">=E5=A6=82=E6=9E=9C=E6=9C=AC=E9=82=
=AE=E4=BB=B6=E9=94=99=E8=AF=AF=E5=9C=B0=E5=8F=91=E7=BB=99=E4=BA=86=E4=BD=A0=
=EF=BC=8C=E8=AF=B7=E8=81=94=E7=B3=BB=E9=82=AE=E4=BB=B6=E5=8F=91=E5=87=BA=E8=
=80=85=E5=B9=B6=E5=88=A0=E9=99=A4=E8=BF=99=E4=B8=AA=E6=96=87=E4=BB=B6=E3=80=
=82=E6=9C=BA=E5=AF=86=E5=8F=8A=E6=B3=95=E5=BE=8B=E7=9A=84=E7=89=B9=E6=9D=83=
=E5=B9=B6=E4=B8=8D=E5=9B=A0=E4=B8=BA=E8=AF=AF=E5=8F=91=E9=82=AE=E4=BB=B6=E8=
=80=8C=E6=94=BE=E5=BC=83=E6=88=96=E4=B8=A7=E5=A4=B1=E3=80=82</span></div><d=
iv class=3D"" dir=3D"auto"><span class=3D" fontfamily  fontsize fontcolor "=
 style=3D"font-family: helvetica; font-size: 12px; color: #262626;">=E4=BB=
=BB=E4=BD=95=E6=8F=90=E5=87=BA=E7=9A=84=E8=A7=82=E7=82=B9=E6=88=96=E6=84=8F=
=E8=A7=81=E5=8F=AA=E5=B1=9E=E4=BA=8E=E4=BD=9C=E8=80=85=E7=9A=84=E4=B8=AA=E4=
=BA=BA=E8=A7=81=E8=A7=A3=EF=BC=8C=E5=B9=B6=E4=B8=8D=E4=B8=80=E5=AE=9A=E4=BB=
=A3=E8=A1=A8=E7=90=86=E6=83=B3=E6=B1=BD=E8=BD=A6=E3=80=82</span></div></div=
></div></body></html>
--b1a56137d6a0663e0728c211bfbc0c308d8d482dbce76eb6a7474c966873--

--===============0776326592527578395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0776326592527578395==--

