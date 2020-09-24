From: mwilck@suse.com
Subject: [PATCH v2 08/21] multipathd: cancel threads early during
	shutdown
Date: Thu, 24 Sep 2020 15:37:03 +0200
Message-ID: <20200924133716.14120-9-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Cancel the other threads before taking vecs->lock. This avoids
delays during shutdown caused e.g. by the checker thread holding
the vecs lock.

Note: this makes it possible that cancelled threads leak memory,
because they can now be cancelled before having released the vecs
lock. I believe this is acceptable, as only threads are affected
that are cancelled during multipathd shutdown.

Cc: Chongyun Wu <wu.chongyun@h3c.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 39aea4a..d1f8cc1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3073,23 +3073,24 @@ child (__attribute__((unused)) void *param)
 		}
 	}
 
-	lock(&vecs->lock);
+	pthread_cancel(check_thr);
+	pthread_cancel(uevent_thr);
+	pthread_cancel(uxlsnr_thr);
+	pthread_cancel(uevq_thr);
+	if (poll_dmevents)
+		pthread_cancel(dmevent_thr);
+
 	conf = get_multipath_config();
 	queue_without_daemon = conf->queue_without_daemon;
 	put_multipath_config(conf);
+
+	lock(&vecs->lock);
 	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
-	pthread_cancel(check_thr);
-	pthread_cancel(uevent_thr);
-	pthread_cancel(uxlsnr_thr);
-	pthread_cancel(uevq_thr);
-	if (poll_dmevents)
-		pthread_cancel(dmevent_thr);
-
 	pthread_join(check_thr, NULL);
 	pthread_join(uevent_thr, NULL);
 	pthread_join(uxlsnr_thr, NULL);
-- 
2.28.0
