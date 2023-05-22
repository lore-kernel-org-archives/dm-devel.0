Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DE4C7EE2D
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772976;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=YLVLnjl9wGsOG9UazGZmOVOuz/M/V9w88OAIThCCI7Y=;
	b=HsLohg05cysC7IUkhT6airL7AUfHrOKuZW+RnJ8tZtBOAjNRNtfXZfwoNi9GVcRd3xgfnk
	zuaJ4J4IBA+nB8L0p4wyvL5wiGk+emFQEtO5dG6KJ8RSQQ2rQntfLnob1Kju2VQWNQwKms
	cQAdLwmwqAsFxc9iMk/nI3SNxsB20RY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-bzOurxO9Ml-CNHGatqkwAw-1; Mon, 22 May 2023 12:29:33 -0400
X-MC-Unique: bzOurxO9Ml-CNHGatqkwAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F5811C01711;
	Mon, 22 May 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A1262166B27;
	Mon, 22 May 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D359819452C2;
	Mon, 22 May 2023 16:29:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10A83194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 11:10:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC40D4F2DCF; Mon, 22 May 2023 11:10:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A412F482060
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95C4438288A2
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:32 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-Hh0pKjRzOauN65ZH6SFCUQ-1; Mon, 22 May 2023 07:10:30 -0400
X-MC-Unique: Hh0pKjRzOauN65ZH6SFCUQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230522111025epoutp04e37c2a36e4dfd93aa423537478bd26b6~hcq2Ltuwb1725517255epoutp04T
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230522111025epoutp04e37c2a36e4dfd93aa423537478bd26b6~hcq2Ltuwb1725517255epoutp04T
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230522111024epcas5p1199f6f4f54362b84bbd9e62231956513~hcq1T4XHe1726517265epcas5p1H;
 Mon, 22 May 2023 11:10:24 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4QPvqz23BZz4x9Pw; Mon, 22 May
 2023 11:10:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 9F.C2.54880.F9D4B646; Mon, 22 May 2023 20:10:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230522104508epcas5p13f99359d0af12453e0e4bc7f4bae23f0~hcUxcpHpJ0977609776epcas5p1E;
 Mon, 22 May 2023 10:45:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230522104508epsmtrp16cf50ac26ffdcc7022620c8b270c3f12~hcUxbeFRs1351813518epsmtrp16;
 Mon, 22 May 2023 10:45:08 +0000 (GMT)
X-AuditID: b6c32a49-8c5ff7000001d660-71-646b4d9f09d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4F.03.27706.4B74B646; Mon, 22 May 2023 19:45:08 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104504epsmtip24fa7fb0cc5cb3140420cc7775b49c43d~hcUtg_bfp1645716457epsmtip2l;
 Mon, 22 May 2023 10:45:04 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2023 16:11:31 +0530
