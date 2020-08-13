From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RESEND PATCH] nvme: explicitly use normal NVMe
 error handling when appropriate
Date: Thu, 13 Aug 2020 15:03:42 -0400
Message-ID: <20200813190342.GA6607@redhat.com>
References: <20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com>
	<20200810172209.GA19535@redhat.com>
	<20200813144811.GA5452@redhat.com>
	<20200813153623.GA30905@infradead.org>
	<20200813174704.GA6137@redhat.com>
	<20200813184349.GA8191@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200813184349.GA8191@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>, "Meneghini, John" <John.Meneghini@netapp.com>
List-Id: dm-devel.ids

On Thu, Aug 13 2020 at  2:43pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Aug 13, 2020 at 01:47:04PM -0400, Mike Snitzer wrote:
> > This is just a tweak to improve the high-level fault tree of core NVMe
> > error handling.  No functional change, but for such basic errors,
> > avoiding entering nvme_failover_req is meaningful on a code flow level.
> > Makes code to handle errors that need local retry clearer by being more
> > structured, less circuitous.
> > 
> > Allows NVMe core's handling of such errors to be more explicit and live
> > in core.c rather than multipath.c -- so things like ACRE handling can be
> > made explicitly part of core and not nested under nvme_failover_req's
> > relatively obscure failsafe that returns false for anything it doesn't
> > care about.
> 
> If we're going that way I'd rather do something like the (untested)
> patch below that adds a dispostion function with a function that
> decides it and then just switches on it:

YES!  That is such a huge improvement (certainly on a code clarity
level).  I haven't reviewed or tested the relative performance or
function of before vs after (will do) but I really like this approach.

Thanks,
Mike
