From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH maybe-for-3.13 01/20] dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
Date: Fri, 20 Dec 2013 18:37:14 -0500
Message-ID: <1387582653-13647-2-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: stable@vger.kernel.org
List-Id: dm-devel.ids

As additional members are added to the dm_thin_new_mapping structure
care should be taken to make sure they get initialized before use.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ee29037..da65feb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -751,13 +751,17 @@ static int ensure_next_mapping(struct pool *pool)
 
 static struct dm_thin_new_mapping *get_next_mapping(struct pool *pool)
 {
-	struct dm_thin_new_mapping *r = pool->next_mapping;
+	struct dm_thin_new_mapping *m = pool->next_mapping;
 
 	BUG_ON(!pool->next_mapping);
 
+	memset(m, 0, sizeof(struct dm_thin_new_mapping));
+	INIT_LIST_HEAD(&m->list);
+	m->bio = NULL;
+
 	pool->next_mapping = NULL;
 
-	return r;
+	return m;
 }
 
 static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
@@ -769,15 +773,10 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
-	m->quiesced = 0;
-	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_dest;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	if (!dm_deferred_set_add_work(pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
@@ -840,15 +839,12 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
 	m->quiesced = 1;
 	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_block;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	/*
 	 * If the whole block of data is being overwritten or we are not
@@ -1045,7 +1041,6 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->data_block = lookup_result.block;
 			m->cell = cell;
 			m->cell2 = cell2;
-			m->err = 0;
 			m->bio = bio;
 
 			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list)) {
-- 
1.8.1.4
