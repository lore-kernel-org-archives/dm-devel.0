Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8902AC43334
	for <dm-devel@archiver.kernel.org>; Sun,  5 Jun 2022 03:58:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-sKHQrQG_NOaM00YCvpb32g-1; Sat, 04 Jun 2022 23:58:56 -0400
X-MC-Unique: sKHQrQG_NOaM00YCvpb32g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02866811E75;
	Sun,  5 Jun 2022 03:58:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6889A404754D;
	Sun,  5 Jun 2022 03:58:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 448CA1947056;
	Sun,  5 Jun 2022 03:58:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C22E61947052
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 03:58:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A15F340EC002; Sun,  5 Jun 2022 03:58:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB5F40EC001
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 03:58:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8505D801228
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 03:58:47 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-TgDCys6oNyK6IqSfG26hCA-1; Sat, 04 Jun 2022 23:58:46 -0400
X-MC-Unique: TgDCys6oNyK6IqSfG26hCA-1
Received: by mail-pf1-f177.google.com with SMTP id b135so10160703pfb.12
 for <dm-devel@redhat.com>; Sat, 04 Jun 2022 20:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=GLlhzihM2dCuAq2yDRRLxKU2EBuIMKBNP/WnxYGk2X0=;
 b=fQXD777V5hKPH+HqO47gigBtMGXaT9kHJdw359wyhAH5e5oUnlTZx/qInohU7M32o0
 qy0FvxO0Cj6B2SDlgiNbXZD5Xy+NxQu0zDrzLafI76Bs9v4b3WQgmXPdMiLzt8OfnBEv
 /g7y7OJIueeoRr+deoW3NJ3S2UJdQAtuoLsdaV/cOKFE4eqrggO3qrzldiJ1IwFizb+e
 AiodofzZfU5wfwBy2UxNclf+Wl/pwtvGqYPPp6O3HZjvOVBLF5mjqpdPU5dHB+/thfwa
 EYcnrMlz232HOIcwYO1/IDi/cBqP5dHk3Kv1TrnJzqIPcsrF2XXh75Hf6TYAovSPqJUU
 8CNw==
X-Gm-Message-State: AOAM532IOcV58YL2aScFMVul0UOPCx8xPX0zzyRnyZHVT1ZEFCvoHrRR
 SdxgxKiVQ2+BeoRJr618pDiJvC9bSEpgpA==
X-Google-Smtp-Source: ABdhPJxjZQL2kRq6bvFCX8dmTJe/PfzlKduObJ6a9TyRigosO4HLRQYC+nhNd3VIblOwV0h/y4fT0g==
X-Received: by 2002:a63:4387:0:b0:3c6:9490:4e4b with SMTP id
 q129-20020a634387000000b003c694904e4bmr15298413pga.438.1654401524741; 
 Sat, 04 Jun 2022 20:58:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 e15-20020aa7980f000000b0051826824d90sm8367665pfl.177.2022.06.04.20.58.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 04 Jun 2022 20:58:43 -0700 (PDT)
Message-ID: <b4d8fdba-53e3-0f16-1209-7ee2b25ce1ea@acm.org>
Date: Sat, 4 Jun 2022 20:58:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Christie <michael.christie@oracle.com>, linux-block@vger.kernel.org, 
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-4-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220603065536.5641-4-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 03/11] scsi: Move sd_pr_type to header to
 share.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/2/22 23:55, Mike Christie wrote:
> +static inline char block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return 0x01;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return 0x03;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return 0x05;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return 0x06;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return 0x07;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return 0x08;
> +	default:
> +		return 0;
> +	}
> +};
> +
> +static inline enum pr_type scsi_pr_type_to_block(char type)
> +{
> +	switch (type) {
> +	case 0x01:
> +		return PR_WRITE_EXCLUSIVE;
> +	case 0x03:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case 0x05:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case 0x06:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case 0x07:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case 0x08:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}

Since 'char' is used above to represent a single byte, please use u8 or 
uint8_t instead.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

