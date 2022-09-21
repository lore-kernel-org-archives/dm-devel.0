Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF245C32771
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 23:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663804636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nFjfcK+iHeA+x9+FaIqONBngmNV+aUFiF04AllezNc4=;
	b=ZyX4qj34LtWcLNfVAn16RqJtnJ7yWLl5R+LcWbJcq9BtcqiCzM5L8BMufIIZJB6OOu7CY/
	JfpNAjNFezsC809g4cJ/3T01WIh6OhGtQd44LHZGmz/fqtli4c2uANIfqB3bwnQ6J+cYLy
	jWQ3fIP6W8u8Va+azXG3FRJv85sjV2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-eKnbPdMwNaKJGnKRRvxBfA-1; Wed, 21 Sep 2022 19:57:13 -0400
X-MC-Unique: eKnbPdMwNaKJGnKRRvxBfA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D9A80029D;
	Wed, 21 Sep 2022 23:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23E8BC15BA4;
	Wed, 21 Sep 2022 23:57:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88EC719465B1;
	Wed, 21 Sep 2022 23:57:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B584219465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 23:57:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0584535429; Wed, 21 Sep 2022 23:57:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F18AA17582
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 23:57:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E02880029D
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 23:57:04 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-6qYhgoATPMWrpFGUJItqnQ-2; Wed, 21 Sep 2022 19:57:03 -0400
X-MC-Unique: 6qYhgoATPMWrpFGUJItqnQ-2
X-IronPort-AV: E=Sophos;i="5.93,334,1654531200"; d="scan'208";a="316243759"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 22 Sep 2022 07:55:58 +0800
IronPort-SDR: wHi7AGUQKDDv2h+hNBwIQKSbZ5QFWr7jbJ4rBmo97WFmqPcQnglzxdoJFvFg53hCOdEvasct3p
 JgZb2bFwaAsNe2iu6CUZWaQ7nVrjapXvdOHvK53ZMg9RA5XnfDWS2azltjijxDyn059jFCCy+6
 j5bqlWkkRKzj4W0xsVOPqv01F8xXZGbVxqWZVS9eKFxl8KtUJ4lK7d2Uy7DUCyK4WKNfNJbHqX
 +BwGCWglPaQLxjR/lMcLmQPUvruhcohIHnd5eWG0vgM2AJ6mKheepIAud+CKvITJYy2MTjlq0B
 hd5vbho9Jlx8NlDjn+QIxqV4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 21 Sep 2022 16:16:02 -0700
IronPort-SDR: Jp8/bUFYBjwVpGDTEyvsuzHWqj91vFIPNkNmaNJGuit9w7IBqPmQpqQYdBzU4ImsUN/dRaUpfm
 0FE5OXdjLvgmknWNRqKf0+s1iE5OfWnkbqph/5DJCZYrDe6I3jVxAQuprq8jsqBAE91UfQXv7M
 fsmcFC2rPYtZpkuyjKiva2aRb6tpJrqBMcSIJjFn/lW6Gw8djk4bgPsnvg3Q5ukEY54ogqWFjT
 zKwlJ1WrJGeFiTA1cY4AXt7Oh79nKHuDLQWCVa2t1YqMZl3lwErHxMg80FUCHiUeSzMnGbbWty
 dEo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 21 Sep 2022 16:55:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MXwKT3zBlz1RvTr
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 16:55:57 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id tRCT899b_rOz for <dm-devel@redhat.com>;
 Wed, 21 Sep 2022 16:55:53 -0700 (PDT)
Received: from [10.225.163.81] (unknown [10.225.163.81])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MXwKJ1tkpz1RvLy;
 Wed, 21 Sep 2022 16:55:47 -0700 (PDT)
