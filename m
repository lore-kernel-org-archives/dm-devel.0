Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA04CCA47E
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 06:41:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-1Jw9j_iQMbyhuAjHBtsGRA-1; Fri, 17 Jun 2022 02:41:18 -0400
X-MC-Unique: 1Jw9j_iQMbyhuAjHBtsGRA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC0DC29ABA1C;
	Fri, 17 Jun 2022 06:41:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6995C40334D;
	Fri, 17 Jun 2022 06:41:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31DF1194705F;
	Fri, 17 Jun 2022 06:41:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12DCB194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 06:41:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0079240CFD0A; Fri, 17 Jun 2022 06:41:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF2FE40CF8EA
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:41:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7ADE811E83
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:41:14 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-GbH5RvXMPeOnTYYFa2UoWQ-1; Fri, 17 Jun 2022 02:41:10 -0400
X-MC-Unique: GbH5RvXMPeOnTYYFa2UoWQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220617064109euoutp0111ca28811bfa0ac95adcee93bcd17c78~5VT_QYhhv2751627516euoutp01a
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:41:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220617064109euoutp0111ca28811bfa0ac95adcee93bcd17c78~5VT_QYhhv2751627516euoutp01a
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220617064109eucas1p23530ef3515aeb360ae436ce1ba964be0~5VT_A4S7T0454204542eucas1p2I;
 Fri, 17 Jun 2022 06:41:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 2A.DC.10067.5022CA26; Fri, 17
 Jun 2022 07:41:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220617064108eucas1p15e0d6b7d599a4e27c976477e06bf5fd4~5VT9oCMwC2665326653eucas1p1S;
 Fri, 17 Jun 2022 06:41:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220617064108eusmtrp26acf19d34def01c63d96f2fd259b1d80~5VT9m5lcq1360513605eusmtrp2D;
 Fri, 17 Jun 2022 06:41:08 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-1d-62ac2205d448
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id F1.9C.09038.4022CA26; Fri, 17
 Jun 2022 07:41:08 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220617064108eusmtip23f0db2ae1dd1feec8d57d429ad712ae0~5VT9dOlJ00040800408eusmtip26;
 Fri, 17 Jun 2022 06:41:08 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 17 Jun 2022 07:41:02 +0100
