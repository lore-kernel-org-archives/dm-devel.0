Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3796DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 14:42:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-J3UeqA3mM8ipnqzbJ6K-yg-1; Wed, 11 May 2022 10:42:30 -0400
X-MC-Unique: J3UeqA3mM8ipnqzbJ6K-yg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C3ED81DA19;
	Wed, 11 May 2022 14:41:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3A7455D6B;
	Wed, 11 May 2022 14:41:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 390681947B84;
	Wed, 11 May 2022 14:41:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB458193F6F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 May 2022 14:39:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E20A914E043E; Wed, 11 May 2022 14:39:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBA6E14E043C
 for <dm-devel@redhat.com>; Wed, 11 May 2022 14:39:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2FBE10AF657
 for <dm-devel@redhat.com>; Wed, 11 May 2022 14:39:27 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-4HpxCiIePY-XKZOGo3zYiQ-1; Wed, 11 May 2022 10:39:25 -0400
X-MC-Unique: 4HpxCiIePY-XKZOGo3zYiQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220511143924euoutp0198464cb2d12d8223b98f733584454b1d~uE9_zZIpj1123511235euoutp01f
 for <dm-devel@redhat.com>; Wed, 11 May 2022 14:39:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220511143924euoutp0198464cb2d12d8223b98f733584454b1d~uE9_zZIpj1123511235euoutp01f
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220511143924eucas1p1114e84104a5c6c0eb50e67f8777969a5~uE9_R-fHL3194531945eucas1p1W;
 Wed, 11 May 2022 14:39:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 60.2A.10009.C9ACB726; Wed, 11
 May 2022 15:39:24 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220511143923eucas1p2e3a3e929d5d66bce874b5a9f7d7fd067~uE99xcdbm0496104961eucas1p2y;
 Wed, 11 May 2022 14:39:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220511143923eusmtrp1fc902ac2cae0a49dc35e360306028ac3~uE99wDcd41329413294eusmtrp1g;
 Wed, 11 May 2022 14:39:23 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-24-627bca9c0b1d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id A9.16.09404.B9ACB726; Wed, 11
 May 2022 15:39:23 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220511143923eusmtip1f71a6b406fa85da0c0332d11c8d4d4aa~uE99juOBx3226832268eusmtip1E;
 Wed, 11 May 2022 14:39:23 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.174) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 11 May 2022 15:39:18 +0100
Message-ID: <d8e86c32-f122-01df-168e-648179766c55@samsung.com>
Date: Wed, 11 May 2022 16:39:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: <dsterba@suse.cz>, <jaegeuk@kernel.org>, <hare@suse.de>,
 <dsterba@suse.com>, <axboe@kernel.dk>, <hch@lst.de>,
 <damien.lemoal@opensource.wdc.com>, <snitzer@kernel.org>, Chris Mason
 <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, <bvanassche@acm.org>,
 <linux-fsdevel@vger.kernel.org>, <matias.bjorling@wdc.com>, Jens Axboe
 <axboe@fb.com>, <gost.dev@samsung.com>, <jonathan.derrick@linux.dev>,
 <jiangbo.365@bytedance.com>, <linux-nvme@lists.infradead.org>,
 <dm-devel@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jth@kernel.org>, "Sagi
 Grimberg" <sagi@grimberg.me>, Alasdair Kergon <agk@redhat.com>,
 <linux-block@vger.kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>, "Keith
 Busch" <kbusch@kernel.org>, <linux-btrfs@vger.kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220509185432.GB18596@twin.jikos.cz>
