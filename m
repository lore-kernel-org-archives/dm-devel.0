From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-thinp: report correct optimal I/O size
Date: Thu, 28 Apr 2011 04:42:24 -0400
Message-ID: <20110428084223.GB32658@infradead.org>
References: <20110427134150.GA15413@infradead.org>
	<1303925125.7049.9.camel@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1303925125.7049.9.camel@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: ejt@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 27, 2011 at 06:25:25PM +0100, Joe Thornber wrote:
> tc->block_size is in sectors (you are passing sectors on the target
> line?).
> 
> What's probably happening here is we should be doing:
> 
> blk_limits_io_opt(limits, min(<some theoretical max>, tc->block_size << SECTOR_SHIFT));

Yes, that should do it.  I don't even think we need the max, the optimum
I/O size is a 32-bit value and we'll reach the limit of the possible
block sizes much earlier.
