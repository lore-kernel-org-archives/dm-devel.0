From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-zoned: Avoid metadata flush writeback throttling
Date: Mon, 11 Sep 2017 11:05:55 -0400
Message-ID: <20170911150555.GA15818@redhat.com>
References: <20170724074422.23948-1-damien.lemoal@wdc.com>
	<20170724080320.GA16608@infradead.org>
	<0ee663a1-f497-1d10-f252-91fee072322a@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0ee663a1-f497-1d10-f252-91fee072322a@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 24 2017 at  5:16am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> 
> 
> On 7/24/17 17:03, Christoph Hellwig wrote:
> > On Mon, Jul 24, 2017 at 04:44:22PM +0900, Damien Le Moal wrote:
> >> Avoid metadata flush to be blocked by the writeback throttling code in
> >> wbt_wait(). Otherwise, we can end up with a deadlock under heavy write
> >> load with all chunk works active. In such situation, a deadlock can
> >> happen if the flush work is blocked by the throttling code while holding
> >> the metadata lock: as the chunk works will wait for the metadata lock
> >> too, no progress can be made.
> >>
> >> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> >> ---
> >>  drivers/md/dm-zoned-metadata.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> >> index 884ff7c170a0..f694fb98b002 100644
> >> --- a/drivers/md/dm-zoned-metadata.c
> >> +++ b/drivers/md/dm-zoned-metadata.c
> >> @@ -567,7 +567,8 @@ static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
> >>  	bio->bi_bdev = zmd->dev->bdev;
> >>  	bio->bi_private = mblk;
> >>  	bio->bi_end_io = dmz_mblock_bio_end_io;
> >> -	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
> >> +	bio_set_op_attrs(bio, REQ_OP_WRITE,
> >> +			 REQ_META | REQ_PRIO | REQ_SYNC | REQ_IDLE);
> > 
> > Please just assign bi_opf directly instea dof using bio_set_op_attrs
> > in new code.
> 
> OK. Will do.
> 
> > Also what do you need REQ_IDLE for?
> 
> It is not really needed here, but the wbt_should_throttle() code test is:
> 
> if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) == (REQ_SYNC | REQ_IDLE))
> 	return false;
> 
> So if REQ_IDLE is not set, wbt will trigger.
> 
> Having a req flag that says "no wb throttling please" would be a lot
> cleaner...

Did you have a new version of this patch?

Thanks,
Mike
