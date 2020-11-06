Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AF6C388F9
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 31852206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31852206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-Oie0p_S6PA6dZqnXhVU31Q-1; Sun, 08 Nov 2020 12:05:09 -0500
X-MC-Unique: Oie0p_S6PA6dZqnXhVU31Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61EE71006C8E;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 475DD76640;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 192BC180BAFF;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A63nFpj012625 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 22:49:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8DA38F519E; Fri,  6 Nov 2020 03:49:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 849EFF556C
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 03:49:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22B8E185A79C
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 03:49:13 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-548-Q_Rl7VTmMIWQtPsIJSzy5g-1;
	Thu, 05 Nov 2020 22:49:10 -0500
X-MC-Unique: Q_Rl7VTmMIWQtPsIJSzy5g-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R841e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UEO19wt_1604634545
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEO19wt_1604634545) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 06 Nov 2020 11:49:05 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
Message-ID: <b042e052-fa66-6542-f382-8bf33c4ffc24@linux.alibaba.com>
Date: Fri, 6 Nov 2020 11:49:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [Question] Why queue_work unneeded for REQUEUE bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mike,


I have another question about dm, though it's irrelevant to this original

mail.


Currently abnormal IO will call blk_queue_split() and normal IO will

be split considering @max_sectors/@chunk_sectos (in max_io_len()).


Question 1: Why bio should be split considering queue_limits in dm layer?

After all the underlying device will split themselves by queue_limits if

the dm layer doesn't split by queue_limits.


Then Question 2: Currently only @max_sectors is considered when splitting

normal IO in dm layer. Should we also consider 
@max_segments/@max_segment_size

as blk_queue_split() does?


Thanks,

Jeffle


On 11/3/20 5:23 PM, Jeffle Xu wrote:
> Hi Mike,
>
> Why queue_work() is unnecessary here for bio with BLK_STS_DM_REQUEUE
> returned?
>
> Thanks
> Jeffle Xu
>
> ---
>   drivers/md/dm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c18fc2548518..ae550daa99b5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -908,9 +908,11 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>   			 * Target requested pushing back the I/O.
>   			 */
>   			spin_lock_irqsave(&md->deferred_lock, flags);
> -			if (__noflush_suspending(md))
> +			if (__noflush_suspending(md)) {
>   				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>   				bio_list_add_head(&md->deferred, io->orig_bio);
> +				queue_work(md->wq, &md->work);
> +			}
>   			else
>   				/* noflush suspend was interrupted. */
>   				io->status = BLK_STS_IOERR;

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

