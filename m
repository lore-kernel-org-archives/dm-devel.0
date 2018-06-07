From: valdis.kletnieks@vt.edu
Subject: next-20180605 - kernel tried to execute NX-protected page - exploit attempt?
Date: Thu, 07 Jun 2018 16:40:57 -0400
Message-ID: <21051.1528404057@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1528404057_2539P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--==_Exmh_1528404057_2539P
Content-Type: text/plain; charset=us-ascii

I've hit this one twice today with pretty much the same traceback.
The disk has 3 partitions - one for EFI, one for /boot, and then the rest of
the disk is a cryptluks partition that contains a dozen or so LVM logical
volumes.

'git log -- drivers/md' didn't show any obvious suspects since next-20180529, which worked
for me just fine....

[ 6090.781839] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[ 6090.781847] BUG: unable to handle kernel paging request at ffff9d4bc8b766c0
[ 6090.781856] PGD 17b7a067 P4D 17b7a067 PUD 17b7e067 PMD 408b9d063 PTE 8000000408b76063
[ 6090.781872] Oops: 0011 [#1] PREEMPT SMP PTI

[ 6090.781893] Workqueue: kcryptd kcryptd_crypt
[ 6090.781901] RIP: 0010:0xffff9d4bc8b766c0
[ 6090.781905] Code: ff ff ff f9 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff <ff> ff ff ff ff ff 9f ff ff ff ff f9 ff ff bf ff ff ff ff ff ff 7f
[ 6090.782012] RSP: 0018:ffff9d4bdd2039d8 EFLAGS: 00010046
[ 6090.782018] RAX: ffff9d4bc8b766c0 RBX: ffff9d4bd53744e8 RCX: 0000000000000000
[ 6090.782023] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff9d4bd31e5c90
[ 6090.782027] RBP: ffff9d4bdd203a40 R08: 0000000000000000 R09: ffff9d4bd31e5c90
[ 6090.782030] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 6090.782034] R13: ffff9d4bd7860228 R14: 00000000d31a2b40 R15: ffff9d4bdd203a58
[ 6090.782038] FS:  0000000000000000(0000) GS:ffff9d4bdd200000(0000) knlGS:0000000000000000
[ 6090.782042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6090.782046] CR2: ffff9d4bc8b766c0 CR3: 0000000015e24003 CR4: 00000000001606e0
[ 6090.782050] Call Trace:
[ 6090.782054]  <IRQ>
[ 6090.782061]  ? __wake_up_common+0xb7/0x3d0
[ 6090.782071]  __wake_up_common_lock+0x87/0xe0
[ 6090.782080]  __wake_up+0x13/0x20
[ 6090.782087]  mempool_free+0x122/0x190
[ 6090.782095]  bio_free+0x59/0x80
[ 6090.782101]  bio_put+0x50/0x90
[ 6090.782107]  dec_pending+0x1b0/0x560
[ 6090.782117]  clone_endio+0xd5/0x2e0
[ 6090.782125]  bio_endio+0x22e/0x4b0
[ 6090.782132]  crypt_dec_pending+0x92/0xf0
[ 6090.782139]  crypt_endio+0x9b/0xe0
[ 6090.782146]  bio_endio+0x22e/0x4b0
[ 6090.782153]  blk_update_request+0x145/0x680
[ 6090.782162]  scsi_end_request+0x56/0x440
[ 6090.782169]  scsi_io_completion+0x462/0x9b0
[ 6090.782178]  scsi_finish_command+0x189/0x2a0
[ 6090.782185]  scsi_softirq_done+0x17e/0x1f0
[ 6090.782193]  blk_done_softirq+0x229/0x410
[ 6090.782198]  ? __do_softirq+0xfb/0x914
[ 6090.782207]  __do_softirq+0x13a/0x914
[ 6090.782219]  irq_exit+0xea/0x140
[ 6090.782224]  do_IRQ+0xcc/0x1c0
[ 6090.782232]  common_interrupt+0xf/0xf
[ 6090.782237]  </IRQ>
[ 6090.782241] RIP: 0010:memset_erms+0x9/0x10

