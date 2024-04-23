Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59117543
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713833032; cv=none; b=hHXRv/B+8JI6rCX/4vbjqcANclBBS5v2tPSJSIw39qvj1riJ7+0YRHsqPZO2UGVcAeimfIqdC3oYXA3dOsZDeXyYLWHX9zIK2mVV0MCaH700+TeKfulqUHrMSj7/SncfQcd1bU2zecULoGs0F8wmoqdycpcsfg3y7Gj3b6Ofcvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713833032; c=relaxed/simple;
	bh=zm0PVmrnyBvzggy6+uE5c+CD6f3INNYYmKCWNhOou+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxIDF2A35OTmvx1EHBHwXXknM8B2Hi6+pTCyo/r97wmFlShd468X4uRcQyuyxVD4oHBqbTTwhqh+lmAh+DZgNsZqcn3oISk28MMKGT6phoFxzOpFIfhgnde3FQHpg3aQ4nLHjvr+z+PB4DIxz23bi7lE+JbvWoWF4G/eudpNUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpRUoYEy; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpRUoYEy"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ed20fb620fso4225817b3a.2
        for <dm-devel@lists.linux.dev>; Mon, 22 Apr 2024 17:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713833030; x=1714437830; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgy2pSKaWKZr77kQ+lvnqcQfCnes1rWUXdspB7oF+GM=;
        b=LpRUoYEyANtQpXv91H0fnDi1TahFBihBhg8TwRTSMLBeUn4jzbOluGSmoYSy/TLkjn
         4b3NsuljVHBOl5c1N3Ld/0LoV1AWeydUujIakMI46Dt7Vx3OykqSp9uuvhYS+I6dXxgP
         hma9Ubog8ymg/Sk98DIsxfjpeG+zvfzCNDl+PXxN9a4oVaspvM9cwkGSP6SYK3ZgyRGg
         QZCV3UA9SmPZOk1jAbp4K35cIxMJDatSlo5nSlhiariRCGjBXB3r3f/1a3N7ChsO2Irn
         kIMunCZ5zoY1RVPl319fRI9Ymq5Yt7c85VH6D5KqpIrOdlwbyTW2r5V7bxWMoFsHJ9hZ
         UXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713833030; x=1714437830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgy2pSKaWKZr77kQ+lvnqcQfCnes1rWUXdspB7oF+GM=;
        b=h/Zseo5H2K7DJAH0mmHmZ/MvkJoFWc+ng0V5pqFKbCATk/XrtPaR1nZ0yEn4ud8Jd0
         YnKxub2u4Bmn0Ca9urWrc6ixjnxHoflSLe02klx2fLi7MuOQCRqtok9D/XT4boNEeWyH
         ZQjxNH/zeeOEol719RIr4gdha+kT2Yxkd8b6ZR7wd2zdgDIvgPO5c6Ezd9/zAiYDoZO1
         KLbzYYq9gHGZMwM2Sm0BL3H3q9iWKRyfm+epIdKsg9ylqmjIs66POd8aUm2FieBVigtq
         L1MszoOCjU9Djo+F2wtEtf+shxmldmulFtfasEZllobTQV1WPefEgjb19E0t9lDjtjhE
         ni1g==
X-Gm-Message-State: AOJu0Yy7akvg49gxdPjCyY+3zj04DSiUPLacGrpUe5nqOKX0eTUH4Njx
	MnRMKQ3+dEa+iDImv9NOCDFtYeictnme451edYKO912gnjgltO2w/pEZH7XI
X-Google-Smtp-Source: AGHT+IHMi7y8L/f0l8G37UFbkQ+s0MyDBEcxoUtMVEXSmbUE+wpJkZC00cKjttWeLuTthaABOtsuQg==
X-Received: by 2002:a05:6a21:8803:b0:1ad:746:b15a with SMTP id ta3-20020a056a21880300b001ad0746b15amr6719056pzc.47.1713833030033;
        Mon, 22 Apr 2024 17:43:50 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:6f51])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b001dcfaf4db22sm8753676ple.2.2024.04.22.17.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 17:43:49 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 22 Apr 2024 14:43:48 -1000
From: Tejun Heo <tj@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Message-ID: <ZicERHDW2w02sJQA@slm.duckdns.org>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
 <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
 <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>

Hello,

Sorry about the delay. I was wondering what happened to this thread earlier
in the morning and realized that I missed your reply. Thanks for the dump
and instruction. I was only testing on NUMA setups and made a silly mistake.
Can you please try the following patch?

------ 8< ------
workqueue: The default node_nr_active should have its max set to max_active

The default nna (node_nr_active) is used when the pool isn't tied to a
specific NUMA node. This can happen in the following cases:

 1. On NUMA, if per-node pwq init failure and the fallback pwq is used.
 2. On NUMA, if a pool is configured to span multiple nodes.
 3. On single node setups.

5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for
unbound workqueues") set the default nna->max to min_active because only #1
was being considered. For #2 and #3, using min_active means that the max
concurrency in normal operation is pushed down to min_active which is
currently 8, which can obviously lead to performance issues.

#1 is very unlikely to happen to begin with and even when it does which
exact value nna->max is set to doesn't really matter. #2 can only happen if
the workqueue is intentionally configured to ignore NUMA boundaries and
there's no good way to distribute max_active in this case. #3 is the default
behavior on single node machines.

Let's set it the default nna->max to max_active. This fixes the artificially
lowered concurrency problem on single node machines and shouldn't hurt
anything for other cases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for unbound workqueues")
Link: http://lkml.kernel.org/r/20240410082822.2131994-1-shinichiro.kawasaki@wdc.com
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0066c8f6c154..f94ae51c6f2b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1606,7 +1606,7 @@ static void wq_update_node_max_active(struct workqueue_struct *wq, int off_cpu)
 			      min_active, max_active);
 	}
 
-	wq_node_nr_active(wq, NUMA_NO_NODE)->max = min_active;
+	wq_node_nr_active(wq, NUMA_NO_NODE)->max = max_active;
 }
 
 /**
