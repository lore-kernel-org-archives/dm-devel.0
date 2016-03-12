From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath performance patches
Date: Sat, 12 Mar 2016 08:45:54 -0500
Message-ID: <20160312134554.GA22280@redhat.com>
References: <56DE81B5.80001@suse.de> <20160308144842.GA13283@redhat.com>
	<56DEEF4B.2040501@suse.de> <20160308174038.GA13843@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160308174038.GA13843@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08 2016 at 12:40pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Mar 08 2016 at 10:27am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > On 03/08/2016 03:48 PM, Mike Snitzer wrote:
> > > On Tue, Mar 08 2016 at  2:39am -0500,
> > > Hannes Reinecke <hare@suse.de> wrote:
> > > 
> > >> Hi Mike,
> > >>
> > >> to picking up an old topic, what's the status of your performance
> > >> patches for dm-multipath?
> > >>
> > >> I've started looking a branch 'devel3', and was wondering if these
> > >> are the latest patches available.
> > >> Or would you have newer?
> > > 
> > > The 'devel3' was just a temporary branch I was using during
> > > development.  I've since staged all the changes in linux-next via
> > > linux-dm.git's 'for-next' branch:
> > > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> > > 
> > > If you could test this 'for-next' and report back I'd appreciate it.
> > > It'd build my confidence in pushing these changes once the 4.6 merge
> > > window opens.
> > > 
> > > That said, these changes have held up to Junichi's test suite.  WHich
> > > I've now staged here (until I get around to porting them over to
> > > device-mapper-test-suite): https://github.com/snitm/mptest
> > > 
> > > As for code review, please have a good look at this commit:
> > >    b3c39bf1d dm mpath: convert from spinlock to RCU for most locking
> > > 
> > > If you find anything feel free to share an incremental fix and I'll get
> > > it reviewed/staged.
> > > 
> > > (Junichi I'd welcome your review of all these request-based DM core and
> > > multipath changes too)
> > > 
> > Right.
> > 
> > Looks like it's essential the same as the devel3 branch, so here
> > hare some general comments:
> > 
> > - It _really_ has a creative RCU usage. From my understanding, RCU
> > is protecting access to the _pointer_, not the structure pointed to.
> > IOW changing fields in an RCU-proctected structure are not
> > necessarily visible to other CPUs, and I'm not sure if
> > synchronize_rcu() is sufficient here.
> > I'd be the first to admit that I'm no expert here, but I really
> > would like to have an explanation if one can do that.
> 
> I understand your concern and do share it.  I'm no expert here either.
> 
> It was my understanding that dereferences of the pointer trigger the
> read/write side of the RCU.  And by-virtue of the write-side having
> exclussive access (after grace period, etc) the concurrent reads should
> be consistent.
> 
> You'll note that all writes to the 'struct multipath_paths' members are
> made while holding the m->lock.  I'd have thought visibility of any
> writes from other CPUs is moot -- primarily because any reads of those
> 'struct multipath_paths' state flags or unsigned counters should be
> effectively atomic (due to read vs write side I touched on above).  But
> in practice a suppose it possible for a cpu to see incorrect values.
> 
> Explicit use of atomic_t for the counters and bitsets (with atomic
> test_bit, set_bit) would be best.
> 
> > - I've got some patches moving the bitfields into bitops, and use
> > atomic_t for counters. With that I guess we can get rid of most of
> > the creative RCU usage as we can use smp_mb__(after|before)_atomic()
> > with the same results.
> > That also enables us to get rid of the spinlock in most cases.
> 
> The use of bitops implies the use of a spinlocks (see
> _atomic_spin_lock_irqsave and _atomic_spin_unlock_irqrestore) but I have
> to assume that it shouldn't be a bottleneck.
> 
> Please rebase those changes ontop of 'for-next'.  I really don't think
> my changes and yours are mutually exclussive.

After further review, from Jeff Moyer, and some introspection I've
decided to drop the commits that factor out 'struct multipath_paths' and
switch to using RCU for the 4.6 merge window.  My RCU changes (while not
obviously broken) were overly complex.  To the point that I'd rather
avoid the potential for difficult/subtle dm-mpath bugs in production.

As such, please rebase your bitops and atomic_t changes (hopefully those
are 2 separate commits) ontop of linux-dm.git's 'for-next'.  I'd like us
to be able to tackle dm-multipath's NUMA scalability issues in time for
the 4.7 merge window -- but develop the changes _now_.

Thanks,
Mike
