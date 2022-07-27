Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08DAC19F2B
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658941239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Y5BnqD7V8G8+8tJszAt1Gr9gq75EN0o5AgPCYinMWgc=;
	b=PuBmUcTTIVjv7fxju/adx8tN1CW94ryXEFn8AeaE40mXuqNgdcnoDQrg5ddfI83zaUTD1K
	nSJLvJgj+L2dDUDKoXkowbVeKhaf54T1alxTFwO/6mdqL3pl3X++DxlEKxflX5jwNfTFUD
	EzAtUenxQ5VT9fgltPnUflJX3TwLJFU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-8p6yzBvuMXivOy6g85_hEg-1; Wed, 27 Jul 2022 13:00:36 -0400
X-MC-Unique: 8p6yzBvuMXivOy6g85_hEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEDFF85A58E;
	Wed, 27 Jul 2022 17:00:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AB2390A04;
	Wed, 27 Jul 2022 17:00:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BFE81945DAB;
	Wed, 27 Jul 2022 17:00:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A18B81945DB5
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B09940C128A; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86489404E4C3
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68CFB1019E1D
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-OgKDtqGGN9ionrFByzwVGg-1; Wed, 27 Jul 2022 12:32:36 -0400
X-MC-Unique: OgKDtqGGN9ionrFByzwVGg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162248euoutp02760a475ed5ef32a109616cc883337856~FvDPWhzyT0990709907euoutp02A
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220727162248euoutp02760a475ed5ef32a109616cc883337856~FvDPWhzyT0990709907euoutp02A
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162247eucas1p2d8c0046b6278b5cc6fe854de49203d62~FvDN7wcZM0838408384eucas1p26;
 Wed, 27 Jul 2022 16:22:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 7A.B3.09664.65661E26; Wed, 27
 Jul 2022 17:22:46 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754~FvDNH16bm2538125381eucas1p1U;
 Wed, 27 Jul 2022 16:22:46 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220727162246eusmtrp27df1ce6a6243f989fb75bf420746b087~FvDNGr_-X0809408094eusmtrp25;
 Wed, 27 Jul 2022 16:22:46 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-e2-62e166565683
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 96.1E.09095.65661E26; Wed, 27
 Jul 2022 17:22:46 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162245eusmtip172f7144298c1675a23739e45c38e4ecb~FvDMxUYpe0064100641eusmtip1O;
 Wed, 27 Jul 2022 16:22:45 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:34 +0200
Message-Id: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7djPc7phaQ+TDJbtsLFYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAlfGor0XmAquG1dsWcbZ
 wPhKo4uRk0NCwERi5uzHbF2MXBxCAisYJb7Nm8UE4XxhlNi05S07hPOZUeLEg6csXYwcYC3L
 fwhBxJczSiyYsgyq/TmjxMOb91hBitgEtCQaO9lBVogIFEs8fNfKAlLDLDCLSeL0scfMIDXC
 ArYSfSdDQWpYBFQl3v9YwAJi8wpYSaxd/Z4J4jx5iZmXvrNDxAUlTs58AlbDDBRv3jqbGWSm
 hMB8Tokvr08wQzS4SOx9MYkNwhaWeHV8CzuELSPxf+d8qKHVEk9v/IZqbmGU6N+5ng3iM2uJ
 vjM5ICazgKbE+l36EOWOEtu3nIP6nU/ixltBiBP4JCZtm84MEeaV6GgTgqhWktj58wnUUgmJ
 y01zWCBsD4ldbd/BDhASiJWYd3YxywRGhVlIHpuF5LFZCDcsYGRexSieWlqcm55abJiXWq5X
 nJhbXJqXrpecn7uJEZj4Tv87/mkH49xXH/UOMTJxMB5ilOBgVhLhTYi+nyTEm5JYWZValB9f
 VJqTWnyIUZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qBSXJHnZ+l6drXTr94A39PqTwb
 eWnfwqUbYiwuz1/2ujT6e82BpzXfnRfWNPdOcZZ6IrjgzYRvK6eozeKz2PKC7z3n1PRLIdNv
 qEdybE4sF/ZdVnSrLtuFZ3Zy5y+vqPxFNkazl7E84Pm3ReaGd+6xZfNrPdMehR55Or3Y8/tf
 V+VPR4p6dzxbdDRms+ubVXXX76xe+D93yyI9BkXDjqVVh//yqbLp1rKuVXx9ePmyma8XSL4s
 Sg0/c0w/gOPRrTMPz/ltYrw7eVsJm0F417I55RvznsxIm75F3H7Jga1M7N+v/v3fOpfr63ZW
 PyXFS3eiH7m5+nxn6D24XOHAjHfNa/IN5HfuNN39xqHqCHMrR9htJZbijERDLeai4kQAzRaN
 zOsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xu7phaQ+TDPZ/YbFYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYml
 nqGxeayVkamSvp1NSmpOZllqkb5dgl7Gor0XmAquG1dsWcbZwPhKo4uRg0NCwERi+Q+hLkYu
 DiGBpYwS/w+tYO1i5ASKS0jcXtjECGELS/y51sUGYgsJPGWU2L5eFaSXTUBLorGTHcQUEaiU
 OPtFFqSCWWAZk8SGEzIgYWEBW4m+k6EgYRYBVYn3PxawgNi8AlYSa1e/Z4IYLi8x89J3sCnM
 ApoS63fpQ5QISpyc+YQFYqK8RPPW2cwTGPlnIVTNQlI1C0nVAkbmVYwiqaXFuem5xYZ6xYm5
 xaV56XrJ+bmbGIGRue3Yz807GOe9+qh3iJGJg/EQowQHs5IIb0L0/SQh3pTEyqrUovz4otKc
 1OJDjKZAV09klhJNzgemhrySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU7NTUgtQimD4m
 Dk6pBia36WtT1PIex7xmkbp8YbdHsp2FvcOGgFJlVaZz2rwr1k3Pm316nyH3dJ/SNNEwHaZn
 /jc96/7E/NY5qTehdfOcD42LkvTqziYn8PEsqxL7LfOS/y6j71fns9Ln+gV/bz5vdNhTr6F8
 ScuR6lDWVSxz0tt3vtE74GG752PS5ZTJwhKTJ/29ufGyxZL2k07y3tUHJnJY129QZRI78NYj
 rXqtovSMMuuT1mWZ1j654vfy7/WxhK5z0n3i8v3PXZ3Ksiyv3xUXs/iXfJyc5/xC8m3R1jRV
 NibRhPJTm+9xPNt3Ofb7Oa/7T48tP75Su08w+dCUg4G35d8vapsv+Xndpq22r/z+xe9aGCyz
 NHbRva1KLMUZiYZazEXFiQBbh9aZVQMAAA==
