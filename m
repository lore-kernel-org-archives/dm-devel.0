Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F96BC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA9BF611ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA9BF611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-rvX3MH9WMRydZGJfY1B-cQ-1; Mon, 17 May 2021 03:51:07 -0400
X-MC-Unique: rvX3MH9WMRydZGJfY1B-cQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6CE9107ACCD;
	Mon, 17 May 2021 07:51:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C193D10023AC;
	Mon, 17 May 2021 07:51:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ECD845534B;
	Mon, 17 May 2021 07:51:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14C7J7LT021524 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 03:19:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB4FB20F74E5; Wed, 12 May 2021 07:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A53AC20F74E1
	for <dm-devel@redhat.com>; Wed, 12 May 2021 07:19:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D5DD18E0921
	for <dm-devel@redhat.com>; Wed, 12 May 2021 07:19:03 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
	[210.118.77.11]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-329-9EZp0RXqO0u5XHD2iy8nlw-1; Wed, 12 May 2021 03:19:01 -0400
X-MC-Unique: 9EZp0RXqO0u5XHD2iy8nlw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
	20210512071322euoutp01b96c4e385eb5260c5b811534ecdaf4e3~_QEoFcjoZ0996309963euoutp01O
	for <dm-devel@redhat.com>; Wed, 12 May 2021 07:13:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
	20210512071322euoutp01b96c4e385eb5260c5b811534ecdaf4e3~_QEoFcjoZ0996309963euoutp01O
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20210512071322eucas1p2657b4d5c249ba14c3dde7105655880b7~_QEnyFQt61142111421eucas1p2e;
	Wed, 12 May 2021 07:13:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id D1.10.09452.2108B906;
	Wed, 12 May 2021 08:13:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20210512071321eucas1p2ca2253e90449108b9f3e4689bf8e0512~_QEnPivnm0606706067eucas1p2K;
	Wed, 12 May 2021 07:13:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20210512071321eusmtrp1d154eb7dc28942d10f16f02fca921391~_QEnOm2R92087720877eusmtrp1Q;
	Wed, 12 May 2021 07:13:21 +0000 (GMT)
X-AuditID: cbfec7f2-a9fff700000024ec-d4-609b801274f9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id C9.E5.08696.1108B906;
	Wed, 12 May 2021 08:13:21 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210512071321eusmtip1ddffca367e61938552a43c3235a4573d~_QEnCRiKp2705427054eusmtip1A;
	Wed, 12 May 2021 07:13:21 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id
	15.0.1497.2; Wed, 12 May 2021 08:13:21 +0100
