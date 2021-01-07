Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6800FC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 09:40:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE2282333E
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 09:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE2282333E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-PPksgSVhM26TncsKPQ2e9Q-1; Thu, 07 Jan 2021 04:40:04 -0500
X-MC-Unique: PPksgSVhM26TncsKPQ2e9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A021F18C89D9;
	Thu,  7 Jan 2021 09:39:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8091E60BF1;
	Thu,  7 Jan 2021 09:39:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DEC994BB7B;
	Thu,  7 Jan 2021 09:39:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1071F7SL011374 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Jan 2021 20:15:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22D7E202660F; Thu,  7 Jan 2021 01:15:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1BF202660E
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 01:15:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27D7C80018D
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 01:15:04 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-360-0wtRM1dnOPmvLPy6vZjMAw-1;
	Wed, 06 Jan 2021 20:14:59 -0500
X-MC-Unique: 0wtRM1dnOPmvLPy6vZjMAw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UKxLUP3_1609982093
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UKxLUP3_1609982093) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 07 Jan 2021 09:14:54 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
Message-ID: <568720e6-b574-eba4-cdf6-6c41c8901772@linux.alibaba.com>
Date: Thu, 7 Jan 2021 09:14:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 07 Jan 2021 04:39:54 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 0/7] dm: add support of iopoll
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

Would you please give some suggestions on this series?


Thanks,
Jeffle

On 12/23/20 7:26 PM, Jeffle Xu wrote:
> This patch set adds support of iopoll for dm devices.
> 
> Several months ago, I also sent a patch set adding support of iopoll
> for dm devices [1]. The old patch set implement this by polling all
> polling mode hardware queues of all underlying target devices
> unconditionally, no matter which hardware queue the bio is enqueued
> into.
> 
> Ming Lei pointed out that this implementation may have performance
> issue. Mike Snitzer also discussed and helpt a lot on the design
> issue. At that time, we agreed that this feature should be
> implemented on the basis of split-bio tracking, since the bio to the
> dm device could be split into multiple split bios to the underlying
> target devices.
> 
> This patch set actually implement the split-bio tracking part.
> Regrettably this implementation is quite coarse and original. Quite
> code refactoring is introduced to the block core, since device mapper
> also calls methods provided by block core to split bios. The new
> fields are directly added into 'struct bio' structure. So this is
> just an RFC version and there may be quite a lot design issues be
> fronted on. I just implement a version quickly and would like to share
> with you my thoughts and problems at hand.
> 
> This implementation works but has poor performance. Awkwardly the
> performance of direct 8k randread decreases ~20% on a 8k-striped
> dm-stripe device.
> 
> The first 5 patches prepare the introduction of iopoll for dm device.
> Patch 6 is the core part and implements a mechanism of tracking split
> bios for bio-based device. Patch 7 just enables this feature.
> 
> [1] https://patchwork.kernel.org/project/linux-block/cover/20201020065420.124885-1-jefflexu@linux.alibaba.com/
> 
> 
> [Design Notes]
> 
> - recursive way or non-recursive way?
> 
> The core of the split-bio tracking mechanism is that, a list is
> maintained in the top bio (the original bio submitted to the dm
> device), which is actually used to maintain all valid cookies of all
> split bios.
> 
> This is actually a non-recursive way to implement the tracking
> mechanism. On the contrary, the recursive way is that, maintain the
> split bios at each dm layer. DM device can be build into a device
> stack. For example, considering the following device stack,
> 
> ```
>             dm0(bio 0)
> dm1(bio 1)             dm2(bio 2)
> nvme0(bio 3)           nvme1(bio 4)
> 
> ```
> 
> The non-recursive way is that bio 3/4 are directly maintained as a
> list beneath bio 0. The recursive way is that, bio 3 is maintained
> as a list beneath bio 1 and bio 4 is maintained as a list beneath
> bio 2, while bio 1/2 are maintained as a list beneath bio 0.
> 
> The reason why I choose the non-recursive way is that, we need call
> blk_bio_poll() or something recursively if it's implemented in the
> recursive way, and I worry this would consume up the stack space if
> the device stack is too deep. After all bio_list is used to prevent
> the dm device using up stack space when submitting bio. 
> 
> 
> - why embed new fields into struct bio directly?
> 
> Mike Snitzer had ever suggested that the newly added fields could be
> integrated into the clone bio allocated by dm subsystem through
> bio_set. There're 3 reasons why I directly embed these fields into
> struct bio:
> 
> 1. The implementation difference of DM and MD
> DM subsystem indeed allocate clone bio itself, in which case we could
> allocate extra per-bio space for specific usage. However MD subsystem
> doesn't allocate extra clone bio, and just uses the bio structure
> originally submitted to MD device as the bio structure submitted to
> the underlying target device. (At least raid0 works in this way.)
> 
> 2. In the previously mentioned non-recursive way of iopoll, a list
> containing all valid cookies should be maintained. For convenience, I
> just put this list in the top bio (the original bio structure
> submitted to the dm device). This original bio structure is allocated
> by the upper layer, e.g. filesystem, and is out of control of DM
> subsystem. (Of course we could resolve this problem technically, e.g.,
> put these newlly added fields into the corresponding dm_io structure
> of the top bio.)
> 
> 3. As a quick implementation, I just put these fields into struct bio
> directly. Obviously more design issues need to be considered when it
> comes into the formal version.
> 
> 
> Jeffle Xu (7):
>   block: move definition of blk_qc_t to types.h
>   block: add helper function fetching gendisk from queue
>   block: add iopoll method for non-mq device
>   block: define blk_qc_t as uintptr_t
>   dm: always return BLK_QC_T_NONE for bio-based device
>   block: track cookies of split bios for bio-based device
>   dm: add support for IO polling
> 
>  block/bio.c                  |   8 ++
>  block/blk-core.c             | 163 ++++++++++++++++++++++++++++++++++-
>  block/blk-mq.c               |  70 ++-------------
>  drivers/md/dm-table.c        |  28 ++++++
>  drivers/md/dm.c              |  27 +++---
>  include/linux/blk-mq.h       |   3 +
>  include/linux/blk_types.h    |  41 ++++++++-
>  include/linux/blkdev.h       |   3 +
>  include/linux/fs.h           |   2 +-
>  include/linux/types.h        |   3 +
>  include/trace/events/kyber.h |   6 +-
>  11 files changed, 270 insertions(+), 84 deletions(-)
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

