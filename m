From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Fwd: kernel BUG at
	drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Mon, 19 Oct 2015 12:16:53 +0300
Message-ID: <5624B505.6000406@siteground.com>
References: <5624B4B8.1030404@siteground.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5624B4B8.1030404@siteground.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, thornber@redhat.com
List-Id: dm-devel.ids

[Resending as I had typo in the dm-devel's mailing list the first time]

Hello, 

Using kernel 3.12.47 I've hit the aforementioned issue. I'd also like 
to say that this kernel does include Dennis Yang's patch which 
supposedly fixes a similar issue 
(https://www.redhat.com/archives/dm-devel/2015-May/msg00113.html). 

So here is the BUG splat: 

[309312.150826] kernel BUG at drivers/md/persistent-data/dm-btree-remove.c:182!
[309312.150902] invalid opcode: 0000 [#1] SMP 
[309312.151098] Modules linked in: act_police cls_basic sch_ingress xt_length xt_state xt_pkttype xt_dscp xt_multiport xt_set(O) ip_set_list_set(O) ip_set_hash_ip(O) ip_set(O) veth openvswitch gre vxlan ip_tunnel nf_nat_ftp nf_conntrack_ftp xt_owner xt_conntrack iptable_mangle xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_CT nf_conntrack iptable_raw ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 ext2 dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio dm_mirror dm_region_hash dm_log ses enclosure igb i2c_algo_bit x86_pkg_temp_thermal crc32_pclmul i2c_i801 lpc_ich mfd_core ioapic ioatdma dca shpchp ipmi_devintf ipmi_si ipmi_msghandler [last unloaded: netconsole]
[309312.155739] CPU: 13 PID: 21194 Comm: kworker/u96:1 Tainted: G           O 3.12.47-clouder3 #1
[309312.155818] Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
[309312.155898] Workqueue: dm-thin do_worker [dm_thin_pool]
[309312.156033] task: ffff883fa4652850 ti: ffff88238d4c2000 task.ti: ffff88238d4c2000
[309312.156109] RIP: 0010:[<ffffffffa00d1612>]  [<ffffffffa00d1612>] shift+0xb2/0xc0 [dm_persistent_data]
[309312.156259] RSP: 0018:ffff88238d4c3b38  EFLAGS: 00010297
[309312.156609] RAX: 00000000000000fc RBX: 0000000000000001 RCX: ffff880137c1e000
[309312.156966] RDX: 0000000000000001 RSI: ffff880137c1e000 RDI: ffff881015c9e000
[309312.157323] RBP: ffff88238d4c3b68 R08: 00000000000000fb R09: ffff881015c9e000
[309312.157678] R10: 00000000000000fc R11: 00000000000000fc R12: ffff880137c1e000
[309312.158033] R13: ffff881015c9e000 R14: 00000000000000fd R15: 00000000000000fb
[309312.158391] FS:  0000000000000000(0000) GS:ffff883fff220000(0000) knlGS:0000000000000000
[309312.158747] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[309312.159100] CR2: 0000000000da6190 CR3: 0000002188b94000 CR4: 00000000001407e0
[309312.159456] Stack:
[309312.159798]  ffff88238d4c3b58 ffff88238d4c3c98 ffff883fceafe040 ffff88238d4c3c20
[309312.160408]  ffff883410df9000 0000000000008d93 ffff88238d4c3c58 ffffffffa00d201c
[309312.161021]  ffff881fff403800 ffff88236b8440c0 0000000000000000 00000000000000fc
[309312.161635] Call Trace:
[309312.161995]  [<ffffffffa00d201c>] remove_raw+0x76c/0x870 [dm_persistent_data]
[309312.162353]  [<ffffffff8113c0ed>] ? mempool_free+0x8d/0xa0
[309312.162709]  [<ffffffff811dd39e>] ? bio_put+0x7e/0xb0
[309312.163075]  [<ffffffffa00d21cf>] dm_btree_remove+0xaf/0x150 [dm_persistent_data]
[309312.163433]  [<ffffffffa00ed067>] dm_thin_remove_block+0x87/0xb0 [dm_thin_pool]
[309312.163789]  [<ffffffffa00e95f2>] process_prepared_discard+0x22/0x60 [dm_thin_pool]
[309312.164145]  [<ffffffffa00e7c47>] process_prepared+0x87/0xa0 [dm_thin_pool]
[309312.164501]  [<ffffffffa00ea1de>] do_worker+0x4e/0x270 [dm_thin_pool]
[309312.164858]  [<ffffffff810a61e5>] process_one_work+0x195/0x550
[309312.165210]  [<ffffffff810a848a>] worker_thread+0x13a/0x430
[309312.165564]  [<ffffffff810a8350>] ? manage_workers+0x2c0/0x2c0
[309312.165918]  [<ffffffff810ae48e>] kthread+0xce/0xe0
[309312.166271]  [<ffffffff810ae3c0>] ? kthread_freezable_should_stop+0x80/0x80
[309312.166629]  [<ffffffff81643408>] ret_from_fork+0x58/0x90
[309312.166980]  [<ffffffff810ae3c0>] ? kthread_freezable_should_stop+0x80/0x80
[309312.167333] Code: 66 0f 1f 84 00 00 00 00 00 e8 4b fc ff ff 89 de 4c 89 e7 e8 51 fe ff ff eb c7 0f 0b eb fe 0f 0b 66 0f 1f 84 00 00 00 00 00 eb f5 <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 
[309312.172374] RIP  [<ffffffffa00d1612>] shift+0xb2/0xc0 [dm_persistent_data]
[309312.172808]  RSP <ffff88238d4c3b38>

Since I've managed to collect crashdump here is some data, 
which should hopefully help debugging. The actual assembly
instruction leading to the crash: 

<Dissassembly of shift>
0xffffffffa00d15a1 <shift+65>:  lea    (%rbx,%r14,1),%r14d
0xffffffffa00d15a5 <shift+69>:  cmp    %r14d,%eax
0xffffffffa00d15a8 <shift+72>:  jb     0xffffffffa00d1612 <shift+178>
<ommitted for brevity>
0xffffffffa00d1612 <shift+178>: ud2 

Looking at the registers contents (r14d contains the sum of
nr_right + count) which in this case equals to 0xfd = 252, 
rbx contains the count which is 1 in this. Checking this by 
showing the contents of the respective structs:

crash> struct btree_node ffff881015c9e000 <-- left 
struct btree_node {
  header = {
    csum = 2063034577, 
    flags = 2, 
    blocknr = 2292, 
    nr_entries = 252, 
    max_entries = 252, 
    value_size = 8, 
    padding = 0
  }, 
  keys = 0xffff881015c9e020
}

crash> struct btree_node ffff880137c1e000 <-- right
struct btree_node {
  header = {
    csum = 2657574476, 
    flags = 2, 
    blocknr = 2340, 
    nr_entries = 252, 
    max_entries = 252, 
    value_size = 8, 
    padding = 0
  }, 
  keys = 0xffff880137c1e020
}

In the condition inside the BUG_ON ends up being 253 > 252

Let me know if you need more information as I have a crashdump
when the problem manifested itself. 

Regards, 
Nikolay 
