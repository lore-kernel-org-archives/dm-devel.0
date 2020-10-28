Return-Path: <SRS0=xCF1=ED=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10818C4363A
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 10:36:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4958E2468A
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 10:36:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4958E2468A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-bKeqDnA_O8-3isySpxfHUg-1; Wed, 28 Oct 2020 06:36:03 -0400
X-MC-Unique: bKeqDnA_O8-3isySpxfHUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE5541009E2E;
	Wed, 28 Oct 2020 10:35:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4876055762;
	Wed, 28 Oct 2020 10:35:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B73D181A870;
	Wed, 28 Oct 2020 10:35:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SANuD0029518 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 06:23:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3FD262156A4A; Wed, 28 Oct 2020 10:23:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC042156A3D
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 10:23:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17CB0811E83
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 10:23:53 +0000 (UTC)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
	[209.85.221.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-y3aWng_OOaOWBDT9ofnvVA-1; Wed, 28 Oct 2020 06:23:50 -0400
X-MC-Unique: y3aWng_OOaOWBDT9ofnvVA-1
Received: by mail-wr1-f68.google.com with SMTP id t9so5031448wrq.11;
	Wed, 28 Oct 2020 03:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=KkR6dg8+1PM+F82/X3tuQVUMuVO+D0KFNCuztaHsbUs=;
	b=Lc+w7FYlwIeEtpIsbY01+B9wVlZXO+gWqaJ7sI6z8xZ2fc84hIeLnlDQhK6sBWnv/8
	SngAO5PEXeEZ97Fs8rfAj/Rn6/67QOf0Q7MNy8ozkXDrntAi7OXAtLlCTkYEkVxizaY/
	7NTaMAttSCMnxq+CHJNTxKyozpoVjU2RQxZjUxuSvHbrlA5nwl5W2zN7LaQAbJ2PmpPB
	EQ+dllytMXdN+1r4eg3Jn+/FvJWJRRb2qu1F6olUthuPeeQpqKU3gUuVH5p5oR0lS/ex
	rX240A5STs8VrgrWx405vHc3Lyro+FKaZSQzy818xacXsef7x7/fGnnYiAvgSItkREMf
	Gjqg==
X-Gm-Message-State: AOAM531WVWiApSY+hfBUcVgUvVjI1GhzBqyvbiVI3YQAHjH893sVFl6D
	SXIOK2nohQ4pyzwCwCl9Do50ckxUqA==
X-Google-Smtp-Source: ABdhPJz5R7MTKoFnbHQ+zb2st+3jVtcN67Y6jmoy388NmOCvNF29aeJplrR5RSecrXTDyoasnDerSQ==
X-Received: by 2002:adf:fd8a:: with SMTP id d10mr7621608wrr.85.1603880629072; 
	Wed, 28 Oct 2020 03:23:49 -0700 (PDT)
Received: from localhost (95.red-95-127-150.staticip.rima-tde.net.
	[95.127.150.95]) by smtp.gmail.com with ESMTPSA id
	j13sm6314232wru.86.2020.10.28.03.23.48
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 28 Oct 2020 03:23:48 -0700 (PDT)
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
References: <20201027224536.11662-1-mwilck@suse.com>
	<20201027224536.11662-3-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <20518276-de6b-19de-e736-3e342e894a6a@gmail.com>
Date: Wed, 28 Oct 2020 11:23:47 +0100
MIME-Version: 1.0
In-Reply-To: <20201027224536.11662-3-mwilck@suse.com>
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
Subject: Re: [dm-devel] [PATCH 2/5] multipath-tools: fix -Wformat errors
	with musl libc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
> rlim_t type is different on musl libc. A cast to unsigned long
> should be fine. Also, in musl, pthread_t is a pointer.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> ---
>   libmultipath/util.c | 6 ++++--
>   multipathd/waiter.c | 2 +-
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 1dad90f..39ccace 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -378,11 +378,13 @@ void set_max_fds(rlim_t max_fds)
>   		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0) {
>   			condlog(0, "can't set open fds limit to "
>   				"%lu/%lu : %s",
> -				fd_limit.rlim_cur, fd_limit.rlim_max,
> +				(unsigned long)fd_limit.rlim_cur,
> +				(unsigned long)fd_limit.rlim_max,
>   				strerror(errno));
>   		} else {
>   			condlog(3, "set open fds limit to %lu/%lu",
> -				fd_limit.rlim_cur, fd_limit.rlim_max);
> +				(unsigned long)fd_limit.rlim_cur,
> +				(unsigned long)fd_limit.rlim_max);
>   		}
>   	}
>   }
> diff --git a/multipathd/waiter.c b/multipathd/waiter.c
> index 16fbdc8..3bc6980 100644
> --- a/multipathd/waiter.c
> +++ b/multipathd/waiter.c
> @@ -64,7 +64,7 @@ void stop_waiter_thread (struct multipath *mpp)
>   		return;
>   
>   	condlog(3, "%s: stop event checker thread (%lu)", mpp->alias,
> -		mpp->waiter);
> +		(unsigned long)mpp->waiter);
>   	thread = mpp->waiter;
>   	mpp->waiter = (pthread_t)0;
>   	pthread_cleanup_push(cleanup_lock, &waiter_lock);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

