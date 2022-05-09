Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A13C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 11:03:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-ooUva_-iPd-Su2PgGTCCcw-1; Mon, 09 May 2022 07:03:51 -0400
X-MC-Unique: ooUva_-iPd-Su2PgGTCCcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7789A3C025B5;
	Mon,  9 May 2022 11:03:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 651C81121314;
	Mon,  9 May 2022 11:03:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CF871947054;
	Mon,  9 May 2022 11:03:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C19BC1947052
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 11:03:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 572B5C27EB6; Mon,  9 May 2022 11:03:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52AFAC27EB3
 for <dm-devel@redhat.com>; Mon,  9 May 2022 11:03:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A25B382ECCF
 for <dm-devel@redhat.com>; Mon,  9 May 2022 11:03:47 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-_fjriCxZN9up3ApvSdpItA-1; Mon, 09 May 2022 07:03:45 -0400
X-MC-Unique: _fjriCxZN9up3ApvSdpItA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220509110344euoutp01960083c59eca6127102edf198d3b835a~tavGshp9b2949529495euoutp01t
 for <dm-devel@redhat.com>; Mon,  9 May 2022 11:03:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220509110344euoutp01960083c59eca6127102edf198d3b835a~tavGshp9b2949529495euoutp01t
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220509110343eucas1p17f10fe921ea74d5a57e4d959c892d06b~tavGLcX-J0659106591eucas1p1G;
 Mon,  9 May 2022 11:03:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 58.8A.10009.F05F8726; Mon,  9
 May 2022 12:03:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220509110343eucas1p136eb9833a9bbd0fb318c60dc246dfbff~tavFmYQjD1972519725eucas1p10;
 Mon,  9 May 2022 11:03:43 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220509110343eusmtrp254cef33f07a685690c0ca325b781458c~tavFjCyPs1597715977eusmtrp2T;
 Mon,  9 May 2022 11:03:43 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-69-6278f50f8aae
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id BB.43.09522.F05F8726; Mon,  9
 May 2022 12:03:43 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220509110343eusmtip28e3f84fbe79d5a007a31ae369dd2facc~tavFXOD8J2741827418eusmtip2C;
 Mon,  9 May 2022 11:03:43 +0000 (GMT)
Received: from [106.110.32.130] (106.110.32.130) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 9 May 2022 12:03:41 +0100
Message-ID: <26ccce4c-da31-4e53-b71f-38adaea852a2@samsung.com>
Date: Mon, 9 May 2022 13:03:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <jaegeuk@kernel.org>,
 <hare@suse.de>, <dsterba@suse.com>, <axboe@kernel.dk>, <hch@lst.de>,
 <snitzer@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <7f1bd653-6f75-7c0d-9a82-e8992b1476e4@opensource.wdc.com>
