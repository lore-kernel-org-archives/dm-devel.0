Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3576BC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 22:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667429459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XDV7p/YHBZQIxG7rL9L+BQM8WWTGAuqW2KnYWMUqebc=;
	b=Zq00KPJV1GZUNLP3aYM4pxiNDBJocDyH1iu13ueYtrwajSXqUaCE/vpL3PuW+TgbDCj85o
	zfcVShq+ASaR/F+V7MYhUgwunpcLc7zLC/NwWlHjPR7GWb9JM6nFdyIqwuIE/8m+DrBDKZ
	D9II+aQQw0jlImBMbpNjV4ECJIzJ8fc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-_izvk5APMKanWo_dIivU9g-1; Wed, 02 Nov 2022 18:50:55 -0400
X-MC-Unique: _izvk5APMKanWo_dIivU9g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FB1C1C05AB6;
	Wed,  2 Nov 2022 22:50:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F309C49BB60;
	Wed,  2 Nov 2022 22:50:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5FA719465A4;
	Wed,  2 Nov 2022 22:50:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 757DB1946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 22:50:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 555F440C6E14; Wed,  2 Nov 2022 22:50:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7F240C6EE9
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:50:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 328F7811E67
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:50:52 +0000 (UTC)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-IBwihPdsNg6FmOwJAZT-DA-1; Wed, 02 Nov 2022 18:50:50 -0400
X-MC-Unique: IBwihPdsNg6FmOwJAZT-DA-1
Received: by mail-pf1-f182.google.com with SMTP id k22so42002pfd.3
 for <dm-devel@redhat.com>; Wed, 02 Nov 2022 15:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oi/++AM86hQyi+QYKhOHsLnIasDTZEsqZxanEFqTzjY=;
 b=SMmAez6tbGOZ2/D2jadua4bqYQSPChxC/GePhTkfWpHsIMumW54itIgJnPug1XeWQC
 6cthSqeXpcWGyE+JMeeC5s6RBqo+ikGTAOcJmLPaxCpXwj2IiMnAUmv2Pit6ndV3mJHl
 2DOSKyhzltm3ybLo30ffe6yZkk2WOJNfuTmbYlluuPMMxuBqqhVC6OGkzrRuLCfIUTjp
 g+Te265vlw+yD89uoNNmnRWc6SC9hUHuFtH6BKsojFy8LZX7UX7mIGPSCH5NKbaJbvRF
 suZoNWdA/zT0EYbscNOS0M05vGPkGMfGKzhgjB5cdmusNg0FPWB8kb8h6gz2Z4AR9Mrc
 yDHg==
X-Gm-Message-State: ACrzQf3pjpYPf15rk+B7KO2vSPMkHwgNEd3bKVLN4ThTWdmprsNx8+Oy
 CIF88r1Sw7XoUgH2CfBU7Vc=
X-Google-Smtp-Source: AMsMyM6bPaD6vkm2t6htya5qjFAYxNj4UjVLLKBnOw0YiQYnA2cdZTgepQevyScmNi+GFrRNkBEHRA==
X-Received: by 2002:a63:5909:0:b0:46e:c98d:e07c with SMTP id
 n9-20020a635909000000b0046ec98de07cmr23719156pgb.530.1667429449450; 
 Wed, 02 Nov 2022 15:50:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89?
 ([2620:15c:211:201:22d3:f380:fa84:4b89])
 by smtp.gmail.com with ESMTPSA id
 f26-20020aa7969a000000b0056bfd4a2702sm8928050pfk.45.2022.11.02.15.50.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Nov 2022 15:50:48 -0700 (PDT)
Message-ID: <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
Date: Wed, 2 Nov 2022 15:50:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-2-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 01/19] block: Add PR callouts for read
 keys and reservation
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/26/22 16:19, Mike Christie wrote:
> +struct pr_keys {
> +	u32	generation;
> +	u32	num_keys;
> +	u64	keys[];
> +};
> +
> +struct pr_held_reservation {
> +	u64		key;
> +	u32		generation;
> +	enum pr_type	type;
> +};
> +
>   struct pr_ops {
>   	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
>   			u32 flags);
> @@ -14,6 +26,18 @@ struct pr_ops {
>   	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
>   			enum pr_type type, bool abort);
>   	int (*pr_clear)(struct block_device *bdev, u64 key);
> +	/*
> +	 * pr_read_keys - Read the registered keys and return them in the
> +	 * pr_keys->keys array. The keys array will have been allocated at the
> +	 * end of the pr_keys struct and is keys_len bytes. If there are more
> +	 * keys than can fit in the array, success will still be returned and
> +	 * pr_keys->num_keys will reflect the total number of keys the device
> +	 * contains, so the caller can retry with a larger array.
> +	 */
> +	int (*pr_read_keys)(struct block_device *bdev,
> +			struct pr_keys *keys_info, u32 keys_len);
> +	int (*pr_read_reservation)(struct block_device *bdev,
> +			struct pr_held_reservation *rsv);
>   };

Is there any pr_read_keys() implementation that won't have to divide 
@keys_len by 8? How about leaving out that argument and making callers 
store the number of elements in the keys[] array in the num_keys member 
before calling pr_read_keys()?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

