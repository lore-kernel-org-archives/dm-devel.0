Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB37C04A95
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 06:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664433132;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1xj8SiaOGFfhu8Aw8zpDP8E/dILt2QXr428m60RfiVY=;
	b=jLjdUlC0Q9PpRiBw6SEvdr4NQDuB21TP6w0FLhmdFkcSgbuEKshNeCuq63bW4oedmwA9nr
	LMpvGrdaoOUEze/sdVi6BYoon7V9voBJFRqr7cCA/m4JysQSjmsw9iynX9gWYQ1orBgcpK
	s7f7Vmsc4KZ/5RUIvn+9eUNS/2OZQnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-Yl-b2q9sPPm-AakxQx3t5w-1; Thu, 29 Sep 2022 02:32:10 -0400
X-MC-Unique: Yl-b2q9sPPm-AakxQx3t5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0833101A52A;
	Thu, 29 Sep 2022 06:32:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B89B140EBF3;
	Thu, 29 Sep 2022 06:32:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CF6F19465B5;
	Thu, 29 Sep 2022 06:32:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C271194658F
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Sep 2022 06:32:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A499C15BA5; Thu, 29 Sep 2022 06:32:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22820C15BA4
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 06:32:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07B20801231
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 06:32:03 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-SEdzKlKNPb6h1J7mUx_DOg-1; Thu, 29 Sep 2022 02:32:00 -0400
X-MC-Unique: SEdzKlKNPb6h1J7mUx_DOg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220929063159euoutp022c166161a1148674f8076343fb579fe1~ZQRqCPGL71545715457euoutp02N
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 06:31:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220929063159euoutp022c166161a1148674f8076343fb579fe1~ZQRqCPGL71545715457euoutp02N
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220929063158eucas1p2e9dfe7e042f4407b1a8bc83acf6b1bc2~ZQRpoIge52200622006eucas1p2v;
 Thu, 29 Sep 2022 06:31:58 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 8D.CB.19378.EDB35336; Thu, 29
 Sep 2022 07:31:58 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220929063158eucas1p1504a8b7423d26e3d427ff32a22f2d70b~ZQRpQs4MM1792417924eucas1p1V;
 Thu, 29 Sep 2022 06:31:58 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220929063158eusmtrp192f85e25440ac5cdf854e3c85b84e268~ZQRpPvFps1200512005eusmtrp1J;
 Thu, 29 Sep 2022 06:31:58 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-2b-63353bdec0a6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 31.79.10862.EDB35336; Thu, 29
 Sep 2022 07:31:58 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220929063158eusmtip167fe71d619027c04012f0cb080b70c37~ZQRpBlKjj1340213402eusmtip15;
 Thu, 29 Sep 2022 06:31:58 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.168) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 29 Sep 2022 07:31:56 +0100
