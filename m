From: Peter Volkov <peter.volkov@gmail.com>
Subject: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 13:52:10 +0300
Message-ID: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0150588585187805466=="
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

--===============0150588585187805466==
Content-Type: multipart/alternative; boundary=047d7b45099813834605314cf982

--047d7b45099813834605314cf982
Content-Type: text/plain; charset=UTF-8

Hi, guys.

There is a problem: udev does not create partitions for multipath devices
in case I use kpartx.rules provided with multipath sources. I found that
udev always go to kpartx_end after following line of rules:
ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"

There is 8 (!!!) years old thread that discusses this problem:
https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html

So what is the current state? Should we fix udev rules for multipath or
should we create better patch for dmsetup.c? Meanwhile I've copied
multipath.rules from redhat and partitions are created as they should.


With best regards,
--
Peter.

--047d7b45099813834605314cf982
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><font color=3D"#000000" face=3D"Times New Roman" size=
=3D"3">Hi, guys.</font></div><div><font color=3D"#000000" face=3D"Times New=
 Roman" size=3D"3"><br></font></div><div><font color=3D"#000000" face=3D"Ti=
mes New Roman" size=3D"3">There is a problem: udev does not create partitio=
ns for multipath devices in case I use kpartx.rules provided with multipath=
 sources. I found that udev always go to=C2=A0</font><span style=3D"color:r=
gb(0,0,0);font-family:&#39;Times New Roman&#39;;font-size:medium">kpartx_en=
d after following line of rules</span><span style=3D"color:rgb(0,0,0);font-=
family:&#39;Times New Roman&#39;;font-size:medium">:</span></div><div><font=
 color=3D"#000000" face=3D"Times New Roman" size=3D"3"><div>ENV{DM_TABLE_ST=
ATE}!=3D&quot;LIVE&quot;, GOTO=3D&quot;kpartx_end&quot;</div><div><br></div=
><div>There is 8 (!!!) years old thread that discusses this problem:</div><=
/font></div><div><font color=3D"#000000" face=3D"Times New Roman" size=3D"3=
"><a href=3D"https://www.redhat.com/archives/dm-devel/2007-July/msg00095.ht=
ml">https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html</a><br=
></font></div><div><font color=3D"#000000" face=3D"Times New Roman" size=3D=
"3"><br></font></div><div><font color=3D"#000000" face=3D"Times New Roman" =
size=3D"3">So what is the current state? Should we fix udev rules for multi=
path or should we create better patch for dmsetup.c? Meanwhile I&#39;ve cop=
ied multipath.rules from redhat and partitions are created as they should.<=
/font></div><div><div class=3D"gmail_signature"><br></div><div class=3D"gma=
il_signature"><br></div><div class=3D"gmail_signature">With best regards,<b=
r>--<br>Peter.</div></div>
</div>

--047d7b45099813834605314cf982--


--===============0150588585187805466==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0150588585187805466==--
