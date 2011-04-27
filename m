From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-thinp bug
Date: Wed, 27 Apr 2011 05:32:59 -0400
Message-ID: <20110427093259.GA24141@infradead.org>
References: <20110426184742.GA13880@infradead.org>
	<1303895339.4679.51.camel@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1303895339.4679.51.camel@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 27, 2011 at 10:08:59AM +0100, Joe Thornber wrote:
> I think this is simply because I omitted the iterate_devices callback in
> the thinp target.
> 
> I'll try and find time to test this patch later this week.

This patch already creashes when creating the table:

qemu1:~# dmsetup create thin-volume table.txt 
[   15.186662] BUG: unable to handle kernel NULL pointer dereference at
00000010
[   15.189266] IP: [<c0863b1f>]
thinp_metadata_get_data_block_size+0xf/0x50
[   15.189266] *pde = 00000000 
[   15.189266] Oops: 0000 [#1] SMP 
[   15.189266] last sysfs file: /sys/devices/virtual/block/dm-0/removable
[   15.189266] Modules linked in:
[   15.189266] 
[   15.189266] Pid: 2027, comm: dmsetup Not tainted 2.6.37+ #99 /Bochs
[   15.189266] EIP: 0060:[<c0863b1f>] EFLAGS: 00010292 CPU: 0
[   15.189266] EIP is at thinp_metadata_get_data_block_size+0xf/0x50
[   15.189266] EAX: 00000000 EBX: 00000000 ECX: 00000200 EDX: f5f33da8
[   15.189266] ESI: f5a40140 EDI: c0862ba0 EBP: f5f33da0 ESP: f5f33d98
[   15.189266]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   15.189266] Process dmsetup (pid: 2027, ti=f5f32000 task=f6616040 task.ti=f5f32000)
[   15.189266] Stack:
[   15.189266]  f5f33e04 f5a40140 f5f33db0 c0863940 09200000 00000000 f5f33dc0 c0863982
[   15.189266]  f8522040 00000000 f5f33e4c c084d864 f5f33de4 c015db89 00000000 00000000
[   15.189266]  00000000 f6802b40 f58cb9c0 f5f33e08 c017fed1 00000000 00000000 f5f33e64
[   15.189266] Call Trace:
[   15.189266]  [<c0863940>] data_dev_block_size+0x10/0x30
[   15.189266]  [<c0863982>] thinp_io_hints+0x22/0x40
[   15.189266]  [<c084d864>] dm_calculate_queue_limits+0xa4/0x140
[   15.189266]  [<c015db89>] ? complete+0x49/0x60
[   15.189266]  [<c017fed1>] ? flush_workqueue_prep_cwqs+0x71/0x1f0
[   15.189266]  [<c084badb>] dm_swap_table+0x4b/0x1c0
[   15.189266]  [<c018585c>] ? remove_wait_queue+0x3c/0x50
[   15.189266]  [<c084ffa8>] dev_suspend+0xe8/0x1f0
[   15.189266]  [<c06535de>] ? copy_to_user+0x2e/0x50
[   15.189266]  [<c0850bbb>] dm_ctl_ioctl+0x16b/0x210
[   15.189266]  [<c01edc93>] ? __pte_alloc+0x93/0xb0
[   15.189266]  [<c084fec0>] ? dev_suspend+0x0/0x1f0
[   15.189266]  [<c0850a50>] ? dm_ctl_ioctl+0x0/0x210
[   15.189266]  [<c02146c9>] do_vfs_ioctl+0x79/0x580
[   15.189266]  [<c064a9fd>] ? kobject_put+0x1d/0x50
[   15.189266]  [<c021821a>] ? dput+0x1a/0x230
[   15.189266]  [<c021e220>] ? mntput_no_expire+0x20/0xf0
[   15.189266]  [<c021e303>] ? mntput+0x13/0x20
[   15.189266]  [<c0207b4d>] ? fput+0x12d/0x1d0
[   15.189266]  [<c0608470>] ? sys_ipc+0x80/0x220
[   15.189266]  [<c0214c09>] sys_ioctl+0x39/0x70
[   15.189266]  [<c099dac9>] syscall_call+0x7/0xb
