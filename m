From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] offload bios to a thread
Date: Thu, 30 Jun 2016 19:15:18 -0400
Message-ID: <20160630231518.GA22518@redhat.com>
References: <alpine.LRH.2.02.1606282014380.7298@file01.intranet.prod.int.rdu2.redhat.com>
	<20160630194023.GA21338@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160630194023.GA21338@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Thu, Jun 30 2016 at  3:40pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> [cc'ing linux-block and drbd folks]
> 
> On Tue, Jun 28 2016 at  8:16pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > Here I'm sending three patches to fix the deadlocks in snapshot and 
> > snapshot-merge.
> > 
> > The first patch fixes the deadlock, the following 2 patches introduce a 
> > timer, so that bios are not offloaded immediatelly, they are offloaded 
> > after a specified timeout, because immediate offloading can change order 
> > of bios and it could theoretically produce regressions. I don't know if 
> > these regressions really exist or not.
> > 
> > If there is some way to push the patches upstream, try it.
> 
> Some fix must happen before the more recent upstream kernels can be
> reliably used in stacked bio-based workloads (in production).  We simply
> cannot ignore this issue any more.
> 
> drbd is also hitting the same generic_make_request (current->bio_list)
> problem, see:
> https://www.redhat.com/archives/dm-devel/2016-June/msg00326.html
> 
> Mikulas, I've taken your 3 proposed patches patches and refactored them
> some to split out intermediate patches that hopefully make review
> easier.  Nothing other than variable names and some other style stuff
> was changed -- headers were tweaked some to help with clarity.
> 
> Please see the 5 topmost "block: ..." patches here:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> 
> It should be noted that Jens had a quick look at this set and wanted to
> throw up a little when he saw the (ab)use of a timer to defer punting to
> the workqueue.  I explained that without the timer, always punting to
> the workqueue, we could hurt performance by reordering IO or crippling
> onstack plugging.  He said he'd try to think of a cleaner way forward.
> 
> Lars, please feel free to see if this set addresses the similar deadlock
> you saw/fixed with drbd.  We need to converge on an acceptable fix for
> this problem -- preferably sooner rather than later!
> 
> Conversely, Mikulas: if you can easily reproduce the dm-snapshot
> deadlock please try Lars' fix to see if it is workable for our DM needs.

I hadn't reviewed Lars' patch yet but Mikulas pointed out to me that
Lars' patch is focused on the blk_queue_split() path -- and given that
DM doesn't use this function (nor do DM devices even have a 'bio_split'
bioset, see commit dbba42d8a9e) it won't fix the DM (snapshot) deadlock.
