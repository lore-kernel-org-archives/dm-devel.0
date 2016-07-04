From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/3] offload bios to a thread
Date: Mon, 4 Jul 2016 18:45:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607041838310.16388@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1606282014380.7298@file01.intranet.prod.int.rdu2.redhat.com>
	<20160630194023.GA21338@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, "Alasdair G. Kergon" <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids



On Thu, 30 Jun 2016, Mike Snitzer wrote:

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

I found a problem with the patches when using loop device - we must not 
offload bios to the rescue thread if they are allocated from fs_bio_set. 
I'll send a second version of the patches with this change. You can 
incorporate that change to your git tree.

> It should be noted that Jens had a quick look at this set and wanted to
> throw up a little when he saw the (ab)use of a timer to defer punting to
> the workqueue.  I explained that without the timer, always punting to
> the workqueue, we could hurt performance by reordering IO or crippling
> onstack plugging.  He said he'd try to think of a cleaner way forward.

The behavior depends on the timer only in a situation when the deadlock 
actually happens - the timer doesn't hurt performance on normal use. So, 
it's better to have timed delay in bio processing than a deadlock :)

The timer part can be dropped entirely if someone shows that offloading 
bios on schedule doesn't hurt performance in any way. Does anyone have a 
large collection of block layer performance tests that could be tried to 
detect if the regression happens?

Mikulas
