From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 01/17] multipathd: use /run instead of /var/run
Date: Mon, 28 Mar 2016 22:12:58 -0500
Message-ID: <1459221194-23222-2-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

/var/run is now usually a symlink to /run.  If /var is on a separate
filesytem, when multipathd starts up, it might end up writing to
/var/run before the /var filesytem is mounted and thus not have its
pidfile accessible at /var/run afterwards.  On most distrubutions /run
is now a tmpfs and should always be available before multipathd is
started, so multipath should just write there directly, instead of
through the symlink.

If /var/run is not a symlink, continue using it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                    | 10 +++++++++-
 libmultipath/defaults.h         |  2 +-
 multipathd/multipathd.init.suse |  2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index c3ed73f..357dd33 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -21,6 +21,14 @@ ifndef LIB
 	endif
 endif
 
+ifndef RUN
+	ifeq ($(shell test -L /var/run -o ! -d /var/run && echo 1),1)
+		RUN=run
+	else
+		RUN=var/run
+	endif
+endif
+
 ifndef SYSTEMD
 	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
 		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
@@ -54,7 +62,7 @@ ifndef RPM_OPT_FLAGS
 endif
 
 OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
-CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
+CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS = -shared
 
 %.o:	%.c
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 8902f40..cf1d5be 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -26,7 +26,7 @@
 #define MAX_CHECKINT(a)		(a << 2)
 
 #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
-#define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
+#define DEFAULT_PIDFILE		"/" RUN_DIR "/multipathd.pid"
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
diff --git a/multipathd/multipathd.init.suse b/multipathd/multipathd.init.suse
index d1319b1..ed699fa 100644
--- a/multipathd/multipathd.init.suse
+++ b/multipathd/multipathd.init.suse
@@ -17,7 +17,7 @@
 
 PATH=/bin:/usr/bin:/sbin:/usr/sbin
 DAEMON=/sbin/multipathd
-PIDFILE=/var/run/multipathd.pid
+PIDFILE=/run/multipathd.pid
 MPATH_INIT_TIMEOUT=10
 ARGS=""
 
-- 
1.8.3.1
