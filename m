Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9910C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3287761130
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3287761130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-P-b-ZXAPOXW980bWFzeGZA-1; Thu, 16 Sep 2021 02:50:15 -0400
X-MC-Unique: P-b-ZXAPOXW980bWFzeGZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E2B610144F1;
	Thu, 16 Sep 2021 06:50:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E736F5C1C5;
	Thu, 16 Sep 2021 06:50:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B74571803B30;
	Thu, 16 Sep 2021 06:50:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18E94xiX018012 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Sep 2021 05:05:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D88C0202F30E; Tue, 14 Sep 2021 09:04:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E5B202F30C
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 09:04:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B37508934EB
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 09:04:55 +0000 (UTC)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
	[209.85.167.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-406-UVCQD6dTOx-dZMx50TZdmA-1; Tue, 14 Sep 2021 05:04:53 -0400
X-MC-Unique: UVCQD6dTOx-dZMx50TZdmA-1
Received: by mail-lf1-f48.google.com with SMTP id bq5so27283744lfb.9
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 02:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=TxkMbPDfFbLZj7gS8lbkBILCw0qzdwhInbM9Rl7jN2Y=;
	b=LP7atr6fvbhY5b/hziuCZpM2/hW9Sf1wkRH6MgHyxFYKN43Lib+E8uqN7s6tSqWyPR
	lIs4OzkW4tRs7OwRTfd0W7hO1D1s1Cty6FQS4rbUybMQ5Q1niGizsMHraDNdvZIWIYWn
	GGKfsA+EfNLT1HdqCJLXWdAc3R2214vGIvr03Hp+F7h3KJ7QZ/xVV/l+bLcddwqiy5qL
	oAisMMW9Oo6Vwn99WGSu/9rGreazxm6jFOCECcuq3pK9X1eUb7GOpqPJbgDb79UF2jkH
	G3ae89e0mTMdGnqelEk6MpzRlzgRkH0B+87HTD75Pjq40HxYYyONturjZL5ownVaoum+
	ii8w==
X-Gm-Message-State: AOAM533BXxu7HgoCQbebB+uaPmyo8QGLkKOcDC6NzX02VH0+Y1aTtd0e
	5QzKT8oLcTAFsHBwJ0tFw4+Rr9jV9GCAqL7ARsiSjQ==
X-Google-Smtp-Source: ABdhPJxmtEn3tJSHkFDVGWx0SpxzVkHAAASInKwE013atEj5O0Z9owxq78OkTQeJkvm7QK88xVAWDaZ3LFcJNo3racU=
X-Received: by 2002:a05:6512:3ca5:: with SMTP id
	h37mr12218278lfv.254.1631610292303; 
	Tue, 14 Sep 2021 02:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210913013135.102404-1-ebiggers@kernel.org>
	<20210913013135.102404-4-ebiggers@kernel.org>
In-Reply-To: <20210913013135.102404-4-ebiggers@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 14 Sep 2021 11:04:16 +0200
Message-ID: <CAPDyKFqEmhwT0v8ZWM9ByOSoVPYM62mi4zjDTG9J1bD40_Zfyg@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 16 Sep 2021 02:50:07 -0400
Cc: linux-block <linux-block@vger.kernel.org>,
	Satya Tangirala <satyaprateek2357@gmail.com>,
	dm-devel@redhat.com, linux-mmc <linux-mmc@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 3/5] blk-crypto: rename keyslot-manager files
	to blk-crypto-profile
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 13 Sept 2021 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> In preparation for renaming struct blk_keyslot_manager to struct
> blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
> source files.  Renaming these files separately before making a lot of
> changes to their contents makes it easier for git to understand that
> they were renamed.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/Makefile                                            | 2 +-
>  block/blk-crypto-fallback.c                               | 2 +-
>  block/{keyslot-manager.c => blk-crypto-profile.c}         | 2 +-
>  block/blk-crypto.c                                        | 2 +-
>  drivers/md/dm-core.h                                      | 2 +-
>  drivers/md/dm.c                                           | 2 +-
>  drivers/mmc/host/cqhci-crypto.c                           | 2 +-
>  drivers/scsi/ufs/ufshcd.h                                 | 2 +-
>  include/linux/{keyslot-manager.h => blk-crypto-profile.h} | 0
>  include/linux/mmc/host.h                                  | 2 +-
>  10 files changed, 9 insertions(+), 9 deletions(-)
>  rename block/{keyslot-manager.c => blk-crypto-profile.c} (99%)
>  rename include/linux/{keyslot-manager.h => blk-crypto-profile.h} (100%)

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

[...]

Kind regards
Uffe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

