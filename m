From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 9/9] dm: Generate uevents for other targets
Date: Mon,  3 Oct 2016 12:23:00 -0700
Message-ID: <1475522580-16723-10-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Generate uevents for other targets: cache, log, raid1, and snap.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-cache-target.c       | 5 ++++-
 drivers/md/dm-log-userspace-base.c | 8 ++++++--
 drivers/md/dm-log.c                | 1 +
 drivers/md/dm-raid1.c              | 1 +
 drivers/md/dm-snap.c               | 1 +
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 59b2c50..29f0bc9 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -586,8 +586,10 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		if (atomic_dec_return(&cache->nr_dirty) == 0)
+		if (atomic_dec_return(&cache->nr_dirty) == 0) {
+			dm_uevent_add(cache->ti, KOBJ_CHANGE, "CACHE_CLEAN");
 			dm_table_event(cache->ti->table);
+		}
 	}
 }
 
@@ -978,6 +980,7 @@ static void notify_mode_switch(struct cache *cache, enum cache_metadata_mode mod
 		"fail"
 	};
 
+	dm_uevent_add(cache->ti, KOBJ_CHANGE, "CACHE_MODE_SWITCH");
 	dm_table_event(cache->ti->table);
 	DMINFO("%s: switching cache to %s mode",
 	       cache_device_name(cache), descs[(int)mode]);
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 53b7b06d..cb0b6cb 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -162,8 +162,10 @@ static void do_flush(struct work_struct *work)
 
 	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH, NULL, 0, NULL, NULL);
 
-	if (r)
+	if (r) {
+		dm_uevent_add(lc->ti->table, KOBJ_CHANGE, "LOG_FLUSHED");
 		dm_table_event(lc->ti->table);
+	}
 }
 
 /*
@@ -634,8 +636,10 @@ out:
 		mempool_free(fe, flush_entry_pool);
 	}
 
-	if (r)
+	if (r) {
+		dm_uevent_add(lc->ti->table, KOBJ_CHANGE, "LOG_FLUSHED");
 		dm_table_event(lc->ti->table);
+	}
 
 	return r;
 }
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 07fc1ad..8d144d2 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -579,6 +579,7 @@ static void fail_log_device(struct log_c *lc)
 		return;
 
 	lc->log_dev_failed = 1;
+	dm_uevent_add(lc->ti, KOBJ_CHANGE, "LOG_FAILED");
 	dm_table_event(lc->ti->table);
 }
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bdf1606..daffbab 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -410,6 +410,7 @@ static void do_recovery(struct mirror_set *ms)
 	if (!ms->in_sync &&
 	    (log->type->get_sync_count(log) == ms->nr_regions)) {
 		/* the sync is complete */
+		dm_uevent_add(ms->ti, KOBJ_CHANGE, "TABLE_SYNCED");
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
 		reset_ms_flags(ms);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c65feea..b47e28f6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1443,6 +1443,7 @@ static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 
 	s->valid = 0;
 
+	dm_uevent_add(s->ti, KOBJ_CHANGE, "SNAPSHOT_INVALIDATED");
 	dm_table_event(s->ti->table);
 }
 
-- 
2.7.4
