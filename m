Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9A34EF0E
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 10:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775815858; cv=none; b=mLvILmbKxUc6JhI/irxFiD3lVZcI1puhNYOdA95VnWRNatqwnQku/wZ+mrl9rDLafaTyuillI5gILBUoxt6BpldwdJuSwb7NYrqlGxBelaspqtAOB5wVaPgNsZES6+OJDXgU05quIcVMVxDXNc6BqGLa3h8Gwe2Mxa3UBYw/uec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775815858; c=relaxed/simple;
	bh=zKVeFhayPQOrx5SBy3aON+cgHp62dSbhACTAXHJ/Atk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=D1Z7qxVw6+2EbtKX/3NGHadk2oRTTrCfsc+ZECY00UvNHa7fFK4Z1OugcHmVnKU7aHA2vgnD6h2JVBsqdPh4WvZLo5I72QU9GXcJidcNRrg5gP+RcfVLGeOnilZ+xVhvX7aeDBPGBPFez3e8RkHfTZ4qM89mWVfcBTIzYAIiIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pYm1d3un; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pYm1d3un"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so17623005e9.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775815856; x=1776420656; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rVVWEgtCRY3qSb+i79BDG4d/u2cUWbolPCHFRBB4+c8=;
        b=pYm1d3unKA9nKlBJEqOTiKT48v1Bmc7SrAQMArpGVGX2awQqEYqKtVFbaErTmd/uRP
         2V6vXXaFYXi6ou5fvRcVa8K4XexD1YzPNx3RBj7AGQFWUZ00IbGFk4cSGsYIlCw08Cyq
         x0fTgjcFstYv3iV/BNjzoMReMSwKcY/bJs5HVuZXfN5CUloJZxjmkU8TDFuFcuKN6PnH
         ETKIUKY1QpOg7sqNvESZ+7oK9s8V9fTyRSE0UUWxwt/aP2MvVKtUb6VDBa+NBH9YuAN3
         aGAF7c8gWeMIpPjUtyVaaKYQHjOr35KTW2LC7ySitLijmHkD7MWxRPx1tFsm+IUtCuWO
         MyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775815856; x=1776420656;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rVVWEgtCRY3qSb+i79BDG4d/u2cUWbolPCHFRBB4+c8=;
        b=n9106ATMvRvJsa0MLSYSrVy6vMtV1a9htUxaXSvj02FwuqxWhG8OImeAXegFPLtbvx
         F9/gJWN8sL6kRRlte0h3Rrg3hZ51MwN6p+hIG7vFwFWTzIE8jJyo/V7t0+2aUUPlC+hg
         oSycfRI1siOYgnsRrGdyN+x8XJ9FiVFZ7MOgyytTCvheEzqjGLxXuVa072IYBwFOgcSS
         H+EuuXa67jxFmVib/mDi+gTUVFNO+HR0MeJL4WWjsD2ejGYn1PPO04OUfrXyHzPpaXhh
         L5ZhecJ4PAlr//ZalXFXtXw60Od8ed0rR5eNIw46KgGTT4EJgIwu7ySBcM8GE92dHLls
         k6EA==
X-Gm-Message-State: AOJu0Yx9edZYgWJYiivMjNZ+Tr09C9EyLlNABqiYye9FCIEQt2uqLeVM
	Z7FflaprriycLBVWJ1oRujLeQHZrcvH+TqH9qqlnwJ357jUsic28842y
X-Gm-Gg: AeBDiet3g0cpjMGSr5ezXOPVTS97mN1JZDI6Wy23dh/yfdMdtNcTcCFpF7bdIh/cXaD
	9Lb8IbN7wkX5bB8sQgjn+I/68J7b8ipeWTdQs5YsyKYtUYDrWs8Q86funuQT5BsvZIfaogq9bKY
	4q7D/vNd9kuDIoMR18s4fSqVvsuGMUASaS3wTD3f29MvNFYlLc2VVQC3kvgC0uxpQcxl7n+XiUp
	wZwRvBnxObnWnRw5AniRCbPYL/hY8nDwd9VjvlaRxxTdiPtLA73CixVSXGZJf5nNHl6ZXqfy0Yw
	coZD/42yyhuRyX4Icu9nAQikkkTfgC/GkaZ8p+TShH6njo0Myekt0D25zg70Ma78xuGNPT1kb8z
	rK6qANkUHIjq0OTXaQnrH4NAQLy0J/X4kp8LcGSfStXb4ylGazkdX+GTj34eAKSL9j2UxHRGd3n
	H5hjeerxkA5NR7sqAdw/U=
X-Received: by 2002:a05:600c:a11b:b0:488:bfc3:efc with SMTP id 5b1f17b1804b1-488d66559d0mr26023055e9.0.1775815855630;
        Fri, 10 Apr 2026 03:10:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d688da2csm16453915e9.34.2026.04.10.03.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:10:54 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:10:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm cache: fix write hang in passthrough mode
Message-ID: <adjMq6T5RRjv_uxM@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ming-Hung Tsai,

Commit 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
from Feb 9, 2026 (linux-next), leads to the following Smatch static
checker warning:

	drivers/md/dm-cache-target.c:1527 invalidate_committed()
	error: dereferencing freed memory 'mg' (line 1525)

drivers/md/dm-cache-target.c
    1517 static void invalidate_committed(struct work_struct *ws)
    1518 {
    1519         struct dm_cache_migration *mg = ws_to_mg(ws);
    1520         struct cache *cache = mg->cache;
    1521         struct bio *bio = mg->overwrite_bio;
    1522         struct per_bio_data *pb = get_per_bio_data(bio);
    1523 
    1524         if (mg->k.input)
    1525                 invalidate_complete(mg, false);
                                             ^^
This frees mg.

    1526 
--> 1527         init_continuation(&mg->k, invalidate_completed);
                                    ^^
    1528         remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
                                                           ^^
    1529         dm_hook_bio(&pb->hook_info, bio, overwrite_endio, mg);
                                                                   ^^
But we still dereference it later.

    1530         dm_submit_bio_remap(bio, NULL);
    1531 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
