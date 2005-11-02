From: =?ISO-8859-1?Q?=C5ke?= Sandgren <ake.sandgren@hpc2n.umu.se>
Subject: soft lockup detected in dm-mod related ioctl,
	2.6.14 + patches from editing-quilt
Date: Wed, 02 Nov 2005 14:29:56 +0100
Message-ID: <1130938196.4462.41.camel@y-boda.hpc2n.umu.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi!

I am getting soft lockup detected when multipathd starts when running
2.6.14 with the patches from
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing-quilt/patches/

Running a plain 2.6.14 without them makes the problem go away.

Should those patches work on a 2.6.14 or?

traceback is:

Starting multipath daemon: multipathd.
BUG: soft lockup detected on CPU#0!

Pid: 4533, comm:           multipathd
EIP: 0060:[<c01108df>] CPU: 0
EIP is at smp_call_function+0xaa/0x151
 EFLAGS: 00000297    Not tainted  (2.6.14-dm-ican)
EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 000c08fb
ESI: 00000001 EDI: f896a000 EBP: f72e3e78 DS: 007b ES: 007b
CR0: 8005003b CR2: 080a0000 CR3: 3789e000 CR4: 000006d0
 [<c0101116>] show_regs+0x15b/0x185
 [<c013ea8c>] softlockup_tick+0x77/0x89
 [<c0125fd4>] do_timer+0x42/0x10f
 [<c0107868>] timer_interrupt+0x35/0x82
 [<c013ec63>] handle_IRQ_event+0x3e/0x71
 [<c013ed20>] __do_IRQ+0x8a/0xea
 [<c0104f03>] do_IRQ+0x33/0x5e
 [<c01037c2>] common_interrupt+0x1a/0x20
 [<c01107e7>] flush_tlb_all+0x2a/0x38
 [<c0156335>] unmap_vm_area+0x7d/0x9c
 [<c0156739>] __remove_vm_area+0x2f/0x56
 [<c015677c>] remove_vm_area+0x1c/0x30
 [<c01567af>] __vunmap+0x1f/0xf4
 [<c01568ad>] vfree+0x29/0x35
 [<f882de59>] free_params+0x11/0x13 [dm_mod]
 [<f882e02f>] ctl_ioctl+0xbc/0x130 [dm_mod]
 [<c01736ea>] do_ioctl+0x7a/0x83
 [<c017387f>] vfs_ioctl+0x5c/0x1ea
 [<c0173a79>] sys_ioctl+0x6c/0x7b
 [<c0102d7d>] syscall_call+0x7/0xb

-- 
Ake Sandgren, HPC2N, Umea University, S-90187 Umea, Sweden
Internet: ake@hpc2n.umu.se   Phone: +46 90 7866134 Fax: +46 90 7866126
Mobile: +46 70 7716134 WWW: http://www.hpc2n.umu.se
