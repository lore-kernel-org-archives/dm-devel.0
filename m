From: "George ." <george@ucdn.com>
Subject: dm-cache: dm-3.14-fixes-4
Date: Mon, 17 Mar 2014 15:43:35 +0200
Message-ID: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8197662815509885631=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8197662815509885631==
Content-Type: multipart/alternative; boundary=047d7b86de4027110204f4cd9b0b

--047d7b86de4027110204f4cd9b0b
Content-Type: text/plain; charset=ISO-8859-1

Hi,

In dm-3.14-fixes-4, there is a description that :

- fix corruption with >2TB fast device due to truncation bug
But looking at the diffidence I can't find anything related to such bug.


I'm asking this, because we are trying to use dm-cache on machine with 2.4
TB SDD cache and after I took following fix:

dm-3.14-fixes-1
dm cache: fix truncation bug when mapping I/O to >2TB fast device
dm-3.14-fixes-1<http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=dm-3.14-fixes-1>

our cached device got corrupted again.


My question is: is there another truncation bug discovered?


I've back ported  dm-3.14-fixes-1 to 3.11.10 kernel, because when we tested
v3.14-rc5<http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=v3.14-rc5>
-
cached device was corrupted after ~15 minutes and seems to be more
unstable.

Meanwhile I'll try to find what happens on >2TB border and eventually will
fix it.

--047d7b86de4027110204f4cd9b0b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>In=A0<span style=3D"color:rgb(51,51=
,51);font-family:sans-serif;font-size:13px">dm-3.14-fixes-4, there is a des=
cription that :</span></div><div><span style=3D"color:rgb(51,51,51);font-fa=
mily:sans-serif;font-size:13px"><br>
</span></div><div><span style=3D"color:rgb(51,51,51);font-family:monospace;=
font-size:13px;white-space:pre">- fix corruption with &gt;2TB fast device d=
ue to truncation bug</span><span style=3D"color:rgb(51,51,51);font-family:s=
ans-serif;font-size:13px"><br>
</span></div><div><font color=3D"#333333" face=3D"monospace"><span style=3D=
"white-space:pre">But looking at the </span></font><font color=3D"#333333" =
face=3D"monospace"><span style=3D"white-space:pre">diffidence I can&#39;t f=
ind anything related to such bug.</span></font></div>
<div><span style=3D"color:rgb(51,51,51);font-family:monospace;font-size:13p=
x;white-space:pre"><br></span></div><div><span style=3D"color:rgb(51,51,51)=
;font-family:monospace;font-size:13px;white-space:pre"><br></span></div><di=
v>
<span style=3D"color:rgb(51,51,51);font-family:monospace;font-size:13px;whi=
te-space:pre">I&#39;m asking this, because we are trying to use dm-cache on=
 machine with 2.4 TB SDD cache and after I took following fix:</span></div>
<div><span style=3D"color:rgb(51,51,51);font-family:sans-serif;font-size:13=
px"><br></span></div><div><span style=3D"color:rgb(51,51,51);font-family:sa=
ns-serif;font-size:13px">dm-3.14-fixes-1</span><span style=3D"color:rgb(51,=
51,51);font-family:sans-serif;font-size:13px"><br>
</span></div><div><span style=3D"color:rgb(51,51,51);font-family:sans-serif=
;font-size:17px;font-weight:bold">dm cache: fix truncation bug when mapping=
 I/O to &gt;2TB fast device</span><span class=3D"" style=3D"color:rgb(51,51=
,51);font-family:sans-serif;font-size:17px;font-weight:bold"><a class=3D"" =
href=3D"http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.=
git/tag/?id=3Ddm-3.14-fixes-1" style=3D"color:rgb(0,0,0);text-decoration:no=
ne;margin:0px 0.5em 0px 1em;padding:0px 0.25em;background-color:rgb(255,255=
,136);border:1px solid rgb(119,119,0);font-size:13px">dm-3.14-fixes-1</a></=
span><br>
</div><div><br></div><div>our cached device got corrupted again.</div><div>=
<br></div><div><br></div><div>My question is: is there another truncation b=
ug discovered?</div><div><br></div><div><br></div><div>I&#39;ve back ported=
 =A0<span style=3D"color:rgb(51,51,51);font-family:sans-serif;font-size:12.=
727272033691406px">dm-3.14-fixes-1 to 3.11.10 kernel, because when we teste=
d=A0</span><a href=3D"http://git.kernel.org/cgit/linux/kernel/git/device-ma=
pper/linux-dm.git/tag/?id=3Dv3.14-rc5" style=3D"font-size:13px;color:black;=
text-decoration:none;font-family:sans-serif;white-space:nowrap">v3.14-rc5</=
a>=A0- cached device was corrupted after ~15 minutes and seems to be more u=
nstable.=A0<br>
<br>Meanwhile I&#39;ll try to find what happens on &gt;2TB border and event=
ually will fix it.</div></div>

--047d7b86de4027110204f4cd9b0b--


--===============8197662815509885631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8197662815509885631==--
