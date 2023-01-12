Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B971BC67871
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673535509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=/zvO4Mn27NRd05zRM+VlfjImIe/z+1+KVNtt0Y3cl6g=;
	b=L2mNPzVSuJc2ogTsInvQnoTWB0V5MaoOezaRYviteE+3nbKy0V+PYvVvNalWDlK9DrO6L9
	TbrzfU8G0U0dffUa7TytXugRF15YJkqzvHRkQNiaZJO8UM9FyL+T6dJ1KjTIjrBMpk62Aa
	H0yAO7NovhRttRJRE5qSidUoYRorv44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-MoVUrHexM9eeqJ4TN_IBrw-1; Thu, 12 Jan 2023 09:58:26 -0500
X-MC-Unique: MoVUrHexM9eeqJ4TN_IBrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C79F9101A52E;
	Thu, 12 Jan 2023 14:58:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B139DC15BA0;
	Thu, 12 Jan 2023 14:58:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 493951947053;
	Thu, 12 Jan 2023 14:58:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 773231946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 13:37:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10D224078904; Thu, 12 Jan 2023 13:37:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0923A4078903
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD1BC85C6EA
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:07 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-sKGQE5vAOd-WIypUPwfA4w-1; Thu, 12 Jan 2023 08:37:06 -0500
X-MC-Unique: sKGQE5vAOd-WIypUPwfA4w-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230112133703epoutp010cd41e914bd495ddf80a8591bd6f5113~5kzw8iL7Z1983419834epoutp017
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230112133703epoutp010cd41e914bd495ddf80a8591bd6f5113~5kzw8iL7Z1983419834epoutp017
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230112133702epcas5p477b3e6fb8d168ff430c4caef47563981~5kzwJKFZW1179511795epcas5p41;
 Thu, 12 Jan 2023 13:37:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4Nt5F86Y3Gz4x9Pt; Thu, 12 Jan
 2023 13:37:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 80.D4.02301.CFC00C36; Thu, 12 Jan 2023 22:37:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230112115954epcas5p4a959bef952926b8976719f1179bb4436~5je8PVHxa1997319973epcas5p4J;
 Thu, 12 Jan 2023 11:59:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230112115954epsmtrp152f30b7df859064e2bec0ca3a6c8a57e~5je8OV1ZL2220922209epsmtrp1w;
 Thu, 12 Jan 2023 11:59:54 +0000 (GMT)
X-AuditID: b6c32a49-473fd700000108fd-07-63c00cfc1b69
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 2D.13.10542.A36FFB36; Thu, 12 Jan 2023 20:59:54 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230112115951epsmtip238e47c6957ed82e8528fd357d0332494~5je5ksTYN0887908879epsmtip2C;
 Thu, 12 Jan 2023 11:59:51 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Date: Thu, 12 Jan 2023 17:28:54 +0530
