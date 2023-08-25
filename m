Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE1BC83F06
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 23:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693004903;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KUOjHM4p56XPVO9HsrPM5mID19YAjK9lCDoB2VwgpMQ=;
	b=XG0Zziem0x6xoVnWf1dJFjlz//tFCktc1p0soLKns0BKQ1T4VHYQYAGYaOamjqTRc5cF/r
	k2dBeYwZw3CrNE6WXOMNKL9cHXHyfFxjXi4WmPlNrPMOjWA1r+iNxeIFgjwgCa4TQb8nCN
	OxtMjvZRFpO9GJ8+By9zcYIZjAUl7Mo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-mKVZB8b4Nu60rKvD3VRhoQ-1; Fri, 25 Aug 2023 19:08:20 -0400
X-MC-Unique: mKVZB8b4Nu60rKvD3VRhoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53B98185A7A3;
	Fri, 25 Aug 2023 23:08:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B933140E950;
	Fri, 25 Aug 2023 23:08:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2893B19465B1;
	Fri, 25 Aug 2023 23:08:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 991F719465A8
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 23:08:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60F32C0177B; Fri, 25 Aug 2023 23:08:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5958CC09A11
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 23:08:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 278D285CBE0
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 23:08:11 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-QQwO3BOVOcKSAu5nrwKVSA-1; Fri, 25 Aug 2023 19:08:07 -0400
X-MC-Unique: QQwO3BOVOcKSAu5nrwKVSA-1
Received: by mail-pf1-f181.google.com with SMTP id
 d2e1a72fcca58-68c0d262933so762305b3a.0
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 16:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1693004886; x=1693609686;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BGD8RLBqVNB4kmg9LQj/IaQhfmnGQcki3nbsh7hZk+8=;
 b=KRE+6R+k2ngS2VQmMXivq4jgxHpd2vS9buKp050Eo7aSM6Qo1ItAmCSyhGV1E7jtct
 jGxfmPzqd81MsrHjDWK2eFLErcN/jupbBWsu94ussDH1AIRjJbh7D/4OItyoNLD6P9tn
 XbCrVMuDUm3j72Wm83kHc2XeL4dsjlIi1Y7oAReq9mtL4td0zIdTOM3M+b+onO8IpLBz
 AsVdX6sS1rIhqOjcm/ZOdeigZ0E0X6qiSyU9VHdCIQ1J/eEMl781je09ZdcrvaFlGwiT
 j5kqxMGi1+vOC/725Ileioy4Zodq2fpsvqQlIJeKUepQ5zzehqN6fHAGXvW4aUN2fRTu
 S7iw==
X-Gm-Message-State: AOJu0YyGMSgaEprW8svL5gut5F/NTGjFPznbTXjEbMhq4EhaPzKt8sQO
 uXvpJ3orqKfSAbmQeme7AJmkNg==
X-Google-Smtp-Source: AGHT+IFe1hAe7Lf6wq0l2606gcJN8yUb28I3sQVbEpzoh4vKFlqBPpa+9BRdxsU4JtNnzCmulUYBcg==
X-Received: by 2002:a05:6a20:6a05:b0:130:7803:5843 with SMTP id
 p5-20020a056a206a0500b0013078035843mr21060026pzk.4.1693004885827; 
 Fri, 25 Aug 2023 16:08:05 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 ff5-20020a056a002f4500b006877b0b31c2sm2134013pfb.147.2023.08.25.16.08.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Aug 2023 16:08:05 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Date: Fri, 25 Aug 2023 16:08:00 -0700
Message-Id: <169300487782.1491255.12127882114694944126.b4-ty@chromium.org>
In-Reply-To: <20230817235955.never.762-kees@kernel.org>
References: <20230817235955.never.762-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] LoadPin: Annotate struct
 dm_verity_loadpin_trusted_root_digest with __counted_by
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
Cc: linux-security-module@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
 Nick Desaulniers <ndesaulniers@google.com>, llvm@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 dm-devel@redhat.com, Tom Rix <trix@redhat.com>,
 Alasdair Kergon <agk@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 17 Aug 2023 16:59:56 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct dm_verity_loadpin_trusted_root_digest.
> Additionally, since the element count member must be set before accessing
> the annotated flexible array member, move its initialization earlier.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] LoadPin: Annotate struct dm_verity_loadpin_trusted_root_digest with __counted_by
      https://git.kernel.org/kees/c/5f536ac6a5a7

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

