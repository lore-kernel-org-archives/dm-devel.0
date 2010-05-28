From: zkabelac@sourceware.org
Subject: dmraid/tools Makefile.in
Date: 28 May 2010 08:37:37 -0000
Message-ID: <20100528083737.9570.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 08:37:37

Modified files:
	tools          : Makefile.in 

Log message:
	Use SOURCES2 for dmevent_tool compilation

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/tools/Makefile.in	2010/05/27 19:50:28	1.9
+++ dmraid/tools/Makefile.in	2010/05/28 08:37:37	1.10
@@ -18,6 +18,9 @@
 	commands.c \
 	toollib.c
 
+SOURCES2=\
+	dmevent_tool.c
+
 TARGETS=\
 	dmraid
 
@@ -68,8 +71,8 @@
 dmraid:	$(OBJECTS) $(top_builddir)/lib/libdmraid.a
 	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_builddir)/lib $(DMRAIDLIBS) $(LIBS)
 
-dmevent_tool: $(top_builddir)/lib/libdmraid.a
-	$(CC) -o $@ $@.c $(INCLUDES) $(LDFLAGS) -L$(top_builddir)/lib \
+dmevent_tool: $(OBJECTS2) $(top_builddir)/lib/libdmraid.a
+	$(CC) -o $@ $(OBJECTS2) $(INCLUDES) $(LDFLAGS) -L$(top_builddir)/lib \
 	  $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(LIBS)
 
 install_dmraid_tools: $(TARGETS)