Message-Id: <20230112115908.23662-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzevbe9XBhll4fjwLLZFKdSnkUoB0I3Fh27bCYjgThjdHBX7iih
 tLW3yB4kwADHyLDyzCjDogHlNVAEVwqFBmEiyNjC6HwAzgSXwUREWNwQZa0XNv/7zvf7vvP9
 fudBYB53cF8iXaVjtCpaKcJdeJcu+4uD1l2t8tAJQyjsGP0Bg1+cfILB1hk9Di33a/nwhrUH
 hc2twyjsPb2MwuGNRRyWD9oQeHfKgELLzQDYZ7nKg5Pmb3FoPHvXCZrm8hF46bERgyuNhU6w
 /c8lHhy5+QqceHKFH+tFGW6P41SPYcaJmpi9wKMmx7OozpavcOpiQy7VeyMPp0oL7uPUUv8U
 Tp3oakGolc7XqM65RTTB9VBGjIKhUxmtkFHJ1anpqjSZ6L3E5L3JEdJQSZAkCkaKhCo6k5GJ
 9u1PCIpLV9rHFAmP0cosO5VAs6wo5I0YrTpLxwgValYnEzGaVKUmXBPM0plsliotWMXooiWh
 oWERdmFKhmKtpB/TNMFPni5b8DzEJi5BnAlAhgPbuplfgrgQHmQvAm7Z1nBu8RABZ6aHeA6V
 B7mCgKbxD7YcrUMPUY43IyC/MpczFKDg6+rTdjdB4GQAGNsgHBovchoFPWN+Dg1G1qJgZPEO
 31HwJKXgensd4tDzyNfB0/53HbSAjAaVjZdRBw3IEKC/7c7R7uBqzdyzdjByOyjorsUcWwJy
 lQANxwtRrrd9IG9wncdhT7BwpcuJw75gXn98E2eD5somnDMXIsDwqwHhCm+ColE95gjGSH/Q
 YQ7h6FdB1Wg7ygW7gdLHc5tZAmA6tYX9QFtHPc5hH2B7lL+JKdD1t2XzDI8AY/kEehLZbnhu
 HsNz8xj+T65HsBbEh9GwmWkMG6GRqJjs/65Vrs7sRJ69dXG8CZn57UHwIIISyCACCEzkJegb
 HpB7CFLpTz9jtOpkbZaSYQeRCPsRl2G+2+Rq+2dR6ZIl4VGh4VKpNDxqj1Qi8hYw3Ua5B5lG
 65gMhtEw2i0fSjj75qHFhwfOj5xZswZFzfY5L/ktR1eEESsHjFikbPKFwO+6I9/fHXMgLPej
 Hjqpyv3LyZ0yYz1/9i9X8PKETVX+zlkZNVxXuhCRKxFnTiW9mCi/vvOn5tWaY4lvfT7/oYtz
 9VB/vBiZr/2xuE3mfa1CIQz8/TCvPcbNWrWj4WcrlAw0xzb6FX38aJdCr2qbC0gI+SNHkp+z
 3xLrcvAQWRw8nMKfbuGV7dmbgOmvte52M/uc+6f6FkrO58SdulC2JryXRMftqgl8O837XHzG
 aky7yXpwh9f3Y2T2dF1U0VFPf4vpF5maufigYXrmiDZlSn9ec3SDdd8WWV7Bwm8EweaXTMqF
 eyIeq6AlYkzL0v8CTBj6s3QEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGe885nh0t7WwKvWZljsSaaGVRL9r1g3YShKAgs8JOdpjXZTvZ
 RdKmVtDoZhejqZmiopspecvlrTZdXlADc5jl7DK7EOp0aqipsSzq2/P/Pb/n05/CRXnEcipK
 dpqTy9hYMelAVOvF7j7+k40RGy5rhKiszYCj1FuzONL03yRR/XCmHXrzXIuhYk0zhmpzRzHU
 PD9Eots6I0CDPSoM1fd5o7r6VgJ1P8siUU7hoADVmFMAqp7JwZG14JIAlX4fIVBLnxvqmn1p
 t8uFUQ10kIxW1S9gukxPCKa7I4EpV18lmYr8i0ztGwXJXE8bJpmRhh6SuVGpBoy1fBVTbh7C
 9i0Jc9h2gouNOsPJ1+845hA5rWzA44vQubnRelIBjBIlsKcgvRlqmsYwWxbRNQB+z/rDXWHh
 bBO+kJ1h8dwXwYKTgkFFmrsSUBRJe8P2eUoJHCgX+jMGO0wfcduB0wUYfNSQYmcbONNbYG9p
 NrANCNoTzjUE27Aj7Q/vFugxG4b0enhzQLiAhbD1gZmwYZz2gmUPRTaM0+4wrSoTvwWWqv6z
 VP8s1X/WI4CrgSsXz8dJ4/iN8X4y7qwvz8bxCTKpb8TJuHLw+40SSQ2oU1t8dQCjgA5AChe7
 ONY1N0aIHE+w5xM5+clweUIsx+uAG0WIlzm+UraGi2gpe5qL4bh4Tv63xSj75QrMqTvp+Bcm
 dzxwW4ulrJ85MNX0NHrl+XtVXH90bWVCXxhrd+cbV9pS7dOmlQW9DP5h6NK3n4quNN7PTYd+
 ewfqGhMXG6fmAvKW5E/oh/UjJV690VHBJrBmxcTY4Hzy47zUtp4Qf4V1tW9I+Lqtk++kq5Or
 DAF72Ws6z6IjmPJVznhSZJFA6pSVLr6U4ZlksHYepl+YPNjXQaIKHdgum8n+9ulTqN/uoAwP
 89eSC5ZFA28tK/dT2UeleFvQjVrxUu3BwMRN4KdlWnZF9/6Ot/OH3q1kqLopm/e0eryPMaWe
 6SPxtQWxO6u6ditahj6j+3lervnSPcJDk2YrH9ZZLSb4SHajBJfz7C82n+OzNQMAAA==
