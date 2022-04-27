Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60408C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-wHys06gON9qG91_fyqIIpA-1; Fri, 29 Apr 2022 04:23:55 -0400
X-MC-Unique: wHys06gON9qG91_fyqIIpA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 269708339A1;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BD5540D2836;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC8341947B81;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 62FC51947043
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 510D6698CE1; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C62557F027
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26D691815CF7
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-8ZbzyC5sMfafF0gZuAdYXg-1; Wed, 27 Apr 2022 12:11:48 -0400
X-MC-Unique: 8ZbzyC5sMfafF0gZuAdYXg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160258euoutp029bd4b7679311b52ee7399585b900ce3a~pzE8Z4BA41441914419euoutp02l
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:02:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160258euoutp029bd4b7679311b52ee7399585b900ce3a~pzE8Z4BA41441914419euoutp02l
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160256eucas1p252958f4ee36901197d6f974e3560f069~pzE69jBaR0647406474eucas1p2a;
 Wed, 27 Apr 2022 16:02:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5E.F9.10260.03969626; Wed, 27
 Apr 2022 17:02:56 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427160256eucas1p2db2b58792ffc93026d870c260767da14~pzE6Zv6eI2335723357eucas1p2e;
 Wed, 27 Apr 2022 16:02:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160256eusmtrp2db328686c1f04e7aa12eb0ef672a4b77~pzE6W4EF62598325983eusmtrp2a;
 Wed, 27 Apr 2022 16:02:56 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-7c-62696930abfd
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 19.71.09522.03969626; Wed, 27
 Apr 2022 17:02:56 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160255eusmtip28f0e31bb579db42914dda258fed0ec00~pzE585B-12538025380eusmtip2K;
 Wed, 27 Apr 2022 16:02:55 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:39 +0200
Message-Id: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUxTVxzdfe/1tXQBn9WEG9TgOjWZRD6mJte5bGyBceMSdST4hwlhpbwA
 WQHT2o1tGhDQSVmB4hjQonxMEQEtFAQLA7GJlG+Q2glGYDiaCbhKW3B8CBvdq5n/nXN+53fP
 +SVXQIrqaT9BYvJpVp4skYlpIdXctTy4LzgxMTZ4cCII6Xu7SFQ7nkejn+eXSdRXOECggrxi
 PlodGCJRu13HQ8NL5wg01mkk0I3a+wSa1mtJ9GPnPIXWVBMbWtYUiV5NhaAC028A2axaArU/
 DkAjf1Tz0UhlBPq1vYdCltZSGpVV2fgo/8IiiUbzbQBpzI085LqWxUe35l5QqPvxttAd2PLw
 c7zeXUdjTaadj4cmGihsGVBiQ002jSvSC0nceDUNt5W7CNw2lk5jdaadxsbzkzz8osNK49ym
 GoD1TVYK5zc28I6LTgo/jGNliV+z8qCPvhQmZCz8QJ3qDU01r0/R6aB1vwp4CSBzAI5dcpIq
 IBSImGoAu4fbeRxZAPDOpUkPcW2QnjXy9cqNIo1ncB3AkZXnnv0ZAGvKmikVEAhoZi88l813
 61uZUQA19fWEm5DMLAmHmx4R7qe2MIdhUVUn340pZjdcuviS58bezAcw56e7gIvzhyUjf/M5
 fTPsKZmm3Jjc0DNv6/5LhkyFEJocTzz9wuC1hlKCw1vgrLmJz+Ht8B9jmUf/HtpGVz3LWQDm
 GfW0uzbcaJTbL3NDknkP6luDOPsn8Hf1NI9z+MDRvzZzFXxgQXMRycne8OIFEecWQ+PytCcU
 QktGKcVZMFxojXDLIiYaOm7lUvlgp/aNu7Rv3KX9v0I5IGuAL6tUJMWziv3J7DeBCkmSQpkc
 HyhNSTKAjU/dt25evAOqZx2BJkAIgAlAASne6r3QlhAr8o6TfPsdK0+JkStlrMIEtgkosa+3
 NLFeImLiJafZr1j2FCt/PSUEXn7pRCWz6fKVP2PulofuWQp5Fn+ALFFU5hz1k86nnFHNhd28
 p3vZobV/Kuo53lVV+3RG9W721Uetjo4dpR3KzwLsB8dNfq8Mkt4rui8o/0XLg+YZXfyy/u16
 a/+x91N3x5zc/ot6Z9QKiq5YG0iJ8D+/hmJXTxxqPixdDnWFR/sYwsHZQkOJ/K0ABa6TpTkP
 PnCeaejepN7jlbZ01nW/Tnf0Y9suo3j96RFr+L2YSKolI27OXikJVt9siczFWcyxbtz4xHeV
 rCuOfJhTdcQQpXE+n4xKL+0sOrQy5DA/c6XwytRLs14N48qssPHId4w6aZO/UzOIo4rH+1L7
 W657KS6fEFOKBEnIXlKukPwL4VxeMEMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xe7oGmZlJBvM+clqsP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehlNX9pZCk45VBz/95CtgXGXcRcjJ4eEgInEyukTWbsYuTiEBJYyStz6+JQNIiEhcXth
 EyOELSzx51oXG0TRc0aJ++92MXcxcnCwCWhJNHayg8RFBJ4AxX8+ZgFxmAUaWCRuTdzFBNIt
 LGAtMX3ZAXYQm0VAVeJHxzdWEJtXwEqie8p+qA3yEjMvfWcHGcosoCmxfpc+RImgxMmZT1hA
 bGagkuats5knMPLPQqiahaRqFpKqBYzMqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQITyrZj
 PzfvYJz36qPeIUYmDsZDjBIczEoivF92ZyQJ8aYkVlalFuXHF5XmpBYfYjQFunois5Rocj4w
 peWVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTA1JdufvXcynOfi
 pXuTLhkefG2q8WLH7WdhmVprjm3+cdX5mJijzEWdyiOcu/dxbf7YIKCW4dNb1rGYSUQuRig2
 9PVVkweThJ901qkbO/6QWZt9M3fORd6ZO5Yr8vtVXGeY3p1vV3LQZnmQCvcqPh+FPvfv8yKe
 Xu07tUutOTf/O8ub+5K+LNUXrxhqZe8KupNd+NVMW+Luyo/nL8b9eqW38mW7UAYP33zPBbMO
 Sucz35nwwLf1zJ3o7KjLFyc+4ePdKryxK7n7tNem7T+Xza3KO8NT2JbvNb1DITvuRvdGp0lu
 nFOaun4fcF50rF3pmtpywTn1K5YUT4r82WmeM/Xtu3f/a1Y4qPH/MFT6Pe2pEktxRqKhFnNR
 cSIA3zNCZbEDAAA=
