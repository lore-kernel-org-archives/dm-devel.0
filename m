Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF34BC7EE20
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973845;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=6E+xY+Jdsx+k/Imctuu3Yc/XPjtT3S0mOylZckpUKzU=;
	b=BrGfS0r0Xcb/tjUblZ1t/38Hv/hJf/a3ynRtKwolCMeQ9NM6QBPI1p5kKxtB9VhCOkUVtI
	NclBQL+w641XC9U1a2hcf3u3vK4x6rOTRsrcbihcUG6dJK7PkgCWuNYTrGbkD+fV3ZOMlE
	zAubzmvbfy0+Z3R1uxgABp6LvBLpp8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-RKzX7CYJNDmtBerWzNxCYg-1; Thu, 20 Apr 2023 02:57:22 -0400
X-MC-Unique: RKzX7CYJNDmtBerWzNxCYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DEB73823A11;
	Thu, 20 Apr 2023 06:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F1A32C16024;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7B1719459FC;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B01A19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:54:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7954A1410F1E; Wed, 19 Apr 2023 11:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 711B01410F1C
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D85B3801F5B
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:24 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-rPPlVgJGPdK-SKMKrAvtdw-1; Wed, 19 Apr 2023 07:54:22 -0400
X-MC-Unique: rPPlVgJGPdK-SKMKrAvtdw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230419115419epoutp045e793731bb30e77ccefef53d9aea16f2~XU_weTavz1730617306epoutp04h
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230419115419epoutp045e793731bb30e77ccefef53d9aea16f2~XU_weTavz1730617306epoutp04h
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230419115418epcas5p337fedbd8a2fa7a38f959b5b86ed0c9c4~XU_v9f7bW1261212612epcas5p3g;
 Wed, 19 Apr 2023 11:54:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Q1fMr5d7dz4x9Pp; Wed, 19 Apr
 2023 11:54:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 95.04.09987.866DF346; Wed, 19 Apr 2023 20:54:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230419114623epcas5p49ee241d5159a15d13aef6b0b5a331c01~XU308fFQk1965419654epcas5p4G;
 Wed, 19 Apr 2023 11:46:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230419114623epsmtrp11f9e4472d9daef7db021eec66ce174e1~XU307SwwV1683116831epsmtrp18;
 Wed, 19 Apr 2023 11:46:23 +0000 (GMT)
X-AuditID: b6c32a4b-7fbff70000002703-f5-643fd668c99a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 55.87.08279.E84DF346; Wed, 19 Apr 2023 20:46:22 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114619epsmtip1646751f7c885d1ce48805076b203f2fa~XU3xw3dPI1718017180epsmtip1e;
 Wed, 19 Apr 2023 11:46:19 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:05 +0530
Message-Id: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbdRTe795yW9DiBab7wZxrqmQC8qhA+YFjD4bkRuaCIYu6zGBHbwAp
 be1tZWgGDBgKGbAim9gBg21xrFMID5HHKEsReW+ZQHlkCEFQoUAZ6IAwgpQLuv++853z5Zzz
 nRwe7rhOuPDi5GpaJZfIhIQdp67Vzc0z1nRY6lNY5ooqu37BUdqldRzdGc0jkLl1EaArC6s4
 Gm85jJrnr9qg4XsNGLp7PR9Dt++0Yaip7DGG2jbmCJRvNAE0NaDDUPOIB7rb3MlBfY1FBLr2
 3RQXGb9Ox1D95HmA6tau4ajCbOGgjpG96MF6u80RSPX1h1O6sV6CatCNcqkHv1VxqL5eDVWt
 zyKompspVNNwKkHlpM8TlMUwQFC5tXpA1XR/QS1Vv0JVT85hEfan4g/G0hIprRLQ8miFNE4e
 EywMj4w6FuUv9hF5igJRgFAglyTQwcLQ4xGeYXGyTQeEgs8kMs0mFSFhGKH3oYMqhUZNC2IV
 jDpYSCulMqWf0ouRJDAaeYyXnFYHiXx83vTfLPw4PjZzJgdTDoScnfzynVRwWZQNbHmQ9INP
 rxu42cCO50g2AXirWoezwSKAxmK9DRs8AXDGvEjsSAqK2jE20QzgXz09uDXhSF7A4GwWPxvw
 eATpAbs3eNaa3WQmDh9PZXGsAU7+isGntZYtgRMZAE2jaZhVwCFdYZHxQyvNJ4Pg/UYt10pD
 0hvmjTmwtAPs/HaSY8U4uR+m/3h1a1JIfmMLV3qncXa4UGjSDQEWO8GZ9loui13gdF7mNk6E
 twvKCVacAaBuULctOAwvdOXh1sY46QYrG71Zeh+83FWBsY3tYc7aJMbyfFhfsoNfhd9Xlm4b
 5AxNy+e3MQVXHn3FYf35CKbrDPglsF/3zD66Z/bR/d+5FOB64EwrmYQYmvFX+srpxP/uGq1I
 qAZbf+AeXg8mxhe8jADjASOAPFy4m9/zdpDUkS+VJH1OqxRRKo2MZozAf9NiLe7yYrRi85Hk
 6iiRX6CPn1gs9gv0FYuEe/gHgjujHckYiZqOp2klrdrRYTxbl1TM9YXnBG9ENKzJCuIHjnQr
 LxblKcYznZbj6l4rlBNJtSeOBxoXOm5p6VBLojwAO3rmg+dPVaylibs8tYbkT/UrkZrB8GRt
 d/HIifl9uYNo3uVQfz1jP/zy8ieu93Pfnw5TTpQceOsG86c58pw2mGm98rDl5lBScvGx1ZS/
 3ZeWCv8peZSxGPfz64YoxkbfXGMpdYiY5fWdy8hYLvnhpzPS/F3O0Rdfsue/FzLHbRlsLW8z
 80+fpO0ENzp6fKe9+euruf5lBqLJ3HlSVV9V6ZHSn/AkecIzbNe0rDZ7VuwciIcM5ZrKH/5u
 4XRo08be3Vuw3Hh2Y+HeH+176taruKfFWSFcIYeJlYjccRUj+Rd9EsHIkAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSnG7fFfsUg39frS3WnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WD/fYWe9/NZrW4eWAnk8WeRZOYLFauPspksXvhRyaLo//fsllM
 OnSN0eLp1VlMFntvaVvs2XuSxeLyrjlsFvOXPWW3ODS5mclix5NGRottv+czW6x7/Z7F4sQt
 aYvzf4+zOkh4XL7i7THr/lk2j52z7rJ7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HNo7f5HZvH
 +31X2Tz6tqxi9Nh8utrj8yY5j01P3jIF8EVx2aSk5mSWpRbp2yVwZbS96mUquOpU8aTdq4Fx
 qmEXIyeHhICJxJQ5x5m6GDk4hAR2M0o8yoMIS0os+3uEGcIWllj57zl7FyMXUEkzk0TLxhcs
 IPVsAtoSp/9zgMRFBCYwS1y638AG4jALPGCSOP/8CytIt7CAucS1u01gC1gEVCXmHIoECfMK
 WEmc2zWRHSQsIaAv0X9fECIsKHFy5hOw8cwC6hLr5wmBhJkF5CWat85mnsDIPwtJ1SyEqllI
 qhYwMq9ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOYC3NHYzbV33QO8TIxMF4iFGC
 g1lJhNfdxi5FiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6p
 BqbJEfdW766b+76k1vnlpGrFtjUcOTmH7afMnKT748PdaXfrXpzqWl9svtwwJGjTfo6Q8DN9
 toYnjju/V1QQr/tYVLs1OuTspb8FrRKPi94tNde7t6rizEn52/bqV84rLri/ztzgzaLqN+Jz
 J9u9OdvhLdmfbLco4MPBpC17ZMXfvrpqfWoqx5LL7nLHDnPwTvZoMshYoi12tYR7ZpLSNNfl
 jl5ry/uuLrEzdBetltEvj5CI8yvyK94QFMIdO0F5XoTkjab9LX9fn+K23dBaJzvXqFBY60vp
 DI6Gwqoy5nncfx+bFrXz82/o2F1WP9v33OP7mbHns87qN19o0J95xtVe27D7QcYtpsLbatHh
 t5RYijMSDbWYi4oTAQ6weptPAwAA
