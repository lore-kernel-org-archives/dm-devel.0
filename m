From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace static and define
	default values for config options
Date: Wed, 19 Oct 2016 20:16:17 +0200
Message-ID: <20161019181617.9147-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Replace "const" by PRIO_CONST.
Replace static force_sync and partition_delim values, and define
DEFAULT_FORCE_SYNC and DEFAULT_PARTITION_DELIM

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/config.c   | 4 ++--
 libmultipath/defaults.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 92e4deb..ed51afb 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -606,8 +606,8 @@ load_config (char * file)
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
-	conf->force_sync = 0;
-	conf->partition_delim = NULL;
+	conf->force_sync = DEFAULT_FORCE_SYNC;
+	conf->partition_delim = DEFAULT_PARTITION_DELIM;
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
 	conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index e9581a6..9af9a9a 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -28,11 +28,13 @@
 #define DEFAULT_RETRIGGER_DELAY	10
 #define DEFAULT_RETRIGGER_TRIES	3
 #define DEFAULT_UEV_WAIT_TIMEOUT 30
-#define DEFAULT_PRIO		"const"
+#define DEFAULT_PRIO		PRIO_CONST
 #define DEFAULT_PRIO_ARGS	""
 #define DEFAULT_CHECKER		TUR
 #define DEFAULT_FLUSH		FLUSH_DISABLED
 #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
+#define DEFAULT_FORCE_SYNC	0
+#define DEFAULT_PARTITION_DELIM	NULL
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
-- 
2.10.1
