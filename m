Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0588FC6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 19:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663183008;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z9IIrsl8fD3OLXVgkd2BRxawiUBt/+tu/8s6nH2FEVs=;
	b=P6rWkDCV4XzRqdVudCHMUc83PXH0yvMBkspfs/PgfCH+/GEwGghobqHUTtTPbxK0CJvDP6
	EDNO5rduDvVOXWQI2tTt1/i6nsx33N2ki7+6Zw/JTlV0KBE9+w+Hbsbz5fT6O2uBwd3na7
	hJzAthF1S32tMBk/xSyXSPwq7APSIlE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-85Fu-3ZaORKVJaOjfUZIhg-1; Wed, 14 Sep 2022 15:16:46 -0400
X-MC-Unique: 85Fu-3ZaORKVJaOjfUZIhg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C519C87B2A2;
	Wed, 14 Sep 2022 19:16:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9F26C15BA4;
	Wed, 14 Sep 2022 19:16:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 91FAC1946A55;
	Wed, 14 Sep 2022 19:16:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3CA2F1946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 19:16:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FE22140EBF5; Wed, 14 Sep 2022 19:16:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B8EB140EBF3
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 19:16:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 049F0101A528
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 19:16:40 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-Ls3QyyCfNA2wBAUktiva1A-1; Wed, 14 Sep 2022 15:16:37 -0400
X-MC-Unique: Ls3QyyCfNA2wBAUktiva1A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220914191634euoutp01f6a69d85a12a4da699e489e555746901~U0B88km_L2497824978euoutp01d
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 19:16:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220914191634euoutp01f6a69d85a12a4da699e489e555746901~U0B88km_L2497824978euoutp01d
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220914191634eucas1p1cf5b4ecb952a15dfc537688c908269a7~U0B8hWI_J1511815118eucas1p1r;
 Wed, 14 Sep 2022 19:16:34 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 35.A8.07817.29822236; Wed, 14
 Sep 2022 20:16:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220914191634eucas1p2a45bbf2def4de9892a2be10ac1dbf9f0~U0B8LBDtD2516825168eucas1p2K;
 Wed, 14 Sep 2022 19:16:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220914191634eusmtrp186e492d3798a7679a64cd166315ebf94~U0B8HD3T12885828858eusmtrp15;
 Wed, 14 Sep 2022 19:16:34 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-29-632228926819
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 35.5A.10862.19822236; Wed, 14
 Sep 2022 20:16:33 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220914191633eusmtip2e0cc3b377eff18a4ddbfd661eb461652~U0B76ya3t2784627846eusmtip2Y;
 Wed, 14 Sep 2022 19:16:33 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.192) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 14 Sep 2022 20:16:31 +0100
