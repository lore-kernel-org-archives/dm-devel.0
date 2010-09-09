From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest
 to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support
 for request-based dm]
Date: Thu, 9 Sep 2010 15:43:01 -0400
Message-ID: <20100909194300.GA16908@redhat.com>
References: <20100902032246.GA31484@redhat.com>
 <20100909152658.GA8118@redhat.com>
 <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909191555.GA14486@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 09 2010 at  3:15pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Sep 09 2010 at  2:35pm -0400,
> Ryan Harper <ryanh@us.ibm.com> wrote:
> 
> > * Mike Snitzer <snitzer@redhat.com> [2010-09-09 12:56]:
> 
> > > I have verified that I no longer get the hang if I switch the root
> > > device from virtio to ide.
> > 
> > And in the failing case, do you see:
> > 
> > /sys/block/vda/serial 
> > 
> > attribute in sysfs?

Interestingly, just this loop:

while true ; do cat /sys/block/vda/serial && date && sleep 1 ; done
Thu Sep  9 15:29:30 EDT 2010
...
Thu Sep  9 15:31:19 EDT 2010

caused the following hang:
INFO: task cat:1825 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cat           D 000000010000e784  5664  1825   1467 0x00000080
 ffff88007bbcdce8 0000000000000046 ffff88007bbcdc88 ffff880000000000
 ffff88007bbcdfd8 ffff88007b42a400 00000000001d4040 ffff88007bbcdfd8
 00000000001d4040 00000000001d4040 00000000001d4040 00000000001d4040
Call Trace:
 [<ffffffff8136de23>] io_schedule+0x73/0xb5
 [<ffffffff811b6882>] get_request_wait+0xf2/0x180
 [<ffffffff8105d8da>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff811b6951>] blk_get_request+0x41/0x71
 [<ffffffff811b69ad>] blk_make_request+0x2c/0x8b
 [<ffffffffa0016073>] virtblk_get_id+0x57/0x93 [virtio_blk]
 [<ffffffffa00160d0>] virtblk_serial_show+0x21/0x4d [virtio_blk]
 [<ffffffff81265f7c>] dev_attr_show+0x27/0x4e
 [<ffffffff81157f0b>] ? sysfs_read_file+0x94/0x17f
 [<ffffffff810c6d6b>] ? __get_free_pages+0x18/0x55
 [<ffffffff81157f34>] sysfs_read_file+0xbd/0x17f
 [<ffffffff81100e7a>] vfs_read+0xab/0x108
 [<ffffffff8106e428>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81100f97>] sys_read+0x4a/0x6e
 [<ffffffff81002bf2>] system_call_fastpath+0x16/0x1b
2 locks held by cat/1825:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81157eaf>] sysfs_read_file+0x38/0x17f
 #1:  (s_active#14){.+.+.+}, at: [<ffffffff81157f0b>] sysfs_read_file+0x94/0x17f

So it seems like the virtio requests aren't being properly cleaned up?
