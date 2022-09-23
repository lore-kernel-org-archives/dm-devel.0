Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17252C6FA86
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954596;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=jZxkHNQMUB786Z+cO3xCG/n8gLaIYnjCTuMPMMDWKeY=;
	b=T9VhhHFAhceuaYkvQYAkVvY10myjv1VU3B+yWJmThGYs7rbfMHx1ErXT3j47I7NE7Nt6Sf
	ViKQBk4FkCg3KmjQOo2PRVcjNzrbEmDlbzA5KFPpOftHF3YG8TKmL9sA3sXZ2saTT2dgic
	MgXT/6s+T9+jcRBVyH6Q5Zu8fryPq5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-NpY1XxdWMDCCYQq9ofNYIg-1; Fri, 23 Sep 2022 13:36:32 -0400
X-MC-Unique: NpY1XxdWMDCCYQq9ofNYIg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16279872848;
	Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2E9C49BB60;
	Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA85019465B6;
	Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81BDF19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 630AC2028E90; Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE692024CC5
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3671F872847
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:26 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-T96FpdDGO8Oqs2tDJYBxcw-1; Fri, 23 Sep 2022 13:36:24 -0400
X-MC-Unique: T96FpdDGO8Oqs2tDJYBxcw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173622euoutp0108bb67e15e20ac5c8ec2bbd18b3a351f~XjeBq078E0810708107euoutp01_
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173622euoutp0108bb67e15e20ac5c8ec2bbd18b3a351f~XjeBq078E0810708107euoutp01_
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173621eucas1p1efd71c6b9be430ff1fc25874264177f0~XjeAbW_iG1387913879eucas1p1E;
 Fri, 23 Sep 2022 17:36:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id A4.6E.29727.49EED236; Fri, 23
 Sep 2022 18:36:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65~Xjd-VO9jb1390013900eucas1p1H;
 Fri, 23 Sep 2022 17:36:19 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173619eusmtrp153694b731b806786b4e038580dbfd562~Xjd-UQcdb1032310323eusmtrp1W;
 Fri, 23 Sep 2022 17:36:19 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-1e-632dee943151
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id A7.78.07473.39EED236; Fri, 23
 Sep 2022 18:36:19 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173619eusmtip1613f6827d35757d800c666df5309f030~Xjd__cKuy0836708367eusmtip1P;
 Fri, 23 Sep 2022 17:36:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:05 +0200
