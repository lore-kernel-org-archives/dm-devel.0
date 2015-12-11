From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: corruption causing crash in __queue_work
Date: Fri, 11 Dec 2015 14:14:01 -0500
Message-ID: <20151211191400.GA24229@redhat.com>
References: <566819D8.5090804@kyup.com>
 <20151209160803.GK30240@mtj.duckdns.org>
 <56685573.1020805@kyup.com>
 <20151209162744.GN30240@mtj.duckdns.org>
 <566945A2.1050208@kyup.com>
 <20151210152901.GR30240@mtj.duckdns.org>
 <566AF262.8050009@kyup.com>
 <20151211170805.GT30240@mtj.duckdns.org>
 <CAJFSNy6XgnQJrZCJd-+V9j510P+AWF76btQq3wEg4-VpjAZjFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJFSNy6XgnQJrZCJd-+V9j510P+AWF76btQq3wEg4-VpjAZjFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolay Borisov <n.borisov@siteground.com>
Cc: Tejun Heo <tj@kernel.org>, Nikolay Borisov <kernel@kyup.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 11 2015 at  1:00pm -0500,
Nikolay Borisov <n.borisov@siteground.com> wrote:

> On Fri, Dec 11, 2015 at 7:08 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Hmmm... No idea why it didn't show up in the debug log but the only
> > way a workqueue could be in the above state is either it got
> > explicitly destroyed or somehow pwq refcnting is messed up, in both
> > cases it should have shown up in the log.
> >
> > cc'ing dm people.  Is there any chance dm-thinp could be using
> > workqueue after destroying it?

Not that I'm aware of.  But never say never?

Plus I'd think we'd see other dm-thinp specific use-after-free issues
aside from the thin-pool's workqueue.

> In __pool_destroy in dm-thin.c I don't see a call to
> cancel_delayed_work before destroying the workqueue. Is it possible
> that this is the causeI

Cannot see how, __pool_destroy()'s destroy_workqueue() would spew a
bunch of WARN_ONs (and the wq wouldn't be destroyed) if the workqueue
had outstanding work.

__pool_destroy() is called once the thin-pool's ref count drops to 0
(see __pool_dec which is called when the thin-pool is removed --
e.g. with 'dmsetup remove').  This code is only reachable when nothing
else is using the thin-pool.

And the thin-pool is only able to be removed if all thin devices that
depend on it have first been removed.  And each individual thin device
waits for all outstanding IO before they can be removed.
