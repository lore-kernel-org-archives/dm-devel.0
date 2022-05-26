Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0260C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 26 May 2022 08:25:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-kcim04u8NAq4jCV6xRXzxQ-1; Thu, 26 May 2022 04:25:32 -0400
X-MC-Unique: kcim04u8NAq4jCV6xRXzxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A09638349B2;
	Thu, 26 May 2022 08:25:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7880B8287E;
	Thu, 26 May 2022 08:25:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DCDF194EB91;
	Thu, 26 May 2022 08:25:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A1D8A19466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 May 2022 08:25:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 922E9C15E71; Thu, 26 May 2022 08:25:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D416C159B3
 for <dm-devel@redhat.com>; Thu, 26 May 2022 08:25:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7616D801E6B
 for <dm-devel@redhat.com>; Thu, 26 May 2022 08:25:28 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-cAlPgR-tMPeAEOC_03AsKw-1; Thu, 26 May 2022 04:25:25 -0400
X-MC-Unique: cAlPgR-tMPeAEOC_03AsKw-1
X-IronPort-AV: E=Sophos;i="5.91,252,1647273600"; d="scan'208";a="202322012"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2022 16:25:25 +0800
IronPort-SDR: 9RBC1RBJNNqJDuHotH+bX8Cjyj35a87rBM0ZSpUVUtbcTNwNeDQC/tMOYgD2vZypw21DW4UHWw
 pmNNndmAmn2HgPDf+oBQxlD6O0VIlM6L1bptbH0kcAWktlWv47ZGkTacf010GuMYTqrG6620Au
 bvQ60I09f6e+YBRo04t01MXMa7yb4lNgly7bJpncDlSlOxO69K3axN52g2kQ/QvVyQqi60U7Pp
 qSYJ7tvT1yhEZ/Yx3nsBClQLhpG6vIo6WRL/+IPPDqPkWpgMwQBW4jcdAJH/0lrNQyoG5sUD/C
 b5UBRZZvxNMEpJgAECtNcVBu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 May 2022 00:49:18 -0700
IronPort-SDR: bQaP9MHe8KmGdnZkAmHa3TdRbVM+MqvO+QW18c+F9h0shEZ055Ly9mARvz35Tc+lgEM9FGPEdM
 YlOjzbs9wJg/r7tPlmocXtcAA+mKVEhFwXitGflSkNr/KEdx5keekvPe6l0JLiIE7MAKvaIKlD
 AmXGO9fZbIR8RcpGKxcgCV0+hAL4PzfRf4xoQL6GMiv7ZS4lrzNwGS1ozOAWlaTIxxpo9xhuQg
 fdK6NR+PxPggxgK/FUGhs4nTMrPhYqNr9zdTxAogG1PsQ7KJuYvtZEczqzUP2iEV8pmolrJN51
 I5U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 May 2022 01:25:24 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L81GC5NWtz1SHwl
 for <dm-devel@redhat.com>; Thu, 26 May 2022 01:25:23 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id ZR4mi-jZC4b3 for <dm-devel@redhat.com>;
 Thu, 26 May 2022 01:25:21 -0700 (PDT)
Received: from [10.225.54.48] (unknown [10.225.54.48])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L81G76Gmcz1Rvlc;
 Thu, 26 May 2022 01:25:19 -0700 (PDT)
Message-ID: <3c04e29f-2c99-c350-bc87-0c0633b4d19d@opensource.wdc.com>
Date: Thu, 26 May 2022 17:25:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 snitzer@redhat.com, Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789@eucas1p2.samsung.com>
 <20220525154957.393656-9-p.raghav@samsung.com>
 <9703ca4c-33cf-cb3a-b46b-6b0e5537cfd6@opensource.wdc.com>
 <0bb57f61-9a33-0273-4b89-2cdf042e56dd@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <0bb57f61-9a33-0273-4b89-2cdf042e56dd@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 8/8] dm: ensure only power of 2 zone sizes
 are allowed
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
Cc: gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/05/26 17:12, Pankaj Raghav wrote:
> Hi Damien,
> On 5/26/22 01:13, Damien Le Moal wrote:
>> On 5/26/22 00:49, Pankaj Raghav wrote:
>>> Ensure that only power of 2 zoned devices are enabled for dm targets that
>>> supports zoned devices. This constraint can be relaxed once non power of
>>> 2 zone size support is added to the DM layer.
>>>
>>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>>> ---
>>>  drivers/md/dm-table.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>> index 03541cfc2317..2a8af70d1d4a 100644
>>> --- a/drivers/md/dm-table.c
>>> +++ b/drivers/md/dm-table.c
>>> @@ -251,6 +251,12 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>>  	if (bdev_is_zoned(bdev)) {
>>>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>>>  
>>> +		if (!is_power_of_2(zone_sectors)) {
>>> +			DMWARN("%s: %pg only power of two zone size supported",
>>> +			       dm_device_name(ti->table->md), bdev);
>>> +			return 1;
>>> +		}
>>> +
>>>  		if (start & (zone_sectors - 1)) {
>>>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>>>  			       dm_device_name(ti->table->md),
>>
>> I thought the agreed upon idea is be to add a dm-linear like target to
>> emulate power of 2 zone size so that we can keep btrfs and f2fs running on
>> this new class of device. So why this patch ?
>>
>> The entire series as is will fragment zoned block device support, which is
>> not a good thing at all. Without the new dm target, none of the current
>> kernel supported zone stuff will work.
>>
> I have mentioned this in my cover letter:
> The support is planned to be added in two phases:
> - Add npo2 support to block, nvme layer and necessary stop gap patches
>   in the filesystems
> - Add dm target for npo2 devices so that they are presented as a po2
>   device to filesystems
> 
> This series is targeting the first phase where we have stop gap patches
> and add support to the block and nvme layer and in the next phase we
> will add a dm linear like target for npo2 zone sizes which can be used
> by all the filesystems. This patch makes sure that we can't use npo2
> zoned devices without the proper support that will be added in the next
> phase in the DM.

Personally, I do not want to see a kernel version where zone support is broken
for some devices. So I definitely prefer everything in one go or nothing.

> 
> Even though we decided we would like to take the direction of DM, I am
> still awaiting reply from Christoph who raised concerns about npo2 zoned
> device support and Mike Snitzer about this approach. That is one of the
> reason I split this effort into two phases.
>> The zonefs patch is also gone from the series. Why ? As is, zonefs will
>> break if it is passed a non power of 2 zone size drive.
>>
> I think this was my mistake. If you agree with the above approach, then
> I can add a stop gap patch also to zonefs npo2 zoned devices. This way
> all the zone filesystem support goes via DM for npo2 zoned devices. I am
> proposing this so that initially we always have only one way of
> accessing a npo2 zoned device (via DM) from **filesystems** until we add
> native support.
-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

