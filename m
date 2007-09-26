From: "Kumar, Vijay (STSD)" <vijay.kumar7@hp.com>
Subject: RE: Enabling/disabling  BIO_RW_FAILFAST at load time
Date: Wed, 26 Sep 2007 09:08:12 +0530
Message-ID: <2825154BD3EAC94888C743735907EE4101A61AAA@BGEEXC02.asiapacific.cpqcorp.net>
References: <2825154BD3EAC94888C743735907EE4101A61937@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0142441226=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <2825154BD3EAC94888C743735907EE4101A61937@BGEEXC02.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0142441226==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C7FFEE.AA9C3AE2"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7FFEE.AA9C3AE2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
=20
One Typo below . Its as =20
 Flag can be set On/Off as follows=20

        modprobe dm-multipath fastfailbit=3D0             //seting it =
off=20
        modprobe dm-multipath fastfailbit=3D1             //seting it on =


Thanks,=20

Vijay Kumar=20

[Kumar, Vijay (STSD)]=20
mailto: vijay.kumar7@hp.com=20


________________________________

	From: dm-devel-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com] On Behalf Of Kumar, Vijay (STSD)
	Sent: Wednesday, September 26, 2007 12:18 AM
	To: device-mapper development; christophe.varoqui@free.fr
	Subject: [dm-devel] Enabling/disabling BIO_RW_FAILFAST at load
time
=09
=09

	Hi Christophe and All,=20
	During I/O on a path, the paths are marked as failed at DM
Multipath, when the I/O returns with Error status as 0x20000 (host code
0x2 denotes DID_BUS_BUSY). What we understand here is, since I/O on
multipath devices have BIO_RW_FAILFAST set(hence REQ_FASTFAIL ), retries
are not allowed at SCSI mid layer for errors such as QUEUEFULL,
UNDERRUN....(as captured in the below syslog snippet)

	syslog snippet=20
	*******************=20
	May 23 16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code
=3D 0x20000
	May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg,
sector 4188002
	May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg,
sector 4188008
	May 23 16:51:49 lnx kernel: device-mapper: dm-multipath: Failing
path 130:32.
	May 23 16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code
=3D 0x20000
	May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg,
sector 4188302
	May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg,
sector 4188303
	May 23 16:52:00 lnx kernel: sd 1:0:2:12: SCSI error: return code
=3D 0x20000=20

	As an option we can have user configurable BIO_RW_FAILFAST for
enabling and disabling which allows scsi mid layer to retry for I/0 .
Below is the patch for passing parameter at load time with DM multipath
module for enabling/disabling BIO_RW_FAILFAST flag.=20

	* Flag can be set On/Off as follows=20

	        modprobe dm-multipath fastfailbit=3D0             //seting
it off=20
	        modprobe dm-multipath fastfailbit=3D0             //seting
it on=20

	* By default the flag is kept on.=20

	It can also be set from modprobe.conf as :=20

	        options dm_multipath fastfailbit=3D0=20


	Please comment !!=20

	***************************************=20
	diff -Naur linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c linux-

	2.6.18.x86_64/drivers/md/dm-mpath.c=20
	--- linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c
2007-08-27=20
	02:18:51.000000000 +0530=20
	+++ linux-2.6.18.x86_64/drivers/md/dm-mpath.c   2007-09-12