The other traceback was about the same, with the following
interleaved:

[27847.571250] list_add corruption. next->prev should be prev (ffff9e2c1347a4e8), but was 0000000000000000. (next=ffff9e2c13cde4a8).
[27847.571278] kernel BUG at lib/list_debug.c:25!
[27847.571685] invalid opcode: 0000 [#2] PREEMPT SMP PTI
[27847.571689] CPU: 0 PID: 55 Comm: kswapd0 Tainted: G      D    O    T 4.17.0-next-20180605-dirty #586
[27847.573947] Call Trace:
[27847.573958]  prepare_to_wait+0x133/0x210
[27847.573966]  ? mempool_alloc+0xe9/0x200
[27847.573975]  mempool_alloc+0x17e/0x200
[27847.573983]  ? remove_wait_queue+0x170/0x170
[27847.573994]  bio_alloc_bioset+0x122/0x3f0
[27847.574000]  ? bio_advance+0xbf/0x240
[27847.574006]  ? bio_clone_blkcg_association+0x5b/0x80
[27847.574015]  alloc_io+0x48/0x320
[27847.574021]  ? dm_get_live_table+0x3a/0x140
[27847.574030]  ? __split_and_process_non_flush+0x420/0x420
[27847.574035]  __split_and_process_bio+0x5d/0x2b0
[27847.574042]  ? __split_and_process_non_flush+0x420/0x420
[27847.574048]  ? dm_get_live_table+0x5d/0x140
[27847.574053]  ? dm_get_live_table+0x84/0x140
[27847.574061]  __dm_make_request+0xaf/0x1f0
[27847.574071]  dm_make_request+0x15/0x20
[27847.574078]  generic_make_request+0x3b9/0x7c0
[27847.574091]  submit_bio+0xb9/0x240
[27847.574097]  ? submit_bio+0xb9/0x240
[27847.574104]  ? __test_set_page_writeback+0x402/0xd30
[27847.574111]  ? get_swap_bio+0x106/0x180
[27847.574121]  __swap_writepage+0x153/0x8d0
[27847.574128]  ? page_swapcount+0xbf/0x140
[27847.574139]  ? __frontswap_store+0x8d/0x142
[27847.574147]  swap_writepage+0x4d/0xc0
[27847.574155]  pageout.isra.29+0x304/0x980
[27847.574171]  shrink_page_list+0x11e9/0x2020
[27847.574189]  shrink_inactive_list+0x291/0xdb0
[27847.574204]  shrink_node_memcg+0x38a/0x1530
[27847.574211]  ? percpu_ref_get_many+0x200/0x200
[27847.574233]  shrink_node+0xdc/0x920
[27847.574246]  balance_pgdat+0x288/0x680
[27847.574262]  kswapd+0x2ca/0x990
[27847.574271]  ? remove_wait_queue+0x170/0x170
[27847.574282]  kthread+0x1d3/0x2a0
[27847.574288]  ? balance_pgdat+0x680/0x680
[27847.574294]  ? kthread_create_worker_on_cpu+0x70/0x70
[27847.574304]  ret_from_fork+0x3a/0x50


--==_Exmh_1528404057_2539P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWxmYWI0DS38y7CIcAQLIVQgAp1dN26+PyWbqizBsMehR6hjjyBhEhznO
KiOEkVXxlcMdFTuesO4nKIMUmL6jONdxOFG7UgE4hxsUSRh6AXYFdYg2eBQjGrpV
8uIlP85IHL92Bz1TgpwS8o1CerQPpr+YW5yE52HMifQb+mACLsn75+7PO8ndM4c1
ajNH50pNZ/Ljih7tzF+ARg06AsBWSHKRaLqHIPjePJUqK7eSWOvhuUNLpnmvTwsM
1JX4AAQEvN+tD6orqGxRvsJlN2gifq+xQQB+5cFlOkGAUOKEg9rtOJQ15tWLkbcL
H3ZVnmsat9FPUoL3QAsBsjstNxMwofVXR47J1QDIpLjW6+mBhccoEA==
=j1yZ
-----END PGP SIGNATURE-----

--==_Exmh_1528404057_2539P--
