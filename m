From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: 2.6.27-rc7: unsafe lock order/inconsistent lock state after removing multipath device
Date: Mon, 29 Sep 2008 18:55:41 +0400
Message-ID: <200809291855.42111.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1886266.I5oq9iiSW6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753215AbYI2O4T@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--nextPart1886266.I5oq9iiSW6
Content-Type: multipart/mixed;
  boundary="Boundary-01=_txO4IuP7tKQ441R"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_txO4IuP7tKQ441R
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I needed to quickly check some things on multipath; I only had available
notebook with USB stick so I arranged for single path multipath with
faked WWID (which worked by the way).

Testing what happans when last path is lost, I started IO from dm and
removed USB stick. It resulted in quite a long kernel warning about
unsafe lock order. I tested several times and once more got warning
about possible inconsistent lock state.

I attach 2 logs with kernel output (one of them includes dmesg from boot)
and kernel config. Please let me now if additional information is required.

-andrey

--Boundary-01=_txO4IuP7tKQ441R
Content-Type: text/x-log;
  charset="us-ascii";
  name="multipath-1.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="multipath-1.log"

Sep 29 17:51:06 cooker kernel: [42498.249469] usb 1-1: USB disconnect, addr=
ess 2
Sep 29 17:51:08 cooker sudo:      bor : TTY=3Dpts/0 ; PWD=3D/home/bor/src/l=
inux-git/drivers/md ; USER=3Droot ; COMMAND=3D/bin/dd if=3D/dev/mapper/1234=
5678 of=3D/dev/null count=3D10
Sep 29 17:51:08 cooker multipathd: 8:0: mark as failed=20
Sep 29 17:51:08 cooker multipathd: 12345678: Entering recovery mode: max_re=
tries=3D5=20
Sep 29 17:51:08 cooker multipathd: 12345678: remaining active paths: 0=20
Sep 29 17:51:08 cooker kernel: [42500.275610] device-mapper: multipath: Fai=
ling path 8:0.
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 29 17:51:08 cooker kernel: [42500.275832] [ INFO: soft-safe -> soft-uns=
afe lock order detected ]
Sep 29 17:51:08 cooker kernel: [42500.275832] 2.6.27-rc7-1avb #11
Sep 29 17:51:08 cooker kernel: [42500.275832] -----------------------------=
=2D------------------------
Sep 29 17:51:08 cooker kernel: [42500.275832] dd/28259 [HC0[0]:SC0[0]:HE0:S=
E1] is trying to acquire:
Sep 29 17:51:08 cooker kernel: [42500.275832]  (_minor_lock){--..}, at: [<c=
01f4c68>] _atomic_dec_and_lock+0x18/0x40
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] and this task is already hold=
ing:
Sep 29 17:51:08 cooker kernel: [42500.275832]  (&m->lock){....}, at: [<dfec=
4af6>] fail_path+0x26/0xc0 [dm_multipath]
Sep 29 17:51:08 cooker kernel: [42500.275832] which would create a new lock=
 dependency:
Sep 29 17:51:08 cooker kernel: [42500.275832]  (&m->lock){....} -> (_minor_=
lock){--..}
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] but this new dependency conne=
cts a soft-irq-safe lock:
Sep 29 17:51:08 cooker kernel: [42500.275832]  (&q->__queue_lock){.+..}
Sep 29 17:51:08 cooker kernel: [42500.275832] ... which became soft-irq-saf=
e at:
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c013e838>] __lock_acquire=
+0x4d8/0x1640
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c013f9fc>] lock_acquire+0=
x5c/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c02f6aca>] _spin_lock+0x3=
a/0x70
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfe8a746>] scsi_device_un=
busy+0x76/0xa0 [scsi_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfe836d1>] scsi_finish_co=
mmand+0x21/0xe0 [scsi_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfe8a943>] scsi_softirq_d=
one+0x103/0x120 [scsi_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c01e81fd>] blk_done_softi=
rq+0x6d/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c0120612>] __do_softirq+0=
x62/0xc0
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c0104c56>] do_softirq+0x9=
6/0xd0
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<ffffffff>] 0xffffffff
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] to a soft-irq-unsafe lock:
Sep 29 17:51:08 cooker kernel: [42500.275832]  (_minor_lock){--..}
Sep 29 17:51:08 cooker kernel: [42500.275832] ... which became soft-irq-uns=
afe at:
Sep 29 17:51:08 cooker kernel: [42500.275832] ...  [<c013e87d>] __lock_acqu=
ire+0x51d/0x1640
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c013f9fc>] lock_acquire+0=
x5c/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c02f6aca>] _spin_lock+0x3=
a/0x70
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfda0f39>] dm_create+0x3d=
9/0x480 [dm_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfda56c1>] dev_create+0x4=
1/0x280 [dm_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<dfda5b5b>] dm_ctl_ioctl+0=
x1cb/0x240 [dm_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c01998c5>] vfs_ioctl+0x25=
/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c0199b5a>] do_vfs_ioctl+0=
x23a/0x2b0
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c0199c0e>] sys_ioctl+0x3e=
/0x70
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<c010329d>] sysenter_do_ca=
ll+0x12/0x31
Sep 29 17:51:08 cooker kernel: [42500.275832]   [<ffffffff>] 0xffffffff
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] other info that might help us=
 debug this:
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] 2 locks held by dd/28259:
Sep 29 17:51:08 cooker kernel: [42500.275832]  #0:  (&q->__queue_lock){.+..=
}, at: [<c01e9c4f>] generic_unplug_device+0x1f/0x40
Sep 29 17:51:08 cooker kernel: [42500.275832]  #1:  (&m->lock){....}, at: [=
<dfec4af6>] fail_path+0x26/0xc0 [dm_multipath]
Sep 29 17:51:08 cooker kernel: [42500.275832]=20
Sep 29 17:51:08 cooker kernel: [42500.275832] the soft-irq-safe lock's depe=
ndencies:
Sep 29 17:51:08 cooker kernel: [42500.275832] -> (&q->__queue_lock){.+..} o=
ps: 0 {
Sep 29 17:51:08 cooker kernel: [42500.275832]    initial-use  at:
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c01eb873>] blk_queue_stack_limits+0xc3/0x160
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<dfd93211>] linear_conf+0xb1/0x300 [linear]
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<dfd9356a>] linear_run+0x2a/0x90 [linear]
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<dfe75e49>] do_md_run+0x439/0xa90 [md_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<dfe7805a>] md_ioctl+0xdba/0x1780 [md_mod]
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c01ed2fb>] blkdev_driver_ioctl+0x5b/0x60
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c01ed59d>] blkdev_ioctl+0x29d/0x860
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c01b6770>] block_ioctl+0x20/0x30
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:08 cooker kernel: [42500.275832]                              =
          [<ffffffff>] 0xffffffff
