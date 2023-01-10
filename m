Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8A0C54EBE
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673340007;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CVACmr1iCmSlTWJYAuQtJ5a/7gcaStqjnmdNVVc4bmE=;
	b=ISIWSvQh1Xjz45srozDUOEXmq1MUzNdcjkPyDvQk8MTvZ/zfvfIvzOdGKpKg8ewO0kaZWP
	BnvTLmbXo1iWwFrzsc9L+B4saH5d//C+pEJr3CkkuSoKqVzkFRqYUe6JS12zCjyqnGMkSP
	MtushYc5XMaLI31siP3H/92wqS6RIVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-hNIjP3EFP8yM_b9g6cM93A-1; Tue, 10 Jan 2023 03:39:23 -0500
X-MC-Unique: hNIjP3EFP8yM_b9g6cM93A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C6A785C076;
	Tue, 10 Jan 2023 08:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06047140EBF4;
	Tue, 10 Jan 2023 08:39:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2E691940378;
	Tue, 10 Jan 2023 08:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 881341946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 08:39:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3531E1121318; Tue, 10 Jan 2023 08:39:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D1251121314
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 08:39:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FA1F857A84
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 08:39:19 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-4yNiDAUpPNq1KCZYpsgGkA-1; Tue, 10 Jan 2023 03:39:17 -0500
X-MC-Unique: 4yNiDAUpPNq1KCZYpsgGkA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230110083915euoutp0146d74be3c8f4fbf9cd4178ad92377d86~45dL-Iunl2262422624euoutp01R
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 08:39:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230110083915euoutp0146d74be3c8f4fbf9cd4178ad92377d86~45dL-Iunl2262422624euoutp01R
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230110083915eucas1p2e373a528e893339a83cb5c74002c3856~45dLp5blg2209722097eucas1p2M;
 Tue, 10 Jan 2023 08:39:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 49.35.43884.3342DB36; Tue, 10
 Jan 2023 08:39:15 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230110083915eucas1p18a4b032bf44b21f8733d0280acbf8688~45dLNThQk0606106061eucas1p1C;
 Tue, 10 Jan 2023 08:39:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230110083915eusmtrp2096c2edc072337b430b2b22f8dc0805f~45dLMeU5A2380423804eusmtrp27;
 Tue, 10 Jan 2023 08:39:15 +0000 (GMT)
X-AuditID: cbfec7f5-25bff7000000ab6c-0b-63bd24331d39
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 31.EC.23420.2342DB36; Tue, 10
 Jan 2023 08:39:14 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230110083914eusmtip26c71070d1d01301789f4728eca911ea0~45dK-lUgV3238632386eusmtip2A;
 Tue, 10 Jan 2023 08:39:14 +0000 (GMT)
