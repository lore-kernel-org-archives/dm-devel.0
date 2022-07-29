Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBDBC00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 07:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659080742;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5QHsrrgrgUMr7d8SgViySAgZxE0tYdZ/aHGLUpG1x8Q=;
	b=ZHyisCPM0Q+NRxQPwr26vDVbN3OfrnAqvK6OtYv3GOEwEbUimctgsOtZPiaJyuhLAiwVCc
	Nhc+0m8U3iXm2suCF7sDm2TctPK6rvnjMZQNHYqOrhwG5KUDFfrm4G5D6T00CjWeSewwFN
	OcD2CnzFDQ7Z2HoYYxoLkJNskRX6BIo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-BOIbuMLdNHeKP6Qye_WWeg-1; Fri, 29 Jul 2022 03:45:39 -0400
X-MC-Unique: BOIbuMLdNHeKP6Qye_WWeg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8315805AF5;
	Fri, 29 Jul 2022 07:45:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC2FD404E4BE;
	Fri, 29 Jul 2022 07:45:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DEE7193211F;
	Fri, 29 Jul 2022 07:45:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 054BC193211B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 07:45:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C47441121315; Fri, 29 Jul 2022 07:45:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C011B1121314
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:45:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C481C068C1
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:45:33 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-sKt1fWf8OkyMn5Fbe9XcVA-1; Fri, 29 Jul 2022 03:45:31 -0400
X-MC-Unique: sKt1fWf8OkyMn5Fbe9XcVA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220729074530euoutp0172cc3ddfffc74c53ad59c9a56246bb50~GPSJwQUgz1548115481euoutp01O
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:45:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220729074530euoutp0172cc3ddfffc74c53ad59c9a56246bb50~GPSJwQUgz1548115481euoutp01O
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220729074530eucas1p21ea3c19a45c637ef3d9ea2e96196ecd6~GPSJa76JX1134011340eucas1p2Z;
 Fri, 29 Jul 2022 07:45:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 80.93.10067.A1093E26; Fri, 29
 Jul 2022 08:45:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220729074530eucas1p270ac45caf3b18a52191551f8a743fa6d~GPSJFi8cZ2146621466eucas1p2q;
 Fri, 29 Jul 2022 07:45:30 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220729074530eusmtrp1b27a38390c4717b0777540433b641bf0~GPSJEg2ci2539025390eusmtrp1J;
 Fri, 29 Jul 2022 07:45:30 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-4a-62e3901aeb7b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 85.80.09038.A1093E26; Fri, 29
 Jul 2022 08:45:30 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220729074529eusmtip264c47380f46b3f8f37950cd2d57efb12~GPSI7HuWE0719907199eusmtip2D;
 Fri, 29 Jul 2022 07:45:29 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.8) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 29 Jul 2022 08:45:27 +0100
