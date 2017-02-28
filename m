From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/33] multipathd: issue systemd READY after
	initial configuration
Date: Tue, 28 Feb 2017 17:23:07 +0100
Message-ID: <20170228162329.14517-12-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

We should be issueing systemd READY only after the initial
configuration has been completed, otherwise systemd might
continue while the multipath devices are not setup up properly.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 86d73f7b..cf44778b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2361,6 +2361,7 @@ child (void * param)
 	int i;
 #ifdef USE_SYSTEMD
 	unsigned long checkint;
+	int startup_done = 0;
 #endif
 	int rc;
 	int pid_fd = -1;
@@ -2509,10 +2510,6 @@ child (void * param)
 	}
 	pthread_attr_destroy(&misc_attr);
 
-#ifdef USE_SYSTEMD
-	sd_notify(0, "READY=1");
-#endif
-
 	while (running_state != DAEMON_SHUTDOWN) {
 		pthread_cleanup_push(config_cleanup, NULL);
 		pthread_mutex_lock(&config_lock);
@@ -2534,6 +2531,12 @@ child (void * param)
 			}
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
+#ifdef USE_SYSTEMD
+			if (!startup_done) {
+				sd_notify(0, "READY=1");
+				startup_done = 1;
+			}
+#endif
 		}
 	}
 
-- 
2.11.0
