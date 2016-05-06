From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
 interface accessible again
Date: Fri, 6 May 2016 17:30:15 +0100
Message-ID: <20160506163015.GA19578@rh-vpn>
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

On Fri, May 06, 2016 at 12:19:16PM -0400, Mike Snitzer wrote:
> As you know not all code is simple.  I've looked at this for quite a bit
> this week and unfortunately I don't see a way forward (yet) that doesn't
> require the use of bio_inc_remaining() to take extra bi_remaining
> references.

Well there is a way around it;  we just maintain our own reference
counter and use that to determine when to complete the original bio.

It just seems a shame when there's a ref count in the bio already.
But if Jens and Christophe are adamant that bio_chain is going to be
the one and only way to access that ref count then I'll allocate
another object to hold the ref count.

- Joe