16:02:29.000000000=20
	+0530=20
	@@ -19,6 +19,7 @@=20
	 #include <linux/slab.h>=20
	 #include <linux/time.h>=20
	 #include <linux/workqueue.h>=20
	+#include <linux/moduleparam.h>=20
	 #include <asm/atomic.h>=20

	 #define DM_MSG_PREFIX "multipath"=20
	@@ -107,6 +108,7 @@=20
	 static void process_queued_ios(void *data);=20
	 static void trigger_event(void *data);=20

	+static int fastfailbit =3D 1;   /*fastfail bit set on by
default*/=20

	 /*-----------------------------------------------=20
	  * Allocation routines=20
	@@ -800,7 +802,7 @@=20
	        dm_bio_record(&mpio->details, bio);=20

	        map_context->ptr =3D mpio;=20
	-       bio->bi_rw |=3D (1 << BIO_RW_FAILFAST);=20
	+       bio->bi_rw |=3D (fastfailbit << BIO_RW_FAILFAST);=20
	        r =3D map_io(m, bio, mpio, 0);=20
	        if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)=20
	                mempool_free(mpio, m->mpio_pool);=20
	@@ -1340,6 +1342,10 @@=20
	 {=20
	        int r;=20

	+       /* validating fastfailbit */=20
	+        if(fastfailbit)=20
	+                fastfailbit=3D1;=20
	+=20
	        /* allocate a slab for the dm_ios */=20
	        _mpio_cache =3D kmem_cache_create("dm_mpath",
sizeof(struct mpath_io),=20
	                                        0, 0, NULL, NULL);=20
	@@ -1387,6 +1393,8 @@=20
	 module_init(dm_multipath_init);=20
	 module_exit(dm_multipath_exit);=20

	+module_param(fastfailbit, int, 0);=20
	+MODULE_PARM_DESC(fastfailbit, "FASTFAIL bit flag ");=20
	 MODULE_DESCRIPTION(DM_NAME " multipath target");=20
	 MODULE_AUTHOR("Sistina Software <dm-devel@redhat.com
<mailto:dm-devel@redhat.com> >");=20
	 MODULE_LICENSE("GPL");=20

	******************************=20
	 =20
	Thanks,=20

	Vijay Kumar=20

	[Kumar, Vijay (STSD)]=20
	mailto: vijay.kumar7@hp.com=20


------_=_NextPart_001_01C7FFEE.AA9C3AE2
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Enabling/disabling BIO_RW_FAILFAST at load =
time</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2800.1593" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D011353003-26092007>Hi,</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D011353003-26092007></SPAN></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D011353003-26092007>One Typo below . Its as =
&nbsp;</SPAN></FONT></DIV>
<DIV><FONT face=3D"Courier New" size=3D2>&nbsp;Flag can be set On/Off as =

follows</FONT>=20
<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3D"Courier New" =

size=3D2>modprobe dm-multipath fastfailbit=3D0&nbsp;&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //seting it off</FONT>=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3D"Courier =
New"=20
size=3D2>modprobe dm-multipath fastfailbit=3D<SPAN=20
class=3D011353003-26092007>1</SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
//seting it on</FONT> </P></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><FONT=20
face=3D"Courier New">Thanks,</FONT><FONT face=3D"Times New Roman" =
color=3D#000000=20
size=3D3> </FONT>
<P><FONT face=3D"Courier New" color=3D#0000ff size=3D2>Vijay =
Kumar</FONT> </P>
<P><FONT face=3D"Courier New" color=3D#0000ff size=3D2>[Kumar, Vijay =
(STSD)]</FONT>=20
<BR><FONT face=3D"Courier New" color=3D#0000ff size=3D2>mailto:=20
vijay.kumar7@hp.com</FONT> </P></FONT></DIV><BR>
<BLOCKQUOTE dir=3Dltr=20
style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #0000ff 2px =
solid; MARGIN-RIGHT: 0px">
  <DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr align=3Dleft>
  <HR tabIndex=3D-1>
  <FONT face=3DTahoma size=3D2><B>From:</B> dm-devel-bounces@redhat.com=20
  [mailto:dm-devel-bounces@redhat.com] <B>On Behalf Of </B>Kumar, Vijay=20
  (STSD)<BR><B>Sent:</B> Wednesday, September 26, 2007 12:18 =
AM<BR><B>To:</B>=20
  device-mapper development; =
christophe.varoqui@free.fr<BR><B>Subject:</B>=20
  [dm-devel] Enabling/disabling BIO_RW_FAILFAST at load=20
time<BR></FONT><BR></DIV>
  <DIV></DIV><!-- Converted from text/rtf format -->
  <P><FONT face=3D"Courier New" size=3D2>Hi Christophe and All, =
</FONT><BR><FONT=20
  face=3D"Courier New" size=3D2>During I/O on a path, the paths are =
marked as failed=20
  at DM Multipath, when the I/O returns with Error status as 0x20000 =
(host code=20
  0x2 denotes DID_BUS_BUSY). What we understand here is, since I/O on =
multipath=20
  devices have BIO_RW_FAILFAST set(hence REQ_FASTFAIL ), retries are not =
allowed=20
  at SCSI mid layer for errors such as QUEUEFULL, UNDERRUN....(as =
captured in=20
  the below syslog snippet)</FONT></P>
  <P><FONT face=3D"Courier New" color=3D#0000ff size=3D2>syslog =
snippet</FONT>=20
  <BR><FONT face=3D"Courier New" color=3D#0000ff =
