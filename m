Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E014AE728DE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696015738;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=doGrTHOcwVJwR5DpT0H4yP5GqWYQ0jlNVJ/beS8/+cw=;
	b=AEIIW5V3xWuRa1rlaGW8mfNqmooH1e7eF8M8+VjuktEDaeYA435UoUwzP5jaCn/gjrt2vA
	QRT6XKB9DffNgwR7NvgfRMX7hiBEci22c8U6f37ukfZBrqbrmPeZ1+yXj92l56hg3UdyxS
	4aXuqwCO93j5XC+A2n7TUFYQmvlzVRE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-WEvyNeJ6MPiR_20nwVeVFw-1; Fri, 29 Sep 2023 15:28:55 -0400
X-MC-Unique: WEvyNeJ6MPiR_20nwVeVFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0B35801779;
	Fri, 29 Sep 2023 19:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A83EC154CA;
	Fri, 29 Sep 2023 19:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59C7B1946587;
	Fri, 29 Sep 2023 19:28:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 132531946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 19:21:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05DD640C6EC1; Fri, 29 Sep 2023 19:21:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F311A40C6EBF
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC033382134F
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-9gB43Lf9OSKFV1wNJWkV0A-1; Fri, 29 Sep 2023 15:21:15 -0400
X-MC-Unique: 9gB43Lf9OSKFV1wNJWkV0A-1
Received: by mail-pl1-f171.google.com with SMTP id
 d9443c01a7336-1c364fb8a4cso130989705ad.1
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 12:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696015274; x=1696620074;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Lm/Ps7g202MOlVqh0mV3HRz4xTXb5X6yozpQbIPIl6I=;
 b=aeSp+i9A0/BVN/+Gg2gCJ0UhJ+aEMQJ6X2W7cdw0nq0gdODfwM03qQHciSV0eWtGyf
 AMCsiSg2EhTU4IUn2mgw2jnuKtpXUI/78MYH0+6xH7WGEoj5DORfKAKio3s4s00R8dt4
 5qKHuYYOLX0NunS8Cr+yK8bxSHFmsN57fG2D0F6UOv0zXGbZIjKeZ0E8HKlH1RGyIszU
 ILODVFGid8eKM9Q2DYZ23YtG8e36qLnrs8ym4CsZhc5k5bZdg2tvxPVMzq3RugN8eCM7
 gB+hcZuZzckoltp6MTfllROy89wCMC7RMO8DP+X8EemzZwc+YjZAsxYH6fNYiY/qIGfO
 WXgg==
X-Gm-Message-State: AOJu0Yy+s0IBejQXXHTOsBTRKMxLq173lL9tqUoijr+GuZZm+c5eegr/
 GNvBQADLVbBh1nclQgsZMSHdwA==
X-Google-Smtp-Source: AGHT+IHzxuvEn9JIX48urjncDPYH9dBw31tAucVspB19q62Zql14kwcg7Iwk6ubcIA4im2QxAPeqyA==
X-Received: by 2002:a17:903:230b:b0:1c3:4565:22f with SMTP id
 d11-20020a170903230b00b001c34565022fmr5848461plh.21.1696015274330; 
 Fri, 29 Sep 2023 12:21:14 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 je15-20020a170903264f00b001ab39cd875csm13499524plb.133.2023.09.29.12.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Sep 2023 12:21:13 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
Date: Fri, 29 Sep 2023 12:21:03 -0700
Message-Id: <169601526975.3013632.7773910905391133937.b4-ty@chromium.org>
In-Reply-To: <20230915200407.never.611-kees@kernel.org>
References: <20230915200407.never.611-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm: Annotate struct dm_bio_prison with
 __counted_by
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 13:04:08 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct dm_bio_prison.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm: Annotate struct dm_bio_prison with __counted_by
      https://git.kernel.org/kees/c/1eb1f6b6c911

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

