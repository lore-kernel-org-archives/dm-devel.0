From: heinzm@sourceware.org
Subject: dmraid/lib/format/ataraid jm.c
Date: 17 Sep 2009 09:21:08 -0000
Message-ID: <20090917092108.25224.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-09-17 09:21:07

Modified files:
	lib/format/ataraid: jm.c 

Log message:
	JMicron name termination fix

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/format/ataraid/jm.c	2008/06/20 21:52:17	1.4
+++ dmraid/lib/format/ataraid/jm.c	2009/09/17 09:21:07	1.5
@@ -25,18 +25,18 @@
 static char *
 name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
-	int i;
-	size_t len;
+	size_t i, len;
 	struct jm *jm = META(rd, jm);
-	char buf[JM_NAME_LEN + 1], *ret, *name = (char *) jm->name;
+	char *ret, *name = (char *) jm->name;
+	char buf[JM_NAME_LEN + 1] = { '\0' };
 
-	/* Name always 0 terminated or whitespace at end ? */
+	/* Sanitize name, make sure it's null terminated */
 	strncpy(buf, name, JM_NAME_LEN);
-	len = strlen(buf);
-	i = len < JM_NAME_LEN ? len : JM_NAME_LEN;
-	buf[i] = 0;
-	while (i-- && isspace(buf[i]))
-		buf[i] = 0;
+	while (i && isspace(buf[i])) {
+		name[i]='\0';
+		buf[i]='\0';
+		--i;
+	}
 
 	len = strlen(buf) + sizeof(HANDLER) + (jm->mode == JM_T_RAID01 ? 3 : 2);
 	if ((ret = dbg_malloc(len))) {
