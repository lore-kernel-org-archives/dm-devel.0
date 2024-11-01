Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF71CDA12
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498332; cv=none; b=cnJS2pA90Zs6yhPySneRRSKrAFuq+vCcQczlRnK51aM2LPaVDJqgOAgAdnU4hpv/Vj569r9Pe82erD+72Ua3++Ans1iu2RdxPlM0fCmaJ69+9d9WR5tiw6SybaPfG/5RcIo1ithjXOmBAN/3Nl5Co3is6fa4MAWHK0O0i6Fw3NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498332; c=relaxed/simple;
	bh=TiiiRpmhYy/3lrDdLk3e/ulmZ1GqqZegLcYId9YAQG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o782Yy+2uh4LKqh8lgw8mftt4VLWZHznEx2Aft5ZlycVNRejtCvw4bfHMgJMZteIm3nl8Naxxy6DShKkr2paBIXXcUbEj58m+DT4xGju12zfAIlZv4CJvwNKVN0XO/4Nd4w76bxNTnyRXF2APo4mAzDXBKTGZ8fQkh0BnIuVNZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M83rxHRI; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M83rxHRI"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a99f3a5a44cso320118066b.3
        for <dm-devel@lists.linux.dev>; Fri, 01 Nov 2024 14:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730498328; x=1731103128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+VUgcigYNj7pXRI69xxT6QPDrXL4GyVDAA1s20kVr+g=;
        b=M83rxHRI/2hsgNdIXhG4HlaJ7EBZQJrOmUlrRHI4TKk5Zv+C6y/dhfnIaJPx/L3s1a
         kZOhnaUCbgx0xxhGE1rhmLKcXB37hBng2FaD0JMfrji7JhO/+KK4CxOdoDkR4IHPmcfN
         HNKw02d2xO7yYKENCMciEBQw0JJEhmfFxK2ZEMbWwYlXmFYi5zkNYtIvr5bq8d7/CB03
         WIeNdBLcS6m+TuKNNwg9q27AM8GusBTJCkwWbGJLkIZbgEwmBFDU+ycCDEoIa8tFIISf
         autcAg5w8KHe6YM0coMjYolgwucoodM4yHFQPqwnJAjWHKhDHEGkTUU/ACCj1U5uomci
         OG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730498328; x=1731103128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VUgcigYNj7pXRI69xxT6QPDrXL4GyVDAA1s20kVr+g=;
        b=rUObY14+owb0bNCQZEg8C0ksCTg/svNDAasnsEwbeVKlxN/td//3QUbO203tSixbmC
         izxS3/jSCh7YARTpYBwjwRlP4L/enJs3Dpd2bpsgvNQe6Lg/y7JQoJXwKribYU/9jl53
         pmD5Sri5TvzO91gaLvxUJfYDVRRN6sQxJsMtRh1Vj55JM7FwfnWJd6pYPuhFr6yR0Vhg
         ghBgiBCjt0eUOzZMFBEBPOSDPgZ79kKLE7+Db9vLF5ftWC7Kw5FMKaGwt3TpHOYKjz0R
         VS4q7H+78mp9dwyrY18tNeW/ObadpU7bJ3W4VVtdLczrJPciDxpdmUJgyYp6gWksM5aQ
         yyjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhvokxzhEMqtqPRTG3ocrdvTtptprBoKNzTJiC6HMP9AJP22MzsNNNogUUnSHrto2mYXQ8LknuOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw8c6+P04iq/fwD3kpAOrjNluiXw+AMZY4MiY5hQKOUD0CxV3u
	I3JnDnWnvQg7/7VuUbO+mTO8H++kvK//W70uBggPK1j8WvkHMaurMuv5EtGBgmo=
X-Google-Smtp-Source: AGHT+IFJGzKNmcIvdurovCCtHO4Nrl6HlIyd/ag2xBkpwECs601c9HwPGExl/B5SPWeOLTa8NlVKSA==
X-Received: by 2002:a17:906:794c:b0:a99:e505:2089 with SMTP id a640c23a62f3a-a9de61ce121mr1021073166b.45.1730498327752;
        Fri, 01 Nov 2024 14:58:47 -0700 (PDT)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e565ea53dsm231157266b.114.2024.11.01.14.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:58:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/3] multipath-tools: udev rule fixes
Date: Fri,  1 Nov 2024 22:58:37 +0100
Message-ID: <20241101215840.1077082-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here are more fixes for the multipath udev rules. 2/3 is the actual fix,
the other two are minor cleanups / code clarifications.

Martin Wilck (3):
  11-dm-mpath.rules.in: import DM_COLDPLUG_SUSPENDED only once
  11-dm-mpath.rules.in: handle inactive suspended devices correctly
  11-dm-mpath.rules.in: clarify DM_ACTIVATION logic

 multipath/11-dm-mpath.rules.in | 40 +++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 17 deletions(-)

-- 
2.47.0

