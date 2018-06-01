From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [bisect BUG] dm-crypt percpu counter warnings and invalid kernel
 paging request at virtual address
Date: Fri, 1 Jun 2018 14:55:15 +0200
Message-ID: <CAJKOXPfSbsu0RGTUFfb+t_uOvQQxa0uDn-nsG+1uuKAq56nVXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>
List-Id: dm-devel.ids

Hi,

Todays linux-next 20180601 fails during dm-crypt tests on Exynos5422
(ARMv7, Cortex-A7+A15) using crypto HW block from SoC (s5p-aes).

The test which fails:
https://github.com/krzk/tools/blob/master/tests/s5p-sss-cryptsetup.sh

Effect:

[  149.867394] ------------[ cut here ]------------
[  149.870631] WARNING: CPU: 5 PID: 492 at
../drivers/md/dm-crypt.c:2225 crypt_dtr+0x1c0/0x1c4 [dm_crypt]
[  149.880078] Modules linked in: dm_crypt s5p_jpeg exynos_gsc s5p_mfc
v4l2_mem2mem v4l2_common videobuf2_dma_contig videobuf2_memops
videobuf2_v4l2 videobuf2_common videodev media
[  149.895908] CPU: 5 PID: 492 Comm: cryptsetup Tainted: G        W
     4.17.0-rc4-00159-gae4c15db96d2 #36
[  149.905328] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[  149.911398] [<c011291c>] (unwind_backtrace) from [<c010ece8>]
(show_stack+0x10/0x14)
[  149.919111] [<c010ece8>] (show_stack) from [<c0a32190>]
(dump_stack+0x98/0xc4)
[  149.926307] [<c0a32190>] (dump_stack) from [<c0126fa0>] (__warn+0x10c/0x124)
[  149.933310] [<c0126fa0>] (__warn) from [<c01270d0>]
(warn_slowpath_null+0x40/0x48)
[  149.940862] [<c01270d0>] (warn_slowpath_null) from [<bf28e15c>]
(crypt_dtr+0x1c0/0x1c4 [dm_crypt])
[  149.949803] [<bf28e15c>] (crypt_dtr [dm_crypt]) from [<c06f34b8>]
(dm_table_destroy+0x5c/0xf8)
[  149.958360] [<c06f34b8>] (dm_table_destroy) from [<c06f0cb0>]
(__dm_destroy+0x158/0x1b4)
[  149.966414] [<c06f0cb0>] (__dm_destroy) from [<c06f7988>]
(dev_remove+0xd4/0x104)
[  149.973861] [<c06f7988>] (dev_remove) from [<c06f80b4>]
(ctl_ioctl+0x2e4/0x660)
[  149.981144] [<c06f80b4>] (ctl_ioctl) from [<c029fcc0>]
(do_vfs_ioctl+0xb0/0x9e8)
[  149.988508] [<c029fcc0>] (do_vfs_ioctl) from [<c02a062c>]
(ksys_ioctl+0x34/0x5c)
[  149.995874] [<c02a062c>] (ksys_ioctl) from [<c0101000>]
(ret_fast_syscall+0x0/0x28)
[  150.061101] ---[ end trace 3e3bc2b7df1963aa ]---

[  150.065594] Unable to handle kernel paging request at virtual
address 2e02f000
[  150.383043] [<c0483edc>] (percpu_counter_add_batch) from
[<bf28e378>] (crypt_page_free+0x34/0x3c [dm_crypt])
[  150.392838] [<bf28e378>] (crypt_page_free [dm_crypt]) from
[<c0229b18>] (mempool_exit+0x24/0x60)
[  150.401584] [<c0229b18>] (mempool_exit) from [<bf28e028>]
(crypt_dtr+0x8c/0x1c4 [dm_crypt])
[  150.409903] [<bf28e028>] (crypt_dtr [dm_crypt]) from [<c06f34b8>]
(dm_table_destroy+0x5c/0xf8)
[  150.418477] [<c06f34b8>] (dm_table_destroy) from [<c06f0cb0>]
(__dm_destroy+0x158/0x1b4)
[  150.426533] [<c06f0cb0>] (__dm_destroy) from [<c06f7988>]
(dev_remove+0xd4/0x104)
[  150.433982] [<c06f7988>] (dev_remove) from [<c06f80b4>]
(ctl_ioctl+0x2e4/0x660)
[  150.441264] [<c06f80b4>] (ctl_ioctl) from [<c029fcc0>]
(do_vfs_ioctl+0xb0/0x9e8)
[  150.448628] [<c029fcc0>] (do_vfs_ioctl) from [<c02a062c>]
(ksys_ioctl+0x34/0x5c)
[  150.455994] [<c02a062c>] (ksys_ioctl) from [<c0101000>]
(ret_fast_syscall+0x0/0x28)

---

Full log is here:
https://krzk.eu/#/builders/1/builds/2117/steps/18/logs/serial0

Bisect could not work reliably because a lot of commits from Kent
Overstreet just do not compile. Really, non-buildable stuff should not
be committed...

Anyway bisect points around convert to bioset_init()/mempool_init().

