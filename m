From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]X
Date: Thu, 29 Jan 2015 18:09:24 -0500
Message-ID: <20150129230924.GA24657@redhat.com>
References: <alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
	<54C91172.10002@kernel.dk> <20150128174442.GA11951@redhat.com>
	<54C92127.4030408@kernel.dk>
	<alpine.LNX.2.00.1501292233230.15481@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501292233230.15481@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Thu, Jan 29 2015 at  5:43pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Wed, 28 Jan 2015, Jens Axboe wrote:
> >On 01/28/2015 10:44 AM, Mike Snitzer wrote:
> >>On Wed, Jan 28 2015 at 11:42am -0500,
> >>Jens Axboe <axboe@kernel.dk> wrote:
> >>>I'd prefer to take these prep patches through the block tree.
> >>
> >>Great, should I send the patches or can you cherry-pick?
> >
> >I already cherry picked them, they are in the for-3.20/core branch.
> 
> I might be getting ahead of myself for trying this right now (sorry if
> that's the case) but 'for-3.20/core' is missing necessary parts of the
> series and hits a BUG_ON at blk-core.c:2333. The original request is
> initialized when setting up the clone, and in this branch, that happens
> in prep_fn before the request was dequeued so it's not in the queuelist
> when it started.
> 
> One of my commits relocated the initialization, but I didn't realize it
> had a hard dependency on the follow-on commit.  Should we reorder that
> part of the series?

Which follow on commit are you referring to?  Please be specific about
which commits you think are out of order.

Also, what are you testing... are you using the linux-dm.git tree's
'dm-for-3.20' branch which builds on Jens' 'for-3.20/core'?

If not please test that and see if you still have problems (without the
associated DM changes all the block preparation changes that Jens
cherry-picked shouldn't cause any problems at all).
