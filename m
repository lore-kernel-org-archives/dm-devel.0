From: meyering@sourceware.org
Subject: device-mapper make.tmpl.in
Date: 18 Sep 2007 14:27:34 -0000
Message-ID: <20070918142734.30074.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-09-18 14:27:34

Modified files:
	.              : make.tmpl.in 

Log message:
	Create the .so.1.02 symlink in lib/, not lib/ioctl/.
	
	Author: Jim Meyering <jim@meyering.net>

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.33&r2=1.34

--- device-mapper/make.tmpl.in	2007/09/18 13:44:28	1.33
+++ device-mapper/make.tmpl.in	2007/09/18 14:27:33	1.34
@@ -174,7 +174,7 @@
 
 $(VERSIONED_SHLIB): %.$(LIB_SUFFIX).$(LIB_VERSION): %.$(LIB_SUFFIX)
 	rm -f $@
-	$(LN_S) $(notdir $<) $@
+	$(LN_S) $< $(notdir $@)
 
 $(LIB_STATIC): $(OBJECTS)
 	$(RM) $@
