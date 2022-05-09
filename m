Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB64C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 11:32:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-bVSaQVKCOVSbmhrhxEKa-Q-1; Mon, 09 May 2022 07:32:27 -0400
X-MC-Unique: bVSaQVKCOVSbmhrhxEKa-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F07D729AB3F3;
	Mon,  9 May 2022 11:32:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FDCF2166B49;
	Mon,  9 May 2022 11:32:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 768F21947054;
	Mon,  9 May 2022 11:32:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F0B261947054
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 11:32:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC9C12167D64; Mon,  9 May 2022 11:32:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D60D62166B4E
 for <dm-devel@redhat.com>; Mon,  9 May 2022 11:32:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87FB4811E80
 for <dm-devel@redhat.com>; Mon,  9 May 2022 11:32:12 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-tH8PntoAPxq6UsLd2lg0tA-1; Mon, 09 May 2022 07:32:09 -0400
X-MC-Unique: tH8PntoAPxq6UsLd2lg0tA-1
X-IronPort-AV: E=Sophos;i="5.91,211,1647273600"; d="scan'208";a="200733499"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 09 May 2022 19:32:08 +0800
IronPort-SDR: To72NAfVFnnS8wc4Lw9JEPMtsXviKNDvQE398wu3rHB9sw4+69EFVogZWgLoZ6/I2W5jVpvaO5
 qx77PGYrsWHrVL53kJuShKNFhjf4QQbLESuZalklzvkKln9jUdQ0unIjjYbSU/6+18oJp+M+Xv
 4cPkFUfaYUmM57OQXhjbGSFh7Ut3HkNV0i8oMGiL1DKyRzgMEhWlY+A3N15QLd30HZ5uiRxES6
 IUVcp4NA9yIVfgZu4UynenyFDtG6k6v2wHJNESI/NeY7tBr6N21izyK73myOAtPVNLFuFVeaeW
 aYoXHz8TjqOul2E57XpZsJVn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 09 May 2022 04:02:12 -0700
IronPort-SDR: 0i8RCepjf/YbMe95+lDLBlh6+mLq1GP+2iCGLhn2FaDRl6rh6DU+1XMBGJfRD43KmvXvxz65Hg
 eWCrGBIhbo8mrhQHe5J4f0RviZdWRKqUmgxFDM825hh3DCUnB/3TkIRh8xie4UabysBo+hHnLJ
 tj4rwivRqLlAAUuxcTCbUeJjB9/WBpzLOh4kziObxMg2IjJai9w+/JYj/4+Y16DwvOLTp0Ofgk
 2mhU7rkjvi8YNSj8q6uGDC/YMpsvPXH44ESxTOzn+4E90i42U5nxPwqXvTjc5eHH+T+SoWor2S
 xeI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 09 May 2022 04:32:07 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KxfCT6yS2z1Rwrw
 for <dm-devel@redhat.com>; Mon,  9 May 2022 04:32:05 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id xDH_4frK9Tdt for <dm-devel@redhat.com>;
 Mon,  9 May 2022 04:32:04 -0700 (PDT)
Received: from [192.168.10.49] (unknown [10.225.164.111])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KxfCM384lz1Rvlc;
 Mon,  9 May 2022 04:31:59 -0700 (PDT)
Message-ID: <9eb00b42-ca5b-c94e-319d-a0e102b99f02@opensource.wdc.com>
Date: Mon, 9 May 2022 20:31:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org, hare@suse.de,
 dsterba@suse.com, axboe@kernel.dk, hch@lst.de, snitzer@kernel.org
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081116eucas1p2cce67bbf30f4c9c4e6854965be41b098@eucas1p2.samsung.com>
 <20220506081105.29134-11-p.raghav@samsung.com>
 <39a80347-af70-8af0-024a-52f92e27a14a@opensource.wdc.com>
 <aef68bcf-4924-8004-3320-325e05ca9b20@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <aef68bcf-4924-8004-3320-325e05ca9b20@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 10/11] null_blk: allow non power of 2
 zoned devices
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
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org,
 Luis Chamberlain <mcgrof@kernel.org>, gost.dev@samsung.com,
 Josef Bacik <josef@toxicpanda.com>, linux-nvme@lists.infradead.org,
 jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, linux-btrfs@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, jonathan.derrick@linux.dev,
 linux-fsdevel@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Johannes Thumshirn <jth@kernel.org>, Keith Busch <kbusch@kernel.org>,
 matias.bjorling@wdc.com, Sagi Grimberg <sagi@grimberg.me>
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

On 2022/05/09 20:06, Pankaj Raghav wrote:
> 
>>> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
>>> index 5cb4c92cd..ed9a58201 100644
>>> --- a/drivers/block/null_blk/main.c
>>> +++ b/drivers/block/null_blk/main.c
>>> @@ -1929,9 +1929,8 @@ static int null_validate_conf(struct nullb_device *dev)
>>>  	if (dev->queue_mode == NULL_Q_BIO)
>>>  		dev->mbps = 0;
>>>  
>>> -	if (dev->zoned &&
>>> -	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
>>> -		pr_err("zone_size must be power-of-two\n");
>>> +	if (dev->zoned && !dev->zone_size) {
>>> +		pr_err("zone_size must not be zero\n");
>>
>> May be a simpler phrasing would be better:
>>
>> pr_err("Invalid zero zone size\n");
>>
> Ack. I will change this in the next rev.
>>>  		return -EINVAL;
>>>  	}
>>>  
>>> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
>>> index dae54dd1a..00c34e65e 100644
>>> --- a/drivers/block/null_blk/zoned.c
>>> +++ b/drivers/block/null_blk/zoned.c
>>> @@ -13,7 +13,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
>>>  
>>>  static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
>>>  {
>>> -	return sect >> ilog2(dev->zone_size_sects);
>>> +	if (is_power_of_2(dev->zone_size_sects))
>>> +		return sect >> ilog2(dev->zone_size_sects);
>>
>> As a separate patch, I think we should really have ilog2(dev->zone_size_sects)
>> as a dev field to avoid doing this ilog2 for every call..
>>
> I don't think that is possible because `zone_size_sects` can also be non
> po2.

But when it is we can optimize that. All we need is add a "zone_size_sect_shift"
field that is initialized when zone_size_sects is set when the device is
created. Then, you can have code like:

	if (dev->zone_size_sect_shift))
		return sect >> dev->zone_size_sect_shift;

Which avoids both is_power_of_2() and ilog2() calls for every IO.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

