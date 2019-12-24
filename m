From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH 3/4] dm snapshot: use true,
	false for bool variable
Date: Tue, 24 Dec 2019 14:38:02 +0800
Message-ID: <1577169483-138896-4-git-send-email-zhengbin13@huawei.com>
References: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: zhengbin13@huawei.com
List-Id: dm-devel.ids

Fixes coccicheck warning:

drivers/md/dm-snap.c:1064:3-18: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-snap.c:1152:1-16: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-snap.c:1317:1-16: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/md/dm-snap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4fb1a40..6b11a26 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1061,7 +1061,7 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 			DMERR("Read error in exception store: "
 			      "shutting down merge");
 			down_write(&s->lock);
-			s->merge_failed = 1;
+			s->merge_failed = true;
 			up_write(&s->lock);
 		}
 		goto shut;
@@ -1149,7 +1149,7 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)

 shut:
 	down_write(&s->lock);
-	s->merge_failed = 1;
+	s->merge_failed = true;
 	b = __release_queued_bios_after_merge(s);
 	up_write(&s->lock);
 	error_bios(b);
@@ -1314,7 +1314,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->state_bits = 0;
-	s->merge_failed = 0;
+	s->merge_failed = false;
 	s->first_merging_chunk = 0;
 	s->num_merging_chunks = 0;
 	bio_list_init(&s->bios_queued_during_merge);
--
2.7.4
