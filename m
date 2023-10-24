Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA53F4A8
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMT+NvPl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698182367;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z44BPeMtE2kACzCzizrt3sSV/gaHEispvl8DNfLTFYw=;
	b=OMT+NvPlKPHGZSk5Ms+wajZVeTuiaOugxmTp9UO7VqpDPLRsHKIE1wA3F1w9EJmQSpJ0vb
	mefzn9WhNeNiR9w4ZJpe5oJZGRYfCvVfkGNIBgxpLqAmuVWIUOt0ZHXL/SiiBc6Jqpp/VT
	xxIRmhm9EAboU2Tawx8mTyHnx+/5wXo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-GmJTuPvdOPGF5Drk99mRrg-1; Tue,
 24 Oct 2023 17:19:21 -0400
X-MC-Unique: GmJTuPvdOPGF5Drk99mRrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 686F629AA389
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F76CC15BB8
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0FD13194658C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D42CE1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C63988C0A; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A7E11120F
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 653AA28088A4
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-1x81cpzqPI-Ysz0NsJYvgQ-1; Tue, 24 Oct 2023 17:19:06 -0400
X-MC-Unique: 1x81cpzqPI-Ysz0NsJYvgQ-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-6bb4abb8100so4075508b3a.2
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 14:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698182345; x=1698787145;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=z44BPeMtE2kACzCzizrt3sSV/gaHEispvl8DNfLTFYw=;
 b=rBRPcgTHcOh1nX+DJlpknRcSMrv3Gqmsr5EFvp7QjuRQQZ6gBtzENoa/rxHjMAQfU6
 9kuauJ1f8bDWv3zrJ13TkqDe/QNWHuMyZ+/h4r1TA+p288Liv1qEcpkI2IFfjtu+p9eG
 I5SU0vXD273CWBN5ZdG4ZjCgcDqfATi2NtUPAnpcPlERxpXQjOwkoKZSnmLNcAdHogD8
 JbHG+oY3I2GxGzfkw0APWUtFd+wyXkyAXhZDXCv397KpP4JvuI9XtDq6Jbrq4RuwpiPG
 nD7ypg5K61zhHoURz9EOG+xVU40ruC8oItdVvS6Qybv/kN1BnL/hNNws39+l0eg+V/ZW
 fAXg==
X-Gm-Message-State: AOJu0Yz5LZtrB2kLUCNscOA+AOOvxnfFVj38lIehixxDFbbr29VonsbP
 2TQLn4Cv7BLJdUdyqU4ojmUhEQ==
X-Google-Smtp-Source: AGHT+IExcAVhyp7VZm2kE7JqtYW/LVhoC5XB1bnP/53gqyGSRDMgUiZJp81JNdO0o7sPap5EOURDnA==
X-Received: by 2002:a05:6a00:1595:b0:6be:22db:7a13 with SMTP id
 u21-20020a056a00159500b006be22db7a13mr11429436pfk.25.1698182345417; 
 Tue, 24 Oct 2023 14:19:05 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 x12-20020aa79a4c000000b006bf536bcd23sm6081290pfj.161.2023.10.24.14.19.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Oct 2023 14:19:04 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] dm log userspace: replace deprecated strncpy with strscpy
Date: Tue, 24 Oct 2023 14:18:52 -0700
Message-Id: <169818232969.2100071.1483595444634836042.b4-ty@chromium.org>
In-Reply-To: <20230925-strncpy-drivers-md-dm-log-userspace-base-c-v1-1-030d7bcf1004@google.com>
References: <20230925-strncpy-drivers-md-dm-log-userspace-base-c-v1-1-030d7bcf1004@google.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
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

On Mon, 25 Sep 2023 07:06:03 +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> `lc` is already zero-allocated:
> |       lc = kzalloc(sizeof(*lc), GFP_KERNEL);
> ... as such, any future NUL-padding is superfluous.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm log userspace: replace deprecated strncpy with strscpy
      https://git.kernel.org/kees/c/f8cff5441800

Take care,

-- 
Kees Cook

