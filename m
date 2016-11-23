From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Tue, 22 Nov 2016 22:16:54 -0500
Message-ID: <20161123031653.GA17056@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
	<20161121234316.GA25362@redhat.com>
	<d4a3879e-ec60-69f6-abb8-95aa7f305277@sandisk.com>
	<20161122003444.GB25362@redhat.com>
	<a8311b54-cd95-a1f9-7cd2-11adb10eec80@sandisk.com>
	<20161123004803.GA32186@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161123004803.GA32186@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 22 2016 at  7:48P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> But regardless, what certainly needs fixing is the inconsistency of
> inheriting DM_TYPE_MQ_REQUEST_BASED but not setting all_blk_mq to true
> (all_blk_mq == true is implied by DM_TYPE_MQ_REQUEST_BASED).
> 
> I'm now questioning why we even need the 'all_blk_mq' state within the
> table.  I'll revisit the "why?" on all that in my previous commits.
> I'll likely get back with you on this point tomorrow.  And will
> hopefully have a fix for you.

We need 'all_blk_mq' because DM_TYPE_* is only used to establish the
DM device's type of request_queue.  It doesn't say anything about the DM
device's underlying devices.

Anyway, this _untested_ patch should hopefully resolve the 'all_blk_mq'
inconsistency you saw:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8b013ea..8ce81d0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -924,12 +924,6 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	BUG_ON(!request_based); /* No targets in this table */
 
-	if (list_empty(devices) && __table_type_request_based(live_md_type)) {
-		/* inherit live MD type */
-		t->type = live_md_type;
-		return 0;
-	}
-
 	/*
 	 * The only way to establish DM_TYPE_MQ_REQUEST_BASED is by
 	 * having a compatible target use dm_table_set_type.
@@ -948,6 +942,19 @@ static int dm_table_determine_type(struct dm_table *t)
 		return -EINVAL;
 	}
 
+	if (list_empty(devices)) {
+		int srcu_idx;
+		struct dm_table *live_table = dm_get_live_table(t->md, &srcu_idx);
+
+		/* inherit live table's type and all_blk_mq */
+		if (live_table) {
+			t->type = live_table->type;
+			t->all_blk_mq = live_table->all_blk_mq;
+		}
+		dm_put_live_table(t->md, srcu_idx);
+		return 0;
+	}
+
 	/* Non-request-stackable devices can't be used for request-based dm */
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
