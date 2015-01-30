From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]X
Date: Thu, 29 Jan 2015 19:32:01 -0500
Message-ID: <20150130003201.GA25136@redhat.com>
References: <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
	<54C91172.10002@kernel.dk> <20150128174442.GA11951@redhat.com>
	<54C92127.4030408@kernel.dk>
	<alpine.LNX.2.00.1501292233230.15481@localhost.lm.intel.com>
	<20150129230924.GA24657@redhat.com>
	<alpine.LNX.2.00.1501292310330.15481@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501292310330.15481@localhost.lm.intel.com>
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

On Thu, Jan 29 2015 at  6:44pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Thu, 29 Jan 2015, Mike Snitzer wrote:
> >On Thu, Jan 29 2015 at  5:43pm -0500,
> >>One of my commits relocated the initialization, but I didn't realize it
> >>had a hard dependency on the follow-on commit.  Should we reorder that
> >>part of the series?
> >
> >Which follow on commit are you referring to?  Please be specific about
> >which commits you think are out of order.
> >
> >Also, what are you testing... are you using the linux-dm.git tree's
> >'dm-for-3.20' branch which builds on Jens' 'for-3.20/core'?
> >
> >If not please test that and see if you still have problems (without the
> >associated DM changes all the block preparation changes that Jens
> >cherry-picked shouldn't cause any problems at all).
> 
> I'm using Jens' linux-block for-3.20/core branch. The last dm commit
> is this:
> 
>  commit febf71588c2a750e04dc2a8b0824ce120c48bd9e
>  Author: Keith Busch <keith.busch@intel.com>
>  Date:   Fri Oct 17 17:46:35 2014 -0600
> 
>     block: require blk_rq_prep_clone() be given an initialized clone request
> 
> Looking at this again, the above was incorrect in the first place: it
> initialized the original, but the intent was to initialize the clone. This
> slipped by me since the next part of the series fixed it. In your linux-dm
> dm-for-3.20, it's this commit:
> 
>  commit 102e38b1030e883efc022dfdc7b7e7a3de70d1c5
>  Author: Mike Snitzer <snitzer@redhat.com>
>  Date:   Fri Dec 5 17:11:05 2014 -0500
> 
>      dm: split request structure out from dm_rq_target_io structure
> 
> 
> So I was confused earlier, there's no need to reorder anything. I just
> need to fix the broken part.

Oof, yeah that first commit should be using: blk_rq_init(NULL, clone);

Jens, any chance you could rebase commit febf71588c2a with s/rq/clone/
in dm.c:clone_rq's call to blk_rq_init?
