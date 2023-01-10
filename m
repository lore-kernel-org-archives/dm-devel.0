Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5422C54EBE
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673341600;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q1kLxvC6jl8OhE/7aIyXy21LbtYiHyjkPLUc7OuZBVw=;
	b=dDbcUFQ7ETviKhUhpDscIUdOXK+QxrrBhfjPhq6YPuDM4TlUhFiD3ThFVNtx8r6uOGrLIB
	MBsxNOV69z86mytaoVHS1hCgXCs45M5gUCVDZechT211+gE39wEgJckr499cSjYy4N3s6i
	QDUe00rQQKEj+9C36JyAK7YqyHauK64=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-E6WlEsHKMi6U-W0l3jYtCA-1; Tue, 10 Jan 2023 04:06:37 -0500
X-MC-Unique: E6WlEsHKMi6U-W0l3jYtCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63A9280234E;
	Tue, 10 Jan 2023 09:06:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27C00140EBF4;
	Tue, 10 Jan 2023 09:06:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7F0E194037C;
	Tue, 10 Jan 2023 09:06:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 030641946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 09:06:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E1B9492B00; Tue, 10 Jan 2023 09:06:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36296492B01
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:06:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BB2B1C02D47
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:06:31 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606--iPcN-dANc-tMwCspAajLQ-1; Tue, 10 Jan 2023 04:06:25 -0500
X-MC-Unique: -iPcN-dANc-tMwCspAajLQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230110090624euoutp02dc884cf390de8ae275ca88da206c02d2~4504zbbt62551025510euoutp02w
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:06:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230110090624euoutp02dc884cf390de8ae275ca88da206c02d2~4504zbbt62551025510euoutp02w
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20230110090624eucas1p1a99a687265afdabbd20f8c8d3e3aa446~4504neOvB2747527475eucas1p1w;
 Tue, 10 Jan 2023 09:06:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id A3.BB.43884.09A2DB36; Tue, 10
 Jan 2023 09:06:24 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230110090624eucas1p23074c6f9d41a5005e499906e01e58f3c~4504PejtP1569015690eucas1p2R;
 Tue, 10 Jan 2023 09:06:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230110090624eusmtrp1d651397f9466392829008648dc6eae9c~4504Ou5Kq1446914469eusmtrp1Z;
 Tue, 10 Jan 2023 09:06:24 +0000 (GMT)
X-AuditID: cbfec7f5-25bff7000000ab6c-a6-63bd2a90b6c9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 60.77.52424.F8A2DB36; Tue, 10
 Jan 2023 09:06:23 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230110090623eusmtip1acb75198ba36a03190e868d77e94b077~4504Cfj-20739907399eusmtip1K;
 Tue, 10 Jan 2023 09:06:23 +0000 (GMT)