X-CMS-MailID: 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754
X-Msg-Generator: CA
X-RootMTR: 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
layer and a new **dm target** is added: dm-po2z-target. This new
target will be initially used for filesystems such as btrfs and
f2fs that does not have native npo2 zone support.

- Patchset description:
Patches 1-2 deals with removing the po2 constraint from the
block layer.

Patches 3-4 deals with removing the constraint from nvme zns.

Patch 5 removes the po2 contraint in null blk

Patch 6 adds npo2 support to zonefs

Patches 7-11 adds support for npo2 zoned devices in the DM layer and
adds a new target dm-po2z-target which converts a npo2 zoned device into
a po2 zoned target.

The patch series is based on linux-next tag: next-20220727

Testing:
The new target was tested with blktest and zonefs test suite in qemu and
on a real ZNS device.

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

Changes since v7:
- Improved dm target for non power of 2 zoned devices with some bug
  fixes and rearrangement
- Removed some unnecessary comments.

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (10):
  block: make bdev_nr_zones and disk_zone_no generic for npo2 zsze
  block: allow blk-zoned devices to have non-power-of-2 zone size
  nvme: zns: Allow ZNS drives that have non-power_of_2 zone size
  nvmet: Allow ZNS target to support non-power_of_2 zone sizes
  null_blk: allow non power of 2 zoned devices
  zonefs: allow non power of 2 zoned devices
  dm-zone: use generic helpers to calculate offset from zone start
  dm-table: allow non po2 zoned devices
  dm: call dm_zone_endio after the target endio callback for zoned
    devices
  dm: add power-of-2 zoned target for non-power-of-2 zoned devices

 block/blk-core.c                  |   2 +-
 block/blk-zoned.c                 |  37 +++--
 drivers/block/null_blk/main.c     |   5 +-
 drivers/block/null_blk/null_blk.h |   6 +
 drivers/block/null_blk/zoned.c    |  18 ++-
 drivers/md/Kconfig                |   9 ++
 drivers/md/Makefile               |   2 +
 drivers/md/dm-po2z-target.c       | 261 ++++++++++++++++++++++++++++++
 drivers/md/dm-table.c             |  21 ++-
 drivers/md/dm-zone.c              |  10 +-
 drivers/md/dm-zoned-target.c      |   8 +
 drivers/md/dm.c                   |   8 +-
 drivers/nvme/host/zns.c           |  16 +-
 drivers/nvme/target/zns.c         |   3 +-
 fs/zonefs/super.c                 |   6 +-
 fs/zonefs/zonefs.h                |   1 -
 include/linux/blkdev.h            |  91 ++++++++---
 include/linux/device-mapper.h     |   9 ++
 18 files changed, 438 insertions(+), 75 deletions(-)
 create mode 100644 drivers/md/dm-po2z-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

