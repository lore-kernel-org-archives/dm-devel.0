From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Thu, 21 Jan 2016 14:44:06 -0500
Message-ID: <20160121194405.GA22766@redhat.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikolay Borisov <n.borisov@siteground.com>, Dennis Yang <shinrairis@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> > Dne 20.1.2016 v 11:05 Dennis Yang napsal(a):
> >>
> >> Hi,
> >>
> >> I had noticed that I/O requests to one thin device will be blocked
> >> when the other thin device is being deleting. The root cause of this
> >> is that to delete a thin device will eventually call dm_btree_del()
> >> which is a slow function and can block. This means that the device
> >> deleting process will need to hold the pool lock for a very long time
> >> to wait for this function to delete the whole data mapping subtree.
> >> Since I/O to the devices on the same pool needs to held the same pool
> >> lock to lookup/insert/delete data mapping, all I/O will be blocked
> >> until the delete process finish.
> >>
> >> For now, I have to discard all the mappings of a thin device before
> >> deleting it to prevent I/O from being blocked. Since these discard
> >> requests not only take lots of time to finish but hurt the pool I/O
> >> throughput, I am still looking for other better solutions to fix this
> >> issue.
> >>
> >> I think the main problem is still the big pool lock in dm-thin which
> >> hurts both the scalability and performance of. I am wondering if there
> >> is any plan on improving this or any better fix for the I/O block
> >> problem.

Just so I'm aware: which kernel are you using?

dm_pool_delete_thin_device() takes pmd->root_lock so yes it is very
coarse-grained; especially when you consider concurrent IO to another
thin device from the same pool will call interfaces, like
dm_thin_find_block(), which also take the same pmd->root_lock.

It should be noted that the discard performance has improved
considerably with the range discard support (which really didn't
stabilize until Linux 4.4) and then even more improvement in Linux 4.5
with commits like:
3d5f6733 ("dm thin metadata: speed up discard of partially mapped volumes")

> On Wed, Jan 20, 2016 at 1:27 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> > Hi
> >
> > What is your use case.
> >
> > You may possibly split the load between several thin-pools ?
> >
> > Current design is not targeted to simultaneously maintain very large number
> > of active thin-volumes within a single thin-pool.

We have some systemic coarse-grained locking for sure (making things
like device deletion vs normal IO problematic) but if we're talking pure
concurrent IO to many thin devices backed by the same thin-pool we
really should perform reasonably well.

On Thu, Jan 21 2016 at 12:33pm -0500,
Nikolay Borisov <n.borisov@siteground.com> wrote:
 
> Sorry of the offtopic, but what would constitute a "Very large number"
> - 100, 1000s?

TBD really.  Like I said above concurrent IO shouldn't hit locks like
the pool metadata lock (pmd->root_lock) _that_ hard.  But if that IO is
competing with device discard or delete operations then it'll be a
different story.

As it happens I just attended a meeting that emphasized the requirement
to scale to 100s or even 1000 thin devices within a single pool.  So
while there certainly could be painfully pathological locking
bottlenecks that have yet to be exposed I'm fairly confident we'll be
identifying them soon enough.

Any perf-report tool traces that illustrate realized thin-pool
performance bottlenecks are always appreciated.

Mike
