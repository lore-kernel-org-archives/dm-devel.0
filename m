From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/dict.c libmultipa ...
Date: 18 Mar 2011 19:50:42 -0000
Message-ID: <20110318195042.15638.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-03-18 19:50:41

Modified files:
	libmultipath   : dict.c parser.c 
	multipath      : multipath.conf.redhat 

Log message:
	Fix for bz#675369. Multipath now uses set_value to get the value in all the
	handler functions, and set_value now makes sure that there is value for the
	option before trying to get its length.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.17&r2=1.17.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.3&r2=1.18.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.7&r2=1.6.2.8

--- multipath-tools/libmultipath/dict.c	2011/02/18 18:27:00	1.17.2.17
+++ multipath-tools/libmultipath/dict.c	2011/03/18 19:50:40	1.17.2.18
@@ -27,10 +27,13 @@
 {
 	char * buff;
 
-	buff = VECTOR_SLOT(strvec, 1);
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	conf->checkint = atoi(buff);
 	conf->max_checkint = MAX_CHECKINT(conf->checkint);
 
+	FREE(buff);
 	return 0;
 }
 
@@ -40,6 +43,8 @@
 	char * buff;
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	if (strlen(buff) == 3 && !strcmp(buff, "off"))
 		conf->fast_io_fail = -1;
 	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
@@ -56,6 +61,8 @@
 	char * buff;
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	if (sscanf(buff, "%u", &conf->dev_loss) != 1)
 		conf->dev_loss = 0;
 
@@ -68,9 +75,12 @@
 {
 	char * buff;
 
-	buff = VECTOR_SLOT(strvec, 1);
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	conf->verbosity = atoi(buff);
 
+	FREE(buff);
 	return 0;
 }
 
@@ -306,6 +316,8 @@
 	char * buff;
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 
 	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
 		conf->pgfailback = -FAILBACK_MANUAL;
@@ -729,6 +741,8 @@
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	if (strlen(buff) == 3 && !strcmp(buff, "off"))
 		hwe->fast_io_fail = -1;
 	else if (sscanf(buff, "%d", &hwe->fast_io_fail) != 1 ||
@@ -746,6 +760,8 @@
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 	if (sscanf(buff, "%u", &hwe->dev_loss) != 1)
 		hwe->dev_loss = 0;
 
@@ -883,7 +899,8 @@
 		return 1;
 
 	buff = set_value(strvec);
-
+	if (!buff)
+		return 1;
 	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
 		hwe->pgfailback = -FAILBACK_MANUAL;
 	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
@@ -1155,7 +1172,8 @@
 		return 1;
 
 	buff = set_value(strvec);
-
+	if (!buff)
+		return 1;
 	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
 		mpe->pgfailback = -FAILBACK_MANUAL;
 	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
--- multipath-tools/libmultipath/parser.c	2011/03/07 05:19:38	1.18.2.3
+++ multipath-tools/libmultipath/parser.c	2011/03/18 19:50:40	1.18.2.4
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.18.2.3 2011/03/07 05:19:38 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.18.2.4 2011/03/18 19:50:40 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -374,13 +374,17 @@
 void *
 set_value(vector strvec)
 {
-	char *str = VECTOR_SLOT(strvec, 1);
-	int size = strlen(str);
+	char *str;
+	int size;
 	int i = 0;
 	int len = 0;
 	char *alloc = NULL;
 	char *tmp;
 
+	if (VECTOR_SIZE(strvec) < 2)
+		return NULL;
+	str = VECTOR_SLOT(strvec, 1);
+	size = strlen(str);
 	if (*str == '"') {
 		for (i = 2; i < VECTOR_SIZE(strvec); i++) {
 			str = VECTOR_SLOT(strvec, i);
--- multipath-tools/multipath/multipath.conf.redhat	2008/01/15 01:34:36	1.6.2.7
+++ multipath-tools/multipath/multipath.conf.redhat	2011/03/18 19:50:41	1.6.2.8
@@ -36,7 +36,7 @@
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
 #	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#	prio_callout		/bin/true
+#	prio_callout		none
 #	path_checker		readsector0
 #	rr_min_io		100
 #	max_fds			8192
