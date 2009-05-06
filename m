From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_alua Makefile ...
Date: 6 May 2009 22:57:58 -0000
Message-ID: <20090506225758.26249.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-05-06 22:57:58

Modified files:
	path_priority/pp_alua: Makefile rtpg.c spc3.h 

Log message:
	Fix for bz #474451
	Intel wanted a variant of the mpath_prio_alua method to determine priority.
	two binaries are now built out of the alua source. The intel one looks at
	the preffered port bit instead of the asymetric access state bits.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.2&r2=1.3.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/spc3.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1

--- multipath-tools/path_priority/pp_alua/Makefile	2008/02/07 22:18:46	1.5.2.3
+++ multipath-tools/path_priority/pp_alua/Makefile	2009/05/06 22:57:57	1.5.2.4
@@ -12,11 +12,12 @@
 #
 # This file is released under the GPL.
 #==============================================================================
-EXEC		= mpath_prio_alua
+ALUA		= mpath_prio_alua
+INTEL		= mpath_prio_intel
 BUILD		= glibc
 DEBUG		= 0
 DEBUG_DUMPHEX	= 0
-OBJS		= main.o rtpg.o
+FILES		= main.c rtpg.c
 INSTALL		= install -D
 
 TOPDIR	= ../..
@@ -29,25 +30,23 @@
 
 all: $(BUILD)
 
-glibc:	$(OBJS)
-	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
-
-klibc:	$(OBJS)
-	$(CC) -static -o $(EXEC) $(OBJS)
-
-install: $(BUILD) $(EXEC).8
-	$(INSTALL) -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
-	$(INSTALL) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/$(EXEC).8
+glibc: $(FILES)
+	$(CC) -static -o $(ALUA).static $(FILES) $(CFLAGS) -DALUA $(LDFLAGS)
+	$(CC) -static -o $(INTEL).static $(FILES) $(CFLAGS) -DINTEL $(LDFLAGS)
+
+install: $(BUILD) $(ALUA).8
+	$(INSTALL) -m 755 $(ALUA).static $(DESTDIR)$(bindir)/$(ALUA).static
+	$(INSTALL) -m 755 $(INTEL).static $(DESTDIR)$(bindir)/$(INTEL).static
+	ln -sf $(ALUA).static $(DESTDIR)$(bindir)/$(ALUA)
+	ln -sf $(INTEL).static $(DESTDIR)$(bindir)/$(INTEL)
+	$(INSTALL) -m 644 $(ALUA).8 $(DESTDIR)$(mandir)/$(ALUA).8
 
 uninstall:
-	rm $(DESTDIR)$(bindir)/$(EXEC)
-	rm $(DESTDIR)$(bindir)/$(EXEC).static
-	rm $(DESTDIR)$(mandir)/$(EXEC).8
+	rm $(DESTDIR)$(bindir)/$(ALUA)
+	rm $(DESTDIR)$(bindir)/$(ALUA).static
+	rm $(DESTDIR)$(mandir)/$(ALUA).8
+	rm $(DESTDIR)$(bindir)/$(INTEL)
+	rm $(DESTDIR)$(bindir)/$(INTEL).static
 
 clean:	
-	rm -f *.o *.gz $(EXEC).static
-
-main.o:	main.c rtpg.h spc3.h
-
-rtpg.o:	rtpg.c rtpg.h spc3.h
+	rm -f *.o *.gz $(ALUA).static $(INTEL).static
--- multipath-tools/path_priority/pp_alua/rtpg.c	2009/04/21 00:05:24	1.3.2.2
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2009/05/06 22:57:58	1.3.2.3
@@ -295,7 +295,11 @@
 					"group.\n");
 			} else {
 				PRINT_DEBUG("pref=%i\n", dscr->pref);
+#ifdef ALUA
 				rc = rtpg_tpg_dscr_get_aas(dscr);
+#else
+				rc = rtpg_tpg_dscr_get_pref(dscr);
+#endif
 			}
 		}
 	}
--- multipath-tools/path_priority/pp_alua/spc3.h	2006/06/06 18:32:44	1.3
+++ multipath-tools/path_priority/pp_alua/spc3.h	2009/05/06 22:57:58	1.3.2.1
@@ -302,6 +302,12 @@
 	return (d->b0 & 0x0f);
 }
 
+static inline int
+rtpg_tpg_dscr_get_pref(struct rtpg_tpg_dscr *d)
+{
+	return ((d->b0 & 0x80)?0:2);
+}
+
 struct rtpg_data {
 	unsigned char			length[4];		/* size-4 */
 	struct rtpg_tpg_dscr		data[0];
