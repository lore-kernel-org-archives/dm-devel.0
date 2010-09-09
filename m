From: Ryan Harper <ryanh@us.ibm.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based dm]
Date: Thu, 9 Sep 2010 10:44:42 -0500
Message-ID: <20100909154442.GI30086@us.ibm.com>
References: <20100902032246.GA31484@redhat.com> <20100909152658.GA8118@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909152658.GA8118@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, ryanh@us.ibm.com, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

* Mike Snitzer <snitzer@redhat.com> [2010-09-09 10:29]:
> On Wed, Sep 01 2010 at 11:22pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Wed, Sep 01 2010 at  2:59pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > My hope was that the request-based deadlock I'm seeing would disappear
> > > if that relaxed ordering patch wasn't applied.  Unfortunately, I still
> > > see the hang.
> > 
> > Turns out I can reproduce the hang on a stock 2.6.36-rc3 (without _any_
> > FLUSH+FUA patches)!
> > 
> > I'll try to pin-point the root cause but I think my test is somehow
> > exposing a bug in my virt setup.
> 
> [my virt setup == single kvm guest (RHEL6) with F13 host]

What's your kvm guest command line?  And the guest is using stock RHEL6
kernel?  What KVM userspace are you using on the host?  What comes with
F13 or some updated version?


> 
> My gut turned out to be correct.  I finally tracked down the regression
> point to the following commit (cc'ing appropriate people):
> 
> commit a5eb9e4ff18a33e43557d44b205f953b0c1efade
> Author: Ryan Harper <ryanh@us.ibm.com>
> Date:   Wed Jun 23 22:19:57 2010 -0500
> 
>     virtio_blk: Add 'serial' attribute to virtio-blk devices (v2)
>     
>     Create a new attribute for virtio-blk devices that will fetch the serial number
>     of the block device.  This attribute can be used by udev to create disk/by-id
>     symlinks for devices that don't have a UUID (filesystem) associated with them.
>     
>     ATA_IDENTIFY strings are special in that they can be up to 20 chars long
>     and aren't required to be nul-terminated.  The buffer is also zero-padded
>     meaning that if the serial is 19 chars or less that we get a nul-terminated
>     string.  When copying this value into a string buffer, we must be careful to
>     copy up to the nul (if it present) and only 20 if it is longer and not to
>     attempt to nul terminate; this isn't needed.
>     
>     Changes since v1:
>     - Added BUILD_BUG_ON() for PAGE_SIZE check
>     - Removed min() since BUILD_BUG_ON() handles the check
>     - Replaced serial_sysfs() by copying id directly to buffer
>     
>     Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
>     Signed-off-by: john cooper <john.cooper@redhat.com>
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> So the first released kernel to have this regression is 2.6.36-rc1.
> 
> Some background:
> I have been working with Tejun to test the barrier to FLUSH+FUA
> conversion patchset.  I crafted the attached script to test the DM
> changes that are part of the FLUSH+FUA patchset.
> 
> Using this script with:
> while true ; do ./test_dm_discard_mpath_scsi_debug.sh ; done
> 
> I can reliably trigger the following hang, always on the 5th iteration
> in my testing, IFF commit a5eb9e4ff18a33e43557d44b205f953b0c1efade is
> applied:
> 
> INFO: task lvcreate:2484 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> lvcreate      D 0000000100064871  4960  2484   2350 0x00000080
>  ffff88007b87b978 0000000000000046 ffff88007b87b8e8 ffff880000000000
>  ffff88007b87bfd8 ffff8800724fa400 00000000001d4040 ffff88007b87bfd8
>  00000000001d4040 00000000001d4040 00000000001d4040 00000000001d4040
> Call Trace:
>  [<ffffffff8136de23>] io_schedule+0x73/0xb5
>  [<ffffffff811b6882>] get_request_wait+0xf2/0x180
>  [<ffffffff8105d8da>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff811b6deb>] __make_request+0x310/0x434
>  [<ffffffff811b5442>] generic_make_request+0x2f1/0x36e
>  [<ffffffff81062f78>] ? cpu_clock+0x43/0x5e
>  [<ffffffff811b559d>] submit_bio+0xde/0xfb
>  [<ffffffff8106e459>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff81129332>] dio_bio_submit+0x7b/0x9c
>  [<ffffffff8112939d>] dio_send_cur_page+0x4a/0xb0
>  [<ffffffff81129f1c>] __blockdev_direct_IO_newtrunc+0x7c5/0x97d
>  [<ffffffff81127f4f>] blkdev_direct_IO+0x57/0x59
>  [<ffffffff81127080>] ? blkdev_get_blocks+0x0/0x90
>  [<ffffffff810c2eee>] generic_file_aio_read+0xed/0x5b4
>  [<ffffffff810d70d4>] ? might_fault+0x5c/0xac
>  [<ffffffff810242bd>] ? pvclock_clocksource_read+0x50/0xb9
>  [<ffffffff81100813>] do_sync_read+0xcb/0x108
>  [<ffffffff8136e5ad>] ? __mutex_unlock_slowpath+0x119/0x12b
>  [<ffffffff8106e428>] ? trace_hardirqs_on_caller+0x11d/0x141
>  [<ffffffff8106e459>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff8118cae7>] ? security_file_permission+0x16/0x18
>  [<ffffffff81100e7a>] vfs_read+0xab/0x108
>  [<ffffffff8106e428>] ? trace_hardirqs_on_caller+0x11d/0x141
>  [<ffffffff81100f97>] sys_read+0x4a/0x6e
>  [<ffffffff81002bf2>] system_call_fastpath+0x16/0x1b
> no locks held by lvcreate/2484.
> 
> 
> lvcreate is just the first victim (sometimes it is the vgcreate).  But
> if the guest is left running other new processes get hung with
> comparable traces (w/ get_request_wait).  Until eventually the guest is
> completely unresponsive.
> 
> Mike



-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
ryanh@us.ibm.com
