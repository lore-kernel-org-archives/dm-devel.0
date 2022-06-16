Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CEEC43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 10:29:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-5CXw3UY_O1utFuYBzPjwiQ-1; Thu, 16 Jun 2022 06:29:01 -0400
X-MC-Unique: 5CXw3UY_O1utFuYBzPjwiQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D8580A0AD;
	Thu, 16 Jun 2022 10:28:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0F8940334E;
	Thu, 16 Jun 2022 10:28:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 800AE194705C;
	Thu, 16 Jun 2022 10:28:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9151A194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 10:28:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 701DB1415107; Thu, 16 Jun 2022 10:28:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B91C1415106
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:28:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53BB2101E985
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:28:57 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-Ky-r1PLkPWWGOKmakiUvfg-1; Thu, 16 Jun 2022 06:28:55 -0400
X-MC-Unique: Ky-r1PLkPWWGOKmakiUvfg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220616102854euoutp018cc1312fac52ad46be9f0a7e9f124a64~5ExikuSIO1853718537euoutp01V
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:28:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220616102854euoutp018cc1312fac52ad46be9f0a7e9f124a64~5ExikuSIO1853718537euoutp01V
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220616102854eucas1p28d84911385a41f5d0c5b61050ff913f3~5ExiMhGOf1431814318eucas1p24;
 Thu, 16 Jun 2022 10:28:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 5D.CE.10067.6E50BA26; Thu, 16
 Jun 2022 11:28:54 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220616102853eucas1p14f7747a8a646b23d68310ba45e0e4bed~5ExhxAD3R1626416264eucas1p1f;
 Thu, 16 Jun 2022 10:28:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220616102853eusmtrp2e56ce9309829d1d15872a0fef861251a~5Exhv54v-1339413394eusmtrp2h;
 Thu, 16 Jun 2022 10:28:53 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-e7-62ab05e6f479
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id E3.A8.09095.5E50BA26; Thu, 16
 Jun 2022 11:28:53 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220616102853eusmtip1b59df1eccc24e951d0f3918da805ea15~5Exhk_UlM3259832598eusmtip1O;
 Thu, 16 Jun 2022 10:28:53 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 16 Jun 2022 11:28:46 +0100
