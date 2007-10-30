From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm: bounce_pfn limit added
Date: Tue, 30 Oct 2007 23:26:17 +0000
Message-ID: <20071030232617.GJ10006@agk.fab.redhat.com>
References: <47257E4B.4080904@sw.ru>
	<20071030131138.3ba59731.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071030131138.3ba59731.akpm@linux-foundation.org>
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

On Tue, Oct 30, 2007 at 01:11:38PM -0700, Andrew Morton wrote:
> On Mon, 29 Oct 2007 09:31:39 +0300
> Vasily Averin <vvs@sw.ru> wrote:
> > Device mapper uses its own bounce_pfn that may differ from one on underlying
> > device. In that way dm can build incorrect requests that contain sg elements
> > greater than underlying device is able to handle.
> > This is the cause of slab corruption in i2o layer, occurred on i386 arch when
> > very long direct IO requests are addressed to dm-over-i2o device.

Interesting.  When this patch was originally proposed a couple of years ago, we
did this instead:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=daef265f1590cf3e6de989d074041a280c82d58b;hp=00d6da9b4d6707b808481372537adb0fb38f99b3

) DM doesn't need to bounce bio's on its own, but the block layer defaults
) to that in blk_queue_make_request(). The lower level drivers should
) bounce ios themselves, that is what they need to do if not layered below
) dm anyways.

Alasdair
-- 
agk@redhat.com
