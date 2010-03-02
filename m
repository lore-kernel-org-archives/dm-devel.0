From: heinzm@sourceware.org
Subject: dmraid/lib Makefile.in register/dmreg.c
Date: 2 Mar 2010 15:27:39 -0000
Message-ID: <20100302152739.7163.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-02 15:27:38

Modified files:
	lib            : Makefile.in 
	lib/register   : dmreg.c 

Log message:
	Explicitely link libdmraid-events-isw.so to libpthread

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/register/dmreg.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/lib/Makefile.in	2009/09/16 11:51:32	1.4
+++ dmraid/lib/Makefile.in	2010/03/02 15:27:38	1.5
@@ -72,7 +72,7 @@
 	@echo $(TARGETS) $(INSTALL_TARGETS)
 
 $(LIB_EVENTS_SHARED):
-	$(CC) events/$(LIB_EVENTS_NAME).c $(INCLUDES) $(CFLAGS) $(LDFLAGS) -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) -o $@ -ldevmapper -ldevmapper-event $(LIB_SHARED)
+	$(CC) events/$(LIB_EVENTS_NAME).c $(INCLUDES) $(CFLAGS) $(LDFLAGS) -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) -o $@ -ldevmapper -ldevmapper-event $(LIB_SHARED) -lpthread
 
 .PHONY: install_dmraid_libs remove_dmraid_libs
 
--- dmraid/lib/register/dmreg.c	2009/09/16 11:45:17	1.1
+++ dmraid/lib/register/dmreg.c	2010/03/02 15:27:38	1.2
@@ -475,7 +475,7 @@
 		printf("ERROR: device \"%s\" %s\n", dev_name,
 		       pending ?
 		       "has a registration event pending and "
-		       "cannot be unregistered until completed":
+		       "cannot be unregistered until completed" :
 		       "is not currently being monitored");
 		return 1;
 	}
