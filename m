From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: corruption causing crash in __queue_work
Date: Sat, 12 Dec 2015 13:49:50 +0200
Message-ID: <566C09DE.9020802@siteground.com>
References: <566819D8.5090804@kyup.com>
 <20151209160803.GK30240@mtj.duckdns.org> <56685573.1020805@kyup.com>
 <20151209162744.GN30240@mtj.duckdns.org> <566945A2.1050208@kyup.com>
 <20151210152901.GR30240@mtj.duckdns.org> <566AF262.8050009@kyup.com>
 <20151211170805.GT30240@mtj.duckdns.org>
 <CAJFSNy6XgnQJrZCJd-+V9j510P+AWF76btQq3wEg4-VpjAZjFw@mail.gmail.com>
 <20151211191400.GA24229@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151211191400.GA24229@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Nikolay Borisov <kernel@kyup.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 12/11/2015 09:14 PM, Mike Snitzer wrote:
> On Fri, Dec 11 2015 at  1:00pm -0500,
> Nikolay Borisov <n.borisov@siteground.com> wrote:
> 
>> On Fri, Dec 11, 2015 at 7:08 PM, Tejun Heo <tj@kernel.org> wrote:
>>>
>>> Hmmm... No idea why it didn't show up in the debug log but the only
>>> way a workqueue could be in the above state is either it got
>>> explicitly destroyed or somehow pwq refcnting is messed up, in both
>>> cases it should have shown up in the log.
>>>
>>> cc'ing dm people.  Is there any chance dm-thinp could be using
>>> workqueue after destroying it?
> 
> Not that I'm aware of.  But never say never?
> 
> Plus I'd think we'd see other dm-thinp specific use-after-free issues
> aside from the thin-pool's workqueue.
> 
>> In __pool_destroy in dm-thin.c I don't see a call to
>> cancel_delayed_work before destroying the workqueue. Is it possible
>> that this is the causeI
> 
> Cannot see how, __pool_destroy()'s destroy_workqueue() would spew a
> bunch of WARN_ONs (and the wq wouldn't be destroyed) if the workqueue
> had outstanding work.
> 
> __pool_destroy() is called once the thin-pool's ref count drops to 0
> (see __pool_dec which is called when the thin-pool is removed --
> e.g. with 'dmsetup remove').  This code is only reachable when nothing
> else is using the thin-pool.
> 
> And the thin-pool is only able to be removed if all thin devices that
> depend on it have first been removed.  And each individual thin device
> waits for all outstanding IO before they can be removed.

Ok, I had a look at the code closer now and it indeed seems that when
the pool is suspended in its postsuspend callback the delay work is
indeed canceled and the workqueue is being flushed. But given that I see
those failures on at least 2-3 servers perday I doubt it it is a
hardware/machine-specific issue. Furthermore, the fact that it is always
a dm-thin queue that's being referenced points to the direction of
dm-thin, even though the code looks solid in that regard.

Regards,
Nikolay
