Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDB5C6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=mrfoYgiBryyuQz0sqTLTyLA5PfyRgXOnHjGBeL7duSc=;
	b=Dcu3IpX2h0M5AHS9D3qxJu5eYyiBb6pCyCNDRFbU5qY8IFZixCTFk+A6noh+/FgKtE/crm
	FzFzW/FMOhBesg7TowcKWPoTIXkvEr5m1y7dKryAitaTw0KLCDIxtVNzh7lIplxMRCMRgT
	g20fxcFiy0SN3nMZOv5NWVMnxTbO33E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-9S779ICLPs24oRX2AhyXaA-1; Thu, 30 Mar 2023 02:33:03 -0400
X-MC-Unique: 9S779ICLPs24oRX2AhyXaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E16C88030D7;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8656A1121331;
	Thu, 30 Mar 2023 06:32:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD24F1946A49;
	Thu, 30 Mar 2023 06:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C05F3194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:21:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AFE7EC15BB8; Wed, 29 Mar 2023 08:21:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A74BBC15BA0
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:21:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D80F282380A
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:21:07 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-76hLAJ2EOSWYwsiWfWs9RA-1; Wed, 29 Mar 2023 04:21:05 -0400
X-MC-Unique: 76hLAJ2EOSWYwsiWfWs9RA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230329081558epoutp014fd8f8f5552b72da628bae0902283018~Q1dHpKyZp1200012000epoutp01L
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:15:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230329081558epoutp014fd8f8f5552b72da628bae0902283018~Q1dHpKyZp1200012000epoutp01L
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230329081557epcas5p2182fed406013eb49fe187d8f52e4bea0~Q1dGpWhpL1664716647epcas5p2s;
 Wed, 29 Mar 2023 08:15:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PmfWb5KVDz4x9QH; Wed, 29 Mar
 2023 08:15:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0A.7D.10528.BB3F3246; Wed, 29 Mar 2023 17:15:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230327084154epcas5p2a1d8ee728610929fbba8c7757ad3193e~QOhMlwjhh0614806148epcas5p2T;
 Mon, 27 Mar 2023 08:41:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230327084154epsmtrp1a4897c638870d56fca4f0694dd19a8a3~QOhMjZT9T3087630876epsmtrp1P;
 Mon, 27 Mar 2023 08:41:54 +0000 (GMT)
X-AuditID: b6c32a49-c17ff70000012920-62-6423f3bbc395
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 55.2C.18071.2D651246; Mon, 27 Mar 2023 17:41:54 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084151epsmtip11c61a1eebd915d7dc45a189d3327d9a0~QOhJIB7hW2981529815epsmtip12;
 Mon, 27 Mar 2023 08:41:51 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:48 +0530
