From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
Date: Fri, 3 Aug 2007 11:04:30 -0700
Message-ID: <20070803110430.88a4b543.akpm@linux-foundation.org>
References: <46B0D4B4.2040809@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B0D4B4.2040809@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Philipp =?ISO-8859-1?Q?T=F6lke?= <philipptoelke@web.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On Wed, 01 Aug 2007 20:45:08 +0200
Philipp T__lke <philipptoelke@web.de> wrote:

> Hello everybody,
> 
> if I mount a dm-crypt-encrypted Harddisk/RAID-Array on an Adaptec 3200S,
> and produce load (for example with bonnie++) the kernel crashes.
> 
> This is always reproducible. To reproduce simply mount an dm-crypt
> encrypted device and produce load -- I always used bonnie++.
> 
> Unencrypted volumes work fine. Every kind of load I threw at the System
> worked fine.
> 
> I would be very glad, if some kind of solution for this can be found.
> 

Gee we get a lot of bug reports involving dm-crypt.

> 
> The oopses:
> 
> #v+
> BUG: unable to handle kernel paging request at virtual address 14001000
> printing eip:
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: dm_crypt dm_mod capability commoncap ipv6 pcspkr
> ppdev lp parport_pc parport rtc_cmos ppp_generic rtc_core rtc_lib
> i2c_viapro i2o_core i2c_core via_ircc irda crc_ccitt sg shpchp
> pci_hotplug evdev thermal processor fan button battery ac slhc r8169
> usbcore jfs sr_mod cdrom sd_mod sym53c8xx dpt_i2o ata_generic pata_via
> libata
> CPU:    0
> EIP:    0060:[<14001000>]    Not tainted VLI
> EFLAGS: 00010082   (2.6.22.1 #2)
> EIP is at 0x14001000
> eax: 00000000   ebx: 14001000   ecx: 00000000   edx: 0002bc00
> esi: 5b51c000   edi: 14001000   ebp: 5b51b000   esp: dfe21f08
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process kblockd/0 (pid: 31, ti=dfe20000 task=c1cfca50 task.ti=dfe20000)
> 
> Stack: 5b51a000 14001000 5b519000 14001000 5b518000 d4001000 5b517000
> 00000086
> c1d0b534 c1d0b424 c1d0b490 c1da7834 c1da7834 c1da7834 00000000 07000000
> c022aac5 c1da78b8 c022b696 c022c762 00000046 c1d0b534 c1d0b424 c1d0b490
> 
> Call Trace:
> [<c022aac5>] __generic_unplug_device+0x25/0x30
> [<c022b696>] generic_unplug_device+0x6/0x10
> [<c022c762>] blk_unplug_work+0x42/0xa0
> [<c022c720>] blk_unplug_work+0x0/0xa0
> [<c012a307>] run_workqueue+0x97/0x110
> [<c012aa00>] worker_thread+0x0/0xe0
> [<c012aa7d>] worker_thread+0x7d/0xe0
> [<c012d5e0>] autoremove_wake_function+0x0/0x40
> [<c012aa00>] worker_thread+0x0/0xe0
> [<c012d292>] kthread+0x42/0x70
> [<c012d250>] kthread+0x0/0x70
> [<c01041df>] kernel_thread_helper+0x7/0x18
> =======================
> Code:  Bad EIP value.
> EIP: [<14001000>] 0x14001000 SS:ESP 0068:dfe21f08
> 

So it looks like q->request_fn points at 0x14001000, which is in outer
space.

I wonder how that could happen, in the middle of heavy IO operations. 
Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.  You could also try switching
from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.
