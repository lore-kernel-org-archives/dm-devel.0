From: Stefan Weinhuber <WEIN@de.ibm.com>
Subject: [PATCH][multipath-tools] discovery.c set hwe pointer for
	bus type ccw
Date: Thu, 2 Feb 2006 15:59:22 +0100
Message-ID: <OFFD0A28A6.4D76571F-ONC1257109.004DBE99-C1257109.0052476D@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 0052474CC1257109_="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

--=_mixed 0052474CC1257109_=
Content-Type: multipart/alternative;
	boundary="=_alternative 0052474CC1257109_="


--=_alternative 0052474CC1257109_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

I tried to use the current git tree version of the multipath-tools in a=20
Linux on zSeries environment with DASD devices. The tool multipath seemed=20
to
recognize the disks correctly, but ignored the device specific=20
configuration
in my multipath.conf.

Stefan Bader found the problem in libmultipath/discovery.c in the function =


ccw=5Fsysfs=5Fpathinfo. In that function the hwe configlet pointer should b=
e=20
set.
Please see attached patch:


Best Regards /  Mit freundlichen Gr=FC=DFen

Stefan Weinhuber

-------------------------------------------------------------------
IBM Deutschland Entwicklung GmbH
e-mail: wein@de.ibm.com
--=_alternative 0052474CC1257109_=
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable


<br><font size=3D2 face=3D"sans-serif">Hi Christophe,</font>
<br>
<br><font size=3D2 face=3D"sans-serif">I tried to use the current git tree
version of the multipath-tools in a </font>
<br><font size=3D2 face=3D"sans-serif">Linux on zSeries environment with DA=
SD
devices. The tool multipath seemed to</font>
<br><font size=3D2 face=3D"sans-serif">recognize the disks correctly, but i=
gnored
the device specific configuration</font>
<br><font size=3D2 face=3D"sans-serif">in my multipath.conf.</font>
<br>
<br><font size=3D2 face=3D"sans-serif">Stefan Bader found the problem in li=
bmultipath/discovery.c
in the function </font>
<br><font size=3D2 face=3D"sans-serif">ccw=5Fsysfs=5Fpathinfo. In that func=
tion
the hwe configlet pointer should be set.</font>
<br><font size=3D2 face=3D"sans-serif">Please see attached patch:</font>
<br>
<br><font size=3D2 face=3D"sans-serif"><br>
Best Regards / &nbsp;Mit freundlichen Gr=FC=DFen<br>
<br>
Stefan Weinhuber<br>
<br>
-------------------------------------------------------------------<br>
IBM Deutschland Entwicklung GmbH<br>
e-mail: wein@de.ibm.com</font>
--=_alternative 0052474CC1257109_=--

--=_mixed 0052474CC1257109_=
Content-Type: application/octet-stream; name="ccw_sysfs_pathinfo-hwe-fix.patch"
Content-Disposition: attachment; filename="ccw_sysfs_pathinfo-hwe-fix.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwIG11bHRpcGF0aC10b29scy9saWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMgbXVsdGlw
YXRoLXRvb2xzLWZpeGVkL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwotLS0gbXVsdGlwYXRoLXRv
b2xzL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwkyMDA2LTAyLTAxIDExOjMwOjA5LjAwMDAwMDAw
MCArMDEwMAorKysgbXVsdGlwYXRoLXRvb2xzLWZpeGVkL2xpYm11bHRpcGF0aC9kaXNjb3Zlcnku
YwkyMDA2LTAyLTAyIDE0OjI3OjU4LjAwMDAwMDAwMCArMDEwMApAQCAtNTIzLDYgKzUyMywxMSBA
QCBjY3dfc3lzZnNfcGF0aGluZm8gKHN0cnVjdCBwYXRoICogcHApCiAJY29uZGxvZygzLCAiJXM6
IHByb2R1Y3QgPSAlcyIsIHBwLT5kZXYsIHBwLT5wcm9kdWN0X2lkKTsKIAogCS8qCisJICogc2V0
IHRoZSBod2UgY29uZmlnbGV0IHBvaW50ZXIKKwkgKi8KKwlwcC0+aHdlID0gZmluZF9od2UoY29u
Zi0+aHd0YWJsZSwgcHAtPnZlbmRvcl9pZCwgcHAtPnByb2R1Y3RfaWQpOworCisJLyoKIAkgKiBo
b3N0IC8gYnVzIC8gdGFyZ2V0IC8gbHVuCiAJICovCiAJaWYoc2FmZV9zcHJpbnRmKGF0dHJfcGF0
aCwgIiVzL2Jsb2NrLyVzL2RldmljZSIsCg==

--=_mixed 0052474CC1257109_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 0052474CC1257109_=--