Message-ID: <a945def3-ba5a-7539-e96a-43ade0ae674a@samsung.com>
Date: Fri, 17 Jun 2022 08:40:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <snitzer@redhat.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <e0dc08fd-cd00-240d-edc4-5799d51aa5a8@opensource.wdc.com>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djPc7qsSmuSDE7c4LRYfbefzWLah5/M
 Fr/Pnme2aG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5QrOUhs8Xe
 W9oWl3fNYbOYv+wpu8Wam09ZLNo2fmV0EPS4fMXb49+JNWweO2fdZfe4fLbUY9OqTjaPhQ1T
 mT02L6n32H2zASjXep/V4/2+q2we67dcZfHYfLra4/MmOY/2A91MAXxRXDYpqTmZZalF+nYJ
 XBmzX65hKnjIVTGxZTtbA+Mnji5GTg4JAROJfU/bWEBsIYEVjBINlyK7GLmA7C+MEm0NbYwQ
 zmdGiXuzD7HDdNz58oMVIrGcUWLqy25WuKrZE1YzQTi7GCUW72liBWnhFbCT+PuklxnEZhFQ
 lZhyZQ4TRFxQ4uTMJ2DLRQUiJFa2vgGyOTiEBRwlmk4kgYSZBcQlbj2ZzwQSFhHIk5j3Lwlk
 PLNAC7NE1/6HzCBxNgEticZOsOM4Bdwk7h2cxgLRqinRuv03O4QtL7H97RywcgkBZYl/O5kh
 fqmVWHvsDDvISAmBNi6Jx9f6WCASLhJLG+YzQtjCEq+Ob4F6Xkbi/875TBB2tcTTG7+ZIZpb
 GCX6d65ng1hgLdF3JgeixlFiVcsTRogwn8SNt4IQ5/BJTNo2nXkCo+ospHCYheThWUg+mIXk
 gwWMLKsYxVNLi3PTU4uN8lLL9YoTc4tL89L1kvNzNzEC0+bpf8e/7GBc/uqj3iFGJg7GQ4wS
 HMxKIrxmwSuThHhTEiurUovy44tKc1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBK
 NTAtjJeLmhDia3jgTYThLoPphelKFzYdW/7a/DAPx+/Xc9bmphc/3F0u/SHheBPjc8lfpcne
 ucluO2z+X+HY6PCm9WRLahmLQ/OxSZHu6ZemqP43OTBzq/nbK7F/zZkjYksU0wufh17V5zw1
 ObFnu0DwQc/Hq4qPVh2/3v/ugtXOPR/ubKjrf3jk6aIrRhUTZmysOyCw5fsxs6oHC4+fWRZd
 w1d09K7iq9Krh993q1vMP6/IkaV4sNH/9grhk4eXtamYeOixCUxvbZztZbK9+MWhRP2rbDlf
 L3a3nffO7mNSe558VTDpsjaz/c1dp15wcKfwrPxY/rH7z+TWnMN99gwHzv9IbK/R/PNwjk7O
 ulUlSizFGYmGWsxFxYkABK3WjAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t/xe7osSmuSDB6v1bdYfbefzWLah5/M
 Fr/Pnme2aG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5QrOUhs8Xe
 W9oWl3fNYbOYv+wpu8Wam09ZLNo2fmV0EPS4fMXb49+JNWweO2fdZfe4fLbUY9OqTjaPhQ1T
 mT02L6n32H2zASjXep/V4/2+q2we67dcZfHYfLra4/MmOY/2A91MAXxRejZF+aUlqQoZ+cUl
 tkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehmzX65hKnjIVTGxZTtbA+Mn
 ji5GTg4JAROJO19+sHYxcnEICSxllHh+bjILREJG4tOVj+wQtrDEn2tdbCC2kMBHRolz+0sg
 GnYxSlw5vJsVJMErYCfx90kvM4jNIqAqMeXKHCaIuKDEyZlPwIaKCkRIfFo2Aaieg0NYwFGi
 6UQSSJhZQFzi1pP5TCBhEYE8iXn/kkDGMwu0MEt07X/IDLHrHrPEwmftjCBFbAJaEo2dYLdx
 CrhJ3Ds4jQVijqZE6/bf7BC2vMT2t3OYQcolBJQl/u1khnilVuLV/d2MExhFZyE5bhaSK2Yh
 mTQLyaQFjCyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxApPNtmM/t+xgXPnqo94hRiYOxkOM
 EhzMSiK8ZsErk4R4UxIrq1KL8uOLSnNSiw8xmgJDaCKzlGhyPjDd5ZXEG5oZmBqamFkamFqa
 GSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MK2YsOPygoOfv9daKvG58+x2vWKz4tCa6FOL
 vz5vuxWnFHK6dUf+G5EPgnaqi49v67+qkpJVvuh2Rcy2GmYLo9+drJ1SC8qWukSZ1h2M2J9X
 1+901ktVbuJ3i9O1qbYq72VDNVlZLudv2vcrpdr6HOcC2fplJUff3O3wbbj+60Fo1wxf5h8K
 f+UV5j7KdeO2zZ5rZ/tzAktG4rafuV5a90UFejl39t6aEXaOdbnL2s0OLkwGCc5zvByvqXR5
 z2C7tt0u6ZHUrdcfYp2unTl77oKC7Ns+5+bats5XHxY8UAuJXVjC7rg9Yus8ZZY1Ux6G3w1u
 l/nxXEvwUOMDk0SfoLlR924/0zfdW2gQbzvlkhJLcUaioRZzUXEiAE1Kxjy/AwAA
X-CMS-MailID: 20220617064108eucas1p15e0d6b7d599a4e27c976477e06bf5fd4
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
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

On 2022-06-17 08:12, Damien Le Moal wrote:
>> I think this is a cleaner approach using features flag and io_hints
>> instead of messing with the revalidate zone function:
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 135c0cc190fb..c97a71e0473f 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1618,6 +1618,9 @@ static int device_not_matches_zone_sectors(struct
>> dm_target *ti, struct dm_dev *
>>  	if (!blk_queue_is_zoned(q))
>>  		return 0;
>>
>> +	if(dm_target_supports_emulated_zone_size(ti->type))
>> +		return 0;
>> +
> 
> This should be in validate_hardware_zoned_model(), not here.
> 
I am not sure about this comment. We need to peek into the individual
target from the table to check for this feature right?

if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors,
&zone_sectors)) {
	DMERR("%s: zone sectors is not consistent across all zoned devices",
        dm_device_name(table->md));
	return -EINVAL;
	}

So we call this function device_not_matches_zone_sectors() from
validate_hardware_zoned_model() for each target and we let the validate
succeed even if the target's zone size is different from the underlying
device zone size if this feature flag is set. Let me know if I am
missing something and how this can be moved to
validate_hardware_zoned_model().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

