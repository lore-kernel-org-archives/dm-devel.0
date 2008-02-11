From: "Mitura, Radoslaw" <radoslaw.mitura@intel.com>
Subject: Activate/rebuilding with broken disk
Date: Mon, 11 Feb 2008 22:11:01 -0000
Message-ID: <170B86B6CD3A4E4683CCAAF936E402E502DA3FC3@swsmsx412.ger.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1836913565=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.

--===============1836913565==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C86CFA.FCCD50F1"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86CFA.FCCD50F1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm writing code to make data recovery (rebuild) with
dmraid/device-mapper.
Assume I have created and mounted a mirror raid volume with disk A and
B.
# dmsetup table
isw_dgdccjfdbi_test: 0 20971779 mirror core 2 16384 nosync 2 8:16 0 8:32
0 1 handle_errors
# dmsetup status
isw_dgdccjfdbi_test: 0 20971779 mirror 2 8:16 8:32 1281/1281 1 AA 1 core

When I remove one of disk (assume A) and make write or read from that
volume I receive dmsetup status with one "AD" (with appropriate patches
to kernel).
I can work with one broken disk (assume it is mirror) and device-mapper
will take care of next writes/reads to be directed only to device B.
Then I add a new disk C (for example 8:48).

Some questions I have:
1. How to update device mapper table in a way where device-mapper will
know that I have only disk B and C and that C is a new empty disk that
should not be used at the moment?
2. If 1 is possible without interrupting system work (volume is still
mounted) then is it possible to start rebuilding of disk B to C (also
with mounted volume)?
3. During rebuild "dmsetup status" will show rebuild progress from
0//1281 to 1281/1281 - assume it is in the middle 500/1281
A) Does device mapper take care of writes to disk B and C together if
they are directed to blocks just recovered?
B) Does device mapper take care of writes only to disk B if they are
directed to blocks not recovered yet?

Regards,
Radoslaw Mitura


---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

------_=_NextPart_001_01C86CFA.FCCD50F1
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version 6.5.7652.24">
<TITLE>Activate/rebuilding with broken disk</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial CE">Hi,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">I'm writing code to make data recovery =
(rebuild) with dmraid/device-mapper.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">Assume I have created and mounted a mi=
rror raid volume with disk A and B.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE"># dmsetup table</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">isw_dgdccjfdbi_test: 0 20971779 mirror=
 core 2 16384 nosync 2 8:16 0 8:32 0 1 handle_errors</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE"># dmsetup status</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">isw_dgdccjfdbi_test: 0 20971779 mirror=
 2 8:16 8:32 1281/1281 1 AA 1 core</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">When I remove one of disk (assume A) an=
d make write or read from that volume I receive dmsetup status with one &qu=
ot;AD&quot; (with appropriate patches to kernel).</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">I can work with one broken disk (assume=
 it is mirror) and device-mapper will take care of next writes/reads to be =
directed only to device B.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">Then I add a new disk C (for example 8:=
48).</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">Some questions I have:</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">1. How to update device mapper table i=
n a way where device-mapper will know that I have only disk B and C and tha=
t C is a new empty disk that should not be used at the moment?</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">2. If 1 is possible without interruptin=
g system work (volume is still mounted) then is it possible to start rebuil=
ding of disk B to C (also with mounted volume)?</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">3. During rebuild &quot;dmsetup status&=
quot; will show rebuild progress from 0//1281 to 1281/1281 - assume it is i=
n the middle 500/1281</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">A) Does device mapper take care of writ=
es to disk B and C together if they are directed to blocks just recovered?<=
/FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">B) Does device mapper take care of wri=
tes only to disk B if they are directed to blocks not recovered yet?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial CE">Regards,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial CE">Radoslaw Mitura</FONT>
</P>
<BR>

<pre>---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
</pre></BODY>
</HTML>
------_=_NextPart_001_01C86CFA.FCCD50F1--


--===============1836913565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1836913565==--
