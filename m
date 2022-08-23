Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A58C32793
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257159;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=5Iu9+QH9ztCM4492tXe1FOZYdYDNqgm/JNaSr+9UxYc=;
	b=VV2YiKOZS3JjZSu3gPFcKfmkg9/uFLNwyqKv017FfI22oRD+xD7QTu2FSI90x50Z6sw/5a
	nFXoaHV/t6qgzVGpt8NM3iFuG4cSiJ9vgftARy3PEao+OyiN98qKSBs5DSZe6weBkWpqkF
	jNEdlmUhFdAxZ2Y+qKdA4H2J1BP/AwA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-RMjzDS25OVqKM0czjpvrQw-1; Tue, 23 Aug 2022 08:19:15 -0400
X-MC-Unique: RMjzDS25OVqKM0czjpvrQw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27433802532;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79D3C492C3B;
	Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14EF51946A52;
	Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB4391946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56CF71121319; Tue, 23 Aug 2022 12:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52BDF1121315
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3485C801585
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:07 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-IhtM7isJPOyOsgZ3iUGq6A-1; Tue, 23 Aug 2022 08:19:05 -0400
X-MC-Unique: IhtM7isJPOyOsgZ3iUGq6A-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121904euoutp01636d289ec5c9cf10077d14b395bca998~N_JIs_Wi81598415984euoutp01d
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121904euoutp01636d289ec5c9cf10077d14b395bca998~N_JIs_Wi81598415984euoutp01d
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220823121901eucas1p19e31f872a7c222fdf6ee995d29270f45~N_JGghk5b1886418864eucas1p1E;
 Tue, 23 Aug 2022 12:19:01 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 84.71.07817.5B5C4036; Tue, 23
 Aug 2022 13:19:01 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121901eucas1p1d8ec2e0d3d6be63b9d4338f70dd717fe~N_JFwFbZ31175311753eucas1p1A;
 Tue, 23 Aug 2022 12:19:01 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121901eusmtrp290a9a2dda6cb94226718ce8de23cdce0~N_JFvHqbT2723427234eusmtrp2W;
 Tue, 23 Aug 2022 12:19:01 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-48-6304c5b5a530
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 9F.02.07473.4B5C4036; Tue, 23
 Aug 2022 13:19:00 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121900eusmtip2dcdb76fd8320f34e3ccc35811cfc2134~N_JFa_4xm2209522095eusmtip22;
 Tue, 23 Aug 2022 12:19:00 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:46 +0200
Message-Id: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djPc7pbj7IkG0x4ZWix/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGVcXV5SMC+0
 4vmTDqYGxtWOXYycHBICJhJX9sxi7GLk4hASWMEo8W/RNVYI5wujRO+kH1CZz4wSz4+fYOti
 5ABraVwJFV/OKHHtdhdUxwtGiQUnNzGDFLEJaEk0drKDrBARSJf4+nUDWAOzwDYmiV93L7GA
 1AgLhEvMXF4HUsMioCpx/Vk/G4jNK2AlcXvLTmaI8+QlZl76zg4RF5Q4OfMJC4jNDBRv3jqb
 GWSmhMByTonOuQ9ZIRpcJN5s3M4CYQtLvDq+hR3ClpH4v3M+E4RdLfH0xm+o5hZGif6d66E+
 s5boO5MDYjILaEqs36UPUe4oceZ2BytEBZ/EjbeCECfwSUzaNp0ZIswr0dEmBFGtJLHz5xOo
 pRISl5vmQB3jIXH2+DSwKUICsRI7HptOYFSYheSvWUj+moVwwgJG5lWM4qmlxbnpqcVGeanl
 esWJucWleel6yfm5mxiBCfD0v+NfdjAuf/VR7xAjEwfjIUYJDmYlEd7qiwzJQrwpiZVVqUX5
 8UWlOanFhxilOViUxHmTMzckCgmkJ5akZqemFqQWwWSZODilGphWC6zXnOqTfFfxRGJu45me
 wmvCzZ+aCq9fMZ7/zSA8ZOUer535r559FitOXMC6beqXFufvl5ZfKnr9z9jXdLoqg72Km3/S
 w0e3pzi2ZKS07nqeWs1wN0Je4eMCN86Oa3sjD7CmW3y2q5myieFq2KQd5f17ZeWr70jd6t29
 bvvs4Gibsz+Mtu/fq7xzx/edn1iUksVmvrb16/JMYtB/ZWcgMOO5ik2NRXRW5YdFKys8z1k1
 8db+mDb/pKTOY17nE+9r7svKHmKPVo4oFLx475LOZpeGmC+1jiXeBzcflWLUYfh8av+bGf4f
 KqULv0QfTyny//LHqPi2/OGQZg7FmD6nOQuYyqOXri7fp/WobJISS3FGoqEWc1FxIgDjfnKX
 7wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xe7pbj7IkG2wwslh/6hizxeq7/WwW
 0z78ZLb4ffY8s8Xed7NZLW4e2MlksWfRJCaLlauPMlk8WT+L2eJv1z0mi723tC0u75rDZjF/
 2VN2iwltX5ktPi9tYbdYc/Mpi8WJW9IOgh6Xr3h77Jx1l93j8tlSj02rOtk8Ni+p99h9s4HN
 Y2frfVaP9/uusnn0bVnF6LH5dLXH501yHu0HupkCeKL0bIryS0tSFTLyi0tslaINLYz0DC0t
 9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mq4uLymYF1rx/EkHUwPjascuRg4OCQETicaV
 jF2MXBxCAksZJf49eQDkcALFJSRuL2yCsoUl/lzrYoMoesYosWXbS3aQZjYBLYnGTnaQGhGB
 XInDmycwgdQwCxxhkljduJYVJCEsECpx5Pp0FhCbRUBV4vqzfjYQm1fASuL2lp3MEAvkJWZe
 +g42k1lAU2L9Ln2IEkGJkzOfgLUyA5U0b53NPIGRfxZC1SwkVbOQVC1gZF7FKJJaWpybnlts
 qFecmFtcmpeul5yfu4kRGKnbjv3cvINx3quPeocYmTgYDzFKcDArifBWX2RIFuJNSaysSi3K
 jy8qzUktPsRoCnT1RGYp0eR8YKrIK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1I
 LYLpY+LglGpg6j7Ba9KU2rjAjOkL1wGeNfOqH8Rwb2iSyc7zZNUzlEz+un+6bHD7zCcvleOU
 TB5cbFSRnaX2P/KSkX/moqNLdm1YfejlmaOXlt9bw1J+49zxlWJJz3QKz/54avnzaV/6yz2F
 jPuUHgiez5WwDOjwvmXW+u33n5n65fMzn2zsmVOWn7rl5X7fRyJKl1hOPuF79YI9ed+HX9Pc
 d15+xbarYcVOtodf5O8/d3jd+dluOdu9O0tlb803eviboUNsuWK0+IaLGoxTA88WnN7fyL5i
 K7fFeXPuRqFSt+o783xv794VffjZgT3LF12UdmG9ycmwxKHNpN/GPOGwb8yRzGeN8vznlVbp
 cjyYmrHQw1XF7o8SS3FGoqEWc1FxIgBqnq2HXQMAAA==
