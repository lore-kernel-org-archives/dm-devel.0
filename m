From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 5/5] dm thin: unroll issue_discard() to
 create longer discard bio chains
Date: Fri, 6 May 2016 17:36:58 +0100
Message-ID: <20160506163657.GA19687@rh-vpn>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-6-git-send-email-snitzer@redhat.com>
	<20160506161216.GC7397@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506161216.GC7397@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 06:12:16PM +0200, Christoph Hellwig wrote:
> On Thu, May 05, 2016 at 11:54:25AM -0400, Mike Snitzer wrote:
> > From: Joe Thornber <ejt@redhat.com>
> > 
> > There is little benefit to doing this but it does structure DM thinp's
> > code to more cleanly use the __blkdev_issue_discard() interface --
> > particularly in passdown_double_checking_shared_status().
> 
> As-is I think it makes the code a whole lot more convoluted, and especially
> the structure that's just used to communicated 4 parameters between
> functions which don't even use all of them isn't very helpful.

I started coding it inline, and then factored it out because I thought
it was cleaner.  I'm also likely to lift it into a separate file for
use in dm-cache too.

> This is a useful helper I think, but passing tc and bio directly would
> make it even more obvious.

y, this is exactly what I had.

> Both the plugging and the bi_error handling would benefit from being
> moved into process_prepared_discard_passdown and handled in the common
> path.

But the plugging and error handling are called from two places.
process_prepared_discard_passdown() and
passdown_double_checking_shared_status().

- Joe

(I agree about the confusing comment, we'll remove)
