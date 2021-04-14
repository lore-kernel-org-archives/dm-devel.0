Return-Path: <SRS0=OBV6=JL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FBBC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:15:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F0D361177
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F0D361177
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-PLN3XeNAMImn8Z4SVmjmqQ-1; Wed, 14 Apr 2021 13:15:41 -0400
X-MC-Unique: PLN3XeNAMImn8Z4SVmjmqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F9971854E28;
	Wed, 14 Apr 2021 17:15:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7144319D9B;
	Wed, 14 Apr 2021 17:15:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4593D1806D0F;
	Wed, 14 Apr 2021 17:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13E8ccK9018705 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 14 Apr 2021 04:38:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 368AD20378EF; Wed, 14 Apr 2021 08:38:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30B8520378E6
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 08:38:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A0285A5A8
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 08:38:35 +0000 (UTC)
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-67-jnXbK0AsOv-Y6Dg-HfcP_Q-1;
	Wed, 14 Apr 2021 04:38:30 -0400
X-MC-Unique: jnXbK0AsOv-Y6Dg-HfcP_Q-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UVX9aPU_1618389505
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UVX9aPU_1618389505) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 14 Apr 2021 16:38:26 +0800
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
References: <20210401021927.343727-1-ming.lei@redhat.com>
	<20210401021927.343727-12-ming.lei@redhat.com>
	<20210412093856.GA978201@infradead.org>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a6d46979-810e-bc53-bc19-8acd449e3718@linux.alibaba.com>
Date: Wed, 14 Apr 2021 16:38:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412093856.GA978201@infradead.org>
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
X-Mailman-Approved-At: Wed, 14 Apr 2021 13:14:03 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V5 11/12] block: add poll_capable method to
 support bio-based IO polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 4/12/21 5:38 PM, Christoph Hellwig wrote:
> On Thu, Apr 01, 2021 at 10:19:26AM +0800, Ming Lei wrote:
>> From: Jeffle Xu <jefflexu@linux.alibaba.com>
>>
>> This method can be used to check if bio-based device supports IO polling
>> or not. For mq devices, checking for hw queue in polling mode is
>> adequate, while the sanity check shall be implementation specific for
>> bio-based devices. For example, dm device needs to check if all
>> underlying devices are capable of IO polling.
>>
>> Though bio-based device may have done the sanity check during the
>> device initialization phase, cacheing the result of this sanity check
>> (such as by cacheing in the queue_flags) may not work. Because for dm
>> devices, users could change the state of the underlying devices through
>> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
>> the cached result of the very beginning sanity check could be
>> out-of-date. Thus the sanity check needs to be done every time 'io_poll'
>> is to be modified.
> 
> I really don't think thi should be a method, and I really do dislike
> how we have all this "if (is_mq)" junk.  Why can't we have a flag on
> the gendisk that signals if the device can support polling that
> is autoamtically set for blk-mq and as-needed by bio based drivers?

That would consume one more bit of queue->queue_flags.

Besides, DM/MD is somehow special here that when one of the underlying
devices is disabled polling through '/sys/block/<dev>/io_poll',
currently there's no mechanism notifying the above MD/DM to clear the
previously set queue_flags. Thus the outdated queue_flags still
indicates this DM/MD is capable of polling, while in fact one of the
underlying device has been disabled for polling.

Mike had ever suggested that we can trust the queue_flag, and clear the
outdated queue_flags when later the IO submission or polling routine
finally finds that the device is not capable of polling. Currently
submit_bio_checks() will silently clear the REQ_HIPRI flag and still
submit the bio when the device is actually not capable of polling. To
fix the issue, could we break the submission and return an error code in
submit_bio_checks() if the device is not capable of polling when
submitting HIPRI bio?


> And please move everything that significantly hanges things for the
> mq based path to separate prep patches early in th series.
> 



-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

