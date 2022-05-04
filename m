Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9167BC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-e7Hoa4u5Nl2DYVaYxHAxJQ-1; Wed, 04 May 2022 17:23:29 -0400
X-MC-Unique: e7Hoa4u5Nl2DYVaYxHAxJQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D61721014A67;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C05DB550A4A;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 354201947B88;
	Wed,  4 May 2022 21:23:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DBAA1947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 08:53:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D669741373D; Wed,  4 May 2022 08:53:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC738463EC3
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:53:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE78A8002B2
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:53:36 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-ivQ7u6BHNnaW2aFLNIjyyA-1; Wed, 04 May 2022 04:53:35 -0400
X-MC-Unique: ivQ7u6BHNnaW2aFLNIjyyA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220504085333euoutp01892356dfaa2dc2792379b2d5daccf0fc~r2vBKUIwx2012220122euoutp01f
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:53:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220504085333euoutp01892356dfaa2dc2792379b2d5daccf0fc~r2vBKUIwx2012220122euoutp01f
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220504085333eucas1p10e28ba95f5c2a26ea4db6270247ad64b~r2vAoyEmn0813908139eucas1p1Y;
 Wed,  4 May 2022 08:53:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 3F.B5.10260.D0F32726; Wed,  4
 May 2022 09:53:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220504085332eucas1p28b16e7db390eb2ffb2906ed2f2aa06b5~r2vAHVCh_1462414624eucas1p2y;
 Wed,  4 May 2022 08:53:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220504085332eusmtrp1117c59c1ab66ee22363450053dfd8684~r2vAF33E11107411074eusmtrp1T;
 Wed,  4 May 2022 08:53:32 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-a7-62723f0d3918
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 50.F7.09404.C0F32726; Wed,  4
 May 2022 09:53:32 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220504085332eusmtip1ef554c6afdc7b3b69842971ebc6d663b~r2u-6o-s51569915699eusmtip1e;
 Wed,  4 May 2022 08:53:32 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.170) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 4 May 2022 09:53:29 +0100
Message-ID: <850340eb-fc88-38a7-4c92-1c389e92b0ad@samsung.com>
Date: Wed, 4 May 2022 10:53:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Jaegeuk Kim <jaegeuk@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <YnGK/8lu2GW4gEY0@google.com>
X-Originating-IP: [106.210.248.170]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0xTZxjed249Lak7FJFPuulSnAlsoAx03zKkLszt6GZk/4y7FjlBslKh
 lW3qNksQkAZoAZFRQcSwjdvoaFG8UMKaAcpFFkux4IApoKaEiwFkHayOcjDj3/O+7/O87/N8
 +Whc0kAF0omqY5xapVDKKBFxpd3dGyqWq+O2F2f6IVNnO45qh/QUOjfjxlFXUQ+GCvQ/CNBi
 Ty+OrFPnSfTH32kYqq5tw9CYyYijnNYZAv2rG17unb6Po6X74ajA1g/QuMOIIevga+jOaJUA
 3bn0Pmq23iKQ/Xophcp/GhcgQ+Y8jpyGcYDyOywkqp+YJtDNQeluKWvv+4D13Kyj2Pz0KQHb
 O9xAsPaeVNZck02xFdoinLVUnmJvXJzF2BsDWorNTZ+i2GsZIyQ73eKgWFOjg2ANlgaSnTVv
 ivU9JIqK55SJX3HqbdFfiI487ntEJmf6fFPa6BFogZvWASENmUjosnVQOiCiJUwVgLfzcgm+
 mAPw7sKz1WIWwO5HC4LnEkPTyOrgZwAfdqX9zxrK76O8LAlzHcDf5nfqAE2LmWjYVrXB2yaY
 LfDy2XzgxWLGF94qGSO82J85CM8Zuykv3Y+JhcMZK/ZwJgAOjpVjXrx+WWq7ZBd4T+FMMwkb
 qu+RXj7FhMC07BVvwmU4bHaRvDYYZjQtCni8GTZNluK8/yBY6OzDePwd/KW9e2UnZAZEcG5i
 kvDuhMy7sLNiB8/xg66OxtXsL8GuwhyCxyfhuHMR57WnAdRfM1G89m2Y163kOe/ATP0FjG+v
 g85JX97OOlhwpRg3gFeNax7CuCaxcU0C45oEFwFRAwK4VE1SAqeJUHFfh2kUSZpUVULY4aNJ
 ZrD8q7s8HfNXQZXrSZgNYDSwAUjjsvXimB+T4yTieMXxE5z66OfqVCWnsQEpTcgCxIcTf1VI
 mATFMe5Ljkvm1M+nGC0M1GLyiHCfyastIfrdard8SPlP0Bmfp2+q+9V97m8L9mSlnOi/y1nq
 AZlgr8zevnVv1sOWpRr8gcvtvzd82GqcvW362NmifVCPxZEduT4qR+toxGe7DqagznRP1GOh
 pzf+1Jz7bGuZyecA80Lnp3Wjwdbo0NcXRsCflqzEyg8/iqpJUQVy06WxpqWBKGv16E7lRmmw
 LmjuSfF7te31JS9XPH3rxe9LcoCRNBV9srG5zrw5TLKvivJ3pP0VY8mtKyrfdDxyw+X9ZYZC
 l7xgz++LbZGhA2XnKdnMyZpnO96AYdHFB/R1u1qlrPMQLq8+o41hY7G8rXETiTEXtglfYcbg
 vX0yQnNEER6CqzWK/wAWnxgCRAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/xu7o89kVJBs/OalusP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLlauPMlk8WT+L2aLnwAcWi79d94Bi
 LQ+ZLf48NLSYdOgao8XTq7OYLPbe0ra49HgFu8WlRe4We/aeZLG4vGsOm8X8ZU/ZLSa0fWW2
 uDHhKaPFxOObWS3WvX7PYnHilrSDtMflK94e/06sYfOY2PyO3eP8vY0sHpfPlnpsWtXJ5rGw
 YSqzx+Yl9R67F3xm8th9s4HNo7f5HZvHztb7rB7v911l81i/5SqLx4TNG1k9Pm+SCxCM0rMp
 yi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL0Mt4ceU5a0Eb
 d8WcLf/YGxh/cnQxcnJICJhITNh+n6WLkYtDSGApo0TzimVMEAkZiU9XPrJD2MISf651sUEU
 fWSUWL9oKSOEs4tRYu2jOUDtHBy8AnYSR1eIgTSwCKhIbJ0ykRHE5hUQlDg58wkLiC0qECHx
 YPdZVhBbWMBP4sHRy2ALmAXEJW49mQ+2WASo99AikDgXUHwPq8TGlbdZIZbdY5SYsu0JI8gy
 NgEticZOsGZOIPPeplesEIM0JVq3/4YaKi+x/e0cZogPlCUm37gC9VmtxKv7uxknMIrOQnLf
 LCR3zEIyahaSUQsYWVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIEprltx35u2cG48tVHvUOM
 TByMhxglOJiVRHidlxYkCfGmJFZWpRblxxeV5qQWH2I0BQbSRGYp0eR8YKLNK4k3NDMwNTQx
 szQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpgalp7I+v5v+ufFd/sXCqr/Kq8ctEG
 5WV+gtILyybMulX/f+ouXg1+dfZpNl3ht1+8ucSdYtPx7O0GqxeHFQ7WvZ5zfXt+Zv/Gld8e
 bNBXsVY4afir4YNhnueuSMOUS+yyPcZL1/47XjLp8PuPkw9Y/X8v9iXb44VRa5T1lmgLBQa7
 ZKXpSer1Nfmqh7ln3ljtsv6i2gOeMBbuoMz9s3cyGka+v7/7YNEkg9mR537zuS3fdYxJfG6u
 73SfI1wXVZJSihZZS+9Q0Ojuubj+jfOeGK1ekZkZnTOeiTEFHyzemdUntqZtnaKl5WPVtDMJ
 sXNTpn1OCf82a6250J27hhb/n0uH8ypfTPjhzJ0fGjlhmhJLcUaioRZzUXEiAIorxvr8AwAA
