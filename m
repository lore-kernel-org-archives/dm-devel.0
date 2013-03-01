From: Hannes Reinecke <hare@suse.de>
Subject: BUG: sleeping function called during table_load()
Date: Fri, 01 Mar 2013 09:12:48 +0100
Message-ID: <51306300.40309@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

during booting 3.8.0 I hit this:

BUG: sleeping function called from invalid context at =

kernel/rcutree.c:2208
in_atomic(): 1, irqs_disabled(): 0, pid: 1976, name: multipath
Pid: 1976, comm: multipath Not tainted 3.8.0-default+ #18
Call Trace:
  [<ffffffff81078289>] __might_sleep+0xd9/0x100
  [<ffffffff810e2f9c>] synchronize_sched+0x2c/0x80
  [<ffffffff812e496f>] blk_queue_bypass_start+0x7f/0x90
  [<ffffffff812fa8bd>] blkcg_activate_policy+0x8d/0x290
  [<ffffffff812fef0f>] cfq_init_queue+0x6f/0x340
  [<ffffffff812deec5>] elevator_init+0x85/0x120
  [<ffffffffa022ec40>] ? dm_lld_busy+0x60/0x60 [dm_mod]
  [<ffffffff812e43f8>] blk_init_allocated_queue+0xa8/0xc0
  [<ffffffffa022c61c>] dm_setup_md_queue+0x3c/0xc0 [dm_mod]
  [<ffffffffa02336a2>] table_load+0x1c2/0x330 [dm_mod]
  [<ffffffffa0234929>] ctl_ioctl+0x1d9/0x270 [dm_mod]
  [<ffffffffa02334e0>] ? table_clear+0x80/0x80 [dm_mod]
  [<ffffffffa02349ce>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
  [<ffffffff8119262d>] do_vfs_ioctl+0x9d/0x380
  [<ffffffff81181bc4>] ? fput+0x74/0xc0
  [<ffffffff811929a1>] sys_ioctl+0x91/0xb0
  [<ffffffff815ce469>] system_call_fastpath+0x16/0x1b

and several others of that ilk.
System itself doesn't seem to be affected, but we might want to look =

into it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
