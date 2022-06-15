Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB77C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-chXqd6_uOCOSsLZmKq0KTA-1; Wed, 15 Jun 2022 06:19:34 -0400
X-MC-Unique: chXqd6_uOCOSsLZmKq0KTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F39C53804510;
	Wed, 15 Jun 2022 10:19:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A84D1415106;
	Wed, 15 Jun 2022 10:19:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90C401947B84;
	Wed, 15 Jun 2022 10:19:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88DFB194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 758D0403350; Wed, 15 Jun 2022 10:19:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 712B140334D
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 527633804516
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:29 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-Nn8Baax3MoaPPK-IlKm9Kw-1; Wed, 15 Jun 2022 06:19:27 -0400
X-MC-Unique: Nn8Baax3MoaPPK-IlKm9Kw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101926euoutp01c97a7ffbd17a88e9baabac12729969d1~4w--SubOH2526325263euoutp01I
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615101926euoutp01c97a7ffbd17a88e9baabac12729969d1~4w--SubOH2526325263euoutp01I
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101924eucas1p2bfd985105dbde7d99937b28ba581d0cc~4w-9aNVFB1911219112eucas1p2d;
 Wed, 15 Jun 2022 10:19:24 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 51.69.09580.C22B9A26; Wed, 15
 Jun 2022 11:19:24 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615101924eucas1p27fbce623c0e1b3097169bf23dd6266d8~4w-8-ROYS1347713477eucas1p2y;
 Wed, 15 Jun 2022 10:19:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101924eusmtrp21deac3323e9ad9a545214ba29eb80c7c~4w-8_QOZ40308003080eusmtrp2L;
 Wed, 15 Jun 2022 10:19:24 +0000 (GMT)
X-AuditID: cbfec7f5-1bfc7a800000256c-ed-62a9b22c1929
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 90.45.09095.B22B9A26; Wed, 15
 Jun 2022 11:19:24 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101922eusmtip2de5ad9ee81cfad14bcb36acabf49fde2~4w-7j7FbM0785907859eusmtip2D;
 Wed, 15 Jun 2022 10:19:22 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:07 +0200
