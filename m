Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51382C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 16:00:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-dmEG0TPfNqySPAREWvdfnA-1; Wed, 25 May 2022 12:00:05 -0400
X-MC-Unique: dmEG0TPfNqySPAREWvdfnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B182C185A794;
	Wed, 25 May 2022 16:00:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C367112131B;
	Wed, 25 May 2022 16:00:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E0AF194F4BF;
	Wed, 25 May 2022 16:00:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A66F194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B0C240D282F; Wed, 25 May 2022 15:50:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46DA440C1240
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26E711C00130
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:04 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-A4D4AOtsMLmHNphkdBlO0A-1; Wed, 25 May 2022 11:50:02 -0400
X-MC-Unique: A4D4AOtsMLmHNphkdBlO0A-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155000euoutp02b0d90be71099a8c65cfeba65e909c89e~yY9ns6VkO0354103541euoutp02D
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220525155000euoutp02b0d90be71099a8c65cfeba65e909c89e~yY9ns6VkO0354103541euoutp02D
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220525154959eucas1p19212cc5cb3c42b45762a8993bebc305c~yY9mG7NPt1681116811eucas1p1e;
 Wed, 25 May 2022 15:49:59 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 49.5B.10009.6205E826; Wed, 25
 May 2022 16:49:59 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220525154958eucas1p2f6af3db8ab178be28eb6c42e9e1be591~yY9luDlFF1436314363eucas1p2A;
 Wed, 25 May 2022 15:49:58 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220525154958eusmtrp27a53011d768f4a6c7f76b14e42e26996~yY9ltLqy40177001770eusmtrp2V;
 Wed, 25 May 2022 15:49:58 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-32-628e502659c4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id BB.8E.09404.6205E826; Wed, 25
 May 2022 16:49:58 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525154958eusmtip280aab28279aa8118080c2646323aed1a~yY9lXaGZE0140601406eusmtip2L;
 Wed, 25 May 2022 15:49:58 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:49 +0200
Message-Id: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djP87rqAX1JBhO6mCxW3+1ns/h99jyz
 xd53s1ktLvxoZLK4eWAnk8WeRZOYLFauPspk8WT9LGaLngMfWCz+dt1jsth7S9vi8q45bBbz
 lz1lt/i8tIXdom3jV0YHfo9/J9aweVw+W+qxaVUnm8fmJfUeu282sHnsbL3P6vF+31U2j74t
 qxg91m+5yuKx+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJ+fXrOUrBMv+LWLocGxja1
 LkZODgkBE4kPt14zdTFycQgJrGCUOPzpOwuE84VRYuba36wQzmdGidXHV7DDtMx5uIMZIrGc
 UWLv+WlQLS8YJb5v/MbWxcjBwSagJdHYyQ4SFxFoZJSY+vIEI4jDLPCVUeLGweeMIEXCAjYS
 x1+HgkxlEVCV+Nq+gxHE5hWwkvh48jULxDZ5iZmXvrNDxAUlTs58AhZnBoo3b50NdoWEwGxO
 iac/n7OAzJQQcJHY/bcUoldY4tXxLVBXy0j83zmfCcKulnh64zdUbwujRP/O9WwQvdYSfWdy
 QExmAU2J9bv0IcodJX7MPsgEUcEnceOtIMQFfBKTtk1nhgjzSnS0CUFUK0ns/PkEaqmExOWm
 OVCPeEh86X3FBmILCcRK9G1eyjqBUWEWkr9mIflrFsINCxiZVzGKp5YW56anFhvmpZbrFSfm
 Fpfmpesl5+duYgQmvdP/jn/awTj31Ue9Q4xMHIyHGCU4mJVEeC887U0S4k1JrKxKLcqPLyrN
 SS0+xCjNwaIkzpucuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwDTV2Y/TLcE2kSXqq8js0rf/nB1v
 JSz9lWCcxuXuJxy+3sf+5oFJdtYlC1h25KW9Xfq3ZU3e2uWXy1slLD4IebqWRxxc8E8q/Car
 kcyZCYd/snm8/LDAtrp7U9nKRzGL+D/b+96LMNO4+JnpzDNLU6F/skzFJy6c3OXbqiO+VTtk
 Mz/DTKtF8655Hrj5YA7rsX0rP5RxqCy7M/dfvi+3eOrVxy/K4iMzPxhsMpmmcCz1xY+DP6/P
 /j7leOP//7OOOqVcv/vxmjNz4P4YYdE1id1L1kwOjD7Ts+n18v9Xq9P2vpyle+m0D4vy9mV/
 daU3HXk3S/dZzI7H1S/6IgUfp+9NDLSI+h118fr1L3PYp/49qsRSnJFoqMVcVJwIAPvKOn7p
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xe7pqAX1JBvP+qVisvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbvF5aQu7RdvGr4wO/B7/Tqxh87h8ttRj06pONo/NS+o9dt9sYPPY2Xqf1eP9vqtsHn1b
 VjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqb
 x1oZmSrp29mkpOZklqUW6dsl6GX8+vScpWCZfsWtXQ4NjG1qXYycHBICJhJzHu5g7mLk4hAS
 WMooseXufWaIhITE7YVNjBC2sMSfa11sEEXPGCWen2sAcjg42AS0JBo72UHiIgKdjBJz9rWC
 OcwC/xkl/nRcZAQpEhawkTj+OhRkEIuAqsTX9h1gQ3kFrCQ+nnzNArFAXmLmpe/sIOXMApoS
 63fpQ5QISpyc+QSshBmopHnrbOYJjPyzEKpmIamahaRqASPzKkaR1NLi3PTcYiO94sTc4tK8
 dL3k/NxNjMDo3Hbs55YdjCtffdQ7xMjEwXiIUYKDWUmE98LT3iQh3pTEyqrUovz4otKc1OJD
 jKZAV09klhJNzgemh7ySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU7NTUgtQimD4mDk6p
 BiabRQxbU+ZMPn8r++bj6IvLVF+laK76t1ZhnWXSoz9mt3zNr1e07ftWtPOGaOOpD6wr5yrc
 ZfZ9a1Qs7SNx5E9Wq9gpE/kHVzbcfPr9oSt7aVLfpL/9EdHcz2cWaljvcOdyZdCceFrzQ87j
 WI4DzCW6H8LevtJfr/eX+VOzDucrrf1N6s1s/qmFokvK/Ffot1ke/awpIOeTarLh1Nkdrl/W
 9DcezNiWebDs5endjHPmz5jo8GBL95Ln3S21AjnXZlh9mbb1+823L6R3rWm82XBuc3fdHXY7
 c5Ydmqubjb3CzSzvPbr35afKrEV1NnOOGumE816dcY+B75KB/EuP7zdmy+/e+rL/ieeBu7tr
 zA2XK7EUZyQaajEXFScCAHGbNo5XAwAA
