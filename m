Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36E3C6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 18:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679682354;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QSCFzyUcm+IdDUYSrcM7MI63ZbzwiUZFKmgCatRW2Pc=;
	b=R04O9Dh0JCvyeWCgANWXD6AiayaxNRO7BjYQt1cyyVkPmG8i8sIUER/EYJ+NosB8l+RpCE
	aMqRsh5J3vMBm+ubGdov7jd71W2qt6a37AVqZiwMEW8KQB03cT8K9AHNewqsFbuvMY/Sql
	s3PwsXHP3GcPU1L79o5sbxiTq+zLYqg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-g-aCSFfTMrKVuqLuOltUaQ-1; Fri, 24 Mar 2023 14:25:51 -0400
X-MC-Unique: g-aCSFfTMrKVuqLuOltUaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B902807D69;
	Fri, 24 Mar 2023 18:25:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 462321121314;
	Fri, 24 Mar 2023 18:25:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04BB41946A5E;
	Fri, 24 Mar 2023 18:25:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D5FC31946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 18:25:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B49BE140E950; Fri, 24 Mar 2023 18:25:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC483140EBF4
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 18:25:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FB70889047
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 18:25:46 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-PGFwwSQoPuWw18zNxINRbQ-1; Fri, 24 Mar 2023 14:25:44 -0400
X-MC-Unique: PGFwwSQoPuWw18zNxINRbQ-1
Received: by mail-pf1-f175.google.com with SMTP id fd25so1846273pfb.1
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 11:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679682343;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=LZKRMSuluRMc0e9BXO5+TDbgf6gy3EYC5wrIH/iS9UE=;
 b=wODPH5l+6SSVTRaqSx/fkR6w2teoyu/XqCeQQOXI4+T5TF1lk9FjM9kxu9UPAoOEOz
 D9agQiUGhlQaL9SMRo5yMjA97I4f1o1525ri58C8ctUFLDzA3S5bsJIO4s1/wmD03oXq
 cM7U/KIPsJEYGQ+MWeKr5eFldzY59dj0syUKKTtnfTsoHsBB8LJS/GS2cpXTj7O62uZH
 3XRTZF3J696dbVleyhFvuKt+lMvUGqKM6E4hScxD056i+fAG2T9fH1UTPgMTXHmkiC6E
 3eGZLhUy1DphhRJ+0TPm2poq8QcHFfOVBcVA8FZUqwOZ4MAvFKF7LE0RB+J/YD/m3IEl
 gxyQ==
X-Gm-Message-State: AO0yUKUa6IfpLDQu+dbyw3unLFjBAr/DYWuvUUZG2tnTxuDHgxUuIQsm
 X8hqa0KKirVD0OfrJ/M2pfc=
X-Google-Smtp-Source: AKy350ZYv1mpvYBouV9n6c8TTxMkUBO8IzS9P0gDxnwkTxznstPza4O2GaiA4I+LyvTxVupCsWuSlw==
X-Received: by 2002:aa7:9a5c:0:b0:628:1347:a619 with SMTP id
 x28-20020aa79a5c000000b006281347a619mr4097965pfj.10.1679682343388; 
 Fri, 24 Mar 2023 11:25:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2421:e16e:b98f:7e76?
 ([2620:15c:211:201:2421:e16e:b98f:7e76])
 by smtp.gmail.com with ESMTPSA id
 v5-20020aa78085000000b006254794d5b2sm2401894pff.94.2023.03.24.11.25.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 11:25:42 -0700 (PDT)
Message-ID: <298ce171-8738-1cd6-bce6-a846fb6469af@acm.org>
Date: Fri, 24 Mar 2023 11:25:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-5-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-5-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v5 04/18] scsi: Move sd_pr_type to header to
 share
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/24/23 11:17, Mike Christie wrote:
> diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
> new file mode 100644
> index 000000000000..44766d7a81d8
> --- /dev/null
> +++ b/include/scsi/scsi_block_pr.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_BLOCK_PR_H
> +#define _SCSI_BLOCK_PR_H
> +
> +#include <uapi/linux/pr.h>
> +
> +enum scsi_pr_type {
> +	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
> +	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
> +	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
> +	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
> +	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
> +	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
> +};
> +
> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return SCSI_PR_WRITE_EXCLUSIVE;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	}
> +
> +	return 0;
> +}
> +
> +#endif

Hi Mike,

Has it been considered to move enum scsi_pr_type into 
include/scsi/scsi_common.h and block_pr_type_to_scsi() into 
drivers/scsi/scsi_common.c? Other definitions that are shared between 
SCSI initiator and SCSI target code exist in these files.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

