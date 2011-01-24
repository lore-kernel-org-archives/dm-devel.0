From: <Menny_Hamburger@Dell.com>
Subject: Re: [PATCH] multipath: reference count on pgpath
Date: Mon, 24 Jan 2011 14:16:22 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064B308482@DUBX7MCDUB01.EMEA.DELL.COM>
References: <D8C50530D6022F40A817A35C40CC06A7064B2CDBEF@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8464578507904169998=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064B2CDBEF@DUBX7MCDUB01.EMEA.DELL.COM>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8464578507904169998==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064B308482DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064B308482DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mistankingly did kref_get after kref_init

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Hamburger, Menny
Sent: 23 January, 2011 15:40
To: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] multipath: reference count on pgpath

Hi,

Here is the patch I am currently testing to solve the OOPs  in  pg_init_don=
e (from send_mode_select).
The patch  adds a reference count to pgpath, which  ensures that activate_p=
ath has the pgpath intact when the call to scsi_dh_activate returns; thus a=
ny call to send_mode_select from within scsi_dh_rdac will call pg_init_done=
 with a valid pgpath.


This patch is over RHEL5.4.

diff -r -U 2 a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c    2011-01-23 14:26:51.483249000 +0200
+++ b/drivers/md/dm-mpath.c 2011-01-23 14:26:51.521889000 +0200
@@ -21,4 +21,5 @@
#include <linux/time.h>
#include <linux/workqueue.h>
+#include <linux/kref.h>
#include <scsi/scsi_dh.h>
#include <asm/atomic.h>
@@ -34,4 +35,5 @@
                struct priority_group *pg;            /* Owning PG */
                unsigned fail_count;                       /* Cumulative fa=
ilure count */
+             struct kref ref_count;

                struct path path;
@@ -129,4 +131,6 @@
                                memset(pgpath, 0, sizeof(*pgpath));
                                pgpath->path.is_active =3D 1;
+                             kref_init(&pgpath->ref_count);
+                             kref_get(&pgpath->ref_count);
                                INIT_WORK(&pgpath->activate_path, activate_=
path, pgpath);
                }
@@ -140,4 +144,11 @@
}

+static void release_pgpath(struct kref *kref)
+{
+        struct pgpath *pgpath =3D container_of(kref, struct pgpath, ref_co=
unt);
+             free_pgpath(pgpath);
+
+}
+
static struct priority_group *alloc_priority_group(void)
{
@@ -164,5 +175,5 @@
                                                scsi_dh_detach(bdev_get_que=
ue(pgpath->path.dev->bdev));
                                dm_put_device(ti, pgpath->path.dev);
-                              free_pgpath(pgpath);
+                             kref_put(&pgpath->ref_count, release_pgpath);
                }
}
@@ -449,6 +460,8 @@
                                                                if (queue_d=
elayed_work(kmpath_handlerd,
                                                                    &tmp->a=
ctivate_path, m->pg_init_delay ?
-                                                                  m->pg_in=
it_delay_secs * HZ : 0))
+                                                                 m->pg_ini=
t_delay_secs * HZ : 0)) {
+                                                                          =
   kref_get(&pgpath->ref_count);
                                                                           =
     m->pg_init_in_progress++;
+                                                             }
                                                }
                                }
@@ -971,6 +984,8 @@
                                queue_work(kmultipathd, &m->process_queued_=
ios);
                } else if (m->hw_handler_name && (m->current_pg =3D=3D pgpa=
th->pg)) {
-                              if (queue_work(kmpath_handlerd, &pgpath->act=
ivate_path))
+                             if (queue_work(kmpath_handlerd, &pgpath->acti=
vate_path)) {
+                                             kref_get(&pgpath->ref_count);
                                                m->pg_init_in_progress++;
+                             }
                }

@@ -1215,4 +1230,5 @@
                scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
                                                                pg_init_don=
