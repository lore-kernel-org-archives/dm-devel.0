Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D567DC19F2C
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659011108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W48UKML/mr93JtbnhFEkaUolfbUmnMiJ3HzOlZitE7I=;
	b=NynHWvjmVDduvDvB6K8e6FtT1hXRdtNrsVBrJTNnxLI87X0hp8lZJs7w9XsBjXLQzha0Gm
	7jH3bFHqosSa85KOhz/noMeQXsRhtiIaUWjItkiMo5CjQV2oAhNldLsag3nPgKjWHgSK+H
	a2HSiO9dgkhhj7qG0vbXYp7JSVB8v8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-qaJnXzgoPRW8xLE6B_-jSg-1; Thu, 28 Jul 2022 08:25:05 -0400
X-MC-Unique: qaJnXzgoPRW8xLE6B_-jSg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31AEA80A0B7;
	Thu, 28 Jul 2022 12:25:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9F8C7401473;
	Thu, 28 Jul 2022 12:25:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64CA11945DA7;
	Thu, 28 Jul 2022 12:25:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2EE81945D85
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 12:25:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A4C95C27D95; Thu, 28 Jul 2022 12:25:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D4BAC15D4F
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:25:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E98D101A586
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:25:01 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-Kl85PCP3NHGUB-QFnhSkRg-1; Thu, 28 Jul 2022 08:24:59 -0400
X-MC-Unique: Kl85PCP3NHGUB-QFnhSkRg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220728122458euoutp02eb6edc7cf1cab55a6cd227e0e9c91eb2~F-c3ynsgL0229602296euoutp02e
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:24:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220728122458euoutp02eb6edc7cf1cab55a6cd227e0e9c91eb2~F-c3ynsgL0229602296euoutp02e
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220728122458eucas1p2f6a3dc82c8874299cf12738d9323f961~F-c3fPVm81954419544eucas1p2e;
 Thu, 28 Jul 2022 12:24:58 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 6C.41.09664.A1082E26; Thu, 28
 Jul 2022 13:24:58 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220728122457eucas1p29f23e1181e0083319bf787dcbd10d36d~F-c3A2Q3O1768117681eucas1p2K;
 Thu, 28 Jul 2022 12:24:57 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220728122457eusmtrp2effe5a2c79b67ca0f811eea703074aba~F-c2-2PWw0151001510eusmtrp2L;
 Thu, 28 Jul 2022 12:24:57 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-8e-62e2801ae01f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id DE.F6.09095.91082E26; Thu, 28
 Jul 2022 13:24:57 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220728122457eusmtip208fb9038b74b0c501bf5a1b6918fc63c~F-c20eKYb3102831028eusmtip2h;
 Thu, 28 Jul 2022 12:24:57 +0000 (GMT)
