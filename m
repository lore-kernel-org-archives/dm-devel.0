Return-Path: <SRS0=xCF1=ED=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEE9C388F7
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 10:35:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 099142468A
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 10:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 099142468A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-ZfTpJn1qN9u7E9B4xRG46Q-1; Wed, 28 Oct 2020 06:35:33 -0400
X-MC-Unique: ZfTpJn1qN9u7E9B4xRG46Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFAD8805EFD;
	Wed, 28 Oct 2020 10:35:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8711E196FE;
	Wed, 28 Oct 2020 10:35:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CD73181A869;
	Wed, 28 Oct 2020 10:35:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SANSpk029447 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 06:23:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5E282156A4A; Wed, 28 Oct 2020 10:23:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D08662156A3D
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 10:23:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B475A8D632D
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 10:23:25 +0000 (UTC)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
	[209.85.221.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-467-oZzlLmKRNRmCDExVRDTAiw-1; Wed, 28 Oct 2020 06:23:21 -0400
X-MC-Unique: oZzlLmKRNRmCDExVRDTAiw-1
Received: by mail-wr1-f66.google.com with SMTP id t9so5029948wrq.11;
	Wed, 28 Oct 2020 03:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=LBskUMmkAqYfb1AlgUU4zcJ8qDMhBe8sz3ekvVwRQiI=;
	b=Ew87lq7KUWRL+WcTsTQA0mdXO8Ssjp2csbV2xZ1X7unqqfKOzJc1Q79jbXcb1IsIM8
	MA4UGkCIioWsNB0GdhqmpDb0joeLUID4gds7/ULSg+GfsPIOh5SxarH+LQcKZ3hwIP6b
	hQ2/koXIUKTjzuEH5nLqKmP48ei7pRuQLjaqOdYrMx5DlCKZbJDrXbH9lAEXIBFhZo6e
	MJs3F0zPGn1ezgBesUCfAnjyFfMvX34TvxlPbaNInYNGLVZbqb9R/sFbtfiY1jm0IGC+
	mz3+LBpDD3522Ge727/agI+elZzCBd85CO45HW+XuhTBdQoARp9JmH5gY/PXuW9uOKVL
	mgeQ==
X-Gm-Message-State: AOAM530K9LYjcw7GX4cuFjwu0gT56p2zQQyt/FMivYr8Ouw2++yFUXvD
	sVZL/MwghE8xKCuFVGHx1xF7D/ml6w==
X-Google-Smtp-Source: ABdhPJyzRkaK0GcZDzNTa22N2v5RQ0nOpjw8P1rgFxO08nBelR1lF/tA+02JZ5yfIdlHD5PLe1A7jQ==
X-Received: by 2002:adf:e446:: with SMTP id t6mr7631600wrm.46.1603880599777;
	Wed, 28 Oct 2020 03:23:19 -0700 (PDT)
Received: from localhost (95.red-95-127-150.staticip.rima-tde.net.
	[95.127.150.95]) by smtp.gmail.com with ESMTPSA id
	205sm5822256wme.38.2020.10.28.03.23.18
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 28 Oct 2020 03:23:19 -0700 (PDT)
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
References: <20201027224536.11662-1-mwilck@suse.com>
	<20201027224536.11662-2-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <40651e53-96db-abc1-f346-e9eceb39f214@gmail.com>
Date: Wed, 28 Oct 2020 11:23:17 +0100
MIME-Version: 1.0
In-Reply-To: <20201027224536.11662-2-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Leonardo Arena <rnalrd@alpinelinux.org>
Subject: Re: [dm-devel] [PATCH 1/5] libmultipath: make sure __GLIBC_PREREQ()
	is defined
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/27/20 11:45 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Otherwise complilation fails on non-glibc systems.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> ---
>   libmultipath/util.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index 0f0f6cb..2b9703a 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -55,6 +55,9 @@ struct scandir_result {
>   };
>   void free_scandir_result(struct scandir_result *);
>   
> +#ifndef __GLIBC_PREREQ
> +#define __GLIBC_PREREQ(x, y) 0
> +#endif
>   /*
>    * ffsll() is also available on glibc < 2.27 if _GNU_SOURCE is defined.
>    * But relying on that would require that every program using this header file
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