X-CMS-MailID: 20230112115954epcas5p4a959bef952926b8976719f1179bb4436
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112115954epcas5p4a959bef952926b8976719f1179bb4436
References: <CGME20230112115954epcas5p4a959bef952926b8976719f1179bb4436@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 12 Jan 2023 14:58:20 +0000
Subject: [dm-devel] [PATCH v6 0/9] Implement copy offload support
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch series covers the points discussed in November 2021 virtual
call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
We have covered the initial agreed requirements in this patchset and
further additional features suggested by community.
Patchset borrows Mikulas's token based approach for 2 bdev
implementation.

This is on top of our previous patchset v5[1].

Overall series supports:
========================
	1. Driver
		- NVMe Copy command (single NS, TP 4065), including support
		in nvme-target (for block and file backend).

	2. Block layer
		- Block-generic copy (REQ_COPY flag), with interface
		accommodating two block-devs, and multi-source/destination
		interface
		- Emulation, when offload is natively absent
		- dm-linear support (for cases not requiring split)

	3. User-interface
		- new ioctl

	4. In-kernel user
		- dm-kcopyd

Testing
=======
	Copy offload can be tested on:
	a. QEMU: NVME simple copy (TP 4065). By setting nvme-ns
		parameters mssrl,mcl, msrc. For more info [2].
	b. Fabrics loopback.
	c. blktests[3] (tests block/032,033, nvme/046,047,048,049)

	Emuation can be tested on any device.

	Sample application to use IOCTL is present in patch desciption.
	fio[4].

Performance
===========
	With the async design of copy-emulation/offload using fio[4],
	we were  able to see the following improvements as
	compared to userspace read and write on a NVMeOF TCP setup:
	Setup1: Network Speed: 1000Mb/s
		Host PC: Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
		Target PC: AMD Ryzen 9 5900X 12-Core Processor
		block size 8k, range 1:
			635% improvement in IO BW (107 MiB/s to 787 MiB/s).
			Network utilisation drops from  97% to 14%.
		block-size 2M, range 16:
			2555% improvement in IO BW (100 MiB/s to 2655 MiB/s).
			Network utilisation drops from 89% to 0.62%.
	Setup2: Network Speed: 100Gb/s
		Server: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz, 72 cores
			(host and target have the same configuration)
		block-size 8k, range 1:
			6.5% improvement in IO BW (791 MiB/s to 843 MiB/s).
			Network utilisation drops from  6.75% to 0.14%.
		block-size 2M, range 16:
			15% improvement in IO BW (1027 MiB/s to 1183 MiB/s).
			Network utilisation drops from 8.42% to ~0%.
		block-size 8k, 8 ranges:
			18% drop in IO BW (from 798 MiB/s to 647 MiB/s)
			Network utilisation drops from 6.66% to 0.13%.

		At present we see drop in performance for bs 8k,16k and
		higher ranges (8, 16), so something more to check there.
	Overall, in these tests, kernel copy emulation performs better than
	userspace read+write. 

Blktests[3]
======================
	tests/block/032,033: Runs copy offload and emulation on block device.
        tests/nvme/046,047,048,049 Create a loop backed fabrics device and
        run copy offload and emulation.

Future Work
===========
        - nullblk: copy-offload emulation.
	- generic copy file range (CFR):
		We explored the possibility of using block device
		def_blk_ops, but we saw a major disadvantage for in-kernel
		users. fd is not available for in-kernel user [5].
	- loopback device copy offload support
	- upstream fio to use copy offload

	These are to be taken up after we reach consensus on the
	plumbing of current elements that are part of this series.