Message-Id: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djP87o6m1YmGZw5Lmex+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFp+XtrBbrLn5lMWibeNXRgchj8tXvD3+nVjD5rFz1l12j8tnSz02repk
 81jYMJXZY/OSeo/dNxuAcq33WT3e77vK5tG3ZRWjx/otV1k8Np+u9vi8Sc6j/UA3UwB/FJdN
 SmpOZllqkb5dAlfGxe1/mQq+GlVcm3OTqYFxlUYXIyeHhICJxMaeX0xdjFwcQgIrGCVudN2A
 cr4wSuxduYcVwvnMKNF8cTIbTMvUhcdYIBLLGSV2vN3BDOG8ZJRY8eMZUAsHB5uAlkRjJztI
 g4hAuMTRPffAxjILvGCSWHx7LitIQljAVuLXvv/sIPUsAqoSM1v4QExeASuJze06ELvkJWZe
 +g42hldAUOLkzCcsIDYzULx562ywtRIC+zklZvatgjrOReJ27wooW1ji1fEt7BC2jMT/nfOZ
 IOxqiac3fkM1tzBK9O9czwayWELAWqLvTA6IySygKbF+lz5E1FHi/dlsCJNP4sZbQYgL+CQm
 bZvODBHmlehoE4KYrSSx8+cTqJ0SEpeb5rBA2B4SPx88BrtLSCBW4vzUL8wTGBVmIflrFpK/
 ZiGcsICReRWjeGppcW56arFxXmq5XnFibnFpXrpecn7uJkZgsjz97/jXHYwrXn3UO8TIxMF4
 iFGCg1lJhNcseGWSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkm
 Dk6pBqaSxw/dslUj+nU10/M8nT5Zbd3MvUlpvn9Nyfe2bdt2bm+t2lNRZMevmXtFOvfBg5On
 jlwsuBnaYegQlH5ryoT2LVnlZxJe+O1gcthrt/dP/KZS+RIOIX2/ZUUzt9RHFm0su+DGGKzy
 VK1TTUa20XGN/Z9fuz43Pbg8QXPqkpDKWLn2kjm/grfPrmffl73nxYFlS5vvi6+xce/QSmHT
 mdBV/0PKLd3KgHtLOvMhreo/1qlflk+a8nWXpGPlnBMn9yWr2NhaS2rWf1x6XvqhpcHJTc8v
 SpnXpcZ+4kpepL/xVQejZdHbW8un6mqtF2CZ8N1qZaOSadbh5U478x7HH04628h0SnSjxPWa
 pv/5W5RYijMSDbWYi4oTATFKlk0FBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t/xe7o6m1YmGfTsYLRYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5ksnqyfxWzRc+ADi8XfrntAsZaHQMW3
 tC0u75rDZjF/2VN2i89LW9gt1tx8ymLRtvEro4OQx+Ur3h7/Tqxh89g56y67x+WzpR6bVnWy
 eSxsmMrssXlJvcfumw1Audb7rB7v911l8+jbsorRY/2Wqywem09Xe3zeJOfRfqCbKYA/Ss+m
 KL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j4va/TAVf
 jSquzbnJ1MC4SqOLkZNDQsBEYurCYyxdjFwcQgJLGSXOPVvLBpGQkLi9sIkRwhaW+HOtiw2i
 6DmjxNtbc1i7GDk42AS0JBo72UFqRASiJTpvvgerYRb4wSQxYdFasISwgK3Er33/2UHqWQRU
 JWa28IGYvAJWEpvbdSDGy0vMvPQdrIJZQFNi/S59kDCvgKDEyZlPWEBsZqCS5q2zmScw8s9C
 qJqFpGoWkqoFjMyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAqN627Gfm3cwznv1Ue8QIxMH
 4yFGCQ5mJRFes+CVSUK8KYmVValF+fFFpTmpxYcYTYFunsgsJZqcD0wreSXxhmYGpoYmZpYG
 ppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTP2PrylJNAvLWv5hPrPjq3HjxLgMX36n
 G4YG6x5cmOp/98bNS3OCPnLPvMp3ROnkx0mhK05Wv+jJ2vL+p657idASR67LDndTpOzLzPPj
 VQ18uYX8HybcWXfpsth8+2/maf7Wvg/0Fe72zhWc4KEp/jXvskjqUmbdZYfOv53dO/Vmss+F
 uHOzle+ZK33WVT0zxT+r8V3Kb9XKyPTbZjsYpjOoS24Od7NJsL/9Keba2oqyw67lW167bo3w
 et/+ZVuGyukNmerJS5f4/2jL1s4yTav9zf1i0goepqPR3+Wf/sz+kLPgqLH7f7+yB90PmFL/
 nFSoX8fI4Be51urMzWTlPb8/r2v8G74/av2HNCmFl0osxRmJhlrMRcWJADNa+FZzAwAA
X-CMS-MailID: 20220615101924eucas1p27fbce623c0e1b3097169bf23dd6266d8
X-Msg-Generator: CA
X-RootMTR: 20220615101924eucas1p27fbce623c0e1b3097169bf23dd6266d8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101924eucas1p27fbce623c0e1b3097169bf23dd6266d8
References: <CGME20220615101924eucas1p27fbce623c0e1b3097169bf23dd6266d8@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v7 00/13] support non power of 2 zoned device
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
to be non-power-of-2").

NAND, which is the media used in newer zoned storage devices, does not
naturally align to po2. In these devices, zone cap is not the same as the
po2 zone size. When the zone cap != zone size, then unmapped LBAs are
introduced to cover the space between the zone cap and zone size. po2
requirement does not make sense for these type of zone storage devices.
This patch series aims to remove these unmapped LBAs for zoned devices when
zone cap is npo2. This is done by relaxing the po2 zone size constraint
in the kernel and allowing zoned device with npo2 zone sizes if zone cap
== zone size.

Removing the po2 requirement from zone storage should be possible
now provided that no userspace regression and no performance regressions are
introduced. Stop-gap patches have been already merged into f2fs-tools to
proactively not allow npo2 zone sizes until proper support is added [1].

There were two efforts previously to add support to npo2 devices: 1) via
device level emulation [2] but that was rejected with a final conclusion
to add support for non po2 zoned device in the complete stack[3] 2)
adding support to the complete stack by removing the constraint in the
block layer and NVMe layer with support to btrfs, zonefs, etc which was
rejected with a conclusion to add a dm target for FS support [0]
to reduce the regression impact.

