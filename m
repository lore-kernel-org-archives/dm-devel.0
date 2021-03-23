Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F3DC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 03:46:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90C21619AB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 03:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90C21619AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-i-ng9AVrNJyBsgLwlNi1YQ-1; Mon, 22 Mar 2021 23:46:29 -0400
X-MC-Unique: i-ng9AVrNJyBsgLwlNi1YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B082B1084C98;
	Tue, 23 Mar 2021 03:46:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4992260C0F;
	Tue, 23 Mar 2021 03:46:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 689C14BB7C;
	Tue, 23 Mar 2021 03:46:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12N3kFdU015154 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Mar 2021 23:46:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F1C3A2157F26; Tue, 23 Mar 2021 03:46:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB3052157F24
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 03:46:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF4CE80006E
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 03:46:11 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
	[209.85.210.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-469-wDIbwe9LPZyGNM1jdonSDA-1; Mon, 22 Mar 2021 23:46:07 -0400
X-MC-Unique: wDIbwe9LPZyGNM1jdonSDA-1
Received: by mail-pf1-f181.google.com with SMTP id 11so12885522pfn.9;
	Mon, 22 Mar 2021 20:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=AQohhoHNI0iXfeHD5Zwk4VUO1Vj7NH97ijqHBjTVA5I=;
	b=Eob9D5bW6Gu+3lKB7rwJaDZZVvOeIj6/fixvrqfJr8NRc/3AuKNUv8AzoWKvW+q0jX
	JBX5BgpVzbUO5GKh5scUvyuCLgLxQOtli2R/s0jOsRCClGhEO2ehgvjbsKD4a7J9AeoW
	o/3bZiTHLBpqqrfv9MmHkwYGZPLzVDQ3IDTMsXNIgnjnMvkw4ST6+f+rfCL1HfQe1EFg
	PYi/ZB0DEkdxxB24IqnfW45kw0QY2ecb1bDhwpdKNBtVQ4cQqgi+Kp3W81Y/zuOnJcpA
	DbfvJG7jns5p339DqEmoS+nVcn6QDDVoDNExSufm9RDtxy55eCFWDelyPR0oVKjrWPA4
	c0Lg==
X-Gm-Message-State: AOAM532Mv2x/vEfBQWukT3cv81sVHzyMzdw4cqq7WHxoFkgFCGp2Kgic
	mtdU39XmU8nA3w8TitXJgcVNnipdLpE=
X-Google-Smtp-Source: ABdhPJwmedZp89STq0PIkMKEWtugmsX2OXYRIcgiHPi7IsZMyYW1NGFCN0q6xZd9TAwj/7P95k7GeA==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id
	v10-20020a1709029a0ab02900e6bf008a36mr3028144plp.51.1616471165897;
	Mon, 22 Mar 2021 20:46:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:2a1:40ef:41b6:3cf0?
	([2601:647:4802:9070:2a1:40ef:41b6:3cf0])
	by smtp.gmail.com with ESMTPSA id
	y15sm16062282pgi.31.2021.03.22.20.46.04
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 22 Mar 2021 20:46:05 -0700 (PDT)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <522a2c87-e9f3-e62a-e09b-084821c698a0@grimberg.me>
Date: Mon, 22 Mar 2021 20:46:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318164827.1481133-10-ming.lei@redhat.com>
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
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


> +static void blk_bio_poll_post_submit(struct bio *bio, blk_qc_t cookie)
> +{
> +	bio->bi_iter.bi_private_data = cookie;
> +}
> +

Hey Ming, thinking about nvme-mpath, I'm thinking that this should be
an exported function for failover. nvme-mpath updates bio.bi_dev
when re-submitting I/Os to an alternate path, so I'm thinking
that if this function is exported then nvme-mpath could do as little
as the below to allow polling?

--
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 92adebfaf86f..e562e296153b 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -345,6 +345,7 @@ static void nvme_requeue_work(struct work_struct *work)
         struct nvme_ns_head *head =
                 container_of(work, struct nvme_ns_head, requeue_work);
         struct bio *bio, *next;
+       blk_qc_t cookie;

         spin_lock_irq(&head->requeue_lock);
         next = bio_list_get(&head->requeue_list);
@@ -359,7 +360,8 @@ static void nvme_requeue_work(struct work_struct *work)
                  * path.
                  */
                 bio_set_dev(bio, head->disk->part0);
-               submit_bio_noacct(bio);
+               cookie = submit_bio_noacct(bio);
+               blk_bio_poll_post_submit(bio, cookie);
         }
  }
--

I/O failover will create misalignment from the polling context cpu and
the submission cpu (running requeue_work), but I don't see if there is
something that would break here...

Thoughts?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

