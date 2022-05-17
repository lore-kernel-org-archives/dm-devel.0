Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEC6C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 07:55:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-TNntD2yQMROCqUfjrCv5RA-1; Tue, 17 May 2022 03:55:52 -0400
X-MC-Unique: TNntD2yQMROCqUfjrCv5RA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C7185A5A8;
	Tue, 17 May 2022 07:55:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 509D4401E3B;
	Tue, 17 May 2022 07:55:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C8A7194705F;
	Tue, 17 May 2022 07:55:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F14661947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 07:55:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE73640CF8F5; Tue, 17 May 2022 07:55:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D2240CF8F0
 for <dm-devel@redhat.com>; Tue, 17 May 2022 07:55:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC261299E75B
 for <dm-devel@redhat.com>; Tue, 17 May 2022 07:55:47 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-EbXN1mJiNqO18qL6mHREAg-1; Tue, 17 May 2022 03:55:42 -0400
X-MC-Unique: EbXN1mJiNqO18qL6mHREAg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220517075541euoutp01a61a39d0fb6370183c325b8b926b82f1~v1VM91Zih0708607086euoutp01W
 for <dm-devel@redhat.com>; Tue, 17 May 2022 07:55:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220517075541euoutp01a61a39d0fb6370183c325b8b926b82f1~v1VM91Zih0708607086euoutp01W
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220517075541eucas1p28071cc51330ce204f2f8758a16b48970~v1VMfzl7Q0562505625eucas1p2h;
 Tue, 17 May 2022 07:55:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id F6.99.10260.DF453826; Tue, 17
 May 2022 08:55:41 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220517075540eucas1p126d19be7cc8d727e072f48bd3212684d~v1VMGc8rS2733227332eucas1p1h;
 Tue, 17 May 2022 07:55:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220517075540eusmtrp17e72e2a8e0edb40b9b0ccb6231156131~v1VMFdVfT1822418224eusmtrp1f;
 Tue, 17 May 2022 07:55:40 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-d0-628354fd157b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id DE.47.09522.CF453826; Tue, 17
 May 2022 08:55:40 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220517075540eusmtip108cb51d13511e557ffec5666fa5ad2f5~v1VL8TtDG1204312043eusmtip10;
 Tue, 17 May 2022 07:55:40 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.7) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 17 May 2022 08:55:38 +0100
