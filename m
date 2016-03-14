From: Zhangguanghui <zhang.guanghui@h3c.com>
Subject: patch:multipath: implement option '-u' for uevents
Date: Mon, 14 Mar 2016 10:01:22 +0000
Message-ID: <E3535A62B291B54FBD1D003696CCB5375E17A291@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0115068603374890674=="
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
To: dm-devel-bounces <dm-devel-bounces@redhat.com>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0115068603374890674==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E3535A62B291B54FBD1D003696CCB5375E17A291H3CMLB14EXsrvhu_"

--_000_E3535A62B291B54FBD1D003696CCB5375E17A291H3CMLB14EXsrvhu_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBpbXBsZW1lbnRzIGFuIG9wdGlvbiAnLXUnIHdoaWNoIHVzZXMgdGhlIGluZm9y
bWF0aW9uIGZyb20gdGhlIHByb2dyYW0gZW52aXJvbm1lbnQgd2hlbiBjaGVja2luZyB0aGUgZGV2
aWNlLg0KdGhlIGZ1bmN0aW9uIGRvbid0IGJlIGZvdW5kIHNvbWUgcHJvYmxlbXMuDQpXaGlsaW5n
IHVzaW5nIHRoZSBjb21tYW5kICd1ZGV2YWRtIHRlc3QgL3N5cy9ibG9jay9zZGInLCBzb21lIGVy
cm9yIGxvZ3MsIHN1Y2ggYXMvc2Jpbi9tdWx0aXBhdGggLXUgc2RiJyhlcnIpDQpTbyBJIGRvbid0
IGtub3cgd2hhdCBpcyB0aGF0PyAgSXMgaXQgYSBwb3RlbnRpYWwgcmlzayA/IFRoYW5rcyBhIGxv
dHMuDQoNCnVkZXZfcnVsZXNfYXBwbHlfdG9fZXZlbnQ6IFBST0dSQU0gJy9zYmluL211bHRpcGF0
aCAtdSBzZGInIC9saWIvdWRldi9ydWxlcy5kLzk1LW11bHRpcGF0aC5ydWxlczoyMA0KdWRldl9l
dmVudF9zcGF3bjogc3RhcnRpbmcgJy9zYmluL211bHRpcGF0aCAtdSBzZGInDQpzcGF3bl9yZWFk
OiAnL3NiaW4vbXVsdGlwYXRoIC11IHNkYicoZXJyKSAnbGlidWRldjogdWRldl9kZXZpY2VfbmV3
X2Zyb21fc3lzcGF0aDogZGV2aWNlIDB4NTVlZTkxMmEwYjUwIGhhcyBkZXZwYXRoICcvZGV2aWNl
cy9wbGF0Zm9ybS9ob3N0NzIvc2Vzc2lvbjcwL3RhcmdldDcyOjA6MC83MjowOjA6MCcnDQpzcGF3
bl9yZWFkOiAnL3NiaW4vbXVsdGlwYXRoIC11IHNkYicoZXJyKSAnbGlidWRldjogdWRldl9kZXZp
Y2VfbmV3X2Zyb21fc3lzcGF0aDogZGV2aWNlIDB4NTVlZTkxMmExZWUwIGhhcyBkZXZwYXRoICcv
ZGV2aWNlcy9wbGF0Zm9ybS9ob3N0NzIvc2Vzc2lvbjcwL3RhcmdldDcyOjA6MCcnDQpzcGF3bl9y
ZWFkOiAnL3NiaW4vbXVsdGlwYXRoIC11IHNkYicoZXJyKSAnbGlidWRldjogdWRldl9kZXZpY2Vf
bmV3X2Zyb21fc3lzcGF0aDogZGV2aWNlIDB4NTVlZTkxMmEyOTgwIGhhcyBkZXZwYXRoICcvZGV2
aWNlcy9wbGF0Zm9ybS9ob3N0NzIvc2Vzc2lvbjcwJycNCnNwYXduX3JlYWQ6ICcvc2Jpbi9tdWx0
aXBhdGggLXUgc2RiJyhlcnIpICdsaWJ1ZGV2OiB1ZGV2X2RldmljZV9uZXdfZnJvbV9zeXNwYXRo
OiBkZXZpY2UgMHg1NWVlOTEyYTFiNzAgaGFzIGRldnBhdGggJy9kZXZpY2VzL3BsYXRmb3JtL2hv
c3Q3MicnDQpzcGF3bl9yZWFkOiAnL3NiaW4vbXVsdGlwYXRoIC11IHNkYicoZXJyKSAnbGlidWRl
djogdWRldl9kZXZpY2VfbmV3X2Zyb21fc3lzcGF0aDogZGV2aWNlIDB4NTVlZTkxMmE0MjMwIGhh
cyBkZXZwYXRoICcvZGV2aWNlcy9wbGF0Zm9ybScnDQpzcGF3bl9yZWFkOiAnL3NiaW4vbXVsdGlw
YXRoIC11IHNkYicoZXJyKSAnbGlidWRldjogdWRldl9kZXZpY2VfbmV3X2Zyb21fc3lzcGF0aDog
ZGV2aWNlIDB4NTVlZTkxMmEyZjkwIGhhcyBkZXZwYXRoICcvZGV2aWNlcy9wbGF0Zm9ybS9ob3N0
NzIvc2Vzc2lvbjcwL2lzY3NpX3Nlc3Npb24vc2Vzc2lvbjcwJycNCnNwYXduX3JlYWQ6ICcvc2Jp
bi9tdWx0aXBhdGggLXUgc2RiJyhvdXQpICdzZGIgaXMgYSB2YWxpZCBtdWx0aXBhdGggZGV2aWNl
IHBhdGgnDQpzcGF3bl93YWl0OiAnL3NiaW4vbXVsdGlwYXRoIC11IHNkYicgWzQyOTMxXSBleGl0
IHdpdGggcmV0dXJuIGNvZGUgMA0KDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
DQp6aGFuZ2d1YW5naHVpDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQqxvtPKvP68sMbkuL28/rqs09C6
vNbdu6rI/c2o0MW8vMr109DP3rmry761xLGjw9zQxc+io6y99s/e09q3osvNuPjJz8PmtdjWt9bQ
wdCz9g0KtcS49sjLu/LIutfpoaO9+9a5yM66zsbky/vIy9LUyM66ztDOyr3KudPDo6iw/MCotauy
u8/e09rIq7K/u/Kyv7fWtdjQucK2oaK4tNbGoaINCrvyyaK3oqOpsb7Tyrz+1tC1xNDFz6Kho8jn
ufvE+rTtytXBy7G+08q8/qOsx+vE+sGivLS157uwu/LTyrz+zajWqreivP7Iy7Kiyb6z/bG+DQrT
yrz+o6ENClRoaXMgZS1tYWlsIGFuZCBpdHMgYXR0YWNobWVudHMgY29udGFpbiBjb25maWRlbnRp
YWwgaW5mb3JtYXRpb24gZnJvbSBIM0MsIHdoaWNoIGlzDQppbnRlbmRlZCBvbmx5IGZvciB0aGUg
cGVyc29uIG9yIGVudGl0eSB3aG9zZSBhZGRyZXNzIGlzIGxpc3RlZCBhYm92ZS4gQW55IHVzZSBv
ZiB0aGUNCmluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJlaW4gaW4gYW55IHdheSAoaW5jbHVkaW5n
LCBidXQgbm90IGxpbWl0ZWQgdG8sIHRvdGFsIG9yIHBhcnRpYWwNCmRpc2Nsb3N1cmUsIHJlcHJv
ZHVjdGlvbiwgb3IgZGlzc2VtaW5hdGlvbikgYnkgcGVyc29ucyBvdGhlciB0aGFuIHRoZSBpbnRl
bmRlZA0KcmVjaXBpZW50KHMpIGlzIHByb2hpYml0ZWQuIElmIHlvdSByZWNlaXZlIHRoaXMgZS1t
YWlsIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXINCmJ5IHBob25lIG9yIGVtYWls
IGltbWVkaWF0ZWx5IGFuZCBkZWxldGUgaXQhDQo=