Sep 29 17:51:08 cooker kernel: [42500.275832]    in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<dfe8a746>] scsi_device_unbusy+0x76/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<dfe836d1>] scsi_finish_command+0x21/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<dfe8a943>] scsi_softirq_done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c01e81fd>] blk_done_softirq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
          [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]  }
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... key      at: [<c0927ee8>=
] __key.22527+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&ret->lock){++..} ops: 0=
 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f3962>] cfq_set_request+0x232/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e6af4>] elv_set_request+0x24/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e95d4>] get_request+0x264/0x290
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e9ac2>] get_request_wait+0x22/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e9c0b>] blk_get_request+0x5b/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df837ecf>] ide_raw_taskfile+0x2f/0x90 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df838062>] taskfile_lib_get_identify+0x62/0x70 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df83cc01>] ide_acpi_port_init_devices+0xd1/0xec [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df83785c>] ide_host_register+0x5bc/0x6c0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df839e6f>] ide_pci_init_one+0xdf/0x100 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df81860e>] alim15x3_init_one+0xae/0xf5 [alim15x3]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02102ee>] pci_device_probe+0x5e/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c026431c>] driver_probe_device+0x8c/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02644c1>] __driver_attach+0x81/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0263b8b>] bus_for_each_dev+0x5b/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c026417e>] driver_attach+0x1e/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02634ff>] bus_add_driver+0x1cf/0x250
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02646a1>] driver_register+0x71/0x150
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0210533>] __pci_register_driver+0x63/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df81201c>] 0xdf81201c
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c010111b>] do_one_initcall+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01493da>] sys_init_module+0x8a/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0103376>] syscall_call+0x7/0xb
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f26d3>] cic_free_func+0x23/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2750>] cfq_free_io_context+0x30/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01ebc4b>] put_io_context+0x8b/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2b12>] __cfq_slice_expired+0x52/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2c7c>] cfq_put_queue+0x7c/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2e29>] cfq_put_request+0x49/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e6b38>] elv_put_request+0x18/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8e31>] __blk_put_request+0x81/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8ecc>] end_that_request_last+0x7c/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e91d0>] __blk_end_request+0x30/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df831977>] __ide_end_request+0x37/0xd0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df831ac9>] ide_end_request+0x59/0x90 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df838315>] task_end_request+0x35/0x80 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df83ad16>] ide_dma_intr+0x56/0xa0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df832b48>] ide_intr+0x98/0x220 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f26d3>] cic_free_func+0x23/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2750>] cfq_free_io_context+0x30/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01ebc4b>] put_io_context+0x8b/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01f2e14>] cfq_put_request+0x34/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e6b38>] elv_put_request+0x18/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8e31>] __blk_put_request+0x81/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8ecc>] end_that_request_last+0x7c/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e90ae>] blk_end_io+0x5e/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e918f>] blk_end_request+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe89d2d>] scsi_end_request+0x2d/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a32c>] scsi_io_completion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe83733>] scsi_finish_command+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a943>] scsi_softirq_done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e81fd>] blk_done_softirq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<c0927f1c=
>] __key.21325+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f31b3>] cfq_cic_looku=
p+0x93/0x160
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f354e>] cfq_get_queue=
+0x6e/0x1d0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f3934>] cfq_set_reque=
st+0x204/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e6af4>] elv_set_reque=
st+0x24/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e95d4>] get_request+0=
x264/0x290
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e9ac2>] get_request_w=
ait+0x22/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e9c0b>] blk_get_reque=
st+0x5b/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8adc8>] scsi_execute+=
0x28/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8af2f>] scsi_execute_=
req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8c0a5>] scsi_probe_an=
d_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8cd54>] __scsi_scan_t=
arget+0xf4/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d3cf>] scsi_scan_cha=
nnel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d4c9>] scsi_scan_hos=
t_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d60c>] do_scsi_scan_=
host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d8ce>] scsi_scan_hos=
t+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfea3a9d>] usb_stor_scan=
_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&base->lock){++..} ops: =
0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c012498a>] lock_timer_base+0x2a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0124ae6>] __mod_timer+0x36/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0124c4f>] mod_timer+0x3f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03f5c6e>] con_init+0x22d/0x232
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03f5192>] console_init+0x1e/0x2c
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03de958>] start_kernel+0x196/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c012498a>] lock_timer_base+0x2a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01249d8>] del_timer+0x28/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df832b25>] ide_intr+0x75/0x220 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6bb0>] _spin_lock_irq+0x40/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c012411e>] run_timer_softirq+0x2e/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<c044156c=
>] __key.19403+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]   -> (ftrace_shutdown_lock){+=
+..} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]      initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0160f5d>] ftrace_record_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01035f7>] mcount_call+0x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03de51d>] kernel_init+0x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0160f5d>] ftrace_record_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01035f7>] mcount_call+0x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0160f5d>] ftrace_record_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01035f7>] mcount_call+0x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]    }
Sep 29 17:51:09 cooker kernel: [42500.275832]    ... key      at: [<c03c26b=
0>] ftrace_shutdown_lock+0x10/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124b48>] __mod_timer+0=
x98/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f45a4>] schedule_time=
out+0x74/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c016135e>] ftraced+0x5e/=
0x180
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012498a>] lock_timer_ba=
se+0x2a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124ae6>] __mod_timer+0=
x36/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124c4f>] mod_timer+0x3=
f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e9cb7>] blk_plug_devi=
ce+0x47/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e7b9e>] __elv_add_req=
uest+0x5e/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec2f7>] blk_execute_r=
q_nowait+0x57/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec3ee>] blk_execute_r=
q+0xae/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ae79>] scsi_execute+=
0xd9/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8af2f>] scsi_execute_=
req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8c0a5>] scsi_probe_an=
d_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8cd54>] __scsi_scan_t=
arget+0xf4/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d3cf>] scsi_scan_cha=
nnel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d4c9>] scsi_scan_hos=
t_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d60c>] do_scsi_scan_=
host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d8ce>] scsi_scan_hos=
t+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfea3a9d>] usb_stor_scan=
_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec2fe>] blk_execute_r=
q_nowait+0x5e/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec3ee>] blk_execute_r=
q+0xae/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ae79>] scsi_execute+=
0xd9/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8af2f>] scsi_execute_=
req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8c0a5>] scsi_probe_an=
d_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8cd54>] __scsi_scan_t=
arget+0xf4/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d3cf>] scsi_scan_cha=
nnel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d4c9>] scsi_scan_hos=
t_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d60c>] do_scsi_scan_=
host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d8ce>] scsi_scan_hos=
t+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfea3a9d>] usb_stor_scan=
_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&sdev->list_lock){.+..} =
ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe843f9>] scsi_get_command+0x59/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a15c>] scsi_setup_blk_pc_cmnd+0x10c/0x150 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a1e5>] scsi_prep_fn+0x45/0x50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e786d>] elv_next_request+0xdd/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe895c4>] scsi_request_fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e99d3>] __generic_unplug_device+0x23/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01ec2fe>] blk_execute_rq_nowait+0x5e/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01ec3ee>] blk_execute_rq+0xae/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8ae79>] scsi_execute+0xd9/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8af2f>] scsi_execute_req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8c0a5>] scsi_probe_and_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8cd54>] __scsi_scan_target+0xf4/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8d3cf>] scsi_scan_channel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8d4c9>] scsi_scan_host_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8d60c>] do_scsi_scan_host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8d8ce>] scsi_scan_host+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfea3a9d>] usb_stor_scan_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c012f58f>] kthread+0x3f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe84357>] scsi_put_command+0x17/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe89b81>] scsi_next_command+0x31/0x50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe89d80>] scsi_end_request+0x80/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a32c>] scsi_io_completion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe83733>] scsi_finish_command+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a943>] scsi_softirq_done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e81fd>] blk_done_softirq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<dfe9eec8=
>] __key.23156+0x0/0xffff11cd [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]   -> (&cwq->lock){++..} ops: =
0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]      initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c44f>] __queue_work+0x1f/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c4d1>] queue_work_on+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c593>] queue_work+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012b6ca>] call_usermodehelper_exec+0xca/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01f6d57>] kobject_uevent_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01f6d9a>] kobject_uevent+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01f63d9>] kset_register+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0263e0d>] bus_register+0xad/0x230
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03f5dd6>] platform_bus_init+0x28/0x3a
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03f5ea5>] driver_init+0x25/0x39
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03de4fd>] kernel_init+0x5a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c44f>] __queue_work+0x1f/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c4d1>] queue_work_on+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c593>] queue_work+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0226613>] acpi_os_execute+0x81/0x9d
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c022ce16>] acpi_ev_gpe_dispatch+0xa2/0x10f
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c022cf22>] acpi_ev_gpe_detect+0x9f/0xe6
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c022b491>] acpi_ev_sci_xrupt_handler+0x1a/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0225e8f>] acpi_irq+0x13/0x28
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c44f>] __queue_work+0x1f/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c4d1>] queue_work_on+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c593>] queue_work+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012c5b4>] schedule_work+0x14/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c021cad9>] cursor_timer_handler+0x19/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c012421a>] run_timer_softirq+0x12a/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]    }
Sep 29 17:51:09 cooker kernel: [42500.275832]    ... key      at: [<c04415c=
c>] __key.18975+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]    -> (&q->lock){++..} ops: 0=
 {
Sep 29 17:51:09 cooker kernel: [42500.275832]       initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f6bb0>] _spin_lock_irq+0x40/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f433e>] wait_for_common+0x2e/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f44d2>] wait_for_completion+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c012f71e>] kthread_create+0x6e/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c03ff030>] cpu_callback+0x50/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c03eb91b>] spawn_ksoftirqd+0x19/0x39
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c010111b>] do_one_initcall+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c03de4dc>] kernel_init+0x39/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]       in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c011309b>] complete+0x1b/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f25f4>] i8042_aux_test_irq+0x67/0x69
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]       in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c011309b>] complete+0x1b/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c012d490>] wakeme_after_rcu+0x10/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c015c4e2>] __rcu_process_callbacks+0x82/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c015c677>] rcu_process_callbacks+0x17/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     }
Sep 29 17:51:09 cooker kernel: [42500.275832]     ... key      at: [<c04419=
94>] __key.13745+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]     -> (&rq->lock){++..} ops:=
 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]        initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c03fef2f>] init_idle+0x73/0xbf
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c03eb45b>] sched_init+0x343/0x392
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c03de885>] start_kernel+0xc3/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]        in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c01176a7>] scheduler_tick+0x27/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0124701>] update_process_times+0x41/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0139119>] tick_periodic+0x29/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0139187>] tick_handle_periodic+0x17/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]        in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0113f27>] task_rq_lock+0x17/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c011462f>] try_to_wake_up+0x2f/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c011474b>] default_wake_function+0xb/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c01124f8>] __wake_up_common+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c01130bd>] complete+0x3d/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c012d490>] wakeme_after_rcu+0x10/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c015c4e2>] __rcu_process_callbacks+0x82/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c015c677>] rcu_process_callbacks+0x17/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      }
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... key      at: [<c041f=
22c>] __key.35092+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]      -> (&rt_b->rt_runtime_lo=
ck){++..} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]         initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0114f32>] enqueue_task_rt+0xb2/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01120e0>] activate_task+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0117089>] __sched_setscheduler+0x199/0x360
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0117282>] sched_setscheduler+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015993a>] watchdog+0x2a/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c012f58f>] kthread+0x3f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]         in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0114f32>] enqueue_task_rt+0xb2/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01120e0>] activate_task+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01146ef>] try_to_wake_up+0xef/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c011476f>] wake_up_process+0xf/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0159c62>] softlockup_tick+0x152/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c012465c>] run_local_timers+0x1c/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01246e8>] update_process_times+0x28/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01398fe>] tick_sched_timer+0x4e/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013300c>] __run_hrtimer+0x9c/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0133a7f>] hrtimer_interrupt+0x14f/0x1c0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]         in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0114f32>] enqueue_task_rt+0xb2/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01120e0>] activate_task+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01146ef>] try_to_wake_up+0xef/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c011476f>] wake_up_process+0xf/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0132f5d>] hrtimer_wakeup+0x1d/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013300c>] __run_hrtimer+0x9c/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0133a7f>] hrtimer_interrupt+0x14f/0x1c0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]       }
Sep 29 17:51:09 cooker kernel: [42500.275832]       ... key      at: [<c041=
f234>] __key.30911+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]       -> (&cpu_base->lock){++=
=2E.} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]          initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c02f6bb0>] _spin_lock_irq+0x40/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0132d46>] run_hrtimer_pending+0x16/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c01332af>] hrtimer_run_pending+0x3f/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0124109>] run_timer_softirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]          in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0133079>] hrtimer_run_queues+0x59/0x1a0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c012464d>] run_local_timers+0xd/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c01246e8>] update_process_times+0x28/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0139119>] tick_periodic+0x29/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0139187>] tick_handle_periodic+0x17/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]          in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c02f6bb0>] _spin_lock_irq+0x40/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0132d46>] run_hrtimer_pending+0x16/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c01332af>] hrtimer_run_pending+0x3f/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0124109>] run_timer_softirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                      [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]        }
Sep 29 17:51:09 cooker kernel: [42500.275832]        ... key      at: [<c04=
419bc>] __key.16723+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]        ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0132e35>] run_hrtimer_p=
ending+0x105/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01332af>] hrtimer_run_p=
ending+0x3f/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124109>] run_timer_sof=
tirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]        -> (i8253_lock){++..} =
ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]           initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01069f0>] init_pit_timer+0x20/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138942>] clockevents_set_mode+0x22/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138965>] clockevents_shutdown+0x15/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138a62>] clockevents_exchange_device+0x52/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138f27>] tick_notify+0xa7/0x270
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c02f91dd>] notifier_call_chain+0x3d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013466f>] raw_notifier_call_chain+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138af2>] clockevents_register_device+0x62/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c03e7b43>] setup_pit_timer+0x9f/0xad
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c03e472d>] hpet_time_init+0xd/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c03de9c0>] start_kernel+0x1fe/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]           in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01069a5>] pit_next_event+0x15/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138bdd>] clockevents_program_event+0x9d/0x150
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0139303>] tick_dev_program_event+0x43/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01393dc>] tick_program_event+0x1c/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0133ab8>] hrtimer_interrupt+0x188/0x1c0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]           in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01069f0>] init_pit_timer+0x20/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0138942>] clockevents_set_mode+0x22/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c013925f>] tick_switch_to_oneshot+0x6f/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01392b2>] tick_init_highres+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c01332cf>] hrtimer_run_pending+0x5f/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0124109>] run_timer_softirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                        [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]         }
Sep 29 17:51:09 cooker kernel: [42500.275832]         ... key      at: [<c0=
3bb710>] i8253_lock+0x10/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]         ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01068f0>] pit_read+0x30=
/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013774b>] clocksource_r=
egister+0xfb/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03e7aa2>] init_pit_cloc=
ksource+0x84/0x86
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]         -> (clocksource_lock)=
{++..} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]            initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0137402>] clocksource_get_next+0x12/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c03ec3e5>] timekeeping_init+0x3c/0x18c
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c03de92d>] start_kernel+0x16b/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]            in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0137402>] clocksource_get_next+0x12/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0136062>] update_wall_time+0x402/0x850
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0124569>] do_timer+0x29/0x100
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0139151>] tick_periodic+0x61/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0139187>] tick_handle_periodic+0x17/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]            in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0137402>] clocksource_get_next+0x12/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0136062>] update_wall_time+0x402/0x850
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0124569>] do_timer+0x29/0x100
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0139151>] tick_periodic+0x61/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0139187>] tick_handle_periodic+0x17/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                          [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]          }
Sep 29 17:51:09 cooker kernel: [42500.275832]          ... key      at: [<c=
03c0a90>] clocksource_lock+0x10/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]          ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0137679>] clocksource_r=
egister+0x29/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03e7aa2>] init_pit_cloc=
ksource+0x84/0x86
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]         ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01374b6>] clocksource_u=
nregister+0x16/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0106a8a>] init_pit_time=
r+0xba/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0138942>] clockevents_s=
et_mode+0x22/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013925f>] tick_switch_t=
o_oneshot+0x6f/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01392b2>] tick_init_hig=
hres+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01332cf>] hrtimer_run_p=
ending+0x5f/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124109>] run_timer_sof=
tirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]        ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01069a5>] pit_next_even=
t+0x15/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0138bdd>] clockevents_p=
rogram_event+0x9d/0x150
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0139303>] tick_dev_prog=
ram_event+0x43/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01393dc>] tick_program_=
event+0x1c/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0132aa4>] hrtimer_repro=
gram+0x74/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0132cc6>] enqueue_hrtim=
er+0xb6/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0133646>] hrtimer_start=
+0x76/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0139a26>] tick_setup_sc=
hed_timer+0x96/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013333b>] hrtimer_run_p=
ending+0xcb/0x110
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0124109>] run_timer_sof=
tirq+0x19/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]       ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01335f7>] hrtimer_start=
+0x27/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0114f86>] enqueue_task_=
rt+0x106/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01120e0>] activate_task=
+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0117089>] __sched_setsc=
heduler+0x199/0x360
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0117282>] sched_setsche=
duler+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c015993a>] watchdog+0x2a=
/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0114f32>] enqueue_task_=
rt+0xb2/0x120
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01120e0>] activate_task=
+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0117089>] __sched_setsc=
heduler+0x199/0x360
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0117282>] sched_setsche=
duler+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c015993a>] watchdog+0x2a=
/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]      -> (&rt_rq->rt_runtime_l=
ock){++..} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]         initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0112da7>] update_curr_rt+0x97/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0112eb6>] dequeue_task_rt+0x16/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c011202b>] dequeue_task+0x9b/0x100
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f412c>] schedule+0x3dc/0x4f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015998d>] watchdog+0x7d/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c012f58f>] kthread+0x3f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c01035df>] kernel_thread_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]         in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0114d7a>] sched_rt_period_timer+0xaa/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013300c>] __run_hrtimer+0x9c/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0133a7f>] hrtimer_interrupt+0x14f/0x1c0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]         in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0114d7a>] sched_rt_period_timer+0xaa/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c013300c>] __run_hrtimer+0x9c/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0133a7f>] hrtimer_interrupt+0x14f/0x1c0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104cb9>] timer_interrupt+0x19/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]       }
Sep 29 17:51:09 cooker kernel: [42500.275832]       ... key      at: [<c041=
f23c>] __key.35056+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0112da7>] update_curr_r=
t+0x97/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0112eb6>] dequeue_task_=
rt+0x16/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011202b>] dequeue_task+=
0x9b/0x100
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f412c>] schedule+0x3d=
c/0x4f0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c015998d>] watchdog+0x7d=
/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0113b97>] enqueue_entit=
y+0x177/0x2a0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01151f9>] enqueue_task_=
fair+0x39/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01120e0>] activate_task=
+0x50/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01146ef>] try_to_wake_u=
p+0xef/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011474b>] default_wake_=
function+0xb/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f8a0>] autoremove_wa=
ke_function+0x20/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0113177>] __wake_up+0x3=
7/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012bb6a>] insert_work+0=
x4a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c45d>] __queue_work+=
0x2d/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c4d1>] queue_work_on=
+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c593>] queue_work+0x=
13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012b6ca>] call_usermode=
helper_exec+0xca/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d57>] kobject_ueven=
t_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d9a>] kobject_ueven=
t+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f63d9>] kset_register=
+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0264f97>] __class_regis=
ter+0xb7/0x1a0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02650cf>] __class_creat=
e+0x4f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03ef623>] bdi_class_ini=
t+0x19/0x3a
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01335f7>] hrtimer_start=
+0x27/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0115028>] hrtick_start_=
fair+0x88/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011515f>] pick_next_tas=
k_fair+0xcf/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f3e42>] schedule+0xf2=
/0x4f0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f45d5>] schedule_time=
out+0xa5/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f43cc>] wait_for_comm=
on+0xbc/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f44d2>] wait_for_comp=
letion+0x12/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012b6d7>] call_usermode=
helper_exec+0xd7/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d57>] kobject_ueven=
t_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d9a>] kobject_ueven=
t+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f63d9>] kset_register=
+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0262e2d>] sysdev_class_=
register+0x5d/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03e5012>] i8259A_init_s=
ysfs+0x12/0x29
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]     ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0113f27>] task_rq_lock+=
0x17/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011462f>] try_to_wake_u=
p+0x2f/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011474b>] default_wake_=
function+0xb/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01130bd>] complete+0x3d=
/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f573>] kthread+0x23/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]     ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0113177>] __wake_up+0x3=
7/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012bb6a>] insert_work+0=
x4a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c45d>] __queue_work+=
0x2d/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c4d1>] queue_work_on=
+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c593>] queue_work+0x=
13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012b6ca>] call_usermode=
helper_exec+0xca/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d57>] kobject_ueven=
t_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d9a>] kobject_ueven=
t+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f63d9>] kset_register=
+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0264f97>] __class_regis=
ter+0xb7/0x1a0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02650cf>] __class_creat=
e+0x4f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03ef623>] bdi_class_ini=
t+0x19/0x3a
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]     -> (&ep->lock){....} ops:=
 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]        initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c01bc63e>] sys_epoll_ctl+0x2ee/0x430
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
                  [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      }
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... key      at: [<c0927=
a78>] __key.19115+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]      ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0113f27>] task_rq_lock+=
0x17/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011462f>] try_to_wake_u=
p+0x2f/0x140
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011474b>] default_wake_=
function+0xb/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011253d>] __wake_up_loc=
ked+0x1d/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01bbaae>] ep_poll_callb=
ack+0x7e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011311d>] __wake_up_syn=
c+0x3d/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0285388>] sock_def_read=
able+0x48/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02ec3a8>] unix_stream_c=
onnect+0x3b8/0x3e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0283522>] sys_connect+0=
x62/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0284010>] sys_socketcal=
l+0x280/0x2c0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]     ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01bba53>] ep_poll_callb=
ack+0x23/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01124f8>] __wake_up_com=
mon+0x48/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011311d>] __wake_up_syn=
c+0x3d/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0285388>] sock_def_read=
able+0x48/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02ec3a8>] unix_stream_c=
onnect+0x3b8/0x3e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0283522>] sys_connect+0=
x62/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0284010>] sys_socketcal=
l+0x280/0x2c0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]    ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011315b>] __wake_up+0x1=
b/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012bb6a>] insert_work+0=
x4a/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c45d>] __queue_work+=
0x2d/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c4d1>] queue_work_on=
+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c593>] queue_work+0x=
13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012b6ca>] call_usermode=
helper_exec+0xca/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d57>] kobject_ueven=
t_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d9a>] kobject_ueven=
t+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f63d9>] kset_register=
+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0263e0d>] bus_register+=
0xad/0x230
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03f5dd6>] platform_bus_=
init+0x28/0x3a
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03f5ea5>] driver_init+0=
x25/0x39
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de4fd>] kernel_init+0=
x5a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]    ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c45d>] __queue_work+=
0x2d/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c4d1>] queue_work_on=
+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c593>] queue_work+0x=
13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012b6ca>] call_usermode=
helper_exec+0xca/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d57>] kobject_ueven=
t_env+0x357/0x390
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f6d9a>] kobject_ueven=
t+0xa/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01f63d9>] kset_register=
+0x49/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0264f97>] __class_regis=
ter+0xb7/0x1a0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02650cf>] __class_creat=
e+0x4f/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03ef623>] bdi_class_ini=
t+0x19/0x3a
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c44f>] __queue_work+=
0x1f/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c4d1>] queue_work_on=
+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c593>] queue_work+0x=
13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012c5b4>] schedule_work=
+0x14/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe88ff6>] sdev_evt_send=
+0x46/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8903b>] sdev_evt_send=
_simple+0x2b/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfd99464>] sd_media_chan=
ged+0x94/0x1e0 [sd_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01b6855>] check_disk_ch=
ange+0x25/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfd9981e>] sd_open+0x9e/=
0x1d0 [sd_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01b724d>] do_open+0x7d/=
0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01b7605>] __blkdev_get+=
0xc5/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01b763a>] blkdev_get+0x=
1a/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01cd370>] register_disk=
+0x170/0x190
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01eeb6e>] add_disk+0x4e=
/0xb0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfd99194>] sd_probe+0x2a=
4/0x440 [sd_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c026431c>] driver_probe_=
device+0x8c/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02644c1>] __driver_atta=
ch+0x81/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0263b8b>] bus_for_each_=
dev+0x5b/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c026417e>] driver_attach=
+0x1e/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02634ff>] bus_add_drive=
r+0x1cf/0x250
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02646a1>] driver_regist=
er+0x71/0x150
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ed64>] scsi_register=
_driver+0x14/0x20 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfd600f4>] 0xdfd600f4
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01493da>] sys_init_modu=
le+0x8a/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe843f9>] scsi_get_comm=
and+0x59/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a15c>] scsi_setup_bl=
k_pc_cmnd+0x10c/0x150 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a1e5>] scsi_prep_fn+=
0x45/0x50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e786d>] elv_next_requ=
est+0xdd/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe895c4>] scsi_request_=
fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec2fe>] blk_execute_r=
q_nowait+0x5e/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec3ee>] blk_execute_r=
q+0xae/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ae79>] scsi_execute+=
0xd9/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8af2f>] scsi_execute_=
req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8c0a5>] scsi_probe_an=
d_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8cd54>] __scsi_scan_t=
arget+0xf4/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d3cf>] scsi_scan_cha=
nnel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d4c9>] scsi_scan_hos=
t_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d60c>] do_scsi_scan_=
host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d8ce>] scsi_scan_hos=
t+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfea3a9d>] usb_stor_scan=
_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011309b>] complete+0x1b=
/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec298>] blk_end_sync_=
rq+0x28/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e8ea2>] end_that_requ=
est_last+0x52/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e90ae>] blk_end_io+0x=
5e/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e918f>] blk_end_reque=
st+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89d2d>] scsi_end_requ=
est+0x2d/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a32c>] scsi_io_compl=
etion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe83733>] scsi_finish_c=
ommand+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a943>] scsi_softirq_=
done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e81fd>] blk_done_soft=
irq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&n->list_lock){++..} ops=
: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0186e51>] add_partial+0x21/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0189464>] __slab_free+0x2e4/0x310
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c018aa85>] kmem_cache_free+0x75/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c022635c>] acpi_os_release_object+0xd/0x11
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02379bb>] acpi_ps_free_op+0x21/0x23
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0237748>] acpi_ps_delete_parse_tree+0x38/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0236d2f>] acpi_ps_complete_this_op+0x13b/0x154
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0236d6b>] acpi_ps_complete_op+0x23/0x1f1
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0237532>] acpi_ps_parse_loop+0x5f9/0x727
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c023692b>] acpi_ps_parse_aml+0x72/0x260
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0236223>] acpi_ns_one_complete_parse+0xeb/0xfe
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0236252>] acpi_ns_parse_table+0x1c/0x32
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0234376>] acpi_ns_load_table+0x42/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02392af>] acpi_load_tables+0xe0/0x193
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03f3ba4>] acpi_early_init+0x62/0xf5
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03dea45>] start_kernel+0x283/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0186e51>] add_partial+0x21/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0189464>] __slab_free+0x2e4/0x310
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c018aa85>] kmem_cache_free+0x75/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0169c73>] mempool_free_slab+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0169eaf>] mempool_free+0x7f/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8e0c>] __blk_put_request+0x5c/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8ecc>] end_that_request_last+0x7c/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e91d0>] __blk_end_request+0x30/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df831977>] __ide_end_request+0x37/0xd0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df831ac9>] ide_end_request+0x59/0x90 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df838315>] task_end_request+0x35/0x80 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df83ad16>] ide_dma_intr+0x56/0xa0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<df832b48>] ide_intr+0x98/0x220 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0186e51>] add_partial+0x21/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0189464>] __slab_free+0x2e4/0x310
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c018aa85>] kmem_cache_free+0x75/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c018dd94>] file_free_rcu+0x14/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015c4e2>] __rcu_process_callbacks+0x82/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c015c677>] rcu_process_callbacks+0x17/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<c0927124=
>] __key.20190+0x0/0x8
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6aca>] _spin_lock+0x=
3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0188fce>] __slab_alloc+=
0x3be/0x570
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c018955f>] kmem_cache_al=
loc+0xcf/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0169c13>] mempool_alloc=
_slab+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0169ef5>] mempool_alloc=
+0x35/0xf0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89cf4>] scsi_sg_alloc=
+0x54/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01fed18>] __sg_alloc_ta=
ble+0x58/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89bd8>] scsi_init_sgt=
able+0x38/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89eec>] scsi_init_io+=
0x1c/0xc0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a0b5>] scsi_setup_bl=
k_pc_cmnd+0x65/0x150 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a1e5>] scsi_prep_fn+=
0x45/0x50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e786d>] elv_next_requ=
est+0xdd/0x1e0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe895c4>] scsi_request_=
fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec2fe>] blk_execute_r=
q_nowait+0x5e/0xa0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01ec3ee>] blk_execute_r=
q+0xae/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ae79>] scsi_execute+=
0xd9/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8af2f>] scsi_execute_=
req+0x6f/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8c0a5>] scsi_probe_an=
d_add_lun+0x245/0xc50 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d033>] __scsi_scan_t=
arget+0x3d3/0x710 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d3cf>] scsi_scan_cha=
nnel+0x5f/0xa0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d4c9>] scsi_scan_hos=
t_selected+0xb9/0x180 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d60c>] do_scsi_scan_=
host+0x7c/0x80 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8d8ce>] scsi_scan_hos=
t+0x14e/0x1b0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfea3a9d>] usb_stor_scan=
_thread+0x14d/0x190 [usb_storage]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c012f58f>] kthread+0x3f/=
0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&sfp->rq_list_lock){.+..=
} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6e59>] _write_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfeb7794>] sg_add_request+0x24/0xe0 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfeb8f34>] sg_new_write+0x64/0x2a0 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfeb95af>] sg_ioctl+0x43f/0xb70 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c019990e>] vfs_ioctl+0x6e/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]     in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6e59>] _write_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfeb838a>] sg_cmd_done+0x1ba/0x300 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8ad76>] scsi_end_async+0x36/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e8ea2>] end_that_request_last+0x52/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e90ae>] blk_end_io+0x5e/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e918f>] blk_end_request+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe89d2d>] scsi_end_request+0x2d/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a32c>] scsi_io_completion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe83733>] scsi_finish_command+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfe8a943>] scsi_softirq_done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01e81fd>] blk_done_softirq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<dfebdca8=
>] __key.25946+0x0/0xffffd115 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c011315b>] __wake_up+0x1=
b/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfeb83b2>] sg_cmd_done+0=
x1e2/0x300 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ad76>] scsi_end_asyn=
c+0x36/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e8ea2>] end_that_requ=
est_last+0x52/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e90ae>] blk_end_io+0x=
5e/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e918f>] blk_end_reque=
st+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89d2d>] scsi_end_requ=
est+0x2d/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a32c>] scsi_io_compl=
etion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe83733>] scsi_finish_c=
ommand+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a943>] scsi_softirq_=
done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e81fd>] blk_done_soft=
irq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6e59>] _write_lock_i=
rqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfeb838a>] sg_cmd_done+0=
x1ba/0x300 [sg]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8ad76>] scsi_end_asyn=
c+0x36/0x60 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e8ea2>] end_that_requ=
est_last+0x52/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e90ae>] blk_end_io+0x=
5e/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e918f>] blk_end_reque=
st+0x1f/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe89d2d>] scsi_end_requ=
est+0x2d/0x90 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a32c>] scsi_io_compl=
etion+0x13c/0x490 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe83733>] scsi_finish_c=
ommand+0x83/0xe0 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfe8a943>] scsi_softirq_=
done+0x103/0x120 [scsi_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01e81fd>] blk_done_soft=
irq+0x6d/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0120612>] __do_softirq+=
0x62/0xc0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0104c56>] do_softirq+0x=
96/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]  -> (&m->lock){....} ops: 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfec43df>] multipath_resume+0x1f/0x40 [dm_multipath]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfda2232>] dm_table_resume_targets+0x82/0xa0 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfda10b1>] dm_resume+0x81/0x110 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfda5169>] dev_suspend+0x129/0x1c0 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<dfda5b5b>] dm_ctl_ioctl+0x1cb/0x240 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]   }
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... key      at: [<dfec7d38=
>] __key.23671+0x0/0xffffe49c [dm_multipath]
Sep 29 17:51:09 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfec5163>] multipath_sta=
tus+0x473/0x690 [dm_multipath]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfda48ed>] retrieve_stat=
us+0x7d/0x180 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfda4a58>] table_status+=
0x68/0x80 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<dfda5b5b>] dm_ctl_ioctl+=
0x1cb/0x240 [dm_mod]
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c01998c5>] vfs_ioctl+0x2=
5/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0199b5a>] do_vfs_ioctl+=
0x23a/0x2b0
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c0199c0e>] sys_ioctl+0x3=
e/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:09 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]=20
Sep 29 17:51:09 cooker kernel: [42500.275832]   -> (&zone->lock){++..} ops:=
 0 {
Sep 29 17:51:09 cooker kernel: [42500.275832]      initial-use  at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c421>] free_pages_bulk+0x21/0x2d0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c84c>] free_hot_cold_page+0x17c/0x1a0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c8df>] free_hot_page+0xf/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c91f>] __free_pages+0x2f/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03ff9aa>] __free_pages_bootmem+0x5d/0x61
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03ee299>] free_all_bootmem_core+0x1b2/0x1ea
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03ee2e3>] free_all_bootmem+0x12/0x14
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03e9f26>] mem_init+0x21/0x29a
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03de9a3>] start_kernel+0x1e1/0x2f0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c03de33d>] i386_start_kernel+0x9d/0xa9
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-hardirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013ea2b>] __lock_acquire+0x6cb/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c15a>] __free_pages_ok+0x11a/0x3a0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c90f>] __free_pages+0x1f/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0187770>] __free_slab+0x80/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0187844>] discard_slab+0x24/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0189443>] __slab_free+0x2c3/0x310
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c018aa85>] kmem_cache_free+0x75/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0169c73>] mempool_free_slab+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0169eaf>] mempool_free+0x7f/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01b50c9>] bio_free+0x29/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01b50f3>] bio_fs_destructor+0x13/0x20
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01b48f3>] bio_put+0x33/0x50
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01b9bb7>] mpage_end_io_read+0x67/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01b4981>] bio_endio+0x21/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01e8519>] req_bio_endio+0x79/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01e85ea>] __end_that_request_first+0x7a/0x290
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01e91e7>] __blk_end_request+0x47/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<df831977>] __ide_end_request+0x37/0xd0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<df831ac9>] ide_end_request+0x59/0x90 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<df838315>] task_end_request+0x35/0x80 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<df83ad16>] ide_dma_intr+0x56/0xa0 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<df832b48>] ide_intr+0x98/0x220 [ide_core]
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015a271>] handle_IRQ_event+0x31/0x60
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015b6fe>] handle_level_irq+0x6e/0xe0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0104b40>] do_IRQ+0xb0/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:09 cooker kernel: [42500.275832]      in-softirq-W at:
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013e838>] __lock_acquire+0x4d8/0x1640
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c15a>] __free_pages_ok+0x11a/0x3a0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c016c90f>] __free_pages+0x1f/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0187770>] __free_slab+0x80/0x130
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0187844>] discard_slab+0x24/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c0189443>] __slab_free+0x2c3/0x310
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c018aa85>] kmem_cache_free+0x75/0xd0
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c01197c1>] free_task+0x31/0x40
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c011ab12>] __put_task_struct+0x52/0x90
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c011ca57>] delayed_put_task_struct+0x27/0x30
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015c4e2>] __rcu_process_callbacks+0x82/0x200
Sep 29 17:51:09 cooker kernel: [42500.275832]                              =
              [<c015c677>] rcu_process_callbacks+0x17/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c0120612>] __do_softirq+0x62/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]    }
