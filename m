From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/5] multipath-tools: install libraries to /lib64
	where appriopriate
Date: Mon, 3 Aug 2009 17:02:29 -0500
Message-ID: <20090803220229.GU15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Multipath currently installs all of it's libraries to /lib, even on 64-bit
machines with a /lib64 directory.  With this patch, multipath will install
the libraries under /lib64 if it exists.  This can be overridden by running
# make LIB=<lib>

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc            |   14 +++++++++++---
 libmultipath/defaults.h |    2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: multipath-tools/libmultipath/defaults.h
===================================================================
--- multipath-tools.orig/libmultipath/defaults.h
+++ multipath-tools/libmultipath/defaults.h
@@ -1,6 +1,6 @@
 #define DEFAULT_GETUID		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #define DEFAULT_UDEVDIR		"/dev"
-#define DEFAULT_MULTIPATHDIR	"/lib/multipath"
+#define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"round-robin 0"
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
Index: multipath-tools/Makefile.inc
===================================================================
--- multipath-tools.orig/Makefile.inc
+++ multipath-tools/Makefile.inc
@@ -13,6 +13,14 @@ ifeq ($(TOPDIR),)
 	TOPDIR	= ..
 endif
 
+ifndef LIB
+	ifeq ($(shell test -d /lib64 && echo 1),1)
+		LIB=lib64
+	else
+		LIB=lib
+	endif
+endif
+
 prefix      = 
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
@@ -21,14 +29,14 @@ multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
 rcdir	    = $(prefix)/etc/init.d
-syslibdir   = $(prefix)/lib
-libdir	    = $(prefix)/lib/multipath
+syslibdir   = $(prefix)/$(LIB)
+libdir	    = $(prefix)/$(LIB)/multipath
 
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
 
 OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes
-CFLAGS	     = $(OPTFLAGS) -fPIC
+CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
 SHARED_FLAGS = -shared
 
 %.o:	%.c
