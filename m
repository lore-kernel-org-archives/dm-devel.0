From: "Kumar, Vijay (STSD)" <vijay.kumar7@hp.com>
Subject: Enabling/disabling  BIO_RW_FAILFAST at load time
Date: Wed, 26 Sep 2007 00:17:39 +0530
Message-ID: <2825154BD3EAC94888C743735907EE4101A61937@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1354379006=="
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
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1354379006==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C7FFA4.8CC7948C"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7FFA4.8CC7948C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Christophe and All,=20
During I/O on a path, the paths are marked as failed at DM Multipath,
when the I/O returns with Error status as 0x20000 (host code 0x2 denotes
DID_BUS_BUSY). What we understand here is, since I/O on multipath
devices have BIO_RW_FAILFAST set(hence REQ_FASTFAIL ), retries are not
allowed at SCSI mid layer for errors such as QUEUEFULL, UNDERRUN....(as
captured in the below syslog snippet)

syslog snippet
*******************
May 23 16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code =3D
0x20000
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector
4188002
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector
4188008
May 23 16:51:49 lnx kernel: device-mapper: dm-multipath: Failing path
130:32.
May 23 16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code =3D
0x20000
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector
4188302
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector
4188303
May 23 16:52:00 lnx kernel: sd 1:0:2:12: SCSI error: return code =3D
0x20000

As an option we can have user configurable BIO_RW_FAILFAST for enabling
and disabling which allows scsi mid layer to retry for I/0 .  Below is
the patch for passing parameter at load time with DM multipath module
for enabling/disabling BIO_RW_FAILFAST flag.=20

* Flag can be set On/Off as follows

	modprobe dm-multipath fastfailbit=3D0		//seting it off
	modprobe dm-multipath fastfailbit=3D0		//seting it on

* By default the flag is kept on.

It can also be set from modprobe.conf as :

	options dm_multipath fastfailbit=3D0


Please comment !!

***************************************
diff -Naur linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c linux-
2.6.18.x86_64/drivers/md/dm-mpath.c
--- linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c      2007-08-27=20
02:18:51.000000000 +0530
+++ linux-2.6.18.x86_64/drivers/md/dm-mpath.c   2007-09-12
16:02:29.000000000=20
+0530
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/workqueue.h>
+#include <linux/moduleparam.h>
 #include <asm/atomic.h>

 #define DM_MSG_PREFIX "multipath"
@@ -107,6 +108,7 @@
 static void process_queued_ios(void *data);
 static void trigger_event(void *data);

+static int fastfailbit =3D 1;   /*fastfail bit set on by default*/

 /*-----------------------------------------------
  * Allocation routines
@@ -800,7 +802,7 @@
        dm_bio_record(&mpio->details, bio);

        map_context->ptr =3D mpio;
-       bio->bi_rw |=3D (1 << BIO_RW_FAILFAST);
+       bio->bi_rw |=3D (fastfailbit << BIO_RW_FAILFAST);
        r =3D map_io(m, bio, mpio, 0);
        if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)
                mempool_free(mpio, m->mpio_pool);
@@ -1340,6 +1342,10 @@
 {
        int r;

+       /* validating fastfailbit */
+        if(fastfailbit)
+                fastfailbit=3D1;
+
        /* allocate a slab for the dm_ios */
        _mpio_cache =3D kmem_cache_create("dm_mpath", sizeof(struct
mpath_io),
                                        0, 0, NULL, NULL);
@@ -1387,6 +1393,8 @@
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);

+module_param(fastfailbit, int, 0);
+MODULE_PARM_DESC(fastfailbit, "FASTFAIL bit flag ");
 MODULE_DESCRIPTION(DM_NAME " multipath target");
 MODULE_AUTHOR("Sistina Software <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");

******************************
=20
> Thanks,
>=20
> Vijay Kumar
>=20
> [Kumar, Vijay (STSD)]
> mailto: vijay.kumar7@hp.com
>=20