Received: from [192.168.8.107] (106.210.248.241) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 10 Jan 2023 08:39:13 +0000
Message-ID: <01349d02-123d-3c49-bd92-8b8b3c645e1c@samsung.com>
Date: Tue, 10 Jan 2023 09:39:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To: Christoph Hellwig <hch@lst.de>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20230110065623.GD10289@lst.de>
X-Originating-IP: [106.210.248.241]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djP87rGKnuTDda8k7NYfbefzWLah5/M
 Fr/Pnme22PtuNqvFnkWTmCxWrj7KZPG36x6TxZmXn1ks9t7Stri8aw6bxfxlT9ktbkx4ymhx
 4pa0A6/H5SveHpfPlnpsWtXJ5rF5Sb3H7psNbB47W++zepxd6ejxft9VoPDpao/Pm+Q82g90
 MwVwR3HZpKTmZJalFunbJXBl/N91nLmgk7li/7br7A2MG5m6GDk5JARMJOb/ns3excjFISSw
 glFi/+/1UM4XRomLH5azQjifGSVanoCUQbQ0H+thhkgsZ5S4uvgSO1zVs5lXoTK7GSVWfloL
 1sIrYCfx/tkeVhCbRUBVYtaJRawQcUGJkzOfsIDYogJREk0XfoLZwgJBEk9fv2IDsZkFxCVu
 PZkPdq2IgJLE01dnGUEWMAs0Mkt8+HEfyOHgYBPQkmjsBNvFKaAjce/2L1aIXk2J1u2/2SFs
 eYntb+cwQ7ygLLH4wjVGCLtWYu2xM2AfSAhc45Q4sPosG0TCReLOm5VQRcISr45vgfpfRuL/
 zvnQ4KuWeHrjNzNEcwujRP/O9WwgB0kIWEv0ncmBqHGUWLN4FQtEmE/ixltBiHv4JCZtm848
 gVF1FlJQzELy8iwkL8xC8sICRpZVjOKppcW56anFxnmp5XrFibnFpXnpesn5uZsYgUnv9L/j
 X3cwrnj1Ue8QIxMH4yFGCQ5mJRHelZx7koV4UxIrq1KL8uOLSnNSiw8xSnOwKInzztg6P1lI
 ID2xJDU7NbUgtQgmy8TBKdXAlL704LdApc9rp2S8U7VgFmRwfZnUv/O3q03/g7K4HraKoEu/
 OlgLPfOlAh8z1GlF/V2QUhZxyj/DWPdMyFFPCZtpYYa/9aX7r5R+sszcbLGt2PhhW/XsDaZ7
 jgfaVr5/MmMym5nJseCviYtlV+xgX+XaVVsdZZl4qvuZ++fElfliDBwPt60v0M7+YXdxzpKj
 Ut6CnB1vHy51C1RflcdQHvR7jkluyfdFJnITbzjdXRB2yze+neP3ytDp348G2XnWv2RY8H5a
 kpL8zYiMif/KoqMOz6uQaH9w1ND63n6BKZ4H+0Q3pWt+yL7LzJRn/HJTnNZZZ2bD0Kr/d5IX
 OEy2C2B0OiZtyfhBRNtzRbISS3FGoqEWc1FxIgAjtb2z6QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e/4PV0jlb3JBhuf2VisvtvPZjHtw09m
 i99nzzNb7H03m9Viz6JJTBYrVx9lsvjbdY/J4szLzywWe29pW1zeNYfNYv6yp+wWNyY8ZbQ4
 cUvagdfj8hVvj8tnSz02repk89i8pN5j980GNo+drfdZPc6udPR4v+8qUPh0tcfnTXIe7Qe6
 mQK4o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy
 /u86zlzQyVyxf9t19gbGjUxdjJwcEgImEs3Hepi7GLk4hASWMkpMufUNKiEj8enKR3YIW1ji
 z7UuNhBbSOAjo8TShUIQDbsZJS7eucYIkuAVsJN4/2wPK4jNIqAqMevEIlaIuKDEyZlPWEBs
 UYEoiZvnH4ItEBYIknj6+hXYUGYBcYlbT+aDxUUElCSevjrLCLKAWaCRWeLDj/uMEJvvMkq8
 3azZxcjBwSagJdHYCXYcp4COxL3bv1gh5mhKtG7/zQ5hy0tsfzuHGeIBZYnFFyDulBColXh1
 fzfjBEbRWUjOm4XkjFlIRs1CMmoBI8sqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwDSx7djP
 zTsY5736qHeIkYmD8RCjBAezkgjvSs49yUK8KYmVValF+fFFpTmpxYcYTYFhNJFZSjQ5H5io
 8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamFY9nvJ2UUf15svC
 pv7K74QrP7xbbxrAInmnwyY76Kf9xhPVaaz8D9UtvJ1mMTzzNGCzCJi7raxlW/t9uePHd/3Y
 8rD32WG9RMMO/0PRvVvsj/HIrRcXceOZcfjh+RW9zoFTP29Z9DPlyprlizbM+Tev58P6mR3r
 EgrUToZ3TP3nybVyyUez7VsCT8Z6TVPks5G8EWIt7Gi8N/7uBZlq8b6N/dqHU2oj/4ea9mX5
 f19+aNYclnSlzL2PVyX4zH5zn7Hw5Mdd+yKezTTu33xz1VTj1ZoFqxeaJQic2ajMG3Vt4p1u
 I8FEdc6FZi7C/cnped5fDxw9Jd+19cKOJfzyc0+KajLcYfSY4GWg84b1fLASS3FGoqEWc1Fx
 IgD1OIivnAMAAA==
X-CMS-MailID: 20230110083915eucas1p18a4b032bf44b21f8733d0280acbf8688
X-Msg-Generator: CA
X-RootMTR: 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0@eucas1p2.samsung.com>
 <20230106083317.93938-6-p.raghav@samsung.com>
 <20230110065623.GD10289@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 5/7] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
Cc: axboe@kernel.dk, bvanassche@acm.org, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2023-01-10 07:56, Christoph Hellwig wrote:
> Given that we don't even support the non pow of 2 zones in the block
> layer I don't see why this is needed.  But either way it doesn't really
> seem to fit into this series.

You are right. It is just an extra stop gap, but it is not needed as block
layer does not support pow of 2 anyway! I will remove this patch in the
next version.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

