From: Eric Wheeler <dm-devel@ew.ewheeler.org>
Subject: dm-thinp BUG at
	drivers/md/persistent-data/dm-btree-remove.c:188
Date: Thu, 14 Feb 2013 18:07:56 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids


Hello all,

I've been experimenting with dm-thinp recently and for the past few months 
and all has been well---until today.

The server is running vanilla 3.7.1 and just started issuing the BUG dump 
below.  After the bug, the kernel hangs and I can't even ping the server. 
This is running as a KVM virtual machine running dm-thinp backed with 
a single virtio-blk device.

Has anyone seen this?  Is this known to be fixed in a newer version?

Does this indicate a corrupt volume or metadata volume?

Let me know what other data I can collect, if any.  The VM seems to hang 
every few hours or so but I'm not sure what triggers it yet.

-Eric

kernel BUG at drivers/md/persistent-data/dm-btree-remove.c:188!
invalid opcode: 0000 [#1] SMP
Modules linked in: ebtable_nat ebtables ipt_REJECT bridge fcoe libfcoe 
libfc 8021q scsi_transport_fc garp stp scsi_tgt llc sunrpc xt_limit 
xt_conntrack iptable_filter xt_mark iptable_mangle ipt_MASQUERADE 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack 
ip6table_filter ip6_tables ipv6 ext3 jbd dm_thin_pool dm_bio_prison 
dm_persistent_data dm_bufio libcrc32c vhost_net tun crc32c_intel microcode 
pcspkr i2c_piix4 i2c_core pata_acpi ata_generic ata_piix floppy dm_mirror 
dm_region_hash dm_log dm_mod
CPU 2
Pid: 3084, comm: kworker/u:0 Not tainted 3.7.1 #2 Red Hat KVM
RIP: 0010:[<ffffffffa009ad01>]  [<ffffffffa009ad01>] shift+0x3b/0x91 
[dm_persistent_data]
RSP: 0018:ffff8802160e7b58  EFLAGS: 00010202
RAX: 00000000000000fc RBX: ffff880040411000 RCX: 00000000000000fb
RDX: 00000000ffffffff RSI: ffff880040411000 RDI: ffff880040410000
RBP: ffff8802160e7b88 R08: 00000000000000fc R09: 000000000008bfc6
R10: ffff8802160e7bf0 R11: ffff8802160e7ac8 R12: 00000000ffffffff
R13: ffff880040410000 R14: 00000000000000fc R15: 00000000000000fd
FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7749c89000 CR3: 00000002141ca000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:0 (pid: 3084, threadinfo ffff8802160e6000, task 
ffff880214038e20)
Stack:
  ffff8802160e7b78 ffff8802153eec40 ffff88001e1d7000 ffff880040411000
  ffff880040410000 00000000000000fc ffff8802160e7c78 ffffffffa009b471
  ffff880200000000 ffff88021fc92680 ffff8802160e7bd8 ffffffff81092a3b
Call Trace:
  [<ffffffffa009b471>] remove_raw+0x517/0x624 [dm_persistent_data]
  [<ffffffff81092a3b>] ? ttwu_do_wakeup+0x4d/0xdb
  [<ffffffff81098ce8>] ? try_to_wake_up+0x19c/0x1ae
  [<ffffffffa009b5ff>] dm_btree_remove+0x81/0x12e [dm_persistent_data]
  [<ffffffffa00ae684>] dm_thin_remove_block+0x5f/0x8a [dm_thin_pool]
  [<ffffffffa00ab1bf>] process_prepared_discard+0x22/0x40 [dm_thin_pool]
  [<ffffffffa00aa875>] process_prepared+0x77/0x8f [dm_thin_pool]
  [<ffffffffa00ac106>] do_worker+0x53/0x22f [dm_thin_pool]
  [<ffffffff810846db>] process_one_work+0x1ea/0x2ec
  [<ffffffffa00ac0b3>] ? pool_dtr+0x6b/0x6b [dm_thin_pool]
  [<ffffffff81086a7c>] worker_thread+0x168/0x268
  [<ffffffff81086914>] ? manage_workers+0x280/0x280
  [<ffffffff8108a73d>] kthread+0xb5/0xbd
  [<ffffffff8108a688>] ? kthread_freezable_should_stop+0x65/0x65
  [<ffffffff81496eac>] ret_from_fork+0x7c/0xb0
  [<ffffffff8108a688>] ? kthread_freezable_should_stop+0x65/0x65
Code: 08 66 66 66 66 90 8b 47 14 49 89 fd 48 89 f3 41 89 d4 44 8b 7f 10 44 
8b 76 10 3b 46 14 74 04 0f 0b eb fe 41 29 d7 41 39 c7 76 04 <0f> 0b eb fe 
47 8d 34 34 41 39 c6 76 04 0f 0b eb fe 83 fa 00 74
RIP  [<ffffffffa009ad01>] shift+0x3b/0x91 [dm_persistent_data]
  RSP <ffff8802160e7b58>
---[ end trace 524d6bc36c283730 ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff8108a1d3>] kthread_data+0x10/0x16
PGD 1673067 PUD 1674067 PMD 0
Oops: 0000 [#2] SMP
Modules linked in: ebtable_nat ebtables ipt_REJECT bridge fcoe libfcoe 
libfc 8021q scsi_transport_fc garp stp scsi_tgt llc sunrpc xt_limit 
xt_conntrack iptable_filter xt_mark iptable_mangle ipt_MASQUERADE 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack 
ip6table_filter ip6_tables ipv6 ext3 jbd dm_thin_pool dm_bio_prison 
dm_persistent_data dm_bufio libcrc32c vhost_net tun crc32c_intel microcode 
pcspkr i2c_piix4 i2c_core pata_acpi ata_generic ata_piix floppy dm_mirror 
dm_region_hash dm_log dm_mod
CPU 2
Pid: 3084, comm: kworker/u:0 Tainted: G      D      3.7.1 #2 Red Hat KVM
RIP: 0010:[<ffffffff8108a1d3>]  [<ffffffff8108a1d3>] 
kthread_data+0x10/0x16
RSP: 0018:ffff8802160e77e8  EFLAGS: 00010092
RAX: 0000000000000000 RBX: ffff88021fd12680 RCX: 0000000000000002
RDX: ffffffff818a8760 RSI: 0000000000000002 RDI: ffff880214038e20
RBP: ffff8802160e77e8 R08: ffff88021fd12680 R09: ffff880214038e68
R10: ffff8801c7c1adf0 R11: 0000000000000010 R12: ffff880214039100
R13: 0000000000000002 R14: 0000000000000002 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffd8 CR3: 00000002141ca000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:0 (pid: 3084, threadinfo ffff8802160e6000, task 
ffff880214038e20)
Stack:
  ffff8802160e7818 ffffffff810863e4 ffff8802160e7818 ffff88021fd12680
  ffff880214039100 ffff8802160e78e8 ffff8802160e78a8 ffffffff8148ebab
  ffff8802160e6010 0000000000012680 ffff880214038e20 0000000000012680
Call Trace:
  [<ffffffff810863e4>] wq_worker_sleeping+0x1a/0x78
  [<ffffffff8148ebab>] __schedule+0x150/0x503
  [<ffffffff8148f24f>] schedule+0x64/0x66
  [<ffffffff81072e23>] do_exit+0x81b/0x834
  [<ffffffff81490ca0>] oops_end+0xbf/0xc7
  [<ffffffff8103cb97>] die+0x5a/0x63
  [<ffffffff8149081f>] do_trap+0x70/0x137
  [<ffffffff8103b02c>] do_invalid_op+0x9c/0xa5
  [<ffffffffa009ad01>] ? shift+0x3b/0x91 [dm_persistent_data]
  [<ffffffffa0099672>] ? insert_shadow+0x39/0x8c [dm_persistent_data]
  [<ffffffff81142110>] ? kmem_cache_alloc_trace+0xc1/0xd3
  [<ffffffff81497f5e>] invalid_op+0x1e/0x30
  [<ffffffffa009ad01>] ? shift+0x3b/0x91 [dm_persistent_data]
  [<ffffffffa009b471>] remove_raw+0x517/0x624 [dm_persistent_data]
  [<ffffffff81092a3b>] ? ttwu_do_wakeup+0x4d/0xdb
  [<ffffffff81098ce8>] ? try_to_wake_up+0x19c/0x1ae
  [<ffffffffa009b5ff>] dm_btree_remove+0x81/0x12e [dm_persistent_data]
  [<ffffffffa00ae684>] dm_thin_remove_block+0x5f/0x8a [dm_thin_pool]
  [<ffffffffa00ab1bf>] process_prepared_discard+0x22/0x40 [dm_thin_pool]
  [<ffffffffa00aa875>] process_prepared+0x77/0x8f [dm_thin_pool]
  [<ffffffffa00ac106>] do_worker+0x53/0x22f [dm_thin_pool]
  [<ffffffff810846db>] process_one_work+0x1ea/0x2ec
  [<ffffffffa00ac0b3>] ? pool_dtr+0x6b/0x6b [dm_thin_pool]
  [<ffffffff81086a7c>] worker_thread+0x168/0x268
  [<ffffffff81086914>] ? manage_workers+0x280/0x280
  [<ffffffff8108a73d>] kthread+0xb5/0xbd
  [<ffffffff8108a688>] ? kthread_freezable_should_stop+0x65/0x65
  [<ffffffff81496eac>] ret_from_fork+0x7c/0xb0
  [<ffffffff8108a688>] ? kthread_freezable_should_stop+0x65/0x65
Code: 8b 04 25 80 b9 00 00 48 8b 80 88 02 00 00 48 8b 40 c8 c9 48 c1 e8 02 
83 e0 01 c3 55 48 89 e5 66 66 66 66 90 48 8b 87 88 02 00 00 <48> 8b 40 d8 
c9 c3 55 48 89 e5 66 66 66 66 90 48 3b 3d b7 e4 81
RIP  [<ffffffff8108a1d3>] kthread_data+0x10/0x16
  RSP <ffff8802160e77e8>
CR2: ffffffffffffffd8
---[ end trace 524d6bc36c283731 ]---
Fixing recursive fault but reboot is needed!



-- 
Eric Wheeler
www.globallinuxsecurity.pro