X-Originating-IP: [106.110.32.130]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfVBUVRztvvf27WNr5e1KcmdhqlmzKQySIZlLJIMN5Yum7ybKf3CBNyvG
 h7PrBizGNwgELFCBLsssgZXuUosgygqrsskigRIgtK5jyLhIQnwJGLgM1vK04b/zu+ec+zvn
 zqVwcTMpoeKTDrGKJFmClBQQZ2wrV/09l1JjdhhcO5DpNxuOHnbYSGS8qSFR1dwKjio1R/nI
 daUfR5aZGh76fTkbQx31lRg6aezCkNOkxVHJxTkCncwbw9HqWCAaW3QQqNI6AtD4sBZDFsd2
 NHj7BB91WHoINHRORyL9j+N8VF6whCN7+ThAFd0tPPTL1CyBLjt8wn2YoWvvMGuXG0mmIneG
 z/T/eYpghq6omGZDEcl8n/UdzrQcz2Tar2eRTGnuDMmY80d5zOz5YZIxnR4mmJbedKa85RSP
 WWh+5gPRXsHrcWxC/Jes4pWwfYL95XoLcfAGP/XWwHEsC1STxcCDgvSr8NeJSX4xEFBi+gSA
 N4bqHg2LABaW6jBuWACwM3+V/9jydVENzhE/AbhwxE7+rxqw9PPcKjF9DsDSpgPFgKKEdBg0
 XPrcDQn6ediu83QrhLQI9hxzEm78NP0ZrNL2rUfaTEfBS111uBvjtDd0OPXrIbxoA4CNU671
 XTj9Aw82tZ3H3JeStB/MLloP50G/BR9MLmCc+SWYf9bF5/Cz8Oy0DnfLIS2FNUMBXJev4M+2
 vvXGkHYKYPNKFc4REXCkIgdweDOc7D79qLwvfGjWYxxOh+N2F86Z8wDUmE0ktyAUlvUlcJrd
 sN7xF+CON0H7tIiLswlWnqnGy8E27Yan0G6orN3QQLuhQR0gDMCbVSkT5awyMIlNCVDKEpWq
 JHlAbHJiM/jvW/eudd9rA7WT8wFWgFHACiCFS72EF8pSY8TCOFmamlUkRytUCazSCnwoQuot
 jI1vkolpuewQ+wXLHmQVj1mM8pBkYdH2Lff/8G1/Tz4dtKaK1FmfClnad8B215RzWPT3tokQ
 h7orLjNYEnVvmtKYO0eDdj5X2PtaODX6TY9ak73H0/ThTuO14OX5idqGpV1B8vfv7oq/FTrb
 lmZPbjQJfd+stDDmf2oNXgXtERmu25kdNXyZwAunpWkZEYUxF9TJL4zubY1ku3InE/SK4DtT
 b8cc1gfPRz4o+HaOFEfVBdpyQ6olx4ySrS8vO3YbRSrP1ScGt4dX7cn9xBn10ZEcPEVUpw6V
 Z8x3D76YM9Iwb894937rnbISaWxow83WPmfJ1ScH/FfYi3nK6M4gffJ45BvqT1NWP66tH6bT
 r/tNh23JXIzwlxLK/bJAP1yhlP0LTkX9F0UEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t/xe7r8XyuSDGY/5bFYf+oYs8X/PcfY
 LFbf7WezmPbhJ7PFpP4Z7Ba/z55nttj7bjarxYUfjUwWexZNYrJYufook8WT9bOYLXoOfGCx
 WNnykNniz0NDi4dfbrFYTDp0jdHi6dVZTBZ7b2lbXHq8gt1iz96TLBaXd81hs5i/7Cm7xYS2
 r8wWNyY8ZbSYeHwzq8W61+9ZLE7cknaQ9rh8xdvj34k1bB4Tm9+xe5y/t5HF4/LZUo9NqzrZ
 PBY2TGX22Lyk3mP3zQY2j97md2weO1vvs3q833eVzWP9lqssHptPV3tM2LyR1ePzJrkAwSg9
 m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jAnz97IU
 3GaveHBxCVMD43S2LkZODgkBE4nuztnMXYxcHEICSxklPh+cwgqRkJH4dOUjO4QtLPHnWhcb
 RNFHoKJlD1ghnF2MEj8ermDqYuTg4BWwk1h1JBLEZBFQkdg9hx+kl1dAUOLkzCcsILaoQITE
 g91nweYLC4RLrHm7hRHEZhYQl7j1ZD4TyEgRgVWMEmte/wZbxiywmFXi4ux37BDLfjFK/Plz
 nBlkA5uAlkRjJ9h1nAJuEr9efWaCmKQp0br9NzuELS+x/e0csHIJASWJ2Zf1IJ6plXh1fzfj
 BEbRWUjum4XkjllIJs1CMmkBI8sqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwCS37djPzTsY
 5736qHeIkYmD8RCjBAezkgjv/r6KJCHelMTKqtSi/Pii0pzU4kOMpsAwmsgsJZqcD0yzeSXx
 hmYGpoYmZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTI1Gr6XlD9xkr7WRumrH
 erXQi1n1yNeLO0rEb8Z18xlM0VexrOKfVenwKnSpAOt1URW7lbMll386WJl90mlyWOikWXnn
 Pkk7/NeyC7/VFdf+Z5UjP8ev3wblbiFJU3WWL1oWU6510PRaLut0Y2XtykWTesw2X+w7Fih9
 xv3jwdSX/1+mLrwQtcfhBOMaxZVGnNP2f/86f1dhZNjuvHW1DNmFCr9bKreqLeHxiqx5bzVZ
 KePNc678L1V2mxff+3G3SfqOYJ1iS+vb9zpm537aa1WqMZ5ffNEqyFHkxZKUSQ6ZYROKHlVw
 c359zmCXwOn38uoF9v71t1pXRSrrxUoXvN3/cEVx7J1Dlq1yUYXqSizFGYmGWsxFxYkAFaDj
 FvsDAAA=
X-CMS-MailID: 20220509110343eucas1p136eb9833a9bbd0fb318c60dc246dfbff
X-Msg-Generator: CA
X-RootMTR: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a@eucas1p1.samsung.com>
 <20220506081105.29134-12-p.raghav@samsung.com>
 <7f1bd653-6f75-7c0d-9a82-e8992b1476e4@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v3 11/11] dm-zoned: ensure only power of 2
 zone sizes are allowed
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
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org,
 Luis Chamberlain <mcgrof@kernel.org>, gost.dev@samsung.com,
 Josef Bacik <josef@toxicpanda.com>, linux-nvme@lists.infradead.org,
 jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, linux-btrfs@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, jonathan.derrick@linux.dev,
 linux-fsdevel@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Johannes Thumshirn <jth@kernel.org>, Keith Busch <kbusch@kernel.org>,
 matias.bjorling@wdc.com, Sagi Grimberg <sagi@grimberg.me>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>> ---
>>  drivers/md/dm-zone.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
>> index 3e7b1fe15..27dc4ddf2 100644
>> --- a/drivers/md/dm-zone.c
>> +++ b/drivers/md/dm-zone.c
>> @@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>>  	struct request_queue *q = md->queue;
>>  	unsigned int noio_flag;
>>  	int ret;
>> +	struct block_device *bdev = md->disk->part0;
>> +	sector_t zone_sectors;
>> +	char bname[BDEVNAME_SIZE];
>> +
>> +	zone_sectors = bdev_zone_sectors(bdev);
>> +
>> +	if (!is_power_of_2(zone_sectors)) {
>> +		DMWARN("%s: %s only power of two zone size supported\n",
>> +		       dm_device_name(md),
>> +		       bdevname(bdev, bname));
>> +		return 1;
> 
> return -EINVAL;
> 
> The error propagates to dm_table_set_restrictions() so a proper error code must
> be returned.
> 
Good point. I will add this in the next rev.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