Received: from [106.110.32.100] (106.110.32.100) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 28 Jul 2022 13:24:56 +0100
Message-ID: <9eed99b8-7e35-841c-5ec1-97b7107f328f@samsung.com>
Date: Thu, 28 Jul 2022 14:24:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <e9663c20-65d5-48f5-3fe1-e3a8f5ab3214@opensource.wdc.com>
X-Originating-IP: [106.110.32.100]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7pSDY+SDPY8FbFYfbefzWLah5/M
 Fr/Pnme22PtuNqvFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9Zba4
 MeEpo8Wam09ZLE7cknbg97h8xdtj56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833cV
 KHS62uPzJjmP9gPdTAHcUVw2Kak5mWWpRfp2CVwZJ6+sYi6YpVDx+uQXpgbGN5JdjJwcEgIm
 Egvaetm6GLk4hARWMEosufqEHcL5wiixae1hVgjnM6PEhZcnGWFa9l2dywZiCwksZ5T48ywD
 wgYq2vtfE6JhN6PEqe1LmEASvAJ2Erv3fWfuYuTgYBFQlVj1Ng4iLChxcuYTFhBbVCBSYs3u
 s+wgtrBAvMSP44vA5jMLiEvcejIfbIyIQA+jxN/djCDzmQXWMUm0Hr3OBjKTTUBLorGTHcTk
 FHCTOLeNFaJVU6J1+292CFteYvvbOcwQ5ytJTJh3nw3CrpVYe+wM2MMSAvc4JVY2PIRKuEg0
 zvnKBGELS7w6voUdwpaR+L9zPlS8WuLpjd/MEM0tjBL9O9eD3SMhYC3RdyYHosZRYsHr54wQ
 YT6JG28FIe7hk5i0bTrzBEbVWUghMQvJx7OQvDALyQsLGFlWMYqnlhbnpqcWG+allusVJ+YW
 l+al6yXn525iBKbA0/+Of9rBOPfVR71DjEwcjIcYJTiYlUR4E6LvJwnxpiRWVqUW5ccXleak
 Fh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpg0vKb8lt8Sf1t8aPbq/M3XDjVf8FA
 LCHzd76nTbZW8wXRn76z61/Eaz96LDKj/eRCa419L4vFnesibj5q6nwXuFXBzKvCKOBAMZdV
 S+Dr3MKSq8GhDnlHb/FaJh2a0up9Y+Mtiasbz/ELtR08n9r/UHSukU2jJ1fHRLl/T65Vlkh9
 P7jvs3FC7dF3WR8kKoSnvKi7KP/eKz91ov2i92d/rpOcHs3xbrqrWtXnbx2NKgUtebPeXaxd
 HdCxO+Gh3LzTPA1ncu4ZeG3Zrz+1amqV1a/tDg7nuczk7u1Vfy/IE7tlTS+j/jb1Kd8jvrY9
 YfESL3UW3u0cwaBy9YvG1LPMhn12Ls18FxYKZWyo3BCnxFKckWioxVxUnAgASqZ/z/ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t/xe7qSDY+SDNrXG1isvtvPZjHtw09m
 i99nzzNb7H03m9Viz6JJTBYrVx9lsniyfhazxd+ue0wWe29pW1zeNYfNYv6yp+wWE9q+Mlvc
 mPCU0WLNzacsFiduSTvwe1y+4u2xc9Zddo/LZ0s9Nq3qZPPYvKTeY/fNBjaPna33WT3e77sK
 FDpd7fF5k5xH+4FupgDuKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTub
 lNSczLLUIn27BL2Mk1dWMRfMUqh4ffILUwPjG8kuRk4OCQETiX1X57J1MXJxCAksZZR41fmG
 ESIhI/Hpykd2CFtY4s+1Lqiij4wSH++eYoZwdjNK3Dn0igmkilfATmL3vu9ACQ4OFgFViVVv
 4yDCghInZz5hAbFFBSIlHi5rAisXFoiX+HF8ERuIzSwgLnHryXywuIhAD6PE392MIPOZBdYx
 SbQevQ5WJCTwm1Hixl8bkPlsAloSjZ3sICangJvEuW2sEGM0JVq3/2aHsOUltr+dwwxxv5LE
 hHn32SDsWolX93czTmAUnYXkullIrpiFZNQsJKMWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vO
 z93ECEwd24793LyDcd6rj3qHGJk4GA8xSnAwK4nwJkTfTxLiTUmsrEotyo8vKs1JLT7EaAoM
 oYnMUqLJ+cDklVcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwGTj
 Vr3nVcDmZ3FPMstymM4kzrpaJtmwSWXxypzSOobkY0L/lt1Z/+3ejMOPnF5wGOXdu7g3aMmX
 l/k5LDl3AtU9NKabhXySuDHfQrxFuHz3/T9O/Af7Iha1rsg8sYtdzVV499t7+0+5ZygHi+8o
 mN+/9VvsvG/tkdyFB3d9uyfQeb1YgDXFxvHF2lu5fSG2le8s+SP61TdoiDw6VWUzq/bXCqXn
 TLs40g5leaxp9/p5I4Uz2nRC0M6pphuMtbXyvZin691mDK29elLU+/zmqNSrBU2K5lwtm68I
 XGeXqUja2y+ru+T106YvbGu+eLRUcgcLPjJq8XjxUu7usqX657JCD7MH7nqernNa/fDsaUos
 xRmJhlrMRcWJAHz0XuCmAwAA