Date: Wed, 12 May 2021 09:13:19 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Message-ID: <20210512071319.x4wtf5uaknypoxrx@mpHalley.local>
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djPc7pCDbMTDM5v4rRYfbefzWLah5/M
	FrNuv2ax2PtuNqvF403/mSz2LJrEZLFy9VEmi0mHrjFa7L2lbTF/2VN2i+7rO9gs9r3ey2yx
	/Pg/JouJHVeZLM7N+sNmcfjeVRaL1X8sLFY+Y7J4tT/OQdjj8hVvj4nN79g9Lp8t9di0qpPN
	Y/OSeo/JN5Yzeuy+2cDmMePTFzaP62e2M3l8fHqLxWPbw152j/f7rgKVna72+LxJzqP9QDdT
	AH8Ul01Kak5mWWqRvl0CV8abld9YC15oVyxZvZu5gbFVtYuRk0NCwERi8a2DbF2MXBxCAisY
	Jb5/ncYC4XxhlHg4eSoThPOZUWLpwZ9MMC19fX9ZIRLLGSX2fVzCDJIAq3p+JA0isZVRYtn0
	L2AdLAKqEttWfmQFsdkE7CUuLbsF1iAiYCwx/+ZcNhCbWeAcu8SLZ5kgtrCAp8SODf1gvbwC
	NhL9V9+zQNiCEidnPmGBqLeS6PzQBDSTA8iWllj+jwMkzCkQK3H03RNmkLCEgLLE8um+EDfX
	SpzacgvsGQmBX5wSK9c3Qj3jIrHyQjeULSzx6vgWdghbRuL05B4WiIZmRokza64wQzg9jBJ/
	Jq1ghNhgLdF3JgeiwVFi1ZVmVogwn8SNt4IQZ/JJTNo2HeoeXomONiGIajWJHU1bGScwKs9C
	8tgsJI/NQnhsASPzKkbx1NLi3PTUYsO81HK94sTc4tK8dL3k/NxNjMC0efrf8U87GOe++qh3
	iJGJg/EQowQHs5IIr1jS7AQh3pTEyqrUovz4otKc1OJDjNIcLErivKtmr4kXEkhPLEnNTk0t
	SC2CyTJxcEo1MInF++37xt0jtKFvwz2FQwyiE1lTU4IyUy++n/Ro38fMvR17rXaeufRU3j8t
	tMdMc3qSy0VBmYldt2ZN7BedtyWi7NuptZb81/Y4fd8k9qY8tMN0h5in7qoVNd/+fBLhPXJj
	bZhwXyyTXJetajL7S/m1JZp/HMOV9j1eJHQ4NIjpcMtTm8h3x3r1yy5GxFfG9Obr720TXefb
	5mD4h1n2j7ugSemyrY8ez9fZMqdk9infK8JntHXvzJzEpTN3oWtJy2JF0yah+kbH0gbOm5qz
	J4fl7q7b5fj/xsWFb3UcpsZfWFF+PiPt6doMd3e1ebV1nPJnhfkWP9huI3R86j72u2HBSVvX
	aG1gXe8iHus0X4mlOCPRUIu5qDgRAF+sxm4KBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t/xu7qCDbMTDPZfULBYfbefzWLah5/M
	FrNuv2ax2PtuNqvF403/mSz2LJrEZLFy9VEmi0mHrjFa7L2lbTF/2VN2i+7rO9gs9r3ey2yx
	/Pg/JouJHVeZLM7N+sNmcfjeVRaL1X8sLFY+Y7J4tT/OQdjj8hVvj4nN79g9Lp8t9di0qpPN
	Y/OSeo/JN5Yzeuy+2cDmMePTFzaP62e2M3l8fHqLxWPbw152j/f7rgKVna72+LxJzqP9QDdT
	AH+Unk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsab
	ld9YC15oVyxZvZu5gbFVtYuRk0NCwESir+8vaxcjF4eQwFJGic4Jb9khEjISn658hLKFJf5c
	62KDKPrIKLG+bz47hLOVUWLVxgZWkCoWAVWJbSs/gtlsAvYSl5bdYgaxRQSMJebfnMsGYjML
	nGOXePEsE8QWFvCU2LGhnwnE5hWwkei/+p4FxBYSiJHY9molK0RcUOLkzCcsEL0WEjPnn2fs
	YuQAsqUllv/jAAlzCsRKHH33hBkkLCGgLLF8ui/EzbUSn/8+Y5zAKDwLyaBZSAbNQhi0gJF5
	FaNIamlxbnpusZFecWJucWleul5yfu4mRmDy2Hbs55YdjCtffdQ7xMjEwXiIUYKDWUmEVyxp
	doIQb0piZVVqUX58UWlOavEhRlNgQExklhJNzgemr7ySeEMzA1NDEzNLA1NLM2MlcV6TI2vi
	hQTSE0tSs1NTC1KLYPqYODilGpj2VL8rSbarul7584upaoVbn07009zpxo7rVnN+kNdbt1nK
	VkrqhNj6m4L7BDuCYtk7du8WZN211ML4xBvR6n/3DyicZ9vAEBMzT1bgbWPk2/0VizI2Gtpq
	96eaFH64JS6iUDeD1zYkZ39IyiHBLzUN+Q/v9GxYUsynZbjvqe421XmFq3XsQgx23Iz7Fb/6
	eqfo/bdl2YbsxSt8nKoa8yW7W1R9pd6+3MMZ+Gkx95PkXvWDrLMbDnnmbIg6EfCQKS4gZun2
	nFlcTHsvXt1s2/rw+o7Vq0QUQnRefrbXlf7eZ/OR6djhWTcM132dpiYXfcU/JPpj/qlXK5iV
	2Wy5c55I859cfZrx9IWdds4y85RYijMSDbWYi4oTAfITnzGnAwAA
