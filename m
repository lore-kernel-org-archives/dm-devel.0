Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B513E49B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8utzBky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698182358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0bKh+O/PANGlG/qak+LU04NiuPPv63eV7oLEVO+FPPs=;
	b=N8utzBkyNRZIaKKexarqJq3gbZm0wYA94Z5MUIaDaGybo0j3OCkIyDsnxQBOIgEZX2UDvz
	aqmkCEEdv6fcUAyz+CAXZ5FVUkXZNboLgnMAswB8sh6js6pcZT4bypieXkCL0ZRvz7RaD8
	lv2/x5d6XJ0ByVIbboiZx3fXy4UmWqI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-XrTSwKZLPTuzLLB_42Oeeg-1; Tue,
 24 Oct 2023 17:19:17 -0400
X-MC-Unique: XrTSwKZLPTuzLLB_42Oeeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4019528088A3
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 360C425C0
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 068F91946595
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:19:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 845A31946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 21:19:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 726E7C15BBC; Tue, 24 Oct 2023 21:19:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B065C15BB8
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:16 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ADEA101A590
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 21:19:16 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-3cWeeKLKNWazHkT_e7rYLA-1; Tue, 24 Oct 2023 17:19:09 -0400
X-MC-Unique: 3cWeeKLKNWazHkT_e7rYLA-1
Received: by mail-pf1-f179.google.com with SMTP id
 d2e1a72fcca58-6bd32d1a040so4913873b3a.3
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 14:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698182348; x=1698787148;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=0bKh+O/PANGlG/qak+LU04NiuPPv63eV7oLEVO+FPPs=;
 b=Wnw7Aw1OfsKu5/MH2drg6IxMcFP6j8yylwH3/dG+ESo1SXg27W/WtbDlYAKGmkYdso
 GvEbDhRwQWfpGUuCvhSVZLa7aaIw0D6KXF09j/LLqBvpiO4bm2jUs3v0jjS7khjOoK8S
 7xFHQzZqs2OlB5rPJDKh/favjkWGwoQWc/nlJfFfB9eRTXH/NZR56yKW4aNUkcubV9mr
 mkmxUhzBv7ZSh8g3j3IIOTgLJqe3uuWIzwUZHca0tZgENxJv1JKJPXBtOW9SoNc+Qli3
 vnQs7g9hp3eIqIonPMpjGPKU78nPpAcOM/LDmUVooou+F0ZEF/NMrzYoGhEnX41Du2ND
 dKtg==
X-Gm-Message-State: AOJu0YxXx7I2qShngrYZ4jyVvZijVD0SKFpdZhmdfOAus5dbPhV7we2N
 97Hwbt+alkWvfP5r9Aazxhr5Yg==
X-Google-Smtp-Source: AGHT+IHGLGRzlzjxbgpZEoNG6Q70od6GIZtk0kPFMN0s5WSitO5/SXqI8s8n50J7L7IYCLKn2sbH3Q==
X-Received: by 2002:a05:6a20:3951:b0:16b:79b3:2285 with SMTP id
 r17-20020a056a20395100b0016b79b32285mr4216060pzg.56.1698182348320; 
 Tue, 24 Oct 2023 14:19:08 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 g12-20020aa79dcc000000b006b24b99afd4sm8349691pfq.176.2023.10.24.14.19.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Oct 2023 14:19:04 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] dm ioctl: replace deprecated strncpy with strscpy_pad
Date: Tue, 24 Oct 2023 14:18:51 -0700
Message-Id: <169818232969.2100071.3919289615593947459.b4-ty@chromium.org>
In-Reply-To: <20230925-strncpy-drivers-md-dm-ioctl-c-v1-1-f0bfa093ef14@google.com>
References: <20230925-strncpy-drivers-md-dm-ioctl-c-v1-1-f0bfa093ef14@google.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 25 Sep 2023 06:54:51 +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect `spec->target_type` to be NUL-terminated based on its use with
> a format string after `dm_table_add_target()` is called
> | 	r = dm_table_add_target(table, spec->target_type,
> | 				(sector_t) spec->sector_start,
> | 				(sector_t) spec->length,
> | 				target_params);
> ... wherein `spec->target_type` is passed as parameter `type` and later
> printed with DMERR:
> |       DMERR("%s: %s: unknown target type", dm_device_name(t->md), type);
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm ioctl: replace deprecated strncpy with strscpy_pad
      https://git.kernel.org/kees/c/0f3f34ea3798

Take care,

-- 
Kees Cook

