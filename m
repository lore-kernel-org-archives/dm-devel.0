From: Rain <s.rain@yahoo.com.tw>
Subject: Need you help - multipath question
Date: Wed, 29 May 2013 15:37:17 +0800 (CST)
Message-ID: <1369813037.39080.YahooMailNeo@web74403.mail.tp2.yahoo.com>
Reply-To: Rain <s.rain@yahoo.com.tw>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6947060159484882437=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6947060159484882437==
Content-Type: multipart/alternative;
	boundary="-1254962548-610987748-1369813037=:39080"

---1254962548-610987748-1369813037=:39080
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dear Christophe,=0A=0A=C2=A0 =C2=A0 I'm grad multipath-tool help us a lot. =
But we got some problem as multipath creation failed. I set the following c=
onfigure and can not get twice path. sometime only got one path. That's str=
ange. Can you help me out? I just want to get sdm and sdal multipath. Thank=
s.=0A=0Aexecutie command steps:=0A1. multipath -F=0A2. multipath -r=0A=0A=
=0Amultipath.conf=0Adefaults {=0A=C2=A0 =C2=A0 getuid_callout =C2=A0 =C2=A0=
 =C2=A0"/lib/udev/scsi_id -g -u /dev/%n"=0A=C2=A0 =C2=A0 prio =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0alua=0A=C2=A0 =C2=A0 failback =C2=A0 =C2=A0 =C2=
=A0 =C2=A0immediate=0A=C2=A0 =C2=A0 no_path_retry =C2=A0 =C2=A0 =C2=A0 queu=
e=0A}=0Ablacklist {=0A=C2=A0 =C2=A0 devnode "*"=0A}=0Ablacklist_exceptions =
{=0A=C2=A0 =C2=A0 devnode "sdml"=0A=C2=A0 =C2=A0=C2=A0=C2=A0devnode "sdal"=
=0A}=0Adevices {=0A=C2=A0 =C2=A0 device {=0A=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 vendor =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"*"=0A=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 "*"=0A=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 no_path_retry =C2=A0 0=0A=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 prio =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const=0A=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_path_retry =C2=A0 fail=0A=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 }=0A}=0A=0A=0Aby the way, I got some multipath err=
or as below, Is there any question?=0A[64513.680938] end_request: I/O error=
, dev dm-3, sector 0=0A[64513.681039] end_request: I/O error, dev dm-3, sec=
tor 3907029160=0A[64513.681097] end_request: I/O error, dev dm-3, sector 39=
07029160=0A[64513.681158] end_request: I/O error, dev dm-3, sector 0=0A[645=
13.681265] end_request: I/O error, dev dm-3, sector 0=0A[64513.681325] end_=
request: I/O error, dev dm-3, sector 24=0A[64513.694741] device-mapper: mul=
tipath: Failing path 67:96.=0A[64513.714079] device-mapper: multipath: Fail=
ing path 67:112.=0A[64513.714130] device-mapper: multipath: Failing path 67=
:128.
---1254962548-610987748-1369813037=:39080
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:=
=E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu, serif;font-size:13pt"><div>=
<span style=3D"font-size: 17px;">Dear Christophe,</span><br></div><div styl=
e=3D"color: rgb(0, 0, 0); font-size: 16px; font-family: =E6=96=B0=E7=B4=B0=
=E6=98=8E=E9=AB=94, pmingliu, serif; background-color: transparent; font-st=
yle: normal;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; I'm grad multi=
path-tool help us a lot. But we got some problem as multipath creation fail=
ed. I set the following configure and can not get twice path. sometime only=
 got one path. That's strange. Can you help me out? I just want to get sdm =
and sdal multipath. Thanks.</span></div><div style=3D"color: rgb(0, 0, 0); =
font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingli=
u, serif; background-color: transparent; font-style: normal;"><span style=
=3D"font-size: 17px;"><br></span></div><div style=3D"color: rgb(0, 0, 0); f=
ont-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu=
, serif; background-color:
 transparent; font-style: normal;"><span style=3D"font-size: 17px; font-wei=
ght: bold; text-decoration: underline;">executie command steps:</span></div=
><div style=3D"color: rgb(0, 0, 0); font-size: 17px; font-family: =E6=96=B0=
=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu, serif; background-color: transparent=
; font-style: normal;">1. multipath -F</div><div style=3D"color: rgb(0, 0, =
0); font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmi=
ngliu, serif; background-color: transparent; font-style: normal;">2. multip=
ath -r</div><div style=3D"color: rgb(0, 0, 0); font-size: 17px; font-family=
: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu, serif; background-color: =
transparent; font-style: normal;"><span style=3D"font-size: 17px;"><br></sp=
an></div><div style=3D"color: rgb(0, 0, 0); font-size: 17px; font-family: =
=E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu, serif; background-color: tr=
ansparent; font-style: normal;"><span style=3D"font-size: 17px;"><br></span=
></div><div style=3D"color: rgb(0, 0, 0); font-size: 17px; font-family: =E6=
=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94, pmingliu, serif;
 background-color: transparent; font-style: normal;"><span style=3D"font-si=
