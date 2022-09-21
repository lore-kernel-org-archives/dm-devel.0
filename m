Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF99C6FA90
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663781759;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+g0Bcm59Q2POB3ONkCohsAuZY1k8layHtg5Q4whioGY=;
	b=c0uXDzfUhlcGa3r2Mgeb77STFm5wjRoXE7u5gWX8War4W878icLsYB7j8ViX39CETmdmxs
	s5PXLLN0JaSPdeRYabXLkZ0cx6Fz0ieVhnkWNLScSPa0m+T0IETI9SSmBNDqnBKvqExGaP
	MZpkIWWvwBq2k+pd02O3RWh1ld4eGek=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-6wI0hTXLNPqDxxxLKsZ5-Q-1; Wed, 21 Sep 2022 13:35:57 -0400
X-MC-Unique: 6wI0hTXLNPqDxxxLKsZ5-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41F9E803520;
	Wed, 21 Sep 2022 17:35:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E279AC15BA4;
	Wed, 21 Sep 2022 17:35:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8046019465B9;
	Wed, 21 Sep 2022 17:35:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9137B19465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 17:32:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81F99492B07; Wed, 21 Sep 2022 17:32:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A4BF492B04
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 17:32:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55E341C05EB9
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 17:32:56 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-mojkpyWxOdq9RcBtjggDxA-1; Wed, 21 Sep 2022 13:32:51 -0400
X-MC-Unique: mojkpyWxOdq9RcBtjggDxA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220921173250euoutp021f35d889e9061be931faadb96d9075d3~W8IXgwxUo0542505425euoutp02X
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 17:32:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220921173250euoutp021f35d889e9061be931faadb96d9075d3~W8IXgwxUo0542505425euoutp02X
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220921173249eucas1p205c67c6120e3314a1324332e3c725528~W8IWuikMW0485404854eucas1p2f;
 Wed, 21 Sep 2022 17:32:49 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 52.87.19378.1CA4B236; Wed, 21
 Sep 2022 18:32:49 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220921173248eucas1p23403baa578aa335747fb8a62145a577f~W8IWL9LNd0562805628eucas1p2p;
 Wed, 21 Sep 2022 17:32:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220921173248eusmtrp1119dd3978522ddbd060337edcc92edd2~W8IWLHoqA1591515915eusmtrp1V;
 Wed, 21 Sep 2022 17:32:48 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-1a-632b4ac1bb46
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 0A.7B.10862.0CA4B236; Wed, 21
 Sep 2022 18:32:48 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220921173248eusmtip2825416e5fdc058383a65eb9819720136~W8IWAmJkC2186421864eusmtip20;
 Wed, 21 Sep 2022 17:32:48 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.192) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 21 Sep 2022 18:32:46 +0100
Message-ID: <fc7d88a5-f65b-3962-22e5-cc393535d66d@samsung.com>
Date: Wed, 21 Sep 2022 19:32:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@redhat.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <Yys9sTqCIzxVFwyX@redhat.com>
X-Originating-IP: [106.210.248.192]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87oHvbSTDT4c4rNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWqxcfZTJ4sn6WcwWf7vuAcVuaVtc3jWHzWL+sqfsFhPa
 vjJbrLn5lMXixC1pi7aNXxkdBDwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we
 7/ddZfP4vEnOo/1AN1MAVxSXTUpqTmZZapG+XQJXRsuJSSwFLcIVt+9MYGxgbOHvYuTkkBAw
 kTh3bgtbFyMXh5DACkaJXSv3s0I4XxglGpdeYoJwPjNK9De/ZINpWTHnMSOILSSwnFHiw2E/
 uKKPPxrYIZzdjBJ91zYAdXBw8ArYSbSvkAVpYBFQlXi29BgTiM0rIChxcuYTFhBbVCBSYs3u
 s+wgtrBAtsSrC9PAFjALiEvcejKfCWSMCFDvrWkuIOOZBQ4xS6xrew0WZxPQkmjsBGvlBDIP
 vvzKAtGqKdG6/Tc7hC0vsf3tHGaI+5UlZt6cCmXXSqw9dgbsZAmBR5wSv873QD3pInG28yQj
 hC0s8er4FnYIW0bi9OQeFgi7WuLpjd/MEM0twBDauR7sXwkBa4m+MzkQNY4S565uYocI80nc
 eCsIcQ+fxKRt05knMKrOQgqJWUg+noXkhVlIXljAyLKKUTy1tDg3PbXYOC+1XK84Mbe4NC9d
 Lzk/dxMjMA2e/nf86w7GFa8+6h1iZOJgPMQowcGsJMI7+45mshBvSmJlVWpRfnxRaU5q8SFG
 aQ4WJXFethlayUIC6YklqdmpqQWpRTBZJg5OqQamlun7tzMdF9oxaYZZlnzYkncdod/m51V4
 btu54+2p8HLrC/f1+m8cyV7kUf/64ErVmdM4PlbOWHdi7buJX/JCe5s/zrTh+c+qsE/0PMec
 FbLrivoPG/rPlYpk/PvX9ON79eveJ+ICjqpMcWt71qJ8qO+Wg4OT5ocSle2rWt4VXA1bV6nE
 7To/6L7O7KDo+6bikmaGVzeZTIrN5j8vs+Bj+7PuWWKiJR/C/H7PeHr/QHDXVLEwhnWMXR9F
 hPr0Io9c+3Rm3Y5Hro4zb2e/0WZyPz+L52T43CDr3t5rr5X4BBYtFb9kMvGfnfyzb0oBx53F
 T002eWetZXX6i/La3zLe1xand6/zYL2v13Odq+THCSWW4oxEQy3mouJEAGmuP8jyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t/xe7oHvLSTDX62aFisP3WM2WL13X42
 i2kffjJb/D57ntmitf0bk8Xed7NZLVauPspk8WT9LGaLv133gGK3tC0u75rDZjF/2VN2iwlt
 X5kt1tx8ymJx4pa0RdvGr4wOAh6Xr3h77Jx1l93j8tlSj02rOtk8Ni+p99h9s4HNY2frfVaP
 9/uusnl83iTn0X6gmymAK0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
 JiU1J7MstUjfLkEvo+XEJJaCFuGK23cmMDYwtvB3MXJySAiYSKyY85ixi5GLQ0hgKaPE3et/
 WSESMhKfrnxkh7CFJf5c62KDKPrIKPH+6FVmCGc3o8S2B/OAqjg4eAXsJNpXyII0sAioSjxb
 eowJxOYVEJQ4OfMJC4gtKhAp8XBZE1hcWCBb4tWFaYwgNrOAuMStJ/OZQMaIAPXemuYCMp5Z
 4BCzxLq210wQu+4xSmzufc0GUsQmoCXR2Al2HCeQefDlVxaIOZoSrdt/s0PY8hLb385hhnhA
 WWLmzalQdq3Eq/u7GScwis5Cct4sJGfMQjJqFpJRCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl
 5+duYgSmj23Hfm7Zwbjy1Ue9Q4xMHIyHGCU4mJVEeGff0UwW4k1JrKxKLcqPLyrNSS0+xGgK
 DKOJzFKiyfnABJZXEm9oZmBqaGJmaWBqaWasJM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cDk
 K6PW+rD/4XSJvANHuOwzNaXkbr7S3JDJtf/hrVPCPDPYJ+bsMw1WvSDQeC5+CY8MG+NbVXmH
 61PmGh2YlWG83Id5c5/T/IgPBeHzrVifWz9ZbClnPPdAmInT4XD7yLTfoQoszSsjNlUcWp3t
 dC5Yys8yo1bwBsOPJZ/LuA6GZbcVuf9+9+yJX6ZlTrEDm9TWD5rNLT2fTzqdZF66bkPY8o65
 qaFs5mm55REn4s7UND6c2pY+a+fKtUxGoTKpEV1K/35nvRA+89IzWdv5tGP1P5fpXq4z9FO4
 nt1/rjybeUKB+PHXLkd9tPkj395alNSYwGN6O2PJ9OWvNl7fPuVxR1eq1R33f3tu8xlmPVBi
 Kc5INNRiLipOBAATeEQ9qAMAAA==
