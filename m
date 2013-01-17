From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Wed, 16 Jan 2013 21:27:28 -0500
Message-ID: <20130117022728.GA16148@redhat.com>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
 <20130110175954.GR26407@google.com>
 <20130114223722.GZ26407@google.com>
 <20130114225330.GA1365@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130114225330.GA1365-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Jan 14 2013 at  5:53pm -0500,
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Jan 14 2013 at  5:37pm -0500,
> Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Want to try again with the latest bcache-for-upstream branch? I fixed
> > all that sysfs stuff, but I wasn't seeing the original build error so
> > I'd appreciate if you verify I did in fact fix that issue.
> 
> Will do, thanks Kent.

I hit the crash below if I do this in a script:

echo 1 > /sys/block/bcache0/bcache/cache/unregister
echo 1 > /sys/block/bcache0/bcache/stop

I have a workaround for this issue (just wait a few seconds between
commands).  I'm still carrying on testing and will share some
preliminary performance results vs dm-cache soon.

------------[ cut here ]------------
bcache: bcache0 stopped
WARNING: at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa4/0xb0()
Hardware name: PRIMERGY RX300 S6
sysfs: can not remove 'cache', no directory
Modules linked in: dm_cache_cleaner(O) dm_cache_mq(O) dm_cache_basic(O) dm_cache(O) dm_thin_pool(O) dm_bio_prison dm_persistent_data(O) dm_bufio libcrc32c dm_mod(O) bc
ache ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe
8021q libfc garp stp llc scsi_transport_fc scsi_tgt sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip
_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode i2c_i801 i2c_core lpc_ich mfd_core igb i7
core_edac edac_core iomemory_vsl(O) skd(O) ixgbe dca ptp pps_core mdio sg ses enclosure ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
 megaraid_sas [last unloaded: dm_cache_basic]
Pid: 81, comm: kworker/8:1 Tainted: G        W  O 3.8.0-rc3.snitm+ #37
Call Trace:
 [<ffffffff810423bf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810424b6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff811db784>] sysfs_hash_and_remove+0xa4/0xb0
 [<ffffffff811de476>] sysfs_remove_link+0x26/0x30
 [<ffffffffa0719e26>] cached_dev_detach_finish+0x86/0x150 [bcache]
 [<ffffffff81236507>] ? ioc_release_fn+0x87/0xc0
 [<ffffffff8105f307>] process_one_work+0x177/0x430
 [<ffffffffa0719da0>] ? flash_dev_free+0x30/0x30 [bcache]
 [<ffffffff8106129e>] worker_thread+0x12e/0x380
 [<ffffffff81061170>] ? manage_workers+0x180/0x180
 [<ffffffff8106650e>] kthread+0xce/0xe0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814ff06c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
---[ end trace 50d16ffe964021b2 ]---
bcache: Cache set 4e51cb30-a889-48b2-88cd-a61bd788eac0 unregistered
BUG: unable to handle kernel NULL pointer dereference at 0000000000000cc8
IP: [<ffffffffa0719bc7>] bcache_device_detach+0x77/0xb0 [bcache]
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: dm_cache_cleaner(O) dm_cache_mq(O) dm_cache_basic(O) dm_cache(O) dm_thin_pool(O) dm_bio_prison dm_persistent_data(O) dm_bufio libcrc32c dm_mod(O) bc
ache ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe
8021q libfc garp stp llc scsi_transport_fc scsi_tgt sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip
_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode i2c_i801 i2c_core lpc_ich mfd_core igb i7
core_edac edac_core iomemory_vsl(O) skd(O) ixgbe dca ptp pps_core mdio sg ses enclosure ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
 megaraid_sas [last unloaded: dm_cache_basic]
CPU 8
Pid: 81, comm: kworker/8:1 Tainted: G        W  O 3.8.0-rc3.snitm+ #37 FUJITSU                          PRIMERGY RX300 S6             /D2619
RIP: 0010:[<ffffffffa0719bc7>]  [<ffffffffa0719bc7>] bcache_device_detach+0x77/0xb0 [bcache]
RSP: 0018:ffff88032dc69d38  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88031c950010 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880331a2a0c0 RDI: ffff88031c950010
RBP: ffff88032dc69d48 R08: ffff88032dc68000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88031c950aa8
R13: ffff88032dc69d58 R14: 0000000000000000 R15: ffff88033fd15c05
FS:  0000000000000000(0000) GS:ffff88033fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000cc8 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/8:1 (pid: 81, threadinfo ffff88032dc68000, task ffff880331a2a0c0)
Stack:
 ffff88031c950000 ffff88031c950aa8 ffff88032dc69dd8 ffffffffa0719e76
 0000000000000000 ffff880331a2a0c0 0000000000000000 0000000000000000
 0000000000000000 00000000a0200001 ffff88032c22d5d8 0000000000000292
