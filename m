Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F14BC43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 12:24:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-qLwAalX-O5qom2dlX6KzJg-1; Thu, 16 Jun 2022 08:24:54 -0400
X-MC-Unique: qLwAalX-O5qom2dlX6KzJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1A7D1C08973;
	Thu, 16 Jun 2022 12:24:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61E34403350;
	Thu, 16 Jun 2022 12:24:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29EB7194705D;
	Thu, 16 Jun 2022 12:24:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4B50F194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 12:24:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 22899492CA6; Thu, 16 Jun 2022 12:24:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D93F492CA5
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 12:24:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 065B1801E80
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 12:24:46 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-u6Un16B7MPGN3dTF3f6p-A-1; Thu, 16 Jun 2022 08:24:44 -0400
X-MC-Unique: u6Un16B7MPGN3dTF3f6p-A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220616122443euoutp02cce0617d3050b25ac349d6550a5c8da3~5GWqFgwRC1558915589euoutp02I
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 12:24:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220616122443euoutp02cce0617d3050b25ac349d6550a5c8da3~5GWqFgwRC1558915589euoutp02I
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220616122442eucas1p2bbd7a238ca1a7768e7bfd4f18850cbba~5GWplods81908019080eucas1p2O;
 Thu, 16 Jun 2022 12:24:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 08.B2.09664.A012BA26; Thu, 16
 Jun 2022 13:24:42 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220616122442eucas1p26a573d308772fd7c73d557fa46f91bdd~5GWpB-7160887408874eucas1p2D;
 Thu, 16 Jun 2022 12:24:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220616122442eusmtrp1ab6bc56c7b66c61af921bd62d07ef4b9~5GWpBKVwp2243722437eusmtrp1I;
 Thu, 16 Jun 2022 12:24:42 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-01-62ab210ab293
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id AB.A4.09038.A012BA26; Thu, 16
 Jun 2022 13:24:42 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220616122442eusmtip2e36f8489d73ae998c241ba901b2f3d6b~5GWo21PBF2951229512eusmtip2_;
 Thu, 16 Jun 2022 12:24:42 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 16 Jun 2022 13:24:36 +0100
Message-ID: <8d8501e8-9e39-8b02-d248-48f778a95d96@samsung.com>
Date: Thu, 16 Jun 2022 14:24:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <snitzer@redhat.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <f7b586a3-5370-f3b9-72dc-f9bea0b63f1f@opensource.wdc.com>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7djP87pciquTDHb/VLdYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBYrVx9lsniyfhazRc+BDywWf7vuAcVaHgKV3NK2uLxrDpvF/GVP
 2S3W3HzKYtG28SujA7/H5SveHv9OrGHz2DnrLrvH5bOlHptWdbJ5LGyYyuyxeUm9x+6bDUC5
 1vusHu/3XWXzWL/lKovH501yHu0HupkCeKO4bFJSczLLUov07RK4Mlpm7GMreCFasWeXbwPj
 ZcEuRk4OCQETiVm7pzB2MXJxCAmsYJS4uPAhE4TzhVFi5+/nUJnPjBKPTpxjgmk5tvEPG0Ri
 OaPEv4XX2OGqPi/YAtWyi1HiW9NqZpAWXgE7iR19vxlBbBYBVYnOVx+ZIOKCEidnPmEBsUUF
 IiRWtr4Bs4UFiiV6LkwE62UWEJe49WQ+UD0Hh4hAnsS8f0kg85kFTjFJPD36lh0kziagJdHY
 yQ5SzingJnHt5Ud2iFZNidbtv6FseYntb+cwg5RLCChL/NvJDPFMrcTaY2fA7pcQeMcp8fTt
 IiaIGheJV28UIGqEJV4d38IOYctInJ7cwwJhV0s8vfGbGaK3hVGif+d6Nohea4m+MzkQNY4S
 C0/2Qq3lk7jxVhDiGj6JSdumM09gVJ2FFA6zkPw7C8kDs5A8sICRZRWjeGppcW56arFhXmq5
 XnFibnFpXrpecn7uJkZgajz97/inHYxzX33UO8TIxMF4iFGCg1lJhNcseGWSEG9KYmVValF+
 fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiaeb1MnGPTudN2pMO9gSvOq
 Aq/1y46tCzVrfTe/Iu3nhoY1Hc4hzmXGCYw/f/he/9P9Wqxl+wuZh+a+Dx3//8u6nBl1VlTN
 KruDse6e739/Aw4W96WKl65avJsS+nHqXLsc5aDFhy5r7awuaJ9pdE7MPm3iH4NjzB62v4p5
 aiI0I12iwrLnFWU7T1nTJfbt/qWKeGWbePegnUuu82fOebdqSwN/7w3FeQckxOxnch7+GzQp
 8ZxjqALrhTn2G3dzVd7TLFOesFjF1dB0b3cL06GQ5dFVl+R9pI3/TdzW3eAU+PPWadcnbXdW
 RiRHhXx5Kx683TxYfXodz6T1YgWbJaKXiK26+JvxJN+Hb1N/v1RiKc5INNRiLipOBABFTMq6
 /AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xe7pciquTDN4dZ7NYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBYrVx9lsniyfhazRc+BDywWf7vuAcVaHgKV3NK2uLxrDpvF/GVP
 2S3W3HzKYtG28SujA7/H5SveHv9OrGHz2DnrLrvH5bOlHptWdbJ5LGyYyuyxeUm9x+6bDUC5
 1vusHu/3XWXzWL/lKovH501yHu0HupkCeKP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUM
 jc1jrYxMlfTtbFJSczLLUov07RL0Mlpm7GMreCFasWeXbwPjZcEuRk4OCQETiWMb/7B1MXJx
 CAksZZSY136XBSIhI/Hpykd2CFtY4s+1LjYQW0jgI6PEto+GEA27GCWuHj7FBJLgFbCT2NH3
 mxHEZhFQleh89REqLihxcuYTsKGiAhESn5ZNYAWxhQWKJXouTGQGsZkFxCVuPZkPVM/BISKQ
 JzHvXxLIfGaBU0wST4++ZYdY9odR4sapaawgRWwCWhKNnWDHcQq4SVx7CXEos4CmROv231C2
 vMT2t3OYQcolBJQl/u1khvilVuLV/d2MExhFZyG5bhaSK2YhmTQLyaQFjCyrGEVSS4tz03OL
 jfSKE3OLS/PS9ZLzczcxAhPKtmM/t+xgXPnqo94hRiYOxkOMEhzMSiK8ZsErk4R4UxIrq1KL
 8uOLSnNSiw8xmgKDaCKzlGhyPjCl5ZXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YW
 pBbB9DFxcEo1MK2PtohSPKWw8J/fguMHhVXbRIJS/j8Xcqv5ruFy/urqHXIB7iu+PDHer3P2
 oteSydp/IlqkJLgcIhbYvHp9dlH1Jua+eq/YhWabX4iyL1t/61b5HWdHzoNvDvWvPhtoqj6p
 qNRN3pn/xaLd1SouaTZmSy+fuG6ltHZpnYHantWz4pQLgv00rurP5nV6av3c5HOck9Pnxeuu
 a3ldmWF4lYsrIW3+vhbevoOiRRPSvjw7/Fj0dPlFyZSeZiP/HyZS7PWrAy993iRcxn/7WOl3
 z9QVNWtYTPzeam5XWHYm4XOBwnkOkX82cff2nDLj+CyVuy3/qK5e8YND+TLtk5//PPO7T0nA
 8jl/Wrus8pruLiWW4oxEQy3mouJEAHE+01yxAwAA
