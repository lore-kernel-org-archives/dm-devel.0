Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217B7EB64DC
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jun 2023 07:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688024871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=yIM4xftZOP6Zc5bcRZaKOAujqg81UidrVe0ZOXgngQ4=;
	b=i2u4FR36/ICfHQKhGdB2MspjOWGTk2zOKiFmNK3+7LO/dbaCJLO8CMUoBC5B7aeAh70U7l
	K4Z6FcdqJZgFd+KDlLaeY+CbEa4cQ0JGCfe2kGO0oQ1nTd++A9RAPAjmGI7g7oJqTeWX/Z
	TjRfgIlBUJyrl/zan/DTDQ6lDbJMW14=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-q0CAH4DqP5ChuDDKP0gp5w-1; Thu, 29 Jun 2023 03:47:47 -0400
X-MC-Unique: q0CAH4DqP5ChuDDKP0gp5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A92EF8E4691;
	Thu, 29 Jun 2023 07:47:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F2A3200B677;
	Thu, 29 Jun 2023 07:47:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D4481946594;
	Thu, 29 Jun 2023 07:47:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E84E01946A47
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Jun 2023 07:47:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EEE9C09A07; Thu, 29 Jun 2023 07:47:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16D8BC00049
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC4B08E468B
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:26 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-KImflgxeN-GQgdNIdokc_Q-1; Thu, 29 Jun 2023 03:47:24 -0400
X-MC-Unique: KImflgxeN-GQgdNIdokc_Q-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230629074721epoutp0356f91630f5a8e99f4212ff60a771efc4~tEaZl7Qsq1909919099epoutp03o
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230629074721epoutp0356f91630f5a8e99f4212ff60a771efc4~tEaZl7Qsq1909919099epoutp03o
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230629074720epcas5p232417c589dd39baaf9197af4aeffd5ee~tEaY1u7Zy0281902819epcas5p2C;
 Thu, 29 Jun 2023 07:47:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Qs9X71yKkz4x9Pt; Thu, 29 Jun
 2023 07:47:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 FB.7C.55522.7073D946; Thu, 29 Jun 2023 16:47:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230628153833epcas5p1fb3e3b663e0c6bfa3c27c29eba58da2f~s3MhNtqOk1574915749epcas5p15;
 Wed, 28 Jun 2023 15:38:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230628153833epsmtrp2313aba390ce5d0f56027041718a42f10~s3MhMR0012480824808epsmtrp2e;
 Wed, 28 Jun 2023 15:38:33 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-b8-649d3707f2f7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4D.81.30535.8F35C946; Thu, 29 Jun 2023 00:38:32 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230628153828epsmtip2f0361a34b48a05a789ba3d1f0c5c9c24~s3MdD-p9q1086610866epsmtip20;
 Wed, 28 Jun 2023 15:38:28 +0000 (GMT)
