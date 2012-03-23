From: "Hart, Brian R." <brianhart@ou.edu>
Subject: mpath_prio_rdac?
Date: Fri, 23 Mar 2012 14:41:33 +0000
Message-ID: <756D2EE1FEBD2946972256A5FDFCB2EE2C38E064@IT-AIRSTORM.sooner.net.ou.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7429405936838645197=="
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

--===============7429405936838645197==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_756D2EE1FEBD2946972256A5FDFCB2EE2C38E064ITAIRSTORMsoone_"

--_000_756D2EE1FEBD2946972256A5FDFCB2EE2C38E064ITAIRSTORMsoone_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

All,

I've been trying to figure this out and have not been able to locate any in=
formation on this.  I hope that I'm not just overlooking something silly...

We have a couple of Dell MD storage arrays that when installed setup multip=
ath.conf to use this line:
        prio_callout          "/sbin/mpath_prio_rdac /dev/%n"

Now, in RHEL5 and Debian Lenny this mpath_prio_rdac file exists.  However, =
in the newer distro releases this file seems to be completely gone and I ca=
nnot find any reference to it in any packages.  Has this functionality been=
 replaced some how?  Should this line really be different or is multipath h=
andling it differently where it just ignores this line anyways in newer ver=
sions?

I would greatly appreciate any light that could be shed on the subject.  Th=
anks in advance!

-- Brian Hart

--_000_756D2EE1FEBD2946972256A5FDFCB2EE2C38E064ITAIRSTORMsoone_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaParaStyle" type=3D"text/css">P {margin-top:0;margin-bottom:=
0;}</style>
</head>
<body ocsi=3D"0" fpstyle=3D"1">
<div style=3D"direction: ltr;font-family: Tahoma;color: #000000;font-size: =
10pt;">All,<br>
<br>
I've been trying to figure this out and have not been able to locate any in=
formation on this.&nbsp; I hope that I'm not just overlooking something sil=
ly...<br>
<br>
We have a couple of Dell MD storage arrays that when installed setup multip=
ath.conf to use this line:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/mpath_prio_rdac /dev/%n&quot;<br>
<br>
Now, in RHEL5 and Debian Lenny this mpath_prio_rdac file exists.&nbsp; Howe=
ver, in the newer distro releases this file seems to be completely gone and=
 I cannot find any reference to it in any packages.&nbsp; Has this function=
ality been replaced some how?&nbsp; Should this
 line really be different or is multipath handling it differently where it =
just ignores this line anyways in newer versions?<br>
<br>
I would greatly appreciate any light that could be shed on the subject.&nbs=
p; Thanks in advance!<br>
<div><br>
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Calibri; font-size:13px"><font size=3D"2">
<div style=3D"margin:0px"><font size=3D"2" color=3D"black"><span style=3D"f=
ont-size:14px">-- Brian Hart<br>
</span></font></div>
</font></div>
</div>
</div>
</div>
</body>
</html>

--_000_756D2EE1FEBD2946972256A5FDFCB2EE2C38E064ITAIRSTORMsoone_--


--===============7429405936838645197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7429405936838645197==--
