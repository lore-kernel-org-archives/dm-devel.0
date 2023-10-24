Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A9B3F4A8
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UwzqJf6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698182358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UDKEq+UzkLbktaOBRai2+Qm6LcjSkYjkBAqlnZqYEVI=;
	b=UwzqJf6pzDBYz0lWJYBtAUrRUdHBfMQ8AdzmjwGAJaThB0FpuZOahge4aVyJ4HuXGDPg26
	pmdxjIiZuTgpyW42X2QUCskVvx2t/FHgugKqQdwPHqjvSzwhOpAo33j5Op0Ooe292nDuc8
	yHseukpjGq/UEmJbMKd+SjYxmCzxlKY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-OHS3gMJ_OI-MGK32kw63rA-1; Tue, 24 Oct 2023 17:19:17 -0400
X-MC-Unique: OHS3gMJ_OI-MGK32kw63rA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70F5688D185
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6996D2166B26
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14D8A19465A0
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D4421946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2759140C6F7B; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2072C40C6F79
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:15 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB65E800CAA
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:14 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-_p-rahaVNyGJF1J8cIwdjg-1; Tue, 24 Oct 2023 17:19:08 -0400
X-MC-Unique: _p-rahaVNyGJF1J8cIwdjg-1
Received: by mail-pf1-f177.google.com with SMTP id
 d2e1a72fcca58-6b77ab73c6fso165069b3a.1
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 14:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698182347; x=1698787147;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=UDKEq+UzkLbktaOBRai2+Qm6LcjSkYjkBAqlnZqYEVI=;
 b=XNZxdJEdUnEvYVrzknWrQ8nlrsSTJngqtJr6v8ATxsd9wklCCCFcz1Gn6GDb2HsGlh
 +vYpVtglq2HcEBdkHiIwIFcsfU2q5AWQ/mUdTcAGXDK74eRrM2gZ8M7iq3T2IGX02Sed
 nJLCRktU0kGuWRZlswq6T0J2N5RRh6VbKVB8s1sJMxnNoFaMfDG1EzOqkOR3tdx96EjZ
 hrm2QMIOK4CBhnfPE52AxRvn0ONxNo0Z7uw35zQS4GykDT1/girxAtrbduSEmzIhlN84
 ulq6Tf69NCidU5N/havDME1I4e9HgB74MZfIVWgGpPixPA6Zb3/vSESpA32e/RF38Wwb
 V8AQ==
X-Gm-Message-State: AOJu0YxmmAbpQc2Ut1Hhd9l3i32sz3oqwKfoeeCwoy1W46C1sjuIldSy
 AnNBARW/n4ygJMvavEuJbl+hWQ==
X-Google-Smtp-Source: AGHT+IEvp8+akJziYautCeWt0MqbrrbJAP2OWIZTlVnOA+AA8K+nsGqzNoYKMslhlIfV7znTpZ+few==
X-Received: by 2002:a05:6a00:1d11:b0:6b3:80f8:7e91 with SMTP id
 a17-20020a056a001d1100b006b380f87e91mr21893779pfx.9.1698182346679; 
 Tue, 24 Oct 2023 14:19:06 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 fa36-20020a056a002d2400b0069309cbc220sm7994225pfb.121.2023.10.24.14.19.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Oct 2023 14:19:04 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] dm cache metadata: replace deprecated strncpy with strscpy
Date: Tue, 24 Oct 2023 14:18:49 -0700
Message-Id: <169818232968.2100071.6650937049148310025.b4-ty@chromium.org>
In-Reply-To: <20230925-strncpy-drivers-md-dm-cache-metadata-c-v1-1-4b75c7db0cfe@google.com>
References: <20230925-strncpy-drivers-md-dm-cache-metadata-c-v1-1-4b75c7db0cfe@google.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 25 Sep 2023 06:13:12 +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> It seems `cmd->policy_name` is intended to be NUL-terminated based on a
> now changed line of code from Commit (c6b4fcbad044e6ff "dm: add cache
> target"):
> |       if (strcmp(cmd->policy_name, policy_name)) { // ...
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm cache metadata: replace deprecated strncpy with strscpy
      https://git.kernel.org/kees/c/5d9bc443188f

Take care,

-- 
Kees Cook