Message-Id: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjOd057WlgqR2DhE2V0R5Goo6UK3Vcn7ObccSwZ0S1ZFh129FgQ
 aJtexpBMLgUmJFpgcxuFCNuETXDIKmCFlmARgSrCuE1wXMYlbKByi8atUdfSsvnveZ/3efI+
 7/vl4+K+OZxAbqJCy6gV0mSK8GY1tm0LDWte2SwLn7ixFV20X8dRduFjHNWMGgg037YM0NeL
 f+PI0d2DI+v9UjYabr2CIcv3xRg6X9OOoebvljDU/vQegYptQwDNDBoxZB3ZgSzWLhbqbyoj
 UHnVDAfZvtRjyDydBVCjoxxHtfMLLNQ5shH1PO5gvwbp/oEY2jjeTdBXjKMcumfsFxbd362j
 TdX5BH3pXAbdPJxJ0Kf0952C3HE2vdAySNCn66sBfelGOr1ieoE2Td/DYn0+StqTwEhljJrP
 KOKVskSFPIqKORj3ZlykOFwUJpKglym+QprCRFF7340N25eY7LwDxf9UmqxzUrFSjYYSRu9R
 K3Vahp+g1GijKEYlS1ZFqAQaaYpGp5ALFIx2tyg8fGekU3gkKeHnWjumWon+bKhwGMsEDYIC
 4MWFZARs/MmKFwBvri/ZDGDTk0lPsQxg9Ugvx108BFA/N8dZsxgXKljuhhXAmmqzR6XH4GL2
 FNulIshQeG02F7ga/mQeDpdm8lctODmBwfLsc8Cl8iPF8M/iJaIAcLksMgS25Ua7aB4pgdkj
 JcBFQ1IIDePr3fR62FUyzXJhnAyG+obS1ayQLPeChtkp4I63FxZVjBNu7AfnOuo9sQPhX4Y8
 D5bDR/0zmBuroP56i8f7Ksy1G3DXXJzcBi82Cd10EDxjr8Xcc9fBU45pj5UHzWfXMAW/OF/m
 wRBab2Vi7vg0fHh1k4v2JQ/DqrMnsUIQbHxmG+Mz2xj/H1wB8GqwgVFpUuSMJlIlUjCp/z1s
 vDLFBFa/w/b9ZjA6sSiwAYwLbAByccqf5xiiZL48mTTtOKNWxql1yYzGBiKdBy7CA5+PVzr/
 k0IbJ4qQhEeIxeIIyS6xiArghUZ1xfuScqmWSWIYFaNe82Fcr8BM7APiiO5buJWdcevOg9Sd
 bw8dm0vx7eDtoC2ZfaiH14tXzp05kWp5+n7Y8Tfsna29fnktkLXxtwPkvdhGUdzrMgl7ud1E
 /s7Hc9pqdx0qerDp4K/pPmk3jYaGQUvwtSjhpKklYH7yFfudzYfY5tKxDw/oXvJ+K2724y5+
 WUlASGHI3UQDLhwuUAYJFy5cXWILxPP75lV/pHWmz6xsaX0nq0qyZfeGyvcaEh/pG17svzz0
 nGPAEWk7OvXV52P1dQN1+zlUhjyQXhdT3nz59tH0ibqTvVSr+ce7sz8Qld+0aXg1gqybfT4n
 LCWHQy7kHMP4K/kjn6iX/YOK/f9pvZ3c+aSvfZBiaRKkou24WiP9FzLG03+XBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRiA+845OzuOVqep9ZWlOboqrUZhn1YmlHCqP92J0PTQTlrpWluu
 NLykiGVmYhk4pdkFw5kON/PSUmpecupa5SWUbAkblqaWRiGi5pLIf+/7PA/vn5fCRc3ECuqs
 /BKnlLMxYlJAVDWIvTe9P+4r29L0ayPStzbjKDVnCkelfbdJNNQwBtC97xM4mrTacFQ3UsBD
 PS9rMfTiYS6GSkqbMGR68ANDTTPDJMo1dwPk7NJgqK7XH72osxCo43khibTFTj4y30nDUI3j
 GkBVk1oclQ+NEqil1wvZpl7zQiDT0XmA0ditJFOr6eMztk8VBNNhjWMMuhskY3yczJh6Ukjm
 VtrIbJBu5zGj9V0kk12pA4yx7SozbvBmDI5h7ODik4KdMi7mrJpTbg6OFESXlbdiivHgK905
 PVgKeCbJBG4UpLdBzWgRkQkElIg2AZjXlUvMCQhbvxaDudkdlkwP8OeiaxhssOXjLkHS62Hj
 QDpwCQ86B4fv7Smka8HpEQzq+ot5rsqdDoBfcn/MCooi6LWwIT3YhYV0IEztzQcuDOnN8LZ9
 yRxeAi35DsKF8dn7+vsiF8ZpH5j2rADPAYs18yrN/0ozryoCuA4s5xSq2KhYlVQhlXOXJSo2
 VhUnj5KcvhBrAH9f7bexBlTrvkvMAKOAGUAKF3sIjQd8ZSKhjI1P4JQXIpRxMZzKDLwoQrxM
 +DbTEiGio9hL3HmOU3DKfxaj3FakYJFhPqnuO9QRzZ+dSRatIntvZdWbg9MtbtsrKp8K1d92
 WI8t9ZcbDz/2ZN89dLgN/EwUWsQOQye/cyk+ePXOxdctWcbw6KajmKkoOnTBzJoM9f0t1RNl
 JyrGbuYNhur3+zgTE4Wez4NqCPU5QeGJpJAqqR54jSbMXJfVTkx9DGCTte2mwLGf5vBPp4oT
 H62eVF/e86GR3bpIIs3Q6s0ORo74T2QJG1Yp9y2AqrJC+krQxXXWIO/+UisbciNz4MvegvZ6
 S3/Wkeaw3yGd1eViD3voJrLPb+XJtlMF517FD9cfCsjq2B3JZDgXFvGcXWeW7UKt7ZG7/O7G
 lB4hum0lYkIVzUr9cKWK/QPqTNhVWQMAAA==
X-CMS-MailID: 20230327084154epcas5p2a1d8ee728610929fbba8c7757ad3193e
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084154epcas5p2a1d8ee728610929fbba8c7757ad3193e
References: <CGME20230327084154epcas5p2a1d8ee728610929fbba8c7757ad3193e@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 0/9] Implement copy offload support
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
 linux-block@vger.kernel.org, nitheshshetty@gmail.com,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

The patch series covers the points discussed in November 2021 virtual
call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
We have covered the initial agreed requirements in this patchset and
further additional features suggested by community.
Patchset borrows Mikulas's token based approach for 2 bdev
implementation.

This is on top of our previous patchset v7[1].

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

	These are to be taken up after we reach consensus on the
	plumbing of current elements that are part of this series.


Additional links:
=================
	[0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
	[1] https://lore.kernel.org/lkml/20230220105336.3810-1-nj.shetty@samsung.com/
	[2] https://qemu-project.gitlab.io/qemu/system/devices/nvme.html#simple-copy
	[3] https://github.com/nitesh-shetty/blktests/tree/feat/copy_offload/v7
	[4] https://github.com/vincentkfu/fio/tree/copyoffload-cfr-3.33-v7

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
  fs, block: copy_file_range for def_blk_ops for direct block device.
  nvme: add copy offload support
  nvmet: add copy command support for bdev and file ns
  dm: Add support for copy offload.
  dm: Enable copy offload for dm-linear target
  null_blk: add support for copy offload

 Documentation/ABI/stable/sysfs-block |  36 +++
 block/blk-lib.c                      | 427 +++++++++++++++++++++++++++
 block/blk-map.c                      |   4 +-
 block/blk-settings.c                 |  24 ++
 block/blk-sysfs.c                    |  64 ++++
 block/blk.h                          |   2 +
 block/fops.c                         |  20 ++
 drivers/block/null_blk/main.c        |  94 ++++++
 drivers/block/null_blk/null_blk.h    |   7 +
 drivers/md/dm-linear.c               |   1 +
 drivers/md/dm-table.c                |  42 +++
 drivers/md/dm.c                      |   7 +
 drivers/nvme/host/constants.c        |   1 +
 drivers/nvme/host/core.c             | 106 ++++++-
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
 31 files changed, 1136 insertions(+), 14 deletions(-)


base-commit: 0aa250ce67a2697327415132a0aa4e9f1f0fe000
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

