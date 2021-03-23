Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB6FC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 16:55:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 108D36192E
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 16:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 108D36192E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-ElwY3FZtPL-9XgZLTH0Tmw-1; Tue, 23 Mar 2021 12:55:01 -0400
X-MC-Unique: ElwY3FZtPL-9XgZLTH0Tmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AE1B83DD22;
	Tue, 23 Mar 2021 16:54:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 906FA5C1C5;
	Tue, 23 Mar 2021 16:54:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24EE84BB7C;
	Tue, 23 Mar 2021 16:54:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12NGsmZi025293 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 12:54:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D761747CE1; Tue, 23 Mar 2021 16:54:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D22936E1CE
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 16:54:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D63D802C1C
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 16:54:45 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
	[209.85.216.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-BFe5HXDSND2NIQ8N_H64nA-1; Tue, 23 Mar 2021 12:54:40 -0400
X-MC-Unique: BFe5HXDSND2NIQ8N_H64nA-1
Received: by mail-pj1-f41.google.com with SMTP id
	a22-20020a17090aa516b02900c1215e9b33so12444253pjq.5; 
	Tue, 23 Mar 2021 09:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Rhue+PMD7lcSwRDm9/LSgaFj1hwON71pQSCOJMu7TnU=;
	b=lTvOJsbsGnIQxSaz2lYCQMPYFnKI5s64WFUxcIkEJeOH5n5qBGRfByTiyxC/gBMF7J
	FFSlj9NYVVEBoZ8tC65bRLUC1ZHPgP2L8srvO0qX+5NIQ01n0SZXyjyC3ZwWyjarzjNh
	tS/51qc17ZrWQf1ZjCXdaNDw2huInagpHhHN4cVC1pTLcJDOEAlcZbjOzsLDAIm9NGp3
	Ojum08rYSLGPPbLKU6Zg3yeEewxgkzaPx317cv3/37Ymmdqxgifo0o+tTVtBKIzu2GZT
	WqFA3E/8xi/XjLpBp9EFd6I26l+QsBUMBG+4++2j/CSnAAqH1wf6uIoBG3/bmt/GeOF9
	L7/A==
X-Gm-Message-State: AOAM532nqjuqSjFRnMJmm01WdXCr+v6I/zJMu3f0TKMV345i5qTXQuhZ
	7vJdpwN5p8bHPdqoq8dyjHjqQFLINMU=
X-Google-Smtp-Source: ABdhPJxY+14Wg+F4KFF0Ga187ZpMTeiwsNYv3efM2W0n+lG4Hozh9MYnONdsI0gUQGXcJbl+9hlENQ==
X-Received: by 2002:a17:90a:be09:: with SMTP id
	a9mr5329699pjs.219.1616518478881; 
	Tue, 23 Mar 2021 09:54:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:3b29:de57:36aa:67b9?
	([2601:647:4802:9070:3b29:de57:36aa:67b9])
	by smtp.gmail.com with ESMTPSA id
	d124sm17690803pfa.149.2021.03.23.09.54.37
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 23 Mar 2021 09:54:38 -0700 (PDT)
To: Ming Lei <ming.lei@redhat.com>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
	<522a2c87-e9f3-e62a-e09b-084821c698a0@grimberg.me>
	<YFnYhBIiFhiyX8Wb@T590>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <713f2a27-4a2c-8723-3dfd-de6d68956eb2@grimberg.me>
Date: Tue, 23 Mar 2021 09:54:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFnYhBIiFhiyX8Wb@T590>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 09/13] block: use per-task poll
 context to implement bio based io poll
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


>>> +static void blk_bio_poll_post_submit(struct bio *bio, blk_qc_t cookie)
>>> +{
>>> +	bio->bi_iter.bi_private_data = cookie;
>>> +}
>>> +
>>
>> Hey Ming, thinking about nvme-mpath, I'm thinking that this should be
>> an exported function for failover. nvme-mpath updates bio.bi_dev
>> when re-submitting I/Os to an alternate path, so I'm thinking
>> that if this function is exported then nvme-mpath could do as little
>> as the below to allow polling?
>>
>> --
>> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
>> index 92adebfaf86f..e562e296153b 100644
>> --- a/drivers/nvme/host/multipath.c
>> +++ b/drivers/nvme/host/multipath.c
>> @@ -345,6 +345,7 @@ static void nvme_requeue_work(struct work_struct *work)
>>          struct nvme_ns_head *head =
>>                  container_of(work, struct nvme_ns_head, requeue_work);
>>          struct bio *bio, *next;
>> +       blk_qc_t cookie;
>>
>>          spin_lock_irq(&head->requeue_lock);
>>          next = bio_list_get(&head->requeue_list);
>> @@ -359,7 +360,8 @@ static void nvme_requeue_work(struct work_struct *work)
>>                   * path.
>>                   */
>>                  bio_set_dev(bio, head->disk->part0);
>> -               submit_bio_noacct(bio);
>> +               cookie = submit_bio_noacct(bio);
>> +               blk_bio_poll_post_submit(bio, cookie);
>>          }
>>   }
>> --
>>
>> I/O failover will create misalignment from the polling context cpu and
>> the submission cpu (running requeue_work), but I don't see if there is
>> something that would break here...
> 
> I understand requeue shouldn't be one usual event, and I guess it is just
> fine to fallback to IRQ based mode?

Well, when it will failover, it will probably be directed to the poll
queues. Maybe I'm missing something...

> This patchset actually doesn't cover such bio submission from kernel context.

What is the difference?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

