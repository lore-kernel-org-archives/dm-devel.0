From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath parser.c
Date: 12 Oct 2007 17:18:15 -0000
Message-ID: <20071012171815.23921.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-10-12 17:18:14

Modified files:
	libmultipath   : parser.c 

Log message:
	Oops. Missed a spot with the ascii checking.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.1&r2=1.17.2.2

--- multipath-tools/libmultipath/parser.c	2007/10/11 20:17:17	1.17.2.1
+++ multipath-tools/libmultipath/parser.c	2007/10/12 17:18:14	1.17.2.2
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.17.2.1 2007/10/11 20:17:17 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.17.2.2 2007/10/12 17:18:14 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -157,8 +157,10 @@
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
