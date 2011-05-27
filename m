From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: Move discard and secure discard flags to
 queue limits
Date: Fri, 27 May 2011 09:39:52 -0400
Message-ID: <20110527133952.GC17219@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, May 26 2011 at 10:42pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> Whether a device supports discard is currently stored two places:
> max_discard_sectors in the queue limits and the discard request_queue
> flag. Deprecate the queue flag and always use the topology.
> 
> Also move the secure discard flag to the queue limits so it can be
> stacked as well.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 35792bf..b5c6a1b 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1185,11 +1185,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 */
>  	q->limits = *limits;
>  
> -	if (!dm_table_supports_discards(t))
> -		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
> -	else
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
> -
>  	dm_table_set_integrity(t);
>  
>  	/*

This doesn't go far enough; dm-table.c pays attention to the targets in
a table and their support for discards.

Most targets do support discards (tgt->num_discard_requests > 0).  But
if any target doesn't support discards then the entire table doesn't
support them.

In addition, there is patch that Alasdair just merged that allows a
target to short-circuit the normal dm_table_supports_discards() and
always claim support for discards.  This is needed for the upcoming DM
thinp target (target, and table, supports discards even if none of the
target's underlying devices do).

This is queued for Alasdair's 2.6.40 pull request to Linus (which should
be happening very soon):
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-table-allow-targets-to-support-discards-internally.patch

Can we give this patch another cycle (IMHO quite late to crank out DM
changes that don't offer discard support regressions)?  I'd have time to
sort out the DM side of things so that it plays nice with what you've
provided.

The previous 2 patches look good to me.  But if Jens is to merge those
for the current window that means Alasdair should drop this stop-gap
patch that he queued up:
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-table-propagate-non-rotational-flag.patch

Thoughts?

Mike