X-Originating-IP: [106.210.248.174]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHc3pv772tVC4V5QTYw4K4IUMbl+y4KWGZ4M3cdLIQlw03C94U
 YinSFmQSGQ4kBaU8FIQOpStuPidDCA95jFUe5aGCrFpqdDAoTBmFAYsgC85yceG/z+/7+37P
 +f1ODoWJawlPKkapYVVKmUJCCPHqtrnbb5V0JkduSrsvQOWdbRh63tBGoCsPcwhUODmHofyc
 IhLN37qDoUbHd3zUM3uMh8rmn+KowZjPQ5eutPLQcLkeQyebJ3F0KX0QQ/8OStHgjA1H+aZ7
 ANkteh5qtG1Ad4cukqihsQNHfTdKCFT6o51EuRn/YMiaawcor72Sj66NTeDIbPMK9mb6ftvJ
 LJivEkxemoNk7jyqwJm+WwnM9cuZBPN9agHGVJ7/hqnvTyWY7DQHwdQd/53PTDRZCKa8yoIz
 3YYWkqnsSmZyKyv4n4g/F249wCpiElnVxqD9wujTo7fxQwXCJG1xUioooLKAgIL027Be1wKc
 LKYvApj9TJ4FhC94BkBtmQlwxTSAz3s6sJeJoa4eHte4AOCzmw/x/126auNSUQ9gb5txMSKi
 g+C9uQLcyTi9Dp6veQw43Q12FA8v6qvpz2Chvptw8ip6L2xpNSxmMdoD2oZLF69zpy0ETM8f
 4WcBiiJof3gsk3R6BPRmWFd2AnD+N+HxmnmS49dgzXjJ0tg+cGKgCef4KPyprZt0nglpixCe
 mTECrrEdWgqKCI5XwSftVSTH3rDr1MmlcDK0W+cxLpwOYE5dOeEcCNLvQV23gvO8D422PwEn
 r4TWcTdunpUwv/oMxskiqM0Q5wJf/bKX0C/bWL9sG/2ybQwAvww82AR1rJxVS5Xs4UC1LFad
 oJQHRsXFXgcvPnfXQvtULTj75O9AE+BRwAQghUncRb/okiLFogOyr4+wqrivVAkKVm0CXhQu
 8RBFxfwsE9NymYY9yLKHWNXLLo8SeKby+EfMa3CJutPsCKurZ/8aXnst0Pddu4UcKz71h0aj
 CfXzCxo9F+xVu94lYERdK4hXUpuUE1bPiAdePuumzXmZiSvwG7WajDyf9PV5rx+M3N7U2Xr3
 1aLxcNGKV2ZD+VJwelddxH7N4y0LFQNbpURrr3ti/Dths5+eCGkKHUhhV9/coPAt3eVtiOBv
 VlwFMzv9XePcUqa27bN/IHe58GWhJDvkcPCUcsGwRxdsjSLnPp6OfrCn/6PJ9n17A5oVDgbt
 2BYQ0drv4hJ/jnY0z45M7earJ9cwP0SEu255w08X9mtKQMioee0XveXh97XaR+FDPlVHp8a+
 3Sjl53xoD0dP9a4SXB0tk/pjKrXsP9KMJ4lLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t/xu7qzT1UnGbx+qmSx/tQxZov/e46x
 Way+289mMe3DT2aLSf0z2C1+nz3PbLH33WxWiws/GpksFv/+zmKxZ9EkJouVq48yWTxZP4vZ
 oufABxaLlS0PmS3+PDS0ePjlFovFpEPXGC2eXp3FZLH3lrbFpccr2C327D3JYnF51xw2i/nL
 nrJbTGj7ymxxY8JTRouJxzezWqx7/Z7F4sQtaQcZj8tXvD3+nVjD5jGx+R27x/l7G1k8Lp8t
 9di0qpPNY2HDVGaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPNZvucricWbBEXaPzaerPSZs
 3sgaIBSlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eg
 lzHl+TmWgqlcFR0zKxoYp3J0MXJySAiYSDw+fYGpi5GLQ0hgKaNE74O/zBAJGYlPVz6yQ9jC
 En+udbFBFH1klJiwZzkzhLMbqKO7kQmkilfATuLaz6ksIDaLgKrEku0vGSHighInZz4Bi4sK
 REg82H2WFcQWFgiXWPN2C1gNs4C4xK0n88HOEBG4yibRMukZK8SG54wS7x+fB6ri4GAT0JJo
 7AQ7iVPAWGLn4m6oZk2J1u2/2SFseYntb+dAvaAs8f7BPhYIu1bi1f3djBMYRWYhuWkWkt2z
 kIyahWTUAkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIGpbduxn1t2MK589VHvECMTB+Mh
 RgkOZiUR3v19FUlCvCmJlVWpRfnxRaU5qcWHGE2BATORWUo0OR+YXPNK4g3NDEwNTcwsDUwt
 zYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpg4qpNc0ydsyn0tv9U52nlJ4pMJW09kzrB8
 enyejAfDqWt3FF26cs5+OjyJl/PEBPVC/SReEStbr8CsOydXtDpGrL2y7JJEqr9hTKXtrtmG
 E+NeKL9cWBJZn3Q9+8WRwl1+rELmca9LVzprvjJoEPt6rlFk6+84hW/Oxpltcr77t3OmiAlW
 Zv9kmdTooNbYM0vst+e1mMgi/lsbr3+3cFmu8OF1O8fmG2qn5igEHXpcd8Kj8K7JvMO7Tjme
 6AtrOXtV8ZkYY+RRX85TSQ/Te65q/dFeftqJe9LM+h/XTPKWT/i8yz709x4umTCZowc+fcve
 nl06I4uRw3tKkWv2Bof/S7OdtNbUux/X5d1q/EKJpTgj0VCLuag4EQANVqpY9gMAAA==
X-CMS-MailID: 20220511143923eucas1p2e3a3e929d5d66bce874b5a9f7d7fd067
X-Msg-Generator: CA
X-RootMTR: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a@eucas1p1.samsung.com>
 <20220506081105.29134-12-p.raghav@samsung.com>
 <20220509185432.GB18596@twin.jikos.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi David,

On 2022-05-09 20:54, David Sterba wrote:>> diff --git
a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
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
> 
> is_power_of_2 takes 'unsigned long' and sector_t is u64, so this is not
> 32bit clean and we had an actual bug where value 1<<48 was not
> recognized as power of 2.
> 
Good catch. Now I understand why btrfs has a helper for is_power_of_two_u64.

But the zone size can never be more than 32bit value so the zone size
sect will never greater than unsigned long.

With that said, we have two options:

1.) We can put a comment explaining that even though it is 32 bit
unsafe, zone size sect can never be a 32bit value

or

2) We should move the btrfs only helper `is_power_of_two_u64` to some
common header and use it everywhere.

Let me know your thoughts.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

