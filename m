From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest
 to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support
 for request-based dm]
Date: Thu, 9 Sep 2010 15:15:55 -0400
Message-ID: <20100909191555.GA14486@redhat.com>
References: <20100902032246.GA31484@redhat.com>
 <20100909152658.GA8118@redhat.com>
 <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909183554.GK30086@us.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 09 2010 at  2:35pm -0400,
Ryan Harper <ryanh@us.ibm.com> wrote:

> * Mike Snitzer <snitzer@redhat.com> [2010-09-09 12:56]:

> > I have verified that I no longer get the hang if I switch the root
> > device from virtio to ide.
> 
> And in the failing case, do you see:
> 
> /sys/block/vda/serial 
> 
> attribute in sysfs?

[root@rhel6 ~]# ls -al /sys/block/vda/serial 
-r--r--r-- 1 root root 4096 Sep  9 15:07 /sys/block/vda/serial
[root@rhel6 ~]# cat /sys/block/vda/serial
[root@rhel6 ~]# 

If I try to access 'serial' once the reproducer script has hung the cat
also hangs:

cat           D 00000000fffe5d48  5664  2386   2049 0x00000080
 ffff880075129ce8 0000000000000046 ffff880075129c88 ffff880000000000
 ffff880075129fd8 ffff8800758aa400 00000000001d4040 ffff880075129fd8
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


Taking a step back; why did you make the inability to add the 'serial'
attribute such a hard failure?

Strikes me as worthy of a non-fatal warning at most.  The serial
attribute is added fine in this instance but I'm just curious.

Mike
