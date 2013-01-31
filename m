From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 17:17:11 -0500
Message-ID: <20130131221711.GA13540@redhat.com>
References: <20130114225330.GA1365@redhat.com>
 <20130117022728.GA16148@redhat.com>
 <20130117114104.GJ10411@moria.home.lan>
 <20130130233643.GD12631@moria.home.lan>
 <20130131001020.GA7541@redhat.com>
 <20130131012627.GF12631@moria.home.lan>
 <20130131012747.GG12631@moria.home.lan>
 <20130131014835.GH12631@moria.home.lan>
 <20130131190249.GA12786@redhat.com>
 <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31 2013 at  4:08pm -0500,
Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jan 31, 2013 at 11:02 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, Jan 30 2013 at  8:48pm -0500,
> > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> This is going to take some thought. For now, just disable the shrinker:
> >>
> >> echo 1 > /sys/fs/bcache/<uuid>/internal/btree_shrinker_disabled
> >
> > Oddly I don't have a /sys/fs/bcache/<uuid> even though I have created
> > /dev/bcache0
> >
> > The only files I have in /sys/fs/bcache/ are: register  register_quiet
> 
> That means you have a backing device registered, but not a cache device

Ah, yeah I had a typo in my script.  When I fixed it I get a BUG (with
your latest bcache code) when I try to mkfs.xfs /dev/bcache0:

bcache: uuid_inode_write_new_fn() inserting inode 0, unused_inode_hint now 1
bcache: bch_cached_dev_attach() attached inode 0
bcache: bch_cached_dev_attach() Caching dm-12 as bcache0 on set 71a7eb63-ed26-48df-8147-59a7d366f242

bcache: register_cache() registered cache device dm-15

------------[ cut here ]------------
kernel BUG at drivers/md/bcache/btree.c:1728!
invalid opcode: 0000 [#1] SMP 
Modules linked in: bcache(O) ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe libfc 8021q garp scsi_transport_fc stp llc scsi_tgt sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode i2c_i801 i2c_core lpc_ich mfd_core igb i7core_edac edac_core iomemory_vsl(O) skd(O) ixgbe
  dca ptp pps_core mdio ses enclosure dm_mod sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas
CPU 9 
Pid: 100, comm: kworker/9:1 Tainted: G        W  O 3.8.0-rc4.snitm+ #39 FUJITSU                          PRIMERGY RX300 S6             /D2619
RIP: 0010:[<ffffffffa0703258>]  [<ffffffffa0703258>] subtract_dirty.45211+0xa8/0xb0 [bcache]
RSP: 0018:ffff88032dd758b8  EFLAGS: 00010246
RAX: 0000000000000200 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8802f4080200 RSI: 0000000000000000 RDI: ffff8802f4080220
RBP: ffff88032dd758d8 R08: 0000000000000300 R09: 0000000000000010
R10: ffff88032dd759a8 R11: 0000000000000000 R12: ffff8802f4080220
R13: ffff88032dd759a8 R14: 0000000000004010 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88033fd20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000041e450 CR3: 00000002f9a88000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/9:1 (pid: 100, threadinfo ffff88032dd74000, task ffff88032dcd20c0)
Stack:
 00ffffffffffffff ffff8802f4080220 00ffffffffffffff ffff8803301b4e08
 ffff88032dd759e8 ffffffffa07081a0 ffff88032dd75948 ffffffff810018d7
 000000002ca26c00 ffff88032e1a75c8 000000092dd75958 0000000000000020
Call Trace:
 [<ffffffffa07081a0>] fix_overlapping_extents+0x360/0x640 [bcache]
 [<ffffffff810018d7>] ? __switch_to+0x157/0x4f0
 [<ffffffff810521dc>] ? lock_timer_base+0x3c/0x70
 [<ffffffffa070cd77>] ? __bch_btree_iter_init+0x87/0xd0 [bcache]
 [<ffffffffa070860d>] btree_insert_key+0x18d/0x680 [bcache]
 [<ffffffff814f3eda>] ? schedule_timeout+0x13a/0x220
 [<ffffffff81250a39>] ? cpumask_next_and+0x29/0x50
 [<ffffffff81250a39>] ? cpumask_next_and+0x29/0x50
 [<ffffffffa0708c6b>] bch_btree_insert_keys+0x16b/0x350 [bcache]
 [<ffffffffa070959b>] bch_btree_insert_node+0xbb/0x240 [bcache]
 [<ffffffffa0709a30>] bch_btree_insert_recurse+0x140/0x190 [bcache]
 [<ffffffffa0709b8a>] bch_btree_insert+0x10a/0x1a0 [bcache]
 [<ffffffffa0714fc2>] bch_data_insert_keys+0x52/0x150 [bcache]
 [<ffffffff8105f327>] process_one_work+0x177/0x430
 [<ffffffffa0714f70>] ? bch_data_insert_endio+0xc0/0xc0 [bcache]
 [<ffffffff810612be>] worker_thread+0x12e/0x380
 [<ffffffff81061190>] ? manage_workers+0x180/0x180
 [<ffffffff8106652e>] kthread+0xce/0xe0
 [<ffffffff81066460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814ff1ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81066460>] ? kthread_freezable_should_stop+0x70/0x70
Code: 63 db f0 48 29 98 28 01 00 00 49 8b 45 00 48 8b 80 80 00 00 00 66 83 80 d0 0c 00 00 01 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 <0f> 0b eb fe 0f 1f 40 00 55 48 89 e5 48 83 ec 10 66 66 66 66 90 
RIP  [<ffffffffa0703258>] subtract_dirty.45211+0xa8/0xb0 [bcache]
 RSP <ffff88032dd758b8>
---[ end trace 66c7f74f4fc71e5f ]---
