From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thinp: report correct optimal I/O size
Date: Thu, 28 Apr 2011 09:47:33 +0100
Message-ID: <1303980453.2483.2.camel@ubuntu>
References: <20110427134150.GA15413@infradead.org>
	<1303925125.7049.9.camel@ubuntu> <20110428084223.GB32658@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110428084223.GB32658@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, 2011-04-28 at 04:42 -0400, Christoph Hellwig wrote:
> On Wed, Apr 27, 2011 at 06:25:25PM +0100, Joe Thornber wrote:
> > tc->block_size is in sectors (you are passing sectors on the target
> > line?).
> > 
> > What's probably happening here is we should be doing:
> > 
> > blk_limits_io_opt(limits, min(<some theoretical max>, tc->block_size << SECTOR_SHIFT));
> 
> Yes, that should do it.  I don't even think we need the max, the optimum
> I/O size is a 32-bit value and we'll reach the limit of the possible
> block sizes much earlier.

I'm tempted to just say min(16M, tc->block_size << SECTOR_SHIFT).  Does
this sound reasonable to you?
