Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33D7CCA479
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 08:03:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-DAxxvpYfOSCOKdfWiDqezQ-1; Fri, 17 Jun 2022 04:03:31 -0400
X-MC-Unique: DAxxvpYfOSCOKdfWiDqezQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 344C91C1C1AD;
	Fri, 17 Jun 2022 08:03:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E91594024BDD;
	Fri, 17 Jun 2022 08:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0460194705F;
	Fri, 17 Jun 2022 08:03:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC361194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 08:03:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABEC0492CA6; Fri, 17 Jun 2022 08:03:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A71EC492CA5
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 08:03:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F540801756
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 08:03:25 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-nIx6CuPcPYu5gkBmU1WEDw-1; Fri, 17 Jun 2022 04:03:20 -0400
X-MC-Unique: nIx6CuPcPYu5gkBmU1WEDw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220617080319euoutp0285d55f2888387a9f3a9fa809e1c5c8c6~5Wbtp6S5N2784827848euoutp02y
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 08:03:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220617080319euoutp0285d55f2888387a9f3a9fa809e1c5c8c6~5Wbtp6S5N2784827848euoutp02y
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220617080319eucas1p1bc4b7ac79368be83ed169769bac13881~5WbtZaKPz2524025240eucas1p1F;
 Fri, 17 Jun 2022 08:03:19 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 1D.1A.10067.7453CA26; Fri, 17
 Jun 2022 09:03:19 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220617080318eucas1p18554421449b17c4a2ad7816dd6584383~5Wbs4YchD3237732377eucas1p1S;
 Fri, 17 Jun 2022 08:03:18 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220617080318eusmtrp2b71751d429c288c6d12854d27dd0fcf5~5Wbs3fT1h2980029800eusmtrp2E;
 Fri, 17 Jun 2022 08:03:18 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-21-62ac3547daa1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F1.09.09095.6453CA26; Fri, 17
 Jun 2022 09:03:18 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220617080318eusmtip13a348e9cbb58e5ec3aaf8dfa8d77b2a0~5WbsqjC4S2368423684eusmtip1X;
 Fri, 17 Jun 2022 08:03:18 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 17 Jun 2022 09:03:12 +0100
Message-ID: <f83eb255-89fe-90dc-3670-79b8684389f1@samsung.com>
Date: Fri, 17 Jun 2022 10:03:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <snitzer@redhat.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <f4cf6348-dd94-aa82-7519-318248c51151@opensource.wdc.com>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7djPc7rupmuSDK59Z7FYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423UPKNbyEKjulrbF5V1z
 2CzmL3vKbrHm5lMWi7aNXxkdBDwuX/H2+HdiDZvHzll32T0uny312LSqk81jYcNUZo/NS+o9
 dt9sAMq13mf1eL/vKpvH+i1XWTw2n672+LxJzqP9QDdTAF8Ul01Kak5mWWqRvl0CV8aqu59Z
 C/4LVHT8e8PawPiWt4uRg0NCwETix46ELkZODiGBFYwSRy9JQNhfGCWmrhDvYuQCsj8zSqxp
 ecMKkgCp39fzhwUisZxRYt2FKexwVVNfvoBydjFKLGn+yAjSwitgJ3Hr11wWEJtFQFXi/q3F
 UHFBiZMzn4DFRQUiJFa2vmEBOUlYwFGi6UQSSJhZQFzi1pP5TCBhEYE8iXn/oMK3mCTuP60D
 CbMJaEk0drKDhDkF3CTuff7NDlGiKdG6HcaWl9j+dg4zxL/KEv92MkO8Uiux9tgZsIMlBL5x
 Sux7eosJIuEi8fb4NhYIW1ji1fEt7BC2jMT/nfOhaqolnt74zQzR3MIo0b9zPRvEAmuJvjM5
 EDWOEqtanjBChPkkbrwVhDiHT2LStunMExhVZyEFwywk/85C8sEsJB8sYGRZxSieWlqcm55a
 bJSXWq5XnJhbXJqXrpecn7uJEZgmT/87/mUH4/JXH/UOMTJxMB5ilOBgVhLhNQtemSTEm5JY
 WZValB9fVJqTWnyIUZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qBKet7l0PagYbSmUyc
 K1ySGjNvZfYwSonOn57Ix2zXnM28y1lURS9V/lbkZpW6t+wZD/f7Bja2+0wLecBgnHqkc/V8
 U7462aAcz6u/4htO5rjt5dFdpHOHZappR9CSW0UrVSIksvrSd0R17ensm2GuxHN06fvW7r7p
 E9bMYU2NSrm47re41dIJVo4WXneZfu8pKLXluLvIfJ7X/Mm9F+X0N56ecXtV2Sr1Dfo2NmF2
 nj6/fZLnzGcTlfrG1GNzYoPbghUl+hsVOFeL2DBaMGWfWfRZqc9Y+pLA8tJVNufnxQTNts/2
 4Vy9VDg8ZnNDXleA4PkvztMu7/u7brGsco6vQEdyrHbCnN47jkt7ipVYijMSDbWYi4oTAdVN
 gNACBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t/xu7pupmuSDPouKVisvtvPZjHtw09m
 i99nzzNb7H03m9Xiwo9GJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87boHFGt5CFR3S9vi8q45
 bBbzlz1lt1hz8ymLRdvGr4wOAh6Xr3h7/Duxhs1j56y77B6Xz5Z6bFrVyeaxsGEqs8fmJfUe
 u282AOVa77N6vN93lc1j/ZarLB6bT1d7fN4k59F+oJspgC9Kz6Yov7QkVSEjv7jEVina0MJI
 z9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PV3c+sBf8FKjr+vWFtYHzL28XIySEh
 YCKxr+cPSxcjF4eQwFJGiaa5jSwQCRmJT1c+skPYwhJ/rnWxQRR9ZJRY+OIdM4Szi1Hi2YTb
 TCBVvAJ2Erd+zQXrZhFQlbh/azEjRFxQ4uTMJ2BxUYEIiU/LJrB2MXJwCAs4SjSdSAIJMwuI
 S9x6Mp8JJCwikCcx7x9U+BaTxP2ndRCrzrNIXD68mR2khk1AS6KxE+w2TgE3iXuff7ND1GtK
 tG6HseUltr+dwwxSLiGgLPFvJzPEK7USr+7vZpzAKDoLyW2zkBwxC8mkWUgmLWBkWcUoklpa
 nJueW2yoV5yYW1yal66XnJ+7iRGYYrYd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4TULXpkkxJuS
 WFmVWpQfX1Sak1p8iNEUGEATmaVEk/OBSS6vJN7QzMDU0MTM0sDU0sxYSZzXs6AjUUggPbEk
 NTs1tSC1CKaPiYNTqoFJeNO+zT3SdTe6CmSn1c+ae+6E2/0gl8kcEonyM9+yng/4pZzW0fM4
 b1Pm6lllfmpJbw+Vzr4xfc6bYO9LfwML/t+Zsdp/ouQmz4lZ525J6Xkb7ug+xSJYd8r3r5Q5
 E9v0+dNWq5i2yU5eMeXk0za29CVW+3y2TWnjNq40iq0tM+a+XN+7jfFTRNJrqXmf2kx//n0/
 zVLRqWqWB/d+zvIs/rMmujrtDg87K6uPln3YMOf7xcy8nJBnjSK+PyWEcjIs/i2x22J8Y3ba
 pah6DtlOO20mOynt48kM9+7oFNzaeWHDe7PD9Wuj/5Xsfbh88paIBIXbK/+oVNjo17LnLDK1
 dT5+3LNieuzrRqEOxa9KLMUZiYZazEXFiQATp8hqugMAAA==
