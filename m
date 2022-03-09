Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA056C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 01:03:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-aPwHI4prP6iffqP_890dkg-1; Tue, 08 Mar 2022 20:03:04 -0500
X-MC-Unique: aPwHI4prP6iffqP_890dkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B078E101AA45;
	Wed,  9 Mar 2022 01:03:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DEDD40CFD23;
	Wed,  9 Mar 2022 01:03:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D421193212B;
	Wed,  9 Mar 2022 01:03:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 990A2194F4AE
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Mar 2022 01:03:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F5DE2166B13; Wed,  9 Mar 2022 01:03:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 689312166B4F
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 01:02:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C4BD811E75
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 01:02:55 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-iPir-oV-PbyFsOHVIV6LAg-1; Tue, 08 Mar 2022 20:02:53 -0500
X-MC-Unique: iPir-oV-PbyFsOHVIV6LAg-1
Received: by mail-pg1-f178.google.com with SMTP id o26so604560pgb.8
 for <dm-devel@redhat.com>; Tue, 08 Mar 2022 17:02:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=lcKnxyTLjpTRP4WN0RiRep/EF/TdUUWhRlsbEAI4NOU=;
 b=72k7JkAhPwn9O7CuwBUVhSM1CJwu+Q62eLrMV2K/rxIY8FWiE0aQAxTlQxc96QBdb8
 NZlxHEuytdaIcjNJAngSXSjdftXSLiE3UAJb576bQ9WPxdx1a1kPc4wKfQN+JJlrx3dE
 XO2I8euRpvc1PbkWE4DmPitZF2AzCPRp7KY7kv0wQVTICzm1TG75ozQ65M8m4+I5xedZ
 bmhxuVycGa1TANIzIdOg8lGOE2sdEFwGip4g3KkGdji3UXFHe8gsVu01RIU+hU17p0ms
 q1PqR3EfNu4MH2+1naiNiqkPgfl7ZykdK0nRpA/Vf8u9SzugfnkU0gh5mKYcYpjVJAAj
 cBzA==
X-Gm-Message-State: AOAM532xibBTY21UM4G+Ju0y2K9+wDyI9OHtT5FQpYfjNcXWxvr2vUcU
 AfUdPanfrkJj1o5V65eYDYr+8A==
X-Google-Smtp-Source: ABdhPJxRlDuJlLr9rJPUjym5d8YWtRwaggHOPGKhzpMxmV4RfaDA8Xf1sz2n2oaCv8NU6Awb4GcEPw==
X-Received: by 2002:a05:6a00:3102:b0:4f6:b88d:9d45 with SMTP id
 bi2-20020a056a00310200b004f6b88d9d45mr21291400pfb.86.1646787772371; 
 Tue, 08 Mar 2022 17:02:52 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 v24-20020a634818000000b0036407db4728sm292925pga.26.2022.03.08.17.02.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Mar 2022 17:02:51 -0800 (PST)
Message-ID: <eac88ad5-3274-389b-9d18-9b6aa16fcb98@kernel.dk>
Date: Tue, 8 Mar 2022 18:02:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Mike Snitzer <snitzer@redhat.com>
References: <20220307185303.71201-1-snitzer@redhat.com>
 <20220307185303.71201-3-snitzer@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220307185303.71201-3-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v6 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/7/22 11:53 AM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> Support bio(REQ_POLLED) polling in the following approach:
> 
> 1) only support io polling on normal READ/WRITE, and other abnormal IOs
> still fallback to IRQ mode, so the target io is exactly inside the dm
> io.
> 
> 2) hold one refcnt on io->io_count after submitting this dm bio with
> REQ_POLLED
> 
> 3) support dm native bio splitting, any dm io instance associated with
> current bio will be added into one list which head is bio->bi_private
> which will be recovered before ending this bio
> 
> 4) implement .poll_bio() callback, call bio_poll() on the single target
> bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
> dm_io_dec_pending() after the target io is done in .poll_bio()
> 
> 5) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> which is based on Jeffle's previous patch.

It's not the prettiest thing in the world with the overlay on bi_private,
but at least it's nicely documented now.

I would encourage you to actually test this on fast storage, should make
a nice difference. I can run this on a gen2 optane, it's 10x the IOPS
of what it was tested on and should help better highlight where it
makes a difference.

If either of you would like that, then send me a fool proof recipe for
what should be setup so I have a poll capable dm device.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

