Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4308235BDBB
	for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776366948; cv=none; b=r++g0L2X4bpRngyHn1jlH3GbRok+Go+6xNbPjLLoRScykJR7h7YLzX49JVU+lEVZv45fB7oea3hK1kKvHQ9YXqB4CPXTGql7GosrVMIcBxYih9HN6gLKjDRRA8pl6/YXhKzR8S3OKMooGf4As+EZ1HJgEqhPmXm36GeR3GC3tX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776366948; c=relaxed/simple;
	bh=OJeI+3mV9W6ncnLD1OqQ+pA6ULnbFdUSlKq0JT7njbc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnizFMH3ge9vhFDgW4VuyuFBfDIOnUlxBbXFPcOHdTzY/cokbpAN5XYDrWhIVUAe/49BA1FOZuBJ5l3yL7DGaPqX3P5oeSUXySFNZUJkOQtsFg5EpRREnKKEm5LV/Vcw4R9RSMjA04uHtgvNs1IrslsQv6XPXIGBB+rSQ/DJXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qxcT4NOY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxcT4NOY"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b0046078so81765845e9.1
        for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776366942; x=1776971742; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GI2dSkxrwqhQpR5uFXP6GxtJ/asEeAYI1RS8A1ZzV9c=;
        b=qxcT4NOYYRGlo+9xw70qgBmkgAgF2buANZXZKV+WQBLdh1uOkpFWoA9cNc9salnDfG
         +gCR6KmhnPiSbhueSYcXtGM8BrP1rM+5WFjPq/aqQbi3odfIch7nbhP0/6yDYbhIcCSF
         x9m+Gdfw0cuSGmo8vUGdExmlzGoGMtpuKCBV0JMUl0FxSNhif1vlhrZUhwv0GC18RZAw
         jK4N5l2gXVP0A+lD++F5BPGEZzZmkpn68Cezf1vNLNnvGrHtogNSWF9PLR07DoBAxBXc
         gaAEM9fr6Y2nIabetfzbxi/pbOOSQqIfsUZjL6RPFyoWvUXuKhli3VhNV9xLrQmk9Zcn
         DGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776366942; x=1776971742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GI2dSkxrwqhQpR5uFXP6GxtJ/asEeAYI1RS8A1ZzV9c=;
        b=MrevoSs40zin/IfODMUbQZeMJfRHPGjLaftecZZcGnoOO6yjAOSRd/ZgDX4ovu2ZJb
         E+dpbOq6GEYlV0b92VfX3IeUBErtsSnECvmJfkSXKJ6magACv32lvfPOWKT9RoCDdKiP
         KbiXT5bXyRLyYQSbWOrG/Esudo6qT483F40oAtAXXbqdRdOOn6VerOYZjUUwTkqmDTOq
         VvUpsDbfSuPewd/BWlOvskHH38h72vecp7sBqVbAVWnTdbSY+Z4MpKGvU3OZtHmNyz16
         xq2FNJsYVedtkDeXgnpeG3m6sdTj+utnjSFDp+4ySzGK6KlMUOLxFKrsKbt0GxkRKqh7
         JkyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nC7ngoZgGP3y+a/Qsy7I7V7IQA5eT63V8wHKdMhV2C8oqPizt+T53CRAHsU/7koxsQIodMlx3Ag==@lists.linux.dev
X-Gm-Message-State: AOJu0YxcYFM0JXV14X3XkP0xpOG2KH9A0xVCXzPDUi6L8OX7AuIPtoC5
	PMqVt49MLdAHw2rH3nNq6osF+e7+9qcU+7XzVaTUKlD/5LRnk+SN7iv5
X-Gm-Gg: AeBDievKzQDEycENHp9CdZxpBZWhzIjLO3a4bLnXQdveMmqlmjUZEJKCvv2BRf1ghUK
	D+kfbIQt2UI6dlmtFfwE2F8nwZGgKVVYxYpvSxwHP3YWal/CiKGTQZVI9u3qAHBQPy3tZ4I12jU
	nEXKS9Zi7IjrLwdbH/vRzrcWMmDMb1c7qOAtNzIaa5cOQrucn3pBmdeOcoQINpWjNdLqA/cxzuP
	aqcXCkJTNOa5nBKorKDAcb26UXn02HSpdj+3B/J/8niLPYbpfL95xtIt5wSUUB+SAKqjFefTpyY
	v4rLjjx/f2BzR7s4cViKDkM0T87XL9JtGlVXbDvmni3Xp3uI1lbsY6yb7bfoyUyQnQaiIk6EnYb
	qLmt75IIJcsSabTtkUEwMsMuqpDlMC4pXpOM0BEIaMCSOxgx2TwLY+LCvkvtbQXnMlTgtsOHLiT
	RArZ0VW3pmE8hQKgBlTXX6i9xvmNU41rIRQMOGPjXkGIiZQlvIulH4BtRkt85nlndXVEoZf06aJ
	ME=
X-Received: by 2002:a05:600c:a415:b0:485:419c:4eba with SMTP id 5b1f17b1804b1-488fb26d43fmr1783635e9.1.1776366941546;
        Thu, 16 Apr 2026 12:15:41 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d5f06sm16561608f8f.17.2026.04.16.12.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 12:15:41 -0700 (PDT)
Date: Thu, 16 Apr 2026 20:15:39 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Petr Mladek <pmladek@suse.com>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
 mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
 dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
 petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list
 with double-linked list for reverse traversal
Message-ID: <20260416201539.2cee3b99@pumpkin>
In-Reply-To: <aeD4H8P1DiPQoM8V@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
	<20260416133004.07bd2886@pumpkin>
	<aeD4H8P1DiPQoM8V@pathway.suse.cz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Apr 2026 16:54:23 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2026-04-16 13:30:04, David Laight wrote:
> > On Wed, 15 Apr 2026 15:01:37 +0800
> > chensong_2000@189.cn wrote:
> >   
> > > From: Song Chen <chensong_2000@189.cn>
> > > 
> > > The current notifier chain implementation uses a single-linked list
> > > (struct notifier_block *next), which only supports forward traversal
> > > in priority order. This makes it difficult to handle cleanup/teardown
> > > scenarios that require notifiers to be called in reverse priority order.  
> > 
> > If it is only cleanup/teardown then the list can be order-reversed
> > as part of that process at the same time as the list is deleted.  
> 
> Interesting idea. But it won't work in all situations.

It is useful for things like locklessy queuing a request to be processed later.
Items can be added with a cmpxchg and the list grabbed by xchg of NULL.
The only downside is that reversing a list isn't cache friendly.
Thinks... although that may not be any worse than accessing the current 'tail'
to add to the end of a doubly linked (or singly linked with a tail ptr) list.

	David

> 
> Note that the motivation for this update are the module loader
> notifiers which are called several times for each loaded/removed module.
> 
> Best Regards,
> Petr
> 

