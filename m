Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0788BC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DD4760235
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD4760235
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-0vOsL8ynMHKHCGl_o6gycw-1; Thu, 28 Jan 2021 03:39:03 -0500
X-MC-Unique: 0vOsL8ynMHKHCGl_o6gycw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A18141007293;
	Thu, 28 Jan 2021 08:38:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C04A25D9F4;
	Thu, 28 Jan 2021 08:38:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CA671809C9F;
	Thu, 28 Jan 2021 08:38:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S27YsU013337 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 21:07:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BC34D2166B2A; Thu, 28 Jan 2021 02:07:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B585A2166B2B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 02:07:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3562E101A561
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 02:07:31 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-408-QviZ9pVxNTKtlXEtqmA6zw-1;
	Wed, 27 Jan 2021 21:07:28 -0500
X-MC-Unique: QviZ9pVxNTKtlXEtqmA6zw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UN5mkEi_1611799642
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UN5mkEi_1611799642) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 28 Jan 2021 10:07:22 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
	<20210125121340.70459-6-jefflexu@linux.alibaba.com>
	<20210127171320.GA11535@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <6cf4f805-7e27-7c82-08c2-52d1bdab027f@linux.alibaba.com>
Date: Thu, 28 Jan 2021 10:07:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127171320.GA11535@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 5/6] block: add QUEUE_FLAG_POLL_CAP flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 1/28/21 1:13 AM, Mike Snitzer wrote:
> On Mon, Jan 25 2021 at  7:13am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> Introduce QUEUE_FLAG_POLL_CAP flag representing if the request queue
>> capable of polling or not.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> Why are you adding QUEUE_FLAG_POLL_CAP?  Doesn't seem as though DM or
> anything else actually needs it.

Users can switch on/off polling on device via
'/sys/block/<dev>/queue/io_poll' at runtime. The requisite for turning
on polling is that the device is **capable** of polling. For mq devices,
the requisite is that there's polling hw queue for the device, i.e.,

```
q->tag_set->nr_maps > HCTX_TYPE_POLL &&
q->tag_set->map[HCTX_TYPE_POLL].nr_queues
```

But for dm devices, we need to check if all the underlying devices
support polling or not. Without this newly added queue flag, we need to
check again every time users want to turn on polling via 'io_poll', and
thus the dm layer need to export one interface to block layer, checking
if all the underlying target devices support polling or not, maybe just
like the iopoll() method we did in patch 3. Something like,

```
 struct block_device_operations {
+	bool (*support_iopoll)(struct request_queue *q);
```

The newly added queue flag 'QUEUE_FLAG_POLL_CAP' is just used as a cache
representing if the device **capable** of polling, while the original
queue flag 'QUEUE_FLAG_POLL' representing if polling is turned on for
this device **currently**.


But indeed we are short of queue flag resource. Adding a new queue flag
may not be the best resolution.

Any inspiration?


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

