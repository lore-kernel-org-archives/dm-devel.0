From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Mon, 9 Nov 2009 21:24:52 -0800
Message-ID: <20091110052452.GA11721@linux.vnet.ibm.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
	<20091109085142.GA4432@linux.vnet.ibm.com>
	<20091109175730.GA12556@us.ibm.com>
	<20091110002445.GF17055@agk-dp.fab.redhat.com>
	<20091110015003.GA7104@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091110015003.GA7104@us.ibm.com>
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

malahal@us.ibm.com <malahal@us.ibm.com> wrote:
> Alasdair G Kergon [agk@redhat.com] wrote:
> > On Mon, Nov 09, 2009 at 09:57:30AM -0800, malahal@us.ibm.com wrote:
> > > Why do we need dm_get() and dm_put() in dm_copy_name_and_uuid()?
> > > dm_copy_name_and_uuid() already has access to md and there shouldn'=
t be
> > > any need to hold a reference.=20
> >=20
> > As Mike points out, struct dm_uevent holds a reference without
> > incrementing the ref count.
> >=20
> > dm_path_uevent() already takes a reference - can everything get
> > simplified if we move this code there (and replace the new mutex with
> > a spinlock of course)?  Then dm_send_uevents won't need to use 'md'.
>=20
> I think the last dm_put() is calling the multipath destructor which
> eventually calls (through a work struct) dm_send_uevents. At that point=
,
> dm is guaranteed to exist but you *must* not place a hold on it. As the
> current code in dm_copy_name_and_uuid() places a hold on a FREEING md,
> it will result in a BUG_ON while calling the dm_put in the same
> function. So, removing the dm_get/dm_put from that function should also
> solve the BUG_ON issue.
>=20

I have been running Mikulas's patch and your last dmf_freeing_lock.patch.
The system system is running for 5 hrs with no BUG_ON or lock dep
warnings.

> I agree, removing the "md" field from the dm_event struct probably
> simplifies other things.
>=20
I will capture similar data to what is provided below for a run using the
dmf_freeing_lock.patch, moving dm_copy_name_and_uuid to dm_path_uevent,
and a patch similar to Mikulas's except using a spinlock.

I attached the previous BUG_ON output you asked for. I also supplied two
systemtap snips of output captured during the previous mentioned run. The
first systemtap you can see that while we are not hitting the BUG_ON and
the dm_copy_name_and_uuid function will fail with ENXIO the sequence is
probably something we would like to avoid. The second systemtap just show=
s
a case where dev_remove is the last put (Note the dm_get and dm_put are
return probes and the ref is the value at the end of the function).

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

1.) BUG ON=20