Message-Id: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87pT3ukmGzS1mVmsP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBlXLz9iKjgS
 XfHg3CPmBsYdbl2MnBwSAiYSE8/PZOxi5OIQEljBKLF2wWN2COcLo8SLydPZIJzPjBIt55ey
 w7Rc+bqcFcQWEljOKNH9Rg+i6CWjxOx7R4BmcXCwCWhJNHaC1YsIpEsc33oTbCqzwDYmibaZ
 O1lAEsIC4RIzpl4AK2IRUJW4+GcJWJxXwEJi657/bBDL5CVmXvrODhEXlDg58wlYDTNQvHnr
 bGaQoRICyzklXl2ZCHWdi8TsN4eZIWxhiVfHt0DFZSROT+5hgbCrJZ7e+A3V3MIo0b9zPRvI
 1RIC1hJ9Z3JATGYBTYn1u/Qhyh0lPh5+wg5RwSdx460gxAl8EpO2TWeGCPNKdLQJQVQrSez8
 +QRqqYTE5aY5UEs9JK5NPssMCbZYibVTjjNNYFSYheSxWUgem4VwwwJG5lWM4qmlxbnpqcWG
 eanlesWJucWleel6yfm5mxiBafD0v+OfdjDOffVR7xAjEwfjIUYJDmYlEd6Ui7rJQrwpiZVV
 qUX58UWlOanFhxilOViUxHnZZmglCwmkJ5akZqemFqQWwWSZODilGpiqVadcy02JXPGn4UVh
 /Ot4002/qnyfRG7mefupKliMTczKbftJ0aaG5TYWLtYsWyIeFu15P6VPNtJt0xodjoz7pswb
 g0sn/z1n2vplvazxCsPVgv/mpR1Wi1++btFrqSn3Lv3qFzF8rVPrVh0dHtLnZ+wku//yzK4V
 N6autFm6QXRaT7eRw/SjdlkP75SIOmyx+P1hgxOf7hnnAs0UM9W4/zefTJjFIsF7WSRH+uNZ
 1UMeLKsemRyJm+8qJ6Mw9eik/v1Rf1ZsXK7p5v/8+kOVYy2yUZlOM04Kta47FV/c8Ctj+lfV
 P4/CO/LTEpnmG0vf8jyzO91379xCf0XRE0HP700pqDD3fDl7YcA/xkolluKMREMt5qLiRACr
 lNuG8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7qT3+kmG5xfrmux/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6Rla
 WugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GVcvfyIqeBIdMWDc4+YGxh3uHUxcnJICJhI
 XPm6nLWLkYtDSGApo8S+EzPZIBISErcXNjFC2MISf651sUEUPWeUaDnWwtLFyMHBJqAl0djJ
 DlIjIpArcWztPbBBzAJHmCTadt8HSwgLhEocXjuJBcRmEVCVuPhnCZjNK2AhsXXPf6hl8hIz
 L31nB5nJLKApsX6XPkSJoMTJmU/AypmBSpq3zmaewMg/C6FqFpKqWUiqFjAyr2IUSS0tzk3P
 LTbUK07MLS7NS9dLzs/dxAiM123Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeFMu6iYL8aYkVlal
 FuXHF5XmpBYfYjQFunois5Rocj4wYeSVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqem
 FqQWwfQxcXBKNTCFZ/26Xrnh6OW5y5LOJj6d58EqrFl2qjp+3vs7H59FHJ75q6C/qojRqSTP
 Nrcr6fCBDfrBK5+kZZ9yfx7j7XpQ+K397t1qV15ferK6ujlqW0/J8hlfzlp7fP46sYCbVSDk
 4d34c3NffvXs39RncDPEJH7pw5RZnBErNmQ82OSyVlRjptvrBdps/Zu+3RHbqvQ0ctW+R9Zy
 us5uj7bNVxSfZKE0scnYteK2+YYn9RNiTolODMtk+HFzuuykOWtfV93XNzs+vyLgksW9iSsq
 2JqcDnmtkVBfxD1N3rCBYbfAao/ukvDil9y7HyakRB/6XjF5x1zL77u5J12Ialp6b+PTAK7l
 Ov5985Rdu9Ov+jFaKrEUZyQaajEXFScCAGYERZ1gAwAA
X-CMS-MailID: 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65
X-Msg-Generator: CA
X-RootMTR: 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v15 00/13] support zoned block devices with
 non-power-of-2 zone sizes
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
 dm-devel@redhat.com, Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,
  Please consider this patch series for the 6.1 release.

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
naturally align to po2. In these devices, zone capacity(cap) is not the
same as the po2 zone size. When the zone cap != zone size, then unmapped
LBAs are introduced to cover the space between the zone cap and zone size.
po2 requirement does not make sense for these type of zone storage devices.
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
layer and a new **dm target** is added: dm-po2zoned-target. This new
target will be initially used for filesystems such as btrfs and
f2fs until native npo2 zone support is added.

- Patchset description:
Patches 1-3 deals with removing the po2 constraint from the
block layer.

Patches 4-5 deals with removing the constraint from nvme zns.

Patch 5 removes the po2 contraint in null blk

Patch 6 adds npo2 support to zonefs

Patches 7-13 adds support for npo2 zoned devices in the DM layer and
adds a new target dm-po2zoned-target which converts a zoned device with
npo2 zone size into a zoned target with po2 zone size.

The patch series is based on linux-next tag: next-20220921

Testing:
The new target was tested with blktest and zonefs test suite in qemu and
on a real ZNS device with npo2 zone size.

Performance Measurement on a null blk:
Device:
zone size = 128M, blocksize=4k

FIO cmd:
fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
--io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
--loops=4