X-CMS-MailID: 20230419114623epcas5p49ee241d5159a15d13aef6b0b5a331c01
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114623epcas5p49ee241d5159a15d13aef6b0b5a331c01
References: <CGME20230419114623epcas5p49ee241d5159a15d13aef6b0b5a331c01@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 0/9] Implement copy offload support
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch series covers the points discussed in November 2021 virtual
call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
We have covered the initial agreed requirements in this patchset and
further additional features suggested by community.
Patchset borrows Mikulas's token based approach for 2 bdev
implementation.

This is on top of our previous patchset v9[1].

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
        c. Fabrics loopback.
	d. blktests[3] (tests block/032,033, nvme/046,047,048,049)

	Emulation can be tested on any device.

	fio[4].

Infra and plumbing:
===================
        We populate copy_file_range callback in def_blk_fops. 
        For devices that support copy-offload, use blkdev_copy_offload to
        achieve in-device copy.
        However for cases, where device doesn't support offload,
        fallback to generic_copy_file_range.
        For in-kernel users (like fabrics), we use blkdev_issue_copy
        which implements its own emulation, as fd is not available.
        Modify checks in generic_copy_file_range to support block-device.

Performance:
============
        The major benefit of this copy-offload/emulation framework is
        observed in fabrics setup, for copy workloads across the network.
        The host will send offload command over the network and actual copy
        can be achieved using emulation on the target.
        This results in better performance and network utilisation,
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
	tests/block/032,033: Runs copy offload and emulation on block device.
        tests/nvme/046,047,048,049 Create a loop backed fabrics device and
        run copy offload and emulation.

Future Work
===========
	- loopback device copy offload support
	- upstream fio to use copy offload
	- upstream blktest to use copy offload

	These are to be taken up after we reach consensus on the
	plumbing of current elements that are part of this series.

Additional links:
=================
	[0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
	[1] https://lore.kernel.org/lkml/20230413103610.3calcy37ogf72y6q@green5/T/
	[2] https://qemu-project.gitlab.io/qemu/system/devices/nvme.html#simple-copy
	[3] https://github.com/nitesh-shetty/blktests/tree/feat/copy_offload/v7
	[4] https://github.com/vincentkfu/fio/commits/copyoffload-3.34-v10

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
 drivers/nvme/target/io-cmd-bdev.c    |  58 ++++
 drivers/nvme/target/io-cmd-file.c    |  52 ++++
 drivers/nvme/target/loop.c           |   6 +
 drivers/nvme/target/nvmet.h          |   1 +
 fs/read_write.c                      |  11 +-
 include/linux/blk_types.h            |  25 ++
 include/linux/blkdev.h               |  21 ++
 include/linux/device-mapper.h        |   5 +
 include/linux/nvme.h                 |  43 ++-
 include/uapi/linux/fs.h              |   3 +
 31 files changed, 1143 insertions(+), 19 deletions(-)


base-commit: 4aa1da8d99724f6c0b762b58a71cee7c5e2e109b
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

