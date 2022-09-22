Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26C3C54EE9
	for <dm-devel@archiver.kernel.org>; Thu, 22 Sep 2022 21:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663883476;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q9RbamdDZV9W3YYGReitUUzlz164x/kz8FsFKe0MdEM=;
	b=Mp0xKcGkuO9kziJOPsA/mDNX9FIvWT3Jp2X6N9GzU4dZdlzu2dLRNOA7PgzJbQHbfBiD34
	gJocmGJg4EaxF4oq2ZMpzt2ocXFR8mVgr0rJwNLZ5PwplVIFfOWBJDKMToL3jQ80Dxj0Cp
	le41C5WXaG5N49olzSRIBtavMkQakro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-qmaGHBFkMwmBtZ6wfC60yQ-1; Thu, 22 Sep 2022 17:51:13 -0400
X-MC-Unique: qmaGHBFkMwmBtZ6wfC60yQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83F5A80CDAD;
	Thu, 22 Sep 2022 21:51:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 48BE140C2064;
	Thu, 22 Sep 2022 21:51:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15DC819465B6;
	Thu, 22 Sep 2022 21:51:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DC8419465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Sep 2022 21:51:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4183440C206B; Thu, 22 Sep 2022 21:51:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3993140C2064
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 21:51:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 193AC80D091
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 21:51:08 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-txFNvAvnNmW2hbAnIHueZQ-2; Thu, 22 Sep 2022 17:51:06 -0400
X-MC-Unique: txFNvAvnNmW2hbAnIHueZQ-2
X-IronPort-AV: E=Sophos;i="5.93,337,1654531200"; d="scan'208";a="212063042"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 23 Sep 2022 05:49:59 +0800
IronPort-SDR: sTHguJoHzF3geAEKYO1mlBk+UhVurBJNFDUCOQI528v8XSMXrhyGgM7OmS6CZWVNQFZ2iDTeIK
 we++u+BPECpYI4HGBhhlak+MHD71ZhVnUR8DKPR1iB1g1QurgQKcL7sRK7Q1dY6EHAaE9hoqlc
 kYWSMlPcdOMqaYMSxqfd2R+tqocLHVdIvdaYBaDwMJN6rGFaVIuZHMes6I14pAL8Vjen04c4EI
 aHZPy1go7krjL4LDBTUeLUUE/Ve3b5KeRXHEW3f5p09dfF2fEvqAfyl+Q0Y1ArOjH2+uMfpgFn
 rZ5B50OaCYoGCdGcxyhE4fh8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 22 Sep 2022 14:04:33 -0700
IronPort-SDR: Zu3gcBeXBIbgqzvqAia7HpCoOlIElDgX/TtKrL0Lr8zmo9o8nNJ7Gy8RnLKCLsMbw7oi/mSbJa
 00Gx45rA9G7uuCn0fDm7EnOsTK9RY6E2loVKJuOSJdiHlrt9gHkvs5apy1OnE+29/t/mEnw+C6
 NZSfHolxDNNY6L7f07gOZ6YK/NXemwnKzWuc29KmRwrFVX1+jBZriNO97crlq3US8mqWKl+LOh
 wL9jhhRwz97rSpCWc9Wto4BCO1UcXZi8wspAW0YsNHT3JVbMRY05POGxD+INOg+rVK0MqiXUpT
 eN4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 22 Sep 2022 14:50:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MYTTh5KlFz1Rwtm
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 14:50:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 227c58vWlt39 for <dm-devel@redhat.com>;
 Thu, 22 Sep 2022 14:49:58 -0700 (PDT)
Received: from [10.225.163.81] (unknown [10.225.163.81])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MYTTX6yjsz1RvLy;
 Thu, 22 Sep 2022 14:49:52 -0700 (PDT)