X-CMS-MailID: 20220728122457eucas1p29f23e1181e0083319bf787dcbd10d36d
X-Msg-Generator: CA
X-RootMTR: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
 <e9663c20-65d5-48f5-3fe1-e3a8f5ab3214@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
 linux-block@vger.kernel.org, dm-devel@redhat.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
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

On 2022-07-28 05:07, Damien Le Moal wrote:
> On 7/28/22 01:22, Pankaj Raghav wrote:
>> Checking if a given sector is aligned to a zone is a common
>> operation that is performed for zoned devices. Add
>> bdev_is_zone_start helper to check for this instead of opencoding it
> 
> The patch actually introduces bdev_is_zone_aligned(). I agree with Bart
> that bdev_is_zone_start() is a better name.
I have posted my rationale behind this change in my reply to Bart. Let
me know what you think.
>

<snip>
>>  		args->zone_sectors = zone->len;
>> -		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
>> +		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
> 
> 		args->nr_zones = disk_zone_no(disk, capacity);
> 
We are doing a round up with a division here mainly to take into account
the last unequal zone if present. disk_zone_no does just a division so
it won't account for the unequal last zone.

>>  	} else if (zone->start + args->zone_sectors < capacity) {
>>  		if (zone->len != args->zone_sectors) {
>>  			pr_warn("%s: Invalid zoned device with non constant zone size\n",
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 85b832908f28..1be805223026 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -634,6 +634,11 @@ static inline bool queue_is_mq(struct request_queue *q)
>>  	return q->mq_ops;
>>  }
>>  
>> +static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>> +{
>> +	return bdev->bd_queue;	/* this is never NULL */
>> +}
>> +
>>  #ifdef CONFIG_PM
>>  static inline enum rpm_status queue_rpm_status(struct request_queue *q)
>>  {
>> @@ -665,6 +670,25 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>>  	}
>>  }
>>  
>> +static inline bool bdev_is_zoned(struct block_device *bdev)
>> +{
>> +	struct request_queue *q = bdev_get_queue(bdev);
>> +
>> +	if (q)
>> +		return blk_queue_is_zoned(q);
>> +
>> +	return false;
>> +}
>> +
>> +static inline sector_t bdev_zone_sectors(struct block_device *bdev)
>> +{
>> +	struct request_queue *q = bdev_get_queue(bdev);
>> +
>> +	if (!blk_queue_is_zoned(q))
>> +		return 0;
>> +	return q->limits.chunk_sectors;
>> +}
>> +
>>  #ifdef CONFIG_BLK_DEV_ZONED
>>  static inline unsigned int disk_nr_zones(struct gendisk *disk)
>>  {
>> @@ -684,6 +708,30 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>>  	return div64_u64(sector, zone_sectors);
>>  }
>>  
>> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
>> +						   sector_t sec)
>> +{
>> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
>> +	u64 remainder = 0;
>> +
>> +	if (!bdev_is_zoned(bdev))
>> +		return 0;
>> +
>> +	if (is_power_of_2(zone_sectors))
>> +		return sec & (zone_sectors - 1);
>> +
>> +	div64_u64_rem(sec, zone_sectors, &remainder);
>> +	return remainder;
>> +}
>> +
>> +static inline bool bdev_is_zone_aligned(struct block_device *bdev, sector_t sec)
>> +{
>> +	if (!bdev_is_zoned(bdev))
>> +		return false;
> 
> This is checked in bdev_offset_from_zone_start(). No need to add it again
> here.
> 
bdev_offset_from_zone_start returns 0 if the device is not zoned, and
the below check will then return `true`. That is why I explicitly return
a false if the device is not zoned.
>> +
>> +	return bdev_offset_from_zone_start(bdev, sec) == 0;
>> +}
>> +
>>  static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>>  {
>>  	if (!blk_queue_is_zoned(disk->queue))
>> @@ -728,6 +776,18 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>>  {
>>  	return 0;
>>  }
>> +
>> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
>> +						   sector_t sec)
>> +{
>> +	return 0;
>> +}
> 
> This one is not used when CONFIG_BLK_DEV_ZONED is not set. No need to
> define it.
> 
Ok. I will remove it if it is not required.
>> +
>> +static inline bool bdev_is_zone_aligned(struct block_device *bdev, sector_t sec)
>> +{

> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

