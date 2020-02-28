From: qiwuchen55@gmail.com
Subject: [PATCH] md/dm-stats.c: use list_for_each_entry*() APIs
	to simplify code
Date: Fri, 28 Feb 2020 11:38:29 +0800
Message-ID: <1582861109-17266-1-git-send-email-qiwuchen55@gmail.com>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, chenqiwu <chenqiwu@xiaomi.com>
List-Id: dm-devel.ids

From: chenqiwu <chenqiwu@xiaomi.com>

Use list_for_each_entry*() APIs instead of open-coding to
simplify code.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 drivers/md/dm-stats.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 7141704..34637d1 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -206,11 +206,10 @@ void dm_stats_init(struct dm_stats *stats)
 void dm_stats_cleanup(struct dm_stats *stats)
 {
 	size_t ni;
-	struct dm_stat *s;
+	struct dm_stat *s, *tmp;
 	struct dm_stat_shared *shared;
 
-	while (!list_empty(&stats->list)) {
-		s = container_of(stats->list.next, struct dm_stat, list_entry);
+	list_for_each_entry_safe(s, tmp, &stats->list, list_entry) {
 		list_del(&s->list_entry);
 		for (ni = 0; ni < s->n_entries; ni++) {
 			shared = &s->stat_shared[ni];
@@ -240,7 +239,6 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			   void (*resume_callback)(struct mapped_device *),
 			   struct mapped_device *md)
 {
-	struct list_head *l;
 	struct dm_stat *s, *tmp_s;
 	sector_t n_entries;
 	size_t ni;
@@ -360,8 +358,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 
 	mutex_lock(&stats->mutex);
 	s->id = 0;
-	list_for_each(l, &stats->list) {
-		tmp_s = container_of(l, struct dm_stat, list_entry);
+	list_for_each_entry(tmp_s, &stats->list, list_entry) {
 		if (WARN_ON(tmp_s->id < s->id)) {
 			r = -EINVAL;
 			goto out_unlock_resume;
@@ -375,7 +372,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 		s->id++;
 	}
 	ret_id = s->id;
-	list_add_tail_rcu(&s->list_entry, l);
+	list_add_tail_rcu(&s->list_entry, &stats->list);
 	mutex_unlock(&stats->mutex);
 
 	resume_callback(md);
-- 
1.9.1