Message-ID: <860fb643-8a1a-225e-13e7-e68a4b6f3842@opensource.wdc.com>
Date: Fri, 23 Sep 2022 06:49:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
To: Mike Snitzer <snitzer@redhat.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com> <YytJhEywBhqcr7MX@redhat.com>
 <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
 <Yyy5XUUWGkU8B3IP@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yyy5XUUWGkU8B3IP@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] Please further explain Linux's "zoned storage"
 roadmap [was: Re: [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/23/22 04:37, Mike Snitzer wrote:
> On Wed, Sep 21 2022 at  7:55P -0400,
> Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:
> 
>> On 9/22/22 02:27, Mike Snitzer wrote:
>>> On Tue, Sep 20 2022 at  5:11P -0400,
>>> Pankaj Raghav <p.raghav@samsung.com> wrote:
>>>
>>>> - Background and Motivation:
>>>>
>>>> The zone storage implementation in Linux, introduced since v4.10, first
>>>> targetted SMR drives which have a power of 2 (po2) zone size alignment
>>>> requirement. The po2 zone size was further imposed implicitly by the
>>>> block layer's blk_queue_chunk_sectors(), used to prevent IO merging
>>>> across chunks beyond the specified size, since v3.16 through commit
>>>> 762380ad9322 ("block: add notion of a chunk size for request merging").
>>>> But this same general block layer po2 requirement for blk_queue_chunk_sectors()
>>>> was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
>>>> to be non-power-of-2").
>>>>
>>>> NAND, which is the media used in newer zoned storage devices, does not
>>>> naturally align to po2. In these devices, zone capacity(cap) is not the
>>>> same as the po2 zone size. When the zone cap != zone size, then unmapped
>>>> LBAs are introduced to cover the space between the zone cap and zone size.
>>>> po2 requirement does not make sense for these type of zone storage devices.
>>>> This patch series aims to remove these unmapped LBAs for zoned devices when
>>>> zone cap is npo2. This is done by relaxing the po2 zone size constraint
>>>> in the kernel and allowing zoned device with npo2 zone sizes if zone cap
>>>> == zone size.
>>>>
>>>> Removing the po2 requirement from zone storage should be possible
>>>> now provided that no userspace regression and no performance regressions are
>>>> introduced. Stop-gap patches have been already merged into f2fs-tools to
>>>> proactively not allow npo2 zone sizes until proper support is added [1].
>>>>
>>>> There were two efforts previously to add support to npo2 devices: 1) via
>>>> device level emulation [2] but that was rejected with a final conclusion
>>>> to add support for non po2 zoned device in the complete stack[3] 2)
>>>> adding support to the complete stack by removing the constraint in the
>>>> block layer and NVMe layer with support to btrfs, zonefs, etc which was
>>>> rejected with a conclusion to add a dm target for FS support [0]
>>>> to reduce the regression impact.
>>>>
>>>> This series adds support to npo2 zoned devices in the block and nvme
>>>> layer and a new **dm target** is added: dm-po2zoned-target. This new
>>>> target will be initially used for filesystems such as btrfs and
>>>> f2fs until native npo2 zone support is added.
>>>
>>> As this patchset nears the point of being "ready for merge" and DM's
>>> "zoned" oriented targets are multiplying, I need to understand: where
>>> are we collectively going?  How long are we expecting to support the
>>> "stop-gap zoned storage" layers we've constructed?
>>>
>>> I know https://zonedstorage.io/docs/introduction exists... but it
>>> _seems_ stale given the emergence of ZNS and new permutations of zoned
>>> hardware. Maybe that isn't quite fair (it does cover A LOT!) but I'm
>>> still left wanting (e.g. "bring it all home for me!")...
>>>
>>> Damien, as the most "zoned storage" oriented engineer I know, can you
>>> please kick things off by shedding light on where Linux is now, and
>>> where it's going, for "zoned storage"?
>>
>> Let me first start with what we have seen so far with deployments in the
>> field.
> 
> <snip>
> 
> Thanks for all your insights on zoned storage, very appreciated!
> 
>>> In addition, it was my understanding that WDC had yet another zoned DM
>>> target called "dm-zap" that is for ZNS based devices... It's all a bit
>>> messy in my head (that's on me for not keeping up, but I think we need
>>> a recap!)
>>
>> Since the ZNS specification does not define conventional zones, dm-zoned
>> cannot be used as a standalone DM target (read: single block device) with
>> NVMe zoned block devices. Furthermore, due to its block mapping scheme,
>> dm-zoned does not support devices with zones that have a capacity lower
>> than the zone size. So ZNS is really a big *no* for dm-zoned. dm-zap is a
>> prototype and in a nutshell is the equivalent of dm-zoned for ZNS. dm-zap
>> can deal with the smaller zone capacity and does not require conventional
>> zones. We are not trying to push for dm-zap to be merged for now as we are
>> still evaluating its potential use cases. We also have a different but
>> functionally equivalent approach implemented as a block device driver that
>> we are evaluating internally.
>>
>> Given the above mentioned usage pattern we have seen so far for zoned
>> storage, it is not yet clear if something like dm-zap for ZNS is needed
>> beside some niche use cases.
> 
> OK, good to know.  I do think dm-zoned should be trained to _not_
> allow use with ZNS NVMe devices (maybe that is in place and I just
> missed it?).  Because there is some confusion with at least one
> customer that is asserting dm-zoned is somehow enabling them to use
> ZNS NVMe devices!

dm-zoned checks for conventional zones and also that all zones have a zone
capacity that is equal to the zone size. The first point puts ZNS out but
a second regular drive can be used to emulate conventional zones. However,
the second point (zone cap < zone size) is pretty much a given with ZNS
and so rules it out.

If anything, we should also add a check on the max number of active zones,
which is also a limitation that ZNS drives have, unlike SMR drives. Since
dm-zoned does not handle active zones at all, any drive with a limit
should be excluded. I will send patches for that.
> 
> Maybe they somehow don't _need_ conventional zones (writes are handled
> by some other layer? and dm-zoned access is confined to read only)!?
> And might they also be using ZNS NVMe devices to do _not_ have a
> zone capacity lower than the zone size?

It is a possibility. Indeed, if the ZNS drive has:
1) zone capacity equal to zone size
2) a second regular drive is used to emulate conventional zones
3) no limit on the max number of active zones

Then dm-zoned will work just fine. But again, I seriously doubt that point
(3) holds. And we should check that upfront in dm-zoned ctr.

> Or maybe they are mistaken and we should ask more specific questions
> of them?

Getting the exact drive characteristics (zone size, capacity and zone
resource limits) will tell you if dm-zoned can work or not.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