X-CMS-MailID: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
X-Msg-Generator: CA
X-RootMTR: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
References: <CGME20220427160256eucas1p2db2b58792ffc93026d870c260767da14@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 00/16] support non power of 2 zoned devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

- Background and Motivation:

The zone storage implementation in Linux, introduced since v4.10, first
targetted SMR drives which have a power of 2 (po2) zone size alignment
requirement. The po2 zone size was further imposed implicitly by the
block layer's blk_queue_chunk_sectors(), used to prevent IO merging
across chunks beyond the specified size, since v3.16 through commit
762380ad9322 ("block: add notion of a chunk size for request merging").
But this same general block layer po2 requirement for blk_queue_chunk_sectors()
was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
to be non-power-of-2"). NAND, which is the media used in newer zoned storage
devices, does not naturally align to po2, and so the po2 requirement
does not make sense for those type of zone storage devices.

Removing the po2 requirement from zone storage should therefore be possible
now provided that no userspace regression and no performance regressions are
introduced. Stop-gap patches have been already merged into f2fs-tools to
proactively not allow npo2 zone sizes until proper support is added [0].
Additional kernel stop-gap patches are provided in this series for dm-zoned.
Support for npo2 zonefs and btrfs support is addressed in this series.

There was an effort previously [1] to add support to non po2 devices via
device level emulation but that was rejected with a final conclusion
to add support for non po2 zoned device in the complete stack[2].

- Patchset description:
This patchset aims at adding support to non power of 2 zoned devices in
the block layer, nvme layer, null blk and adds support to btrfs and
zonefs.

This round of patches **will not** support f2fs and DM layer for non
power of 2 zoned devices. More about this in the future work section.

Patches 1-4 deals with removing the po2 constraint from the
block layer. Note that the patches have been split for clarity and it can
be squashed together if the community feels that is better.

Patches 5-6 deals with removing the constraint from nvme zns.

Patches 7-11 adds support to btrfs for non po2 zoned devices.

Patch 12 removes the po2 constraint in ZoneFS

Patch 13 removes the po2 contraint in null blk

Patches 14-16 adds conditions to not allow non power of 2 devices in
f2fs and DM.

- Performance:
PO2 zone sizes utilizes log and shifts instead of division when
determing alignment, zone number, etc. The same math cannot be used when
using a zoned device with non po2 zone size. Hence, to avoid any performance
regression on zoned devices with po2 zone sizes, the optimized math in the
hot paths has been retained with branching.

The performance was measured using null blk for regression
and the results have been posted in the appropriate commit log. No
performance regression was noticed.

- Testing
With respect to testing we need to tackle two things: one for regression
on po2 zoned device and progression on non po2 zoned devices.