Message-Id: <20230522104146.2856-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTZxjGcy49LbDOI6B+sKlYZxZxBbq19cNwWaKbx6ELbDNL3Awe6Rkg
 0DY9LSDbtFhxiBegXKIFxSFDuUTu1wJOEAoYYBkFFEHUQYwyBDEoQhijHN387/c+eZ/vvXx5
 BZhjHt9VEK7UMholHSki7PHqls3u4pw9EQovUzoflnS2YTC7pJiAx1IWMFg0nEzA8ZZpBGZO
 vcLg/ev+sPFpFg/e+b0OhQ25RhQWFLWisCxZAM2/PkNh6+IEAY3N/Qgc6zOhsHFwC2xo7MBh
 b302Ae8VL/JgTv4YH54aqCXgFcs/KGxOM6CwdjQegdXzORi8Nj6Jw/bB92DPgoUH52eziU/X
 Ub3WAMo00kVQdaZhPtVzrwynMo2dBFVx1Z3q7dJR5YUnCap82sin2s/N41RF3lHKfEdPUGcM
 Twnq2dggTk029RHU2cpCJNBpX4RPGEMrGI0bowxRKcKVob6igK+DtwfL5F4SscQbbhW5Keko
 xle0Y3eg+PPwyKVNidyi6UjdkhRIs6zI089Ho9JpGbcwFav1FTFqRaRaqvZg6ShWpwz1UDLa
 bRIvr49lS4kHIsKSbq1T11CxlXfncD2yIE1CBAJASsFMsSwJsRc4kmYEPJyoQLlgGgHdIzUE
 F7xAwC+ND7AkxG7ZkVv6aJkdyUYEjPd9zyUloOBC10u+7VmC3AJuLQpsujM5ioGJ+r8xW4CR
 Fgyk5Hcsu53IreDi8RqejXFyE3icMYjazELSG/w1IOfa8wTJIyttGUJyJeg4P4rbGCPXA0NV
 1vKTgOy3A63WdoRrbgfoGL2Lc+wEnlgq+Ry7gsfJJ15zDChIv0pw5uMIMA2YXpv9QUJnMmYr
 jJGbQUm9JyevBRmd11Cu8LvgzPwoyulCUHvxDW8ExSWXCI5dQP/L+NdMgZOXHyDcsvaD3ybm
 eCnIetNb85jemsf0f+VLCFaIuDBqNiqUYWVqiZKJ+e9bQ1RR5cjyubjvqkWG7095NCOoAGlG
 gAATOQuDzoYoHIUK+nAco1EFa3SRDNuMyJZWnIq5rgpRLd2bUhsskXp7SeVyudT7E7lEtEb4
 oW9HiCMZSmuZCIZRM5o3PlRg56pHI/wMzu/LTMSKuJ1H51ItxwxtZQ4OFxKxRfuwVy34asXB
 +KANeqcV1vltXl35t+vSjfYRaZPpZVV7N6bVjjm4zvpIu+lVvdlGP3vKcqRJXJQ1s+b2TOHu
 gFynh5Im9VrtTlU27Z1CfYTBPZ1t1w+ajQPDn51gb1qjZWzySPEXQ1/+EfXd/vryXm/xkV1t
 h3L9o7e7KRaq+1tLnae6bv7Zvc/Fwfp86NsriT/+HCfx33AotzizQUj2YPrL+GzGkD72p6Ce
 /hEpan2em5dSmnlDrDv9TXjkoxslq3+oUpyaEZoPG2IW2WyeOSFRH/JiU/Rp9/Mf1LzzJHW4
 oOyrvWbluQOxIpwNoyXumIal/wVO/v8DtwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsWy7bCSvO4W9+wUg6bNXBbrTx1jtpizfg2b
 RdOEv8wWq+/2s1m8PvyJ0WLah5/MFg/221vsfTeb1eLmgZ1MFnsWTWKyWLn6KJPFxn4Oi90L
 PzJZHP3/ls1i0qFrjBZPr85isth7S9tiz96TLBaXd81hs7i35j+rxfxlT9ktuq/vYLNYfvwf
 k8Whyc1MFjueNDJabPs9n9li3ev3LBYnbklbnP97nNXi9485bA5yHpeveHvMun+WzWPnrLvs
 HufvbWTxmDbpFJvH5hVaHpfPlnpsWtXJ5rHp0yR2jxMzfrN4bF5S77H7ZgObR2/zOzaPj09v
 sXi833eVzaNvyyrGAOEoLpuU1JzMstQifbsEroyu03IF2z0qttz+xdLA+Neki5GTQ0LARGLR
 hufMXYxcHEICuxklziz+ywaRkJRY9vcIM4QtLLHy33N2iKJmJon+T2dZuhg5ONgEtCVO/+cA
 iYsIfGCWWL9lESNIA7PAbWaJbdcjQGxhAXOJeS3bWUFsFgFViZdTbzGB9PIKWEo8vm4GYkoI
 6Ev03xcEqeAVEJQ4OfMJ2HRmAXWJ9fOEIAbKSzRvnc08gZF/FpKqWQhVs5BULWBkXsUomVpQ
 nJueW2xYYJiXWq5XnJhbXJqXrpecn7uJEZwStDR3MG5f9UHvECMTB+MhRgkOZiUR3sC+5BQh
 3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamEK0EsXFal8d
 Zen6mvouncf28RqZN2mPfXXWrNIOC+/1aVnLbHBbstfFcWvPjYBKHc3MfTXlC2842l8+FNjZ
 vP/8it7K5L/VZ6en+b1+aPc//OBGlT3+bxo9LsXuyT4WevZSqkSB6mP/e95CStzylYne77mb
 HLuO18ezaj0s959psE7Ew+1ln8qCWsFJK5SMO93NjEoUclcuDZ4qO69zN9e9L0c1svccDv2m
 rrjpw5TvaeHsj5d/s9Xdlb/xkLHP9cDGbWIVVSyHvLhCpn1TSFzz4eWPbUVJf6Ys3fsxas4j
 r28egjklh60eFnhqy36q9vg294XW2tuS4kquSfMDc24/9kkpSvnZlrvQcNMxJZbijERDLeai
 4kQAKZNWoHgDAAA=
