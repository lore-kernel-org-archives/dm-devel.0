Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D768AC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 22:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667429277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5k2AonnvIdeVU/SYPwIkCA5z+A7nyvE4uwdzB0Y7N+8=;
	b=FmGytWXuOIaobWcN+I5hNOJ3b2lWK4zFlEMuRzvc4pSwFXxwUpTwDec478u2t5DhoiSBZl
	Dx5mweG94w2mNr29EC9jlrQZEBRIpwUnybqwNSRkWQTR2qCkJzwL5Pw7Un/OZfxACaVl6C
	ZZ9dPoq7LEhsurc1qcFzyEAqhqjWGgk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-dwersnL7Py2wiRkXhId_4A-1; Wed, 02 Nov 2022 18:47:54 -0400
X-MC-Unique: dwersnL7Py2wiRkXhId_4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603052A2AD77;
	Wed,  2 Nov 2022 22:47:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E73840C6EE9;
	Wed,  2 Nov 2022 22:47:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9198219465A4;
	Wed,  2 Nov 2022 22:47:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 825941946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 22:47:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63F842024CBB; Wed,  2 Nov 2022 22:47:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8142028DC1
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:47:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D55085A59D
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:47:48 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-228-JvxaTpzZPH2jsUPa4MVGOw-1; Wed, 02 Nov 2022 18:47:46 -0400
X-MC-Unique: JvxaTpzZPH2jsUPa4MVGOw-1
Received: by mail-pj1-f53.google.com with SMTP id
 d59-20020a17090a6f4100b00213202d77e1so3516625pjk.2
 for <dm-devel@redhat.com>; Wed, 02 Nov 2022 15:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=o4wIJC4qmLD8sZv7FELeKq1bWLCLMI4X8kEQubd/l6g=;
 b=YSUJrV84ffj6JeizJuBpNfGfVovxaXNAxObvN90szTEpuD0Mgz3xANMkuacst+hQRW
 0q7Hio8+xkmHohSxZ5oYabqb56Sx6BApAznW3mcYoBj2YYwJUOFPyh8UqSE/7/Nl4fJe
 FizpTziKtG/HH9UIktNYgWvjo2sUhnzoQ50NPuRwwiPN3rlGaiKy0CIc+GofDWI7Mfia
 KvspwwJZH1I0BC6qEMz3aImKZZL4of3yYLkjN19WVPQLj03ggZGfH0SJFN55VczYGu6l
 VbLR407goKTBwmN4R0a3JR32iwGw/6GSKcwNJ/mfRsmQCcON6Wt5gr4QkG8vdy48bQFF
 C0yw==
X-Gm-Message-State: ACrzQf3MBYm+rqRrv3h/09g644u8UapLiEiRe4TazAVJ07jtE9UBWn19
 J+VQC5/djiFexbwfa4eemT8=
X-Google-Smtp-Source: AMsMyM7oTR2d5lchMffcmjpS1vJGXh4SAt69GYPXVjFJ2dUHdIGIroDKm3Sonab/kAsDMsRgrqXqvA==
X-Received: by 2002:a17:902:bf08:b0:178:90fb:8cda with SMTP id
 bi8-20020a170902bf0800b0017890fb8cdamr26566977plb.9.1667429265258; 
 Wed, 02 Nov 2022 15:47:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89?
 ([2620:15c:211:201:22d3:f380:fa84:4b89])
 by smtp.gmail.com with ESMTPSA id
 w22-20020a1709027b9600b0017f7628cbddsm8842988pll.30.2022.11.02.15.47.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Nov 2022 15:47:44 -0700 (PDT)
Message-ID: <0123db70-6217-135a-4101-0609512e723b@acm.org>
Date: Wed, 2 Nov 2022 15:47:41 -0700
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
 <20221026231945.6609-4-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-4-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/26/22 16:19, Mike Christie wrote:
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
> +	default:
> +		return 0;
> +	}
> +};

Please leave out "default: return 0;" from the switch statement and add 
"return 0;" after the switch statement. That will make the compiler emit 
a warning if a value is added in enum pr_type but not in the above function.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

