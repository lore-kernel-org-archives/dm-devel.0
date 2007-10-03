From: mbroz@sourceware.org
Subject: device-mapper make.tmpl.in
Date: 3 Oct 2007 09:00:46 -0000
Message-ID: <20071003090046.24546.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	mbroz@sourceware.org	2007-10-03 09:00:45

Modified files:
	.              : make.tmpl.in 

Log message:
	Fix build, symlink removal used old argument.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.34&r2=1.35

--- device-mapper/make.tmpl.in	2007/09/18 14:27:33	1.34
+++ device-mapper/make.tmpl.in	2007/10/03 09:00:45	1.35
@@ -173,7 +173,7 @@
 endif
 
 $(VERSIONED_SHLIB): %.$(LIB_SUFFIX).$(LIB_VERSION): %.$(LIB_SUFFIX)
-	rm -f $@
+	rm -f $(notdir $@)
 	$(LN_S) $< $(notdir $@)
 
 $(LIB_STATIC): $(OBJECTS)