Message-ID: <e42a0579-61b2-7b77-08cb-6723278490cc@samsung.com>
Date: Wed, 14 Sep 2022 21:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@redhat.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <YyIG3i++QriS9Gyy@redhat.com>
X-Originating-IP: [106.210.248.192]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7djPc7qTNJSSDZZNkbZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWuxZNInJYuXqo0wWT9bPYrb423UPKHFL2+LyrjlsFvOX
 PWW3mND2ldlizc2nLBYnbklbtG38yugg6HH5irfHzll32T0uny312LSqk81j85J6j903G9g8
 drbeZ/V4v+8qUOh0tcfnTXIe7Qe6mQK4o7hsUlJzMstSi/TtErgyJq9/zF4wT6Ri1cm1LA2M
 3QJdjJwcEgImErOPf2PrYuTiEBJYwShx7MwuJgjnC6PEj5fnWSGcz4wS/TuWMsK0LLz3DKpl
 OaPE36OX2UESYFWNO0MhEruBZs37DNbBK2AnMW1OE5jNIqAqcfz4FTaIuKDEyZlPWEBsUYFI
 iTW7z4INEhbIljh4bRMziM0sIC5x68l8oJs4OESAem9Nc4EI72eW6J9nARJmE9CSaOwE6+QE
 MtdfX8IEUaIp0br9NzuELS+x/e0cZoj7lSVm3pwKZddKrD12hh3kZAmBZ5wSPX8PQT3pInH8
 1lwoW1ji1fEt7BC2jMTpyT0sEHa1xNMbv5khmluAIbRzPRvIQRIC1hJ9Z3IgahwlGqb9ZIYI
 80nceCsIcQ+fxKRt05knMKrOQgqIWUgenoXkhVlIXljAyLKKUTy1tDg3PbXYKC+1XK84Mbe4
 NC9dLzk/dxMjMDGe/nf8yw7G5a8+6h1iZOJgPMQowcGsJMLbF6KQLMSbklhZlVqUH19UmpNa
 fIhRmoNFSZw3OXNDopBAemJJanZqakFqEUyWiYNTqoEp5OEcB94n0lHR/4tfzZzgtex0k9TM
 OQFXzGc55sdPYMqeOCPMY/sBDo1PtmfFz89Q+SDSe9ixY2K21YuaQvazV3WM966fJJLEs+eU
 fgXDgZRU3igJwV1ip/Mru9niuVarLm/rcXsT0aDudsPv/1f1FcHthf++3ROdyDwheMe5xWW6
 GZa/Xq+eqcc347feTzsuf5cFt5l+dR9iOzHLd2KE/XYrY0aOUzeXsaRbf2u49G5XiZJQe4Dg
 FO6LRZ9tg5q1OB1tGESXX0mwLV4TfLZmgcvGqpc93jwZuXVvLp5OrnpyP/xbKV/fBPuZqb59
 BXWWmnGyay9dTLHIjkrIelGWlVS1c0q5pC0vY1XYTSWW4oxEQy3mouJEACla5g/7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xe7qTNJSSDc4IWqw/dYzZYvXdfjaL
 aR9+Mlv8Pnue2aK1/RuTxd53s1kt9iyaxGSxcvVRJosn62cxW/ztugeUuKVtcXnXHDaL+cue
 sltMaPvKbLHm5lMWixO3pC3aNn5ldBD0uHzF22PnrLvsHpfPlnpsWtXJ5rF5Sb3H7psNbB47
 W++zerzfdxUodLra4/MmOY/2A91MAdxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbm
 sVZGpkr6djYpqTmZZalF+nYJehmT1z9mL5gnUrHq5FqWBsZugS5GTg4JAROJhfeesXUxcnEI
 CSxllDh+5ykrREJG4tOVj+wQtrDEn2tdUEUfGSX2XDvHCOHsZpQ4MP8DE0gVr4CdxLQ5TYwg
 NouAqsTx41fYIOKCEidnPmEBsUUFIiUeLmsCqxcWyJY4eG0TM4jNLCAucevJfKA4B4cIUO+t
 aS4Q4f3MEv3zLCB23WGUuPTjDwtIDZuAlkRjJ9hxnEDm+utLmCDqNSVat/9mh7DlJba/ncMM
 8YCyxMybU6HsWolX93czTmAUnYXkullIrpiFZNQsJKMWMLKsYhRJLS3OTc8tNtIrTswtLs1L
 10vOz93ECEwn24793LKDceWrj3qHGJk4GA8xSnAwK4nw9oUoJAvxpiRWVqUW5ccXleakFh9i
 NAUG0URmKdHkfGBCyyuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRq
 YCorNRVcPO1eyaW/qsXFO34K7p+bsr/9dHjc2+m9PCvZhPVzr0a4J78+rNCd2Md3SjfCcTGn
 ln3tmrmf6jp1hT/+ZOP4H3V2Z+7hSOudHDLbhQ7PmDOxbYp9JLOpqsm+o1vrb8094C3FKuC5
 nYM9TLPQ5dtk65kms11nFSYeLruucmbOEYut9Qe27dDbXcCUa+dUN+XCCqt3c+88+BNW3vr3
 y6kGg4cNcTPME0+fvmMUs2uxwEc2AdZ6dt6PrcvvNfqqXOl/7Lrtud4mW9nZp6xmmhZFRyrf
 n33XImthRfysokUN007sOd56aBXrLTmFmkyhPrYiyeSpN8s+7V3zs4anzEth9gwV1gmhB9Oz
 limxFGckGmoxFxUnAgBKA+adsAMAAA==
X-CMS-MailID: 20220914191634eucas1p2a45bbf2def4de9892a2be10ac1dbf9f0
X-Msg-Generator: CA
X-RootMTR: 20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5@eucas1p2.samsung.com>
 <20220912082204.51189-14-p.raghav@samsung.com> <YyIG3i++QriS9Gyy@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v13 13/13] dm: add power-of-2 target for
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
>> +
>> +	return 0;
>> +}
> 
> The above error paths need to unwind the references or any other
> resources acquired before failing.  Please see other targets for how
> they handle sequencing of the needed operations (e.g. dm_put_device)
> in the error path by using gotos, etc.
> 

Ok. That makes sense, and it should be pretty straight forward to do that.

>> +
>> +static void dm_po2z_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> +{
>> +	struct dm_po2z_target *dmh = ti->private;
>> +
>> +	limits->chunk_sectors = dmh->zone_size_po2;
>> +}
> 
> Are you certain you shouldn't at least be exposing a different
> logical_block_size to upper layers?
> 
To be honest, I tested my patches in QEMU with 4k Logical block size and on
a device with 4k LBA size.

I did a quick test with 512B LBA size in QEMU, and I didn't see any
failures when I ran my normal test suite.

Do you see any problem with exposing the same LBA as the underlying device?

>> +
>> +static void dm_po2z_status(struct dm_target *ti, status_type_t type,
>> +			   unsigned int status_flags, char *result,
>> +			   unsigned int maxlen)
>> +{
>> +	struct dm_po2z_target *dmh = ti->private;
>> +	size_t sz = 0;
>> +
>> +	switch (type) {
>> +	case STATUSTYPE_INFO:
>> +		DMEMIT("%s %lld", dmh->dev->name,
>> +		       (unsigned long long)dmh->zone_size_po2);
>> +		break;
> 
> Wouldn't it be worthwhile to expose the zone sectors (native npo2 vs
> simulated po2?) You merely roundup but never expose what you're using
> (unless I'm missing something about generic "zoned" device
> capabilities).
>

BLKREPORTZONE ioctl is typically used to get the zone information from a
zoned block device, which should expose the npo2 zone sectors(zone
capacity) in this case.

But I do see the value of exposing the dmh->zone_size instead of
dmh->zone_size_po2 as the latter can be easily calculated from the former
or it can be retrieved by reading the chunk_sectors. I will fix that up.


> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