Call Trace:
 [<ffffffffa0719e76>] cached_dev_detach_finish+0xd6/0x150 [bcache]
 [<ffffffff81236507>] ? ioc_release_fn+0x87/0xc0
 [<ffffffff8105f307>] process_one_work+0x177/0x430
 [<ffffffffa0719da0>] ? flash_dev_free+0x30/0x30 [bcache]
 [<ffffffff8106129e>] worker_thread+0x12e/0x380
 [<ffffffff81061170>] ? manage_workers+0x180/0x180
 [<ffffffff8106650e>] kthread+0xce/0xe0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814ff06c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
Code: 00 00 49 89 44 24 08 e8 f8 ae 97 e0 41 89 44 24 38 48 8b 7b 70 e8 5a ff ff ff c7 83 94 00 00 00 00 00 00 00 48 8b 43 70 8b 53 78 <48> 8b 80 c8 0c 00 00 48 c7 04
d0 00 00 00 00 48 8b 7b 70 48 81
RIP  [<ffffffffa0719bc7>] bcache_device_detach+0x77/0xb0 [bcache]
 RSP <ffff88032dc69d38>
CR2: 0000000000000cc8
---[ end trace 50d16ffe964021b3 ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81065e40>] kthread_data+0x10/0x20
PGD 1a0e067 PUD 1a0f067 PMD 0
Oops: 0000 [#2] SMP
Modules linked in: dm_cache_cleaner(O) dm_cache_mq(O) dm_cache_basic(O) dm_cache(O) dm_thin_pool(O) dm_bio_prison dm_persistent_data(O) dm_bufio libcrc32c dm_mod(O) bc
ache ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe
8021q libfc garp stp llc scsi_transport_fc scsi_tgt sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip
_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode i2c_i801 i2c_core lpc_ich mfd_core igb i7
core_edac edac_core iomemory_vsl(O) skd(O) ixgbe dca ptp pps_core mdio sg ses enclosure ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
 megaraid_sas [last unloaded: dm_cache_basic]
CPU 8
Pid: 81, comm: kworker/8:1 Tainted: G      D W  O 3.8.0-rc3.snitm+ #37 FUJITSU                          PRIMERGY RX300 S6             /D2619
RIP: 0010:[<ffffffff81065e40>]  [<ffffffff81065e40>] kthread_data+0x10/0x20
RSP: 0018:ffff88032dc69968  EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff88033fd12980 RCX: ffffffff81d8e3a0
RDX: 000000000000000d RSI: 0000000000000008 RDI: ffff880331a2a0c0
RBP: ffff88032dc69968 R08: ffff880331a2a130 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000008 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88033fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffd8 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/8:1 (pid: 81, threadinfo ffff88032dc68000, task ffff880331a2a0c0)
Stack:
 ffff88032dc69998 ffffffff8105e571 0000000000000008 ffff88033fd12980
 0000000000000008 ffff880331a2a690 ffff88032dc69a28 ffffffff814f55f3
 ffff88032dc69fd8 0000000000012980 ffff88032dc68010 0000000000012980
Call Trace:
 [<ffffffff8105e571>] wq_worker_sleeping+0x21/0xa0
 [<ffffffff814f55f3>] __schedule+0x5a3/0x710
 [<ffffffff814f5a99>] schedule+0x29/0x70
 [<ffffffff81048515>] do_exit+0x2c5/0x470
 [<ffffffff814f790c>] oops_end+0xac/0xf0
 [<ffffffff81035e0e>] no_context+0x11e/0x1f0
 [<ffffffff8103601d>] __bad_area_nosemaphore+0x13d/0x220
 [<ffffffff81081d98>] ? load_balance+0x128/0x670
 [<ffffffff81036113>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff814fa65a>] __do_page_fault+0x27a/0x490
 [<ffffffff810018d7>] ? __switch_to+0x157/0x4f0
 [<ffffffff810827f0>] ? idle_balance+0x1c0/0x320
 [<ffffffff814fa87e>] do_page_fault+0xe/0x10
 [<ffffffff814f6d48>] page_fault+0x28/0x30
 [<ffffffffa0719bc7>] ? bcache_device_detach+0x77/0xb0 [bcache]
 [<ffffffffa0719e76>] cached_dev_detach_finish+0xd6/0x150 [bcache]
 [<ffffffff81236507>] ? ioc_release_fn+0x87/0xc0
 [<ffffffff8105f307>] process_one_work+0x177/0x430
 [<ffffffffa0719da0>] ? flash_dev_free+0x30/0x30 [bcache]
 [<ffffffff8106129e>] worker_thread+0x12e/0x380
 [<ffffffff81061170>] ? manage_workers+0x180/0x180
 [<ffffffff8106650e>] kthread+0xce/0xe0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814ff06c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81066440>] ? kthread_freezable_should_stop+0x70/0x70
Code: 78 05 00 00 48 8b 40 c8 c9 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 78 05 00 00 <48> 8b 40 d8 c9 c3 66 2e 0f 1f
84 00 00 00 00 00 55 48 89 e5 66
RIP  [<ffffffff81065e40>] kthread_data+0x10/0x20
 RSP <ffff88032dc69968>
CR2: ffffffffffffffd8
---[ end trace 50d16ffe964021b4 ]---
Fixing recursive fault but reboot is needed!
