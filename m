From: "Eyal Ben-David" <EYALBE@il.ibm.com>
Subject: Automatic blacklisting of NVMe devices if NVMe native MP
Date: Tue, 4 Jun 2019 10:29:23 +0300
Message-ID: <OFE5B87F49.B857DE99-ONC225840F.00284A78-C225840F.00292455@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6984354805400517778=="
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


--===============6984354805400517778==
Content-Type: multipart/alternative;
	boundary="=_alternative 002923C3C225840F_="


--=_alternative 002923C3C225840F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Hi all,

Is it possible to automatically blacklist all NVMe devices if the NVMe=20
driver has it's own multipath?

I mean if for example if:
=20
cat /sys/module/nvme=5Fcore/parameters/multipath=20
Y

then device mapper would automatically blacklist all NVMe devices to avoid =

unexpected consequences.


Thanks.
Eyal



--=_alternative 002923C3C225840F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<font size=3D2 face=3D"sans-serif">Hi all,</font><br><br><font size=3D2 fac=
e=3D"sans-serif">Is it possible to automatically blacklist
all NVMe devices if the NVMe driver has it's own multipath?</font><br><br><=
font size=3D2 face=3D"sans-serif">I mean if for example if:</font><br><font=
 size=3D2 face=3D"sans-serif">&nbsp; &nbsp; &nbsp; &nbsp; </font><br><font =
size=3D2 face=3D"sans-serif">cat /sys/module/nvme=5Fcore/parameters/multipa=
th
</font><br><font size=3D2 face=3D"sans-serif">Y</font><br><br><font size=3D=
2 face=3D"sans-serif">then device mapper would automatically
blacklist all NVMe devices to avoid unexpected consequences.</font><br><br>=
<br><font size=3D2 face=3D"sans-serif">Thanks.</font><br><font size=3D2 fac=
e=3D"sans-serif">Eyal</font><br><BR>
--=_alternative 002923C3C225840F_=--


--===============6984354805400517778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6984354805400517778==--
