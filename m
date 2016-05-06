From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
	interface	accessible again
Date: Fri, 6 May 2016 17:46:56 +0100
Message-ID: <20160506164655.GC19687@rh-vpn>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de> <20160506155633.GA7318@lst.de>
	<20160506161915.GA905@redhat.com> <20160506162705.GA7999@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506162705.GA7999@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 06:27:05PM +0200, Christoph Hellwig wrote:
> On Fri, May 06, 2016 at 12:19:16PM -0400, Mike Snitzer wrote:
> > (this is a direct result of completing the discard bio before all
> > mappings, and associated sub-discards, have):
> 
> The completion order really should not matter, we rely on it not
> mattering for almost every usage of the bio_chain API.  So there
> is something else fishy going on here.  What's your test case?
> I'd like to dig a bit deeper into this.

Completion order isn't important.  The issue we have is there are two
levels of fragmentation that we see with thinp.

First a large discard (eg, mkfs) comes in.  We then break this up into
mapped regions.  Then each region is quiesced individually.  Once
quiesced we then can discard the region, with the extra twist that we
can't discard any areas that are shared between snapshots.  The
patches Mike posted switch to use your new bio_chain/blk_issue_thing
(which I like btw) on the bottom level (ie, each region).  So we need
some form of ref counting to work out when all the mid level regions
are complete and hence we can complete the original bio.

It's not rocket science, and is generating far more discussion than is
neccessary.  If I can't piggy back on the bio's ref count, I'll create
my own.

- Joe
