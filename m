From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 18:45:55 -0500
Message-ID: <20091111234555.GA24019@redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<20091111132056.GA28612@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091111132056.GA28612@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 11 2009 at  8:20am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Nov 10 2009 at  8:16pm -0500,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > Questions:
> > 
> >   Do all the targets correctly flush or push back everything during a
> >   suspend (including workqueues)?
> > 
> >   Do all the targets correctly sync to disk all internal state that
> >   needs to be preserved during a suspend?
> > 
> > In other words, in the case of an already-suspended target, the target
> > 'dtr' functions should only be freeing memory and other resources and
> > not causing I/O to any of the table's devices.
> > 
> > All targets are supposed to be behave this way already, but please
> > would you check the targets with which you are familiar anyway?
> > 
> > Alasdair
> > 
> > 
> > From: Alasdair G Kergon <agk@redhat.com>
> > 
> > When replacing a mapped device's table during a 'resume', delay the
> > destruction of the old table until the new one is successfully in place.
> > 
> > This will make it easier for a later patch to transfer internal state
> > information from the old table to the new one (something we do not currently
> > support) while giving us more options for reversion if a later part
> > of the operation fails.
> 
> I have confirmed that this patch allows handover to work within a single
> device.

Alasdair,

After further testing I've hit a lockdep trace.  My testing was with
handing over on the same device.  I had the snapshot (of an ext3 FS)
mounted and I was doing a sequential direct-io write to a file in the
FS.  While writing I triggered a handover with the following:

echo "0 50331648 snapshot 253:2 253:3 P 8" | dmsetup reload test-testlv_snap
dmsetup resume test-testlv_snap

With that handover worked fine (with no IO errors), but the following
lockdep resulted (some "snapshot_*" tracing was added for context):

snapshot_ctr
snapshot_ctr: found snap_src
snapshot_presuspend

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-rc6-snitm #8
-------------------------------------------------------
dmsetup/1827 is trying to acquire lock:
 (&md->suspend_lock){+.+...}, at: [<ffffffffa00678d8>] dm_swap_table+0x2d/0x249 [dm_mod]

but task is already holding lock:
 (&journal->j_barrier){+.+...}, at: [<ffffffff8119192d>] journal_lock_updates+0xe1/0xf0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&journal->j_barrier){+.+...}:
       [<ffffffff810857b3>] __lock_acquire+0xb6b/0xd13
       [<ffffffff81086396>] lock_release_non_nested+0x1dc/0x23b
       [<ffffffff8108656f>] lock_release+0x17a/0x1a5
       [<ffffffff8139214b>] __mutex_unlock_slowpath+0xce/0x132
       [<ffffffff813921bd>] mutex_unlock+0xe/0x10
       [<ffffffff81147329>] freeze_bdev+0x104/0x110
       [<ffffffffa0069038>] dm_suspend+0x119/0x2a1 [dm_mod]
       [<ffffffffa006db3a>] dev_suspend+0x11d/0x1de [dm_mod]
       [<ffffffffa006e30c>] ctl_ioctl+0x1c6/0x213 [dm_mod]
       [<ffffffffa006e36c>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
       [<ffffffff8112a959>] vfs_ioctl+0x22/0x87
       [<ffffffff8112aec2>] do_vfs_ioctl+0x488/0x4ce
       [<ffffffff8112af5e>] sys_ioctl+0x56/0x79
       [<ffffffff8100bb82>] system_call_fastpath+0x16/0x1b

-> #0 (&md->suspend_lock){+.+...}:
       [<ffffffff8108565d>] __lock_acquire+0xa15/0xd13
       [<ffffffff81085a37>] lock_acquire+0xdc/0x102
       [<ffffffff81392372>] __mutex_lock_common+0x4b/0x37b
       [<ffffffff81392766>] mutex_lock_nested+0x3e/0x43
       [<ffffffffa00678d8>] dm_swap_table+0x2d/0x249 [dm_mod]
       [<ffffffffa006db45>] dev_suspend+0x128/0x1de [dm_mod]
       [<ffffffffa006e30c>] ctl_ioctl+0x1c6/0x213 [dm_mod]
       [<ffffffffa006e36c>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
       [<ffffffff8112a959>] vfs_ioctl+0x22/0x87
       [<ffffffff8112aec2>] do_vfs_ioctl+0x488/0x4ce
       [<ffffffff8112af5e>] sys_ioctl+0x56/0x79
       [<ffffffff8100bb82>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by dmsetup/1827:
 #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff8119192d>] journal_lock_updates+0xe1/0xf0

stack backtrace:
Pid: 1827, comm: dmsetup Not tainted 2.6.32-rc6-snitm #8
Call Trace:
 [<ffffffff81084825>] print_circular_bug+0xa8/0xb7
 [<ffffffff8108565d>] __lock_acquire+0xa15/0xd13
 [<ffffffff81085a37>] lock_acquire+0xdc/0x102
 [<ffffffffa00678d8>] ? dm_swap_table+0x2d/0x249 [dm_mod]
 [<ffffffffa00678d8>] ? dm_swap_table+0x2d/0x249 [dm_mod]
 [<ffffffffa006da1d>] ? dev_suspend+0x0/0x1de [dm_mod]
 [<ffffffff81392372>] __mutex_lock_common+0x4b/0x37b
 [<ffffffffa00678d8>] ? dm_swap_table+0x2d/0x249 [dm_mod]
 [<ffffffff81083933>] ? mark_lock+0x2d/0x22d
 [<ffffffff81083b85>] ? mark_held_locks+0x52/0x70
 [<ffffffff8139219d>] ? __mutex_unlock_slowpath+0x120/0x132
 [<ffffffffa006da1d>] ? dev_suspend+0x0/0x1de [dm_mod]
 [<ffffffff81392766>] mutex_lock_nested+0x3e/0x43
 [<ffffffffa00678d8>] dm_swap_table+0x2d/0x249 [dm_mod]
 [<ffffffff813921bd>] ? mutex_unlock+0xe/0x10
 [<ffffffffa00691ae>] ? dm_suspend+0x28f/0x2a1 [dm_mod]
 [<ffffffffa006da1d>] ? dev_suspend+0x0/0x1de [dm_mod]
 [<ffffffffa006db45>] dev_suspend+0x128/0x1de [dm_mod]
 [<ffffffffa006e30c>] ctl_ioctl+0x1c6/0x213 [dm_mod]
 [<ffffffff81077d7f>] ? cpu_clock+0x43/0x5e
 [<ffffffffa006e36c>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
 [<ffffffff8112a959>] vfs_ioctl+0x22/0x87
 [<ffffffff81083e41>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8112aec2>] do_vfs_ioctl+0x488/0x4ce
 [<ffffffff811f3e5a>] ? __up_read+0x76/0x7f
 [<ffffffff81076746>] ? up_read+0x2b/0x2f
 [<ffffffff8100c635>] ? retint_swapgs+0x13/0x1b
 [<ffffffff8112af5e>] sys_ioctl+0x56/0x79
 [<ffffffff8100bb82>] system_call_fastpath+0x16/0x1b
snapshot_preresume
snapshot_preresume: snap_src is_handover_source
snapshot_preresume: resuming handover-destination
snapshot_resume
snapshot_resume: handing over exceptions
snapshot_dtr
