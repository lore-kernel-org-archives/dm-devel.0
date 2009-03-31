From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Tue, 31 Mar 2009 12:49:33 +0200
Message-ID: <20090331104933.GJ5178@kernel.dk>
References: <20090324140524.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	<20090324143034.GW27476@kernel.dk>
	<Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	<20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

On Mon, Mar 30 2009, Mikulas Patocka wrote:
> On Thu, 26 Mar 2009, Jens Axboe wrote:
> 
> > On Wed, Mar 25 2009, Mikulas Patocka wrote:
> >
> > > > > So I think there should be flag (this device does/doesn't support data 
> > > > > consistency) that the journaled filesystems can use to mark the disk dirty 
> > > > > for fsck. And if you implement this flag, you can accept barriers always 
> > > > > to all kind of devices regardless of whether they support consistency. You 
> > > > > can then get rid of that -EOPNOTSUPP and simplify filesystem code because 
> > > > > they'd no longer need two commit paths and a clumsy way to restart 
> > > > > -EOPNOTSUPPed requests.
> > > > 
> > > > And my point is that this case isn't interesting, because most setups
> > > > don't guarantee proper ordering.
> > > 
> > > If the ordering isn't guaranteed, the filesystem should know about it, and 
> > > mark the partition for fsck. That's why I'm suggesting to use a flag for 
> > > that. That flag could be also propagated up through md and dm.
> > 
> > We can do that, not a problem. The problem is that ordering is almost
> > never preserved, SCSI does not use ordered tags because it hasn't
> > verified that its error path doesn't reorder by mistake. So right now
> > you can basically use 'false' as that flag.
> 
> There are three ordering guarantees:
> 
> 1. - nothing (for devices with write cache without cache control)
> 
> 2. - non-cached ordering: the sequence [submit req a, end req a, submit 
> req b, end req b] will make the ordering. It is guaranteed that when the 
> request ends successfully, it is on medium. This is what all the 
> filesystems, md and dm assume about disks. This consistency model was used 
> long way before barriers came in.
> 
> 3. - barrier ordering: ordering is done with barriers, [submit req a, end 
> req a, submit req b, end req b] won't guarantee ordering of a and b, a 
> barrier must be inserted.

Plus the barrier also allows [submit req a, submit req b] and still
count on ordering if either one of them is a barrier. It doesn't have to
be sync, like the (2).

> --- so you can make a two bitflags that differentiate these models. In 
> current kernel, model (1) and (2) cannot be differentiated in any way. (3) 
> can be differentiated only after a trial write and it won't guarantee that 
> (3) will be valid further.

But what's the point? Basically no devices are naturally ordered by
default. Either you need cache flushes, or you need to tell the device
not to reorder on a per-command basis.

> > > The reasoning: "write barriers aren't supported => the device doesn't 
> > > guarantee consistency" isn't valid.
> > 
> > It's valid in the sense that it's the only RELIABLE primitive we have.
> > Are you really suggestion that we just assume any device is fully
> > ordered, unless proven otherwise?
> 
> If someone implements "write barrier's aren't supported => run fsck", then 
> a lot of systems start fscking needlessly (for example those using md or 
> dm without write cache) and become inoperational for long time because of 
> that. So no one can really implement this logic and filesystems don't run 
> fsck at all when operated over a device that doesn't support ordering. So 
> you get data corruption if you get crash on those devices.

Nobody is suggesting that, it's just not a feasible approach. But you
have to warn if you don't know whether it provides the ordering
guarantee you expect to provide consistency and integrity.

> > > > The error handling is complex, no doubt
> > > > about that. But the trial barrier test is pretty trivial and even could
> > > > be easily abstracted out. If a later barrier write fails, then that's
> > > > really no different than if a normal write fails. Error handling is not
> > > > easy in that case.
> > > 
> > > I had a discussion with Andi about it some times ago. The conclusion was 
> > > that all the current filesystems handle barriers failing in the middle of 
> > > the operation without functionality loss, but it makes barriers useless 
> > > for any performance-sensitive tasks (commits that wouldn't block 
> > > concurrent activity). Non-blocking commits could only be implemented if 
> > > barriers don't fail.
> > 
> > As long as you do a trial barrier like XFS does, barriers will not fail
> > unless you have media error.
> 
> No.
> 
> The barrier can be cancelled with -EOPNOTSUPP at any time. Andi Kleen 
> submitted a patch that implements failing barriers for device mapper and 
> he says that md-raid1 does the same thing.

You are right, if a device is reconfigured beneath you it may very well
begin to return -EOPNOTSUPP much later. I didn't take that into account,
I was considering only "plain" devices.

> Filesystems handle these randomly failed barriers but the downside is that 
> they must not submit any request concurrently with the barrier. Also, that 
> -EOPNOTSUPP restarting code is really crap, the request cannot be 
> restarted from bi_end_io, so bi_end_io needs to handle to another thread 
> for retry without barrier.

It can, but it requires you to operate at the request level. So for file
systems that is problematic, it wont work of course. It would not be
THAT hard to provide a helper to reissue the request. Not that pretty,
but...

> See this patch: http://lkml.org/lkml/2008/12/4/433 (and associated thread)
> The patch is silly but it just shows what is really hapenning and what the 
> filesystem must be prepared to deal with.

It's not that silly, we should add special barrier failing to the
CONFIG_FAIL stuff. You'd definitely want to exercise that in the file
system.

> > Things would also be much easier, if writes never failed.
> >
> > -- 
> > Jens Axboe
> 
> I definitelly agree that it shouldn't fail. So remove that -EOPNOTSUPP 
> error code at all, make barriers always pass to all kinds of devices and 
> inform the caller via queue flags that the device doesn't support 
> ordering.

Not a queue flag. Make it succeed to get rid of the whole retry
business, but flag the bio with the information anyway.

-- 
Jens Axboe