[  260.342806] ------------[ cut here ]------------
[  260.365067] kernel BUG at drivers/md/dm.c:2059!
[  260.381069] invalid opcode: 0000 [#1] SMP
[  260.413071] last sysfs file: /sys/kernel/uevent_seqnum
[  260.413071] CPU 3
[  260.413071] Modules linked in: scsi_debug crc_t10dif xt_tcpudp af_pack=
et nf_conntrack_ipv6 ip6t_REJECT xt_state ipt_REJECT iptable_filter ip6ta=
ble_mangle nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6tab=
le_filter ip6_tables x_tables ipv6 fuse loop sr_mod cdrom ata_piix ahci i=
2c_i801 shpchp libata i2c_core tg3 sg pci_hotplug rng_core libphy floppy =
mpt2sas button mptctl joydev usbhid scsi_dh_alua scsi_dh_rdac scsi_dh_hp_=
sw scsi_dh_emc dm_round_robin dm_multipath scsi_dh uhci_hcd ehci_hcd usbc=
ore sd_mod dm_snapshot dm_mod edd ext3 jbd fan mptsas mptscsih mptbase sc=
si_transport_sas aic79xx scsi_transport_spi scsi_mod thermal processor [l=
ast unloaded: freq_table]
[  260.766701] Pid: 18, comm: events/3 Not tainted 2.6.32-rc6-Mikulas_nam=
e_read_lock #1 eserver xSeries 346 -[884015U]-
[  260.861109] RIP: 0010:[<ffffffffa012915f>]  [<ffffffffa012915f>] dm_pu=
t+0x19/0x1b3 [dm_mod]
[  260.861109] RSP: 0018:ffff88003fac9c80  EFLAGS: 00010202
[  260.861109] RAX: 000000000000529b RBX: ffff88003c9cd000 RCX: ffff88003=
fac6506
[  260.861109] RDX: ffff88003fac9be0 RSI: ffff88003fac6c40 RDI: ffff88003=
c9cd000
[  260.861109] RBP: ffff88003fac9ca0 R08: 0000000000000003 R09: 000000000=
0000000
[  260.861109] R10: ffff88003e304140 R11: 0000000000000046 R12: 000000000=
0000000
[  260.861109] R13: ffff88003c9cd000 R14: ffff88003cc53dc8 R15: ffff88003=
cc53e48
[  260.861109] FS:  0000000000000000(0000) GS:ffff880004800000(0000) knlG=
S:0000000000000000
[  260.861109] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  260.861109] CR2: 00007f9bcc13b000 CR3: 000000003e2e9000 CR4: 000000000=
00006e0
[  260.861109] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[  260.861109] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[  261.373150] Process events/3 (pid: 18, threadinfo ffff88003fac8000, ta=
sk ffff88003fac6540)
[  261.373150] Stack:
[  261.373150]  ffff88003c9cd000 00000000fffffffa 0000000000000000 ffff88=
003c9cd000
[  261.373150] <0> ffff88003fac9ce0 ffffffffa012c529 ffff88003fac9ce0 fff=
f88003cc534a0
[  261.526731] <0> ffff88003fac9d40 ffff88003cc53dc8 ffff88003cc53e48 fff=
f88003fac9428
[  261.526731] Call Trace:
[  261.602734]  [<ffffffffa012c529>] dm_copy_name_and_uuid+0x9d/0xab [dm_=
mod]
[  261.602734]  [<ffffffffa012728e>] dm_send_uevents+0x6e/0x138 [dm_mod]
[  261.602734]  [<ffffffffa0127ba3>] event_callback+0x85/0xb6 [dm_mod]
[  261.602734]  [<ffffffffa012ad00>] dm_table_event+0x4a/0x5a [dm_mod]
[  261.750880]  [<ffffffffa01b1588>] trigger_event+0x13/0x15 [dm_multipat=
h]
[  261.750880]  [<ffffffff810535aa>] worker_thread+0x232/0x33b
[  261.750880]  [<ffffffff81053550>] ? worker_thread+0x1d8/0x33b
[  261.750880]  [<ffffffff812b05c6>] ? thread_return+0x3e/0x108
[  261.885195]  [<ffffffffa01b1575>] ? trigger_event+0x0/0x15 [dm_multipa=
th]
[  261.885195]  [<ffffffff810574e0>] ? autoremove_wake_function+0x0/0x38
[  261.885195]  [<ffffffff81053378>] ? worker_thread+0x0/0x33b
[  261.885195]  [<ffffffff81057194>] kthread+0x7d/0x85
[  261.885195]  [<ffffffff8100caba>] child_rip+0xa/0x20
[  261.885195]  [<ffffffff8100c47c>] ? restore_args+0x0/0x30
[  261.885195]  [<ffffffff81057117>] ? kthread+0x0/0x85
[  261.885195]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20
[  261.885195] Code: 8b 45 d4 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f c9 c=
3 55 48 89 e5 41 55 41 54 53 48 89 fb 48 83 ec 08 f6 87 60 01 00 00 08 74=
 04 <0f> 0b eb fe 48 8d bf 58 01 00 00 48 c7 c6 10 16 13 a0 e8 ce 53
