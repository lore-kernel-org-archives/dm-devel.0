From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for-4.2 2/3] block,
 dm: don't copy bios for request clones
Date: Tue, 26 May 2015 06:20:43 +0000
Message-ID: <556410BB.3000103@ce.jp.nec.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1432300445-9543-2-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <DB73D74CB5403B4CB1E75118C99ACB45@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/22/15 22:14, Mike Snitzer wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Currently dm-multipath has to clone the bios for every request sent
> to the lower devices, which wastes cpu cycles and ties down memory.
> 
> This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
> to not complete bios attached to a request, which we set on clone
> requests similar to bios in a flush sequence.  With this change I/O
> errors on a path failure only get propagated to dm-multipath, which
> can then either resubmit the I/O or complete the bios on the original
> request.
..
> @@ -128,7 +128,8 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>  	bio_advance(bio, nbytes);
>  
>  	/* don't actually finish bio if it's part of flush sequence */
> -	if (bio->bi_iter.bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
> +	if (bio->bi_iter.bi_size == 0 &&
> +	    !(rq->cmd_flags & (REQ_FLUSH_SEQ|REQ_CLONE)))
>  		bio_endio(bio, error);
>  }

Not completing bios is not sufficient.
If you advance the bi_iter to the end, you need to somehow rewind it
or the re-submission will be incomplete, that would end up as a data
corruption...

-- 
Jun'ichi Nomura, NEC Corporation