X-CMS-MailID: 20220616122442eucas1p26a573d308772fd7c73d557fa46f91bdd
X-Msg-Generator: CA
X-RootMTR: 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b@eucas1p1.samsung.com>
 <20220615101920.329421-13-p.raghav@samsung.com>
 <f7b586a3-5370-f3b9-72dc-f9bea0b63f1f@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 12/13] dm: call dm_zone_endio after the
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
 jiangbo.365@bytedance.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-06-15 13:01, Damien Le Moal wrote:
> On 6/15/22 19:19, Pankaj Raghav wrote:
>> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
>> uses either native append or append emulation and it is called before the
>> endio of the target. But target endio can still update the clone bio
>> after dm_zone_endio is called, thereby, the orig bio does not contain
>> the updated information anymore. Call dm_zone_endio for zoned devices
>> after calling the target's endio function
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>> @Damien and @Hannes: I couldn't come up with a testcase that uses endio callback and
>> zone append or append emulation for zoned devices to test for
>> regression in this change. It would be great if you can suggest
>> something. This change is required for the npo2 target as we update the
>> clone bio sector in the endio callback function and the orig bio should
>> be updated only after the endio callback for zone appends.
> 
> Running zonefs tests on top of dm-crypt will exercise DM zone append
> emulation.
> 
Thanks. However, I am facing issues creating a dm-crypt target with a
zoned device. Steps:
- cryptsetup luksFormat <zns-device>

is throwing a bunch of IO errors with the following error message:
Device wipe error, offset 32768.
Cannot wipe header on device <zns-device>.

I can observe the same behavior in both v5.18 and next-20220615 with
cryptsetup 2.4.3.The same step is working correctly on a normal NVMe device.
Am I doing something wrong?
ZNS info: zsze 128M and zcap 128M with 50 zones
>>
>>  drivers/md/dm.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 3f17fe1de..3a74e1038 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1025,10 +1025,6 @@ static void clone_endio(struct bio *bio)
>>  			disable_write_zeroes(md);
>>  	}
>>  
>> -	if (static_branch_unlikely(&zoned_enabled) &&
>> -	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
>> -		dm_zone_endio(io, bio);
>> -
>>  	if (endio) {
>>  		int r = endio(ti, bio, &error);
>>  		switch (r) {
>> @@ -1057,6 +1053,10 @@ static void clone_endio(struct bio *bio)
>>  		}
>>  	}
>>  
>> +	if (static_branch_unlikely(&zoned_enabled) &&
>> +	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
> 
> blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))) ->
> bdev_is_zoned(bio->bi_bdev)
> 
Ok. Even though I just moved the statements, I think this is trivial
enough to take it along.
>> +		dm_zone_endio(io, bio);
>> +
>>  	if (static_branch_unlikely(&swap_bios_enabled) &&
>>  	    unlikely(swap_bios_limit(ti, bio)))
>>  		up(&md->swap_bios_semaphore);
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

