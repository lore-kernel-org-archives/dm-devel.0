From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] dm: Fix lock dependency warning for request
	based dm
Date: Wed, 18 Feb 2009 15:21:54 +0100
Message-ID: <20090218142154.GA1782@schmichrtp.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Testing with request based dm multipathing and lock dependency checking
revealed this problem. Fix this by disabling interrupts when acquiring the
map_lock from the ioctl call in __bind and __unbind.

It seems that the problem has been introduced with this patch:
http://lkml.indiana.edu/hypermail/linux/kernel/0810.0/1067.html

======================================================
[ INFO: soft-safe -> soft-unsafe lock order detected ]
2.6.27.13-1.1.mz11dbg-default #1
------------------------------------------------------
multipath/3857 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&md->map_lock){----}, at: [<000003e000573a0e>] dm_get_table+0x32/0x68 [dm_mod]

and this task is already holding:
 (&q->__queue_lock){.+..}, at: [<000003e000573b04>] dm_resume+0xc0/0x1b8 [dm_mod]
which would create a new lock dependency:
 (&q->__queue_lock){.+..} -> (&md->map_lock){----}

but this new dependency connects a soft-irq-safe lock:
 (&q->__queue_lock){.+..}
... which became soft-irq-safe at:
  [<00000000001633fa>] mark_irqflags+0xa6/0x154
  [<0000000000165486>] __lock_acquire+0x5ea/0x780
  [<0000000000165686>] lock_acquire+0x6a/0x90
  [<00000000003b5f8a>] _spin_lock+0x4a/0x64
  [<000003e000786fd2>] scsi_device_unbusy+0xb2/0xe4 [scsi_mod]
  [<000003e00077def4>] scsi_finish_command+0x4c/0x11c [scsi_mod]
  [<000003e000787278>] scsi_softirq_done+0x170/0x180 [scsi_mod]
  [<00000000002a4c2a>] blk_done_softirq+0xc6/0xe4
  [<000000000013c9d2>] __do_softirq+0xee/0x1ec
  [<000000000010fcc8>] do_softirq+0x9c/0xd8
  [<000000000013c3e6>] irq_exit+0x82/0xe0
  [<00000000002fda4c>] do_IRQ+0x170/0x190
  [<0000000000113c36>] io_return+0x0/0x8
  [<0000000000109c10>] default_idle+0x198/0x1a8

to a soft-irq-unsafe lock:
 (&md->map_lock){----}
... which became soft-irq-unsafe at:
...  [<0000000000163478>] mark_irqflags+0x124/0x154
  [<0000000000165486>] __lock_acquire+0x5ea/0x780
  [<0000000000165686>] lock_acquire+0x6a/0x90
  [<00000000003b6146>] _write_lock+0x4a/0x64
  [<000003e000572a1a>] __bind+0x116/0x184 [dm_mod]
  [<000003e000572b18>] dm_swap_table+0x90/0xb8 [dm_mod]
  [<000003e0005791e4>] do_resume+0xe4/0x17c [dm_mod]
  [<000003e00057932e>] dev_suspend+0xb2/0xc8 [dm_mod]
  [<000003e000579f46>] ctl_ioctl+0x236/0x2ac [dm_mod]
  [<000003e000579fea>] dm_ctl_ioctl+0x2e/0x40 [dm_mod]
  [<00000000001e7764>] vfs_ioctl+0x50/0xbc
  [<00000000001e7c64>] do_vfs_ioctl+0x26c/0x280
  [<00000000001e7d4e>] SyS_ioctl+0xd6/0xfc
  [<0000000000113696>] sysc_noemu+0x10/0x16
  [<000002000019269e>] 0x2000019269e

[...]

stack backtrace:
CPU: 3 Not tainted 2.6.27.13-1.1.mz11dbg-default #1
Process multipath (pid: 3857, task: 0000000139e06038, ksp: 000000013416b858)
0000000139e067d0 000000013416b708 0000000000000002 0000000000000000 
       000000013416b7a8 000000013416b720 000000013416b720 0000000000104c3e 
       0000000000000003 0000000000000000 0000000000000000 000000010000000b 
       0000000000000060 0000000000000008 000000013416b708 000000013416b778 
       00000000003ba8b8 0000000000104c3e 000000013416b708 000000013416b760 
Call Trace:
([<0000000000104b86>] show_trace+0xb2/0xd0)
 [<0000000000104c5c>] show_stack+0xb8/0xc8
 [<00000000003b2392>] dump_stack+0xae/0xbc
 [<00000000001640ec>] print_bad_irq_dependency+0x320/0x334
 [<0000000000164226>] check_usage+0x126/0x138
 [<0000000000164368>] check_prev_add+0x130/0x530
 [<0000000000164d3a>] validate_chain+0x5d2/0x734
 [<00000000001655aa>] __lock_acquire+0x70e/0x780
 [<0000000000165686>] lock_acquire+0x6a/0x90
 [<00000000003b645a>] _read_lock+0x4a/0x64
 [<000003e000573a0e>] dm_get_table+0x32/0x68 [dm_mod]
 [<000003e000574b9a>] dm_request_fn+0x3e/0x1a4 [dm_mod]
 [<000000000029f1ac>] blk_invoke_request_fn+0x94/0x170
 [<000000000029f304>] blk_start_queue+0x7c/0x9c
 [<000003e000573b20>] dm_resume+0xdc/0x1b8 [dm_mod]
 [<000003e00057924a>] do_resume+0x14a/0x17c [dm_mod]
 [<000003e00057932e>] dev_suspend+0xb2/0xc8 [dm_mod]
 [<000003e000579f46>] ctl_ioctl+0x236/0x2ac [dm_mod]
 [<000003e000579fea>] dm_ctl_ioctl+0x2e/0x40 [dm_mod]
 [<00000000001e7764>] vfs_ioctl+0x50/0xbc
 [<00000000001e7c64>] do_vfs_ioctl+0x26c/0x280
 [<00000000001e7d4e>] SyS_ioctl+0xd6/0xfc
 [<0000000000113696>] sysc_noemu+0x10/0x16
 [<000002000019269e>] 0x2000019269e
INFO: lockdep is turned off.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>

--- linux-2.6.27.13-1.orig/drivers/md/dm.c
+++ linux-2.6.27.13-1/drivers/md/dm.c
@@ -1943,7 +1943,7 @@ static int __bind(struct mapped_device *
 	if (dm_table_request_based(t) && !blk_queue_stopped(q))
 		stop_queue(q);
 
-	write_lock(&md->map_lock);
+	write_lock_irq(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
 	dm_table_set_integrity(t, md);
@@ -1952,7 +1952,7 @@ static int __bind(struct mapped_device *
 	} else {
 		set_disk_ro(md->disk, 0);
 	}
-	write_unlock(&md->map_lock);
+	write_unlock_irq(&md->map_lock);
 
 	return 0;
 }
@@ -1965,9 +1965,9 @@ static void __unbind(struct mapped_devic
 		return;
 
 	dm_table_event_callback(map, NULL, NULL);
-	write_lock(&md->map_lock);
+	write_lock_irq(&md->map_lock);
 	md->map = NULL;
-	write_unlock(&md->map_lock);
+	write_unlock_irq(&md->map_lock);
 	dm_table_destroy(map);
 }
 