Message-ID: <4f6f9ea5-fac6-598d-fcaa-3cb24cb2d935@samsung.com>
Date: Fri, 29 Jul 2022 09:45:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <137b8772-a2cc-f195-1c0d-476214fabd52@opensource.wdc.com>
X-Originating-IP: [106.210.248.8]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djPc7pSEx4nGWzeLGWx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF51xw2i/nLnrJbTGj7ymxx
 Y8JTRos1N5+yWJy4Je3A73H5irfHzll32T0uny312LSqk81j85J6j903G9g8drbeZ/V4v+8q
 UOh0tcfnTXIe7Qe6mQK4o7hsUlJzMstSi/TtErgy7vx/zlawlqNi99ab7A2Md9m6GDk5JARM
 JKYvncfcxcjFISSwglHi45E9bBDOF0aJhY83sUI4nxkltr9eD9eyqG8OE0RiOaNE29GtzHBV
 04/OYodwdjJKnD34kwmkhVfATqL3yUbGLkYODhYBVYnlHU4QYUGJkzOfsIDYogKREmt2n2UH
 sYUFYiQO7TvGDGIzC4hL3HoyH2yMiEAPo8Tf3Ywg85kF1jFJtB69zgYyk01AS6Kxkx3E5BRw
 k7hwTRCiVVOidftvdghbXmL72znMEA8oSvR/3wD1TK3E2mNnwE6WEHjEKTF10ht2iISLxJ+O
 F4wQtrDEq+NboOIyEqcn97BA2NUST2/8ZoZobmGU6N+5HuweCQFrib4zORA1jhK3O1exQIT5
 JG68hbqNT2LStunMExhVZyGFxCwkH89C8sIsJC8sYGRZxSieWlqcm55abJSXWq5XnJhbXJqX
 rpecn7uJEZgGT/87/mUH4/JXH/UOMTJxMB5ilOBgVhLhFQh4nCTEm5JYWZValB9fVJqTWnyI
 UZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qByVxoTnbkSfY1HyRjjsZHC8c5NHK5JVbP
 1lppd8B47dUsZ0uF7buTzX3luFa9dmn6wrDWVCSII7RLduWqHZrLTq2TVDDnd3bli2t+KyZq
 6eXx1O2xw0FBN4YqvY4MK4Xfs/xCIl6IP/V+wqI9r2v2J1bhzzuXiMSdlokx5kl95HUkpndi
 g5dGlq7HzmKxX0cbrnP7GoskqzxlWan9KUvh/F+mziOiP6fK9USszFFa9+6Hj2P9RM/+NJ+j
 k2tLZ6fNaeBP2aPSHOzi8vXKq1dhrXzivBIqkofmPZnx4Ocm9YKOL9pKvjNPrfJTXXFuSfUF
 wVSuV3aPElwkyyPv14grluSyVb251vko/+Dql0osxRmJhlrMRcWJAArgzZzyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t/xe7pSEx4nGXzazGyx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF51xw2i/nLnrJbTGj7ymxx
 Y8JTRos1N5+yWJy4Je3A73H5irfHzll32T0uny312LSqk81j85J6j903G9g8drbeZ/V4v+8q
 UOh0tcfnTXIe7Qe6mQK4o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1s
 UlJzMstSi/TtEvQy7vx/zlawlqNi99ab7A2Md9m6GDk5JARMJBb1zWHqYuTiEBJYyiixe/di
 qISMxKcrH9khbGGJP9e6wOJCAh8ZJebfqIewdzJK7OnnAbF5Bewkep9sZOxi5OBgEVCVWN7h
 BBEWlDg58wkLiC0qECnxcFkTE4gtLBAjcWjfMWYQm1lAXOLWk/lgcRGBHkaJv7sZQe5hFljH
 JNF69DobxHG/GSXmPPwKtoBNQEuisZMdxOQUcJO4cE0QYo6mROv23+wQtrzE9rdzmCHOV5To
 /74B6q1aiVf3dzNOYBSdheS8WUjOmIVk1CwkoxYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P
 3cQITBzbjv3csoNx5auPeocYmTgYDzFKcDArifAKBDxOEuJNSaysSi3Kjy8qzUktPsRoCgyi
 icxSosn5wNSVVxJvaGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAtCCN
 4yzz8SWbsivOi2UUPt29712/WOD5tgVvdni80OdNYbpVuU3NXZGr8carlTWNIef5Tb7Mu3k2
 4YZlx9e1KRkfjn2qMzmpLnPN8ajpi40iSY8/zLSw0Pw7c8M8npOqOys+aESmxBSeLznToa2t
 uLmCybLj8OUHqww2sd87cnPaHDOP5HSuBw/EjrxYsJv9/P8iy/O/rrXq11vfqO9+bxf28wqX
 IMfRgPQs3ZM5Pb8mdN9qvjy3Ke2vfsSye6xmHUXvWZxPCT6SXvv6kqi4n9T7D1xaqsKRS0XF
 Dxeeei5+QSb3rsiRnS4q80q2OD5aITUrK9j89Cpuiyebt3o5a/3Y+njNgos3m+a/XFrZ76XE
 UpyRaKjFXFScCABRZxy8pQMAAA==
X-CMS-MailID: 20220729074530eucas1p270ac45caf3b18a52191551f8a743fa6d
X-Msg-Generator: CA
X-RootMTR: 20220727162250eucas1p133e8a814fee934f7161866122ef93273
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162250eucas1p133e8a814fee934f7161866122ef93273
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162250eucas1p133e8a814fee934f7161866122ef93273@eucas1p1.samsung.com>
 <20220727162245.209794-5-p.raghav@samsung.com>
 <137b8772-a2cc-f195-1c0d-476214fabd52@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 04/11] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-07-28 05:09, Damien Le Moal wrote:

>>  }
> 
> This change should go into patch 3. Otherwise, adding patch 3 only will
> break the nvme target zone code.
> 
Ok.
>>  
>>  static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 1be805223026..d1ef9b9552ed 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1350,6 +1350,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>>  	return BLK_ZONED_NONE;
>>  }
>>  
>> +static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
>> +{
>> +	return disk_zone_no(bdev->bd_disk, sec);
>> +}
>> +
> 
> This should go into a prep patch before patch 3.
> 
Bart commented in the earlier versions to see the new helpers along with
its usage instead of having it separately in a prep patch.

>>  static inline int queue_dma_alignment(const struct request_queue *q)
>>  {
>>  	return q ? q->dma_alignment : 511;
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