X-CMS-MailID: 20230522104508epcas5p13f99359d0af12453e0e4bc7f4bae23f0
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104508epcas5p13f99359d0af12453e0e4bc7f4bae23f0
References: <CGME20230522104508epcas5p13f99359d0af12453e0e4bc7f4bae23f0@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: [dm-devel] [PATCH v11 0/9] Implement copy offload support
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
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 James.Bottomley@HansenPartnership.com, linux-fsdevel@vger.kernel.org,
 dlemoal@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>, joshi.k@samsung.com,
 nitheshshetty@gmail.com, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch series covers the points discussed in past and most recently
in LSFMM'23[0].
We have covered the initial agreed requirements in this patchset and
further additional features suggested by community.
Patchset borrows Mikulas's token based approach for 2 bdev implementation.

This is next iteration of our previous patchset v10[1].

Overall series supports:
========================
	1. Driver
		- NVMe Copy command (single NS, TP 4065), including support
		in nvme-target (for block and file backend).

	2. Block layer
		- Block-generic copy (REQ_COPY flag), with interface
		accommodating two block-devs
		- Emulation, for in-kernel user when offload is natively 
                absent
		- dm-linear support (for cases not requiring split)

	3. User-interface
		- copy_file_range

Testing
=======
	Copy offload can be tested on:
	a. QEMU: NVME simple copy (TP 4065). By setting nvme-ns
		parameters mssrl,mcl, msrc. For more info [2].
	b. Null block device
        c. NVMe Fabrics loopback.
	d. blktests[3] (tests block/034-037, nvme/050-053)

	Emulation can be tested on any device.

	fio[4].

Infra and plumbing:
===================
        We populate copy_file_range callback in def_blk_fops. 
        For devices that support copy-offload, use blkdev_copy_offload to
        achieve in-device copy.
        However for cases, where device doesn't support offload,
        fallback to generic_copy_file_range.
        For in-kernel users (like NVMe fabrics), we use blkdev_issue_copy
        which implements its own emulation, as fd is not available.
        Modify checks in generic_copy_file_range to support block-device.

Performance:
============
        The major benefit of this copy-offload/emulation framework is
        observed in fabrics setup, for copy workloads across the network.
        The host will send offload command over the network and actual copy
        can be achieved using emulation on the target.
        This results in higher performance and lower network consumption,
        as compared to read and write travelling across the network.
        With async-design of copy-offload/emulation we are able to see the
        following improvements as compared to userspace read + write on a
        NVMeOF TCP setup:

        Setup1: Network Speed: 1000Mb/s
        Host PC: Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
        Target PC: AMD Ryzen 9 5900X 12-Core Processor
        block size 8k:
        710% improvement in IO BW (108 MiB/s to 876 MiB/s).
        Network utilisation drops from  97% to 15%.
        block-size 1M:
        2532% improvement in IO BW (101 MiB/s to 2659 MiB/s).
        Network utilisation drops from 89% to 0.62%.

        Setup2: Network Speed: 100Gb/s
        Server: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz, 72 cores
        (host and target have the same configuration)
        block-size 8k:
        17.5% improvement in IO BW (794 MiB/s to 933 MiB/s).
        Network utilisation drops from  6.75% to 0.16%.

Blktests[3]
======================
	tests/block/034,035: Runs copy offload and emulation on block
                              device.
	tests/block/035,036: Runs copy offload and emulation on null
                              block device.
        tests/nvme/050-053: Create a loop backed fabrics device and
                              run copy offload and emulation.

Future Work
===========
	- loopback device copy offload support
	- upstream fio to use copy offload
	- upstream blktest to use copy offload

	These are to be taken up after this minimal series is agreed upon.

