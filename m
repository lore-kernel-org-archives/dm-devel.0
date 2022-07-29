Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E31C00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 08:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659084503;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W7roGynwiqLaAjqzS/3lPKdJ7d6GwYmQ6zYvrjTUPw0=;
	b=CF4t/8hi0FtnjKlV7Xfq1nOo0SYvbzhJiFGACObf8K6B3KQkcq5Vk5KdjKX375CcNsFwDm
	BgusavrhgDrvRqRxi1k7OfKQjJIk7wKLxVX51dvCO46VvAU5O2SNV0jTl8a5dE+41x+XHc
	DcAUkhtWvHA9Ijn2hMjbrX6q6Y/5knQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-61OYIkSIMamTggkVvwU27g-1; Fri, 29 Jul 2022 04:48:19 -0400
X-MC-Unique: 61OYIkSIMamTggkVvwU27g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7207310A5CCD;
	Fri, 29 Jul 2022 08:48:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7FF01415118;
	Fri, 29 Jul 2022 08:48:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2468193211F;
	Fri, 29 Jul 2022 08:48:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D88B193211B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 08:48:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C2FB2026D07; Fri, 29 Jul 2022 08:48:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CEB2026D64
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:48:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 373EF1C05132
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:48:15 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-68jHyLxZMFGxaUYiT7rTqA-1; Fri, 29 Jul 2022 04:48:13 -0400
X-MC-Unique: 68jHyLxZMFGxaUYiT7rTqA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220729084811euoutp01eb57a881d1edcff06edb7e2915bb7a00~GQI4Xe93x2067120671euoutp019
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:48:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220729084811euoutp01eb57a881d1edcff06edb7e2915bb7a00~GQI4Xe93x2067120671euoutp019
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220729084811eucas1p29c708be560495e380d2ba54446086657~GQI4AoB3p3148931489eucas1p2D;
 Fri, 29 Jul 2022 08:48:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 16.90.10067.BCE93E26; Fri, 29
 Jul 2022 09:48:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220729084810eucas1p1e495e9f4378f515ddc42e7fb54690c8c~GQI3oGuWO2521325213eucas1p1q;
 Fri, 29 Jul 2022 08:48:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220729084810eusmtrp1fcf915da651f0bc849b5f10ce7b597ea~GQI3nRaJm3175431754eusmtrp17;
 Fri, 29 Jul 2022 08:48:10 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-4b-62e39ecb5a6f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 30.AB.09095.ACE93E26; Fri, 29
 Jul 2022 09:48:10 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220729084810eusmtip122adeb7211a38b2523b3a9e055ee2d0e~GQI3b6Uya1554515545eusmtip1y;
 Fri, 29 Jul 2022 08:48:10 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.8) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 29 Jul 2022 09:48:08 +0100