The following results are an average of 4 runs on AMD Ryzen 5 5600X with
32GB of RAM:

Sequential Write:
x-----------------x---------------------------------x---------------------------------x
|     IOdepth     |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
x-----------------x---------------------------------x---------------------------------x

Sequential read:
x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
x-----------------x---------------------------------x---------------------------------x

Random read:
x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
x-----------------x---------------------------------x---------------------------------x

Minor variations are noticed in Sequential write with io depth 8 and
in random read with io depth 16. But overall no noticeable differences
were noticed

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

Changes since v8:
- Rename dm-po2z to dm-po2zone
- set max_io_len for the target to po2 zone size sector
- Simplify dm-po2zone target by removing some superfluous conditions
- Added documentation for the new dm-po2zone target
- Change pr_warn to pr_err for critical errors
- Split patch 2 and 11 with their corresponding prep patches
- Minor spelling and grammatical improvements

Changes since v9:
- Add a check for a zoned device in dm-po2zone ctr.
- Rephrased some commit messages and documentation for clarity

Changes since v10:
- Simplified dm_poz_map function (Damien)

Changes since v11:
- Rename bio_in_emulated_zone_area and some formatting adjustments
  (Damien)

Changes since v12:
- Changed the name from dm-po2zone to dm-po2zoned to have a common
  naming convention for zoned devices(Mike)
- Return directly from the dm_po2z_map function instead of having
  returns from different functions (Mike)
- Change target type to target feature flag in commit header (Mike)
- Added dm_po2z_status function and NOWAIT flag to the target
- Added some extra information to the target's documentation.

Changes since v13:
- Use goto for cleanup in dm-po2zoned target (Mike)
- Added dtr to dm-po2zoned target
- Expose zone capacity instead of po2 zone size for
  DMSTATUS_TYPE_INFO(Mike)

Changes since v14:
- Make sure to put device if ctr fails after dm_get_device(Mike)

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (12):
  block: make bdev_nr_zones and disk_zone_no generic for npo2 zone size
  block: rearrange bdev_{is_zoned,zone_sectors,get_queue} helper in
    blkdev.h
  block: allow blk-zoned devices to have non-power-of-2 zone size
  nvmet: Allow ZNS target to support non-power_of_2 zone sizes
  nvme: zns: Allow ZNS drives that have non-power_of_2 zone size
  null_blk: allow zoned devices with non power-of-2 zone sizes
  zonefs: allow non power of 2 zoned devices
  dm-zone: use generic helpers to calculate offset from zone start
  dm-table: allow zoned devices with non power-of-2 zone sizes
  dm: call dm_zone_endio after the target endio callback for zoned
    devices
  dm: introduce DM_EMULATED_ZONES target feature flag
  dm: add power-of-2 target for zoned devices with non power-of-2 zone
    sizes

 .../admin-guide/device-mapper/dm-po2zoned.rst |  79 +++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 block/blk-core.c                              |   2 +-
 block/blk-zoned.c                             |  37 ++-
 drivers/block/null_blk/main.c                 |   5 +-
 drivers/block/null_blk/null_blk.h             |   1 +
 drivers/block/null_blk/zoned.c                |  18 +-
 drivers/md/Kconfig                            |  10 +
 drivers/md/Makefile                           |   2 +
 drivers/md/dm-po2zoned-target.c               | 293 ++++++++++++++++++
 drivers/md/dm-table.c                         |  20 +-
 drivers/md/dm-zone.c                          |   8 +-
 drivers/md/dm-zoned-target.c                  |   8 +
 drivers/md/dm.c                               |   8 +-
 drivers/nvme/host/zns.c                       |  14 +-
 drivers/nvme/target/zns.c                     |   3 +-
 fs/zonefs/super.c                             |   6 +-
 fs/zonefs/zonefs.h                            |   1 -
 include/linux/blkdev.h                        |  80 +++--
 include/linux/device-mapper.h                 |   9 +
 20 files changed, 530 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zoned.rst
 create mode 100644 drivers/md/dm-po2zoned-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