Additional links:
=================
	[0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
            https://lore.kernel.org/linux-nvme/f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com/
            https://lore.kernel.org/linux-nvme/20230113094648.15614-1-nj.shetty@samsung.com/
	[1] https://lore.kernel.org/all/20230419114320.13674-1-nj.shetty@samsung.com/
	[2] https://qemu-project.gitlab.io/qemu/system/devices/nvme.html#simple-copy
	[3] https://github.com/nitesh-shetty/blktests/tree/feat/copy_offload/v11
	[4] https://github.com/vincentkfu/fio/commits/copyoffload-3.34-v11

Changes since v10:
=================
        - NVMeOF: optimization in NVMe fabrics (Chaitanya Kulkarni)
        - NVMeOF: sparse warnings (kernel test robot)

Changes since v9:
=================
        - null_blk, improved documentation, minor fixes(Chaitanya Kulkarni)
        - fio, expanded testing and minor fixes (Vincent Fu)

Changes since v8:
=================
        - null_blk, copy_max_bytes_hw is made config fs parameter
          (Damien Le Moal)
        - Negative error handling in copy_file_range (Christian Brauner)
        - minor fixes, better documentation (Damien Le Moal)
        - fio upgraded to 3.34 (Vincent Fu)

Changes since v7:
=================
        - null block copy offload support for testing (Damien Le Moal)
        - adding direct flag check for copy offload to block device,
	  as we are using generic_copy_file_range for cached cases.
        - Minor fixes

Changes since v6:
=================
        - copy_file_range instead of ioctl for direct block device
        - Remove support for multi range (vectored) copy
        - Remove ioctl interface for copy.
        - Remove offload support in dm kcopyd.

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

Changes since v1:
=================
	- sysfs documentation (Greg KH)
        - 2 bios for copy operation (Bart Van Assche, Mikulas Patocka,
          Martin K. Petersen, Douglas Gilbert)
        - better payload design (Darrick J. Wong)

Nitesh Shetty (9):
  block: Introduce queue limits for copy-offload support
  block: Add copy offload support infrastructure
  block: add emulation for copy
  fs, block: copy_file_range for def_blk_ops for direct block device
  nvme: add copy offload support
  nvmet: add copy command support for bdev and file ns
  dm: Add support for copy offload
  dm: Enable copy offload for dm-linear target
  null_blk: add support for copy offload

 Documentation/ABI/stable/sysfs-block |  33 ++
 block/blk-lib.c                      | 431 +++++++++++++++++++++++++++
 block/blk-map.c                      |   4 +-
 block/blk-settings.c                 |  24 ++
 block/blk-sysfs.c                    |  64 ++++
 block/blk.h                          |   2 +
 block/fops.c                         |  20 ++
 drivers/block/null_blk/main.c        | 108 ++++++-
 drivers/block/null_blk/null_blk.h    |   8 +
 drivers/md/dm-linear.c               |   1 +
 drivers/md/dm-table.c                |  41 +++
 drivers/md/dm.c                      |   7 +
 drivers/nvme/host/constants.c        |   1 +
 drivers/nvme/host/core.c             | 103 ++++++-
 drivers/nvme/host/fc.c               |   5 +
 drivers/nvme/host/nvme.h             |   7 +
 drivers/nvme/host/pci.c              |  27 +-
 drivers/nvme/host/rdma.c             |   7 +
 drivers/nvme/host/tcp.c              |  16 +
 drivers/nvme/host/trace.c            |  19 ++
 drivers/nvme/target/admin-cmd.c      |   9 +-
 drivers/nvme/target/io-cmd-bdev.c    |  62 ++++
 drivers/nvme/target/io-cmd-file.c    |  52 ++++
 drivers/nvme/target/loop.c           |   6 +
 drivers/nvme/target/nvmet.h          |   1 +
 fs/read_write.c                      |  11 +-
 include/linux/blk_types.h            |  25 ++
 include/linux/blkdev.h               |  21 ++
 include/linux/device-mapper.h        |   5 +
 include/linux/nvme.h                 |  43 ++-
 include/uapi/linux/fs.h              |   3 +
 mm/filemap.c                         |  11 +-
 32 files changed, 1155 insertions(+), 22 deletions(-)


base-commit: dbd91ef4e91c1ce3a24429f5fb3876b7a0306733
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

