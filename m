Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6523C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665092;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=C+40/bb61P7mfrerZQhF1VJvt8zuOkEUGvw/t1S/CbM=;
	b=CzoRkZwIlhe2O5LyH/VMp1PKhnpVLXxlal98P/lA31k9FX9YBTEvGdarLIvKd5jSxoPv24
	eaoMHN/J7dUHvYZ/Ws47EXeSwYjs2Pi2LIlCHxkYZljJeLquOrmMU0PJRCaZgj2UTFy/kA
	29wZcCo5Toqr13QobMV4nDLs5Uveo4c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-9W8kjp1uMEm2PpTSDrQeeA-1; Tue, 20 Sep 2022 05:11:29 -0400
X-MC-Unique: 9W8kjp1uMEm2PpTSDrQeeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07BBC299E753;
	Tue, 20 Sep 2022 09:11:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E835640C206B;
	Tue, 20 Sep 2022 09:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7727A1946A44;
	Tue, 20 Sep 2022 09:11:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D82BA19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5A37492B2D; Tue, 20 Sep 2022 09:11:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADC00492B2C
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF21101CC67
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:25 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-EfPz3OSBNwmEz-YNxiz1DQ-1; Tue, 20 Sep 2022 05:11:23 -0400
X-MC-Unique: EfPz3OSBNwmEz-YNxiz1DQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091122euoutp02e69ca41b4be1ca02a63b66906199f0b7~WhpQKKTtI2726327263euoutp02z
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091122euoutp02e69ca41b4be1ca02a63b66906199f0b7~WhpQKKTtI2726327263euoutp02z
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220920091120eucas1p11dffb27c44a8fbfe48f24eab63e46553~WhpOVymD32913329133eucas1p1k;
 Tue, 20 Sep 2022 09:11:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id E3.7E.07817.8B389236; Tue, 20
 Sep 2022 10:11:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc~WhpNzRUiF1326413264eucas1p2E;
 Tue, 20 Sep 2022 09:11:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091120eusmtrp11d079d4ec14c363dbc6b4c4bc89be3e5~WhpNyUClc0149701497eusmtrp1Y;
 Tue, 20 Sep 2022 09:11:20 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-0a-632983b81a01
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 8B.43.10862.8B389236; Tue, 20
 Sep 2022 10:11:20 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091119eusmtip2affa7e4fb0b83dd7e244c3a24aed8d8f~WhpNbdwPE3041630416eusmtip2y;
 Tue, 20 Sep 2022 09:11:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:06 +0200
Message-Id: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djP87o7mjWTDf7N1LBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJ2HJjGWrAs
 qqJlVgd7A+Ne1y5GTg4JAROJ9/3NrF2MXBxCAisYJR7uXsYM4XxhlLizbwNU5jOjxOTtDxlh
 WtbOPARVtZxRYs70g1DOS0aJ7jtngao4ONgEtCQaO9lBGkQE0iW+ft3ACFLDLLCNSWL6lEXM
 IDXCAuESCz/ZgdSwCKhKLFo+jQXE5hWwkrg6YRsTxDJ5iZmXvrNDxAUlTs58AlbDDBRv3job
 bK+EwGJOifVzz0E1uEjc3f2dDcIWlnh1fAs7hC0jcXpyDwuEXS3x9MZvqOYWRon+nevZQA6S
 ELCW6DuTA2IyC2hKrN+lD1HuKPHw7RJmiAo+iRtvBSFO4JOYtG06VJhXoqNNCKJaSWLnzydQ
 SyUkLjfNYYEo8ZCYNi8WJCwkECvxdudGpgmMCrOQ/DULyV+zEE5YwMi8ilE8tbQ4Nz212Cgv
 tVyvODG3uDQvXS85P3cTIzAJnv53/MsOxuWvPuodYmTiYDzEKMHBrCTC2+KvmSzEm5JYWZVa
 lB9fVJqTWnyIUZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qByX53kHSLwruLC0r8hGZd
 ff39546EDaK6tQsOsQvMYFi44979DG9LQ/YjEayiijsD1Tuib05P/bFDvJRxg2bgPgcLsWWS
 5puWBFz17FrxVqxGv9Kz7IvI2ZAnXeJSPAX3GQ7/ZlLQ+cHy/tgypbgjm6fyOO2Q6jv349Rb
 03Nhem9CRNqnxO7yDzN/yP7T4YDBj7NTZj6/8vFkbfcuc6/CG2HRu5Y5y1tzZDme22HVp9h4
 5pn4k6nTT9gK/vXf0tS6e23eQq1zvyKfpFcozdY9by98c+oq9hXVeRv3uOXF/jR91bV8ZZnR
 xccHAjUm73nWsCI5pltQ6Cz7nf1iRSnMZqfu2TXN81imwc4+SVdqohJLcUaioRZzUXEiAK2m
 SZ3xAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7o7mjWTDea/YLVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJ2HJjGWrAsqqJlVgd7A+Ne1y5GTg4JAROJ
 tTMPMXcxcnEICSxllNh34hULREJC4vbCJkYIW1jiz7UuNoii54wSfecus3cxcnCwCWhJNHay
 g9SICORKHN48gQnEZhY4wiSxeGoMiC0sECoxZ917sJksAqoSi5ZPA7N5Bawkrk7YxgQxX15i
 5qXvYCOZBTQl1u/ShygRlDg58wkLxEh5ieats5knMPLPQqiahaRqFpKqBYzMqxhFUkuLc9Nz
 i430ihNzi0vz0vWS83M3MQKjdduxn1t2MK589VHvECMTB+MhRgkOZiUR3hZ/zWQh3pTEyqrU
 ovz4otKc1OJDjKZAV09klhJNzgemi7ySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU7NTU
 gtQimD4mDk6pBqZq1gqjC/Mzvp0+JMvZ9Xp25t9Yx2Uca6S97W/1/Py/pnOGzh3uy7fEi0R8
 /9eobJeVSrKbpnBb1161bPojFhVuDtuDt9aFTzv+cXINc3b9FzvLrs6a56WsS2ZM/L1+so/C
 k5vvD1Un5bDqzk/ZsKdYbudWtv7AX85n8rLcJ0wwOZJRlViZ4F/BrNbkKipt/in5TcI8b/XK
 48vkZn7M2Vv3+orXgnrHvYmn+r+9yX51dfXZMiXZzZ9v5WkLnQ63zmvQ2dY3q7/3QKCpULO6
 T4poNb/y0flvn83tYX/sfp7jRqlole3nqoeBHh5PKl2yN05YxBqg/i8ukp0/tI1TfkrN9dvx
 X1uSGP5PP/zDUYmlOCPRUIu5qDgRAEo6oypfAwAA
X-CMS-MailID: 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc
X-Msg-Generator: CA
X-RootMTR: 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v14 00/13] support zoned block devices with
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

The patch series is based on linux-next tag: next-20220919

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
 drivers/md/dm-po2zoned-target.c               | 291 ++++++++++++++++++
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
 20 files changed, 528 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zoned.rst
 create mode 100644 drivers/md/dm-po2zoned-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