Sep 29 17:51:10 cooker kernel: [42500.275832]    ... key      at: [<c09264d=
c>] __key.25555+0x0/0x8
Sep 29 17:51:10 cooker kernel: [42500.275832]    ... acquired at:
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0160f5d>] ftrace_record=
_ip+0x9d/0x1b0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01035f7>] mcount_call+0=
x5/0xa
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016cff8>] get_page_from=
_freelist+0x458/0x490
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016d0e6>] __alloc_pages=
_internal+0xb6/0x460
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0188f91>] __slab_alloc+=
0x381/0x570
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018955f>] kmem_cache_al=
loc+0xcf/0xe0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0281a28>] sock_alloc_in=
ode+0x18/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01a1f30>] alloc_inode+0=
x20/0x1d0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01a23bc>] new_inode+0x1=
c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01ac240>] get_sb_pseudo=
+0x90/0x130
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0281738>] sockfs_get_sb=
+0x28/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018e46f>] vfs_kern_moun=
t+0x3f/0xa0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018e4ea>] kern_mount_da=
ta+0x1a/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c03f9d61>] sock_init+0x5=
1/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c010111b>] do_one_initca=
ll+0x2b/0x170
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c03de51d>] kernel_init+0=
x7a/0xcc
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01035df>] kernel_thread=
_helper+0x7/0x10
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016cfe8>] get_page_from=
_freelist+0x448/0x490
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016d0e6>] __alloc_pages=
_internal+0xb6/0x460
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0188f91>] __slab_alloc+=
0x381/0x570
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018955f>] kmem_cache_al=
loc+0xcf/0xe0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda6efd>] dm_path_ueven=
t+0x4d/0x200 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfec4b66>] fail_path+0x9=
6/0xc0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfec547d>] multipath_end=
_io+0xfd/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda06c2>] clone_endio+0=
x52/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b4981>] bio_endio+0x2=
1/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8519>] req_bio_endio=
+0x79/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e85ea>] __end_that_re=
quest_first+0x7a/0x290
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e91e7>] __blk_end_req=
uest+0x47/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e92cf>] end_queued_re=
quest+0x3f/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e789e>] elv_next_requ=
est+0x10e/0x1e0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfe895c4>] scsi_request_=
fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e9c56>] generic_unplu=
g_device+0x26/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda2321>] dm_table_unpl=
ug_all+0x31/0x50 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda1d9f>] dm_unplug_all=
+0x1f/0x30 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8030>] blk_backing_d=
ev_unplug+0x10/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b0a11>] block_sync_pa=
ge+0x31/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671a0>] sync_page+0x3=
0/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671dd>] sync_page_kil=
lable+0xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f46a9>] __wait_on_bit=
_lock+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016707f>] __lock_page_k=
illable+0xaf/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01693d7>] generic_file_=
aio_read+0x347/0x640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018ce59>] do_sync_read+=
0xd9/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018d971>] vfs_read+0xa1=
/0x140
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018dae2>] sys_read+0x42=
/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832]   -> (&md->uevent_lock){....}=
 ops: 0 {
Sep 29 17:51:10 cooker kernel: [42500.275832]      initial-use  at:
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfda0286>] dm_uevent_add+0x26/0x60 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfda6fe0>] dm_path_uevent+0x130/0x200 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfec4b66>] fail_path+0x96/0xc0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfec547d>] multipath_end_io+0xfd/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfda06c2>] clone_endio+0x52/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01b4981>] bio_endio+0x21/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e8519>] req_bio_endio+0x79/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e85ea>] __end_that_request_first+0x7a/0x290
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e91e7>] __blk_end_request+0x47/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e92cf>] end_queued_request+0x3f/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e789e>] elv_next_request+0x10e/0x1e0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfe895c4>] scsi_request_fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e99d3>] __generic_unplug_device+0x23/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e9c56>] generic_unplug_device+0x26/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e8014>] blk_unplug+0x14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfda2321>] dm_table_unplug_all+0x31/0x50 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<dfda1d9f>] dm_unplug_all+0x1f/0x30 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e8014>] blk_unplug+0x14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01e8030>] blk_backing_dev_unplug+0x10/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01b0a11>] block_sync_page+0x31/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01671a0>] sync_page+0x30/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01671dd>] sync_page_killable+0xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c02f46a9>] __wait_on_bit_lock+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c016707f>] __lock_page_killable+0xaf/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c01693d7>] generic_file_aio_read+0x347/0x640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c018ce59>] do_sync_read+0xd9/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c018d971>] vfs_read+0xa1/0x140
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c018dae2>] sys_read+0x42/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
              [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]    }
