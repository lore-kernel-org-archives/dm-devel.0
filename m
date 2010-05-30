From: zkabelac@sourceware.org
Subject: dmraid tools/Makefile.in include/config.h.in
Date: 30 May 2010 22:27:50 -0000
Message-ID: <20100530222750.24122.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 22:27:50

Modified files:
	tools          : Makefile.in 
	include        : config.h.in 

Log message:
	Use DEVMAPPEREVENT_CFLAGS
	Remove VPATH
	Do not link devmapper here - it's already part of dmraid library

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/config.h.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/tools/Makefile.in	2010/05/30 17:39:02	1.11
+++ dmraid/tools/Makefile.in	2010/05/30 22:27:49	1.12
@@ -7,7 +7,6 @@
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
 top_builddir = @top_builddir@
-VPATH = @srcdir@
 DIETLIBC = @DIETLIBC@
 KLIBC = @KLIBC@
 
@@ -34,6 +33,7 @@
 include $(top_builddir)/make.tmpl
 
 DMRAIDLIBS=-ldmraid
+INCLUDES += $(DEVMAPPEREVENT_CFLAGS)
 
 # FIXME: use pkg-config here to get the list of needed librarie
 #  pkg-config --libs  devmapper
@@ -46,10 +46,10 @@
 			DMEVENTTOOLLIBS = -ldevmapper-event_dietc
 		endif
 	else
-		DMRAIDLIBS += -ldevmapper
-		ifeq ("@STATIC_LINK@", "no")
-			DMEVENTTOOLLIBS = -ldevmapper-event
-		endif
+#		DMRAIDLIBS += -ldevmapper
+#		ifeq ("@STATIC_LINK@", "no")
+#			DMEVENTTOOLLIBS = -ldevmapper-event
+#		endif
 	endif
 
 #	DMRAIDLIBS += -lselinux
--- dmraid/include/config.h.in	2010/05/30 19:15:26	1.3
+++ dmraid/include/config.h.in	2010/05/30 22:27:49	1.4
@@ -184,8 +184,43 @@
 /* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
 #undef TIME_WITH_SYS_TIME
 
-/* Define to 1 if you want compile with large file. */
-#undef _LARGEFILE64_SOURCE
+/* Enable extensions on AIX 3, Interix.  */
+#ifndef _ALL_SOURCE
+# undef _ALL_SOURCE
+#endif
+/* Enable GNU extensions on systems that have them.  */
+#ifndef _GNU_SOURCE
+# undef _GNU_SOURCE
+#endif
+/* Enable threading extensions on Solaris.  */
+#ifndef _POSIX_PTHREAD_SEMANTICS
+# undef _POSIX_PTHREAD_SEMANTICS
+#endif
+/* Enable extensions on HP NonStop.  */
+#ifndef _TANDEM_SOURCE
+# undef _TANDEM_SOURCE
+#endif
+/* Enable general extensions on Solaris.  */
+#ifndef __EXTENSIONS__
+# undef __EXTENSIONS__
+#endif
+
+
+/* Number of bits in a file offset, on hosts where this is settable. */
+#undef _FILE_OFFSET_BITS
+
+/* Define for large files, on AIX-style hosts. */
+#undef _LARGE_FILES
+
+/* Define to 1 if on MINIX. */
+#undef _MINIX
+
+/* Define to 2 if the system does not provide POSIX.1 features except with
+   this defined. */
+#undef _POSIX_1_SOURCE
+
+/* Define to 1 if you need to in order for `stat' and other things to work. */
+#undef _POSIX_SOURCE
 
 /* Define for Solaris 2.5.1 so the uint32_t typedef from <sys/synch.h>,
    <pthread.h>, or <semaphore.h> is not used. If the typedef were allowed, the
