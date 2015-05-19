From: Ravikanth Nalla <ravikanth.nalla@yahoo.com>
Subject: Regarding the correct version of sysfs util for
 multipath-tools-0.4.5
Date: Tue, 19 May 2015 14:51:13 +0000 (UTC)
Message-ID: <517618339.2403222.1432047073976.JavaMail.yahoo@mail.yahoo.com>
Reply-To: Ravikanth Nalla <ravikanth.nalla@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0761073318577587763=="
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
To: Device-mapper Development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0761073318577587763==
Content-Type: multipart/alternative;
	boundary="----=_Part_2403221_375246572.1432047073967"

------=_Part_2403221_375246572.1432047073967
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
I'm facing compilation issues with=C2=A0multipath-tools-0.4.5 w.r.t sysfs a=
s below
discovery.c:67: warning: implicit declaration of function =E2=80=98sysfs_op=
en_directory=E2=80=99discovery.c:67: warning: assignment makes pointer from=
 integer without a castdiscovery.c:68: warning: implicit declaration of fun=
ction =E2=80=98sysfs_read_directory=E2=80=99discovery.c:70: error: derefere=
ncing pointer to incomplete typediscovery.c:70: error: dereferencing pointe=
r to incomplete type=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 .....
Could you please let me know is there any corresponding sysfs util version =
and from where to download?
Thanks,Ravi

------=_Part_2403221_375246572.1432047073967
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif;fo=
nt-size:16px"><div id=3D"yui_3_16_0_1_1432046809970_6164">Hi,</div><div id=
=3D"yui_3_16_0_1_1432046809970_6164"><br></div><div id=3D"yui_3_16_0_1_1432=
046809970_6164" dir=3D"ltr">I'm facing compilation issues with&nbsp;multipa=
th-tools-0.4.5 w.r.t sysfs as below</div><div id=3D"yui_3_16_0_1_1432046809=
970_6164" dir=3D"ltr" class=3D"" style=3D""><br></div><div id=3D"yui_3_16_0=
_1_1432046809970_6164" dir=3D"ltr" class=3D"" style=3D"">discovery.c:67: wa=
rning: implicit declaration of function =E2=80=98sysfs_open_directory=E2=80=
=99</div><div id=3D"yui_3_16_0_1_1432046809970_6164" dir=3D"ltr" class=3D""=
 style=3D"">discovery.c:67: warning: assignment makes pointer from integer =
without a cast</div><div id=3D"yui_3_16_0_1_1432046809970_6164" dir=3D"ltr"=
 class=3D"" style=3D"">discovery.c:68: warning: implicit declaration of fun=
ction =E2=80=98sysfs_read_directory=E2=80=99</div><div id=3D"yui_3_16_0_1_1=
432046809970_6164" dir=3D"ltr" class=3D"" style=3D"">discovery.c:70: error:=
 dereferencing pointer to incomplete type</div><div id=3D"yui_3_16_0_1_1432=
046809970_6164" dir=3D"ltr" class=3D"" style=3D"">discovery.c:70: error: de=
referencing pointer to incomplete type</div><div dir=3D"ltr" class=3D"" sty=
le=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .....<br></=
div><div id=3D"yui_3_16_0_1_1432046809970_6164" dir=3D"ltr" class=3D"" styl=
e=3D"">Could you please let me know is there any corresponding sysfs util v=
ersion and from where to download?</div><div id=3D"yui_3_16_0_1_14320468099=
70_6164" dir=3D"ltr" class=3D"" style=3D""><br></div><div id=3D"yui_3_16_0_=
1_1432046809970_6164" dir=3D"ltr" class=3D"" style=3D"">Thanks,</div><div i=
d=3D"yui_3_16_0_1_1432046809970_6164" dir=3D"ltr" class=3D"" style=3D"">Rav=
i</div><div dir=3D"ltr" class=3D"" style=3D"" id=3D"yui_3_16_0_1_1432046809=
970_6230"><br></div></div></body></html>
------=_Part_2403221_375246572.1432047073967--


--===============0761073318577587763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0761073318577587763==--
