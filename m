Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC6AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 23:29:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-P8DyLrCDNHyHnW6ydsVdcQ-1; Thu, 16 Jun 2022 19:29:42 -0400
X-MC-Unique: P8DyLrCDNHyHnW6ydsVdcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 604F71C00ACA;
	Thu, 16 Jun 2022 23:29:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04AED2026985;
	Thu, 16 Jun 2022 23:29:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D30CA194705F;
	Thu, 16 Jun 2022 23:29:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC912194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 23:29:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BE14492CA6; Thu, 16 Jun 2022 23:29:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97866492CA5
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:29:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 800F03C0CD49
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:29:38 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-KCMljmefPeCLTvMJuVuriA-1; Thu, 16 Jun 2022 19:29:36 -0400
X-MC-Unique: KCMljmefPeCLTvMJuVuriA-1
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; d="scan'208";a="204135502"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2022 07:29:34 +0800
IronPort-SDR: Y/+J9lyfhPthi8QvFtyfOmrTQ4gttW2DI4eyGYMc3tFd/lWHVijJyR0MFXhHfSoupTkrIfJ1IZ
 3S05YrFJYQoD2SZEl41RI6qk3dKFe4YaaueaEoJUrFxRHDmUgwE3/I2vDWWoZO2oSUfgvK1Gap
 6+cJycmUWombUubdHVNbdMKkE6oxVA/cJ3IV4kLUaQHUx2BCoiOgQo0yt8ji/uXUmLkQRTXq/G
 QoUDxTLNm8k+HaEDSZ9gUH+MzDNhe+Wc4UI0O2n7APzCwbnCT/HIYWW8JS2xwAIy4X0mxG7b2m
 9y40kyXUY6z8DP1fVJrDS2j3
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 15:47:46 -0700
IronPort-SDR: Rpto+ZN7wur/j9GGq1iZ5JRd6rDorW9t8ukI5ZfNfioXol72ESJZ1jbovJMrCW41Ea8m7GfWrm
 HXEkOBwfYM9uMKm9inzrxp+eyvyS1xb1CTnga2tZPQZI+8i6P883Yc4i3jv7TGCr09262iYDeD
 FDZuhF1ZoopOlRrqN6jxxQL9n4ikPvC346hC+v4v/dV8PUYWWZ36N7dNDbT57YJn/V9X3JMbsG
 N5nQPUojgC9yhr59cuHHE34Dw0z+Jdq3IJkE3G2GJbQlX8neBJ24JEXMqfld106CsPazM+i0Jg
 fpk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 16:29:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LPJKn2v5Kz1SVp9
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 16:29:33 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id aGcYcQ0pxLJe for <dm-devel@redhat.com>;
 Thu, 16 Jun 2022 16:29:32 -0700 (PDT)
Received: from [10.225.163.84] (unknown [10.225.163.84])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LPJKj0df1z1Rvlc;
 Thu, 16 Jun 2022 16:29:28 -0700 (PDT)
Message-ID: <065e9c29-0ceb-9b5d-ee99-ab501773c883@opensource.wdc.com>
Date: Fri, 17 Jun 2022 08:29:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498@eucas1p2.samsung.com>
 <20220615101920.329421-11-p.raghav@samsung.com>
 <064551fa-4575-87cb-d9da-90a34309f634@opensource.wdc.com>
 <50731e57-e0bb-179e-388c-32a18b0c610e@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <50731e57-e0bb-179e-388c-32a18b0c610e@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/16/22 18:55, Pankaj Raghav wrote:
> drivers/md/dm-table.c
>>> +++ b/drivers/md/dm-table.c
>>> @@ -251,7 +251,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>>  	if (bdev_is_zoned(bdev)) {
>>>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>>>  
>>> -		if (start & (zone_sectors - 1)) {
>>> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {
>>
>> This is wrong. And you are changing this to the correct test in the next
>> patch.
>>
> Yeah, I think I made a mistake while committing it. The next patch
> should only have the removing po2 condition check and these changes
> should have been only in this patch. I will fix it up!

This one and the next patch should be squashed together. They both deal
with non power of 2 zone size.


>>>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>>>  			       dm_device_name(ti->table->md),
>>>  			       (unsigned long long)start,
>>> @@ -268,7 +268,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>>  		 * devices do not end up with a smaller zone in the middle of
>>>  		 * the sector range.
>>>  		 */
>>> -		if (len & (zone_sectors - 1)) {
>>> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
>>>  			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
>>>  			       dm_device_name(ti->table->md),
>>>  			       (unsigned long long)len,
>>
>>


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

