From: "T S, Veena (STSD)" <veena-s.t@hp.com>
Subject: [patch] mpath_prio_pp
Date: Wed, 5 Dec 2007 08:55:54 +0530
Message-ID: <4640E676B7B93749BC82C75D50E500FB0570FBF4@BGEEXC07.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0754971027=="
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

--===============0754971027==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C836EE.8BAFEDE7"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C836EE.8BAFEDE7
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi,

Below is the patch for the implementation of preferred path feature in
the device mapper.
Preferred path feature allows the selection of a particular path for a
LUN, by making proper priority assignments.
mpath_prio_pp is a callout routine for the same.Let me know your
comments.

Thanks,
Veena



diff -pNaur multipath-tools-0.4.8/libmultipath/config.h
multipath-tools-0.4.8.new/libmultipath/config.h
--- multipath-tools-0.4.8/libmultipath/config.h	2007-08-03
02:35:37.000000000 +0530
+++ multipath-tools-0.4.8.new/libmultipath/config.h	2007-11-30
12:40:33.000000000 +0530
@@ -37,6 +37,7 @@ struct mpentry {
 	char * alias;
 	char * getuid;
 	char * selector;
+	char * getprio;
=20
 	int pgpolicy;
 	int pgfailback;
diff -pNaur multipath-tools-0.4.8/libmultipath/dict.c
multipath-tools-0.4.8.new/libmultipath/dict.c
--- multipath-tools-0.4.8/libmultipath/dict.c	2007-08-03
02:35:37.000000000 +0530
+++ multipath-tools-0.4.8.new/libmultipath/dict.c	2007-11-30
12:13:46.000000000 +0530
@@ -933,9 +933,31 @@ mp_pg_timeout_handler(vector strvec)
 	return 0;
 }
=20
+static int
+mp_prio_callout_handler(vector strvec)
+{
+         struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf->mptable);
+
+         if(!mpe)
+                return 1;
+
+         mpe->getprio =3D set_value(strvec);
+
+         if(!mpe->getprio)
+                return 1;
+
+         if (strlen(mpe->getprio) =3D=3D 4 && !strcmp(mpe->getprio,
"none")) {
+                FREE(mpe->getprio);
+                mpe->getprio =3D NULL;
+         }
+
+         return 0;
+}
+
 /*
  * config file keywords printing
  */
