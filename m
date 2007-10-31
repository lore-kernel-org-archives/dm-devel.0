From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm: bounce_pfn limit added
Date: Wed, 31 Oct 2007 02:01:33 +0000
Message-ID: <20071031020133.GL10006@agk.fab.redhat.com>
References: <47257E4B.4080904@sw.ru>
	<20071030131138.3ba59731.akpm@linux-foundation.org>
	<20071030232617.GJ10006@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071030232617.GJ10006@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Averin <vvs@sw.ru>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, devel@openvz.org
List-Id: dm-devel.ids

On Tue, Oct 30, 2007 at 11:26:17PM +0000, Alasdair G Kergon wrote:
> ) DM doesn't need to bounce bio's on its own, but the block layer defaults
> ) to that in blk_queue_make_request(). The lower level drivers should
> ) bounce ios themselves, that is what they need to do if not layered below
> ) dm anyways.

So currently we treat bounce_pfn as a property that does not need to be
propagated through the stack.

But is that the right approach?
- Is there a blk_queue_bounce() missing either from dm or elsewhere?
  (And BTW can the bio_alloc() that lurks within lead to deadlock?)

Firstly, what's going wrong?
- What is the dm table you are using?  (output of 'dmsetup table')
  - Which dm targets and with how many underlying devices?
- Which underlying driver?
- Is this direct I/O to the block device from userspace, or via some
filesystem or what?

Presumably you've shown the problem goes away when the dm device is
removed from the stack.
What if you swap in alternative dm targets, e.g. if it's linear,
try multipath (round-robin, one path)?
 
Alasdair
-- 
agk@redhat.com
