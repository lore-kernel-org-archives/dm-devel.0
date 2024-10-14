Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A10158531
	for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898891; cv=none; b=QJz2d1T0gxuLX5u1fbbxI7vlQjCsbwwBC0BBt/hPdLA44/CkWQJyBuBPohzJKa3s6TtK9je3OJ468T6kGxKLn4AWC9zwRx3xLumv1GuoXL5jnzQvJodpIIxnO1byIRdsPGxnH405MLYvMjYgvNT8oeJEWGyWZwcfi+RLeH45NVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898891; c=relaxed/simple;
	bh=fUoNTEfvSq0GSvgYvtoYghMRMAOyjzVsb6fYfyavliI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odTm1qvxzVAC9x1ieSBdAGMPriUunMmOfdFAY2EdrGysWtJoNfeZFES5ttYil0pi1dlvbA1X1qjhTAzjL3hnXT6AKE7njqmlZe3Z//2IRValmonBpAJ9HX26Qj2ozItqmkDfQFKcUJg3VhVNaxjECLOEdBUwQhUopZ9ivVUPEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QjFWyE6/; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjFWyE6/"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3e3dfc24a80so2155349b6e.2
        for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728898889; x=1729503689; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cnopLGGRHN4ho4J7qxXEPkj6nPnNlpB0jO6Hxh7Gbh0=;
        b=QjFWyE6/46Q03qFRDmMx7u1eeVzeA7hrRjwoK88h8VUFzVe+ESW8QttoS0UMMf05qK
         X58FwXuIJZQn0sDxpjk4wBofWOzco7oBcRKz7xKqyn2ypPF3RuKsr7dlNNydUDQt89eN
         InmsMpzHY9ttGmkKREVvt1k6nhNW5Ms7l7ocChJzpnjHQXvIRwBlAcOlqxmduT83sdrY
         WCK/xiXWIsqKnQzl3uxgRcFDw211s0TbzEZiaqHIFVohyorl5XmEgvpoTUEqzAfIXROK
         RSIEmWY6hxnQ0Dhv6q+B7By3RYoXbtLBk1poZQIoguU5aOupQtcqRonUYi4Ke9/XyrkB
         lWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728898889; x=1729503689;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cnopLGGRHN4ho4J7qxXEPkj6nPnNlpB0jO6Hxh7Gbh0=;
        b=JP3fxOiMZ2q+/WHL+przuUeJzWAjnB8CxS1RxvkdLSvw9E3xyIKPsuAfgTFYuDAFYD
         +eyP7iyYFUKBYrD5DaHLQL8NtfDa5PPIL0Yetgu4Eto/bMvQIvJvm0M1QpuZJ1OP7dJR
         riVMJsYQ1sLQtZsphak9mFGBJdt0SJS3AKpyiOFJJQuqAxObdjCPESbAYEMGQsV6lxL4
         9zvqLJ50qVNi0TLq329Lutv3PL1RAvnz2JyCrreUoT3IVjDQexcAPvtTb+Afm5l/9QVr
         cjMJEqJeGoxfsYHkiLwPUjoGuMunu3vNKYsX41vAl/vwYJkU9one5uP/c7UEoYCsMT8y
         C5Gg==
X-Forwarded-Encrypted: i=1; AJvYcCWKBAFgU8lWzIbsBp1zXuwG+GoQBTQFEhjNSXsul/G3D/Znuz6z751AxMsoCYuPZzBWx82wl3KTeQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzmVdmQkx+lGPSCu21G/ak6xnVqS7Yo08HjVoPxNcEGA8yWMkZy
	1mNd5u1ZY+XH5uFufFhHOOOg+4EEWCAgF64Ga+3sZOIemCACjKO/
X-Google-Smtp-Source: AGHT+IHoeSOi/8gRIEfx92XexDiMptLlqh1jZyP8IvkieREy/d/trmJ2S/NsZy8dTSlUefXAs7OIeA==
X-Received: by 2002:a05:6808:3c89:b0:3e3:a1ae:6a1a with SMTP id 5614622812f47-3e5c90b5eaemr8267101b6e.4.1728898889039;
        Mon, 14 Oct 2024 02:41:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea69c2d9ecsm3389311a12.34.2024.10.14.02.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 02:41:28 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:41:23 +0800
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
Message-ID: <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
Yes, I also learned from reading the lib/sort.c git log that indirect
function calls can become especially expensive when
CONFIG_MITIGATION_RETPOLINE is enabled.

I'm not an expert in bcache, bcachefs, or dm-vdo, but when Andrew
previously suggested moving these functions to lib/min_heap, Kent
expressed his support. This led me to believe that in bcache and
bcachefs (which are the primary users of min_heap), these indirect
function calls are considered acceptable. However, that's just my
assumption — I'll wait for Kent to chime in on this.

> Given the whole min_heap thing is basically a ton of less() and swp()
> calls, I really don't think this trade off makes any kind of sense.

As for your point about min_heap being full of less() and swp() calls,
we could handle swp() the same way it's done in lib/sort.c by providing
a built-in swap function, which would help avoid indirect function
calls in places other than fs/bcachefs/ec.c. However, for less(), it
seems there might not be a way around it.

Regards,
Kuan-Wei
