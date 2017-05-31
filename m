From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] dm: Make flush bios explicitely sync
Date: Wed, 31 May 2017 09:44:32 +0200
Message-ID: <20170531074433.14298-2-jack@suse.cz>
References: <20170531074433.14298-1-jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170531074433.14298-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
definitions.  generic_make_request_checks() however strips REQ_FUA and
REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
write cache and thus write effectively becomes asynchronous which can
lead to performance regressions

Fix the problem by making sure all bios which are synchronous are
properly marked with REQ_SYNC.

CC: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com
Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/dm-bufio.c           | 2 +-
 drivers/md/dm-integrity.c       | 3 ++-
 drivers/md/dm-raid1.c           | 2 +-
 drivers/md/dm-snap-persistent.c | 3 ++-
 drivers/md/dm.c                 | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cd8139593ccd..840c1496b2b1 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1334,7 +1334,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 {
 	struct dm_io_request io_req = {
 		.bi_op = REQ_OP_WRITE,
-		.bi_op_flags = REQ_PREFLUSH,
+		.bi_op_flags = REQ_PREFLUSH | REQ_SYNC,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = c->dm_io,
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c7f7c8d76576..923323e22320 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -783,7 +783,8 @@ static void write_journal(struct dm_integrity_c *ic, unsigned commit_start, unsi
 			for (i = 0; i < commit_sections; i++)
 				rw_section_mac(ic, commit_start + i, true);
 		}
-		rw_journal(ic, REQ_OP_WRITE, REQ_FUA, commit_start, commit_sections, &io_comp);
+		rw_journal(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, commit_start,
+			   commit_sections, &io_comp);
 	} else {
 		unsigned to_end;
 		io_comp.in_flight = (atomic_t)ATOMIC_INIT(2);
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index a95cbb80fb34..e61c45047c25 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -260,7 +260,7 @@ static int mirror_flush(struct dm_target *ti)
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_op = REQ_OP_WRITE,
-		.bi_op_flags = REQ_PREFLUSH,
+		.bi_op_flags = REQ_PREFLUSH | REQ_SYNC,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = ms->io_client,
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index b93476c3ba3f..c5534d294773 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -741,7 +741,8 @@ static void persistent_commit_exception(struct dm_exception_store *store,
 	/*
 	 * Commit exceptions to disk.
 	 */
-	if (ps->valid && area_io(ps, REQ_OP_WRITE, REQ_PREFLUSH | REQ_FUA))
+	if (ps->valid && area_io(ps, REQ_OP_WRITE,
+				 REQ_PREFLUSH | REQ_FUA | REQ_SYNC))
 		ps->valid = 0;
 
 	/*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ef9500226c0..37ccd73c79ec 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1657,7 +1657,7 @@ static struct mapped_device *alloc_dev(int minor)
 
 	bio_init(&md->flush_bio, NULL, 0);
 	md->flush_bio.bi_bdev = md->bdev;
-	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
 
 	dm_stats_init(&md->stats);
 
-- 
2.12.3