e, &pgpath->path);
+             kref_put(&pgpath->ref_count, release_pgpath);
}

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064B308482DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><META HTTP-EQUIV=3D"Content-Type" CONTENT=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 12 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span style=3D'c=
olor:#1F497D'>Mistankingly did kref_get after kref_init<o:p></o:p></span></=
p><p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></spa=
n></p><div><div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding=
:3.0pt 0in 0in 0in'><p class=3DMsoNormal><b><span style=3D'font-size:10.0pt=
;font-family:"Tahoma","sans-serif"'>From:</span></b><span style=3D'font-siz=
e:10.0pt;font-family:"Tahoma","sans-serif"'> dm-devel-bounces@redhat.com [m=
ailto:dm-devel-bounces@redhat.com] <b>On Behalf Of </b>Hamburger, Menny<br>=
<b>Sent:</b> 23 January, 2011 15:40<br><b>To:</b> dm-devel@redhat.com<br><b=
>Subject:</b> [dm-devel] [PATCH] multipath: reference count on pgpath<o:p><=
/o:p></span></p></div></div><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p cl=
ass=3DMsoNormal>Hi,<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p=
><p class=3DMsoNormal>Here is the patch I am currently testing to solve the=
 OOPs&nbsp; in&nbsp; pg_init_done (from send_mode_select).<o:p></o:p></p><p=
 class=3DMsoNormal>The patch&nbsp; adds a reference count to pgpath, which&=
nbsp; ensures that activate_path has the pgpath intact when the call to scs=
i_dh_activate returns; thus any call to send_mode_select from within scsi_d=
h_rdac will call pg_init_done with a valid pgpath. <o:p></o:p></p><p class=
=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p=
><p class=3DMsoNormal>This patch is over RHEL5.4.<o:p></o:p></p><p class=3D=
MsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>diff -r -U 2 a/drivers/=
md/dm-mpath.c b/drivers/md/dm-mpath.c<o:p></o:p></p><p class=3DMsoNormal>--=
- a/drivers/md/dm-mpath.c&nbsp;&nbsp;&nbsp; 2011-01-23 14:26:51.483249000 +=
0200<o:p></o:p></p><p class=3DMsoNormal>+++ b/drivers/md/dm-mpath.c 2011-01=
-23 14:26:51.521889000 +0200<o:p></o:p></p><p class=3DMsoNormal>@@ -21,4 +2=
1,5 @@<o:p></o:p></p><p class=3DMsoNormal>#include &lt;linux/time.h&gt;<o:p=
></o:p></p><p class=3DMsoNormal>#include &lt;linux/workqueue.h&gt;<o:p></o:=
p></p><p class=3DMsoNormal>+#include &lt;linux/kref.h&gt;<o:p></o:p></p><p =
class=3DMsoNormal>#include &lt;scsi/scsi_dh.h&gt;<o:p></o:p></p><p class=3D=
MsoNormal>#include &lt;asm/atomic.h&gt;<o:p></o:p></p><p class=3DMsoNormal>=
@@ -34,4 +35,5 @@<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct=
 priority_group *pg;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; /* Owning PG */<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; unsigned fail_count;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; /* Cumulative failure count */<o:p></o:p></p><p class=3DMsoNormal>+&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; str=
