From: Hannes Reinecke <hare@suse.de>
Subject: [multipath-tools] Fixup Makefiles
Date: Fri, 09 Dec 2005 13:31:52 +0100
Message-ID: <43997938.8070205@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090800090103030101050305"
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
To: Christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090800090103030101050305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch cleans up the Makefiles. I've splitup CFLAGS so that you now
can specify an optimisation flags via 'OPTFLAGS' from the commandline
(overriding the default). It also cleans up the Makefiles, moving common
parts into Makefile.inc, deleting left-over tabs etc.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------090800090103030101050305
Content-Type: text/x-patch;
 name="multipath-tools-makefile-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-makefile-fixup.patch"

Makefile cleanup

Fixup CFLAGS so that it can be adjusted by setting 'OPTFLAGS'
from the commandline.
General cleanup of Makefiles; move common parts into Makefile.inc.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/Makefile.inc b/Makefile.inc
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -25,9 +25,17 @@ exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
 checkersdir = $(TOPDIR)/libcheckers
 multipathdir = $(TOPDIR)/libmultipath
-mandir      = /usr/share/man/man8
+mandir      = $(prefix)/usr/share/man/man8
+rcdir	    = $(prefix)/etc/init.d
 
 GZIP        = /bin/gzip -9 -c
 
 CHECKERSLIB = $(checkersdir)/libcheckers
 MULTIPATHLIB = $(multipathdir)/libmultipath
+
+OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes
+CFLAGS	     = $(OPTFLAGS)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
+
diff --git a/devmap_name/Makefile b/devmap_name/Makefile
--- a/devmap_name/Makefile
+++ b/devmap_name/Makefile
@@ -6,7 +6,6 @@ BUILD = glibc
 include ../Makefile.inc
 
 OBJS = devmap_name.o
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS += $(libdm)
@@ -24,7 +23,7 @@ prepare:
 glibc: prepare $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
-	
+
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
diff --git a/kpartx/Makefile b/kpartx/Makefile
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -6,7 +6,7 @@ BUILD=glibc
 
 include ../Makefile.inc
 
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes -I. -D_LARGEFILE64_SOURCE
+CFLAGS += -I. -D_LARGEFILE64_SOURCE
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -13,9 +13,7 @@ OBJS = memory.o parser.o vector.o devmap
        switchgroup.o uxsock.o print.o alias.o log_pthread.o \
        log.o configure.o structs_vec.o
 
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes
-
-PREVBUILD = $(shell nm debug.o|grep log_safe)
+PREVBUILD = $(shell nm debug.o 2> /dev/null|grep log_safe)
 
 ifeq ($(strip $(DAEMON)),1)
 	CFLAGS += -DDAEMON
diff --git a/multipath/Makefile b/multipath/Makefile
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -7,8 +7,7 @@ include ../Makefile.inc
 
 OBJS = main.o $(MULTIPATHLIB)-$(BUILD).a $(CHECKERSLIB)-$(BUILD).a
 
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes \
-	 -I$(multipathdir) -I$(checkersdir)
+CFLAGS += -I$(multipathdir) -I$(checkersdir)
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS += $(libdm) $(libsysfs)
@@ -27,7 +26,7 @@ prepare:
 glibc: prepare $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
-	
+
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
diff --git a/multipathd/Makefile b/multipathd/Makefile
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -4,17 +4,9 @@ EXEC = multipathd
 include ../Makefile.inc
 
 #
-# directories where to put stuff
-#
-bindir = /usr/bin
-mandir = /usr/share/man/man8
-rcdir = /etc/init.d
-
-#
 # basic flags setting
 #
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes \
-	 -DDAEMON -I$(multipathdir) -I$(checkersdir)
+CFLAGS += -DDAEMON -I$(multipathdir) -I$(checkersdir)
 LDFLAGS = -lpthread -ldevmapper -lsysfs -lreadline -lncurses
 
 #