Message-ID: <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
Date: Thu, 29 Sep 2022 08:31:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: Pankaj Raghav <p.raghav@samsung.com>
To: <axboe@kernel.dk>, <hch@lst.de>, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
X-Originating-IP: [106.210.248.168]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7r3rE2TDVY/NbZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS32LJrEZLFy9VEmiyfrZzFb/O26x2Qx6dA1Rou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLdbcfMpiceKWtIOAx+Ur3h47Z91l97h8ttRj06pONo/NS+o9dt9sYPPY2Xqf
 1eP9vqtAodPVHp83yXm0H+hmCuCO4rJJSc3JLEst0rdL4Mo4f+8dW8FlxorGPfoNjHMZuxg5
 OSQETCQmbXvO2sXIxSEksIJR4sm1OewQzhdGif+L9zFDOJ8ZJWY+38MM09LW+ZUFIrGcUWJR
 1xMWuKrOK01Q/bsZJXo79gK1cHDwCthJXD6bA9LNIqAq8XzHXLBJvAKCEidngjRzcogKREqs
 2X2WHaScTUBLorGTHSQsLBAt8eDQFyYQW0TAReJm7yGwi5gFvjBJzL++mxUkwSwgLnHryXwm
 kF5OAUuJ/sYaiLCmROv23+wQtrzE9rdzoB5Qllh+eiaUXSux9tgZsJMlBJ5xSvx5/YgNIuEi
 8ebPOiYIW1ji1fEt7BC2jMTpyT0sEHa1xNMbv5khmlsYJfp3rmcDOUJCwFqi70wORI2jxMfD
 T9ghwnwSN94KQtzDBwz36cwTGFVnIYXELCTfzELywiwkLyxgZFnFKJ5aWpybnlpsnJdarlec
 mFtcmpeul5yfu4kRmA5P/zv+dQfjilcf9Q4xMnEwHmKU4GBWEuH9fdQwWYg3JbGyKrUoP76o
 NCe1+BCjNAeLkjgv2wytZCGB9MSS1OzU1ILUIpgsEwenVAPTzLinYkkbJcWuWLmaTWic0pdS
 Z/PB//u5c4cFrdsul/2bduqk/OqDhXFxM2ql9nyfa+sicMv4/c9v8srR8yRK51xeFbG478NJ
 J4/OK893ijVOO1t4apeFw80g8/Taab9LF/+IuxSuvaqUxfiI9AFjruPJJw9/qlvAejv14k3e
 cw83vl639y3/c4VnpWdFd7zOTFJtj9gg+Gk7+4qnS0NKPftDFt26yG+gxL9zf77NU70SId20
 xiiuM22e5UbvdfOlJnVKuOd6CUgEpB891yNS9trtxZ9t/ww0p6xqmNXZFX4jtneybDTzmzaX
 qQ9PqyufeLDJbavl8hvL+VPU6je785n4RlfZaa3+/KTj4gY9JZbijERDLeai4kQAaSGnVvYD
 AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t/xu7r3rE2TDY5ekrJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS32LJrEZLFy9VEmiyfrZzFb/O26x2Qx6dA1Rou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLdbcfMpiceKWtIOAx+Ur3h47Z91l97h8ttRj06pONo/NS+o9dt9sYPPY2Xqf
 1eP9vqtAodPVHp83yXm0H+hmCuCO0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7Uy
 MlXSt7NJSc3JLEst0rdL0Ms4f+8dW8FlxorGPfoNjHMZuxg5OSQETCTaOr+ydDFycQgJLGWU
 +LDtHRNEQkbi05WP7BC2sMSfa11sEEUfGSXOn9wA1bGbUWLWnZVAGQ4OXgE7ictnc0AaWARU
 JZ7vmMsMYvMKCEqcnPmEBcQWFYiUeLisiQmknE1AS6KxE2y+sEC0xOUzT9hAbBEBF4mbvYeY
 QcYzC3xhkph/fTcrxK4eRomFy7eCdTALiEvcejIfbBCngKVEf2MNRFhTonX7b6gSeYntb+cw
 QzygLLH89Ewou1bi1f3djBMYRWchOW8WkqmzkIyahWTUAkaWVYwiqaXFuem5xUZ6xYm5xaV5
 6XrJ+bmbGIFJZNuxn1t2MK589VHvECMTB+MhRgkOZiUR3t9HDZOFeFMSK6tSi/Lji0pzUosP
 MZoCw2gis5Rocj4wjeWVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBK
 NTClHXvtNfHVFvEXvB5mL6dLqhZuKAlh/Wi05NxF5Z3fIv5XzDtzQCzpXpdNRDGD3K0SObZH
 7Pwf7p0XnM/71ats1syjUdfXtVtqMij5Jr5MLHHpFzi45lBcmATjhdezFM43qYhsvFuvuPDd
 ga2W+VekHm1Vcps1W26BR8OiLPfP5yNetqSnyq5/H52UP/Uyo4/ywvmdW/czneyaKKvosIYv
 eP/UatPgwt/7phVNC536YI1b7OEf9tq2bT5bZytK/Xu3o6DCziLk0uqgvmi/qGjfBMM5me+/
 b7U2EHb6E75t9Rnn5z2qijwh9ie+aRzPfKjPp2nqknCd/+tNPU9Vx2vxuR1aDaLls9d+/+4b
 1aDEUpyRaKjFXFScCADA9Ta9qwMAAA==
X-CMS-MailID: 20220929063158eucas1p1504a8b7423d26e3d427ff32a22f2d70b
X-Msg-Generator: CA
X-RootMTR: 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v15 00/13] support zoned block devices with
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Hi Jens,
>   Please consider this patch series for the 6.1 release.
> 

Hi Jens, Christoph, and Keith,
 All the patches have a Reviewed-by tag at this point. Can we queue this up
for 6.1?

--
Pankaj

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

