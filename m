From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: awful request merge results while simulating high
	IOPS multipath
Date: Wed, 25 Feb 2015 17:10:47 -0500
Message-ID: <20150225221047.GA22281@redhat.com>
References: <54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
	<54EDE62D.7010308@kernel.dk>
	<B58D82457FDA0744A320A2FC5AC253B93BA8BF21@fmsmsx104.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B58D82457FDA0744A320A2FC5AC253B93BA8BF21@fmsmsx104.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Busch, Keith" <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, jmoyer@redhat.com, shivakrishna.merla@netapp.com, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Wed, Feb 25 2015 at  1:17pm -0500,
Busch, Keith <keith.busch@intel.com> wrote:

> Sorry, my reply was non sequitur to this thread. We don't do merging
> in NVMe.

NVMe may not but current dm-multipath's top-level queue will.  And any
future blk-mq enabled dm-multipath (which I'm starting to look into now)
will need to also.

> Our first bottleneck appears to be the device mapper's single lock
> request queue.

Obviously if we switched dm-multipath over to blk-mq we'd eliminate
that.  I'll see how things go and will share any changes I come up
with.

FYI, here is a related exchange Jens and I had on the LSF-only mailing
list:

On Tue, Feb 24 2015 at  1:43pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 02/24/2015 10:37 AM, Mike Snitzer wrote:
>
> >I agree.  I'd hate to be called up front to tap dance around some yet to
> >be analyzed issue.  But discussing the best way to update multipath for
> >blk-mq devices is fair game.
> >
> >As is, the current blk-mq code doesn't have any IO scheduler so the
> >overall approach that DM multipath _attempts_ to take (namely leaning on
> >the elevator to create larger requests that are then balanced across the
> >underlying paths) is a non-starter.
> 
> No it isn't, blk-mq still provides merging, the logic would very
> much be the same there... I think the crux of the problem is the way
> too frequent queue runs, that'd similarly be a problem on the blk-mq
> front.
> 
> -- 
> Jens Axboe
> 