X-CMS-MailID: 20220525154958eucas1p2f6af3db8ab178be28eb6c42e9e1be591
X-Msg-Generator: CA
X-RootMTR: 20220525154958eucas1p2f6af3db8ab178be28eb6c42e9e1be591
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525154958eucas1p2f6af3db8ab178be28eb6c42e9e1be591
References: <CGME20220525154958eucas1p2f6af3db8ab178be28eb6c42e9e1be591@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v6 0/8] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,
  The previous revision ended up leading to a new direction to add npo2
  device support as a dm target instead of adding support to filesystems
  directly[0]. I would like to hear some inputs from the community,
  especially from Christoph and Mike Snitzer about this approach.

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

- Patchset description:

The support is planned to be added in two phases:
- Add npo2 support to block, nvme layer and necessary stop gap patches
  in the filesystems
- Add dm target for npo2 devices so that they are presented as a po2
  device to filesystems

This patchset addresses the first phase for adding support to npo2
devices.

Patches 1-2 deals with removing the po2 constraint from the
block layer.

Patches 3-4 deals with removing the constraint from nvme zns.

Patch 5-6 removes the po2 contraint in null blk

Patches 7 adds conditions to not allow non power of 2 devices in
DM.

The patch series is based on linux-next tag: next-20220520

- Future work
Add DM target for npo2 devices to be presented as a po2 device.

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

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (7):
  block: make blkdev_nr_zones and blk_queue_zone_no generic for npo2
    zsze
  block: allow blk-zoned devices to have non-power-of-2 zone size
  nvme: zns: Allow ZNS drives that have non-power_of_2 zone size
  nvmet: Allow ZNS target to support non-power_of_2 zone sizes
  null_blk: allow non power of 2 zoned devices
  null_blk: use zone_size_sects_shift for power of 2 zoned devices
  dm: ensure only power of 2 zone sizes are allowed

 block/blk-core.c                  |  3 +--
 block/blk-zoned.c                 | 37 +++++++++++++++++++++++--------
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  6 +++++
 drivers/block/null_blk/zoned.c    | 18 +++++++++------
 drivers/md/dm-table.c             |  6 +++++
 drivers/md/dm-zone.c              | 10 +++++++++
 drivers/md/dm-zoned-target.c      |  8 +++++++
 drivers/nvme/host/zns.c           | 21 ++++++++++--------
 drivers/nvme/target/zns.c         |  2 +-
 include/linux/blkdev.h            | 36 +++++++++++++++++++++++++++++-
 11 files changed, 120 insertions(+), 32 deletions(-)

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