X-CMS-MailID: 20210512071321eucas1p2ca2253e90449108b9f3e4689bf8e0512
X-Msg-Generator: CA
X-RootMTR: 20210512071321eucas1p2ca2253e90449108b9f3e4689bf8e0512
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210512071321eucas1p2ca2253e90449108b9f3e4689bf8e0512
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<CGME20210512071321eucas1p2ca2253e90449108b9f3e4689bf8e0512@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 May 2021 03:51:00 -0400
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11.05.2021 00:15, Chaitanya Kulkarni wrote:
>Hi,
>
>* Background :-
>-----------------------------------------------------------------------
>
>Copy offload is a feature that allows file-systems or storage devices
>to be instructed to copy files/logical blocks without requiring
>involvement of the local CPU.
>
>With reference to the RISC-V summit keynote [1] single threaded
>performance is limiting due to Denard scaling and multi-threaded
>performance is slowing down due Moore's law limitations. With the rise
>of SNIA Computation Technical Storage Working Group (TWG) [2],
>offloading computations to the device or over the fabrics is becoming
>popular as there are several solutions available [2]. One of the common
>operation which is popular in the kernel and is not merged yet is Copy
>offload over the fabrics or on to the device.
>
>* Problem :-
>-----------------------------------------------------------------------
>
>The original work which is done by Martin is present here [3]. The
>latest work which is posted by Mikulas [4] is not merged yet. These two
>approaches are totally different from each other. Several storage
>vendors discourage mixing copy offload requests with regular READ/WRITE
>I/O. Also, the fact that the operation fails if a copy request ever
>needs to be split as it traverses the stack it has the unfortunate
>side-effect of preventing copy offload from working in pretty much
>every common deployment configuration out there.
>
>* Current state of the work :-
>-----------------------------------------------------------------------
>
>With [3] being hard to handle arbitrary DM/MD stacking without
>splitting the command in two, one for copying IN and one for copying
>OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
>candidate. Also, with [4] there is an unresolved problem with the
>two-command approach about how to handle changes to the DM layout
>between an IN and OUT operations.
>
>* Why Linux Kernel Storage System needs Copy Offload support now ?
>-----------------------------------------------------------------------
>
>With the rise of the SNIA Computational Storage TWG and solutions [2],
>existing SCSI XCopy support in the protocol, recent advancement in the
>Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
>DMA support in the Linux Kernel mainly for NVMe devices [7] and
>eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
>from Copy offload operation.
>
>With this background we have significant number of use-cases which are
>strong candidates waiting for outstanding Linux Kernel Block Layer Copy
>Offload support, so that Linux Kernel Storage subsystem can to address
>previously mentioned problems [1] and allow efficient offloading of the
>data related operations. (Such as move/copy etc.)
>
>For reference following is the list of the use-cases/candidates waiting
>for Copy Offload support :-
>
>1. SCSI-attached storage arrays.
>2. Stacking drivers supporting XCopy DM/MD.
>3. Computational Storage solutions.
>7. File systems :- Local, NFS and Zonefs.
>4. Block devices :- Distributed, local, and Zoned devices.
>5. Peer to Peer DMA support solutions.
>6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>
>* What we will discuss in the proposed session ?
>-----------------------------------------------------------------------
>
>I'd like to propose a session to go over this topic to understand :-
>
>1. What are the blockers for Copy Offload implementation ?
>2. Discussion about having a file system interface.
>3. Discussion about having right system call for user-space.
>4. What is the right way to move this work forward ?
>5. How can we help to contribute and move this work forward ?
>
>* Required Participants :-
>-----------------------------------------------------------------------
>
>I'd like to invite file system, block layer, and device drivers
>developers to:-
>
>1. Share their opinion on the topic.
>2. Share their experience and any other issues with [4].
>3. Uncover additional details that are missing from this proposal.
>
>Required attendees :-
>
>Martin K. Petersen
>Jens Axboe
>Christoph Hellwig
>Bart Van Assche
>Zach Brown
>Roland Dreier
>Ric Wheeler
>Trond Myklebust
>Mike Snitzer
>Keith Busch
>Sagi Grimberg
>Hannes Reinecke
>Frederick Knight
>Mikulas Patocka
>Keith Busch
>
>Regards,
>Chaitanya
>
>[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
>[2] https://www.snia.org/computational
>https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
>      https://www.eideticom.com/products.html
>https://www.xilinx.com/applications/data-center/computational-storage.html
>[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
>[4] https://www.spinics.net/lists/linux-block/msg00599.html
>[5] https://lwn.net/Articles/793585/
>[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
>namespaces-zns-as-go-to-industry-technology/
>[7] https://github.com/sbates130272/linux-p2pmem
>[8] https://kernel.dk/io_uring.pdf


I would like to participate in this discussion too.

Cc'in Selva and Kanchan, who have been posting several series for NVMe
Simple Copy (SCC). Even though SCC is a very narrow use-case of
copy-offload, it seems like a good start to start getting generic code
in the block layer.

Javier


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

