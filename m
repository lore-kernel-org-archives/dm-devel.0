From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_tpc Makefile
Date: 6 May 2008 21:44:04 -0000
Message-ID: <20080506214404.11870.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-05-06 21:44:04

Modified files:
	path_priority/pp_tpc: Makefile 

Log message:
	compile pp_tpc with debugging.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1.4.1&r2=1.1.4.2

--- multipath-tools/path_priority/pp_tpc/Makefile	2007/07/23 21:37:10	1.1.4.1
+++ multipath-tools/path_priority/pp_tpc/Makefile	2008/05/06 21:44:04	1.1.4.2
@@ -5,6 +5,8 @@
 TOPDIR		= ../..
 include $(TOPDIR)/Makefile.inc
 
+CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
+
 all: $(BUILD)
 
 glibc:	$(OBJS)
@@ -20,3 +22,6 @@
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 clean:	
 	rm -f *.o $(EXEC)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