Additional links:
=================
	[0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
	[1] https://lore.kernel.org/lkml/20221130041450.GA17533@test-zns/T/
	[2] https://qemu-project.gitlab.io/qemu/system/devices/nvme.html#simple-copy
	[3] https://github.com/nitesh-shetty/blktests/tree/feat/copy_offload/v6
	[4] https://github.com/vincentkfu/fio/tree/copyoffload
	[5] https://lore.kernel.org/lkml/20221130041450.GA17533@test-zns/T/#m0e2754202fc2223e937c8e7ba3cf7336a93f97a3

Changes since v5:
=================
	- Addition of blktests (Chaitanya Kulkarni)
        - Minor fix for fabrics file backed path
        - Remove buggy zonefs copy file range implementation.

Changes since v4:
=================
	- make the offload and emulation design asynchronous (Hannes
	  Reinecke)
	- fabrics loopback support
	- sysfs naming improvements (Damien Le Moal)
	- use kfree() instead of kvfree() in cio_await_completion
	  (Damien Le Moal)
	- use ranges instead of rlist to represent range_entry (Damien
	  Le Moal)
	- change argument ordering in blk_copy_offload suggested (Damien
	  Le Moal)
	- removed multiple copy limit and merged into only one limit
	  (Damien Le Moal)
	- wrap overly long lines (Damien Le Moal)
	- other naming improvements and cleanups (Damien Le Moal)
	- correctly format the code example in description (Damien Le
	  Moal)
	- mark blk_copy_offload as static (kernel test robot)
	
Changes since v3:
=================
	- added copy_file_range support for zonefs
	- added documentation about new sysfs entries
	- incorporated review comments on v3
	- minor fixes

Changes since v2:
=================
	- fixed possible race condition reported by Damien Le Moal
	- new sysfs controls as suggested by Damien Le Moal
	- fixed possible memory leak reported by Dan Carpenter, lkp
	- minor fixes

Nitesh Shetty (9):
  block: Introduce queue limits for copy-offload support
  block: Add copy offload support infrastructure
  block: add emulation for copy
  block: Introduce a new ioctl for copy
  nvme: add copy offload support
  nvmet: add copy command support for bdev and file ns
  dm: Add support for copy offload.
  dm: Enable copy offload for dm-linear target
  dm kcopyd: use copy offload support

 Documentation/ABI/stable/sysfs-block |  36 ++
 block/blk-lib.c                      | 597 +++++++++++++++++++++++++++
 block/blk-map.c                      |   4 +-
 block/blk-settings.c                 |  24 ++
 block/blk-sysfs.c                    |  64 +++
 block/blk.h                          |   2 +
 block/ioctl.c                        |  36 ++
 drivers/md/dm-kcopyd.c               |  56 ++-
 drivers/md/dm-linear.c               |   1 +
 drivers/md/dm-table.c                |  42 ++
 drivers/md/dm.c                      |   7 +
 drivers/nvme/host/constants.c        |   1 +
 drivers/nvme/host/core.c             | 106 ++++-
 drivers/nvme/host/fc.c               |   5 +
 drivers/nvme/host/nvme.h             |   7 +
 drivers/nvme/host/pci.c              |  27 +-
 drivers/nvme/host/rdma.c             |   7 +
 drivers/nvme/host/tcp.c              |  16 +
 drivers/nvme/host/trace.c            |  19 +
 drivers/nvme/target/admin-cmd.c      |   9 +-
 drivers/nvme/target/io-cmd-bdev.c    |  79 ++++
 drivers/nvme/target/io-cmd-file.c    |  52 +++
 drivers/nvme/target/loop.c           |   6 +
 drivers/nvme/target/nvmet.h          |   2 +
 include/linux/blk_types.h            |  44 ++
 include/linux/blkdev.h               |  18 +
 include/linux/device-mapper.h        |   5 +
 include/linux/nvme.h                 |  43 +-
 include/uapi/linux/fs.h              |  27 ++
 29 files changed, 1324 insertions(+), 18 deletions(-)


base-commit: 469a89fd3bb73bb2eea628da2b3e0f695f80b7ce
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