kdevops (https://github.com/mcgrof/kdevops) was extensively used to
automate the testing for blktests and (x)fstests for btrfs changes. The
known failures were excluded during the test based on the baseline
v5.17.0-rc7

-- regression
Emulated zoned device with zone size =128M , nr_zones = 10000

Block and nvme zns:
blktests were run with no new failures

Btrfs:
Changes were tested with the following profile in QEMU:
[btrfs_simple_zns]
TEST_DIR=<dir>
SCRATCH_MNT=<mnt>
FSTYP=btrfs
MKFS_OPTIONS="-f -d single -m single"
TEST_DEV=<dev>
SCRATCH_DEV_POOL=<dev-pool>

No new failures were observed in btrfs, generic and shared test suite

ZoneFS:
zonefs-tests-nullblk.sh and zonefs-tests.sh from zonefs-tools were run
with no failures.

nullblk:
t/zbd/run-tests-against-nullb from fio was run with no failures.

F2FS and DM:
It was verified if f2fs and dm-zoned successfully mounts without any
error.

-- progression
Emulated zoned device with zone size = 96M , nr_zones = 10000

Block and nvme zns:
blktests were run with no new failures

Btrfs:
Same profile as po2 zone size was used.

Many tests in xfstests for btrfs included dm-flakey and some tests
required dm-linear. As they are not supported at the moment for non
po2 devices, those **tests were excluded for non po2 devices**.

No new failures were observed in btrfs, generic and shared test suite

ZoneFS:
zonefs-tests.sh from zonefs-tools were run with no failures.

nullblk:
A new section was added to cover non po2 devices:

section14()
{
       conv_pcnt=10
       zone_size=3
       zone_capacity=3
       max_open=${set_max_open}
       zbd_test_opts+=("-o ${max_open}")
}
t/zbd/run-tests-against-nullb from fio was run with no failures.

F2FS and DM:
It was verified that f2fs and dm-zoned does not mount.

- Open issue:
* btrfs superblock location for zoned devices is expected to be in 0,
  512GB(mirror) and 4TB(mirror) in the device. Zoned devices with po2
  zone size will naturally align with these superblock location but non
  po2 devices will not align with 512GB and 4TB offset.

  The current approach for npo2 devices is to place the superblock mirror
  zones near   512GB and 4TB that is **aligned to the zone size**. This
  is of no issue for normal operation as we keep track where the superblock
  mirror are placed but this can cause an issue with recovery tools for
  zoned devices as they expect mirror superblock to be in 512GB and 4TB.

  Note that ATM, recovery tools such as `btrfs check` does not work for
  image dumps for zoned devices even for po2 zone sizes.

  I hope this issue could be discussed as a part of the BoF on ZNS
  during the upcoming LSFMM.

- Tools:
Some tools had to be updated to support non po2 devices. Once these
patches are accepted in the kernel, these tool updates will also be
upstreamed.
* btrfs-prog: https://github.com/Panky-codes/btrfs-progs/tree/remove-po2-btrfs
* blkzone: https://github.com/Panky-codes/util-linux/tree/remove-po2

- Future work
To reduce the amount of changes and testing, support for F2FS and DM was
excluded in this round of patches. The plan is to add support to them in
the forthcoming future.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/commit/?h=dev-test&id=6afcf6493578e77528abe65ab8b12f3e1c16749f
[1] https://lore.kernel.org/all/20220310094725.GA28499@lst.de/T/
[2] https://lore.kernel.org/all/20220315135245.eqf4tqngxxb7ymqa@unifi/

Luis Chamberlain (4):
  nvmet: use blk_queue_zone_no()
  f2fs: call bdev_zone_sectors() only once on init_blkz_info()
  f2fs: ensure only power of 2 zone sizes are allowed
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (12):
  block: make blkdev_nr_zones and blk_queue_zone_no generic for npo2
    zsze
  block: add blk_queue_zone_aligned and bdev_zone_aligned helper
  block: add bdev_zone_no helper
  block: allow blk-zoned devices to have non-power-of-2 zone size
  nvme: zns: Allow ZNS drives that have non-power_of_2 zone size
  btrfs: zoned: Cache superblock location in btrfs_zoned_device_info
  btrfs: zoned: add generic btrfs helpers for zoned devices
  btrfs: zoned: Make sb_zone_number function non power of 2 compatible
  btrfs: zoned: use btrfs zone helpers to support non po2 zoned devices
  btrfs: zoned: relax the alignment constraint for zoned devices
  zonefs: allow non power of 2 zoned devices
  null_blk: allow non power of 2 zoned devices

 block/blk-core.c               |   3 +-
 block/blk-zoned.c              |  20 ++++--
 drivers/block/null_blk/main.c  |   4 +-
 drivers/block/null_blk/zoned.c |  14 ++--
 drivers/md/dm-zone.c           |  12 ++++
 drivers/nvme/host/zns.c        |  11 +---
 drivers/nvme/target/zns.c      |   2 +-
 fs/btrfs/volumes.c             |  24 +++----
 fs/btrfs/zoned.c               | 115 +++++++++++++++++----------------
 fs/btrfs/zoned.h               |  41 ++++++++++--
 fs/f2fs/super.c                |  15 +++--
 fs/zonefs/super.c              |   6 +-
 fs/zonefs/zonefs.h             |   1 -
 include/linux/blkdev.h         |  48 +++++++++++++-
 14 files changed, 208 insertions(+), 108 deletions(-)

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

