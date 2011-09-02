From: egroegnibus@gmail.com
Subject: switching from active to failed.
Date: Fri, 2 Sep 2011 16:05:41 -0400
Message-ID: <55B91642-6A88-477E-BBAB-8EC1842DE957@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: multipart/mixed; boundary="===============5299202976241416744=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============5299202976241416744==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-129--468186484
Content-Transfer-Encoding: 7bit


--Apple-Mail-129--468186484
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi, I had a question on how a target can force a path on Linux to go to "fai=
led" state.=20

In the multipath -l output below, there are 4 paths to a device and all the p=
aths are "active". What kind of response/sense code is required so as to mak=
e path sddd below to go from active to failed state ?

I guess another question is : how does device mapper recognize that a path i=
s active or failed, in other words what sequence of SCSI opcodes is sent by L=
inux to discover a path and mark it dead/failed or alive ?


mpath153 (360060480000190102221533031303030) dm-154 EMC,SYMMETRIX
[size=3D938M][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D0][active]
\_ 3:0:0:11  sddd 70:176  [active][undef]
\_ 4:0:0:11  sdgt 132:144 [active][undef]
\_ 5:0:0:182 sdka 65:480  [active][undef]
\_ 6:0:0:182 sdln 68:336  [active][undef]


Thanks=

--Apple-Mail-129--468186484
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><body bgcolor=3D"#FFFFFF"><div></div><div>Hi, I had a question on how a=
 target can force a path on Linux to go to "failed" state.&nbsp;</div><div><=
br></div><div>In the multipath -l output below, there are 4 paths to a devic=
e and all the paths are "active". What kind of response/sense code is requir=
ed so as to make path sddd below to go from active to failed state ?</div><d=
iv><br></div><div>I guess another question is : how does device mapper recog=
nize that a path is active or failed, in other words what sequence of SCSI o=
pcodes is sent by Linux to discover a path and mark it dead/failed or alive ?=
<br><br></div><div><br><span class=3D"Apple-style-span" style=3D"-webkit-tap=
-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-composition-fill-color=
: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 1=
28, 180, 0.230469); font-size: medium; "><span>mpath153 (3600604800001901022=
21533031303030) dm-154 EMC,SYMMETRIX</span></span><span class=3D"Apple-style=
-span" style=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -we=
bkit-composition-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composit=
ion-frame-color: rgba(77, 128, 180, 0.230469); font-size: medium; "><br></sp=
an><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color: rg=
ba(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227=
, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); f=
ont-size: medium; "><span>[size=3D938M][features=3D0][hwhandler=3D0][rw]</sp=
an></span><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-co=
lor: rgba(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 1=
92, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.23=
0469); font-size: medium; "><br></span><span class=3D"Apple-style-span" styl=
e=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-compos=
ition-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-c=
olor: rgba(77, 128, 180, 0.230469); font-size: medium; "><span>\_ round-robi=
n 0 [prio=3D0][active]</span></span><span class=3D"Apple-style-span" style=3D=
"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-compositio=
n-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color=
: rgba(77, 128, 180, 0.230469); font-size: medium; "><br></span><span class=3D=
"Apple-style-span" style=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.=
296875); -webkit-composition-fill-color: rgba(175, 192, 227, 0.230469); -web=
kit-composition-frame-color: rgba(77, 128, 180, 0.230469); font-size: medium=
; "><span>\_ 3:0:<a href=3D"x-apple-data-detectors://1" x-apple-data-detecto=
rs=3D"true">0:11</a>&nbsp;&nbsp;sddd 70:176 &nbsp;[active][undef]</span></sp=
an><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color: rg=
ba(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227=
, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); f=
ont-size: medium; "><br></span><span class=3D"Apple-style-span" style=3D"-we=
bkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-composition-fi=
ll-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rg=
ba(77, 128, 180, 0.230469); font-size: medium; "><span>\_ 4:0:<a href=3D"x-a=
pple-data-detectors://2" x-apple-data-detectors=3D"true">0:11</a>&nbsp;&nbsp=
;sdgt 132:144 [active][undef]</span></span><span class=3D"Apple-style-span" s=
tyle=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-com=
position-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-fram=
e-color: rgba(77, 128, 180, 0.230469); font-size: medium; "><br></span><span=
 class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color: rgba(26, 2=
6, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227, 0.2304=
69); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); font-siz=
e: medium; "><span>\_ 5:0:0:182 sdka 65:480 &nbsp;[active][undef]</span></sp=
an><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color: rg=
ba(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227=
, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); f=
ont-size: medium; "><br></span><span class=3D"Apple-style-span" style=3D"-we=
bkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-composition-fi=
ll-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rg=
ba(77, 128, 180, 0.230469); font-size: medium; "><span>\_ 6:0:0:182 sdln 68:=
336 &nbsp;[active][undef]</span></span><span class=3D"Apple-style-span" styl=
e=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-compos=
ition-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-c=
olor: rgba(77, 128, 180, 0.230469); font-size: medium; "><br></span><div><br=
></div></div><div><br></div><div>Thanks</div></body></html>=

--Apple-Mail-129--468186484--


--===============5299202976241416744==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5299202976241416744==--