X-CMS-MailID: 20220921173248eucas1p23403baa578aa335747fb8a62145a577f
X-Msg-Generator: CA
X-RootMTR: 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d@eucas1p2.samsung.com>
 <20220920091119.115879-14-p.raghav@samsung.com>
 <Yys9sTqCIzxVFwyX@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v14 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>> +/*
>> + * This target works on the complete zoned device. Partial mapping is not
>> + * supported.
>> + * Construct a zoned po2 logical device: <dev-path>
>> + */
>> +static int dm_po2z_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>> +{
>> +	struct dm_po2z_target *dmh = NULL;
>> +	int ret;
>> +	sector_t zone_size;
>> +	sector_t dev_capacity;
>> +
>> +	if (argc != 1)
>> +		return -EINVAL;
>> +
>> +	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
>> +	if (!dmh)
>> +		return -ENOMEM;
>> +
>> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
>> +			    &dmh->dev);
>> +	if (ret) {
>> +		ti->error = "Device lookup failed";
>> +		goto bad;
>> +	}
>> +
>> +	if (!bdev_is_zoned(dmh->dev->bdev)) {
>> +		DMERR("%pg is not a zoned device", dmh->dev->bdev);
>> +		ret = -EINVAL;
>> +		goto bad;
>> +	}
>> +
>> +	zone_size = bdev_zone_sectors(dmh->dev->bdev);
>> +	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
>> +	if (ti->len != dev_capacity) {
>> +		DMERR("%pg Partial mapping of the target is not supported",
>> +		      dmh->dev->bdev);
>> +		ret = -EINVAL;
>> +		goto bad;
>> +	}
>> +
>> +	if (is_power_of_2(zone_size))
>> +		DMWARN("%pg: underlying device has a power-of-2 number of sectors per zone",
>> +		       dmh->dev->bdev);
>> +
>> +	dmh->zone_size = zone_size;
>> +	dmh->zone_size_po2 = 1 << get_count_order_long(zone_size);
>> +	dmh->zone_size_po2_shift = ilog2(dmh->zone_size_po2);
>> +	dmh->zone_size_diff = dmh->zone_size_po2 - dmh->zone_size;
>> +	ti->private = dmh;
>> +	ti->max_io_len = dmh->zone_size_po2;
>> +	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
>> +	ti->len = dmh->zone_size_po2 * dmh->nr_zones;
>> +	return 0;
>> +
>> +bad:
>> +	kfree(dmh);
>> +	return ret;
>> +}
> 
> This error handling still isn't correct.  You're using
> dm_get_device().  If you return early due to error, _after_
> dm_get_device(), you need to dm_put_device().
> 
> Basically you need a new label above "bad:" that calls dm_put_device()
> then falls through to "bad:".  Or you need to explcitly call
> dm_put_device() before "goto bad;" in the if (ti->len != dev_capacity)
> error branch.
> 

Ah. I naively assumed dtr will be called to cleanup but not in this case as
the ctr itself fails.

I will add an extra label on top of `bad` and use it for errors that
happens after `dm_get_device`. Thanks for pointing it out Mike.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

