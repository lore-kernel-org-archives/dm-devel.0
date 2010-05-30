From: zkabelac@sourceware.org
Subject: dmraid/tools version.h.in
Date: 30 May 2010 19:10:16 -0000
Message-ID: <20100530191016.12650.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-05-30 19:10:15

Modified files:
	tools          : version.h.in 

Log message:
	Update to use new substituted variables from configure

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/version.h.in.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/tools/version.h.in	2008/02/22 16:57:37	1.1
+++ dmraid/tools/version.h.in	2010/05/30 19:10:15	1.2
@@ -1,3 +1,4 @@
 #ifndef	DMRAID_VERSION
-#define	DMRAID_VERSION	"@DMRAID_VERSION@ @FLAVOUR@"
+#define	DMRAID_VERSION	"@DMRAID_LIB_MAJOR@.@DMRAID_LIB_MINOR@.@DMRAID_LIB_SUBMINOR@." \
+			"@DMRAID_LIB_SUFFIX@ @DMRAID_LIB_DATE@ @FLAVOUR@"
 #endif
