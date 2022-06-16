Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA10AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 23:34:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-7mE6KNpjPMacAfMVvrNc_Q-1; Thu, 16 Jun 2022 19:34:18 -0400
X-MC-Unique: 7mE6KNpjPMacAfMVvrNc_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11A158339A0;
	Thu, 16 Jun 2022 23:34:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00A82492CA5;
	Thu, 16 Jun 2022 23:34:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B0222194705F;
	Thu, 16 Jun 2022 23:34:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07568194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 23:34:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBA52C2811B; Thu, 16 Jun 2022 23:34:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E75C1C28115
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:34:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5D6785A580
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:34:15 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-sXVVYqjjMVK5NN0GaL9g5Q-1; Thu, 16 Jun 2022 19:34:01 -0400
X-MC-Unique: sXVVYqjjMVK5NN0GaL9g5Q-1
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; d="scan'208";a="203374381"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2022 07:33:57 +0800
IronPort-SDR: 9MhGrcAMSSE5WZmmGqUIR22rFG9JZzWqN9B6S9GX+oyKuwTWf09uSYFNbegkm3sUWnNTOgdrLg
 FiaVfvD8LyH9D+fxBlbAWzhbnOmMKDgwGIZLF6ZSB4jHIFONlM4D9ifOnhRY7waYHCZvZxP0eo
 srZjCssOyqJB+6T/me6auDIUnMEjB1UIQbsnhu2uuJDWATLrEMK5R/DK0J7xsDyLC68hLOhHjU
 zeArqjn90b3Zk8PpapfgSV858nliOhFShwTdtnNGqxJVviuK/DzBrYO4AxLWgchgnndwYlE8CN
 emhD189aYYpLYprTcX5yet1P
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 15:52:10 -0700
IronPort-SDR: mKNA48yO2i1WOAVnuXVJd+WHvoZKXg7DH01YSwVqUbHiaWgnAT8K2S/Y81mZsNJFeMEt1R+VVG
 7olCCrn8QgQRJfhujmNTUhMMq8wjr/LzfkV6CtrBVtXvUFodg7pYPtv3v9ygT0zVS2O4HVTK8y
 707H71feWNIeLXBCexmaHS135yafcaN6am0PcBVpJzrtbITZ6Ecrf55MMZlbdGksNrkkUyPPqj
 Bir6mifJILZgq2Phw/avCgyACq91IAKPHv2rt+gLK68JSmxGyOTEajgPuPvxmChB5s06nJLE7P
 CcI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 16:33:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LPJQs5X9mz1SHwl
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 16:33:57 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Cw8yqZnQlZB7 for <dm-devel@redhat.com>;
 Thu, 16 Jun 2022 16:33:56 -0700 (PDT)
Received: from [10.225.163.84] (unknown [10.225.163.84])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LPJQp1Ntqz1Rvlc;
 Thu, 16 Jun 2022 16:33:54 -0700 (PDT)
Message-ID: <8883fed1-cc5a-889d-6668-cb8039fbf09a@opensource.wdc.com>
Date: Fri, 17 Jun 2022 08:33:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b@eucas1p1.samsung.com>
 <20220615101920.329421-13-p.raghav@samsung.com>
 <f7b586a3-5370-f3b9-72dc-f9bea0b63f1f@opensource.wdc.com>
 <8d8501e8-9e39-8b02-d248-48f778a95d96@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <8d8501e8-9e39-8b02-d248-48f778a95d96@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 12/13] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
 jiangbo.365@bytedance.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
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

On 6/16/22 21:24, Pankaj Raghav wrote:
> On 2022-06-15 13:01, Damien Le Moal wrote:
>> On 6/15/22 19:19, Pankaj Raghav wrote:
>>> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
>>> uses either native append or append emulation and it is called before the
>>> endio of the target. But target endio can still update the clone bio
>>> after dm_zone_endio is called, thereby, the orig bio does not contain
>>> the updated information anymore. Call dm_zone_endio for zoned devices
>>> after calling the target's endio function
>>>
>>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>>> ---
>>> @Damien and @Hannes: I couldn't come up with a testcase that uses endio callback and
>>> zone append or append emulation for zoned devices to test for
>>> regression in this change. It would be great if you can suggest
>>> something. This change is required for the npo2 target as we update the
>>> clone bio sector in the endio callback function and the orig bio should
>>> be updated only after the endio callback for zone appends.
>>
>> Running zonefs tests on top of dm-crypt will exercise DM zone append
>> emulation.
>>
> Thanks. However, I am facing issues creating a dm-crypt target with a
> zoned device. Steps:
> - cryptsetup luksFormat <zns-device>

luks format is not supported because cryptsetup does not write the
metadata sequentially. I am working on fixing that. Use the plain format.

> 
> is throwing a bunch of IO errors with the following error message:
> Device wipe error, offset 32768.
> Cannot wipe header on device <zns-device>.
> 
> I can observe the same behavior in both v5.18 and next-20220615 with
> cryptsetup 2.4.3.The same step is working correctly on a normal NVMe device.
> Am I doing something wrong?
> ZNS info: zsze 128M and zcap 128M with 50 zones
>>>
>>>  drivers/md/dm.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>> index 3f17fe1de..3a74e1038 100644
>>> --- a/drivers/md/dm.c
>>> +++ b/drivers/md/dm.c
>>> @@ -1025,10 +1025,6 @@ static void clone_endio(struct bio *bio)
>>>  			disable_write_zeroes(md);
>>>  	}
>>>  
>>> -	if (static_branch_unlikely(&zoned_enabled) &&
>>> -	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
>>> -		dm_zone_endio(io, bio);
>>> -
>>>  	if (endio) {
>>>  		int r = endio(ti, bio, &error);
>>>  		switch (r) {
>>> @@ -1057,6 +1053,10 @@ static void clone_endio(struct bio *bio)
>>>  		}
>>>  	}
>>>  
>>> +	if (static_branch_unlikely(&zoned_enabled) &&
>>> +	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
>>
>> blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))) ->
>> bdev_is_zoned(bio->bi_bdev)
>>
> Ok. Even though I just moved the statements, I think this is trivial
> enough to take it along.
>>> +		dm_zone_endio(io, bio);
>>> +
>>>  	if (static_branch_unlikely(&swap_bios_enabled) &&
>>>  	    unlikely(swap_bios_limit(ti, bio)))
>>>  		up(&md->swap_bios_semaphore);
>>
>>


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

