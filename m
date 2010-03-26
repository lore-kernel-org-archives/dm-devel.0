From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: move bindings file location
Date: Fri, 26 Mar 2010 17:10:24 -0500
Message-ID: <20100326221024.GJ23952@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

The current bindings file location (/var/lib/multipath/bindings) can be
problematic, since multipath can start up before /var/lib is mounted yet in
late boot.  In this case, multipath will create it's own bindings file which
will be covered up by /var when it is mounted.  This means that the device
names that you get on startup might be different from the device names that you
get when you run multipath on a system during normal operation.  Since /etc is
always available when multipath starts up in late boot, moving the bindings
file there fixes the problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 84e5d6b... 5a38d25... M	libmultipath/defaults.h
:100644 100644 9afa615... 7b6453f... M	multipath.conf.annotated
:100644 100644 a165e4e... 4340e51... M	multipath/multipath.conf.5
 libmultipath/defaults.h    |    2 +-
 multipath.conf.annotated   |    2 +-
 multipath/multipath.conf.5 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: multipath-tools-100322/libmultipath/defaults.h
===================================================================
--- multipath-tools-100322.orig/libmultipath/defaults.h
+++ multipath-tools-100322/libmultipath/defaults.h
@@ -19,6 +19,6 @@
 #define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
-#define DEFAULT_BINDINGS_FILE	"/var/lib/multipath/bindings"
+#define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 
 char * set_default (char * str);
Index: multipath-tools-100322/multipath.conf.annotated
===================================================================
--- multipath-tools-100322.orig/multipath.conf.annotated
+++ multipath-tools-100322/multipath.conf.annotated
@@ -165,7 +165,7 @@
 #	# name    : user_friendly_names
 #	# scope   : multipath
 #	# desc    : If set to "yes", using the bindings file
-#	#           /var/lib/multipath/bindings to assign a persistent and
+#	#           /etc/multipath/bindings to assign a persistent and
 #	#           unique alias to the multipath, in the form of mpath<n>.
 #	#           If set to "no" use the WWID as the alias. In either case
 #	#           this be will be overriden by any specific aliases in this
Index: multipath-tools-100322/multipath/multipath.conf.5
===================================================================
--- multipath-tools-100322.orig/multipath/multipath.conf.5
+++ multipath-tools-100322/multipath/multipath.conf.5
@@ -224,7 +224,7 @@ for never stop queueing. Default is 0.
 If set to 
 .I yes
 , using the bindings file
-.I /var/lib/multipath/bindings
+.I /etc/multipath/bindings
 to assign a persistent and unique alias to the multipath, in the form of mpath<n>.
 If set to 
 .I no