Date: Wed, 28 Jun 2023 21:05:18 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <dlemoal@kernel.org>
Message-ID: <20230628153518.xquaulfmevdaa6d4@green245>
MIME-Version: 1.0
In-Reply-To: <0d05d74e-48c5-2b99-dc28-482dc717e508@kernel.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUZRSfb+/u5eLM0mWF+nhkdMtA3puwfBCIJdFNCnEamkYzXNgrMOwu
 2+4SkhPxUhHkzRYsWooUCIzIIg5PQ0gQsKh47EC8xpYCQSBIEA2IZaH673d+53d+53znzEdg
 PI2RJREpVTJyqVBM4TvYN9v22DkZeVwUuU52EKiqqx1DSdmrGKoYycLRdNsCQF/Mr2BI13IW
 oF6dCRr/zhc1zxZx0GBLPQs1Feey0NWKOyx0Z/0hjnJbBwCa6FezUPOQA7p8poSNmpo72ai3
 4QKOvv52wgila+twVNqxxkKtecksVKdLBOja9Bwb3R2yQj2rHRz09PEFfL813dsXQNerR4zo
 ntFqNl1TZk/3/hBDa8rP4XRNyed042ACTl/JzOPQGcmzOP3nxBCbnrvVj9OZN8oBXdN9il7U
 7KI1uoesIPJIlHcEIxQxchtGGhYtipSG+1AB74UcCHEXuPKd+J7Ig7KRCiWMD+X3TpCTf6R4
 YzuUzSdCccwGFSRUKCiXfd7y6BglYxMRrVD6UIxMJJa5yZwVQokiRhruLGWUXnxX11fdN4TH
 oyLa8xc4skLByZ4zKjwBlDqmAWMCkm5wbj2NkwZ2EDyyEcDpn6pZhmABwNXys5ghWAJwJrOL
 s13Sd7dxS9UM4Fh67ZbqdwA7tKu4XsUmd8OWicWNBEHgpAPsXif0tBlpC1V5TUCvx8hqHN6e
 WsX0iZ1kMFTVl7H1mEsKYHZ6EseATWFnoY6t9zEm98HKFKmeNietYcE3jzb7QnLIGDapkjDD
 dH5wrCGTZcA74YOOG0YGbAkXZ5txA46FV/PLcENxCoBqrRoYEr7wdFfW5tAYGQEzVk4Z6Oeh
 quvapidGmsCMp7otfy6s+2obvwQrqy5t+VvAgeXELUzDv/oKt7a1CGCxKgdkgxfU/3ub+r92
 6s0WXvDcfBLHQFvB0jXCAPfAqgaXS4BTDiwYmUISzijcZXwpE/vvwcOiJRqw+Xns364DI+Pz
 zq2ARYBWAAmMMuP+OlMk4nFFwrhPGXl0iDxGzChagfvGqXIwS/Ow6I3fJ1WG8N08Xd0EAoGb
 514Bn3qO23YvQ8Qjw4VKJophZIx8u45FGFsmsByIojaFT9xRds7B2fd/0fofZnJuVixovK7f
 fuVep6cLgY2s1o4uX979jDzLcTzx1tyhxi7dwQOP6+yGT6c/sIqv5R6dLX0rV272Qfz5JdsS
 E+pKaLyo+MezjhW+h3RvxKRmBR4efjddMrbfejB5kG9S4eKXNZCmph0klIYntlCUeVefPxIf
 XOc12d/96I8n3nu7ecF2K4kNvqn0TOhQcEH2MXv/2AAf3nWLTtf8OZSb+NuT8JPWg2/GTUpa
 KnneKTYc09eZD0dDp4o8prRf3n/2hGn9xUC2UUvwinaIY4vpfl5+7aO/qeMnhtNe/F6U+tmS
 h67g/tIx1VrgOM/85Y9nYPsuiq2IEPLtMblC+A+NzTluxQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7bCSvO6P4DkpButbbCzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFpef8Fk82G9vsffdbFaLmwd2MlnsWTSJyWLl6qNMFkf/
 v2WzmHToGqPF06uzmCz23tK2WNi2hMViz96TLBaXd81hs5i/7Cm7Rff1HWwWy4//Y7I4NLmZ
 yWLHk0ZGi3Wv37NYnLglbXH+73FWi98/5rA5yHhcvuLtsXPWXXaP8/c2snhsXqHlcflsqcem
 VZ1sHpuX1HvsvtnA5rG4bzKrR2/zOzaPj09vsXi833eVzaNvyypGj82nqz0+b5Lz2PTkLVOA
 QBSXTUpqTmZZapG+XQJXxtV5LgWnjStmn//F2sD4WbOLkZNDQsBE4sqJ3UxdjFwcQgK7GSW2
 L/3EBpGQlFj29wgzhC0ssfLfc3aIoieMEgveTWUBSbAIqEocePoZqIiDg01AW+L0fw6QsIiA
 usTUyXsYQeqZBTazSdx/tgWsXlggVGLqzhVgNq+AmcSE7iZWiKGfGSW+XbzEBJEQlDg58wlY
 ETNQ0bzND8EWMAtISyz/xwFicgrYSaxpyQOpEBWQkZix9CvzBEbBWUiaZyFpnoXQvICReRWj
 ZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnC60NLawbhn1Qe9Q4xMHIyHGCU4mJVEeG+/
 mZ0ixJuSWFmVWpQfX1Sak1p8iFGag0VJnPfb694UIYH0xJLU7NTUgtQimCwTB6dUA5NUeWb2
 pweHlmheYgz48TwpvF3eVbCHs+RJrv8Pla2mv631vE/3TdT54nuaZab4rp9uHW2X5EwrRX8s
 uFS56rg5I+O9a25ZT97pvWlwOjfRkvVbid+v+MopxkURl1n50kXbPbOzFc449M9XuVu7K9rO
 5PqkpnPBizd0sTevmiNxmJPhnULju8IfWtH83n8vunf1BPTvYjz3pvmnx/8YvVfbik8qmZqn
 7N+6JZSZ6/Ssz2cY2LReFOSplVXu5Pqkv17hHFvJtDNfBJK276s+1xAhe6Pz4fpXzyae/XC3
 Xz7k0n6X2/eNL/0TV5f9eSb+gixvEafTk+YtW4vS9fdGma3t2/9stbHQTDvRnnlr1ZRYijMS
 DbWYi4oTAX+XRdOGAwAA