Sep 29 17:51:10 cooker kernel: [42500.275832]    ... key      at: [<dfdace9=
8>] __key.23750+0x0/0xffffa3e5 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]   ... acquired at:
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda0286>] dm_uevent_add=
+0x26/0x60 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda6fe0>] dm_path_ueven=
t+0x130/0x200 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfec4b66>] fail_path+0x9=
6/0xc0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfec547d>] multipath_end=
_io+0xfd/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda06c2>] clone_endio+0=
x52/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b4981>] bio_endio+0x2=
1/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8519>] req_bio_endio=
+0x79/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e85ea>] __end_that_re=
quest_first+0x7a/0x290
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e91e7>] __blk_end_req=
uest+0x47/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e92cf>] end_queued_re=
quest+0x3f/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e789e>] elv_next_requ=
est+0x10e/0x1e0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfe895c4>] scsi_request_=
fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e9c56>] generic_unplu=
g_device+0x26/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda2321>] dm_table_unpl=
ug_all+0x31/0x50 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda1d9f>] dm_unplug_all=
+0x1f/0x30 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8030>] blk_backing_d=
ev_unplug+0x10/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b0a11>] block_sync_pa=
ge+0x31/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671a0>] sync_page+0x3=
0/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671dd>] sync_page_kil=
lable+0xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f46a9>] __wait_on_bit=
_lock+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016707f>] __lock_page_k=
illable+0xaf/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01693d7>] generic_file_=
aio_read+0x347/0x640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018ce59>] do_sync_read+=
0xd9/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018d971>] vfs_read+0xa1=
/0x140
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018dae2>] sys_read+0x42=
/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfec5420>] multipath_end=
_io+0xa0/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda06c2>] clone_endio+0=
x52/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b4981>] bio_endio+0x2=
1/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8519>] req_bio_endio=
+0x79/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e85ea>] __end_that_re=
quest_first+0x7a/0x290
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e91e7>] __blk_end_req=
uest+0x47/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e92cf>] end_queued_re=
quest+0x3f/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e789e>] elv_next_requ=
est+0x10e/0x1e0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfe895c4>] scsi_request_=
fn+0x64/0x430 [scsi_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e99d3>] __generic_unp=
lug_device+0x23/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e9c56>] generic_unplu=
g_device+0x26/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda2321>] dm_table_unpl=
ug_all+0x31/0x50 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda1d9f>] dm_unplug_all=
+0x1f/0x30 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8014>] blk_unplug+0x=
14/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01e8030>] blk_backing_d=
ev_unplug+0x10/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01b0a11>] block_sync_pa=
ge+0x31/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671a0>] sync_page+0x3=
0/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01671dd>] sync_page_kil=
lable+0xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f46a9>] __wait_on_bit=
_lock+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c016707f>] __lock_page_k=
illable+0xaf/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01693d7>] generic_file_=
aio_read+0x347/0x640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018ce59>] do_sync_read+=
0xd9/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018d971>] vfs_read+0xa1=
/0x140
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c018dae2>] sys_read+0x42=
/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832] the soft-irq-unsafe lock's de=
pendencies:
Sep 29 17:51:10 cooker kernel: [42500.275832] -> (_minor_lock){--..} ops: 0=
 {
Sep 29 17:51:10 cooker kernel: [42500.275832]    initial-use  at:
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda0f39>] dm_create+0x3d9/0x480 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda56c1>] dev_create+0x41/0x280 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda5b5b>] dm_ctl_ioctl+0x1cb/0x240 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]    softirq-on-W at:
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013e87d>] __lock_acquire+0x51d/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda0f39>] dm_create+0x3d9/0x480 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda56c1>] dev_create+0x41/0x280 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda5b5b>] dm_ctl_ioctl+0x1cb/0x240 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]    hardirq-on-W at:
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013e855>] __lock_acquire+0x4f5/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c02f6aca>] _spin_lock+0x3a/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda0f39>] dm_create+0x3d9/0x480 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda56c1>] dev_create+0x41/0x280 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<dfda5b5b>] dm_ctl_ioctl+0x1cb/0x240 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
          [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]  }
