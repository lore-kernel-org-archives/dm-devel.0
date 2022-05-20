Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706E2C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 09:09:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-mlyP1YMxNcmWOPruOlD74Q-1; Fri, 20 May 2022 05:09:33 -0400
X-MC-Unique: mlyP1YMxNcmWOPruOlD74Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85B973804506;
	Fri, 20 May 2022 09:09:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 742D92166B25;
	Fri, 20 May 2022 09:09:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43149194705A;
	Fri, 20 May 2022 09:09:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 303571947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 09:09:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 123B2492C14; Fri, 20 May 2022 09:09:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DED3401E9D
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:09:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9EBB801210
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:09:29 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-clBI3L1jNJi7o47v1rgbnA-1; Fri, 20 May 2022 05:09:27 -0400
X-MC-Unique: clBI3L1jNJi7o47v1rgbnA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220520090926euoutp01992f0f69890ca2722c63edc184984977~wxRc6516v1875218752euoutp01f
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:09:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220520090926euoutp01992f0f69890ca2722c63edc184984977~wxRc6516v1875218752euoutp01f
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220520090926eucas1p1bc12b0a9dc442b78da3af9ddc2202325~wxRcsrHdB0182901829eucas1p19;
 Fri, 20 May 2022 09:09:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B3.9D.10009.6CA57826; Fri, 20
 May 2022 10:09:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220520090925eucas1p26954f3932778b1e6d579d50095b3f138~wxRcJyMFD2110521105eucas1p2s;
 Fri, 20 May 2022 09:09:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220520090925eusmtrp1b0e8eda967a664f924b0e66aa52a2ca9~wxRcI0pXY2190521905eusmtrp1Y;
 Fri, 20 May 2022 09:09:25 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-49-62875ac6612c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id EC.2D.09522.5CA57826; Fri, 20
 May 2022 10:09:25 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220520090925eusmtip11d5b71aafeef920d4c670fe714700b5a~wxRb-0jrS1395113951eusmtip1U;
 Fri, 20 May 2022 09:09:25 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.20) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 20 May 2022 10:09:24 +0100
