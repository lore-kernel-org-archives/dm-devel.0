From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/18] multipathd: use /run instead of /var/run
Date: Thu,  8 Oct 2015 14:44:36 -0500
Message-ID: <1444333491-16265-4-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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

/var/run is usually a symlink to /run.  If /var is on a separate
filesytem, when multipathd starts up, it might end up writing to
/var/run before the /var filesytem is mounted and thus not have
its pidfile accessible at /var/run afterwards.  /run is a tmpfs and
should always be available before multipathd is started, so
multipath should just write there directly, instead of through the
symlink.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h         | 2 +-
 multipathd/multipathd.init.suse | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 8902f40..79d6b91 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -26,7 +26,7 @@
 #define MAX_CHECKINT(a)		(a << 2)
 
 #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
-#define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
+#define DEFAULT_PIDFILE		"/run/multipathd.pid"
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