------_=_NextPart_001_01C7FFA4.8CC7948C
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7652.24">
<TITLE>Enabling/disabling  BIO_RW_FAILFAST at load time</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Courier New">Hi Christophe and All, </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">During I/O on a path, the paths =
are marked as failed at DM Multipath, when the I/O returns with Error =
status as 0x20000 (host code 0x2 denotes DID_BUS_BUSY). What we =
understand here is, since I/O on multipath devices have BIO_RW_FAILFAST =
set(hence REQ_FASTFAIL ), retries are not allowed at SCSI mid layer for =
errors such as QUEUEFULL, UNDERRUN....(as captured in the below syslog =
snippet)</FONT></P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">syslog =
snippet</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier =
New">*******************</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">May 23 =
16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code =3D 0x20000<BR>
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector =
4188002<BR>
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector =
4188008<BR>
May 23 16:51:49 lnx kernel: device-mapper: dm-multipath: Failing path =
130:32.<BR>
May 23 16:51:49 lnx kernel: sd 2:0:3:8: SCSI error: return code =3D =
0x20000<BR>
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector =
4188302<BR>
May 23 16:51:49 lnx kernel: end_request: I/O error, dev sdfg, sector =
4188303<BR>
May 23 16:52:00 lnx kernel: sd 1:0:2:12: SCSI error: return code =3D =
0x20000</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">As an option we can have user =
configurable BIO_RW_FAILFAST for enabling and disabling which allows =
scsi mid layer to retry for I/0 .&nbsp; Below is the patch for passing =
parameter at load time with DM multipath module for enabling/disabling =
BIO_RW_FAILFAST flag. </FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">* Flag can be set On/Off as =
follows</FONT>
</P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">modprobe dm-multipath =
fastfailbit=3D0&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //seting it off</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">modprobe dm-multipath =
fastfailbit=3D0&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //seting it on</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">* By default the flag is kept =
on.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">It can also be set from =
modprobe.conf as :</FONT>
</P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">options dm_multipath fastfailbit=3D0</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Please comment !!</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">***************************************</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">diff -Naur =
linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c linux-</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">2.6.18.x86_64/drivers/md/dm-mpath.c</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">--- =
linux-2.6.18.x86_64-orig/drivers/md/dm-mpath.c&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; 2007-08-27 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">02:18:51.000000000 +0530</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+++ =
linux-2.6.18.x86_64/drivers/md/dm-mpath.c&nbsp;&nbsp; 2007-09-12 =
16:02:29.000000000 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+0530</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -19,6 +19,7 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;#include =
&lt;linux/slab.h&gt;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;#include =
&lt;linux/time.h&gt;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;#include =
&lt;linux/workqueue.h&gt;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+#include =
&lt;linux/moduleparam.h&gt;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;#include =
&lt;asm/atomic.h&gt;</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;#define DM_MSG_PREFIX =
&quot;multipath&quot;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -107,6 +108,7 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;static void =
process_queued_ios(void *data);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;static void =
trigger_event(void *data);</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">+static int fastfailbit =3D =
1;&nbsp;&nbsp; /*fastfail bit set on by default*/</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;/*-----------------------------------------------</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp; * Allocation =
routines</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -800,7 +802,7 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dm_bio_record(&amp;mpio-&gt;details, bio);</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; map_context-&gt;ptr =3D =
mpio;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_rw |=3D (1 =
&lt;&lt; BIO_RW_FAILFAST);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_rw |=3D =
(fastfailbit &lt;&lt; BIO_RW_FAILFAST);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D map_io(m, bio, =
mpio, 0);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r &lt; 0 || r =3D=3D =
DM_MAPIO_REQUEUE)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; mempool_free(mpio, m-&gt;mpio_pool);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -1340,6 +1342,10 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;{</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int r;</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* validating fastfailbit =
*/</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(fastfailbit)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; fastfailbit=3D1;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* allocate a slab for =
the dm_ios */</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _mpio_cache =3D =
kmem_cache_create(&quot;dm_mpath&quot;, sizeof(struct mpath_io),</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; 0, 0, NULL, NULL);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -1387,6 +1393,8 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;module_init(dm_multipath_init);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;module_exit(dm_multipath_exit);</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">+module_param(fastfailbit, int, =
0);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+MODULE_PARM_DESC(fastfailbit, =
&quot;FASTFAIL bit flag &quot;);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;MODULE_DESCRIPTION(DM_NAME =
&quot; multipath target&quot;);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;MODULE_AUTHOR(&quot;Sistina Software &lt;</FONT><A =
HREF=3D"mailto:dm-devel@redhat.com"><U><FONT COLOR=3D"#0000FF" SIZE=3D2 =
FACE=3D"Courier New">dm-devel@redhat.com</FONT></U></A><FONT SIZE=3D2 =
FACE=3D"Courier New">&gt;&quot;);</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;MODULE_LICENSE(&quot;GPL&quot;);</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">******************************</FONT>

<BR><FONT FACE=3D"Times New Roman"></FONT>&nbsp;

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">Thanks,</FONT>
</P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">Vijay =
Kumar</FONT>
</P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">[Kumar, Vijay =
(STSD)]</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Courier New">mailto: =
vijay.kumar7@hp.com</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C7FFA4.8CC7948C--


--===============1354379006==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1354379006==--