ze: 17px; font-weight: bold; text-decoration: underline;">multipath.conf</s=
pan></div><div style=3D"background-color: transparent;"><span style=3D"font=
-size: 17px;">defaults {</span></div><div style=3D"background-color: transp=
arent;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; getuid_callout &nbsp=
; &nbsp; &nbsp;"/lib/udev/scsi_id -g -u /dev/%n"</span></div><div style=3D"=
background-color: transparent;"><span style=3D"font-size: 17px;">&nbsp; &nb=
sp; prio &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;alua</span></div><div sty=
le=3D"background-color: transparent;"><span style=3D"font-size: 17px;">&nbs=
p; &nbsp; failback &nbsp; &nbsp; &nbsp; &nbsp;immediate</span></div><div st=
yle=3D"background-color: transparent;"><span style=3D"font-size: 17px;">&nb=
sp; &nbsp; no_path_retry &nbsp; &nbsp; &nbsp; queue</span></div><div style=
=3D"background-color: transparent;"><span style=3D"font-size: 17px;">}</spa=
n></div><div
 style=3D"background-color: transparent;"><span style=3D"font-size: 17px;">=
blacklist {</span></div><div style=3D"background-color: transparent;"><span=
 style=3D"font-size: 17px;">&nbsp; &nbsp; devnode "*"</span></div><div styl=
e=3D"background-color: transparent;"><span style=3D"font-size: 17px;">}</sp=
an></div><div style=3D"background-color: transparent;"><span style=3D"font-=
size: 17px;">blacklist_exceptions {</span></div><div style=3D"background-co=
lor: transparent;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; devnode "=
sdml"</span></div><div style=3D"background-color: transparent; color: rgb(0=
, 0, 0); font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=94=
, pmingliu, serif; font-style: normal;"><span style=3D"font-size: 17px;">&n=
bsp; &nbsp;&nbsp;</span>&nbsp;devnode "sdal"</div><div style=3D"background-=
color: transparent;"><span style=3D"font-size: 17px;">}</span></div><div st=
yle=3D"background-color: transparent;"><span style=3D"font-size: 17px;">dev=
ices {</span></div><div style=3D"background-color:
 transparent;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; device {</spa=
n></div><div style=3D"background-color: transparent;"><span style=3D"font-s=
ize: 17px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;"*"</span></div><div style=3D"background-=
color: transparent;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product &nbsp; &nbsp; &nbsp; &nbsp; "*"<=
/span></div><div style=3D"background-color: transparent;"><span style=3D"fo=
nt-size: 17px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; no_=
path_retry &nbsp; 0</span></div><div style=3D"background-color: transparent=
;"><span style=3D"font-size: 17px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; prio &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;const</span>=
</div><div style=3D"background-color: transparent;"><span style=3D"font-siz=
e: 17px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; no_path_r=
etry &nbsp;
 fail</span></div><div style=3D"background-color: transparent;"><span style=
=3D"font-size: 17px;">&nbsp; &nbsp; &nbsp; &nbsp; }</span></div><div style=
=3D"background-color: transparent;"><span style=3D"font-size: 17px;"></span=
></div><div style=3D"background-color: transparent;"><span style=3D"font-si=
ze: 17px;">}</span></div><div style=3D"background-color: transparent; color=
: rgb(0, 0, 0); font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=
=E9=AB=94, pmingliu, serif; font-style: normal;"><span style=3D"font-size: =
17px;"><br></span></div><div style=3D"background-color: transparent; color:=
 rgb(0, 0, 0); font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=
=AB=94, pmingliu, serif; font-style: normal;"><span style=3D"font-size: 17p=
x;"><br></span></div><div style=3D"background-color: transparent; color: rg=
b(0, 0, 0); font-size: 17px; font-family: =E6=96=B0=E7=B4=B0=E6=98=8E=E9=AB=
=94, pmingliu, serif; font-style: normal;"><span style=3D"font-size: 17px;"=
>by the way, I got some multipath error as below, Is there any question?</s=
pan></div><div
 style=3D"background-color: transparent;"><span style=3D"background-color: =
transparent; font-size: 17px;">[64513.680938] end_request: I/O error, dev d=
m-3, sector 0</span></div><div style=3D"background-color: transparent;"><sp=
an style=3D"font-size: 17px;">[64513.681039] end_request: I/O error, dev dm=
-3, sector 3907029160</span></div><div style=3D"background-color: transpare=
nt;"><span style=3D"font-size: 17px;">[64513.681097] end_request: I/O error=
, dev dm-3, sector 3907029160</span></div><div style=3D"background-color: t=
ransparent;"><span style=3D"font-size: 17px;">[64513.681158] end_request: I=
/O error, dev dm-3, sector 0</span></div><div style=3D"background-color: tr=
ansparent;"><span style=3D"font-size: 17px;">[64513.681265] end_request: I/=
O error, dev dm-3, sector 0</span></div><div style=3D"background-color: tra=
nsparent;"><span style=3D"font-size: 17px;">[64513.681325] end_request: I/O=
 error, dev dm-3, sector 24</span></div><div style=3D"background-color: tra=
nsparent;"><span
 style=3D"font-size: 17px;">[64513.694741] device-mapper: multipath: Failin=
g path 67:96.</span></div><div style=3D"background-color: transparent;"><sp=
an style=3D"font-size: 17px;">[64513.714079] device-mapper: multipath: Fail=
ing path 67:112.</span></div><div style=3D"background-color: transparent;">=
<span style=3D"font-size: 17px;">[64513.714130] device-mapper: multipath: F=
ailing path 67:128.</span></div></div></body></html>
---1254962548-610987748-1369813037=:39080--


--===============6947060159484882437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6947060159484882437==--
