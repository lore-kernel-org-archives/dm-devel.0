Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FB0C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:47:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 830BD23B01
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:47:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 830BD23B01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-zS-g3NGsOxyego9TnyiQlQ-1; Fri, 18 Dec 2020 17:47:28 -0500
X-MC-Unique: zS-g3NGsOxyego9TnyiQlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBC1F800D53;
	Fri, 18 Dec 2020 22:47:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F3665C1C5;
	Fri, 18 Dec 2020 22:47:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B8E24BB7B;
	Fri, 18 Dec 2020 22:47:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIMhpc8024870 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 17:43:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C73B2F49D7; Fri, 18 Dec 2020 22:43:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1E03F49BF
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:43:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BEC0101A53F
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:43:49 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
	[209.85.221.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-409-3gbSm3-iPkC66BudzJDtPQ-1; Fri, 18 Dec 2020 17:43:45 -0500
X-MC-Unique: 3gbSm3-iPkC66BudzJDtPQ-1
Received: by mail-wr1-f44.google.com with SMTP id d26so3958199wrb.12;
	Fri, 18 Dec 2020 14:43:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=MrGKmwqUEviRSkqehV1YzgXyN5b/wbbT2owGg4JJO5w=;
	b=GSHEEmhvgdLvtLFqrlrOYMZRex4Ti++rby0doEW/8l4Qdb9Qd2Irw9+9HKlt3T3Ris
	sA+xEEZ6ImU7byd9rxVYquJeGJv33zKeztDzoG2mRMvCmPW9+ww35KP1L7xBqfoS7aEH
	wpja14ElEWF9Z70EKitEDVdMjo1nqV/asLCbtogC4rWnRyeArkLiKQEAjZU+A4vA7aTd
	QHuU8Kgr5+dFSHOvy/dVCsnFyqJqxkGKClHotduntKxG1RoBd/sgpCNZQtIcM5B9CpTY
	4RBsBo1deFpz1H7z+sSQI4SUazT1f1PVzA7wyF5NRD/N5NIH9WwAsAcxo4ai7afMbkvD
	wbeA==
X-Gm-Message-State: AOAM531yUMOPLLal1NGsuut7OJ/aLlZ2TkOnCdZmvCf1DQ0nchC05tb5
	hOwBNZzR+vz8VC2r5O7tyQmoKJIaqY6W
X-Google-Smtp-Source: ABdhPJyd24y0BmxgyqhAvoZzCaYdDEf9COeBy4/WQJjUZGq4fPf09UW5Gc51Oov7DHgvCLBJpVOQww==
X-Received: by 2002:a5d:558a:: with SMTP id i10mr6779409wrv.363.1608331423728; 
	Fri, 18 Dec 2020 14:43:43 -0800 (PST)
Received: from localhost (242.red-95-127-155.staticip.rima-tde.net.
	[95.127.155.242]) by smtp.gmail.com with ESMTPSA id
	34sm15164935wrh.78.2020.12.18.14.43.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 18 Dec 2020 14:43:43 -0800 (PST)
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
References: <20201218223753.24451-1-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <bdf66e35-6d85-bb42-6b3e-2db2bbaf6053@gmail.com>
Date: Fri, 18 Dec 2020 23:43:41 +0100
MIME-Version: 1.0
In-Reply-To: <20201218223753.24451-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: fix format warning with clang
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/18/20 11:37 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> ---
>   libmultipath/log.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/log.c b/libmultipath/log.c
> index 6498c88..10fa32c 100644
> --- a/libmultipath/log.c
> +++ b/libmultipath/log.c
> @@ -125,6 +125,7 @@ void log_reset (char *program_name)
>   	pthread_cleanup_pop(1);
>   }
>   
> +__attribute__((format(printf, 2, 0)))
>   static int _log_enqueue(int prio, const char * fmt, va_list ap)
>   {
>   	int len, fwd;
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