X-CMS-MailID: 20220617080318eucas1p18554421449b17c4a2ad7816dd6584383
X-Msg-Generator: CA
X-RootMTR: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
 <63b0cfb6-eb24-f058-e502-2637039c5a98@opensource.wdc.com>
 <0b819562-8b16-37b6-9220-28bf1960bccb@samsung.com>
 <0c4f30f2-c206-0201-31e3-fbb9edbdf666@opensource.wdc.com>
 <4746a000-2220-211e-1bd6-79c15c18a85c@samsung.com>
 <e0dc08fd-cd00-240d-edc4-5799d51aa5a8@opensource.wdc.com>
 <a945def3-ba5a-7539-e96a-43ade0ae674a@samsung.com>
 <f4cf6348-dd94-aa82-7519-318248c51151@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-06-17 08:56, Damien Le Moal wrote:
>>
>> So we call this function device_not_matches_zone_sectors() from
>> validate_hardware_zoned_model() for each target and we let the validate
>> succeed even if the target's zone size is different from the underlying
>> device zone size if this feature flag is set. Let me know if I am
>> missing something and how this can be moved to
>> validate_hardware_zoned_model().
> 
> Your change does not match the function name
> device_not_matches_zone_sectors(), at all. So I think this is wrong.
> 
> The fact is that zone support in DM has been built under the following
> assumptions:
> 1) A zoned device can be used to create a *zoned* target (e.g. dm-linear,
> dm-flakey, dm-crypt). For this case, the target *must* use the same zone
> size as the underlying devices and all devices used for the target must
> have the same zone size.
> 2) A zoned device can be used to create a *regular* device target (e.g.
> dm-zoned). All zoned devices used for the target must have the same zone size.
> 
> This new target driver completely breaks (1) and does not fit with (2). I
> suspect this is why you are seeing problems with dm_revalidate_zones() as
> that one uses the underlying device instead of the target report zones.
> 
> Based on this analysis, validate_hardware_zoned_model() definitely needs
> to be changed. But device_not_matches_zone_sectors() is to check the
> assumptions (1) and (2) so changing it for your new case is wrong in my
> opinion. You need another set of assumptions (3) (define that well please)
> and modify validate_hardware_zoned_model() so that the defined constraints
> are checked. Using a target flag to indicate the type of zoned target is
> fine by me.
> 
Got it. Thanks for the explanation. Renaming
device_not_matches_zone_sectors() function to something meaningful with
my changes should address what you have pointed out to accommodate all
three types.

I see that something similar was done to dm_table_supports_zoned_model()
to accommodate type 2(dm-zoned) with different underlying zoned models
even though the initial impl. supported only type 1.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