--_000_E3535A62B291B54FBD1D003696CCB5375E17A291H3CMLB14EXsrvhu_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style>body { line-height: 1.5; }body { font-size: 16pt; font-family: =CE=
=A2=C8=ED=D1=C5=BA=DA; color: rgb(0, 0, 0); line-height: 1.5; }</style>
</head>
<body>
<div>
<div><span style=3D"color: rgb(31, 73, 125); font-family: Calibri, sans-ser=
if; font-size: 16pt; background-color: window; line-height: normal; widows:=
 1;">This&nbsp;patch&nbsp;implements&nbsp;an&nbsp;option&nbsp;'-u'&nbsp;whi=
ch&nbsp;uses&nbsp;the&nbsp;information&nbsp;</span><span style=3D"color: rg=
b(31, 73, 125); font-family: Calibri, sans-serif; font-size: 16pt; backgrou=
nd-color: window; line-height: normal; widows: 1;">from&nbsp;the&nbsp;progr=
am&nbsp;environment&nbsp;when&nbsp;checking&nbsp;the&nbsp;device.</span></d=
iv>
</div>
<div style=3D"widows: 1;"><font color=3D"#1f497d" face=3D"Calibri, sans-ser=
if"><span style=3D"line-height: normal;">the function don't be found some p=
roblems.</span></font></div>
<div style=3D"text-align: justify; widows: 1;"><font color=3D"#1f497d" face=
=3D"Calibri, sans-serif"><span style=3D"line-height: 20px;">Whiling using t=
he command '</span></font><span style=3D"background-color: rgba(0, 0, 0, 0)=
; color: rgb(31, 73, 125); font-family: 'Calibri, sans-serif'; font-size: 1=
6pt; line-height: 1.5;">udevadm
 test /sys/block/sdb',</span><span style=3D"background-color: rgba(0, 0, 0,=
 0); color: rgb(31, 73, 125); font-size: 16pt; line-height: 1.5;"> som</spa=
