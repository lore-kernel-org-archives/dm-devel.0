Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0BBEB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687474261;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zaqhAnsQiBJnSMDYx3xr/Ogk9U+LxHtl7Tjyy10NCWg=;
	b=Dwl74bkj2xTm7pu5gbt0TcYXr3BuaCUwGzGLPX1iEaajnR/32ZVS0pqTcABRx27CzNzg1r
	/NHNLOYXjuK5Q6owNWVoLK85xyrlAtF0HHH+dkeQ60FFQ2LvuRy9v3bB9ocf7gvunG2k3u
	l/cJWwdVSjcrwYVOwt6EvUSkfxPJjdY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-9FhGRDNyNsOX95oTkzz-0w-1; Thu, 22 Jun 2023 18:50:58 -0400
X-MC-Unique: 9FhGRDNyNsOX95oTkzz-0w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61C67185A792;
	Thu, 22 Jun 2023 22:50:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 70952492C13;
	Thu, 22 Jun 2023 22:50:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26B341946588;
	Thu, 22 Jun 2023 22:50:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B40FD1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 22:50:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ABDEC1ED97; Thu, 22 Jun 2023 22:50:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92C96C478C9
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 22:50:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EBDB101A528
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 22:50:41 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-Aq5ua0ZCOV2oiJCIQhhRvg-1; Thu, 22 Jun 2023 18:50:37 -0400
X-MC-Unique: Aq5ua0ZCOV2oiJCIQhhRvg-1
Received: by mail-qv1-f50.google.com with SMTP id
 6a1803df08f44-62ffe4cabc0so249826d6.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 15:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687474237; x=1690066237;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9x9QfSSVUpTeAWdqCixUHSwi7foPPLLpLOSUdEXv8WE=;
 b=Vwu/tB8AAg/birdiVktyshHSilLPwCUkHfb2+4i23R9ccRqFMaiGmUpoSdJ7Qr5/U+
 cCcLoWARs2Xo5sQLB5j58B/Iab1uSnrcPH5LuR2YomgWvqT0HwW+66vNo9RajDDx9EkB
 srtPMldeYJRkM/pgI5OGEMxVoj/iw3d7HHeJK5Ldur3kZZwrD29YQ7h3e3tUotypk/Kg
 lZ6VzISJmBgPnA4QF56s5xpSO9AGMsvkary7g0ZB7hkKtQXj/hODZ7Ov3YYYy+J7pKuh
 GfYfvjz3bEy64Dw2ZdzK/xPA4ujmi5JmoRx0yxrVODGFz9gMJRBA3qGK2QHQKWijt160
 IS+g==
X-Gm-Message-State: AC+VfDxV+audJssjoe1CYK5pnqONYohOLBVI4gbyrvt8ymVSL69PAXiq
 RclCKgi/JSoWWWGgO0O9WinQrU1QdRUvirG4shIE
X-Google-Smtp-Source: ACHHUZ5wU337FIxFIJZQbmKE670bOEaoz4yGFxNkDChOmuLZrnAXBAhPW8u4+uoVVHUQbDgFJVqDGA==
X-Received: by 2002:a05:6214:20ae:b0:62f:fe87:67e9 with SMTP id
 14-20020a05621420ae00b0062ffe8767e9mr21122003qvd.44.1687474237072; 
 Thu, 22 Jun 2023 15:50:37 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i20-20020a0cf394000000b0063013c621fasm4263594qvk.68.2023.06.22.15.50.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 15:50:36 -0700 (PDT)
Date: Thu, 22 Jun 2023 18:50:35 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZJTQO5sk3ugSrXjz@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-3-demi@invisiblethingslab.com>
MIME-Version: 1.0
In-Reply-To: <20230603145244.1538-3-demi@invisiblethingslab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 2/6] device-mapper: Avoid pointer
 arithmetic overflow
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03 2023 at 10:52P -0400,
Demi Marie Obenour <demi@invisiblethingslab.com> wrote:

> Especially on 32-bit systems, it is possible for the pointer arithmetic
> to overflow and cause a userspace pointer to be dereferenced in the
> kernel.
> 
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-ioctl.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 34fa74c6a70db8aa67aaba3f6a2fc4f38ef736bc..64e8f16d344c47057de5e2d29e3d63202197dca0 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1396,6 +1396,25 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  {
>  	static_assert(_Alignof(struct dm_target_spec) <= 8,
>  		      "struct dm_target_spec has excessive alignment requirements");
> +	static_assert(offsetof(struct dm_ioctl, data) >= sizeof(struct dm_target_spec),
> +		      "struct dm_target_spec too big");

I'm struggling to see the point for this compile-time check?
Especially when you consider (on x86_64):

sizeof(struct dm_target_spec) = 40
offsetof(struct dm_ioctl, data) = 305

Just feels like there is no utility offered by adding this check.

SO I've dropped it.  But if you feel there is some inherent value
please let me know.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

