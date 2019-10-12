From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 29/72] multipathd: stop_waiter_thread(): removed
 unused parameter
Date: Sat, 12 Oct 2019 21:28:13 +0000
Message-ID: <20191012212703.12989-30-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 4 ++--
 multipathd/waiter.c | 2 +-
 multipathd/waiter.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ef128a32..43ae42d4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -377,7 +377,7 @@ remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 	 * so they don't need to be manually removed here */
 	condlog(3, "%s: removing map from internal tables", mpp->alias);
 	if (!poll_dmevents)
-		stop_waiter_thread(mpp, vecs);
+		stop_waiter_thread(mpp);
 	remove_map(mpp, vecs, PURGE_VEC);
 }
 
@@ -392,7 +392,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 
 	if (!poll_dmevents) {
 		vector_foreach_slot(vecs->mpvec, mpp, i)
-			stop_waiter_thread(mpp, vecs);
+			stop_waiter_thread(mpp);
 	}
 	else
 		unwatch_all_dmevents();
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index eb8d6996..e6457663 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -49,7 +49,7 @@ static void free_waiter (void *data)
 	FREE(wp);
 }
 
-void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
+void stop_waiter_thread (struct multipath *mpp)
 {
 	pthread_t thread;
 
diff --git a/multipathd/waiter.h b/multipathd/waiter.h
index 0cfae46f..28e0f6d5 100644
--- a/multipathd/waiter.h
+++ b/multipathd/waiter.h
@@ -11,7 +11,7 @@ struct event_thread {
 	struct vectors *vecs;
 };
 
-void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs);
+void stop_waiter_thread (struct multipath *mpp);
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
 
 #endif /* _WAITER_H */
-- 
2.23.0
