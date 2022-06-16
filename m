Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA96AC43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 09:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-3QtR-5obMPeT_FOWfi0BSA-1; Thu, 16 Jun 2022 05:55:44 -0400
X-MC-Unique: 3QtR-5obMPeT_FOWfi0BSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 136821C2B2AA;
	Thu, 16 Jun 2022 09:55:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AD0B4010150;
	Thu, 16 Jun 2022 09:55:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C793D1947062;
	Thu, 16 Jun 2022 09:55:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C773194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 09:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B45140CFD0A; Thu, 16 Jun 2022 09:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 064D840CF8E4
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 09:55:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E11141C2B2A1
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 09:55:36 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-9XUHcTH1M42FyZwR5ZK8Lg-1; Thu, 16 Jun 2022 05:55:35 -0400
X-MC-Unique: 9XUHcTH1M42FyZwR5ZK8Lg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220616095533euoutp025bddf8df287d802c950ba769790cd9d3~5EUbSmDB91733117331euoutp02R
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 09:55:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220616095533euoutp025bddf8df287d802c950ba769790cd9d3~5EUbSmDB91733117331euoutp02R
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220616095533eucas1p198f88427d18eac974902dcd6465a3ca1~5EUa8B59n0597505975eucas1p1J;
 Thu, 16 Jun 2022 09:55:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 57.0A.10067.51EFAA26; Thu, 16
 Jun 2022 10:55:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220616095533eucas1p11e0b6e865c36436af0c5961fed68c0bb~5EUafCeto2317623176eucas1p1F;
 Thu, 16 Jun 2022 09:55:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220616095533eusmtrp12668d16e772800c87b383a470d9ee908~5EUad9T0i2661126611eusmtrp1N;
 Thu, 16 Jun 2022 09:55:33 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-93-62aafe15f22f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 17.24.09038.41EFAA26; Thu, 16
 Jun 2022 10:55:32 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220616095532eusmtip20dfff485048e66a3d699052f99eaeaba~5EUaPlILp0880708807eusmtip2i;
 Thu, 16 Jun 2022 09:55:32 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 16 Jun 2022 10:55:26 +0100
