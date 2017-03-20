From: Stanislas Oger <s.oger@nectardecode.com>
Subject: Kernel BUG at dm-cache-policy-mq.c
Date: Mon, 20 Mar 2017 13:15:07 +0100
Message-ID: <e5905454-26b8-8c85-a2e6-eca5f08de6cd@nectardecode.com>
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
Cc: Maza Benjamin <b.maza@nectardecode.com>
List-Id: dm-devel.ids

Hi,

We currently encounter a critical issue on a Proxmox cluster we operate, 
which seems to be triggered by a bug in dm-cache ("kernel BUG at 
drivers/md/dm-cache-policy-mq.c:1079!", see syslog below).


1/ Context

The Proxmox cluster uses 4.4 kernel, the VM storage is a DRBD9 cluster 
on top of lvm with SSD caching. The underlaying disks are on a MegaRAID 
hardware RAID.
The problem started to occur since we installed a VM (a mail server) 
that performs many disk reads on many small files (~ 1 million), with 
read lock using flock at each read. With the VM fully running, the IO 
wait of the system is less than 1%.


2/ The problem

Randomly, without pre-fail signs, syslog reports a bug in 
dm-cache-policy-mq.c (see below). A few minutes later all write 
operations infinitely block. A few minutes after the node stopped to 
perform write operations, the other DRBD9 nodes stop writing too. At 
this point all the cluster is down. Reads can be done as usual, but 
write operations are inifitinely blocking.

The only way we figured out to overcome this situation is to perform a 
hard reboot of the failing node. As soon as the failing node is down, 
the other nodes resume to a normal activity. When the failing node is up 
again, DRBD9 performs disk resynchronization and the cluster resume 
normal activity, as if nothing happened.

The bug occurred with both 4.4.35 and 4.4.40 kernels, with a frequency 
of about once every 10 days.


3/ Hardware RAID info

Basics :
Model = LSI MegaRAID SAS 9271-4i
Serial Number = SK64414158
Mfg Date = 11/05/16
Revision No = 001

Version :
Firmware Package Build = 23.34.0-0019
Firmware Version = 3.460.115-6465
Bios Version = 5.50.03.0_4.17.08.00_0x06110200
NVDATA Version = 2.1507.03-0162
Boot Block Version = 2.05.00.00-0010
Bootloader Version = 07.26.26.219
Driver Name = megaraid_sas
Driver Version = 06.810.09.00-rc1


4/ Syslog trace

Mar 18 19:11:27 hyde kernel: [1567082.404669] kernel BUG at 
drivers/md/dm-cache-policy-mq.c:1079!
Mar 18 19:11:27 hyde kernel: [1567082.405274] Modules linked in: 
binfmt_misc ipt_REJECT nf_reject_ipv4 dm_snapshot iptable_mangle veth 
ip_set ip6table_filter ip6_tables drbd_transport_tcp(O) drbd(O) softdog 
nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ocfs2_dlmfs 
ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs 
ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch nf_defrag_ipv6 
xt_limit xt_conntrack xt_addrtype iptable_filter xt_nat xt_tcpudp 
xt_multiport iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_raw ip_tables x_tables nfnetlink_log 
nfnetlink zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) 
dm_cache_mq dm_cache dm_thin_pool dm_persistent_data dm_bio_prison 
dm_bufio libcrc32c intel_rapl<4>[1567082.409411] CPU: 2 PID: 16388 Comm: 
php5-fpm Tainted: P           O    4.4.40-1-pve #1
Mar 18 19:11:27 hyde kernel: [1567082.409912] Hardware name: Supermicro 
Super Server/X10SRi-F, BIOS 2.0 12/17/2015
Mar 18 19:11:27 hyde kernel: [1567082.410936] RIP: 
0010:[<ffffffffc0376123>]  [<ffffffffc0376123>] 
__mq_set_clear_dirty+0x43/0x80 [dm_cache_mq]
Mar 18 19:11:27 hyde kernel: [1567082.411981] RAX: 0000000000000000 RBX: 
ffff88003590c000 RCX: ffffc90014ba2ba0
Mar 18 19:11:27 hyde kernel: [1567082.413031] RBP: ffff8806b85ab8f8 R08: 
0000000000000000 R09: ffff88003590c630
Mar 18 19:11:27 hyde kernel: [1567082.414147] R13: 00000000007429e9 R14: 
0000000000008b7f R15: 0000000000000000
Mar 18 19:11:27 hyde kernel: [1567082.415202] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Mar 18 19:11:27 hyde kernel: [1567082.416896]  ffff8806b85ab8f8 
ffff88003590c080 ffff88003590c000 ffff8806b85ab920
Mar 18 19:11:27 hyde kernel: [1567082.418675] Call Trace:
Mar 18 19:11:27 hyde kernel: [1567082.420566] [<ffffffffc0578e09>] 
remap_cell_to_cache_dirty+0x1d9/0x240 [dm_cache]
Mar 18 19:11:27 hyde kernel: [1567082.422520] [<ffffffffc05762a0>] ? 
cache_resume+0x30/0x30 [dm_cache]
Mar 18 19:11:27 hyde kernel: [1567082.425221] [<ffffffff813ca1c0>] 
generic_make_request+0x110/0x1f0
Mar 18 19:11:27 hyde kernel: [1567082.428555] [<ffffffff81190146>] 
__filemap_fdatawrite_range+0xc6/0x100
Mar 18 19:11:27 hyde kernel: [1567082.431999] [<ffffffff8121097e>] 
____fput+0xe/0x10
Mar 18 19:11:27 hyde kernel: [1567082.435492] Code: 08 48 8b bf 78 0d 00 
00 48 8b b3 80 0d 00 00 e8 64 f6 ff ff 48 85 c0 74 12 48 3b 83 f8 00 00 
00 72 09 48 3b 83 00 01 00 00 72 02 <0f> 0b 48 89 c6 48 89 df 48 89 45 
e8 e8 4c ef ff ff 48 8b 45 e8
Mar 18 19:11:27 hyde kernel: [1567082.445413] Modules linked in: 
binfmt_misc ipt_REJECT nf_reject_ipv4 dm_snapshot iptable_mangle veth 
ip_set ip6table_filter ip6_tables drbd_transport_tcp(O) drbd(O) softdog 
nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ocfs2_dlmfs 
ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs 
ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch nf_defrag_ipv6 
xt_limit xt_conntrack xt_addrtype iptable_filter xt_nat xt_tcpudp 
xt_multiport iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_raw ip_tables x_tables nfnetlink_log 
nfnetlink zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) 
dm_cache_mq dm_cache dm_thin_pool dm_persistent_data dm_bio_prison 
dm_bufio libcrc32c intel_rapl<4>[1567082.461675] [<ffffffff81031db1>] 
oops_end+0xa1/0xd0
Mar 18 19:11:27 hyde kernel: [1567082.465256] [<ffffffff810b3faf>] ? 
select_idle_sibling+0xef/0x120
Mar 18 19:11:27 hyde kernel: [1567082.468782] [<ffffffffc0376123>] ? 
__mq_set_clear_dirty+0x43/0x80 [dm_cache_mq]
Mar 18 19:11:27 hyde kernel: [1567082.472294] [<ffffffffc0579336>] 
cache_map+0x326/0x4b0 [dm_cache]
Mar 18 19:11:27 hyde kernel: [1567082.475703] [<ffffffff813ca1c0>] 
generic_make_request+0x110/0x1f0
Mar 18 19:11:27 hyde kernel: [1567082.479114] [<ffffffff81190146>] 
__filemap_fdatawrite_range+0xc6/0x100
Mar 18 19:11:27 hyde kernel: [1567082.482535] [<ffffffff8121097e>] 
____fput+0xe/0x10
Mar 18 19:11:27 hyde kernel: [1567082.485950] ---[ end trace 
0767d58f6fa0ec61 ]---


I found a similar bug report on the <4.2 kernel 
(https://www.redhat.com/archives/linux-lvm/2015-November/msg00017.html), 
but it should be fixed in the 4.4 kernel.

Have you any idea of what can cause this issue?

If you need more info on the system, please ask.

Thank you,
Stanislas.