Message-ID: <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
Date: Thu, 22 Sep 2022 08:55:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
To: Mike Snitzer <snitzer@redhat.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com> <YytJhEywBhqcr7MX@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YytJhEywBhqcr7MX@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 gost.dev@samsung.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/22/22 02:27, Mike Snitzer wrote:
> On Tue, Sep 20 2022 at  5:11P -0400,
> Pankaj Raghav <p.raghav@samsung.com> wrote:
> 
>> - Background and Motivation:
>>
>> The zone storage implementation in Linux, introduced since v4.10, first
>> targetted SMR drives which have a power of 2 (po2) zone size alignment
>> requirement. The po2 zone size was further imposed implicitly by the
>> block layer's blk_queue_chunk_sectors(), used to prevent IO merging
>> across chunks beyond the specified size, since v3.16 through commit
>> 762380ad9322 ("block: add notion of a chunk size for request merging").
>> But this same general block layer po2 requirement for blk_queue_chunk_sectors()
>> was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
>> to be non-power-of-2").
>>
>> NAND, which is the media used in newer zoned storage devices, does not
>> naturally align to po2. In these devices, zone capacity(cap) is not the
>> same as the po2 zone size. When the zone cap != zone size, then unmapped
>> LBAs are introduced to cover the space between the zone cap and zone size.
>> po2 requirement does not make sense for these type of zone storage devices.
>> This patch series aims to remove these unmapped LBAs for zoned devices when
>> zone cap is npo2. This is done by relaxing the po2 zone size constraint
>> in the kernel and allowing zoned device with npo2 zone sizes if zone cap
>> == zone size.
>>
>> Removing the po2 requirement from zone storage should be possible
>> now provided that no userspace regression and no performance regressions are
>> introduced. Stop-gap patches have been already merged into f2fs-tools to
>> proactively not allow npo2 zone sizes until proper support is added [1].
>>
>> There were two efforts previously to add support to npo2 devices: 1) via
>> device level emulation [2] but that was rejected with a final conclusion
>> to add support for non po2 zoned device in the complete stack[3] 2)
>> adding support to the complete stack by removing the constraint in the
>> block layer and NVMe layer with support to btrfs, zonefs, etc which was
>> rejected with a conclusion to add a dm target for FS support [0]
>> to reduce the regression impact.
>>
>> This series adds support to npo2 zoned devices in the block and nvme
>> layer and a new **dm target** is added: dm-po2zoned-target. This new
>> target will be initially used for filesystems such as btrfs and
>> f2fs until native npo2 zone support is added.
> 
> As this patchset nears the point of being "ready for merge" and DM's
> "zoned" oriented targets are multiplying, I need to understand: where
> are we collectively going?  How long are we expecting to support the
> "stop-gap zoned storage" layers we've constructed?
> 
> I know https://zonedstorage.io/docs/introduction exists... but it
> _seems_ stale given the emergence of ZNS and new permutations of zoned
> hardware. Maybe that isn't quite fair (it does cover A LOT!) but I'm
> still left wanting (e.g. "bring it all home for me!")...
> 
> Damien, as the most "zoned storage" oriented engineer I know, can you
> please kick things off by shedding light on where Linux is now, and
> where it's going, for "zoned storage"?

Let me first start with what we have seen so far with deployments in the
field.

The largest user base for zoned storage is for now hyperscalers (cloud
services) deploying SMR disks. E.g. Dropbox has many times publicized its
use of SMR HDDs. ZNS is fairly new, and while it is being actively
evaluated by many, there are not yet any large scale deployments that I am
aware of.

Most of the large scale SMR users today mainly use the zoned storage
drives directly, without a file system, similarly to their use of regular
block devices. Some erasure coded object store sits on top of the zoned
drives and manage them. The interface used for that has now switched to
using the kernel API, from libzbc pass-through in the early days of SMR
support. With the inclusion of zonefs in kernel 5.6, many are now
switching to using that instead of directly accessing the block device
file. zonefs makes the application development somewhat easier (there is
no need for issuing zone management ioctls) and can also result in
applications that can actually run almost as-is on top of regular block
devices with a file system. That is a very interesting property,
especially in development phase for the user.

Beside these large scale SMR deployments, there are also many smaller
users. For these cases, dm-zoned seemed to be used a lot. In particular,
the Chia cryptocurrency boom (now fading ?) did generate a fair amount of
new SMR users relying on dm-zoned. With btrfs zoned storage support
maturing, dm-zoned is not as needed as it used to though. SMR drives can
be used directly under btrfs and I certainly am always recommending this
approach over dm-zoned+ext4 or dm-zoned+xfs as performance is much better
for write intensive workloads.

For Linux kernel overall, zoned storage is in a very good shape for raw
block device use and zonefs use. Production deployments we are seeing are
a proof of that. Currently, my team effort is mostly focused on btrfs and
zonefs and increasing zoned storage use cases.

1) For btrfs, Johannes and Naohiro are working on stabilizing support for
ZNS (we still have some issues with the management of active zones) and
implementing de-clustered parity RAID support so that zoned drives can be
used in RAID 0, 1, 10, 5, 6 and erasure coded volumes. This will address
use cases such as home NAS boxes, backup servers, small file servers,
video applications (e.g. video surveillance) etc. Essentially, any
application with large storage capacity needs that is not a distributed
setup. There are many.

