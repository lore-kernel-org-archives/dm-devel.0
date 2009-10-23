From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH resend] block: silently error unsupported
 empty barriers too
Date: Fri, 23 Oct 2009 16:40:44 -0400
Message-ID: <20091023204044.GA29173@redhat.com>
References: <1251992870.3084.125.camel@blaa>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251992870.3084.125.camel@blaa>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, device-mapper development <dm-devel@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 03 2009 at 11:47am -0400,
Mark McLoughlin <markmc@redhat.com> wrote:

> With 2.6.31-rc5 in a KVM guest using dm and virtio_blk, we see the
> following errors:
> 
>   end_request: I/O error, dev vda, sector 0
>   end_request: I/O error, dev vda, sector 0
> 
> The errors go away if dm stops submitting empty barriers, by reverting:
> 
>   commit 52b1fd5a27c625c78373e024bf570af3c9d44a79
>   Author: Mikulas Patocka <mpatocka@redhat.com>
>     dm: send empty barriers to targets in dm_flush
> 
> We should error all barriers, even empty barriers, on devices like
> virtio_blk which don't support them.
> 
> See also:
> 
>   https://bugzilla.redhat.com/514901
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  block/blk-core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index e3299a7..35ad2bb 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1163,8 +1163,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>  	const int unplug = bio_unplug(bio);
>  	int rw_flags;
>  
> -	if (bio_barrier(bio) && bio_has_data(bio) &&
> -	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> +	if (bio_barrier(bio) && (q->next_ordered == QUEUE_ORDERED_NONE)) {
>  		bio_endio(bio, -EOPNOTSUPP);
>  		return 0;
>  	}

Jens,

Any chance we can get this fix upstream for 2.6.32?  I refreshed the
patch to work on 2.6.32-rc5:


From: Mark McLoughlin <markmc@redhat.com>

With 2.6.32-rc5 in a KVM guest using dm and virtio_blk, we see the
following errors:

  end_request: I/O error, dev vda, sector 0
  end_request: I/O error, dev vda, sector 0

The errors go away if dm stops submitting empty barriers, by reverting:

  commit 52b1fd5a27c625c78373e024bf570af3c9d44a79
  Author: Mikulas Patocka <mpatocka@redhat.com>
    dm: send empty barriers to targets in dm_flush

We should silently error all barriers, even empty barriers, on devices
like virtio_blk which don't support them.

See also:

  https://bugzilla.redhat.com/514901

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ac0fa10..71da511 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1161,7 +1161,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
	int rw_flags;
 
-	if (bio_rw_flagged(bio, BIO_RW_BARRIER) && bio_has_data(bio) &&
+	if (bio_rw_flagged(bio, BIO_RW_BARRIER) &&
	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
		bio_endio(bio, -EOPNOTSUPP);
		return 0;