size=3D2>*******************</FONT>=20
  <BR><FONT face=3D"Courier New" color=3D#0000ff size=3D2>May 23 =
16:51:49 lnx kernel:=20
  sd 2:0:3:8: SCSI error: return code =3D 0x20000<BR>May 23 16:51:49 lnx =
kernel:=20
  end_request: I/O error, dev sdfg, sector 4188002<BR>May 23 16:51:49 =
lnx=20
  kernel: end_request: I/O error, dev sdfg, sector 4188008<BR>May 23 =
16:51:49=20
  lnx kernel: device-mapper: dm-multipath: Failing path 130:32.<BR>May =
23=20
  16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code =3D =
0x20000<BR>May 23=20
  16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector =
4188302<BR>May=20
  23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector=20
  4188303<BR>May 23 16:52:00 lnx kernel: sd 1:0:2:12: SCSI error: return =
code =3D=20
  0x20000</FONT> </P>
  <P><FONT face=3D"Courier New" size=3D2>As an option we can have user =
configurable=20
  BIO_RW_FAILFAST for enabling and disabling which allows scsi mid layer =
to=20
  retry for I/0 .&nbsp; Below is the patch for passing parameter at load =
time=20
  with DM multipath module for enabling/disabling BIO_RW_FAILFAST flag.=20
  </FONT></P>
  <P><FONT face=3D"Courier New" size=3D2>* Flag can be set On/Off as =
follows</FONT>=20
  </P>
  <P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3D"Courier =
New"=20
  size=3D2>modprobe dm-multipath fastfailbit=3D0&nbsp;&nbsp;&nbsp;&nbsp; =

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //seting it off</FONT>=20
  <BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3D"Courier =
New"=20
  size=3D2>modprobe dm-multipath fastfailbit=3D0&nbsp;&nbsp;&nbsp;&nbsp; =

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //seting it on</FONT> </P>
  <P><FONT face=3D"Courier New" size=3D2>* By default the flag is kept =
on.</FONT>=20
  </P>
  <P><FONT face=3D"Courier New" size=3D2>It can also be set from =
modprobe.conf as=20
  :</FONT> </P>
  <P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3D"Courier =
New"=20
  size=3D2>options dm_multipath fastfailbit=3D0</FONT> </P><BR>
  <P><FONT face=3D"Courier New" size=3D2>Please comment !!</FONT> </P>
  <P><FONT face=3D"Courier New"=20
  size=3D2>***************************************</FONT> <BR><FONT=20
  face=3D"Courier New" size=3D2>diff -Naur=20
  linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c linux-</FONT> <BR><FONT =

  face=3D"Courier New" =
size=3D2>2.6.18.x86_64/drivers/md/dm-mpath.c</FONT> <BR><FONT=20
  face=3D"Courier New" size=3D2>---=20
  =
linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;=20
  2007-08-27 </FONT><BR><FONT face=3D"Courier New" =
size=3D2>02:18:51.000000000=20
  +0530</FONT> <BR><FONT face=3D"Courier New" size=3D2>+++=20
  linux-2.6.18.x86_64/drivers/md/dm-mpath.c&nbsp;&nbsp; 2007-09-12=20
  16:02:29.000000000 </FONT><BR><FONT face=3D"Courier New" =
size=3D2>+0530</FONT>=20
  <BR><FONT face=3D"Courier New" size=3D2>@@ -19,6 +19,7 @@</FONT> =
<BR><FONT=20
  face=3D"Courier New" size=3D2>&nbsp;#include =
&lt;linux/slab.h&gt;</FONT> <BR><FONT=20
  face=3D"Courier New" size=3D2>&nbsp;#include =
&lt;linux/time.h&gt;</FONT> <BR><FONT=20
  face=3D"Courier New" size=3D2>&nbsp;#include =
&lt;linux/workqueue.h&gt;</FONT>=20
  <BR><FONT face=3D"Courier New" size=3D2>+#include=20
  &lt;linux/moduleparam.h&gt;</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;#include &lt;asm/atomic.h&gt;</FONT> </P>
  <P><FONT face=3D"Courier New" size=3D2>&nbsp;#define DM_MSG_PREFIX=20
  "multipath"</FONT> <BR><FONT face=3D"Courier New" size=3D2>@@ -107,6 =
+108,7=20
  @@</FONT> <BR><FONT face=3D"Courier New" size=3D2>&nbsp;static void=20
  process_queued_ios(void *data);</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;static void trigger_event(void *data);</FONT> </P>
  <P><FONT face=3D"Courier New" size=3D2>+static int fastfailbit =3D =