X-CMS-MailID: 20220504085332eucas1p28b16e7db390eb2ffb2906ed2f2aa06b5
X-Msg-Generator: CA
X-RootMTR: 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746@eucas1p2.samsung.com>
 <20220427160255.300418-16-p.raghav@samsung.com>
 <YnGK/8lu2GW4gEY0@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: Re: [dm-devel] [PATCH 15/16] f2fs: ensure only power of 2 zone
 sizes are allowed
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, hch@lst.de, agk@redhat.com, naohiro.aota@wdc.com,
 sagi@grimberg.me, gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jonathan.derrick@linux.dev, kch@nvidia.com, chao@kernel.org,
 snitzer@kernel.org, josef@toxicpanda.com, linux-block@vger.kernel.org,
 dsterba@suse.com, kbusch@kernel.org, matias.bjorling@wdc.com,
 bvanassche@acm.org, axboe@kernel.dk, johannes.thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
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


On 2022-05-03 22:05, Jaegeuk Kim wrote:
> Applied to f2fs tree. Thanks,
>
Thanks Jaegeuk. I will remove the f2fs patches from my next revision

Regards,
Pankaj
> On 04/27, Pankaj Raghav wrote:
>> From: Luis Chamberlain <mcgrof@kernel.org>
>>
>> F2FS zoned support has power of 2 zone size assumption in many places
>> such as in __f2fs_issue_discard_zone, init_blkz_info. As the power of 2
>> requirement has been removed from the block layer, explicitly add a
>> condition in f2fs to allow only power of 2 zone size devices.
>>
>> This condition will be relaxed once those calculation based on power of
>> 2 is made generic.
>>
>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>>  fs/f2fs/super.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>> index f64761a15df7..db79abf30002 100644
>> --- a/fs/f2fs/super.c
>> +++ b/fs/f2fs/super.c
>> @@ -3685,6 +3685,10 @@ static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
>>  		return 0;
>>  
>>  	zone_sectors = bdev_zone_sectors(bdev);
>> +	if (!is_power_of_2(zone_sectors)) {
>> +		f2fs_err(sbi, "F2FS does not support non power of 2 zone sizes\n");
>> +		return -EINVAL;
>> +	}
>>  
>>  	if (sbi->blocks_per_blkz && sbi->blocks_per_blkz !=
>>  				SECTOR_TO_BLOCK(zone_sectors))
>> -- 
>> 2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

