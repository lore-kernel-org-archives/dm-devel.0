Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98ACAC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 22:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667429651;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U/zJ0l2f6ZMUM4oyudWXvm9SdnBhqcR0g5Jk2gLpzUw=;
	b=EcjcKlAjNmlKsfSyPAqKcqinBgp4qgNg5qOQepY/Ez8WD7fXQ9UBqL/eVAwcDvRTPIQ5qv
	Wve6R/WODsqDHMbE5D/Ak/gyVhDz7DO3VRhRm8EfvXMpkjcLed466FN1HzdTs1b4H9HfEk
	vCsrb5lkgO9QfqFCH4e6bWXGkYR/THU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-ii7f6iiJPL6fyyPDXZGl7A-1; Wed, 02 Nov 2022 18:54:08 -0400
X-MC-Unique: ii7f6iiJPL6fyyPDXZGl7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E18B1C0759E;
	Wed,  2 Nov 2022 22:54:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D8EA39D6A;
	Wed,  2 Nov 2022 22:54:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3831419465A4;
	Wed,  2 Nov 2022 22:54:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6EEFE1946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 22:54:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE7D540C6E14; Wed,  2 Nov 2022 22:54:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6DFD40C6E17
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:54:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB9D229AB3E4
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 22:54:02 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-U2TylyENMFWzemVLRgtRDw-1; Wed, 02 Nov 2022 18:54:01 -0400
X-MC-Unique: U2TylyENMFWzemVLRgtRDw-1
Received: by mail-pj1-f51.google.com with SMTP id k5so10044863pjo.5
 for <dm-devel@redhat.com>; Wed, 02 Nov 2022 15:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=6sCkwj9YSprxNmaofEdMTvLEH5B6xW9TB9afqYojreE=;
 b=LDBkIaJbEJwxzdkxkNcuWa3wxb+PfPM2JcH8GysO1ydmcz0LYdWG1Evx7jGRo/IF9d
 GddBMwF5Iov9iafN31ETWa6HjiJdqwxcCFYAa6bNaISU8qQljKOZMn5dzC6DlZvZ/Dgd
 Mj+JrsthGb4L5QinSPCscuntIC4vXSoTEUHV94sQPxydrGDje0oOiOi+M3hau/xJJn95
 sMf1YoDqkqGs4CE5/STEgZBGhccStRiXXwEctEX3zl/9MduB/7j6n40sSKmXvPsYaFnp
 Ua1POxJRC8pSwRbySUCqcGnBp6nnhBcy/5oJy8OWvvHmCjK8vkoUutqNbiZgA7xouuj2
 +jCg==
X-Gm-Message-State: ACrzQf3TW5PNJzhhk5buvNx8fU4e1CpqRSj6jwL2Eys0GcpRuxEp9zkr
 XSjSkkmhagbiKGCZGvDQAnY=
X-Google-Smtp-Source: AMsMyM711K/XUrQHKPUtbBSxzz99QtzdPWA4ooVlF037LAOY+yPo/0v1VhBhBLoucp5Sp0Kf7/u28Q==
X-Received: by 2002:a17:902:ec86:b0:187:2430:d377 with SMTP id
 x6-20020a170902ec8600b001872430d377mr16640073plg.33.1667429640140; 
 Wed, 02 Nov 2022 15:54:00 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89?
 ([2620:15c:211:201:22d3:f380:fa84:4b89])
 by smtp.gmail.com with ESMTPSA id
 t4-20020a63f344000000b0046f8e444edfsm7630960pgj.60.2022.11.02.15.53.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Nov 2022 15:53:59 -0700 (PDT)
Message-ID: <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
Date: Wed, 2 Nov 2022 15:53:56 -0700
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Is my understanding correct that keys[] is treated as opaque data by the 
kernel? If so, is it necessary to convert the persistent reservation 
keys from big endian to CPU endianness? Some SCSI stacks keep 
reservation keys as __be64 format.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