X-CMS-MailID: 20230628153833epcas5p1fb3e3b663e0c6bfa3c27c29eba58da2f
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184000epcas5p1c7cb01eb1c70bc5a19f76ce21f2ec3f8
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184000epcas5p1c7cb01eb1c70bc5a19f76ce21f2ec3f8@epcas5p1.samsung.com>
 <20230627183629.26571-2-nj.shetty@samsung.com>
 <0d05d74e-48c5-2b99-dc28-482dc717e508@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 1/9] block: Introduce queue limits for
 copy-offload support
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_95eb8_"

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_95eb8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/28 03:40PM, Damien Le Moal wrote:
>On 6/28/23 03:36, Nitesh Shetty wrote:
>> Add device limits as sysfs entries,
>>         - copy_offload (RW)
>>         - copy_max_bytes (RW)
>>         - copy_max_bytes_hw (RO)
>>
>> Above limits help to split the copy payload in block layer.
>> copy_offload: used for setting copy offload(1) or emulation(0).
>> copy_max_bytes: maximum total length of copy in single payload.
>> copy_max_bytes_hw: Reflects the device supported maximum limit.
>>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>  Documentation/ABI/stable/sysfs-block | 33 +++++++++++++++
>>  block/blk-settings.c                 | 24 +++++++++++
>>  block/blk-sysfs.c                    | 63 ++++++++++++++++++++++++++++
>>  include/linux/blkdev.h               | 12 ++++++
>>  include/uapi/linux/fs.h              |  3 ++
>>  5 files changed, 135 insertions(+)
>>
>> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
>> index c57e5b7cb532..3c97303f658b 100644
>> --- a/Documentation/ABI/stable/sysfs-block
>> +++ b/Documentation/ABI/stable/sysfs-block
>> @@ -155,6 +155,39 @@ Description:
>>  		last zone of the device which may be smaller.
>>
>>
>> +What:		/sys/block/<disk>/queue/copy_offload
>> +Date:		June 2023
>> +Contact:	linux-block@vger.kernel.org
>> +Description:
>> +		[RW] When read, this file shows whether offloading copy to a
>> +		device is enabled (1) or disabled (0). Writing '0' to this
>> +		file will disable offloading copies for this device.
>> +		Writing any '1' value will enable this feature. If the device
>> +		does not support offloading, then writing 1, will result in an
>> +		error.
>
>I am still not convinced that this one is really necessary. copy_max_bytes_hw !=
>0 indicates that the devices supports copy offload. And setting copy_max_bytes
>to 0 can be used to disable copy offload (which probably should be the default
>for now).
>

Agreed, we will do this in next iteration.

>> +
>> +
>> +What:		/sys/block/<disk>/queue/copy_max_bytes
>> +Date:		June 2023
>> +Contact:	linux-block@vger.kernel.org
>> +Description:
>> +		[RW] This is the maximum number of bytes that the block layer
>> +		will allow for a copy request. This will is always smaller or
>
>will is -> is
>

