From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH] crash in dm-io when signal is pending
Date: Tue, 27 Jan 2009 15:50:57 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901271540420.32171@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901212203090.31606@hs20-bc2-1.build.redhat.com>
	<20090123105744.GV9859@agk.fab.redhat.com>
	<Pine.LNX.4.64.0901231444270.5179@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0901231444270.5179@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 23 Jan 2009, Mikulas Patocka wrote:

> On Fri, 23 Jan 2009, Alasdair G Kergon wrote:
> 
> > On Wed, Jan 21, 2009 at 10:04:39PM -0500, Mikulas Patocka wrote:
> > > If someone sends signal to a process performing synchronous dm-io call,
> > > the kernel may crash.
> >  
> > > There is no way to cancel in-progress IOs, so the best solution is to ignore
> > > signals at this point.
> >  
> > So what is the impact of this patch at a higher level?
> 
> Avoid crash if the admin kills lvm or dmsetup with SIGKILL at a certain 
> point.
> 
> AFAIK lvm blocks all the blockable signals while it is performing critical 
> operations, so there should be no crash from pressing ^C, terminal loss or 
> so.
> 
> > - What userspace operations are there that you can interrupt now, but that
> > after this patch you won't be able to?
> 
> When I grepped for interruptible sleep, I found one another possibility: 
> aborting a suspend with signal. I didn't find crash condition that could 
> be caused by this, but it could unfortunatelly confuse targets.
> 
> If suspend is aborted this way, presuspend method is called, but 
> postsuspend, preresume and resume isn't --- this will confuse target 
> drivers --- you end up with an active mirror that stopped recovering or 
> active snapshot that stopped merging.
> 
> I don't know if aborting suspend this way should be allowed or not.
> 
> > (Are there any situations where the io will not complete without a reboot,
> > that could actually be safe today?)
> 
> If the io will not complete, you can't reboot with normal reboot script. 
> Unmount/remount-ro waits for ios on a filesystem to complete, so they will 
> deadlock.
> 
> Mikulas
> 
> > Alasdair
> > -- 
> > agk@redhat.com

Regarding the other possibilities you suggested on the phone call:

There are main architectural design decisions that can't be changed 
without major code rewrite:
- submitted bio can't be cancelled
- the device must not be closed when some bios are submitted on it

So, if the function sync_io() was modified so that the structure would be 
allocated with kmalloc and wouldn't be on stack (so that the function 
could be interrupted and exit while bios are still pending), we would have 
to somehow make sure be that the device wouldn't be closed until all the 
bios finish.

So there would be no benefit for the user --- the user still wouldn't be 
able to interrupt target contructor --- because in the error path, devices 
are closed and these close calls would have to wait for the interrupted 
bio to finish. And there would be major code blow coming from the fact 
that these interrupted bios would have to be tracked somehow and 
dm_put_device would have to wait for them.

So the best solution is to make dm-io ios uninterruptible.

Mikulas
