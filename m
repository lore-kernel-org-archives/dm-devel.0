Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2C3E49D
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bFKHtlRm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698182358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nN6qLLiV1hMbAd2ABROBC8TqYl495gWbFutxERKWZ5Q=;
	b=bFKHtlRm0byknnrJzgv32JyUV+sXGUEm1XalUHQRaWoYcc5a7NF034LIowv6JLo8sG7waX
	vHI2lajsxejELN4ucFFAKpPviXG4nO51YgW7Rc+skiw/GWcYOke98Ph9Gnqo0y5kOaKt5m
	oKgB3Ej/YqeM3BBQtx2BLOYwEOaGLvs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-k_1vPxXjN5W8IfebWOhWJg-1; Tue, 24 Oct 2023 17:19:17 -0400
X-MC-Unique: k_1vPxXjN5W8IfebWOhWJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9BE185A782
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 356C1C15BBC
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE6A9194658C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F556194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C1F725C0; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35D9825C2
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1602B3C0D180
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-C0js7SlJMMGuN12HRNzQmA-1; Tue, 24 Oct 2023 17:19:08 -0400
X-MC-Unique: C0js7SlJMMGuN12HRNzQmA-1
Received: by mail-pf1-f169.google.com with SMTP id
 d2e1a72fcca58-6ba54c3ed97so4787584b3a.2
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 14:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698182347; x=1698787147;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nN6qLLiV1hMbAd2ABROBC8TqYl495gWbFutxERKWZ5Q=;
 b=kj08AEg4LkGK644Sx3Y7KYEnNxKIYvkOsB4ulTudtgZPuOW7T3wCcfALirjJysekHL
 Rq233aRnnikvBbpvWgR22A+qk4fOVvaq0qcNpupDDJXtmVB3gW/OyhOGVFbmGueCXtfK
 cpNaEgFvazXNRiiXUBdKH4Omk/jp2xrHWltXfteQabBFIxBVVBTKefC7AyRxYr+d1oyS
 DC8FpC8nyMI+rboS5EBRW6qXsQPTjupdhyPWVQnQ/GxnOwfW69eXHPrdzgKQHRV3egjR
 xNctJ85oSYmuMTMMLoOcJHN/DFwnO7oanc29gsC9w8X52gQed27rqudDKqWLweBIgmSK
 ZJ8w==
X-Gm-Message-State: AOJu0YyMBiaix1p/9CcxUkdsUcjD3BOkxbS79ysp8nyw5Y+roIJUzAC+
 SCXBrVu/J6F+5IxA0MH4wGFsrg==
X-Google-Smtp-Source: AGHT+IF34WCz22LleHdBIoXGoj6CerzAjgn+5ajfqq2LqtYNzNXC/G3yfQWrDrbHRch4V57IWmaAtg==
X-Received: by 2002:a05:6a21:7983:b0:170:3e5b:bccd with SMTP id
 bh3-20020a056a21798300b001703e5bbccdmr3039533pzc.30.1698182347115; 
 Tue, 24 Oct 2023 14:19:07 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 h29-20020a056a00001d00b0068fbaea118esm6013685pfk.45.2023.10.24.14.19.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Oct 2023 14:19:04 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] dm crypt: replace open-coded kmemdup_nul
Date: Tue, 24 Oct 2023 14:18:50 -0700
Message-Id: <169818232968.2100071.5806064081646325604.b4-ty@chromium.org>
In-Reply-To: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
References: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
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
Cc: linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 25 Sep 2023 06:35:54 +0000, Justin Stitt wrote:
> kzalloc() followed by strncpy() on an expected NUL-terminated string is
> just kmemdup_nul(). Let's simplify this code (while also dropping a
> deprecated strncpy() call [1]).
> 
> 

Applied to for-next/hardening, thanks!

[1/1] dm crypt: replace open-coded kmemdup_nul
      https://git.kernel.org/kees/c/17348b0a6a6d

Take care,

-- 
Kees Cook

