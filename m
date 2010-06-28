From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard requests
Date: Mon, 28 Jun 2010 14:44:29 +0200
Message-ID: <20100628124429.GA7729@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <4C2896C6.9030607@kernel.dk> <20100628123742.GB19497@redhat.com> <4C28987A.7000701@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C28987A.7000701@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jun 28, 2010 at 02:41:30PM +0200, Jens Axboe wrote:
> The horrible part is working around that issue by fiddling with the
> assignment of the internal vec. THAT looks like a horrible solution
> to that problem.
> 
> How about just adding a check to bio_has_data() for non-zero
> bio->bi_vcnt?

The question is how a discard request from the block layer should look
like.  With Mike's patch we have the same situation as for a barrier
request:  absolutely no data transferred and no indicator of it.  IHMO
that's much better than any partially constructed request.  And yes,
that means enabling the payload later in the driver.

The other option would be to not reuse the request at all and just
allocate a new request and use that from sd_prep_fn.  That's what
I tried to implement first, but I couldn't get it to work.  Given
all the issue we have with the current approach I'm almost tempted
to try that again.
