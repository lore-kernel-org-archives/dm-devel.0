From: Jan Blunck <jblunck@suse.de>
Subject: [patch 04/11] dm-snap: Remove dead pe_lock spinlock
Date: Fri, 10 Aug 2007 22:02:08 +0200
Message-ID: <6634.62750749222$1186776749@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-remove-pe_lock.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Remove the dead pe_lock spinlock.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |    1 -
 drivers/md/dm-snap.h |    6 ------
 2 files changed, 7 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -469,7 +469,6 @@ static int snapshot_ctr(struct dm_target
 	s->active = 0;
 	s->last_percent = 0;
 	init_rwsem(&s->lock);
-	spin_lock_init(&s->pe_lock);
 	s->table = ti->table;
 
 	/* Allocate hash table for COW data */
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -114,12 +114,6 @@ struct dm_snapshot {
 	struct exception_table pending;
 	struct exception_table complete;
 
-	/*
-	 * pe_lock protects all pending_exception operations and access
-	 * as well as the snapshot_bios list.
-	 */
-	spinlock_t pe_lock;
-
 	/* The on disk metadata handler */
 	struct exception_store store;
 

-- 
