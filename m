Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF37C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667429712;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LKYMyqqmid4Wmxg1lwF/hB+HpRKAL8NvKrHuwq9bdZ0=;
	b=AMa4I3mo9PUkIoKFdCn6g4TOayrANxJI+ETIVyuIT+2HVca0DhI37D7y41Whmba7z7DswR
	oYCJ3Dahvg/M2hrOy4jew4BZK0zXfxjsX6wS4VBa40sxM5uHmkwSkZOIrhljyYIpmxwRDf
	dnO8LvklpwaUoHchz9i2S/vJwhx9mqE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-KNBktRLdM-CUyU4swnvwhg-1; Wed, 02 Nov 2022 18:55:08 -0400
X-MC-Unique: KNBktRLdM-CUyU4swnvwhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8482101A52A;
	Wed,  2 Nov 2022 22:55:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96E3040C835A;
	Wed,  2 Nov 2022 22:55:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66C3F19465A4;
	Wed,  2 Nov 2022 22:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C387E1946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 22:55:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 472CF40C2140; Wed,  2 Nov 2022 22:55:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F77E40C2086
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:55:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22BE9811E67
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:55:04 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-wbipoiNvMj6_UFITjngJeQ-1; Wed, 02 Nov 2022 18:55:02 -0400
X-MC-Unique: wbipoiNvMj6_UFITjngJeQ-1
Received: by mail-pg1-f175.google.com with SMTP id b62so163068pgc.0
 for <dm-devel@redhat.com>; Wed, 02 Nov 2022 15:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=FhcJfbAsBWcPbIOPhmf4NmsmIT2+nCjFL2diMORdIc4=;
 b=jan7fdHP27eeFtoDV1T+2NjEMGD9IP1EN6myhPAeyQZiaM7oXKZsemGQm8fjOQWIVv
 H89KuJft0fgYDyu24t4Pr5jj/tyNfMvmoBAjRrokjv2y6Qa2DVoqQeu+3SmO/kZ3sqDP
 IxbO4SgzYpGE1pzpDA+cky7KoSiqQ15B4yU623uCiBcVZWAdyvgs7DbVHmTD5P2wEQae
 guX2Js7symbg58cnRtjrvu2cM+g/nzbWVkMf73RldKcDF9k3lhA2M6N/FEUlQh/NFq5n
 CxJ3qYWn4tDz42z1bahSI+T34viuiosQATlfofW2Kv6WXF7AFJM58uSGEQTEoxbf+s11
 AFSg==
X-Gm-Message-State: ACrzQf0e7cz4foMyLovAAP3M1oaIYfBKBeVPkkq2akbRIKXkx7MvlzRO
 89gEWS8MF66ibdkP9o1BO80=
X-Google-Smtp-Source: AMsMyM6jm80wXzBme3fqf0bXNSyD8N9iJ7BsvU1v+V/kepBM9YQJbRErCViosW8DEAyldaWwwy8RvQ==
X-Received: by 2002:a63:d757:0:b0:46f:9446:273d with SMTP id
 w23-20020a63d757000000b0046f9446273dmr20335679pgi.436.1667429701140; 
 Wed, 02 Nov 2022 15:55:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89?
 ([2620:15c:211:201:22d3:f380:fa84:4b89])
 by smtp.gmail.com with ESMTPSA id
 pc3-20020a17090b3b8300b00212cf2fe8c3sm3823933pjb.1.2022.11.02.15.54.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Nov 2022 15:55:00 -0700 (PDT)
Message-ID: <1b4bde2b-782d-67c2-62c7-8f5c13721fa8@acm.org>
Date: Wed, 2 Nov 2022 15:54:57 -0700
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
 <20221026231945.6609-5-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-5-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/26/22 16:19, Mike Christie wrote:
> +static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
> +{
> +	switch (type) {
> +	case SCSI_PR_WRITE_EXCLUSIVE:
> +		return PR_WRITE_EXCLUSIVE;
> +	case SCSI_PR_EXCLUSIVE_ACCESS:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}

Also for this function, how about moving the "return 0" statement out of 
the switch statement?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

