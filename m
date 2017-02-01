From: Christoph Hellwig <hch@infradead.org>
Subject: Re: error propagation problem on xfs over dm stripe
Date: Tue, 31 Jan 2017 23:42:49 -0800
Message-ID: <20170201074249.GA22669@infradead.org>
References: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 31, 2017 at 09:12:07PM -0600, Eric Sandeen wrote:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5..3555ba8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -808,7 +808,9 @@ static void dec_pending(struct dm_io *io, int error)
>  		} else {
>  			/* done with normal IO or empty flush */
>  			trace_block_bio_complete(md->queue, bio, io_error);
> -			bio->bi_error = io_error;
> +			/* don't overwrite or clear existing errors */
> +			if (!bio->bi_error)
> +				bio->bi_error = io_error;
>  			bio_endio(bio);
>  		}
>  	}
> 
> but Mike was a little uneasy, not knowing for sure how we got here to
> overwrite this bio's error (hopefully I'm representing his concerns
> fairly and correctly).

FYI, what we do both in the XFS buffer cache and the new direct I/O
code is to use a

	        cmpxchg(&dio->error, 0, ret);

in a similar situation, which should work here, too.
