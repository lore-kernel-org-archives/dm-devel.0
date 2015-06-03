From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.2 2/3] block,
	dm: don't copy bios for	request clones
Date: Wed, 3 Jun 2015 09:39:56 +0200
Message-ID: <20150603073956.GB12072@lst.de>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com> <20150529165545.GB2682@lst.de>
	<556BB311.7050505@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <556BB311.7050505@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 01, 2015 at 01:19:13AM +0000, Junichi Nomura wrote:
> For example, blk_update_request() does this:
> 
> >         while (req->bio) {
> >                 struct bio *bio = req->bio;
> >                 unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
> > 
> >                 if (bio_bytes == bio->bi_iter.bi_size)
> >                         req->bio = bio->bi_next;
> 
> if bi_iter.bi_size is not correct, we possibly fail
> to move the req->bio pointer.
> 
> So other test case could be:
> 
> 1. Create a bio with 1MB size
> 2. Submit a request with the bio
> 3. From lower driver,
>    firstly partial complete 512KB with error,
>    secondly partial complete 512KB without error
> 4. The I/O should complete successfully.

It will be returned to the upper layer after the first completion
as mentioned in my previous mail.  Same for the other test.

Think of partial completion as a way for SCSI targets to chunk
transfers, higher layers will only see full success/failure cases.

For that reason we also removed the bytes completed argument to
->bi_end_io because the callers should not care about these details.
