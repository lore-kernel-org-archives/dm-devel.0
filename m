From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: recent bdi changes result in WARN_ON on luksClose /
	dm
Date: Sat, 12 Sep 2009 22:07:05 +0200
Message-ID: <20090912200704.GI14984@kernel.dk>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
	<20090912195212.GF14984@kernel.dk>
	<20090912195839.GG14984@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090912195839.GG14984@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Sep 12 2009, Jens Axboe wrote:
> On Sat, Sep 12 2009, Jens Axboe wrote:
> > On Sat, Sep 12 2009, Sebastian Andrzej Siewior wrote:
> > > | Orion:/# cryptsetup luksClose crypto
> > > |------------[ cut here ]------------
> > > |WARNING: at /home/bigeasy/git/cryptodev-2.6/mm/backing-dev.c:637 bdi_destroy+0x44/0x60()
> > > |Modules linked in: cbc sha256_generic dm_crypt [last unloaded: mv_cesa]
> > > |[<c0028dd8>] (unwind_backtrace+0x0/0xdc) from [<c003adb0>] (warn_slowpath_common+0x4c/0x80)
> > > |[<c003adb0>] (warn_slowpath_common+0x4c/0x80) from [<c007f2e0>] (bdi_destroy+0x44/0x60)
> > > |[<c007f2e0>] (bdi_destroy+0x44/0x60) from [<c012e3a0>] (blk_release_queue+0x3c/0x54)
> > > |[<c012e3a0>] (blk_release_queue+0x3c/0x54) from [<c01399a8>] (kobject_release+0x5c/0x74)
> > > |[<c01399a8>] (kobject_release+0x5c/0x74) from [<c013a6ac>] (kref_put+0x68/0x7c)
> > > |[<c013a6ac>] (kref_put+0x68/0x7c) from [<c01b7098>] (dm_put+0x148/0x178)
> > > |[<c01b7098>] (dm_put+0x148/0x178) from [<c01bb82c>] (dev_remove+0x98/0xb4)
> > > |[<c01bb82c>] (dev_remove+0x98/0xb4) from [<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c)
> > > |[<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c) from [<c00a153c>] (vfs_ioctl+0x2c/0x8c)
> > > |[<c00a153c>] (vfs_ioctl+0x2c/0x8c) from [<c00a1bac>] (do_vfs_ioctl+0x524/0x590)
> > > |[<c00a1bac>] (do_vfs_ioctl+0x524/0x590) from [<c00a1c50>] (sys_ioctl+0x38/0x5c)
> > > |[<c00a1c50>] (sys_ioctl+0x38/0x5c) from [<c0023e80>] (ret_fast_syscall+0x0/0x2c)
> > > |---[ end trace b3c544a14b51605c ]---
> > 
> > So dm is killing the queue and associated backing device, while dirty
> > inodes still exist. That's not very nice. Perhaps dm_lock_for_deletion()
> > should ensure that the backing is flushed?
> 
> Don't count this as a real fix, I'll investigate closer on monday. Does
> the warning go away with this hack? It'll ensure that pending dirty
> inodes are flushed.

Though I do wonder why we have dirty inodes there, if dm has ensured
that the device has no other openers left. Something to investigate for
monday.

-- 
Jens Axboe