Received: from [192.168.8.107] (106.210.248.241) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 10 Jan 2023 09:06:22 +0000
Message-ID: <e8326ea7-a354-e627-195f-dcd02b13accc@samsung.com>
Date: Tue, 10 Jan 2023 10:06:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To: Christoph Hellwig <hch@lst.de>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20230110065738.GE10289@lst.de>
X-Originating-IP: [106.210.248.241]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djPc7oTtPYmG6y/J2ax+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeJv1z0mizMvP7NY7L2lbXF51xw2i/nLnrJb3JjwlNHi
 xC1pB16Py1e8PS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n9Ti70tHj/b6rQOHT1R6fN8l5tB/o
 ZgrgjuKySUnNySxLLdK3S+DK6O7+z1hwl7di+ZybrA2MG7i7GDk5JARMJHrP72bqYuTiEBJY
 wSjx+lsrI0hCSOALo8TX30UQ9mdGiS1PuboYOcAaXl2UgKhfzijRd+84G1zNii5uiMRuRom1
 G6YxgyR4Bewk3i5YwAJiswioSmxpv8oOEReUODnzCVhcVCBKounCTzBbWCBa4uG882C9zALi
 EreezGcCsUUElCSevjrLCLKAWaCRWeLDj/uMIBexCWhJNHaCzeQU0JH4PeUgK0SvpkTr9t/s
 ELa8xPa3c5ghPlaWWHzhGiOEXSux9tgZdpCZEgKXOCV27l3OBvGli8ThP+UQNcISr45vYYew
 ZSROT+5hgbCrJZ7e+M0M0dvCKNG/cz1Ur7VE35kcCNNRYsm2cgiTT+LGW0GIa/gkJm2bzjyB
 UXUWUkDMQvLwLCQPzELywAJGllWM4qmlxbnpqcXGeanlesWJucWleel6yfm5mxiBie70v+Nf
 dzCuePVR7xAjEwfjIUYJDmYlEd6VnHuShXhTEiurUovy44tKc1KLDzFKc7AoifPO2Do/WUgg
 PbEkNTs1tSC1CCbLxMEp1cC0Zronyz2ftXwzHt1oNGHrvPMtw7Zyu3HvSo2zH6o69K9wyior
 CFhuc6urXv406UrItAnnfjoztP/sqnH9NmvRHa4954V8P6uti/lusESLx0ppptrZ7/feSzko
 XlSYecpmJfeHOTFfOpXOB7OqK70zd14z+ZNb/NOjgjMebf3xnOHEnHd+y8V2cxx8yv8hsnfW
 ktVP3dYfOFZXI/rVV1MiU00yWm7d6p+yZywrzUxes6dH53PcVg9IOnDHcYMDT5RlpoR6+3Td
 /uvdNe+EWf3t/r26VmPxIOnWrmmHGxWvCP5Onj6xePfvAhOGqp5d/zLZ15toOiTvdCuuFykP
 r1P4lMcmEPJn4sxLqtIuukeVWIozEg21mIuKEwEC6Xp64wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e/4Xd1+rb3JBrvWWVisvtvPZjHtw09m
 i99nzzNb7H03m9Viz6JJTBYrVx9lsvjbdY/J4szLzywWe29pW1zeNYfNYv6yp+wWNyY8ZbQ4
 cUvagdfj8hVvj8tnSz02repk89i8pN5j980GNo+drfdZPc6udPR4v+8qUPh0tcfnTXIe7Qe6
 mQK4o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy
 urv/Mxbc5a1YPucmawPjBu4uRg4OCQETiVcXJboYuTiEBJYyStzc8Iy1i5ETKC4j8enKR3YI
 W1jiz7UuNoiij4wSG5e+ZIdwdjNKPLh3FayDV8BO4u2CBSwgNouAqsSW9qvsEHFBiZMzn4DF
 RQWiJG6ef8gEYgsLREs87VnACGIzC4hL3HoyHywuIqAk8fTVWUaQBcwCjcwSH37cBysSErjL
 KPF9SRHI2WwCWhKNnWDzOQV0JH5POcgKMUdTonX7b3YIW15i+9s5zBAfKEssvnCNEcKulXh1
 fzfjBEbRWUjOm4XkjFlIRs1CMmoBI8sqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwDSx7djP
 LTsYV776qHeIkYmD8RCjBAezkgjvSs49yUK8KYmVValF+fFFpTmpxYcYTYFhNJFZSjQ5H5io
 8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamIqVoie/vHqSL2tD
 sq+w+YkKvib2B6f/hel+TGe/K/39+MPIl+cEtJTt0/rOT+FNS0nstD+9YkOH3Xt9+9nu33m3
 5rL2MMW7s/VUSiu1NTXuWqyygofth8kSfmGei0f4w1Iz5zn/cHHZMG3iF2kJa8/F/mqZ5vdY
 smf53Gb78reuvHPCki09YaoCjH84tfMN8zPtZ/7/PCla7HDdi0mffE9eXibvKajF8Od1nUD/
 akP7lOkBF9bcj+MyMBPnn84ZU7f33/ufjnFyH95P25fzndvWKDK2Y15T3JUPU+zOB9z4f31+
 04Wyn44F3Md+hb83/NnAFd6sKnTtJnvD8toHKVe3HN8TlvWGMUl8a2qxEktxRqKhFnNRcSIA
 0ga3ZZwDAAA=
X-CMS-MailID: 20230110090624eucas1p23074c6f9d41a5005e499906e01e58f3c
X-Msg-Generator: CA
X-RootMTR: 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338@eucas1p1.samsung.com>
 <20230106083317.93938-7-p.raghav@samsung.com>
 <20230110065738.GE10289@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 6/7] dm-zone: use generic helpers to
 calculate offset from zone start
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
Cc: axboe@kernel.dk, bvanassche@acm.org, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2023-01-10 07:57, Christoph Hellwig wrote:
> On Fri, Jan 06, 2023 at 09:33:16AM +0100, Pankaj Raghav wrote:
>> Use the bdev_offset_from_zone_start() helper function to calculate
>> the offset from zone start instead of open coding.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Reviewed-by: Mike Snitzer <snitzer@kernel.org>
>> ---
>>  drivers/md/dm-zone.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
>> index 3dafc0e8b7a9..ac6fc1293d41 100644
>> --- a/drivers/md/dm-zone.c
>> +++ b/drivers/md/dm-zone.c
>> @@ -390,7 +390,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
>>  	case REQ_OP_WRITE_ZEROES:
>>  	case REQ_OP_WRITE:
>>  		/* Writes must be aligned to the zone write pointer */
>> -		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
>> +		if (bdev_offset_from_zone_start(md->disk->part0,
>> +						clone->bi_iter.bi_sector) != zwp_offset)
> 
> I can't see how this actually cleans antyhing up, while it does add an
> overly long line.
>
While I do agree with the overly long line comment, I feel it makes the
intent more clear, as it is easy to overlook this math operation.

>>  		if (clone->bi_status == BLK_STS_OK &&
>>  		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
>>  			orig_bio->bi_iter.bi_sector +=
>> -				clone->bi_iter.bi_sector & mask;
>> +				bdev_offset_from_zone_start(disk->part0, clone->bi_iter.bi_sector);
> 
> Same here.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