Sep 29 17:51:10 cooker kernel: [42500.275832]  ... key      at: [<dfdaca70>=
] _minor_lock+0x10/0xffffa81d [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  -> (_minor_idr.lock){....} o=
ps: 0 {
Sep 29 17:51:10 cooker kernel: [42500.275832]     initial-use  at:
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c013e4c0>] __lock_acquire+0x160/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c013f9fc>] lock_acquire+0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c02f6c29>] _spin_lock_irqsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c01f57c7>] idr_pre_get+0x27/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<dfda0f27>] dm_create+0x3c7/0x480 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<dfda56c1>] dev_create+0x41/0x280 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<dfda5b5b>] dm_ctl_ioctl+0x1cb/0x240 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c01998c5>] vfs_ioctl+0x25/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c0199b5a>] do_vfs_ioctl+0x23a/0x2b0
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c0199c0e>] sys_ioctl+0x3e/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<c010329d>] sysenter_do_call+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]                              =
            [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]   }
Sep 29 17:51:10 cooker kernel: [42500.275832]   ... key      at: [<dfdacaa0=
>] _minor_idr+0x20/0xffffa7fd [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  ... acquired at:
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f3b1>] __lock_acquir=
e+0x1051/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c013f9fc>] lock_acquire+=
0x5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c02f6c29>] _spin_lock_ir=
qsave+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01f51ad>] get_from_free=
_list+0x1d/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01f54a5>] idr_get_empty=
_slot+0x255/0x270
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01f56b4>] idr_get_new_a=
bove_int+0x14/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01f572d>] idr_get_new+0=
xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda0f4b>] dm_create+0x3=
eb/0x480 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda56c1>] dev_create+0x=
41/0x280 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<dfda5b5b>] dm_ctl_ioctl+=
0x1cb/0x240 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c01998c5>] vfs_ioctl+0x2=
5/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0199b5a>] do_vfs_ioctl+=
0x23a/0x2b0
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c0199c0e>] sys_ioctl+0x3=
e/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<c010329d>] sysenter_do_c=
all+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]    [<ffffffff>] 0xffffffff
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832]=20
Sep 29 17:51:10 cooker kernel: [42500.275832] stack backtrace:
Sep 29 17:51:10 cooker kernel: [42500.275832] Pid: 28259, comm: dd Not tain=
ted 2.6.27-rc7-1avb #11
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c02f3c22>] ? printk+0x1d/0=
x23
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013e2ee>] check_usage+0x3=
4e/0x3c0
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013f231>] __lock_acquire+=
0xed1/0x1640
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013f9fc>] lock_acquire+0x=
5c/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01f4c68>] ? _atomic_dec_a=
nd_lock+0x18/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c02f6aca>] _spin_lock+0x3a=
/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01f4c68>] ? _atomic_dec_a=
nd_lock+0x18/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01f4c68>] _atomic_dec_and=
_lock+0x18/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda1a2a>] dm_put+0x2a/0x1=
90 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda6fe8>] dm_path_uevent+=
0x138/0x200 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfec4b66>] fail_path+0x96/=
0xc0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfec547d>] multipath_end_i=
o+0xfd/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda06c2>] clone_endio+0x5=
2/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfec5380>] ? multipath_end=
_io+0x0/0x1c0 [dm_multipath]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda0670>] ? clone_endio+0=
x0/0xc0 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01b4981>] bio_endio+0x21/=
0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e8519>] req_bio_endio+0=
x79/0xd0
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013ba15>] ? lock_release_=
holdtime+0x35/0x200
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e85ea>] __end_that_requ=
est_first+0x7a/0x290
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013b9db>] ? trace_hardirq=
s_off+0xb/0x10
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e91e7>] __blk_end_reque=
st+0x47/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e92cf>] end_queued_requ=
est+0x3f/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e789e>] elv_next_reques=
t+0x10e/0x1e0
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c0124a06>] ? del_timer+0x5=
6/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfe895c4>] scsi_request_fn=
+0x64/0x430 [scsi_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c02f68e7>] ? _spin_unlock_=
irqrestore+0x57/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e99d3>] __generic_unplu=
g_device+0x23/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e9c56>] generic_unplug_=
device+0x26/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e8014>] blk_unplug+0x14=
/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda2321>] dm_table_unplug=
_all+0x31/0x50 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<dfda1d9f>] dm_unplug_all+0=
x1f/0x30 [dm_mod]
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e8020>] ? blk_backing_d=
ev_unplug+0x0/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e8014>] blk_unplug+0x14=
/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01e8030>] blk_backing_dev=
_unplug+0x10/0x20
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01b0a11>] block_sync_page=
+0x31/0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01671a0>] sync_page+0x30/=
0x60
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01671dd>] sync_page_killa=
ble+0xd/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c02f46a9>] __wait_on_bit_l=
ock+0x49/0x80
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01671d0>] ? sync_page_kil=
lable+0x0/0x40
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c016707f>] __lock_page_kil=
lable+0xaf/0xc0
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c012f8d0>] ? wake_bit_func=
tion+0x0/0x70
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c01693d7>] generic_file_ai=
o_read+0x347/0x640
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c018ce59>] do_sync_read+0x=
d9/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c0106d87>] ? native_sched_=
clock+0x77/0xb0
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c012f880>] ? autoremove_wa=
ke_function+0x0/0x50
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013da6b>] ? trace_hardirq=
s_on+0xb/0x10
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c013da6b>] ? trace_hardirq=
s_on+0xb/0x10
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c02f6887>] ? _spin_unlock_=
irq+0x27/0x30
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c018d971>] vfs_read+0xa1/0=
x140
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c018cd80>] ? do_sync_read+=
0x0/0x120
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c018dae2>] sys_read+0x42/0=
x70
Sep 29 17:51:10 cooker kernel: [42500.275832]  [<c010329d>] sysenter_do_cal=
l+0x12/0x31
Sep 29 17:51:10 cooker kernel: [42500.275832]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 29 17:51:13 cooker multipathd: sda: directio checker reports path is do=
wn=20
Sep 29 17:51:18 cooker multipathd: sda: directio checker reports path is do=
wn=20
Sep 29 17:51:23 cooker multipathd: sda: directio checker reports path is do=
wn=20
Sep 29 17:51:28 cooker multipathd: sda: directio checker reports path is do=
wn=20
Sep 29 17:51:33 cooker multipathd: sda: directio checker reports path is do=
wn=20
Sep 29 17:51:34 cooker multipathd: 12345678: Disable queueing=20
Sep 29 17:51:38 cooker multipathd: sda: directio checker reports path is do=
wn=20