This series adds support to npo2 zoned devices in the block and nvme
layer and a new dm target is added: dm-zoned-npo2-target. This new
target will be initially used for filesystems such as btrfs and
f2fs that does not have native npo2 zone support.

- Patchset description:
Patches 1-2 deals with removing the po2 constraint from the
block layer.

Patches 3-4 deals with removing the constraint from nvme zns.

Patch 5-6 removes the po2 contraint in null blk

Patch 7 adds npo2 support to zonefs

Patches 8-13 adds support for npo2 zoned devices in the DM layer and
adds a new target dm-zoned-npo2-target

The patch series is based on linux-next tag: next-20220615

Testing:
The new target was tested with fio, xfstests with btrfs and zonefs test
suite. No new regression was found during the testing.

[0] https://lore.kernel.org/lkml/PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/commit/?h=dev-test&id=6afcf6493578e77528abe65ab8b12f3e1c16749f
[2] https://lore.kernel.org/all/20220310094725.GA28499@lst.de/T/
[3] https://lore.kernel.org/all/20220315135245.eqf4tqngxxb7ymqa@unifi/

Changes since v1:
- Put the function declaration and its usage in the same commit (Bart)
- Remove bdev_zone_aligned function (Bart)
- Change the name from blk_queue_zone_aligned to blk_queue_is_zone_start
  (Damien)
- q is never null in from bdev_get_queue (Damien)
- Add condition during bringup and check for zsze == zcap for npo2
  drives (Damien)
- Rounddown operation should be made generic to work in 32 bits arch
  (bart)
- Add comments where generic calculation is directly used instead having
  special handling for po2 zone sizes (Hannes)
- Make the minimum zone size alignment requirement for btrfs to be 1M
  instead of BTRFS_STRIPE_LEN(David)

Changes since v2:
- Minor formatting changes

Changes since v3:
- Make superblock mirror align with the existing superblock log offsets
  (David)
- DM change return value and remove extra newline
- Optimize null blk zone index lookup with shift for po2 zone size

Changes since v4:
- Remove direct filesystems support for npo2 devices (Johannes, Hannes,
  Damien)

Changes since v5:
- Use DIV_ROUND_UP* helper instead of round_up as it breaks 32bit arch
  build in null blk(kernel-test-robot, Nathan)
- Use DIV_ROUND_UP_SECTOR_T also in blkdev_nr_zones function instead of
  open coding it with div64_u64
- Added extra condition in dm-zoned and in dm to reject non power of 2
  zone sizes.

Changes since v6:
- Added a new dm target for non power of 2 devices
- Added support for non power of 2 devices in the DM layer.

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (12):
  block: make blkdev_nr_zones and blk_queue_zone_no generic for npo2
    zsze
  block: allow blk-zoned devices to have non-power-of-2 zone size
  nvme: zns: Allow ZNS drives that have non-power_of_2 zone size
  nvmet: Allow ZNS target to support non-power_of_2 zone sizes
  null_blk: allow non power of 2 zoned devices
  null_blk: use zone_size_sects_shift for power of 2 zoned devices
  zonefs: allow non power of 2 zoned devices
  dm-zone: use generic helpers to calculate offset from zone start
  dm-table: use bdev_is_zone_start helper in device_area_is_invalid()
  dm-table: allow non po2 zoned devices
  dm: call dm_zone_endio after the target endio callback for zoned
    devices
  dm: add non power of 2 zoned target

 block/blk-core.c                  |   3 +-
 block/blk-zoned.c                 |  37 ++++-
 drivers/block/null_blk/main.c     |   5 +-
 drivers/block/null_blk/null_blk.h |   6 +
 drivers/block/null_blk/zoned.c    |  18 +-
 drivers/md/Kconfig                |   9 +
 drivers/md/Makefile               |   2 +
 drivers/md/dm-table.c             |   6 +-
 drivers/md/dm-zone.c              |  16 +-
 drivers/md/dm-zoned-npo2-target.c | 268 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-target.c      |   8 +
 drivers/md/dm.c                   |   8 +-
 drivers/nvme/host/zns.c           |  21 ++-
 drivers/nvme/target/zns.c         |   2 +-
 fs/zonefs/super.c                 |   6 +-
 fs/zonefs/zonefs.h                |   1 -
 include/linux/blkdev.h            |  48 +++++-
 17 files changed, 416 insertions(+), 48 deletions(-)
 create mode 100644 drivers/md/dm-zoned-npo2-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

