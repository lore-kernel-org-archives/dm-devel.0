From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
	dm-multipath
Date: Wed, 7 May 2014 16:53:33 -0400
Message-ID: <20140507205333.GA29666@redhat.com>
References: <5368ABE8.9050909@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5368ABE8.9050909@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Bart,

On Tue, May 06 2014 at  5:31am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> Hello,
> 
> Has anyone else perhaps already run into this ?
> 
> Thanks,
> 
> Bart.
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.15.0-rc4-debug+ #1 Not tainted
> -------------------------------------------------------
> multipathd/10364 is trying to acquire lock:
>  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
> 
> but task is already holding lock:
>  (&(&m->lock)->rlock){..-...}, at: [<ffffffffa077a647>] queue_if_no_path+0x27/0xc0 [dm_multipath]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&(&m->lock)->rlock){..-...}:
>        [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>        [<ffffffff814ae8eb>] _raw_spin_lock+0x3b/0x50
>        [<ffffffffa043a3e9>] dm_blk_open+0x19/0x80 [dm_mod]
>        [<ffffffff811cbc41>] __blkdev_get+0xd1/0x4c0
>        [<ffffffff811cc215>] blkdev_get+0x1e5/0x380
>        [<ffffffff811cc45b>] blkdev_open+0x5b/0x80
>        [<ffffffff8118a12e>] do_dentry_open.isra.15+0x1de/0x2a0
>        [<ffffffff8118a300>] finish_open+0x30/0x40
>        [<ffffffff8119c44d>] do_last.isra.61+0xa5d/0x1200
>        [<ffffffff8119cca7>] path_openat+0xb7/0x620
>        [<ffffffff8119d88a>] do_filp_open+0x3a/0x90
>        [<ffffffff8118bb4e>] do_sys_open+0x12e/0x210
>        [<ffffffff8118bc4e>] SyS_open+0x1e/0x20
>        [<ffffffff814b84e2>] tracesys+0xd0/0xd5

I'm not sure what lockdep is trying to communicate for #1 here.  Not
seeing where m->lock is taken in the above stack.  Nor does it appear to
take q->queue_lock.

> -> #0 (&(&q->__queue_lock)->rlock){-.-...}:
>        [<ffffffff810a4c46>] __lock_acquire+0x1716/0x1a00
>        [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>        [<ffffffff814aea56>] _raw_spin_lock_irqsave+0x46/0x60
>        [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>        [<ffffffffa077a692>] queue_if_no_path+0x72/0xc0 [dm_multipath]
>        [<ffffffffa077a6f9>] multipath_presuspend+0x19/0x20 [dm_multipath]
>        [<ffffffffa043d34a>] dm_table_presuspend_targets+0x4a/0x60 [dm_mod]
>        [<ffffffffa043ad5d>] dm_suspend+0x6d/0x1f0 [dm_mod]
>        [<ffffffffa043ff63>] dev_suspend+0x1c3/0x220 [dm_mod]
>        [<ffffffffa0440759>] ctl_ioctl+0x269/0x500 [dm_mod]
>        [<ffffffffa0440a03>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>        [<ffffffff811a04c0>] do_vfs_ioctl+0x300/0x520
>        [<ffffffff811a0721>] SyS_ioctl+0x41/0x80
>        [<ffffffff814b84e2>] tracesys+0xd0/0xd5
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&m->lock)->rlock);
>                                lock(&(&q->__queue_lock)->rlock);
>                                lock(&(&m->lock)->rlock);
>   lock(&(&q->__queue_lock)->rlock);
> 
>  *** DEADLOCK ***

I'm not seeing where q->queue_lock is held before m->lock is taken.

I did find that multipath_ioctl() does _not_ hold m->lock when calling
dm_table_run_md_queue_async() -- the other callers hold m->lock.

Any chance you can see if this patch silences lockdep?

--
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa009e8..fa0f6cb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1566,8 +1566,8 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 		}
 		if (m->pg_init_required)
 			__pg_init_all_paths(m);
-		spin_unlock_irqrestore(&m->lock, flags);
 		dm_table_run_md_queue_async(m->ti->table);
+		spin_unlock_irqrestore(&m->lock, flags);
 	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
