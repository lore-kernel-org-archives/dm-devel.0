Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC98C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 08:27:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-tB9Miub9Oo-TeZsSc5S4fg-1; Thu, 12 May 2022 04:27:52 -0400
X-MC-Unique: tB9Miub9Oo-TeZsSc5S4fg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB18890E982;
	Thu, 12 May 2022 08:27:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 317E540C1247;
	Thu, 12 May 2022 08:27:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1D7E193220C;
	Thu, 12 May 2022 08:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B93E9194F4BB
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 08:27:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D9FCC27EB8; Thu, 12 May 2022 08:27:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 898D2C15D76
 for <dm-devel@redhat.com>; Thu, 12 May 2022 08:27:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB4290E980
 for <dm-devel@redhat.com>; Thu, 12 May 2022 08:27:47 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-gs5eFa1-MW-nURiAQbOXCw-1; Thu, 12 May 2022 04:27:45 -0400
X-MC-Unique: gs5eFa1-MW-nURiAQbOXCw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220512082744euoutp01c7f19a1b74aa58ccba6f5064fac0e281~uTiwkk_mh0478004780euoutp01V
 for <dm-devel@redhat.com>; Thu, 12 May 2022 08:27:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220512082744euoutp01c7f19a1b74aa58ccba6f5064fac0e281~uTiwkk_mh0478004780euoutp01V
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220512082744eucas1p210240bbd37977d1995224e1d7664d7f5~uTiv_AvZs2198321983eucas1p2Z;
 Thu, 12 May 2022 08:27:44 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 72.63.10009.FF4CC726; Thu, 12
 May 2022 09:27:44 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220512082743eucas1p2f2b8253db08a3cb212836fe634463f62~uTivLCT1p0648106481eucas1p2C;
 Thu, 12 May 2022 08:27:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220512082743eusmtrp13402dfcd903ac73c80eb6204db4fc67d~uTivJvnJU0978209782eusmtrp1N;
 Thu, 12 May 2022 08:27:43 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-49-627cc4ff5507
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 6F.C5.09404.FF4CC726; Thu, 12
 May 2022 09:27:43 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220512082743eusmtip1bfefa8841eba10cbdcaa7e99628c0ca6~uTiu_ZXg31785317853eusmtip1f;
 Thu, 12 May 2022 08:27:43 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.174) by CAMSVWEXC01.scsc.local
 (106.1.227.71) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 May
 2022 09:27:40 +0100