2) For zonefs, I have some to-do items lined up to improve performance
(better read IO tail latency) and further improve ease of use (e.g. remove
the O_DIRECT write constraint).

3) At the block device level, we are also working on adding zoned block
device specifications to virtio and implementing that support in qemu and
the kernel. Patches are floating around now but not yet merged. This
addresses the use of zoned storage in VM environments through virtio
interface instead of directly attaching devices to guests.

> To give some additional context to help me when you answer: I'm left
> wondering what, if any, role dm-zoned has to play moving forward given
> ZNS is "the future" (and yeah "the future" is now but...)?  E.g.: Does
> it make sense to stack dm-zoned ontop of dm-po2zoned!?

That is a lot to unfold in a small paragraph :)

First of all, I would rephrase "ZNS is the future" into "ZNS is a very
interesting alternative to generic NVMe SSDs". The reason being that HDD
are not dead, far from it. They still are way cheaper than SSDs in $/TB :)
So ZNS is not really in competition with SMR HDDs jere. The 2 are
complementary, exactly like regular SSDs are complementary to regular HDDs.

dm-zoned serves some use cases for SMR HDDs (see above) but does not
address ZNS (more on this below). And given that all SMR HDD on the market
today have a zone size that is a power of 2 number of LBAs (256MB zone
size is by far the most common), dm-po2zoned is not required at all for SMR.

Pankaj patch series is all about supporting ZNS devices that have a zone
size that is not a power of 2 number of LBAs as some vendors want to
produce such drives. There is no such move happening in the SMR world as
all users are happy with the current zone sizes which match the kernel
support (which currently requires power-of-2 number of LBAs for the zone
size).

I do not think we have yet reached a consensus on if we really want to
accept any zone size for zoned storage. I personally am not a big fan of
removing the existing constraint as that makes the code somewhat heavier
(multiplication & divisions instead of bit shifts) without introducing any
benefit to the user that I can see (or agree with). And there is also a
risk of forcing onto the users to redesign/change their code to support
different devices in the same system. That is never nice to fragment
support like this for the same device class. This is why several people,
including me, requested something like dm-po2zoned, to avoid breaking user
applications if non-power-of-2 zone size drives support is merged. Better
than nothing for sure, but not ideal either. That is only my opinion.
There are different opinions out there.

> Yet more context: When I'm asked to add full-blown support for
> dm-zoned to RHEL my gut is "please no, why!?".  And if we really
> should add dm-zoned is dm-po2zoned now also a requirement (to support
> non-power-of-2 ZNS devices in our never-ending engineering of "zoned
> storage" compatibility stop-gaps)?

Support for dm-zoned in RHEL really depends on if your customers need it.
Having SMR and ZNS block device (CONFIG_BLK_DEV_ZONED) and zonefs support
enabled would already cover a lot of use cases on their own, at least the
ones we see in the field today.

Going forward, we expect more use cases to rely on btrfs rather than
dm-zoned or any equivalent DM target for ZNS. And that can also include
non power of 2 zone size drives as btrfs should normally be able to handle
such devices, if the support for them is merged. But we are not there yet
with btrfs support, hence dm-po2zoned.

But again, that all depends on if Pankaj patch series is accepted, that
is, on everybody accepting that we lift the power-of-2 zone size constraint.
> In addition, it was my understanding that WDC had yet another zoned DM
> target called "dm-zap" that is for ZNS based devices... It's all a bit
> messy in my head (that's on me for not keeping up, but I think we need
> a recap!)

Since the ZNS specification does not define conventional zones, dm-zoned
cannot be used as a standalone DM target (read: single block device) with
NVMe zoned block devices. Furthermore, due to its block mapping scheme,
dm-zoned does not support devices with zones that have a capacity lower
than the zone size. So ZNS is really a big *no* for dm-zoned. dm-zap is a
prototype and in a nutshell is the equivalent of dm-zoned for ZNS. dm-zap
can deal with the smaller zone capacity and does not require conventional
zones. We are not trying to push for dm-zap to be merged for now as we are
still evaluating its potential use cases. We also have a different but
functionally equivalent approach implemented as a block device driver that
we are evaluating internally.

Given the above mentioned usage pattern we have seen so far for zoned
storage, it is not yet clear if something like dm-zap for ZNS is needed
beside some niche use cases.

> So please help me, and others, become more informed as quickly as
> possible! ;)

I hope the above helps. If you want me to develop further any of the
points above, feel free to let me know.

> ps. I'm asking all this in the open on various Linux mailing lists
> because it doesn't seem right to request a concall to inform only
> me... I think others may need similar "zoned storage" help.

All good with me :)

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