diff --git a/path_priority/pp_alua/Makefile b/path_priority/pp_alua/Makefile
--- a/path_priority/pp_alua/Makefile
+++ b/path_priority/pp_alua/Makefile
@@ -24,7 +24,7 @@ ifneq ($(shell ls $(TOPDIR)/Makefile.inc
 include $(TOPDIR)/Makefile.inc
 endif
 
-CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes -DDEBUG=$(DEBUG)
+CFLAGS += -DDEBUG=$(DEBUG)
 
 all: $(BUILD)
 
@@ -45,9 +45,6 @@ uninstall:
 clean:	
 	rm -f *.o *.gz $(EXEC)
 
-%.o:	%.c
-	$(CC) $(CFLAGS) -c -o $@ $<
-
 $(EXEC).8.gz:	$(EXEC).8
 	$(GZIP) $< >$@
 
diff --git a/path_priority/pp_balance_units/Makefile b/path_priority/pp_balance_units/Makefile
--- a/path_priority/pp_balance_units/Makefile
+++ b/path_priority/pp_balance_units/Makefile
@@ -9,11 +9,10 @@ TOPDIR	= ../..
 include $(TOPDIR)/Makefile.inc
 
 ifeq ($(strip $(BUILD)),klibc)
-	CFLAGS = -I/usr/include -DDEBUG=$(DEBUG)
+	CFLAGS += -I/usr/include -DDEBUG=$(DEBUG)
 	OBJS = pp_balance_units.o $(MULTIPATHLIB)-$(BUILD).a
 else
-	CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes \
-		 -I$(multipathdir) -DDEBUG=$(DEBUG)
+	CFLAGS += -I$(multipathdir) -DDEBUG=$(DEBUG)
 	LDFLAGS = -ldevmapper
 	OBJS = pp_balance_units.o $(MULTIPATHLIB)-$(BUILD).a
 endif
@@ -27,7 +26,7 @@ prepare:
 
 glibc: prepare $(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
-	
+
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
 
diff --git a/path_priority/pp_emc/Makefile b/path_priority/pp_emc/Makefile
--- a/path_priority/pp_emc/Makefile
+++ b/path_priority/pp_emc/Makefile
@@ -5,8 +5,6 @@ OBJS		= pp_emc.o
 TOPDIR		= ../..
 include $(TOPDIR)/Makefile.inc
 
-CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
-
 all: $(BUILD)
 
 glibc:	$(OBJS)
diff --git a/path_priority/pp_netapp/Makefile b/path_priority/pp_netapp/Makefile
--- a/path_priority/pp_netapp/Makefile
+++ b/path_priority/pp_netapp/Makefile
@@ -5,8 +5,6 @@ OBJS		= pp_netapp.o
 TOPDIR		= ../..
 include $(TOPDIR)/Makefile.inc
 
-CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
-
 all: $(BUILD)
 
 glibc:	$(OBJS)
@@ -22,6 +20,3 @@ uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 clean:	
 	rm -f *.o $(EXEC)
-
-%.o:	%.c
-	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/path_priority/pp_random/Makefile b/path_priority/pp_random/Makefile
--- a/path_priority/pp_random/Makefile
+++ b/path_priority/pp_random/Makefile
@@ -5,8 +5,6 @@ OBJS		= pp_random.o
 TOPDIR		= ../..
 include $(TOPDIR)/Makefile.inc
 
-CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
-
 all: $(BUILD)
 
 glibc:	$(OBJS)
@@ -22,6 +20,3 @@ uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 clean:	
 	rm -f *.o $(EXEC)
-
-%.o:	%.c
-	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/path_priority/pp_tpc/Makefile b/path_priority/pp_tpc/Makefile
--- a/path_priority/pp_tpc/Makefile
+++ b/path_priority/pp_tpc/Makefile
@@ -5,8 +5,6 @@ OBJS		= pp_tpc.o
 TOPDIR		= ../..
 include $(TOPDIR)/Makefile.inc
 
-CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
-
 all: $(BUILD)
 
 glibc:	$(OBJS)
@@ -22,6 +20,3 @@ uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 clean:	
 	rm -f *.o $(EXEC)
-
-%.o:	%.c
-	$(CC) $(CFLAGS) -c -o $@ $<

--------------090800090103030101050305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090800090103030101050305--