acked

>> +		equal to the maximum size allowed by the hardware, indicated by
>> +		'copy_max_bytes_hw'. An attempt to set a value higher than
>> +		'copy_max_bytes_hw' will truncate this to 'copy_max_bytes_hw'.
>> +
>> +
>> +What:		/sys/block/<disk>/queue/copy_max_bytes_hw
>
>Nit: In keeping with the spirit of attributes like
>max_hw_sectors_kb/max_sectors_kb, I would call this one copy_max_hw_bytes.
>

acked, will update in next iteration.

>> +Date:		June 2023
>> +Contact:	linux-block@vger.kernel.org
>> +Description:
>> +		[RO] This is the maximum number of bytes that the hardware
>> +		will allow for single data copy request.
>> +		A value of 0 means that the device does not support
>> +		copy offload.
>> +
>> +
>>  What:		/sys/block/<disk>/queue/crypto/
>>  Date:		February 2022
>>  Contact:	linux-block@vger.kernel.org
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 4dd59059b788..738cd3f21259 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -59,6 +59,8 @@ void blk_set_default_limits(struct queue_limits *lim)
>>  	lim->zoned = BLK_ZONED_NONE;
>>  	lim->zone_write_granularity = 0;
>>  	lim->dma_alignment = 511;
>> +	lim->max_copy_sectors_hw = 0;
>> +	lim->max_copy_sectors = 0;
>>  }
>>
>>  /**
>> @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>>  	lim->max_dev_sectors = UINT_MAX;
>>  	lim->max_write_zeroes_sectors = UINT_MAX;
>>  	lim->max_zone_append_sectors = UINT_MAX;
>> +	lim->max_copy_sectors_hw = UINT_MAX;
>> +	lim->max_copy_sectors = UINT_MAX;
>>  }
>>  EXPORT_SYMBOL(blk_set_stacking_limits);
>>
>> @@ -183,6 +187,22 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
>>  }
>>  EXPORT_SYMBOL(blk_queue_max_discard_sectors);
>>
>> +/**
>> + * blk_queue_max_copy_sectors_hw - set max sectors for a single copy payload
>> + * @q:  the request queue for the device
>> + * @max_copy_sectors: maximum number of sectors to copy
>> + **/
>> +void blk_queue_max_copy_sectors_hw(struct request_queue *q,
>> +		unsigned int max_copy_sectors)
>> +{
>> +	if (max_copy_sectors > (COPY_MAX_BYTES >> SECTOR_SHIFT))
>> +		max_copy_sectors = COPY_MAX_BYTES >> SECTOR_SHIFT;
>> +
>> +	q->limits.max_copy_sectors_hw = max_copy_sectors;
>> +	q->limits.max_copy_sectors = max_copy_sectors;
>> +}
>> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors_hw);
>> +
>>  /**
>>   * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
>>   * @q:  the request queue for the device
>> @@ -578,6 +598,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>  	t->max_segment_size = min_not_zero(t->max_segment_size,
>>  					   b->max_segment_size);
>>
>> +	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
>> +	t->max_copy_sectors_hw = min(t->max_copy_sectors_hw,
>> +						b->max_copy_sectors_hw);
>> +
>>  	t->misaligned |= b->misaligned;
>>
>>  	alignment = queue_limit_alignment_offset(b, start);
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index afc797fb0dfc..43551778d035 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -199,6 +199,62 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
>>  	return queue_var_show(0, page);
>>  }
>>
>> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
>> +{
>> +	return queue_var_show(blk_queue_copy(q), page);
>> +}
>> +
>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
>> +				       const char *page, size_t count)
>> +{
>> +	unsigned long copy_offload;
>> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (copy_offload && !q->limits.max_copy_sectors_hw)
>> +		return -EINVAL;
>> +
>> +	if (copy_offload)
>> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
>> +	else
>> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
>> +
>> +	return count;
>> +}
>
>See above. I think we can drop this attribute.
>
acked

Thank you, 
Nitesh Shetty

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_95eb8_
Content-Type: text/plain; charset="utf-8"


------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_95eb8_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_95eb8_--