Bisect log:
git bisect start
# good: [ecb37ce9baac653cc09e2b631393dde3df82979f] bcache: Move couple
of functions to sysfs.c
git bisect good ecb37ce9baac653cc09e2b631393dde3df82979f
# bad: [ae4c15db96d22776fe188b5271a226f81e85e872] dm: add writecache target
git bisect bad ae4c15db96d22776fe188b5271a226f81e85e872
# good: [b7405176b58aa475354f3c0d2ca1c560e9354288] Merge branch
'nvme-4.18-2' of git://git.infradead.org/nvme into for-4.18/block
git bisect good b7405176b58aa475354f3c0d2ca1c560e9354288
# skip: [b906bbb6997785d9ea0bd3f5585537afa6257c43] lightnvm: convert
to bioset_init()/mempool_init()
git bisect skip b906bbb6997785d9ea0bd3f5585537afa6257c43
# skip: [0892fac8719f062f98116ee883230a004a9fce1e] drbd: convert to
bioset_init()/mempool_init()
git bisect skip 0892fac8719f062f98116ee883230a004a9fce1e
# bad: [04c4950d5b373ba712d928592e05e73510785bca] block: fixup
bioset_integrity_create() call
git bisect bad 04c4950d5b373ba712d928592e05e73510785bca
# skip: [64c4bc4de79fec06bb46d9827e7c4df67a025590] pktcdvd: convert to
bioset_init()/mempool_init()
git bisect skip 64c4bc4de79fec06bb46d9827e7c4df67a025590
# skip: [8ac9f7c1fd1d342e82ddf078425423b050652ba0] btrfs: convert to
bioset_init()/mempool_init()
git bisect skip 8ac9f7c1fd1d342e82ddf078425423b050652ba0
# skip: [d19936a26658a7a53edd5619d631ee2c2c3151a2] bcache: convert to
bioset_init()/mempool_init()
git bisect skip d19936a26658a7a53edd5619d631ee2c2c3151a2
# skip: [52190f8abe7f2bf2b4e5f9760cbcc1427ca2136b] fs: convert
block_dev.c to bioset_init()
git bisect skip 52190f8abe7f2bf2b4e5f9760cbcc1427ca2136b
# skip: [338aa96d5661048b3c0cafc6d91876025603cacf] block: convert
bounce, q->bio_split to bioset_init()/mempool_init()
git bisect skip 338aa96d5661048b3c0cafc6d91876025603cacf
# good: [2ab74cd29622c48e9852d85618081c061b6ac6d9] blk-throttle: fix
potential NULL pointer dereference in throtl_select_dispatch
git bisect good 2ab74cd29622c48e9852d85618081c061b6ac6d9
# good: [0b6bad7d669ef2abd3b9e1f8cee1fbd448abbc5c] blk-throttle:
return proper bool type to caller instead of 0/1
git bisect good 0b6bad7d669ef2abd3b9e1f8cee1fbd448abbc5c
# skip: [6f1c819c219f7841079f0f43ab62727a55b0d849] dm: convert to
bioset_init()/mempool_init()
git bisect skip 6f1c819c219f7841079f0f43ab62727a55b0d849
# skip: [a47a28b74a5c7c27bf621276b85ad6c124651236] target: convert to
bioset_init()/mempool_init()
git bisect skip a47a28b74a5c7c27bf621276b85ad6c124651236
# skip: [afeee514ce7f4cab605beedd03be71ebaf0c5fc8] md: convert to
bioset_init()/mempool_init()
git bisect skip afeee514ce7f4cab605beedd03be71ebaf0c5fc8
# skip: [e292d7bc63c8f2adb3dfda27910e805f1b6557f9] xfs: convert to
bioset_init()/mempool_init()
git bisect skip e292d7bc63c8f2adb3dfda27910e805f1b6557f9
# skip: [dad08527525f9a8ac9c7f278864c65f94bc5e9b3] block: Drop bioset_create()
git bisect skip dad08527525f9a8ac9c7f278864c65f94bc5e9b3
# only skipped commits left to test
# possible first bad commit:
[04c4950d5b373ba712d928592e05e73510785bca] block: fixup
bioset_integrity_create() call
# possible first bad commit:
[dad08527525f9a8ac9c7f278864c65f94bc5e9b3] block: Drop bioset_create()
# possible first bad commit:
[e292d7bc63c8f2adb3dfda27910e805f1b6557f9] xfs: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[8ac9f7c1fd1d342e82ddf078425423b050652ba0] btrfs: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[52190f8abe7f2bf2b4e5f9760cbcc1427ca2136b] fs: convert block_dev.c to
bioset_init()
# possible first bad commit:
[a47a28b74a5c7c27bf621276b85ad6c124651236] target: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[6f1c819c219f7841079f0f43ab62727a55b0d849] dm: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[afeee514ce7f4cab605beedd03be71ebaf0c5fc8] md: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[d19936a26658a7a53edd5619d631ee2c2c3151a2] bcache: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[b906bbb6997785d9ea0bd3f5585537afa6257c43] lightnvm: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[64c4bc4de79fec06bb46d9827e7c4df67a025590] pktcdvd: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[0892fac8719f062f98116ee883230a004a9fce1e] drbd: convert to
bioset_init()/mempool_init()
# possible first bad commit:
[338aa96d5661048b3c0cafc6d91876025603cacf] block: convert bounce,
q->bio_split to bioset_init()/mempool_init()

Best regards,
Krzysztof