n><font color=3D"#1f497d"><span style=3D"line-height: 1.5;">e err</span><sp=
an style=3D"line-height: 1.5;">or lo</span><span style=3D"line-height: 1.5;=
">gs,
 such as</span><span style=3D"line-height: 24px;">/sbin/multipath -u sdb'(e=
rr)</span></font></div>
<div style=3D"text-align: justify; widows: 1;"><font color=3D"#1f497d" face=
=3D"Calibri, sans-serif"><span style=3D"background-color: rgb(255, 255, 255=
);"><span style=3D"line-height: 20px;">So I don't know what is th</span><sp=
an style=3D"line-height: 20px;">at? &nbsp;I</span><span style=3D"line-heigh=
t: 30px;">s
 it a&nbsp;</span><span style=3D"line-height: 30px;">potential risk ?&nbsp;=
</span></span></font><font style=3D"font-size: 16pt; line-height: 1.5; back=
ground-color: window; color: rgb(31, 73, 125); font-family: Calibri, sans-s=
erif;">Thanks a lots</font><font style=3D"font-size: 16pt; background-color=
: window; color: rgb(31, 73, 125); font-family: Calibri, sans-serif; line-h=
eight: normal;">.
 &nbsp;</font></div>
<div><span style=3D"color: rgb(105, 105, 105); font-family: monospace; font=
-size: 18.6666660308838px; line-height: normal; widows: 1;"><br>
</span></div>
<div><span style=3D"font-size: 16px;"></span><span style=3D"background-colo=
r: rgba(0, 0, 0, 0);"><span style=3D"font-size: 16px;">udev_rules_apply_to_=
event: PROGRAM '/sbin/multipath -u sdb' /lib/udev/rules.d/95-multipath.rule=
s:20
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">udev_event_spawn: starting '/sbin/multipat=
h -u sdb'
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a0b50 has devpath '=
/devices/platform/host72/session70/target72:0:0/72:0:0:0''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a1ee0 has devpath '=
/devices/platform/host72/session70/target72:0:0''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a2980 has devpath '=
/devices/platform/host72/session70''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a1b70 has devpath '=
/devices/platform/host72''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a4230 has devpath '=
/devices/platform''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(err) =
'libudev: udev_device_new_from_syspath: device 0x55ee912a2f90 has devpath '=
/devices/platform/host72/session70/iscsi_session/session70''
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_read: '/sbin/multipath -u sdb'(out) =
'sdb is a valid multipath device path'
</span><br style=3D"font-size: 16px;">
<span style=3D"font-size: 16px;">spawn_wait: '/sbin/multipath -u sdb' [4293=
1] exit with return code 0&nbsp;</span><br>
</span></div>
<div><span style=3D"background-color: rgba(0, 0, 0, 0);"><span style=3D"fon=
t-size: 16px;"><br>
</span></span></div>
<div><br>
</div>
<hr style=3D"width: 210px; height: 1px;" color=3D"#b5c4df" size=3D"1" align=
=3D"left">
<div><span>
<div style=3D"MARGIN: 10px; FONT-FAMILY: verdana; FONT-SIZE: 10pt">
<div>zhangguanghui</div>
</div>
</span></div>
<span style=3D"font-size:7.5pt;font-family:=BB=AA=CE=C4=CF=B8=BA=DA;color:g=
ray"><span lang=3D"EN-US">-------------------------------------------------=
---------------------------------------------------------------------------=
---------<br>
</span>=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0=BA=BC=D6=DD=
=BB=AA=C8=FD=CD=A8=D0=C5=BC=BC=CA=F5=D3=D0=CF=DE=B9=AB=CB=BE=B5=C4=B1=A3=C3=
=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=B7=A2=CB=CD=B8=F8=C9=CF=C3=E6=B5=D8=
=D6=B7=D6=D0=C1=D0=B3=F6<span lang=3D"EN-US"><br>
</span>=B5=C4=B8=F6=C8=CB=BB=F2=C8=BA=D7=E9=A1=A3=BD=FB=D6=B9=C8=CE=BA=CE=
=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=CE=D0=CE=CA=BD=CA=B9=D3=C3=A3=A8=B0=FC=C0=
=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=B2=BF=BB=F2=B2=BF=B7=D6=B5=D8=D0=B9=C2=B6=
=A1=A2=B8=B4=D6=C6=A1=A2<span lang=3D"EN-US"><br>
</span>=BB=F2=C9=A2=B7=A2=A3=A9=B1=BE=D3=CA=BC=FE=D6=D0=B5=C4=D0=C5=CF=A2=
=A1=A3=C8=E7=B9=FB=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC=C7=EB=C4=
=FA=C1=A2=BC=B4=B5=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=A8=D6=AA=B7=A2=BC=FE=C8=CB=
=B2=A2=C9=BE=B3=FD=B1=BE<span lang=3D"EN-US"><br>
</span>=D3=CA=BC=FE=A3=A1<span lang=3D"EN-US"><br>
</span></span><span lang=3D"EN-US" style=3D"font-size:7.5pt;font-family:&qu=
ot;Arial&quot;,&quot;sans-serif&quot;;color:gray">This e-mail and its attac=
hments contain confidential information from H3C, which is
<br>
intended only for the person or entity whose address is listed above. Any u=
se of the
<br>
information contained herein in any way (including, but not limited to, tot=
al or partial
<br>
disclosure, reproduction, or dissemination) by persons other than the inten=
ded <br>
recipient(s) is prohibited. If you receive this e-mail in error, please not=
ify the sender
<br>
by phone or email immediately and delete it!</span>
</body>
</html>

--_000_E3535A62B291B54FBD1D003696CCB5375E17A291H3CMLB14EXsrvhu_--


--===============0115068603374890674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0115068603374890674==--
