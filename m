From: Christoph Hellwig <hch@infradead.org>
Subject: dm-thinp bug
Date: Tue, 26 Apr 2011 14:47:42 -0400
Message-ID: <20110426184742.GA13880@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

I can reproduce a bug in virtio triggered by running under dm-thinp by
just copying lots of files from my home directory into a freshly created
filesystem on dm-thinp.

The table setup I use for the thinly provisoned volume is:

0 73400320 thin-prov /dev/vdc1 /dev/vdc2 1048576 32

The virtio bug on says that it gets more segments than it allows to
higher layers.

[ 1944.721745] ------------[ cut here ]------------
[ 1944.724771] kernel BUG at /home/hch/work/linux-2.6/drivers/block/virtio_blk.c:178!
[ 1944.725511] invalid opcode: 0000 [#1] SMP 
[ 1944.725511] last sysfs file: /sys/devices/virtual/block/dm-0/dm/name
[ 1944.725511] Modules linked in:
[ 1944.725511] 
[ 1944.725511] Pid: 0, comm: swapper Not tainted 2.6.37+ #95 /Bochs
[ 1944.725511] EIP: 0060:[<c06d6808>] EFLAGS: 00010002 CPU: 0
[ 1944.725511] EIP is at do_virtblk_request+0x378/0x3a0
[ 1944.725511] EAX: 00000081 EBX: f5df7980 ECX: 00000000 EDX: 00000000
[ 1944.725511] ESI: f5dbf000 EDI: f5988670 EBP: f6409f6c ESP: f6409f28
[ 1944.725511]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1944.725511] Process swapper (pid: 0, ti=f6408000 task=c0d30ee0 task.ti=c0d1c000)
[ 1944.725511] Stack:
[ 1944.725511]  00000001 f5df7980 00000020 f5dbf4d8 f5df79ac f5dbf010 f5dbf020 00000004
[ 1944.725511]  f5c75bf0 0000003d f5dbf034 00000001 f77dda00 00000001 f5c75bf0 f5c75da8
[ 1944.725511]  f6409f94 f6409f7c c063b055 f5c75bf0 f5dbf000 f6409f88 c063b215 00000000
[ 1944.725511] Call Trace:
[ 1944.725511]  [<c063b055>] __blk_run_queue+0x65/0x120
[ 1944.725511]  [<c063b215>] blk_start_queue+0x35/0x70
[ 1944.725511]  [<c06d68fe>] blk_done+0xce/0xe0
[ 1944.725511]  [<c06a1594>] vring_interrupt+0x24/0x40
[ 1944.725511]  [<c01ad594>] handle_IRQ_event+0x44/0x150
[ 1944.725511]  [<c01ad594>] ? handle_IRQ_event+0x44/0x150
[ 1944.725511]  [<c01b0884>] ? move_native_irq+0x14/0x50
[ 1944.725511]  [<c01af42b>] handle_edge_irq+0x9b/0x130
[ 1944.725511]  [<c01af53c>] ? handle_fasteoi_irq+0x7c/0xc0
[ 1944.725511]  [<c01af390>] ? handle_edge_irq+0x0/0x130
[ 1944.725511]  <IRQ> 
[ 1944.725511]  [<c01377ed>] ? do_IRQ+0x3d/0xb0
[ 1944.725511]  [<c016f136>] ? irq_exit+0x56/0x70
[ 1944.725511]  [<c014c266>] ? smp_apic_timer_interrupt+0x56/0x90
[ 1944.725511]  [<c0136aa9>] ? common_interrupt+0x29/0x30
[ 1944.725511]  [<c0153525>] ? native_safe_halt+0x5/0x10
[ 1944.725511]  [<c013d493>] ? default_idle+0x73/0x170
[ 1944.725511]  [<c01353ea>] ? cpu_idle+0x4a/0x80
[ 1944.725511]  [<c09810d8>] ? rest_init+0x58/0x60
[ 1944.725511]  [<c0d858e3>] ? start_kernel+0x2e5/0x2eb
[ 1944.725511]  [<c0d85428>] ? unknown_bootoption+0x0/0x1a0
[ 1944.725511]  [<c0d850e0>] ? i386_start_kernel+0xe0/0xe8