1;&nbsp;&nbsp;=20
  /*fastfail bit set on by default*/</FONT> </P>
  <P><FONT face=3D"Courier New"=20
  =
size=3D2>&nbsp;/*-----------------------------------------------</FONT>=20
  <BR><FONT face=3D"Courier New" size=3D2>&nbsp; * Allocation =
routines</FONT>=20
  <BR><FONT face=3D"Courier New" size=3D2>@@ -800,7 +802,7 @@</FONT> =
<BR><FONT=20
  face=3D"Courier New" =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  dm_bio_record(&amp;mpio-&gt;details, bio);</FONT> </P>
  <P><FONT face=3D"Courier New" =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  map_context-&gt;ptr =3D mpio;</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_rw |=3D (1 =
&lt;&lt;=20
  BIO_RW_FAILFAST);</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_rw |=3D =
(fastfailbit=20
  &lt;&lt; BIO_RW_FAILFAST);</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D map_io(m, =
bio, mpio,=20
  0);</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r &lt; 0 || r =
=3D=3D=20
  DM_MAPIO_REQUEUE)</FONT> <BR><FONT face=3D"Courier New"=20
  =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;=20
  mempool_free(mpio, m-&gt;mpio_pool);</FONT> <BR><FONT face=3D"Courier =
New"=20
  size=3D2>@@ -1340,6 +1342,10 @@</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;{</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int r;</FONT> </P>
  <P><FONT face=3D"Courier New" =
size=3D2>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*=20
  validating fastfailbit */</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
if(fastfailbit)</FONT>=20
  <BR><FONT face=3D"Courier New"=20
  =
size=3D2>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  fastfailbit=3D1;</FONT> <BR><FONT face=3D"Courier New" =
size=3D2>+</FONT> <BR><FONT=20
  face=3D"Courier New" =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*=20
  allocate a slab for the dm_ios */</FONT> <BR><FONT face=3D"Courier =
New"=20
  size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _mpio_cache =3D=20
  kmem_cache_create("dm_mpath", sizeof(struct mpath_io),</FONT> =
<BR><FONT=20
  face=3D"Courier New"=20
  =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
  0, 0, NULL, NULL);</FONT> <BR><FONT face=3D"Courier New" size=3D2>@@ =
-1387,6=20
  +1393,8 @@</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;module_init(dm_multipath_init);</FONT> <BR><FONT=20
  face=3D"Courier New" =
size=3D2>&nbsp;module_exit(dm_multipath_exit);</FONT> </P>
  <P><FONT face=3D"Courier New" size=3D2>+module_param(fastfailbit, int, =
0);</FONT>=20
  <BR><FONT face=3D"Courier New" size=3D2>+MODULE_PARM_DESC(fastfailbit, =
"FASTFAIL=20
  bit flag ");</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;MODULE_DESCRIPTION(DM_NAME " multipath target");</FONT> =
<BR><FONT=20
  face=3D"Courier New" size=3D2>&nbsp;MODULE_AUTHOR("Sistina Software =
&lt;</FONT><A=20
  href=3D"mailto:dm-devel@redhat.com"><U><FONT face=3D"Courier New" =
color=3D#0000ff=20
  size=3D2>dm-devel@redhat.com</FONT></U></A><FONT face=3D"Courier New"=20
  size=3D2>&gt;");</FONT> <BR><FONT face=3D"Courier New"=20
  size=3D2>&nbsp;MODULE_LICENSE("GPL");</FONT> </P>
  <P><FONT face=3D"Courier New" =
size=3D2>******************************</FONT>=20
  <BR><FONT face=3D"Times New Roman"></FONT>&nbsp; <BR><FONT =
face=3D"Courier New"=20
  color=3D#0000ff size=3D2>Thanks,</FONT> </P>
  <P><FONT face=3D"Courier New" color=3D#0000ff size=3D2>Vijay =
Kumar</FONT> </P>
  <P><FONT face=3D"Courier New" color=3D#0000ff size=3D2>[Kumar, Vijay =
(STSD)]</FONT>=20
  <BR><FONT face=3D"Courier New" color=3D#0000ff size=3D2>mailto:=20
  vijay.kumar7@hp.com</FONT> </P></BLOCKQUOTE></BODY></HTML>

------_=_NextPart_001_01C7FFEE.AA9C3AE2--


--===============0142441226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0142441226==--
