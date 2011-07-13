From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: Move discard and secure discard flags to
 queue limits
Date: Wed, 13 Jul 2011 11:46:37 -0400
Message-ID: <20110713154637.GA22216@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
 <20110527133952.GC17219@redhat.com>
 <yq1fwnvzk0i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1fwnvzk0i.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, May 30 2011 at 10:22pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Most targets do support discards (tgt->num_discard_requests > 0).
> Mike> But if any target doesn't support discards then the entire table
> Mike> doesn't support them.
> 
> Would you rather have the stacking policy for discard be | instead of &?

Sorry about letting this slip through the cracks.

I had a look and I think if you just changed the dm-table.c hunk of this
3rd patch to allow DM to override the stacking then we'd be good (some
targets aren't to allow discard even if their component devices would
allow it when stacked), so something like:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 367a2e0..02c93ab 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1251,16 +1251,17 @@ static void dm_table_set_integrity(struct dm_table *t)
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
+	if (!dm_table_supports_discards(t)) {
+		limits->max_discard_sectors = 0;
+		limits->discard_granularity = 0;
+		limits->secure_discard = 0;
+	}
+
 	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
 	q->limits = *limits;
 
-	if (!dm_table_supports_discards(t))
-		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
-	else
-		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-
 	dm_table_set_integrity(t);
 
 	/*
