Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1979C001B0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692018116;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=K+SOvsWFsEHvwP78i99qNlX84A9kvZr/PWkZG1lT2Vw=;
	b=HxKBELwC/4n4hMmW6ebMaNlDZ4syguDF1hCCqlvEq0kW9gwitsS4KFxhympeXFJ+L6mpuO
	pIWp0XrsY91ZO+RWIDX703Cs3yW8Tg74Y4sdsuaRPnpRwYmvdzVXOI4IPZQ+gLpaisNAgr
	4kmT+/2Ysf6ggkDt92aGNolTFLnIg6U=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-Aj4pF75bNKifaJTl6CfS6A-1; Mon, 14 Aug 2023 09:01:47 -0400
X-MC-Unique: Aj4pF75bNKifaJTl6CfS6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F22933C13504;
	Mon, 14 Aug 2023 13:01:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6694BC15BAE;
	Mon, 14 Aug 2023 13:01:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22DB21946587;
	Mon, 14 Aug 2023 13:01:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 874D51946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 13:01:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 740DA2026D76; Mon, 14 Aug 2023 13:01:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C1CC2026D68
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:01:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AA7C1C09A5C
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:01:36 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-uuieEEghPLa_I_hu-AP1PA-1; Mon, 14 Aug 2023 09:01:30 -0400
X-MC-Unique: uuieEEghPLa_I_hu-AP1PA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230814130113epoutp02757ab29cdad2090b8992269b7e292131~7QXkI65MT2338223382epoutp02u
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:01:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230814130113epoutp02757ab29cdad2090b8992269b7e292131~7QXkI65MT2338223382epoutp02u
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230814130112epcas5p4911f9a9e6f010a347b48734a3237a9e6~7QXjHSw3B3072830728epcas5p4X;
 Mon, 14 Aug 2023 13:01:12 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4RPZK22WlHz4x9Pr; Mon, 14 Aug
 2023 13:01:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 58.C3.55522.6952AD46; Mon, 14 Aug 2023 22:01:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230814121319epcas5p32e02f82561b4040f8e3fb7c7410b6de5~7PtvgeQaE2140321403epcas5p3E;
 Mon, 14 Aug 2023 12:13:19 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230814121319epsmtrp2479bbf33206258a34d03825743a7e8e3~7PtvfUa9o0884008840epsmtrp2I;
 Mon, 14 Aug 2023 12:13:19 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-83-64da2596b55e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 7D.55.30535.E5A1AD46; Mon, 14 Aug 2023 21:13:18 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230814121315epsmtip264aaea99f00073a95cc0b32dd5a0ebd7~7PtsahaFA0358203582epsmtip2d;
 Mon, 14 Aug 2023 12:13:15 +0000 (GMT)