Message-ID: <bfcab01e-dbc8-a990-17b1-4aeadffa5685@samsung.com>
Date: Tue, 17 May 2022 09:55:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: <dsterba@suse.cz>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220516215826.GZ18596@twin.jikos.cz>
X-Originating-IP: [106.210.248.7]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7djP87p/Q5qTDFbf47HY+242q8WFH41M
 Fot/f2exWLn6KJNFz4EPLBZ7b2lbXHq8gt1iz96TLBaXd81hs5i/7Cm7xY0JTxkt1tx8yuLA
 4/HvxBo2j52z7rJ7bFrVyeaxeUm9x+6bDWwe7/ddZfNYv+Uqi8eZBUfYPT5vkgvgjOKySUnN
 ySxLLdK3S+DKWNKcW9DGUdH08w5TA+NRti5GTg4JAROJpoP32EFsIYEVjBK/DjlC2F8YJW7v
 suxi5AKyPzNKzP9xEa7h4o6TLBCJ5YwSt07/ZIKrern7LFRmJ6PEufNfgOZycPAK2EkcWCcC
 0s0ioCrRvfsbI4jNKyAocXLmExYQW1QgQmLarDNgG4QFkiR2PPgAVsMsIC5x68l8JhBbREBU
 4tL+FWDzmQVuMEksu7KXBWQ+m4CWRGMn2AucAsYSr1u3sUD0akq0bv/NDmHLS2x/O4cZ4gNF
 iZsrf0F9Uyux9tgZdpCZEgKHOSV+XYVJuEis+nodqkFY4tXxLewQtozE6ck9LBB2tcTTG7+Z
 IZpbGCX6d65nAzlIQsBaou9MDkSNo0RT3weoMJ/EjbeCEPfwSUzaNp15AqPqLKSgmIXk5VlI
 XpiF5IUFjCyrGMVTS4tz01OLjfNSy/WKE3OLS/PS9ZLzczcxAhPb6X/Hv+5gXPHqo94hRiYO
 xkOMEhzMSiK8BhUNSUK8KYmVValF+fFFpTmpxYcYpTlYlMR5kzM3JAoJpCeWpGanphakFsFk
 mTg4pRqYOOIuqSb8XmOhYnp4e2LYfZ0qOaMYVW3PG7tbNZ8LXHH46RuqJVws1WXkxGtnInz/
 6Z5D4W4Nsvy/Vq5MY7D3jNBbvvSBw/fpgbol2ZOrmFVuz7dx+6V+z/HsKpeipKeRG3981Lpf
 +qyW+YXv/8aTk4VPP7X+ZXlKi9v8ue7xRQrP1LJ6eWp0NA9mZCp659274l2etUGOx8zodj+r
 saiJ/x+ZSXU8F7ITbws/5YrtVpz0hG3XKsM7X177bmYMSnmwXF7OTL91fzFvR6WFVKlR8D79
 jd98qz91SjCHTt0j45qZsXB2CouGhb/Oj7gDYfI3+7wOlqZHMXxSPS3f8DvdWOWtyJHfF/Km
 cW82VmIpzkg01GIuKk4EAN5Uwi7bAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t/xu7p/QpqTDI5/1rXY+242q8WFH41M
 Fot/f2exWLn6KJNFz4EPLBZ7b2lbXHq8gt1iz96TLBaXd81hs5i/7Cm7xY0JTxkt1tx8yuLA
 4/HvxBo2j52z7rJ7bFrVyeaxeUm9x+6bDWwe7/ddZfNYv+Uqi8eZBUfYPT5vkgvgjNKzKcov
 LUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLWNKcW9DGUdH0
 8w5TA+NRti5GTg4JAROJiztOsnQxcnEICSxllOj40scIkZCR+HTlIzuELSzx51oXG0TRR0aJ
 eRu3MUM4Oxkl/h55w9TFyMHBK2AncWCdCEgDi4CqRPfub2CDeAUEJU7OfMICYosKREg82H2W
 FcQWFkiS2PHgA1gNs4C4xK0n85lAbBEBUYlL+1dAXfSCUaL/0nKwzcwCN5gkll3ZywKyjE1A
 S6KxE+w6TgFjidet21ggBmlKtG7/zQ5hy0tsfzuHGeIDRYmbK39BvVwr8er+bsYJjKKzkNw3
 C8kds5CMmoVk1AJGllWMIqmlxbnpucWGesWJucWleel6yfm5mxiBKWHbsZ+bdzDOe/VR7xAj
 EwfjIUYJDmYlEV6DioYkId6UxMqq1KL8+KLSnNTiQ4ymwECayCwlmpwPTEp5JfGGZgamhiZm
 lgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9TBycUg1MUeHPhW7ptaWvmbnOQvlmVln5oQDB
 U8xe0uvK7ViXp9qK3Xfa/lrnhkKfjPL5CHf3fXsYJuSzfn0p+FfFjjP59L/HWy/ETpHQVNtW
 q53T8v2hFtu5+NwF/wOrdhQLXE2xXjb7vYXS8uVr9/e6n1qp2GEVnqC7wuSvTctb80VnHK2D
 dScxBykzWLL9EC+Z1edpENz66dSstLMFXot3dBgc0r7DFDr7yu5L5xeaSWaa575g3bc/JY4r
 RNE7MTO5qOa1wK+3uSqeCbZTElis+ZdoGwe3eJ8KmTb3cChD5PaDbskrD74542l+JvnnjWsv
 A700wpriP2w49jtMy8OhlyGTZ73ivY5/Kl2Ox24ENiixFGckGmoxFxUnAgCKt6OGkgMAAA==
X-CMS-MailID: 20220517075540eucas1p126d19be7cc8d727e072f48bd3212684d
X-Msg-Generator: CA
X-RootMTR: 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999@eucas1p2.samsung.com>
 <20220516165416.171196-6-p.raghav@samsung.com>
 <20220516215826.GZ18596@twin.jikos.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 05/13] btrfs: zoned: Cache superblock
 location in btrfs_zoned_device_info
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com,
 hch@lst.de, linux-btrfs@vger.kernel.org
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

On 2022-05-16 23:58, David Sterba wrote:
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>>  fs/btrfs/zoned.c | 13 +++++++++----
>>  fs/btrfs/zoned.h |  1 +
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 06f22c021..e8c7cebb2 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -511,6 +511,11 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>>  			   max_active_zones - nactive);
>>  	}
>>  
>> +	/* Cache the sb zone number */
>> +	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
>> +		zone_info->sb_zone_location[i] =
>> +			sb_zone_number(zone_info->zone_size_shift, i);
>> +	}
> 
> I don't think we need to cache the value right now, it's not in any hot
> path and call to bdev_zone_no is relatively cheap (only dereferencing a
> few pointers, all in-memory values).
Ok. I will fix it up in the next revision! Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

