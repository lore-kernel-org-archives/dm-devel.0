From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath callout.c
Date: 24 Oct 2011 13:39:56 -0000
Message-ID: <20111024133956.31687.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-24 13:39:56

Modified files:
	libmultipath   : callout.c 

Log message:
	Fix for bz #729478. Add a new callout format parameter %c, that converts the "!"
	in cciss device names to "/".

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/callout.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3

--- multipath-tools/libmultipath/callout.c	2009/05/15 21:01:26	1.5.2.2
+++ multipath-tools/libmultipath/callout.c	2011/10/24 13:39:56	1.5.2.3
@@ -133,6 +133,19 @@
 	return retval;
 }
 
+void
+convert_cciss(char *dest, char *src)
+{
+	char *ptr;
+
+	strcpy(dest, src);
+	if (strncmp(src, "cciss", 5))
+		return;
+	ptr = strrchr(dest, '!');
+	if (ptr)
+		*ptr = '/';
+}
+
 extern int
 apply_format (char * string, char * cmd, struct path * pp)
 {
@@ -141,6 +154,7 @@
 	char * p;
 	int len;
 	int myfree;
+	char converted_dev[FILE_NAME_SIZE];
 
 	if (!string)
 		return 1;
@@ -179,6 +193,17 @@
 		snprintf(p, len, "%s", pp->dev);
 		p += len - 1;
 		break;
+	case 'c':
+		convert_cciss(converted_dev, pp->dev);
+		len = strlen(converted_dev) + 1;
+		myfree -= len;
+
+		if (myfree < 2)
+			return 1;
+
+		snprintf(p, len, "%s", converted_dev);
+		p += len - 1;
+		break;
 	case 'd':
 		len = strlen(pp->dev_t) + 1;
 		myfree -= len;