Message-ID: <fc015adb-4b18-a144-7859-cfe434b74166@samsung.com>
Date: Fri, 20 May 2022 11:09:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Naohiro Aota <Naohiro.Aota@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220519075926.6h4ka3qbo3vv26ve@naota-xeon>
X-Originating-IP: [106.210.248.20]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djP87rHotqTDPrnylusvtvPZvH77Hlm
 i73vZrNaXPjRyGSxcvVRJoueAx9YLPbe0ra49HgFu8WevSdZLC7vmsNmMX/ZU3aLicc3s1qs
 ufmUxYHX49+JNWweO2fdZfe4fLbUY/OSeo/dNxuAIq33WT3e77vK5rF+y1UWj8+b5DzaD3Qz
 BXBFcdmkpOZklqUW6dslcGXcm3KbraCVu+Laut9sDYwnOLoYOTkkBEwk7p+Zw9TFyMUhJLCC
 UWJd32NWCOcLo8T5teegnM+MEl+vnGaFabl3cjk7iC0ksJxRYts6NbiiJyd/QM3aBeQsfccM
 UsUrYCcxf9NZJhCbRUBVYur1TlaIuKDEyZlPWEBsUYEIiWmzzrB1MXJwCAukSOxYWQQSZhYQ
 l7j1ZD5Yq4iAusTHp0fZQOYzCxxmldh0FuQ8Dg42AS2Jxk6wgzgFLCVOHj/MDNGrKdG6/Tc7
 hC0vsf3tHGaQcgkBJYltv0wgfqmVWHvsDDvISAmBc5wSp950sUMkXCSuX25nhrCFJV4d3wIV
 l5E4PbmHBcKulnh64zczRHMLo0T/zvVsEAusJfrO5EDUOEpc+vYZai+fxI23ghDn8ElM2jad
 eQKj6iykgJiF5ONZSD6YheSDBYwsqxjFU0uLc9NTiw3zUsv1ihNzi0vz0vWS83M3MQKT3el/
 xz/tYJz76qPeIUYmDsZDjBIczEoivIy5LUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQK
 CaQnlqRmp6YWpBbBZJk4OKUamNxCf7tJ1t2s1Hz+7jrnPw6zY7nP1Gae4nZ7Ut5V97hxi/xt
 27a+6Ac71q7fGzmfObXL7nrh1pVLb86TrPi3trps1Ylt+lOUTh4wmu3361fuzrtdTxuZRX3Y
 fu/uz5ti8PP+lKT5Gz5sWim9368tN3BK7VS1qP0Xvky5eyMzsknr+TbnrNDtLHdf+tWybRe7
 F3m5h8nw+qXApDlRq9bElXze7jD39oOz755tF5omKL3n+gz5ae2P/x3/cDetnbtBpkk4XVxo
 YkR0+UGW2R4Wz9YuMHxaXjhj5elFk4uTWG9/PJrH9DLlW0VmyaYrHauP37d7qqvsbx4iFLvV
 5Vm0q16nyIUcjfNh8132sHHPktRTYinOSDTUYi4qTgQAS/3CwuUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e/4Xd2jUe1JBucOm1usvtvPZvH77Hlm
 i73vZrNaXPjRyGSxcvVRJoueAx9YLPbe0ra49HgFu8WevSdZLC7vmsNmMX/ZU3aLicc3s1qs
 ufmUxYHX49+JNWweO2fdZfe4fLbUY/OSeo/dNxuAIq33WT3e77vK5rF+y1UWj8+b5DzaD3Qz
 BXBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GXc
 m3KbraCVu+Laut9sDYwnOLoYOTkkBEwk7p1czt7FyMUhJLCUUeLjl1lsEAkZiU9XPrJD2MIS
 f651sUEUfWSUeHh+GZSzi1Hi/u+zzCBVvAJ2EvM3nWUCsVkEVCWmXu9khYgLSpyc+YQFxBYV
 iJB4sPssWFxYIEXi0afZYDazgLjErSfzwXpFBNQlPj49ygYRP8wqsWuJOMSyd4wSO3Z+Zuxi
 5OBgE9CSaOwEu45TwFLi5PHDzBD1mhKt23+zQ9jyEtvfzmEGKZcQUJLY9ssE4plaiVf3dzNO
 YBSdheS6WUiumIVk0iwkkxYwsqxiFEktLc5Nzy021CtOzC0uzUvXS87P3cQITBLbjv3cvINx
 3quPeocYmTgYDzFKcDArifAy5rYkCfGmJFZWpRblxxeV5qQWH2I0BQbRRGYp0eR8YJrKK4k3
 NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpgCgrZYGzEus/cpDohxXPx
 v2V7X3GsE+/ekbPvwL6G0oeTjlxzVRP+u1l1XvtrR7G+PRbrJh1WUDDzfBnhuTdlM3Privfm
 JtwuDMJexpctXa/0TtZY9eqnxclNTFyHuZcH/W/Jcm+Ya74y5J3l1Y0R1/gWvGtc/0O9vHYr
 7yfzkt8pDJnBKvfyYj5MKzE7uFTrfOX/1W5XE6+YX+tlMTtnfcyc2/cSp1uG5YKSvZ+OqzK4
 PhF8evlhzyGHuglXWur4VfY1zLLX4LxYqTk7fXKzrKCp0AvvL+fydE6IS86Wf82QL+FTuDk+
 T+tS/8UHe6tPn1t52vTqn/UMgpY3d37ez73sB+O/+Nh/jUf1RBR1lViKMxINtZiLihMBGIST
 t5sDAAA=
X-CMS-MailID: 20220520090925eucas1p26954f3932778b1e6d579d50095b3f138
X-Msg-Generator: CA
X-RootMTR: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <20220519075926.6h4ka3qbo3vv26ve@naota-xeon>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "dsterba@suse.com" <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/19/22 09:59, Naohiro Aota wrote:
>> +
>>  static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
>> -			   int rw, u64 *bytenr_ret)
>> +			   int rw, int mirror, u64 *bytenr_ret)
>>  {
>>  	u64 wp;
>>  	int ret;
>> +	bool zones_empty = false;
>>  
>>  	if (zones[0].type == BLK_ZONE_TYPE_CONVENTIONAL) {
>>  		*bytenr_ret = zones[0].start << SECTOR_SHIFT;
>> @@ -775,13 +808,31 @@ static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
>>  	if (ret != -ENOENT && ret < 0)
>>  		return ret;
>>  
>> +	if (ret == -ENOENT)
>> +		zones_empty = true;
>> +
> 
> I think, we don't need this. We need to issue the zeroout when
> zones[0]->cond == BLK_ZONE_COND_EMPTY && !is_power_of_2(...) after sending
> ZONE_RESET if necessary. No?
> 
Yeah. I added this extra check to cover all the cases possible. But you
are right that it is enough to issue zeroout only for this condition:
zones[0]->cond == BLK_ZONE_COND_EMPTY && !is_power_of_2(...) as both the
zones empty is not likely to happen.
>>  	if (rw == WRITE) {
>>  		struct blk_zone *reset = NULL;
>> +		bool is_sb_offset_write_req = false;
>> +		u32 reset_zone_nr = -1;
>>  
>> -		if (wp == zones[0].start << SECTOR_SHIFT)
>> +		if (wp == zones[0].start << SECTOR_SHIFT) {
>>  			reset = &zones[0];
>> -		else if (wp == zones[1].start << SECTOR_SHIFT)
>> +			reset_zone_nr = 0;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