X-CMS-MailID: 20220823121901eucas1p1d8ec2e0d3d6be63b9d4338f70dd717fe
X-Msg-Generator: CA
X-RootMTR: 20220823121901eucas1p1d8ec2e0d3d6be63b9d4338f70dd717fe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121901eucas1p1d8ec2e0d3d6be63b9d4338f70dd717fe
References: <CGME20220823121901eucas1p1d8ec2e0d3d6be63b9d4338f70dd717fe@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v12 00/13] support zoned block devices with
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
layer and a new **dm target** is added: dm-po2z-target. This new
target will be initially used for filesystems such as btrfs and
f2fs until native npo2 zone support is added.

- Patchset description:
Patches 1-3 deals with removing the po2 constraint from the
block layer.

Patches 4-5 deals with removing the constraint from nvme zns.

Patch 5 removes the po2 contraint in null blk

Patch 6 adds npo2 support to zonefs

Patches 7-13 adds support for npo2 zoned devices in the DM layer and
adds a new target dm-po2z-target which converts a zoned device with npo2
zone size into a zoned target with po2 zone size.

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

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (12):
  block: make bdev_nr_zones and disk_zone_no generic for npo2 zone size
  block:rearrange bdev_{is_zoned,zone_sectors,get_queue} helpers in
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
  dm: introduce DM_EMULATED_ZONES target type
  dm: add power-of-2 target for zoned devices with non power-of-2 zone
    sizes

 .../admin-guide/device-mapper/dm-po2zone.rst  |  71 +++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 block/blk-core.c                              |   2 +-
 block/blk-zoned.c                             |  37 ++-
 drivers/block/null_blk/main.c                 |   5 +-
 drivers/block/null_blk/null_blk.h             |   1 +
 drivers/block/null_blk/zoned.c                |  18 +-
 drivers/md/Kconfig                            |  10 +
 drivers/md/Makefile                           |   2 +
 drivers/md/dm-po2zone-target.c                | 260 ++++++++++++++++++
 drivers/md/dm-table.c                         |  20 +-
 drivers/md/dm-zone.c                          |   8 +-
 drivers/md/dm-zoned-target.c                  |   8 +
 drivers/md/dm.c                               |   8 +-
 drivers/nvme/host/zns.c                       |  14 +-
 drivers/nvme/target/zns.c                     |   3 +-
 fs/zonefs/super.c                             |   6 +-
 fs/zonefs/zonefs.h                            |   1 -
 include/linux/blkdev.h                        |  80 ++++--
 include/linux/device-mapper.h                 |   9 +
 20 files changed, 489 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zone.rst
 create mode 100644 drivers/md/dm-po2zone-target.c

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