uct kref ref_count;<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p=
><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path path;<o:p></o:p></p><p cl=
ass=3DMsoNormal>@@ -129,4 +131,6 @@<o:p></o:p></p><p class=3DMsoNormal>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(pgpath, 0, sizeof(*pgpath));<o:p></=
o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pgpath-&g=
t;path.is_active =3D 1;<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; kref_init(&amp;pgpath-&gt;ref_count);<o:p></o:p></p><p class=3DMsoNorma=
l>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; kref_get(&amp;pgpath-&gt;ref_count);<o:p></o:p></p><p=
 class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; INIT_WORK(&amp;pgpa=
th-&gt;activate_path, activate_path, pgpath);<o:p></o:p></p><p class=3DMsoN=
ormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p><p class=3DMsoNormal>@@ -140,4 +144,1=
1 @@<o:p></o:p></p><p class=3DMsoNormal>}<o:p></o:p></p><p class=3DMsoNorma=
l><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>+static void release_pgpath(str=
uct kref *kref)<o:p></o:p></p><p class=3DMsoNormal>+{<o:p></o:p></p><p clas=
s=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pgpath *pg=
path =3D container_of(kref, struct pgpath, ref_count);<o:p></o:p></p><p cla=
ss=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; free_pgpath(pgpath);<o:p></o:p></p><p class=3DMsoNormal>+<o:p=
></o:p></p><p class=3DMsoNormal>+}<o:p></o:p></p><p class=3DMsoNormal>+<o:p=
></o:p></p><p class=3DMsoNormal>static struct priority_group *alloc_priorit=
y_group(void)<o:p></o:p></p><p class=3DMsoNormal>{<o:p></o:p></p><p class=
=3DMsoNormal>@@ -164,5 +175,5 @@<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; scsi_dh_detach(bdev_get_=
queue(pgpath-&gt;path.dev-&gt;bdev));<o:p></o:p></p><p class=3DMsoNormal>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dm_put_device(ti, pgpath-&gt;path.dev);<=
o:p></o:p></p><p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free_pgpath(pg=
path);<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kref_put(&amp=
;pgpath-&gt;ref_count, release_pgpath);<o:p></o:p></p><p class=3DMsoNormal>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; }<o:p></o:p></p><p class=3DMsoNormal>}<o:p></o:p></p><p cla=
ss=3DMsoNormal>@@ -449,6 +460,8 @@<o:p></o:p></p><p class=3DMsoNormal>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i=
f (queue_delayed_work(kmpath_handlerd,<o:p></o:p></p><p class=3DMsoNormal>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; &amp;tmp-&gt;activate_path, m-&gt;pg_init_delay ?<o:p=
></o:p></p><p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; m-&gt;pg_init_delay_secs * HZ :=
 0))<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; m-&gt;pg_init_delay_secs * HZ : 0)=
) {<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kref_get(&amp;pgpath-&gt;ref=
_count);<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; m-&gt;=
pg_init_in_progress++;<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p><p class=3DMso=
Normal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:=
p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p=
></p><p class=3DMsoNormal>@@ -971,6 +984,8 @@<o:p></o:p></p><p class=3DMsoN=
ormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queue_work(kmultipathd, &amp;m-&=
gt;process_queued_ios);<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
} else if (m-&gt;hw_handler_name &amp;&amp; (m-&gt;current_pg =3D=3D pgpath=
-&gt;pg)) {<o:p></o:p></p><p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if=
 (queue_work(kmpath_handlerd, &amp;pgpath-&gt;activate_path))<o:p></o:p></p=
><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (queue_work(kmpath_handlerd, &=
amp;pgpath-&gt;activate_path)) {<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kref_get(&amp;pgpath-&gt;ref_count);<o:p>=
</o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; m-&gt;pg_init_in_progress++;<o:p></o:p></p><p class=3DMsoNorm=
al>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 }<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNo=
rmal>@@ -1215,4 +1230,5 @@<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; scsi_dh_activate(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p=
></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pg_init_done, &amp;pgpath-&gt;path);<o:p></o:=
p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; kref_put(&amp;pgpath-&gt;ref_count, release_pgpat=
h);<o:p></o:p></p><p class=3DMsoNormal>}<o:p></o:p></p><p class=3DMsoNormal=
><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><b><span style=3D'font-size:10.0=
pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>Menny Hamburger</=
span></b><span style=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-se=
rif";color:#444444'><o:p></o:p></span></p><p class=3DMsoNormal><span style=
=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>=
Engineer<o:p></o:p></span></p><p class=3DMsoNormal><b><span style=3D'font-s=
ize:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#0085C3'>Dell</span=
></b><span style=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif"=
;color:#444444'> | IDC<b><o:p></o:p></b></span></p><p class=3DMsoNormal><b>=
<span style=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";colo=
r:#444444'>office </span></b><span style=3D'font-size:8.0pt;font-family:"Tr=
ebuchet MS","sans-serif";color:#444444'>+972 97698789<b>,&nbsp; fax </b>+97=
2 97698889<b><o:p></o:p></b></span></p><p class=3DMsoNormal><span style=3D'=
font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>Dell=
 IDC. 4 Hacharoshet St, Raanana 43657, Israel</span><span style=3D'color:#1=
F497D'><o:p></o:p></span></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p></di=
v></body></html>=

--_000_D8C50530D6022F40A817A35C40CC06A7064B308482DUBX7MCDUB01E_--


--===============8464578507904169998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8464578507904169998==--
