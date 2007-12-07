From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath parser.c
Date: 7 Dec 2007 23:57:05 -0000
Message-ID: <20071207235705.5597.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-12-07 23:57:05

Modified files:
	libmultipath   : parser.c 

Log message:
	Fix for bz335021. Multipath not ignores nonascii characters in
	/etc/multipath.conf

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18&r2=1.18.2.1

--- multipath-tools/libmultipath/parser.c	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/parser.c	2007/12/07 23:57:03	1.18.2.1
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.18 2006/06/06 18:32:43 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.18.2.1 2007/12/07 23:57:03 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -203,7 +203,7 @@
 	cp = string;
 
 	/* Skip white spaces */
-	while (isspace((int) *cp) && *cp != '\0')
+	while ((isspace((int) *cp) || !isascii((int) *cp)) && *cp != '\0')
 		cp++;
 
 	/* Return if there is only white spaces */
@@ -241,8 +241,10 @@
 				in_string = 1;
 
 		} else {
-			while ((in_string || !isspace((int) *cp)) && *cp
-				!= '\0' && *cp != '"')
+			while ((in_string ||
+				(!isspace((int) *cp) && isascii((int) *cp) &&
+				 *cp != '!' && *cp != '#')) &&
+			       *cp != '\0' && *cp != '"')
 				cp++;
 			strlen = cp - start;
 			token = MALLOC(strlen + 1);
@@ -255,7 +257,8 @@
 		}
 		vector_set_slot(strvec, token);
 
-		while (isspace((int) *cp) && *cp != '\0')
+		while ((isspace((int) *cp) || !isascii((int) *cp))
+		       && *cp != '\0')
 			cp++;
 		if (*cp == '\0' || *cp == '!' || *cp == '#')
 			return strvec;