Date: Mon, 14 Aug 2023 17:39:59 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20230814120959.ridr6xptirlcjkty@green245>
MIME-Version: 1.0
In-Reply-To: <355bb623-9cd9-fe33-106e-1f091c09fb32@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVCTdRzv9zzPxjO6eY+86M9pOudxF/NANsb6ARKmnD1l3XF1epVXa7In
 IGCbe1GyTKA0kFchSEaCprxtxFtmBI10KEzAzCPexoFcB2oguKBI4sU2Njr/+/w+n+/n9327
 L4l7ZXjwyHiljtEo5YkCtidxpc1fGFDkZ1MEDf3uieo623GUlreEI9NwLhtNts0AVGSfx9HY
 1S8AGv05EpmnS1ho8OqPGKo23cBQvqUPoPFeA4bMtu3owqlLBPrJfJNAPc1fs1FZxbgHquxY
 xtBA3jhAtZOPCGS1bUS3lzpYu9bRPb/to2+PNBB0zy093WjMYNPfXTpBtwymsOmLOQUsOvuz
 aTb957iNoB+19rLpnMtGQM82bqYbx6awaO47CTvjGLmC0fAZZYxKEa+MjRDse1O2RxYiDRIF
 iELRCwK+Up7ERAiiXosO2Buf6OhZwD8iT9Q7qGi5VivY8eJOjUqvY/hxKq0uQsCoFYlqiTpQ
 K0/S6pWxgUpGFyYKChKHOALfT4hb7F/A1AMeyaXzuewUcJ19GnBISElg5UiBA3uSXlQLgLbM
 +8ApeFEzALYN6V3CHICWr9I9Vh1D6Rcxl2AGcH6iELge9wAcaq5gOaMIyg8au1IdDpJkU9th
 1xPSSftQz8O50UrCGY9TxSx4paYUdwreVAIsHupjO+O5lBTmFx5z0lxqLbxZPEY4MYcKh2Vd
 uStF+FKb4Nnyv3HnP5Aq48CHlnPAVV0UNFrbcRf2hhMdl91V8+DstNnd81FY/WUV22X+HEBD
 v8FtjoQnO3NXzDgVB+sHUwkX/xws7KzFXPwamL0whrl4LmwqXcXbYE3deXeCDbDvn1Q3puHZ
 6R/c47IDWGu6QOSBLYanujM8lc+Fw2CGPY1lcAwDpzbCymXSBf1hXfOO84BlBBsYtTYpltGG
 qEVK5uj/G49RJTWClZsQvtIEhkftgRaAkcACIIkLfLhZXJvCi6uQf3SM0ahkGn0io7WAEMey
 zuA83xiV46iUOplIEhokkUqlktBgqUiwnjt58pzCi4qV65gEhlEzmlUfRnJ4KdjahUy/V2+x
 eM+W/5HVY/DZOtEQpEonDe0fK6vEr8+Wt5B+rd8WNE8tYMH2w38txr0XwLdydr8UnN/9iZWo
 3rqFOvxr8ofcT5OzxLrQTtMHp5U6vO7I/g7ZxIGa3vB3eQcfm4yl166X8Eus7WnNsvBD/45P
 HJT+chzOmk/cW79mc/39499vUgq9aWyyVSx6IyH+Wk/2tidC/yru3EDF2w/8Ti0bxTK0J18W
 2t2Ssq6nIZR150xaXf/eJt+CIXuaOCxYQd+JGYm8awpTdz4wSHb5iQYjD1hfPiSa4vDrH6bu
 Ll9sNM1kBmu6jbpvHnOFz+RY7y7diGrU1yikRftZb9ntwwJCGycXCXGNVv4fIjC6FJwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRjG+c45OzsbrY7T6stZxigqLS/d/CqpIKFTUa3yrwprupOGbo4d
 L2kXraBU8lJh2MrKtEmTNKd0U0unTkvUcDnymLZoVjC8l2Cp5ZSo/x6e5/e87wsvhUubCU/q
 pCaO1WmUMXJSTDypl3uvCfPkVQGFuUGo7I0FRxdyJnFU0pNNImf9CEA3hsZx5Ki9DJD91TZU
 M3BLgLpqn2PoYUkjhq6ZbQD1deoxVMP7ooJLRQSqrnlNIOuL2yS6a+gTouKmKQy9z+kDqNQ5
 SKBmXobaJ5sE2xcw1nd7mPbecoKxtsYzJmM6yVQUpTBVXakkU5h1XcBkXhwgmeE+nmAGX3aS
 TFalETCjpiWMydGPKSSHxcEqNuZkAqvz33pcHPXyUQ+mzRCcuj9URqSCHCIDiChIr4fdaYWY
 S0vpKgD570Gz/iJomGzAZ7U7fDj1VZgBxNOMA8DeiRcCV0DQy6Gx5fx0QFEk7QtbflMu24Ne
 CcfsxYSLx+l8ATT8ahe6Anc6GvZYykgXL6E3wmu5ybN7hwBML5G4tIR2g69vOmZuw6eROxWf
 cBeO0zJYPDUzXkRvgXdbsmcmzqe9YN6DH3gOcNP/19b/19b/a98DuBEsYrWcOlLNBWrXathE
 P06p5uI1kX4RsWoTmHm2j88zUG0c8jMDjAJmAClc7iG5IuFVUolKmZTM6mKP6eJjWM4MZBQh
 XygZc2aqpHSkMo6NZlktq/ubYpTIMxV7mqgcEb1VN9l2997XH4lIaPj4pWvNwitz8RSvmHyH
 uGNj4NIC61Zt9+5d4QX+AT/P7Wz9LFzKJeKnbXHFy5zNAzvEO1PeVde5BY+TQb11wtDFzpAW
 +SN9NRbybd9wYaOhU73y00FrnW17XIjHruxR/ucHWV5Wh/fR7vB+fxPY43598MSgXbicfxW7
 7kHlPHXyY7/9mzu9z2rj+TSp/mZER+Ot1hL7aH158yHmRumWkbdG7Z2OOUkKUbTF98yGhAlq
 27ngtLzQ1YccbUGbci+nZTR8bpPFEulcRL5FETUC7Ap/g1kxrvgtnuCLpAcyhfTzMI3Xiqur
 inItvO3g3io5wUUpA31wHaf8A6ifNtlbAwAA
X-CMS-MailID: 20230814121319epcas5p32e02f82561b4040f8e3fb7c7410b6de5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
 <20230811105300.15889-3-nj.shetty@samsung.com>
 <355bb623-9cd9-fe33-106e-1f091c09fb32@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy
 offload in block and request layer.
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 mcgrof@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_548ca_"

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_548ca_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/11 02:58PM, Bart Van Assche wrote:
>On 8/11/23 03:52, Nitesh Shetty wrote:
>>We expect caller to take a plug and send bio with source information,
>>followed by bio with destination information.
>>Once the src bio arrives we form a request and wait for destination
>>bio. Upon arrival of destination we merge these two bio's and send
>>corresponding request down to device driver.
>
>Is the above description up-to-date? In the cover letter there is a 
>different description of how copy offloading works.
>
Acked, This description is up to date.
We need to update this description in cover letter.

Thank you,
Nitesh Shetty

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_548ca_
Content-Type: text/plain; charset="utf-8"


------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_548ca_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_548ca_--

