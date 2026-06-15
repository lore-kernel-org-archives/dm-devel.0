Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722E03C0A0D
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512023; cv=none; b=JamiRaqVpvanwBLPEOcmOxADXCYJrf9JCdx4G6IjMSgzuzUwzWfpbotmt1gm+tsET1HvfYQUZg5QbrJgtfJLJwXKunc73SW4ekwjqFkepDELinhzn3ACt5hhTH0kOyQtERftMqIjLJ6Aa8Hoz7sv4NX6XaeuVWp5+wPuuXaZwxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512023; c=relaxed/simple;
	bh=A6DauMGjVX+3NjclS98vfXuBudD6Ueoxa57XuEJLoTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D0FceoStG4FMMhOS+s9+kGxqU6VgyQKZ/xRbzCTih9vRXbD0KmyNciC9e19v58cTgWnRvL7R4q8WKa047p9oJd0gnfYy7dWPLshtZ9ZGqtXIKb1ngt2rSeHKbrg0qlNYTdOIjcdbhT0BrVzmevBGYsvm6SlvHu7EOtDbq351Tkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p/+0ILap; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p/+0ILap"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b8adf7efso4301615e9.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 01:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781512020; x=1782116820; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7gUfQQWNl2/162RS8DcK+pTPzQP8ocxB+jFfBNECv0=;
        b=p/+0ILapmgYHI7xFM4FIWpTVp07UQk6YykpI0V6+K9FicP+B9waxqmkk222B4p3L5H
         GSfTS+kGZTtDGifi5XvAaeGosUv5oF5YLK0C0T2M5gnPn/wsGjtOtVDUZofEenBTws76
         l9tWrL8uQaId/NWG/QxUKbIxALwiSk3SMJO9tkVuxxKeN5zHP+xcuDVNWRSGmtchaidA
         d6e4brEGWMdImPND8NZs4mfDo/l4dWSepCRYL8eokYOQntyIsxAhMXvqyYtJntFxStLf
         zjYUgUXUPqaJgM7wCZHDSuzgXGvLdRHCgm9PpwRcyYy+xhKw/N+oECK4k17neN1T5k9Q
         ql1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781512020; x=1782116820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7gUfQQWNl2/162RS8DcK+pTPzQP8ocxB+jFfBNECv0=;
        b=iMcQIg8JrGxFqHGDfCyt+2zO2H6TMAOmcOpR9qEN8xSvljUrVTcwlrc+vIeysLFhBY
         WHFfo/rjTy+N5uUSRKNnP+Eu5MNhy0rQ1ZbaNhvvzFh6n85nqAedjQ5x7tS/e1WgBWQX
         mFihHfJVDNSYpnZq0RBS0poyPTW9mUfac9CwamHaR43WY+YlmP8xLtzWifS1480O81i/
         jQwORoek+BxrH0iQsHB2lgR1AUWthkfiNokES9jxf5WhvG3IxJcb5kuUd2AxAVRz4M5F
         6ipXP5hhD3hG+Qgv7LhM5gblo8mtM3nYEQa9cfpG5Jq7MMc33h4kB8DRmdolmvdcVDX8
         18WQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EdNTHH/sysKWg/MB7z3xHafxN7fqJ1ui5XlUi/376jw9/uROF2gQQF1QmKqCXYuq8h6ebwQPtLg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7yNTYVfxq4qubTtXKwoAy8scDihcZC5hUNcfgnwXj2yKG3nnO
	ncv8NYVMjgmI+zYqHjiEOo8K0dAAMXMJFKltqmEONG4qpREVh4je2gc=
X-Gm-Gg: Acq92OGPBBTHx6ajr4S3r6SQ2QktURI3ZEEky8UHqMGrHXQdQYlSbMF2Zeuj0NFChVJ
	NCU5P5eySP1+A0dENkbAtigcxK952T+Le/efrggB8/ELL7DY00yho7fLjDsTzn7HzATwRRnO9lJ
	FkhyglXCQ/HTqETFzh4IEbmrLh+9cvSDpSip8g56qcOV9gdXzTsqvglCyPH+BRRFShlQntNnViE
	cM/lum6vuYYkaJjOCHYhmxSW/5Hg3CgGIuY4Oi1Yiz6mYifeFOAbBEXu4R0ENw7e4On9aLgWb8R
	t1baULW48Q7VX0PIPPrSdxslWcFIi4J8IWCDT1UA4BMbgQI3LDFbVfAc3MtBAAeabNtA8i9C3Gy
	1iVuP01MNKJC/JA4iPTQ5OzmfotADF8u4/bh5qRdgu4mPJaX/dlPnxJB3mhNQcSrlZSxEUvgERH
	6yefGJqKkYAzRjksTxfUj8QVAfrRY8M9p/yef0LFo6KqBwbtT75PNVtmDL/66jSzIk
X-Received: by 2002:a05:600c:138e:b0:490:b45b:2471 with SMTP id 5b1f17b1804b1-490ec5067cemr95930515e9.6.1781512019280;
        Mon, 15 Jun 2026 01:26:59 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492202e5d61sm215569125e9.1.2026.06.15.01.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 01:26:58 -0700 (PDT)
Message-ID: <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
Date: Mon, 15 Jun 2026 10:26:58 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
 <20260613131002.144263-3-xose.vazquez@gmail.com>
 <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/26 10:16 AM, Martin Wilck wrote:

> On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
>> Selectors operate on the next individual I/O request rather
>> than a "bunch" of I/O.
> 
> This patch doesn't apply cleanly to any of my branches (master, queue,
> tip).
That quote is from the patch series I sent earlier. You might have missed it:

Xose Vazquez Perez (3):
   multipath-tools: delete obsolete information from multipath.conf.5
   multipath-tools: remove explicit width from .TP macros in multipath.conf.5
   multipath-tools: remove explicit widths from macros in the remaining man pages

  libmpathpersist/mpath_persistent_reserve_in.3 |   4 +-
  .../mpath_persistent_reserve_out.3            |   4 +-
  mpathpersist/mpathpersist.8.in                |   2 +-
  multipath/multipath.8.in                      |   6 +-
  multipath/multipath.conf.5.in                 | 135 +++++-------------
  multipathd/multipathd.8.in                    |   9 +-
  6 files changed, 51 insertions(+), 109 deletions(-)