+
 static int
 snprint_mp_wwid (char * buff, int len, void * data)
 {
@@ -1068,6 +1090,17 @@ snprint_mp_pg_timeout (char * buff, int=20
 }
=20
 static int
+snprint_mp_prio_callout(char * buff, int len, void * data)
+{
+        struct mpentry * mpe =3D (struct mpentry *)data;
+
+        if (!mpe->getprio)
+                return 0;
+
+        return snprintf(buff, len, "%s", mpe->getprio);
+}
+
+static int
 snprint_hw_vendor (char * buff, int len, void * data)
 {
 	struct hwentry * hwe =3D (struct hwentry *)data;
@@ -1594,6 +1627,7 @@ init_keywords(void)
 	install_keyword("alias", &alias_handler, &snprint_mp_alias);
 	install_keyword("path_grouping_policy", &mp_pgpolicy_handler,
&snprint_mp_path_grouping_policy);
 	install_keyword("path_selector", &mp_selector_handler,
&snprint_mp_selector);
+	install_keyword("prio_callout", &mp_prio_callout_handler,
&snprint_mp_prio_callout);
 	install_keyword("failback", &mp_failback_handler,
&snprint_mp_failback);
 	install_keyword("rr_weight", &mp_weight_handler,
&snprint_mp_rr_weight);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler,
&snprint_mp_no_path_retry);
diff -pNaur multipath-tools-0.4.8/libmultipath/discovery.c
multipath-tools-0.4.8.new/libmultipath/discovery.c
--- multipath-tools-0.4.8/libmultipath/discovery.c	2007-08-03
02:35:37.000000000 +0530
+++ multipath-tools-0.4.8.new/libmultipath/discovery.c	2007-11-30
12:18:21.000000000 +0530
@@ -709,8 +709,11 @@ pathinfo (struct path *pp, vector hwtabl
 	  * been successfully obtained before.
 	  */
 	if (mask & DI_PRIO &&
-	    (pp->state !=3D PATH_DOWN || pp->priority =3D=3D PRIO_UNDEF))
+	    (pp->state !=3D PATH_DOWN || pp->priority =3D=3D PRIO_UNDEF)) {
+		if( !strlen(pp->wwid))
+                        get_uid(pp);
 		get_prio(pp);
+	}
=20
 	if (mask & DI_WWID && !strlen(pp->wwid))
 		get_uid(pp);
diff -pNaur multipath-tools-0.4.8/libmultipath/propsel.c
multipath-tools-0.4.8.new/libmultipath/propsel.c
--- multipath-tools-0.4.8/libmultipath/propsel.c	2007-08-03
02:35:37.000000000 +0530
+++ multipath-tools-0.4.8.new/libmultipath/propsel.c	2007-11-30
12:45:21.000000000 +0530
@@ -258,7 +258,16 @@ select_getuid (struct path * pp)
=20
 extern int
 select_getprio (struct path * pp)
-{
+{=09
+	struct mpentry * mpe;
+        if (mpe =3D find_mpe(pp->wwid)) {
+                if (mpe->getprio) {
+                        pp->getprio =3D mpe->getprio;
+                        condlog(3, "%s: getprio =3D %s (LUN setting)",
pp->dev, pp->getprio);
+                        return 0;
+                }
+        }
+
 	if (pp->hwe && pp->hwe->getprio) {
 		pp->getprio =3D pp->hwe->getprio;
 		condlog(3, "%s: getprio =3D %s (controller setting)",
diff -pNaur multipath-tools-0.4.8/path_priority/pp_pref_path/Makefile
multipath-tools-0.4.8.new/path_priority/pp_pref_path/Makefile
--- multipath-tools-0.4.8/path_priority/pp_pref_path/Makefile
1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools-0.4.8.new/path_priority/pp_pref_path/Makefile
2007-11-30 11:47:21.000000000 +0530
@@ -0,0 +1,25 @@
+EXEC		=3D mpath_prio_pp
+BUILD		=3D glibc
+OBJS		=3D mpath_prio_pp.o
+
+TOPDIR		=3D ../..
+include $(TOPDIR)/Makefile.inc
+
+all: $(BUILD)
+
+glibc:	$(OBJS)
+	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+
+klibc:	$(OBJS)
+	$(CC) -static -o $(EXEC) $(OBJS)
+
+install: $(EXEC)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:=09
+	rm -f *.o $(EXEC)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
diff -pNaur
multipath-tools-0.4.8/path_priority/pp_pref_path/mpath_prio_pp.c
multipath-tools-0.4.8.new/path_priority/pp_pref_path/mpath_prio_pp.c
--- multipath-tools-0.4.8/path_priority/pp_pref_path/mpath_prio_pp.c
1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools-0.4.8.new/path_priority/pp_pref_path/mpath_prio_pp.c
2007-12-04 16:54:21.000000000 +0530
@@ -0,0 +1,67 @@
+ /*
+
************************************************************************
*****
+ *
*
+ *     (C)  Copyright 2007 Hewlett-Packard Development Company, L.P
*
+ *
*
+ * This program is free software; you can redistribute it and/or modify
it   *
+ * under the terms of the GNU General Public License as published by
the Free*
+ * Software  Foundation; either version 2 of the License, or (at your
option)*
+ * any later version.
*
+ *
*
+ * This program is distributed in the hope that it will be useful, but
*
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY*
+ * or FITNESS FOR  A PARTICULAR PURPOSE. See the GNU General Public
License  *
+ * for more details.
*
+ *
*
+ * You should have received a copy of the GNU General Public License
along   *
+ * with this program; if not, write to the Free Software Foundation,
Inc.,   *
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
*
+ *
*
+ * The copy of the GNU General Public License is available at
*
+ * /opt/hp/HPDMmultipath-tool directoy
*
+ *
*
+
************************************************************************
*****
+ */
+
+/*
+ * Prioritizer for device mapper,when a path instance is provided as
the
+ * preferred path.
+
+ * This prioritizer assigns a priority value based on the comparison
made
+ * between the preferred path and the path instance for which this is
called.
+ * A priority value of 1 is assigned to the preferred path and 0 to the
other
+ * non-preferred paths.
+
+ * Returns zero on successful assignment of priority and -1 on failure.
+ * Failure to assign priority can be caused due to invalid pathname or
a missing * argument.
+ */
+
+#include<stdio.h>
+#include<string.h>
+#define HIGH 1
+#define LOW 0
+#define FILE_NAME_SIZE 256
+
+int main(int argc, char * argv[])
+{
+
+	char path[FILE_NAME_SIZE];
+=09
+	if(argv[1] && argv[2])
+	{
+		if(!strncmp(argv[2],"/dev/",5))
+			strcpy(path,argv[2]+5);
+
+		if(!strcmp(path,argv[1]) || !strcmp(argv[1],argv[2]))
+		{
+			printf("%u\n", HIGH);
+			return 0;
+		}
+		else
+		{
+			printf("%u\n", LOW);
+			return 0;
+		}
+	}
+	return -1;
+}

------_=_NextPart_001_01C836EE.8BAFEDE7
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
<TITLE>[patch] mpath_prio_pp</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">Below is the patch =
for the implementation of preferred path feature in the device =
mapper.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">Preferred path =
feature allows the selection of a particular path for a LUN, by making =
proper priority assignments.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">mpath_prio_pp is =
a callout routine for the same.Let me know your comments.</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Thanks,</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Veena</FONT></SPAN>
</P>
<BR>
<BR>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/libmultipath/config.h =
multipath-tools-0.4.8.new/libmultipath/config.h</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/libmultipath/config.h 2007-08-03 =
02:35:37.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp; =
2007-11-30 12:40:33.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -37,6 +37,7 @@ =
struct mpentry {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * =
alias;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * =
getuid;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * =
selector;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * =
getprio;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int =
pgpolicy;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int =
pgfailback;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/libmultipath/dict.c =
multipath-tools-0.4.8.new/libmultipath/dict.c</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/libmultipath/dict.c&nbsp;&nbsp; 2007-08-03 =
02:35:37.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 2007-11-30 12:13:46.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -933,9 +933,31 =
@@ mp_pg_timeout_handler(vector strvec)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+static =
int</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+mp_prio_callout_handler(vector strvec)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
mpentry * mpe =3D VECTOR_LAST_SLOT(conf-&gt;mptable);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
if(!mpe)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 1;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
mpe-&gt;getprio =3D set_value(strvec);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
if(!mpe-&gt;getprio)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 1;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(strlen(mpe-&gt;getprio) =3D=3D 4 &amp;&amp; !strcmp(mpe-&gt;getprio, =
&quot;none&quot;)) {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FREE(mpe-&gt;getprio);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpe-&gt;getprio =3D =
NULL;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;/*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; * config =
file keywords printing</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; =
*/</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;static =
int</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;snprint_mp_wwid (char * buff, int len, void * =
data)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -1068,6 =
+1090,17 @@ snprint_mp_pg_timeout (char * buff, int </FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;static =
int</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+snprint_mp_prio_callout(char * buff, int len, void * =
data)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
mpentry * mpe =3D (struct mpentry *)data;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(!mpe-&gt;getprio)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
snprintf(buff, len, &quot;%s&quot;, mpe-&gt;getprio);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+static =
int</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;snprint_hw_vendor (char * buff, int len, void * =
data)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct hwentry =
* hwe =3D (struct hwentry *)data;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -1594,6 =
+1627,7 @@ init_keywords(void)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;alias&quot;, &amp;alias_handler, =
&amp;snprint_mp_alias);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;path_grouping_policy&quot;, =
&amp;mp_pgpolicy_handler, =
&amp;snprint_mp_path_grouping_policy);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;path_selector&quot;, &amp;mp_selector_handler, =
&amp;snprint_mp_selector);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;prio_callout&quot;, &amp;mp_prio_callout_handler, =
&amp;snprint_mp_prio_callout);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;failback&quot;, &amp;mp_failback_handler, =
&amp;snprint_mp_failback);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;rr_weight&quot;, &amp;mp_weight_handler, =
&amp;snprint_mp_rr_weight);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
install_keyword(&quot;no_path_retry&quot;, =
&amp;mp_no_path_retry_handler, =
&amp;snprint_mp_no_path_retry);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/libmultipath/discovery.c =
multipath-tools-0.4.8.new/libmultipath/discovery.c</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/libmultipath/discovery.c&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; 2007-08-03 02:35:37.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/libmultipath/discovery.c&nbsp; 2007-11-30 =
12:18:21.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -709,8 +709,11 =
@@ pathinfo (struct path *pp, vector hwtabl</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; * been =
successfully obtained before.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; =
*/</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (mask &amp; =
DI_PRIO &amp;&amp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
(pp-&gt;state !=3D PATH_DOWN || pp-&gt;priority =3D=3D =
PRIO_UNDEF))</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
(pp-&gt;state !=3D PATH_DOWN || pp-&gt;priority =3D=3D PRIO_UNDEF)) =
{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if( =
!strlen(pp-&gt;wwid))</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; get_uid(pp);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; get_prio(pp);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (mask &amp; =
DI_WWID &amp;&amp; !strlen(pp-&gt;wwid))</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; get_uid(pp);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/libmultipath/propsel.c =
multipath-tools-0.4.8.new/libmultipath/propsel.c</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; 2007-08-03 02:35:37.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/libmultipath/propsel.c&nbsp;&nbsp;&nbsp; =
2007-11-30 12:45:21.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -258,7 +258,16 =
@@ select_getuid (struct path * pp)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;extern =
int</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;select_getprio (struct path * pp)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">-{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mpentry * =
mpe;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (mpe =3D =
find_mpe(pp-&gt;wwid)) {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (mpe-&gt;getprio) {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; pp-&gt;getprio =3D mpe-&gt;getprio;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; condlog(3, &quot;%s: getprio =3D %s (LUN setting)&quot;, =
pp-&gt;dev, pp-&gt;getprio);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; return 0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;hwe =
&amp;&amp; pp-&gt;hwe-&gt;getprio) {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;getprio =3D =
pp-&gt;hwe-&gt;getprio;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: getprio =
=3D %s (controller setting)&quot;,</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/path_priority/pp_pref_path/Makefile =
multipath-tools-0.4.8.new/path_priority/pp_pref_path/Makefile</FONT></SPA=
N></P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/path_priority/pp_pref_path/Makefile&nbsp;&nbsp; =
1970-01-01 05:30:00.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/path_priority/pp_pref_path/Makefile&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; 2007-11-30 11:47:21.000000000 =
+0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -0,0 +1,25 =
@@</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+EXEC&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
mpath_prio_pp</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+BUILD&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D glibc</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+OBJS&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
mpath_prio_pp.o</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+TOPDIR =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D ../..</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+include =
$(TOPDIR)/Makefile.inc</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+all: =
$(BUILD)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+glibc: =
$(OBJS)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(CC) -o $(EXEC) =
$(OBJS) $(LDFLAGS)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+klibc: =
$(OBJS)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(CC) -static -o =
$(EXEC) $(OBJS)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+install: =
$(EXEC)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install -m 755 =
$(EXEC) $(DESTDIR)$(bindir)/$(EXEC)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+uninstall:</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rm =
$(DESTDIR)$(bindir)/$(EXEC)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+clean: =
</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rm -f *.o =
$(EXEC)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+%.o:&nbsp;&nbsp; =
%.c</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(CC) $(CFLAGS) -c =
-o $@ $&lt;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">diff -pNaur =
multipath-tools-0.4.8/path_priority/pp_pref_path/mpath_prio_pp.c =
multipath-tools-0.4.8.new/path_priority/pp_pref_path/mpath_prio_pp.c</FON=
T></SPAN></P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">--- =
multipath-tools-0.4.8/path_priority/pp_pref_path/mpath_prio_pp.c&nbsp;&nb=
sp;&nbsp; 1970-01-01 05:30:00.000000000 +0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+++ =
multipath-tools-0.4.8.new/path_priority/pp_pref_path/mpath_prio_pp.c&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2007-12-04 16:54:21.000000000 =
+0530</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">@@ -0,0 +1,67 =
@@</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
/*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*************************************************************************=
****</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp; (C)&nbsp; Copyright 2007 Hewlett-Packard =
Development Company, =
L.P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * This program =
is free software; you can redistribute it and/or modify it&nbsp;&nbsp; =
*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * under the =
terms of the GNU General Public License as published by the =
Free*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * =
Software&nbsp; Foundation; either version 2 of the License, or (at your =
option)*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * any later =
version.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * This program =
is distributed in the hope that it will be useful, =
but&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * WITHOUT ANY =
WARRANTY; without even the implied warranty of =
MERCHANTABILITY*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * or FITNESS =
FOR&nbsp; A PARTICULAR PURPOSE. See the GNU General Public License&nbsp; =
*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * for more =
details.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * You should =
have received a copy of the GNU General Public License along&nbsp;&nbsp; =
*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * with this =
program; if not, write to the Free Software Foundation, =
Inc.,&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * 675 Mass Ave, =
Cambridge, MA 02139, =
USA.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * The copy of =
the GNU General Public License is available =
at&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * =
/opt/hp/HPDMmultipath-tool =
directoy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; *</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*************************************************************************=
****</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*/</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+/*</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * Prioritizer =
for device mapper,when a path instance is provided as the</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * preferred =
path.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * This =
prioritizer assigns a priority value based on the comparison =
made</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * between the =
preferred path and the path instance for which this is =
called.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * A priority =
value of 1 is assigned to the preferred path and 0 to the =
other</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * non-preferred =
paths.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * Returns zero =
on successful assignment of priority and -1 on failure.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ * Failure to =
assign priority can be caused due to invalid pathname or a missing * =
argument.</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+ =
*/</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+#include&lt;stdio.h&gt;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+#include&lt;string.h&gt;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+#define HIGH =
1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+#define LOW =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+#define =
FILE_NAME_SIZE 256</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+int main(int =
argc, char * argv[])</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+{</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char =
path[FILE_NAME_SIZE];</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(argv[1] =
&amp;&amp; argv[2])</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
if(!strncmp(argv[2],&quot;/dev/&quot;,5))</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
strcpy(path,argv[2]+5);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(!strcmp(path,argv[1]) || =
!strcmp(argv[1],argv[2]))</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%u\n&quot;, =
HIGH);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%u\n&quot;, =
LOW);</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
-1;</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">+}</FONT></SPAN>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C836EE.8BAFEDE7--


--===============0754971027==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0754971027==--
