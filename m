Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A67C147
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746800510; cv=none; b=CoW5sLMfoTjnUnnwAGFO/jntLYxT29D35U0shUuiRlQZDgUMJF2IMiuBtAjs9qxltevsFyrCdvNipT0vXMNVxJP5H6sX1L+4z6WKZqX9uooNR8SPlN7UeEMCqkLbvCAjbCCqPiR2Hb0JhZLlL8Hjybk8QHzw3zSeQ1HD6z1l3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746800510; c=relaxed/simple;
	bh=HG5XWy2QSE8H0hED1X+lQVvuyTqUxO6GgLVmdg/yJz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lt52e2YLA8E7fe3NUDF6zJvTpsa8kB7umHavbmYjp/3pHTcCFWt+PAFhhg6nhS+uffEd+xCADGj4HTjS1yrBz2Z980ASIZ+Duilt0bPydSH6NZaTfd4CaBgKxBPpg3Fg+MD0THPrbvGTDDDBYGWy75HywnZPCcA+Y6nmr9+1wXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUVFxBLL; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUVFxBLL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a0b0d8090dso264021f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 09 May 2025 07:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746800507; x=1747405307; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6SnHVocx3V6mX0KxG1G06onTTP4CMdl3FYLuqLMdDE=;
        b=RUVFxBLLYUQGhgeupeaGqSvKdrmVuKhbM3dzFg7Domcn/R9pfyPaeMf332hfuh/x1d
         avkcbtUqmVIyPiVMu67JfbMhQ4NdW3Ntl3o8yW1B1xvCzNCvX9u5HB95VE9zzunQXLDH
         XwyZI1V1PYU7tYoZdjSbTQqKQBrW8Kmey6lMpb1OyOsTlF/Scf5BV7K+kuqQTcO3Dmct
         fJHaKklwnhjY7fbBLc9/85FUwCnMVCNgdzKq5Bdozyu5Apjp7Iv5t9rrQ9JhTPNE9mXE
         EndGdTfntDwGxFjpxsiVbHTz8zbVY9swqE+isX84fqzT74/8arj2YQeeqpLIG7+xTJHl
         gQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746800507; x=1747405307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T6SnHVocx3V6mX0KxG1G06onTTP4CMdl3FYLuqLMdDE=;
        b=oqH+5CrlfxdCU2WaJ+NqlMexRwcKa7cF2jjnahrYMvCFoAPK64ZBcmAP4Xz/lN6kBP
         +PecpCtwh1A/3WjnogrbiR9bxJauGbAtGhgp1xzL7Rngy9t4xzXle6kBN8afxIncpSJf
         HVEOY61k2Ut5X9I9HeOA0oaP9+RXMzAPXFbwvAVd5cXhXXuqUf2SsgsF8xK95pHLtlNb
         CChPJ+mQVfyVsp8821Y95twzHnlp0agZKa8LWD3ERchQSQ4wl4R8Z+QyCuh9AxHjvRzC
         xTB6UDRsdZv0Kx+PcErVKejSctpFvNmGLO0dmVcRCa0d+gSXwiMIqT7TeHKeR/+z6ByU
         SWCg==
X-Forwarded-Encrypted: i=1; AJvYcCUdDtjwHUCVBArS7/gevd8rRSxY2bo+lKQyxOYx8llVrgPR6fWe7yf8jgRD3nFqlbyo9bKEV7I9Qw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZzjqmzfKoAbh7S9Z1wZvhz/xkKlYebAzeH3HYRPvzwPVd8AHO
	CSy6adIPTj/24ZcPnzUE74hmT7sPR6xFxDAAgLFOsiNEy6pbgUU=
X-Gm-Gg: ASbGncuPj9gnsvV4Gq5Y+BCXLd1oaVrw0NmorkFZ3FZ3l0KnFkSybrJIFK/a+xUYouJ
	CExMLhd3w6/hnMyW0y6sFSkT6ELcDGTyvA4BjLUNH9X2HBIIgQ4JGkdnXKoHJ6mXnS1Owf/fl87
	JVpgb+6xZk4OlEW3K5ehQPQnrxSeMxvrChvKRQmg8hIkdLXY8px7zAKEYb95GrpPqsnRR1SPtMy
	lygERr4HYcJ82aNjk2pAl5CCVlqHXFMYRppw9DnZqx2cZ+9oiRrXnncQvwLrOlc8BWKHsenPa/H
	VOxKzcd3TFRBqnXBopLQk8zl6zDk034ZV7IUdNHLozuiABgmSXjcv40oqG+qzs+E1Jc18B/Mx6K
	NHyI88Q9W
X-Google-Smtp-Source: AGHT+IGWQoLwpxlWexq3QOiP/zWgNdunEMscDivAza53OZ8Nr5AG57E+rnyDa0K42QwWmx7FP6HcwQ==
X-Received: by 2002:a05:6000:4012:b0:3a0:9575:fac2 with SMTP id ffacd0b85a97d-3a1f649ca07mr1110892f8f.13.1746800506502;
        Fri, 09 May 2025 07:21:46 -0700 (PDT)
Received: from localhost (236.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.236])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3af15bsm74544145e9.30.2025.05.09.07.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 07:21:46 -0700 (PDT)
Message-ID: <b4d90104-7bf4-44b2-a8c4-cc5ccdc37de6@gmail.com>
Date: Fri, 9 May 2025 16:21:45 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: replace round-robin path selector with
 the default for NFINIDAT/InfiniBox
To: Martin Wilck <mwilck@suse.com>, arnony@infinidat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>, John Meneghini <jmeneghi@redhat.com>
References: <20250509134459.226640-1-xose.vazquez@gmail.com>
 <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/9/25 4:08 PM, Martin Wilck wrote:

> Please support this claim with actual numbers. I'm not saying that it's
> wrong (it makes sense that John's argument "the round-robin path
> selector is inefficient in cases where there is a difference in latency
> between paths" applies to all implementations), but you can't present
> numbers for one technology and simply apply them to a different
> technology without providing any evidence for the latter.
> 
> I'd accept this statement in a weaker form, like "It is reasonable to
> assume that the same effects would be measured with dm-multipath over
> SCSI devices, too".

Marzinski did some tests time ago:

git show c015b1281
commit c015b128103e7a6426d124a38cd679a181573b88
Author: Benjamin Marzinski <bmarzins@redhat.com>
Date:   Sat Jan 12 00:04:40 2013 -0600

     multipath: change default path_selector to

     My testing has showed service-time to be as good and occassionally
     noticeably better than round-robin.  So the patch switches the
     default selector to give better performance out of the box.

     Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index f647ee08..097c66f7 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,7 +1,7 @@
  #define DEFAULT_UID_ATTRIBUTE  "ID_SERIAL"
  #define DEFAULT_UDEVDIR                "/dev"
  #define DEFAULT_MULTIPATHDIR   "/" LIB_STRING "/multipath"
-#define DEFAULT_SELECTOR       "round-robin 0"
+#define DEFAULT_SELECTOR       "service-time 0"
  #define DEFAULT_ALIAS_PREFIX   "mpath"
  #define DEFAULT_FEATURES       "0"
  #define DEFAULT_HWHANDLER      "0"

I didn't do any test, sorry.
