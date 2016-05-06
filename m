From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
	interface	accessible again
Date: Fri, 6 May 2016 18:43:02 +0200
Message-ID: <20160506164302.GA8332@lst.de>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de> <20160506155633.GA7318@lst.de>
	<20160506161915.GA905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506161915.GA905@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Ok, I think I understand the problem now - the problem is when
break_up_discard_bio does not actually call pool->process_prepared
_discard directly, but instead defers it to a worker thread.  At that
point we might have already completed all the chained bios and
the original one by the time we run another instance of
process_discard_cell_passdown.

So I guess we'll have to live with this for now.  I really don't
like it very much, and the comments could use a massive improvement,
but instead of duplicating the code let's just export the helper:

Acked-by: Christoph Hellwig <hch@lst.de>
