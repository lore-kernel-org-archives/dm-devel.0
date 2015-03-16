From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 60/78] multipathd: use local variable for
	watchdog configuration
Date: Mon, 16 Mar 2015 13:36:47 +0100
Message-ID: <1426509425-15978-61-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The 'watchdog' setting in struct config needs to be a local
variable in multipathd/main.c, as the config will be freed
during reconfiguration and the checkerloop might then
access an invalid structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h | 1 -
 multipathd/main.c     | 8 ++++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 0149ad3..0183969 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -116,7 +116,6 @@ struct config {
 	int ignore_wwids;
 	int checker_timeout;
 	int daemon;
-	int watchdog;
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
diff --git a/multipathd/main.c b/multipathd/main.c
index fd3514f..f876258 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -29,6 +29,10 @@
  */
 #include <checkers.h>
 
+#ifdef USE_SYSTEMD
+static int use_watchdog;
+#endif
+
 /*
  * libmultipath
  */
@@ -1400,7 +1404,7 @@ checkerloop (void *ap)
 		pthread_testcancel();
 		condlog(4, "tick");
 #ifdef USE_SYSTEMD
-		if (conf->watchdog)
+		if (use_watchdog)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 		if (vecs->pathvec) {
@@ -1830,7 +1834,7 @@ child (void * param)
 			conf->checkint = conf->max_checkint / 4;
 		condlog(3, "enabling watchdog, interval %d max %d",
 			conf->checkint, conf->max_checkint);
-		conf->watchdog = conf->checkint;
+		use_watchdog = conf->checkint;
 	}
 #endif
 	/*
-- 
1.8.4.5