Message-ID: <7fe560c6-4078-f89a-892d-d79b52664045@samsung.com>
Date: Fri, 29 Jul 2022 10:48:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <2b1ab4ac-a355-dfb4-6ca4-82fe36a38433@opensource.wdc.com>
X-Originating-IP: [106.210.248.8]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djP87qn5z1OMth8XcBi9d1+NotpH34y
 W/w+e57ZYu+72awWexZNYrJYufook8WT9bOYLf523WOy2HtL2+LyrjlsFvOXPWW3mND2ldli
 zc2nLBYnbkk78HlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j52t91k93u+7ChQ6Xe3x
 eZOcR/uBbqYA7igum5TUnMyy1CJ9uwSujHPb3zMXfOOsWNtxga2B8QV7FyMnh4SAicTCp8eB
 bC4OIYEVjBJNnQ1sEM4XRolTr3czQjifGSXm/97OCtNyfuUhZhBbSGA5o8SZq6VwRTMfL2GD
 SOwE6viZCmLzCthJXNy3nAXEZhFQlZjY2cUIEReUODnzCVhcVCBSYs3us2A3CQtkSByavhZs
 AbOAuMStJ/OZQGwRgR5Gib8QFzELdDBJbNvUDJTg4GAT0JJo7ATr5RRwk2g8dY4doldTonX7
 byhbXmL72znMEA8oSvR/38AGYddKrD12Bux/CYFbnBKzF0yCBoyLxOoHmxghbGGJV8e3QMVl
 JE5P7mGBsKslnt74zQzR3MIo0b9zPRvIQRIC1hJ9Z3IgahwljjyaABXmk7jxVhDiHj6JSdum
 M09gVJ2FFBSzkLw8C8kLs5C8sICRZRWjeGppcW56arFRXmq5XnFibnFpXrpecn7uJkZg8jv9
 7/iXHYzLX33UO8TIxMF4iFGCg1lJhFcg4HGSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2J
 QgLpiSWp2ampBalFMFkmDk6pBqbqHz2zrgUJ2C+vmMl/oGaf9aozQg4mxkFz3t/hnPniUqis
 oxG7hewlca4ya5ZbxyaJy/5QXh29NsJHhO1b/snbnxPWdwj1GGw+EfZ2f6GzWLWb793VuQVJ
 NzYtOGDrsIHnzd1zHvurTv35vLU02OKCobVa5eqPriFvIp8736i7bTf5lB5jZ/gXp12vuIS+
 VwVNSOXXXmbFoCK+fff/O2eCFh03dJ0vnCq6t5RNJbUydV7nVIWf8UIrL9RklP3yT9k+x2Z2
 9eLHi9g2m+51lVDbnLM6cdrZ966Zds3rcw/tXLtgruNksYUZXqYrvm9t4/m3q/ehqkrYwezb
 kgueHvefdzaAR9zmSozoZwYVA1UlluKMREMt5qLiRADsUhrO7QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t/xu7qn5j1OMrjbYWqx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF51xw2i/nLnrJbTGj7ymyx
 5uZTFosTt6Qd+DwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we7/ddBQqdrvb4
 vEnOo/1AN1MAd5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
 apG+XYJexrnt75kLvnFWrO24wNbA+IK9i5GTQ0LAROL8ykPMXYxcHEICSxkllvWeZYRIyEh8
 uvIRqkhY4s+1LjaIoo+MEh+6nrFAODsZJVb9m8UCUsUrYCdxcd9yMJtFQFViYmcXI0RcUOLk
 zCdgcVGBSImHy5qYQGxhgQyJQ9PXMoPYzALiEreezAeLiwj0MEr83c0IsoBZoI1J4nzDRUaI
 bX8YJb69mMzaxcjBwSagJdHYCXYep4CbROOpc+wQgzQlWrf/hrLlJba/ncMM8YKiRP/3DWwQ
 dq3Eq/u7GScwis5Cct8sJHfMQjJqFpJRCxhZVjGKpJYW56bnFhvqFSfmFpfmpesl5+duYgSm
 jW3Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeAUCHicJ8aYkVlalFuXHF5XmpBYfYjQFBtJEZinR
 5Hxg4soriTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamCKMLSsb3QK
 FPO8aeU1J0JnVqnUg1nyC1uZ27nTeXKf9spE8BXvqLn2tVRmQpfQuttaN8vvvLxt3q+26G7V
 K6mW8Nmbnp9XvTfLQziy+/w+z+1uJV4X2A/wGotpywmd/mF9rEr3iHOU+9eQxIlv9lsn7zt1
 PeTVBC2dA4kbN73bdPGzwqr/dzwOeH5+8kT+VbMy85YQsatMiu88vD9uj1k2/cz8t0/8NjEV
 BKqENB1OsbjNbHX9ed5n6UnZ9iy7X5fPc3VdW3JuPeu7qQ7OE+M6Zfcdf7BUMEruGuNTy+YX
 j23tGH+Zp9xfNe960lejC5NOrJonemeK7RRDx78BJQVMzOrC6cc/phuVlLpYHX6vxFKckWio
 xVxUnAgAdiWloqQDAAA=
X-CMS-MailID: 20220729084810eucas1p1e495e9f4378f515ddc42e7fb54690c8c
X-Msg-Generator: CA
X-RootMTR: 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd@eucas1p2.samsung.com>
 <20220727162245.209794-11-p.raghav@samsung.com>
 <2b1ab4ac-a355-dfb4-6ca4-82fe36a38433@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v8 10/11] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>  	if (endio) {
>>  		int r = endio(ti, bio, &error);
>>  		switch (r) {
>> @@ -1155,6 +1151,10 @@ static void clone_endio(struct bio *bio)
>>  		}
>>  	}
>>  
>> +	if (static_branch_unlikely(&zoned_enabled) &&
>> +	    unlikely(bdev_is_zoned(bio->bi_bdev)))
>> +		dm_zone_endio(io, bio);
>> +
>>  	if (static_branch_unlikely(&swap_bios_enabled) &&
>>  	    unlikely(swap_bios_limit(ti, bio)))
>>  		up(&md->swap_bios_semaphore);
> 
> This patch seems completely unrelated to the series topic. Is that a bug
> fix ? How do you trigger it ? Our tests do not show any issues here...
> If this triggers only with non power of 2 zone size devices, then this
> should be squashed in patch 8. And patch 9 could also be squashed with
> patch 8 too.
> 
The targets that support zoned devices such as dm-zoned, dm-linear, and
dm-crypt do not have an endio function, and even if they do (such as
dm-flakey), they don't modify the bio->bi_iter.bi_sector of the cloned
bio that is used to update the orig_bio's bi_sector in dm_zone_endio
function.

This path is triggered only for the new target dm-po2zone and not for
npo2 zone size devices in general. I will mention this is a prep patch
for the new target because I wouldn't call it a bug per se.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

