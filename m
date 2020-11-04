Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CD0C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:34:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EAA642080D
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAA642080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-B7THoPOJPqy8H5x-95wdgA-1; Wed, 04 Nov 2020 02:34:47 -0500
X-MC-Unique: B7THoPOJPqy8H5x-95wdgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27449186DD24;
	Wed,  4 Nov 2020 07:34:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D21B55C22E;
	Wed,  4 Nov 2020 07:34:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36AF1181A06B;
	Wed,  4 Nov 2020 07:34:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A41ZBum012069 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 20:35:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37C9A21568B0; Wed,  4 Nov 2020 01:35:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32F1E215688E
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 01:35:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D647F801779
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 01:35:08 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-570-a0l4GcquMLqV7SfFXBNyyQ-1;
	Tue, 03 Nov 2020 20:35:04 -0500
X-MC-Unique: a0l4GcquMLqV7SfFXBNyyQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UE90IOd_1604453699
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UE90IOd_1604453699) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 04 Nov 2020 09:34:59 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
	<20201103134824.GA26430@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <0034522a-c6f8-9be3-ba9b-7383aa0f441f@linux.alibaba.com>
Date: Wed, 4 Nov 2020 09:34:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103134824.GA26430@redhat.com>
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
X-Mailman-Approved-At: Wed, 04 Nov 2020 02:34:40 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] Why queue_work unneeded for REQUEUE bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 11/3/20 9:48 PM, Mike Snitzer wrote:
> On Tue, Nov 03 2020 at  4:23am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>
>> Hi Mike,
>>
>> Why queue_work() is unnecessary here for bio with BLK_STS_DM_REQUEUE
>> returned?
>>
>> Thanks
>> Jeffle Xu
>>
>> ---
>>   drivers/md/dm.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index c18fc2548518..ae550daa99b5 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -908,9 +908,11 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>>   			 * Target requested pushing back the I/O.
>>   			 */
>>   			spin_lock_irqsave(&md->deferred_lock, flags);
>> -			if (__noflush_suspending(md))
>> +			if (__noflush_suspending(md)) {
>>   				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>>   				bio_list_add_head(&md->deferred, io->orig_bio);
>> +				queue_work(md->wq, &md->work);
>> +			}
>>   			else
>>   				/* noflush suspend was interrupted. */
>>   				io->status = BLK_STS_IOERR;
>> -- 
>> 2.27.0
>>
> For the case you highlighted (BLK_STS_DM_REQUEUE + __noflush_suspending)
> I think the missing queue_work is because we're actively dealing with
> the fact that we do _not_ want to flush IO.  SO kicking the workqueue
> there isn't helpful because it just processes work that cannot be issued
> yet -- the workqueue will be kicked upon resume (see __dm_resume's
> dm_queue_flush).


Got it. Thanks.

If we are in process of DMF_NOFLUSH_SUSPENDING, then the BLK_STS_DM_REQUEUE

may be impacted by the suspending, then re-enqueue the bio to @deferred 
list. Or just pop

out BLK_STS_IOERR error.


-- 
Jeffle
Thanks

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

