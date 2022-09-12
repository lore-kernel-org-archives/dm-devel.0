Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E651C6FA86
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970973;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=0ekwsQyw2cBGJTPfyd3hBVJBSrGm37aJhSTQYQqo4rY=;
	b=i+8tyl17ffLERgrK1K5cAxQS1wOGoVoupNhqaHaS8f17AyH3LaNYoVCQCfcfCL3U/bujaC
	9oE0xcntZgB1I2xjl6rXJQJj4GAHnH7XOTQJiYJ2P9XelkIp6Z5sNaTFEBfStqimBvDCl4
	vz2xOG7iUCo6hH5vvZgKz22ssWseAgU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-3HApqPkPO1qi26vEz6H0Vg-1; Mon, 12 Sep 2022 04:22:52 -0400
X-MC-Unique: 3HApqPkPO1qi26vEz6H0Vg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB0003C0E229;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6A3F4B3FC6;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A20BD1946A4A;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1750C1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEDCB1121315; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA206112131B
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB335381078A
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-p9wm7Cj5MbilCSysjqZl0Q-1; Mon, 12 Sep 2022 04:22:48 -0400
X-MC-Unique: p9wm7Cj5MbilCSysjqZl0Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082220euoutp022d4e8b7e626150d87463fcace7ada3ca~UD0J4A5Rh2265222652euoutp02Q
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082220euoutp022d4e8b7e626150d87463fcace7ada3ca~UD0J4A5Rh2265222652euoutp02Q
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082206eucas1p2e66eca1fe9822464354eb96547af3115~UDz9AQXWY2521325213eucas1p2D;
 Mon, 12 Sep 2022 08:22:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 6A.93.19378.E2CEE136; Mon, 12
 Sep 2022 09:22:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082205eucas1p1e5fb1acfb0b2a2fe6261520ace90c883~UDz8CGkOC1570415704eucas1p1l;
 Mon, 12 Sep 2022 08:22:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082205eusmtrp21412da259fe3fb478c9aab14424e4169~UDz8A42yK3082830828eusmtrp2I;
 Mon, 12 Sep 2022 08:22:05 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-3e-631eec2e1577
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 93.33.10862.D2CEE136; Mon, 12
 Sep 2022 09:22:05 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082205eusmtip273ae8f14c5da6e3be214ceaf115ed25f~UDz7rXyfu2764727647eusmtip2q;
 Mon, 12 Sep 2022 08:22:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:51 +0200
Message-Id: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djPc7p6b+SSDWYdUbNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJ2vfrAWvA8
 ouL8ok7WBsYlLl2MnBwSAiYSm9vOs3UxcnEICaxglLjxezkThPOFUWLzv9VsIFVCAp8ZJXZ9
 U4bp+HTmDFTHckaJ1Q/mM0M4Lxkl3nx9ytLFyMHBJqAl0djJDtIgIpAu8X36O7CpzALbmCTu
 P3zBDJIQFgiXmLP2HpjNIqAq0Tb9KCuIzStgKbH9wS5GiG3yEjMvfWeHiAtKnJz5hAXEZgaK
 N2+dDbZYQmA1p8SMHd/ZIBpcJJ68384MYQtLvDq+hR3ClpH4v3M+E4RdLfH0xm+o5hZGif6d
 69lArpYQsJboO5MDYjILaEqs36UPEXWU+HrdHcLkk7jxVhDiAj6JSdumM0OEeSU62oQgZitJ
 7Pz5BGqnhMTlpjksELaHRO/6LnZIcMZKTF3RxDyBUWEWkr9mIflrFsIJCxiZVzGKp5YW56an
 FhvnpZbrFSfmFpfmpesl5+duYgQmwdP/jn/dwbji1Ue9Q4xMHIyHGCU4mJVEeFkMpZOFeFMS
 K6tSi/Lji0pzUosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2CyTJxcEo1MM3f9DtgYvDGT3Ii
 R1TUnGXvuh/74LNAZIu+r7OWYtqX2Ow/+yeyiMfoJTc8eC7G8OHpvfkHA7XWZe4/qBkgutJe
 LuTIKc2UZkMR/9gNJs5zDNNveKy5HPflyYO3jyKcOg8/ebO54INCON/+zbE7XLcc9Tyb4CGT
 4GrVx5awqItp1aMPz3e+ktVQnb/n3eLzJbeX2jZFC3Defcmsu4Dvuus02QtF2x1E2W0yqi8c
 OveXl7WK18T2/SOFCUpskqdqjkVPmlJ19mBU+ZtzLRJ7i+v+nH4mNt3m2o6r+44+sbjX/InZ
 Luu0wfHlng2FUqE6W7vOBTDJBBQrHcue+qzGkn1C1+ut2Ru/Kgawcq7Qk1NiKc5INNRiLipO
 BADOyIqU8QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7q6b+SSDQ68VLFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJ2vfrAWvA8ouL8ok7WBsYlLl2MnBwSAiYS
 n86cYeti5OIQEljKKPFw2nFmiISExO2FTYwQtrDEn2tdbCC2kMBzRoneafpdjBwcbAJaEo2d
 7CBhEYFcic8rf4DNYRY4wiTx99UKsDnCAqESaxvnMIHYLAKqEm3Tj7KC2LwClhLbH+yCmi8v
 MfPSd3aQmcwCmhLrd+lDlAhKnJz5hAXEZgYqad46m3kCI/8shKpZSKpmIalawMi8ilEktbQ4
 Nz232EivODG3uDQvXS85P3cTIzBatx37uWUH48pXH/UOMTJxMB5ilOBgVhLhZTGUThbiTUms
 rEotyo8vKs1JLT7EaAp09URmKdHkfGC6yCuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnN
 Tk0tSC2C6WPi4JRqYAoVuLGCZ7nWPcHz3WwPY/VCO1b6RWRMV5IVmm5aaqqj2PH2wbdjp+ZO
 OPc280TtKnvFIpGys6/5f6pfFp+66NNExTsGRsuWST/oZM6M8rz8Z1PK1cUnVTMS3z7561Bn
 8DQ+dGV8d6n+zx/Si+WOWGlbiO7SmZcz91hpbNrUCu7D+56yvCzda3M9K/aLO+OEhuS31Z0n
 169Pj/3knemzMrzjTdDSfxoRXMoi26bFeny48ObJ8cksRu/fNCjzmSVtei/2rvba5U1P3y3/
 slrV/shJ9/+ZJhw/+JeKHHylcr7Sf0dKytG7pp8OrLfacz1vl/G6VLtc+RXmr1NvsSyT3uF9
 wO7StOmNF5aeMnIQv+ipxFKckWioxVxUnAgAgBPjiF8DAAA=
X-CMS-MailID: 20220912082205eucas1p1e5fb1acfb0b2a2fe6261520ace90c883
X-Msg-Generator: CA
X-RootMTR: 20220912082205eucas1p1e5fb1acfb0b2a2fe6261520ace90c883
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082205eucas1p1e5fb1acfb0b2a2fe6261520ace90c883
References: <CGME20220912082205eucas1p1e5fb1acfb0b2a2fe6261520ace90c883@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v13 00/13] support zoned block devices with
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

The patch series is based on linux-next tag: next-20220823

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
 drivers/md/dm-po2zoned-target.c               | 280 ++++++++++++++++++
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
 20 files changed, 517 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zoned.rst
 create mode 100644 drivers/md/dm-po2zoned-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

