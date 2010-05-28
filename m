From: zkabelac@sourceware.org
Subject: dmraid/lib Makefile.in
Date: 28 May 2010 08:46:05 -0000
Message-ID: <20100528084605.12939.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 08:46:04

Modified files:
	lib            : Makefile.in 

Log message:
	Use SOURCES2 for dmraid plugin
	OBJECTS is created by make.tmpl.in

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/lib/Makefile.in	2010/05/27 19:47:49	1.9
+++ dmraid/lib/Makefile.in	2010/05/28 08:46:04	1.10
@@ -52,7 +52,7 @@
 LIBS += -ldl
 endif
 
-OBJECTS=$(SOURCES:%.c=%.o)
+SOURCES2 = events/$(LIB_EVENTS_NAME).c
 
 LIB_STATIC=$(top_builddir)/lib/libdmraid.a
 LIB_EVENTS_NAME=libdmraid-events-isw
@@ -74,8 +74,8 @@
 all: $(TARGETS)
 	@echo $(TARGETS) $(INSTALL_TARGETS)
 
-$(LIB_EVENTS_SHARED):
-	$(CC) -o $@ $(INCLUDES) $(CFLAGS) $(LDFLAGS) events/$(LIB_EVENTS_NAME).c \
+$(LIB_EVENTS_SHARED): $(OBJECTS2)
+	$(CC) -o $@ $(INCLUDES) $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
 	  -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
 	  $(LIB_SHARED) -ldevmapper-event -lpthread
 