Message-ID: <92c922ed-cc04-6e55-9c12-81a43332b318@samsung.com>
Date: Thu, 16 Jun 2022 12:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Randy Dunlap <rdunlap@infradead.org>, <hch@lst.de>,
 <snitzer@redhat.com>, <damien.lemoal@opensource.wdc.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <0480d917-94e5-20ab-514c-bb1374a8d9c4@infradead.org>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZduznOd1nrKuTDC78Z7VYfbefzWLah5/M
 Fr/Pnme2aG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5QrOUhs8Xe
 W9oWl3fNYbOYv+wpu8Wam09ZLN7emc5i0bbxK6ODkMflK94e/06sYfPYOesuu8fmFVoel8+W
 emxa1cnmsbBhKrPH5iX1HrtvNgDlW++zerzfd5XNY/2Wqywem09Xe3zeJOfRfqCbKYA/issm
 JTUnsyy1SN8ugSvj46lHzAWNvBVrpz9mamDcx9nFyMkhIWAi8WrLMaYuRi4OIYEVjBI3rlyF
 cr4wStw8vR7K+cwo8WTrbSCHA6zl10ptiPhyRommL3cQim5tf8EM4exilJh3/i0zSAevgJ3E
 jcn2IPtYBFQlJj//wgxi8woISpyc+YQFxBYViJBY2fqGBaRcWMBRoulEEkiYWUBc4taT+WDz
 RQRaGYHqb7CAOMwCLcwSXfsfgs1nE9CSaOxkB2ngBOq91NXFCNGsKdG6/Tc7hC0vsf3tHGaI
 B5Ql/u1khni/VmLtsTPsEPZMLompTfkQtovErmnnWCFsYYlXx7dA1chI/N8Jcg+IXS3x9MZv
 sHclBFoYJfp3rmeDmG8t0XcmB6LGUWJVyxNGiDCfxI23ghDX8ElM2jadeQKj6iykgJiF5ONZ
 SB6YheSBBYwsqxjFU0uLc9NTi43yUsv1ihNzi0vz0vWS83M3MQIT6el/x7/sYFz+6qPeIUYm
 DsZDjBIczEoivGbBK5OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2C
 yTJxcEo1MBXMO/v1jbl2bt31FxM2rJE9s0jl4VOrSYcvtfEnxIeIyq5h3qW3/F2zvmvslW+/
 /a5f253skZMo5MlbLVeyWWn+Ee7SQ4cuLraVe1H+aFt+2beTdVMfP3D2Mr044SsDo3i0KO+C
 228EdJvPsjXHX5y44eX6V6aqUQ4Ptuz3WF12I3Aea2JR5yQtpvubS6vCvHLz+pa+qbMP+OBw
 YrLGT84Jeb86l6samJXLbzt89lze6XeNie/qPnnqFPFPOVKXsFPpezP7lsXGS8/vydjYs+fl
 uxJp88XPi/YvzMifbcvDKFczPXP/yqs/72zV/lAyx3LKhe5TP/ddEKk0cuHV1/sgv7BlraDR
 /blskeeXHbVQYinOSDTUYi4qTgQAWSLBrBMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t/xu7pPWVcnGaxdpGax+m4/m8W0Dz+Z
 LX6fPc9s0dr+jcli77vZrBYXfjQyWexZNInJYuXqo0wWT9bPYrboOfCBxeJv1z2gWMtDZou9
 t7QtLu+aw2Yxf9lTdos1N5+yWLy9M53Fom3jV0YHIY/LV7w9/p1Yw+axc9Zddo/NK7Q8Lp8t
 9di0qpPNY2HDVGaPzUvqPXbfbADKt95n9Xi/7yqbx/otV1k8Np+u9vi8Sc6j/UA3UwB/lJ5N
 UX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7Gx1OPmAsa
 eSvWTn/M1MC4j7OLkYNDQsBE4tdK7S5GLg4hgaWMEhtPnmXrYuQEistIfLrykR3CFpb4c60L
 LC4k8JFR4s9Bcwh7F6PE7LMFIHN4Bewkbky2BwmzCKhKTH7+hRnE5hUQlDg58wkLiC0qECHx
 adkEVpByYQFHiaYTSSBhZgFxiVtP5jOBnCAi0Moo8WbbLRYQh1mghVmia/9DZojjvjNKXHyz
 lQWkm01AS6KxE+w2TqBBl7q6GCEmaUq0bv/NDmHLS2x/O4cZ4kdliX87mSFeqZV4dX834wRG
 0VlIzpuF5I5ZSCbNQjJpASPLKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMDks+3Yz807GOe9
 +qh3iJGJg/EQowQHs5IIr1nwyiQh3pTEyqrUovz4otKc1OJDjKbAMJrILCWanA9Mf3kl8YZm
 BqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUwruv15P3nP+Fga9/n0piq5
 d0yLv9ntkeDIX833rIrZjuGTKJfJPut3r5ju5Ijbn7gqM3Vl7hTm8iXhb+3fsa+xKs4IiWjY
 fvntrsRLK8zvHJV3WLW28Oiun4/fX98dLn9L6urtJI+e8wbRdtNZN/y4l3ljjdXMGRw69+w3
 9AaUW28zSPI6oXNJ4O5aofNT4xJqdsvvUH5tPvHhPOEjov4MYl9PB6571rO5ZVvEH6ktZ5Z8
 PF3+3M6k9gnzDCvDPxMKFt60eR3qKVzA3vTzSNCLTcrNEndCufR3hd9KShHo6r7zYul9/sL/
 8R9qKyZ9yZtzcNsWDoWXCz/pRQUsW2Tfkz5ZbUffnn5O38U5QYqflFiKMxINtZiLihMBLOYv
 9McDAAA=
X-CMS-MailID: 20220616102853eucas1p14f7747a8a646b23d68310ba45e0e4bed
X-Msg-Generator: CA
X-RootMTR: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
 <0480d917-94e5-20ab-514c-bb1374a8d9c4@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 13/13] dm: add non power of 2 zoned target
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
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

On 2022-06-15 21:54, Randy Dunlap wrote:
> Hi--
> 
> On 6/15/22 03:19, Pankaj Raghav wrote:
> 
>> ---
>>  drivers/md/Kconfig                |   9 +
>>  drivers/md/Makefile               |   2 +
>>  drivers/md/dm-zone.c              |   9 +
>>  drivers/md/dm-zoned-npo2-target.c | 268 ++++++++++++++++++++++++++++++
>>  4 files changed, 288 insertions(+)
>>  create mode 100644 drivers/md/dm-zoned-npo2-target.c
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 998a5cfdb..773314536 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -518,6 +518,15 @@ config DM_FLAKEY
>>  	help
>>  	 A target that intermittently fails I/O for debugging purposes.
>>  
>> +config DM_ZONED_NPO2
>> +	tristate "Zoned non power of 2 target"
> 
> 	         "Zoned non-power-of-2 target"
> 
>> +	depends on BLK_DEV_DM
>> +	depends on BLK_DEV_ZONED
>> +	help
>> +	A target that converts a zoned device with non power of 2 zone size to
> 
> 	                                           non-power-of-2 zone size to
> 
>> +	be power of 2. This is done by introducing gaps in between the zone
>> +	capacity and the power of 2 zone size.
> 
> All help text should be indented with one tab and 2 spaces
> according to Documentation/process/coding-style.rst.
> 
>> +
>>  config DM_VERITY
>>  	tristate "Verity target support"
>>  	depends on BLK_DEV_DM
> 
> [snip]
> 
>> +
>> +MODULE_DESCRIPTION(DM_NAME " non power 2 zoned target");
> 
>                                 non-power-of-2
> 
>> +MODULE_AUTHOR("Pankaj Raghav <p.raghav@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> +
> 
Thanks Randy. Fixed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

