Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101761373
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 05:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729401328; cv=none; b=TPnfYBT3GjJfe7JiXhJvJB8RHpu9x0leD+T08gspUGDNQhqvWjxYIBoR5HLJuxGXI4VRE+KAyU7QEKIgW6gf7TpxSJF8g/uen5caasGfFheft6sxlreff+ICn4tHtbpI0Xj0FVbS0GCqCIl9rsLplxgQaWegRxgpm2Gn2bELKh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729401328; c=relaxed/simple;
	bh=EiS1xJd1Mm5kFjrRr9U5CfecgYtGUDFHb98U0Psae/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfbQOXx46+ZoGlR4eZqV48PQjGsuUY3EfB2iC8glfltz05l3hVvefuVJ1qSy+2VoiC4uc27fhBzTt2Nb2wCEnUFKlfFp5nVifWv5AMDibog8dsS3QU1+24JmOdDV/rLJPAC2rN+wpDVpQswsoVWZmZgvt5lKNCXr9zX9cC5pIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bT9aZldn; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bT9aZldn"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c803787abso26236135ad.0
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 22:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729401326; x=1730006126; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mPLTUkSwRn/ADCNGu4AGpEmYT7rtlb2CMdwqNdOxpTA=;
        b=bT9aZldnunhlyS4V82H+GcvuAIUUZ3K98T0d9E5awPOlaSdQOJJfsJd5Vyk6nfJULJ
         Wid4cwfLzacHvnnEwJ4w8C1HWRMpAF0XBAh23eOaYc1Ni5PSkb5kJ1DVCh3A4cjKJKA7
         dpT9KY1Fe2OO5+gm3An8EKmrmc5w7a7U/ZaoPjUcLgh+mJ0d+e4sxfMx6sG9vJVshJoX
         VZvbsT68yUdyAB7/FqJ5I1lIP1Yd5EljCoK9AB9rLk/MKWyj9C9n5y7vBQlNdWXPFpvW
         U+QvVaT5XiZU/xY09hdklmmcUMzr/hy59Ah5R+OL6T1tpa0k9gpYrtdB0s+S1ZRMef7N
         6Odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729401326; x=1730006126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPLTUkSwRn/ADCNGu4AGpEmYT7rtlb2CMdwqNdOxpTA=;
        b=waOQAgNLLaaqhehFttNefIcAbuFSC/G3yxi6AdpdssBsl0g9uIKDqI7eW5iESFx2zp
         yDJR7vlVT52YhQfi16HfC+9J0Jhlzm3qM5ADNzIwSyv7EuK6tbn0SkWBU8oWWN4AGPwu
         HQ6pnhN7+vMQtIFZzksyyTy0l/kSs/SsVDcIalhpWtxRmKqBmxWoYAM/TO6h2jTPr5xk
         vc/A4YQOIP5+p2RW/WSK8jjVqNthOEz+64qIrTdfwv/xMXKj/DwZ3hPFKnnsasVyQS5d
         zE89wZPhj/mtZlWqkuSY6jwaw5fTXjdbqQhclR7egvOcBAZ166nZe5iUGvgmeIrN9yHO
         l25A==
X-Forwarded-Encrypted: i=1; AJvYcCW1dzUkxLHmjLm6we5qpzvGFKxT06MhfEZV1Tg30CeYe6FcLtZwqHIvf3y1s2dGY2uKJp6xnn/JaA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYU/PuYnepRURrhtV9v+stnqHC0JImTW0FLZe+0Rd4tV56vrw2
	HdqAAPU+8Tmuv1PLJK3b6QOqQxt+YPz8uaGrIqtSt8eGtUckkmob
X-Google-Smtp-Source: AGHT+IE2fzzFACXVkzcnLBp5pcAmsooXt9koAwUC1XLg/0exaP+5fY0FgX9aH1MGPibSba2Conm9sg==
X-Received: by 2002:a17:902:d4c9:b0:20b:c043:3873 with SMTP id d9443c01a7336-20e5c29ab00mr108315935ad.21.1729401326147;
        Sat, 19 Oct 2024 22:15:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0de39fsm4857465ad.206.2024.10.19.22.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 22:15:24 -0700 (PDT)
Date: Sun, 20 Oct 2024 13:15:19 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <ZxSR50u0qLYPUeH+@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014081358.GS17263@noisy.programming.kicks-ass.net>

On Mon, Oct 14, 2024 at 10:13:58AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> > All current min heap API functions are marked with '__always_inline'.
> > However, as the number of users increases, inlining these functions
> > everywhere leads to a significant increase in kernel size.
> > 
> > In performance-critical paths, such as when perf events are enabled and
> > min heap functions are called on every context switch, it is important
> > to retain the inline versions for optimal performance. To balance this,
> > the original inline functions are kept, and additional non-inline
> > versions of the functions have been added in lib/min_heap.c.
> 
> The reason it is all __always_inline is because then the whole
> min_heap_callbacks thing can be constant propagated and the func->less()
> etc calls become direct calls.
> 
> Doing out of line for this stuff, makes them indirect calls, and
> indirect calls are super retarded expensive ever since spectre. But also
> things like kCFI add significant cost to indirect calls.
> 
> Something that would be a trivial subtract instruction becomes this
> giant mess of an indirect function call.
> 
> Given the whole min_heap thing is basically a ton of less() and swp()
> calls, I really don't think this trade off makes any kind of sense.

BTW, Regarding the concerns about the efficiency impact of indirect
function calls, should we also consider converting some calls to
sort()/list_sort() into inline function calls? The comparison functions
they require could lead to a significant number of indirect calls.

For instance, the comparison function passed to list_sort() in ubifs
calls cond_resched(), which implies that the linked list could be
lengthy, further increasing the likelihood of numerous indirect calls.

Regards,
Kuan-Wei