--Boundary-01=_txO4IuP7tKQ441R
Content-Type: text/x-log;
  charset="us-ascii";
  name="multipath-2.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="multipath-2.log"

Sep 29 18:11:26 cooker kernel: [  297.924302] end_request: I/O error, dev s=
da, sector 3040
Sep 29 18:11:26 cooker kernel: [  297.924359] device-mapper: multipath: Fai=
ling path 8:0.
Sep 29 18:11:26 cooker kernel: [  297.924608]=20
Sep 29 18:11:26 cooker kernel: [  297.924611] =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 29 18:11:26 cooker kernel: [  297.924619] [ INFO: inconsistent lock sta=
te ]
Sep 29 18:11:26 cooker kernel: [  297.924628] 2.6.27-rc7-1avb #11
Sep 29 18:11:26 cooker kernel: [  297.924635] -----------------------------=
=2D---
Sep 29 18:11:26 cooker kernel: [  297.924643] inconsistent {softirq-on-W} -=
> {in-softirq-W} usage.
Sep 29 18:11:26 cooker kernel: [  297.924653] ksoftirqd/0/3 [HC0[0]:SC1[1]:=
HE0:SE0] takes:
Sep 29 18:11:26 cooker kernel: [  297.924663]  (_minor_lock){-+..}, at: [<c=
01f4c68>] _atomic_dec_and_lock+0x18/0x40
Sep 29 18:11:26 cooker kernel: [  297.924711] {softirq-on-W} state was regi=
stered at:
Sep 29 18:11:26 cooker kernel: [  297.924721]   [<c013e87d>] __lock_acquire=
+0x51d/0x1640
Sep 29 18:11:26 cooker kernel: [  297.924761]   [<c013f9fc>] lock_acquire+0=
x5c/0x80
Sep 29 18:11:26 cooker kernel: [  297.924774]   [<c02f6aca>] _spin_lock+0x3=
a/0x70
Sep 29 18:11:26 cooker kernel: [  297.924803]   [<dfd97f39>] dm_create+0x3d=
9/0x480 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.924895]   [<dfd9c6c1>] dev_create+0x4=
1/0x280 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.924925]   [<dfd9cb5b>] dm_ctl_ioctl+0=
x1cb/0x240 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.924950]   [<c01998c5>] vfs_ioctl+0x25=
/0x80
Sep 29 18:11:26 cooker kernel: [  297.924966]   [<c0199b5a>] do_vfs_ioctl+0=
x23a/0x2b0
Sep 29 18:11:26 cooker kernel: [  297.924977]   [<c0199c0e>] sys_ioctl+0x3e=
/0x70
Sep 29 18:11:26 cooker kernel: [  297.924991]   [<c010329d>] sysenter_do_ca=
ll+0x12/0x31
Sep 29 18:11:26 cooker kernel: [  297.925010]   [<ffffffff>] 0xffffffff
Sep 29 18:11:26 cooker kernel: [  297.925024] irq event stamp: 117181
Sep 29 18:11:26 cooker kernel: [  297.925031] hardirqs last  enabled at (11=
7180): [<c013da6b>] trace_hardirqs_on+0xb/0x10
Sep 29 18:11:26 cooker kernel: [  297.925048] hardirqs last disabled at (11=
7181): [<c013b9db>] trace_hardirqs_off+0xb/0x10
Sep 29 18:11:26 cooker kernel: [  297.925064] softirqs last  enabled at (11=
7160): [<c0120653>] __do_softirq+0xa3/0xc0
Sep 29 18:11:26 cooker kernel: [  297.925102] softirqs last disabled at (11=
7165): [<c0104c56>] do_softirq+0x96/0xd0
Sep 29 18:11:26 cooker kernel: [  297.925125]=20
Sep 29 18:11:26 cooker kernel: [  297.925127] other info that might help us=
 debug this:
Sep 29 18:11:26 cooker kernel: [  297.925137] 1 lock held by ksoftirqd/0/3:
Sep 29 18:11:26 cooker kernel: [  297.925144]  #0:  (&m->lock){.+..}, at: [=
<dfd87af6>] fail_path+0x26/0xc0 [dm_multipath]
Sep 29 18:11:26 cooker kernel: [  297.925186]=20
Sep 29 18:11:26 cooker kernel: [  297.925189] stack backtrace:
Sep 29 18:11:26 cooker kernel: [  297.925206] Pid: 3, comm: ksoftirqd/0 Not=
 tainted 2.6.27-rc7-1avb #11
Sep 29 18:11:26 cooker kernel: [  297.925222]  [<c02f3c22>] ? printk+0x1d/0=
x23
Sep 29 18:11:26 cooker kernel: [  297.925240]  [<c013c8cc>] print_usage_bug=
+0x16c/0x1b0
Sep 29 18:11:26 cooker kernel: [  297.925254]  [<c013d447>] mark_lock+0x667=
/0xa20
Sep 29 18:11:26 cooker kernel: [  297.925267]  [<c013e838>] __lock_acquire+=
0x4d8/0x1640
Sep 29 18:11:26 cooker kernel: [  297.925279]  [<c013f445>] ? __lock_acquir=
e+0x10e5/0x1640
Sep 29 18:11:26 cooker kernel: [  297.925295]  [<dfd97286>] ? dm_uevent_add=
+0x26/0x60 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925325]  [<c013b9db>] ? trace_hardirq=
s_off+0xb/0x10
Sep 29 18:11:26 cooker kernel: [  297.925342]  [<dfd97286>] ? dm_uevent_add=
+0x26/0x60 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925369]  [<c013f9fc>] lock_acquire+0x=
5c/0x80
Sep 29 18:11:26 cooker kernel: [  297.925383]  [<c01f4c68>] ? _atomic_dec_a=
nd_lock+0x18/0x40
Sep 29 18:11:26 cooker kernel: [  297.925401]  [<c02f6aca>] _spin_lock+0x3a=
/0x70
Sep 29 18:11:26 cooker kernel: [  297.925413]  [<c01f4c68>] ? _atomic_dec_a=
nd_lock+0x18/0x40
Sep 29 18:11:26 cooker kernel: [  297.925430]  [<c01f4c68>] _atomic_dec_and=
_lock+0x18/0x40
Sep 29 18:11:26 cooker kernel: [  297.925443]  [<dfd98a2a>] dm_put+0x2a/0x1=
90 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925469]  [<dfd9dfe8>] dm_path_uevent+=
0x138/0x200 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925504]  [<dfd87b66>] fail_path+0x96/=
0xc0 [dm_multipath]
Sep 29 18:11:26 cooker kernel: [  297.925521]  [<dfd8847d>] multipath_end_i=
o+0xfd/0x1c0 [dm_multipath]
Sep 29 18:11:26 cooker kernel: [  297.925538]  [<dfd976c2>] clone_endio+0x5=
2/0xc0 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925564]  [<dfd88380>] ? multipath_end=
_io+0x0/0x1c0 [dm_multipath]
Sep 29 18:11:26 cooker kernel: [  297.925583]  [<dfd97670>] ? clone_endio+0=
x0/0xc0 [dm_mod]
Sep 29 18:11:26 cooker kernel: [  297.925609]  [<c01b4981>] bio_endio+0x21/=
0x40
Sep 29 18:11:26 cooker kernel: [  297.925627]  [<c01e8519>] req_bio_endio+0=
x79/0xd0
Sep 29 18:11:26 cooker kernel: [  297.925646]  [<c01e85ea>] __end_that_requ=
est_first+0x7a/0x290
Sep 29 18:11:26 cooker kernel: [  297.925660]  [<c01e90d7>] blk_end_io+0x87=
/0xc0
Sep 29 18:11:26 cooker kernel: [  297.925672]  [<c01e918f>] blk_end_request=
+0x1f/0x30
Sep 29 18:11:26 cooker kernel: [  297.925685]  [<dfe6ad2d>] scsi_end_reques=
t+0x2d/0x90 [scsi_mod]
Sep 29 18:11:26 cooker kernel: [  297.925855]  [<dfe6b372>] scsi_io_complet=
ion+0x182/0x490 [scsi_mod]
Sep 29 18:11:26 cooker kernel: [  297.925894]  [<c013d995>] ? trace_hardirq=
s_on_caller+0x75/0x140
Sep 29 18:11:26 cooker kernel: [  297.925913]  [<dfe64733>] scsi_finish_com=
mand+0x83/0xe0 [scsi_mod]
Sep 29 18:11:26 cooker kernel: [  297.925951]  [<c013da6b>] ? trace_hardirq=
s_on+0xb/0x10
Sep 29 18:11:26 cooker kernel: [  297.925967]  [<dfe6b943>] scsi_softirq_do=
ne+0x103/0x120 [scsi_mod]
Sep 29 18:11:26 cooker kernel: [  297.926004]  [<c013da6b>] ? trace_hardirq=
s_on+0xb/0x10
Sep 29 18:11:26 cooker kernel: [  297.926020]  [<c013d995>] ? trace_hardirq=
s_on_caller+0x75/0x140
Sep 29 18:11:26 cooker kernel: [  297.926036]  [<c01e81fd>] blk_done_softir=
q+0x6d/0x80
Sep 29 18:11:26 cooker kernel: [  297.926050]  [<c0120612>] __do_softirq+0x=
62/0xc0
Sep 29 18:11:26 cooker kernel: [  297.926063]  [<c01205b0>] ? __do_softirq+=
0x0/0xc0
Sep 29 18:11:26 cooker kernel: [  297.926077]  [<c0104c56>] do_softirq+0x96=
/0xd0
Sep 29 18:11:26 cooker kernel: [  297.926092]  [<c011fcc0>] ? ksoftirqd+0x0=
/0xc0
Sep 29 18:11:26 cooker kernel: [  297.926107]  [<c011fd05>] ksoftirqd+0x45/=
0xc0
Sep 29 18:11:26 cooker kernel: [  297.926119]  [<c012f58f>] kthread+0x3f/0x=
80
Sep 29 18:11:26 cooker kernel: [  297.926141]  [<c012f550>] ? kthread+0x0/0=
x80
Sep 29 18:11:26 cooker kernel: [  297.926154]  [<c01035df>] kernel_thread_h=
elper+0x7/0x10
Sep 29 18:11:26 cooker kernel: [  297.926168]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 29 18:11:26 cooker kernel: [  297.942316] sd 0:0:0:0: [sda] Result: hos=
tbyte=3D0x07 driverbyte=3D0x00
Sep 29 18:11:26 cooker kernel: [  297.942347] end_request: I/O error, dev s=
da, sector 3280
Sep 29 18:11:26 cooker kernel: [  297.966225] sd 0:0:0:0: [sda] Result: hos=
tbyte=3D0x07 driverbyte=3D0x00
Sep 29 18:11:26 cooker kernel: [  297.966261] end_request: I/O error, dev s=
da, sector 3296
Sep 29 18:11:26 cooker kernel: [  297.967662] sd 0:0:0:0: [sda] READ CAPACI=
TY failed
Sep 29 18:11:26 cooker kernel: [  297.967677] sd 0:0:0:0: [sda] Result: hos=
tbyte=3D0x07 driverbyte=3D0x00
Sep 29 18:11:26 cooker kernel: [  297.967690] sd 0:0:0:0: [sda] Sense not a=
vailable.
Sep 29 18:11:26 cooker kernel: [  297.968125] sd 0:0:0:0: [sda] Write Prote=
ct is off
Sep 29 18:11:26 cooker kernel: [  297.968147] sd 0:0:0:0: [sda] Assuming dr=
ive cache: write through
Sep 29 18:11:26 cooker kernel: [  297.970045] sd 0:0:0:0: [sda] READ CAPACI=
TY failed
Sep 29 18:11:26 cooker kernel: [  297.970056] sd 0:0:0:0: [sda] Result: hos=
tbyte=3D0x07 driverbyte=3D0x00
Sep 29 18:11:26 cooker kernel: [  297.970069] sd 0:0:0:0: [sda] Sense not a=
vailable.
Sep 29 18:11:26 cooker kernel: [  297.970526] sd 0:0:0:0: [sda] Write Prote=
ct is off
Sep 29 18:11:26 cooker kernel: [  297.970544] sd 0:0:0:0: [sda] Assuming dr=
ive cache: write through
Sep 29 18:11:26 cooker kernel: [  298.044247] usb 1-1: USB disconnect, addr=
ess 2
Sep 29 18:15:55 cooker multipathd: 12345678: Entering recovery mode: max_re=
tries=3D5=20
Sep 29 18:15:55 cooker multipathd: 12345678: map in use=20
Sep 29 18:15:55 cooker multipathd: 12345678: unable to flush devmap=20
Sep 29 18:15:55 cooker multipathd: 12345678: Entering recovery mode: max_re=
tries=3D5=20
Sep 29 18:15:55 cooker multipathd: 12345678: Entering recovery mode: max_re=
tries=3D5=20
Sep 29 18:15:55 cooker multipathd: 12345678: event checker started=20
Sep 29 18:15:55 cooker multipathd: path checkers start up=20
Sep 29 18:15:57 cooker multipathd: process is already running=20
Sep 29 18:15:57 cooker multipathd: process is already running=20
Sep 29 18:16:19 cooker multipathd: 12345678: Disable queueing=20

--Boundary-01=_txO4IuP7tKQ441R
Content-Type: text/plain;
  charset="us-ascii";
  name="config-2.6.27-rc7-1avb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config-2.6.27-rc7-1avb"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27-rc7
# Mon Sep 22 09:25:56 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
# CONFIG_USE_GENERIC_SMP_HELPERS is not set
# CONFIG_HAVE_CLK is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="\"\""
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
CONFIG_HERMES=m
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_CYBLA=m
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_SIERRA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACING=y
CONFIG_FTRACE=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-01=_txO4IuP7tKQ441R--

--nextPart1886266.I5oq9iiSW6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjg7G0ACgkQR6LMutpd94znwwCfSNoXQ2P1n5/Ve1mw3ksJZHiw
OQAAn3veoH0OTyJp6mKgJkQ5cjdL5O7P
=SO6V
-----END PGP SIGNATURE-----

--nextPart1886266.I5oq9iiSW6--
