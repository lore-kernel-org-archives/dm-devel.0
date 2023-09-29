Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE8EE728DA
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696015692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=k42iZmreJQ9IylmQP5hrqaWAbul3vKQQND0Gr1jou2Q=;
	b=gYOS2Pwt9PEuv8lEDeBSN51XOpJuAG5RKryfI9UT4rhAXMMcEtks0cpY1quYX1+lB4PE7T
	xarUM2eeeqH4t2HkG85RRTQidUhtCo0KRdGV3Ye5huxqEZwyF4SHy8t2UesYeNGrZ1v4V3
	I9dEV7KP127DYe5QIyzqqFZQfnjPxv8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-dHa9YxVQO66vZb84onhH1Q-1; Fri, 29 Sep 2023 15:28:08 -0400
X-MC-Unique: dHa9YxVQO66vZb84onhH1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFC443816CA0;
	Fri, 29 Sep 2023 19:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 669072156702;
	Fri, 29 Sep 2023 19:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E7A81946588;
	Fri, 29 Sep 2023 19:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A5E71946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 19:21:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E286C400E89; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAB9D492B16
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B85AB85A5BA
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-S6DiMW77N2mfXiWtMUilPg-1; Fri, 29 Sep 2023 15:21:17 -0400
X-MC-Unique: S6DiMW77N2mfXiWtMUilPg-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-690ba63891dso11500304b3a.2
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 12:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696015276; x=1696620076;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=J+JwqsH6QF4VOv5yHrt+J+oPhRZNhTjhOsyT6TXu7Bw=;
 b=K4bS5wkACoJZ5DghOI8wTsoVUY0Syu4ZB8J6NDFziMd1Q7mSzt1MPR9fw5mSyH2Aks
 hgmTEdQMqrwms/6AxEfAIusIdTd3brNT8K+Cn4TgRo+npwePjp9p13Xc33RPGjQjV7h+
 jXC0bFXD15mSDVQfjn4LbUUO0tawOrBwBTjJT3Iu+x2Q6cmCM1SUTpB0K4AgH6F80cYr
 /rjHHA3rfkumxTEO+Y5wy3PZ8i3/fdQJp03sI9yeV4/duDWHjH87UntgTEdD+FVhOwMe
 1Q5YHw3wNWf+dt8la80CWTrUJwHR023TBuC4g/TwVdjEzMHTDpHYscdICVUhygvbxf8O
 NbWA==
X-Gm-Message-State: AOJu0YzdrLe9nKSB/bKsnkqLoTvH4s0S9XMWhQa0uKEnJiZuu/cGyf37
 hBwrZgJD6OS0d1d8yfxKRvOiXQ==
X-Google-Smtp-Source: AGHT+IEgcLkzDCaWGmIBtqvOf11K/aas1RfwhznJoxkvK95mk2Nx5WuE98B3wrHbauF8RteAbPkdwA==
X-Received: by 2002:a05:6a20:8f02:b0:140:730b:4b3f with SMTP id
 b2-20020a056a208f0200b00140730b4b3fmr6546747pzk.1.1696015276710; 
 Fri, 29 Sep 2023 12:21:16 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 s26-20020aa78d5a000000b00672ea40b8a9sm15729140pfe.170.2023.09.29.12.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Sep 2023 12:21:13 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
Date: Fri, 29 Sep 2023 12:21:04 -0700
Message-Id: <169601526975.3013632.10720424703998827212.b4-ty@chromium.org>
In-Reply-To: <20230915200400.never.585-kees@kernel.org>
References: <20230915200400.never.585-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] dm: Annotate struct dm_stat with __counted_by
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
Cc: Mike Snitzer <snitzer@kernel.org>, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, dm-devel@redhat.com,
 linux-hardening@vger.kernel.org, Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 13:04:01 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct dm_stat.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm: Annotate struct dm_stat with __counted_by
      https://git.kernel.org/kees/c/e9d842d479ac

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