Message-ID: <50731e57-e0bb-179e-388c-32a18b0c610e@samsung.com>
Date: Thu, 16 Jun 2022 11:55:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <snitzer@redhat.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <064551fa-4575-87cb-d9da-90a34309f634@opensource.wdc.com>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djP87qi/1YlGbz4LGmx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSz2LJrEZLFy9VEmiyfrZzFb9Bz4wGLxt+seUKzlIVDdLW2Ly7vm
 sFnMX/aU3eLGhKeMFmtuPmWxaNv4ldFB0OPyFW+PfyfWsHnsnHWX3ePy2VKPTas62TwWNkxl
 9ti8pN5j980GoFzrfVaP9/uusnms33KVxWPz6WqPz5vkPNoPdDMF8EVx2aSk5mSWpRbp2yVw
 ZUxc/Y25oJWromvaTLYGxnvsXYycHBICJhK/tvcC2VwcQgIrGCWmNd5hhHC+MEqsPH2eDaRK
 SOAzo8TtOdFdjBxgHVvvi0DULGeUWD1tBlQDUM3u92tYIZxdjBIP9kxlAunmFbCTOLZ5NguI
 zSKgKnHpwnlGiLigxMmZT8DiogIREitb34DZwgLJEi8nbAarYRYQl7j1ZD4TyGYRgTyJef+S
 QOYzCzQxS5w99YEdJM4moCXR2An2DqeAm0TvvKXsEK2aEq3bf0PZ8hLb385hhnhAWeLfTmaI
 72sl1h47A/a9hMA/Tolnk7pZIRIuEm97P0PZwhKvjm+BBpeMxOnJPSwQdrXE0xu/mSGaWxgl
 +neuZ4NYYC3RdyYHosZR4mj/HhaIMJ/EjbeCEOfwSUzaNp15AqPqLKSAmIXk4VlIPpiF5IMF
 jCyrGMVTS4tz01OLjfJSy/WKE3OLS/PS9ZLzczcxAtPm6X/Hv+xgXP7qo94hRiYOxkOMEhzM
 SiK8ZsErk4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUw
 OVY/375N7tLD1XNCn10yfz8j7OH3zp9qGR+aZs1ccI5ziWh4+iFu609VzivmmH38bZN4VezL
 lTrjQ2pzokyOMUn1mwhpLlblaFYVc/uRF7Dg9ntvRkemdYcd+6/6XMkP9L7zWLRI1+OanvbE
 3xNDWjfVe/gsmfPDYrbN9G9cDS3ztn5YVGuYu7HdJ/qWf9v/1u59J//M4urWVrltpKh73PaC
 WKKMCHMxb4lh3tzLOkLa0xQ1ApYuD1Vay7vvbiTPz1PTX8f5rNOUnZ+q53NV/n+53qstGaub
 uKRWa7A7bwiVMWd5LqK5sObP56JNRt5v2GX2qocKfGCWY/3rf8vDaE8sw6QJFo6LTm/sYLmu
 xFKckWioxVxUnAgAiLYCoAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t/xe7oi/1YlGdz5Zmqx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSz2LJrEZLFy9VEmiyfrZzFb9Bz4wGLxt+seUKzlIVDdLW2Ly7vm
 sFnMX/aU3eLGhKeMFmtuPmWxaNv4ldFB0OPyFW+PfyfWsHnsnHWX3ePy2VKPTas62TwWNkxl
 9ti8pN5j980GoFzrfVaP9/uusnms33KVxWPz6WqPz5vkPNoPdDMF8EXp2RTll5akKmTkF5fY
 KkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZUxc/Y25oJWromvaTLYGxnvs
 XYwcHBICJhJb74t0MXJxCAksZZSYsbabtYuREyguI/Hpykd2CFtY4s+1LjaIoo+MElfXrWKE
 cHYxShxY85cRpIpXwE7i2ObZLCA2i4CqxKUL56HighInZz4Bi4sKREh8WjYBbIOwQLLEywmb
 wWqYBcQlbj2ZzwRykYhAnsS8f0kg85kFmpgl/i87DrXsD6PE05YpYEVsAloSjZ1g13EKuEn0
 zlvKDjFHU6J1+28oW15i+9s5zBBfKkv828kM8UytxKv7uxknMIrOQnLdLCRXzEIyaRaSSQsY
 WVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIEppttx35u2cG48tVHvUOMTByMhxglOJiVRHjN
 glcmCfGmJFZWpRblxxeV5qQWH2I0BQbRRGYp0eR8YMLLK4k3NDMwNTQxszQwtTQzVhLn9Szo
 SBQSSE8sSc1OTS1ILYLpY+LglGpgkk3knntiWlrb1iMnch5XL8vb/0b5561+hQjzeimJ/Yr8
 3RPO2v0TnBfYIBH8873+EdUtb/Xt2CfO/3OjofJVvMjNC69vrbS9nbrtdv+1W9qfWYt2Nk+u
 FL6//bqk2uXGcHkJS1s1H/F22UT9lIzcOmm7nY7RpYn/js2aPGG+pu6xzx+efpJs2Vu1rfFA
 4mTu10p19ccdF51/PM842V4iYZ6LY2bUghRfZ46d+301l9o9cTvjlPuZ6+GSuf8TdviVzXDb
 oLnz5eFs6UN/3sru3LeQh4/Pyy3zbKH5h4/qnypvZqxZLFNvvrTisaSrz5kLSV4LpeO5P+5v
 kS/JFF2ycN3ahvtMsQ+nX3tQobPOXImlOCPRUIu5qDgRALbxfBzAAwAA
X-CMS-MailID: 20220616095533eucas1p11e0b6e865c36436af0c5961fed68c0bb
X-Msg-Generator: CA
X-RootMTR: 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498@eucas1p2.samsung.com>
 <20220615101920.329421-11-p.raghav@samsung.com>
 <064551fa-4575-87cb-d9da-90a34309f634@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 10/13] dm-table: use bdev_is_zone_start
 helper in device_area_is_invalid()
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
 jaegeuk@kernel.org, Luis Chamberlain <mcgrof@kernel.org>
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

drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -251,7 +251,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>  	if (bdev_is_zoned(bdev)) {
>>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>>  
>> -		if (start & (zone_sectors - 1)) {
>> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {
> 
> This is wrong. And you are changing this to the correct test in the next
> patch.
> 
Yeah, I think I made a mistake while committing it. The next patch
should only have the removing po2 condition check and these changes
should have been only in this patch. I will fix it up!
>>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>>  			       dm_device_name(ti->table->md),
>>  			       (unsigned long long)start,
>> @@ -268,7 +268,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>  		 * devices do not end up with a smaller zone in the middle of
>>  		 * the sector range.
>>  		 */
>> -		if (len & (zone_sectors - 1)) {
>> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
>>  			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
>>  			       dm_device_name(ti->table->md),
>>  			       (unsigned long long)len,
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

