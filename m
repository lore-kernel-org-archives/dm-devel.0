From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 23/24] io-controller: map sync requests to group
	using bio tracking info
Date: Sun, 16 Aug 2009 15:30:45 -0400
Message-ID: <1250451046-9966-24-git-send-email-vgoyal@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Cc: paolo.valente@unimore.it, jmarchan@redhat.com, dhaval@linux.vnet.ibm.com, peterz@infradead.org, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, lizf@cn.fujitsu.com, jmoyer@redhat.com, mikew@google.com, fchecconi@gmail.com, dpshah@google.com, vgoyal@redhat.com, nauman@google.com, s-uchida@ap.jp.nec.com, akpm@linux-foundation.org, agk@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

o sync requests are mapped to the cgroup submitting tasks belongs to. This
  is an experimental patch where sync requets can be mapped to the group
  using bio tracking information and not submitting task's context.

o This patch implements this functionality only for noop, deadline and AS.

o Introducing this patch for experimental purposes to see if it is really
  meaningful or not.

o This behavior is turned on by setting /sys/block/<disk>/queue/iosched/map_sync  varibale.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/as-iosched.c       |    1 +
 block/deadline-iosched.c |    1 +
 block/elevator-fq.c      |    7 ++++++-
 block/elevator-fq.h      |    9 +++++++++
 block/noop-iosched.c     |    1 +
 5 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 8ea9398..2a72da1 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1769,6 +1769,7 @@ static struct elv_fs_entry as_attrs[] = {
 	ELV_ATTR(fairness),
 	ELV_ATTR(slice_sync),
 	ELV_ATTR(group_idle),
+	ELV_ATTR(map_sync),
 #endif
 	__ATTR_NULL
 };
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index cc9c8c3..80377a9 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -466,6 +466,7 @@ static struct elv_fs_entry deadline_attrs[] = {
 	ELV_ATTR(fairness),
 	ELV_ATTR(slice_sync),
 	ELV_ATTR(group_idle),
+	ELV_ATTR(map_sync),
 #endif
 	__ATTR_NULL
 };
diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 70d0ecf..2f7a419 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -681,6 +681,8 @@ SHOW_FUNCTION(elv_slice_async_show, efqd->elv_slice[0], 1);
 EXPORT_SYMBOL(elv_slice_async_show);
 SHOW_FUNCTION(elv_fairness_show, efqd->fairness, 0);
 EXPORT_SYMBOL(elv_fairness_show);
+SHOW_FUNCTION(elv_map_sync_show, efqd->map_sync, 0);
+EXPORT_SYMBOL(elv_map_sync_show);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -707,6 +709,8 @@ STORE_FUNCTION(elv_slice_async_store, &efqd->elv_slice[0], 1, UINT_MAX, 1);
 EXPORT_SYMBOL(elv_slice_async_store);
 STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
 EXPORT_SYMBOL(elv_fairness_store);
+STORE_FUNCTION(elv_map_sync_store, &efqd->map_sync, 0, 1, 0);
+EXPORT_SYMBOL(elv_map_sync_store);
 #undef STORE_FUNCTION
 
 void elv_schedule_dispatch(struct request_queue *q)
@@ -1713,6 +1717,7 @@ struct io_group *elv_io_get_io_group_bio(struct request_queue *q,
 						struct bio *bio, int create)
 {
 	struct page *page = NULL;
+	struct elv_fq_data *efqd = q->elevator->efqd;
 
 	/*
 	 * Determine the group from task context. Even calls from
@@ -1731,7 +1736,7 @@ struct io_group *elv_io_get_io_group_bio(struct request_queue *q,
 	}
 
 	/* Map the sync bio to the right group using task context */
-	if (elv_bio_sync(bio))
+	if (elv_bio_sync(bio) && !efqd->map_sync)
 		goto sync;
 
 #ifdef CONFIG_TRACK_ASYNC_CONTEXT
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 53e5a03..57ff85f 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -205,6 +205,12 @@ struct elv_fq_data {
 	 * queue before new queue is scheduled in
 	 */
 	unsigned int fairness;
+
+	/*
+	 * Get io group bio belongs to from bio and not from submitting task
+	 * context
+	 */
+	unsigned int map_sync;
 };
 
 /* Logging facilities. */
@@ -436,6 +442,9 @@ extern struct io_group *elv_io_get_io_group_bio(struct request_queue *q,
 extern ssize_t elv_group_idle_show(struct elevator_queue *q, char *name);
 extern ssize_t elv_group_idle_store(struct elevator_queue *q, const char *name,
 					size_t count);
+extern ssize_t elv_map_sync_show(struct elevator_queue *q, char *name);
+extern ssize_t elv_map_sync_store(struct elevator_queue *q, const char *name,
+					size_t count);
 extern void elv_io_group_congestion_threshold(struct request_queue *q,
 						struct io_group *iog);
 static inline void elv_get_iog(struct io_group *iog)
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 4ba496f..887bba1 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -88,6 +88,7 @@ static struct elv_fs_entry noop_attrs[] = {
 	ELV_ATTR(fairness),
 	ELV_ATTR(slice_sync),
 	ELV_ATTR(group_idle),
+	ELV_ATTR(map_sync),
 	__ATTR_NULL
 };
 #endif
-- 
1.6.0.6