Message-ID: <ccf73bfc-48a5-e5e7-2588-02f455c16f79@samsung.com>
Date: Thu, 12 May 2022 10:27:38 +0200
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
In-Reply-To: <20220511160001.GQ18596@twin.jikos.cz>
X-Originating-IP: [106.210.248.174]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (106.1.227.71) To
 CAMSVWEXC01.scsc.local (106.1.227.71)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbZRTGee+9vb10dF5aDG+AbJGpceDqcGhePyBDl+xui0acoiHRWdi1
 EPmyhemEuWLLdB0CK4ij1EERNlYYFLrx0QEllcLGxyBCldaNiVDZMIMpIw5KwHV3M/z3O895
 npNz3rwULmojg6jktExWniZNCSUFREvv0tVtPvachO2TywA19vfiaK2jl0R11wtJVHpnCUfa
 wlN85BkaxlHnXDkPjdzLxdCPnn8J1FGlxdC5OjuGpht1OMrvvkOgc+pJHK1MRqDJuy4CaW2/
 AOR26DDU6QpHP0/V8lFH5xUCjVr0JKo44+ajomOLOBovcgN0ss/MQw1/zRPosit4ZwgzOraP
 Wb1cTzInVXN8ZniiiWBGh7KYZuNxkjEov8MZc/VR5pJTSTLfquZIpj3vBo+Z73KQTOMFB8EM
 VvbwGfNANlNkbuK9JYoXvHqQTUk+xMqfi/5IkKSsWyMyfn3s8+uGHlwJjH4a4EtBOhLmzS3g
 GiCgRHQtgBbNTxhX3AXQplc97CwAqHJ+hT2KqFa7Sa5xFsCatTO8/133NC6CKxoA7DCd5nkj
 Qjoa3qq/8YAJ+ilY0d6Ncbo/vFI2TXj5cfp9WKobJL0spt+DPfZK3Ms4HQhd0xUPlgqgHSRU
 a/+8P4iiSDoM5h7nez2+9A64WDDG4/xbYV6rh8/xZth6W49za2+B8793Ed4opBOhqSzOOxLS
 TgE0nLWQnL4LzkwBzi6Gs30X+ByHwIHifILjbOge9+BcVg1gYXvjw+wrsGAwhfPEwCrXTcDJ
 G+H4bX9um41Q2/I9zslC+M0xURF4UrfuHXTr7tWtu0W37pZKQBhBIJulSJWxiog09jOJQpqq
 yEqTSRLTU5vB/c89sNr3Txv4YfZviQ1gFLABSOGhAcIcVU6CSHhQevgLVp5+QJ6VwipsIJgi
 QgOFickmqYiWSTPZT1g2g5U/6mKUb5ASA+eXwsq2+njKu0eGq3UXp5ZbY63Ni2O1y3HgCVbj
 bLKQ0S/EZYs3r+2rP+TvMEVVTGaPGjX1kS+fV7z49ErXM0mZE8E7BFUluTVDp1SdbWXxE5KS
 I7S8tOFNy5du+d5rf/iJZ4YNixuuRvXfutiUkO77m7JvWzj5vPXmjCH2w+LxnreXrtXsrCuO
 DSlsWZAF7I80B0ZZXypc2ZSoFB3doNDq+itLiBODl/bsza8pf3agS5yqV5+mw09YVPyPqzG/
 uLT4GPsRsP2DgLUt4gOicacftVvisztpVvWu1WTd//XryQUx1rBdvHdes0fI7EYTfKMgd1Uf
 NO08nPGpWjMysimUUCRJI8JwuUL6H+ryAfNLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t/xu7r/j9QkGTx9zW2x/tQxZov/e46x
 Way+289mMe3DT2aLSf0z2C1+nz3PbLH33WxWiws/GpksFv/+zmKxZ9EkJouVq48yWTxZP4vZ
 oufABxaLlS0PmS3+PDS0ePjlFovFpEPXGC2eXp3FZLH3lrbFpccr2C327D3JYnF51xw2i/nL
 nrJbTGj7ymxxY8JTRouJxzezWqx7/Z7F4sQtaQcZj8tXvD3+nVjD5jGx+R27x/l7G1k8Lp8t
 9di0qpPNY2HDVGaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPNZvucricWbBEXaPzaerPSZs
 3sgaIBSlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eg
 l9Gw+j9LwXX+irsLjzA3MK7i6WLk5JAQMJFo/neArYuRi0NIYCmjxNIT19khEjISn658hLKF
 Jf5c64Iq+sgoMW33J3YIZx2jxNSDzUwgVbwCdhIv19xnBbFZBFQl5u88ABUXlDg58wkLiC0q
 ECHxYPdZsBphgXCJNW+3MILYzALiEreezGcCGSoicJVNomXSM1aIDUeZJG7c/QGU4eBgE9CS
 aOwEO4lTwFjia98VVohmTYnW7b/ZIWx5ie1v5zBDnK0s8f7BPhaQVgmBZIm/t8InMIrMQnLS
 LCSrZyGZNAvJpAWMLKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzECU9u2Yz+37GBc+eqj3iFG
 Jg7GQ4wSHMxKIrw1zTVJQrwpiZVVqUX58UWlOanFhxhNgeEykVlKNDkfmFzzSuINzQxMDU3M
 LA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqYuvw99x1vyK9R2L3wzbYVqwueKR4S
 e+ml/OeK/c0O0auWObJLpY01hTw4rnxbeTArZucvn2uq/+SbvM+IpbkuZlVvMPvUcWDnq3eH
 p/sseyR5uPelf923r8kzpVhFFxoGfbRk/ntx/9GMG9ZM6R91zbf/clQ5zXS2oKt82Ym/GjPd
 1vhwbFI+8d1Y+bTN4wzrSY+vbbDn9JY+czj7hd9ErqZ1nJuqzrWbC02Oi7m66aEQ533vpc7x
 TNW/ZXgL5OO27FTO+W5t0qG5smEpK4vEnLRK9wXbstIm74hfLtmqsLCnkGOpmKPiz7CV6lw+
 931mXevo1a2ec9+4tnjRtgX1RzZ2HXLm4/2T8LP+4UdRJZbijERDLeai4kQAhjJCOvYDAAA=
X-CMS-MailID: 20220512082743eucas1p2f2b8253db08a3cb212836fe634463f62
X-Msg-Generator: CA
X-RootMTR: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a@eucas1p1.samsung.com>
 <20220506081105.29134-12-p.raghav@samsung.com>
 <20220509185432.GB18596@twin.jikos.cz>
 <d8e86c32-f122-01df-168e-648179766c55@samsung.com>
 <20220511160001.GQ18596@twin.jikos.cz>
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

>>>> +	zone_sectors = bdev_zone_sectors(bdev);
>>>> +
>>>> +	if (!is_power_of_2(zone_sectors)) {
>>>
>>> is_power_of_2 takes 'unsigned long' and sector_t is u64, so this is not
>>> 32bit clean and we had an actual bug where value 1<<48 was not
>>> recognized as power of 2.
>>>
>> Good catch. Now I understand why btrfs has a helper for is_power_of_two_u64.
>>
>> But the zone size can never be more than 32bit value so the zone size
>> sect will never greater than unsigned long.
> 
> We've set the maximum supported zone size in btrfs to be 8G, which is a
> lot and should be sufficient for some time, but this also means that the
> value is larger than 32bit maximum. I have actually tested btrfs on top
> of such emaulated zoned device via TCMU, so it's not dm-zoned, so it's
> up to you to make sure that a silent overflow won't happen.
> 

bdev_zone_sectors is used in this case and not the actual size in bytes.
So the zone size need to be 2TB for the sectors value to cross the 32bit
limit. This is likely not an issue in the near future.

>> With that said, we have two options:
>>
>> 1.) We can put a comment explaining that even though it is 32 bit
>> unsafe, zone size sect can never be a 32bit value
> 
> This is probably part of the protocol and specification of the zoned
> devices, the filesystem either accepts the spec or makes some room for
> larger values in case it's not too costly.
> 
>> or
>>
>> 2) We should move the btrfs only helper `is_power_of_two_u64` to some
>> common header and use it everywhere.
> 
> Yeah, that can be done independently. With some macro magic it can be
> made type-safe for any argument while preserving the 'is_power_of_2'
> name.
But I agree with your point that we need a type safe power of 2
implementation in a common header so that we can avoid silent overflows
in 32 bit architectures.

I will keep the change as is in this patch and follow up on the type
safe power of 2 later independently. Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

