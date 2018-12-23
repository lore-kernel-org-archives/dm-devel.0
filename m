From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/20] multipathd: don't check foreign paths
	every tick
Date: Sun, 23 Dec 2018 23:21:17 +0100
Message-ID: <20181223222126.30882-12-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We don't do this for native paths, so don't do it for
foreigns, either. Instead use max_checkint for foreign
paths, always.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index aac32ac8..c981d437 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2271,6 +2271,7 @@ checkerloop (void *ap)
 	unsigned int i;
 	struct timespec last_time;
 	struct config *conf;
+	int foreign_tick = 0;
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
@@ -2368,7 +2369,15 @@ checkerloop (void *ap)
 						diff_time.tv_sec);
 			}
 		}
-		check_foreign();
+
+		if (foreign_tick == 0) {
+			conf = get_multipath_config();
+			foreign_tick = conf->max_checkint;
+			put_multipath_config(conf);
+		}
+		if (--foreign_tick == 0)
+			check_foreign();
+
 		post_config_state(DAEMON_IDLE);
 		conf = get_multipath_config();
 		strict_timing = conf->strict_timing;
-- 
2.19.2
