From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: recent bdi changes result in WARN_ON on luksClose / dm
Date: Sat, 12 Sep 2009 13:19:28 +0200
Message-ID: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754122AbZILLTc@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

| Orion:/# cryptsetup luksClose crypto
|------------[ cut here ]------------
|WARNING: at /home/bigeasy/git/cryptodev-2.6/mm/backing-dev.c:637 bdi_destroy+0x44/0x60()
|Modules linked in: cbc sha256_generic dm_crypt [last unloaded: mv_cesa]
|[<c0028dd8>] (unwind_backtrace+0x0/0xdc) from [<c003adb0>] (warn_slowpath_common+0x4c/0x80)
|[<c003adb0>] (warn_slowpath_common+0x4c/0x80) from [<c007f2e0>] (bdi_destroy+0x44/0x60)
|[<c007f2e0>] (bdi_destroy+0x44/0x60) from [<c012e3a0>] (blk_release_queue+0x3c/0x54)
|[<c012e3a0>] (blk_release_queue+0x3c/0x54) from [<c01399a8>] (kobject_release+0x5c/0x74)
|[<c01399a8>] (kobject_release+0x5c/0x74) from [<c013a6ac>] (kref_put+0x68/0x7c)
|[<c013a6ac>] (kref_put+0x68/0x7c) from [<c01b7098>] (dm_put+0x148/0x178)
|[<c01b7098>] (dm_put+0x148/0x178) from [<c01bb82c>] (dev_remove+0x98/0xb4)
|[<c01bb82c>] (dev_remove+0x98/0xb4) from [<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c)
|[<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c) from [<c00a153c>] (vfs_ioctl+0x2c/0x8c)
|[<c00a153c>] (vfs_ioctl+0x2c/0x8c) from [<c00a1bac>] (do_vfs_ioctl+0x524/0x590)
|[<c00a1bac>] (do_vfs_ioctl+0x524/0x590) from [<c00a1c50>] (sys_ioctl+0x38/0x5c)
|[<c00a1c50>] (sys_ioctl+0x38/0x5c) from [<c0023e80>] (ret_fast_syscall+0x0/0x2c)
|---[ end trace b3c544a14b51605c ]---

This is on v2.6.31-1335-g86d7101. A bisect between a12e4d3 and 89af571
leads to 
|commit 66f3b8e2e103a0b93b945764d98e9ba46cb926dd
|Author: Jens Axboe <jens.axboe@oracle.com>
|Date:   Wed Sep 2 09:19:46 2009 +0200
|
|    writeback: move dirty inodes from super_block to backing_dev_info
|    
|    This is a first step at introducing per-bdi flusher threads. We should
|    have no change in behaviour, although sb_has_dirty_inodes() is now
|    ridiculously expensive, as there's no easy way to answer that question.
|    Not a huge problem, since it'll be deleted in subsequent patches.
|    
|    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
|
|:040000 040000 08d15594747641d496850833378666fccc301872 9bd487d9aa4778cc2b4faabd94f9e4e378f09ed4 M      fs
|:040000 040000 84292cade24750adfd88aa4ef104209573ea8d7e 986c9bf3552ecc52337c69d62fd39ab67e928f3c M      include
|:040000 040000 8feddafc4d976199f9842b2f138f93e395afc746 d33936f4946f1ff4e4a5c7a7eab226b174d104d8 M      mm

Sebastian