[  261.885195] RIP  [<ffffffffa012915f>] dm_put+0x19/0x1b3 [dm_mod]
[  261.885195]  RSP <ffff88003fac9c80>
[  262.343081] ---[ end trace 0d93a89c3d6227e3 ]---


2.) System tap output dev_remove NOT last dm_put.

1257824260814259355, dm_get, md (253:5), ref 3, caller dm_table_get_md 0x=
ffffffffa012a63b
1257824260814291496, dm_put, md (253:5), ref 2, caller dm_path_uevent 0xf=
fffffffa0127211
1257824260814348359, dm_put, md (253:5), ref 1, caller target_message 0xf=
fffffffa012caaa
1257824260814390748, dm_copy_name_and_uuid, md (253:5), ref 1
1257824260814404049, dm_copy_name_and_uuid, md (253:5), ref 1 ret 0
1257824260818867530, dm_put, md (253:5), ref 1, caller table_status 0xfff=
fffffa012ce4f
1257824260819356132, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824260819383953, dm_put, md (253:5), ref 1, caller dev_status 0xfffff=
fffa012c96e
1257824260819835016, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824260819868820, dm_put, md (253:5), ref 1, caller table_status 0xfff=
fffffa012ce4f
1257824261030684451, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824261036110432, dm_get, md (253:5), ref 3, caller __get_name_cell 0x=
ffffffffa012c637
1257824261036157879, dm_put, md (253:5), ref 2, caller __hash_remove 0xff=
ffffffa012d874
1257824261036248683, dm_put, md (253:5), ref 1, caller dev_remove 0xfffff=
fffa012d935
1257824261063081028, dm_get, md (253:5), ref 2, caller dm_table_get_md 0x=
ffffffffa012a63b
1257824261063120742, dm_put, md (253:5), ref 1, caller dm_path_uevent 0xf=
fffffffa0127211
1257824261063263612, dm_put(DMF_FREEING), md (), ref 0
1257824261063393477, dm_copy_name_and_uuid, md (253:5), ref 0
1257824261063408504, dm_copy_name_and_uuid, md (253:5), ref 0 ret -6
1257824261065012335, __unbind, md (253:5), ref 0
1257824261109351080, free_dev, md (=C2=B0=C2=A1=C3=97/), ref 140
1257824261121781827, dm_put, md (253:5), ref 0, caller target_message 0xf=
fffffffa012caaa

3.) System tap output dev_remove last dm_put.

1257824262109220909, dm_get, md (253:5), ref 3, caller dm_table_get_md 0x=
ffffffffa012a63b
1257824262109252657, dm_put, md (253:5), ref 2, caller dm_path_uevent 0xf=
fffffffa0127211
1257824262109375197, dm_put, md (253:5), ref 1, caller target_message 0xf=
fffffffa012caaa
1257824262109427927, dm_copy_name_and_uuid, md (253:5), ref 1
1257824262109443336, dm_copy_name_and_uuid, md (253:5), ref 1 ret 0
1257824262114407438, dm_put, md (253:5), ref 1, caller table_status 0xfff=
fffffa012ce4f
1257824262114910281, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824262114937691, dm_put, md (253:5), ref 1, caller dev_status 0xfffff=
fffa012c96e
1257824262115397074, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824262115446916, dm_put, md (253:5), ref 1, caller table_status 0xfff=
fffffa012ce4f
1257824262316985895, dm_get, md (253:5), ref 2, caller __get_name_cell 0x=
ffffffffa012c637
1257824262317031425, dm_put, md (253:5), ref 1, caller __hash_remove 0xff=
ffffffa012d874
1257824262317123286, dm_put(DMF_FREEING), md (), ref 0
1257824262318357193, __unbind, md (253:5), ref 0
1257824262318635815, free_dev, md (=C3=B0i=C3=AB/), ref 140
1257824262336344411, dm_put, md (253:5), ref 0, caller dev_remove 0xfffff=
fffa012d935
