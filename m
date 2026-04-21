Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652A39FCDE
	for <dm-devel@lists.linux.dev>; Tue, 21 Apr 2026 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762328; cv=none; b=NLB5ZIJkZMyl/bTMZUwDgai4O+t7XGQBVZcxrR/ZdHPN8CLl3neKmj4u9+TVlFZW+FYuzl+jfcMPux6hTD8Fwn5FujpA53DlmsISVcd4EJexWpzaXmpYFXPPG/V962VwXW8vk64rd1QBZDsHupdPVDLhcryzvlOuF8aiGHxxSsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762328; c=relaxed/simple;
	bh=jNS11TxrGCzC/ayr6dWUKwMQYFcjJbkoMNjsM92foRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ht0B4d+QI1/hHajtWBAA/scuasz2eMPJ8ZhyLNhMfsej9cjxqCpR9D0v5f0ZnVPTDLl91rWqVV1Jh1Vov6Cq76PG0FFYKuyhf0exKsytQ6v8kz8B8BKTnzaNQPL4amX2mxCPoJRcpwI3PwfT6cX6v2YojPfwpkq6wvnCfM8th7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X4wAkyCJ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X4wAkyCJ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-441209fb77eso177890f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 21 Apr 2026 02:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776762325; x=1777367125; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=X4wAkyCJnfDNNRWSj2r4M3o/pYg70sFxLofvzi0POB5wywxot+AOfuFAqjaFWKUdDU
         Bt21nP0eBXijnkeS8lAQnEwaHyc4PzvI9h+aDjP+BwUBM6t3gNTpbaiGskXPIl1s884I
         b1tZX02ngIzgUUo9Gcx7dQb+Y9I33ayec3Rz1B6T4N736aFdAzpZmAkVjfvQlH7QZgfz
         yi3NOyxL9t779iBizeamMbMXMYEv/bU5EQNvUWJul3weODhg8DbS/aj/wJpykx4fdTv6
         dtbvz1H2DkaxCQ7W+6ftNMGkW07uNocOzBnpievt0LPntZRV9FS9PhogjADSvV8F3B5X
         darQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776762325; x=1777367125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=fqMLZp9GtMNzYxBo4XxoGNf8FNL9qrc0QA3VIlvvB+8k/wigUJzK80jqirYAH8vxm/
         W8fpDfKUp3dl8Dv735uJrsu6w5RylMBGu+a67Ru0XJdmIf0/9qzrfS9fYVIW1svRt4od
         NNq558pCcrH5Nok35fpCmsztPKHVFq1I/GfByjPqBH98QWsK8YHKe0Ndc0wsosN96nD4
         XoiyxL2OGx/d847+8ag35RSJ5zpz45JseRv7JkMXOxsbn6QJQ3AUTjtDB4PgWDSNL1rq
         sR0ZTf1bgeCtMP3HKT328I7ikzeaTl1r9ZE0uzC2Q9uFzma059kFprnwC+s7XSzzu7FP
         UFSA==
X-Forwarded-Encrypted: i=1; AFNElJ8bbvs3mv9KCCNnf2KfIkxgcT7M0SFRJIKDNluvCShi/Ckx9L+n70iJATvykxwaRhqENF7fRkPhnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2GDi4VSpRcSd+MSFrR4PCjMXDPR88VLQPq+zVFRf3sydIKNim
	kqSrCqMtLq7Rw4PYzWwurP+2S9OZSfANe2/dpo9cgXzgrCfSO+5sO3L4rEGLlhCpOjo=
X-Gm-Gg: AeBDievjdmLnC9PuL0j20VuzrJ1On3gX5cmYqy823t9b1dgJ5mXHGZqERQb+/2V4yFV
	JUnq5HA7eDpTvwLOQy8WvktOJXdVUEdS7P26kXGYa9IB+uA0Z4ePygJwgV1m2RH2/dvEZdZ2yN6
	FEKZU8lEnmhDNSFelKHx9LrdXIdq4ypIKgKYjwOgtKHV810eQ3ZYt677UxcoIxOV8Eh4vUUo3eI
	r6JlF92PATTPfKoNC035vQAxPT0ZX9FTJzNkp5eWJCYFy6UJ1mIr0jDWjx49jLl/WbsnsKNktHo
	a2sfEjrjNb2zSyrF1izV4lKsXaczbxwEdrvF8YLRozB7EUVyJuT79puK7I1mn9qW6vbfDLh/jMP
	chJPbPTAg5deZuPt2b5NYCzC47dDXkcNeW23yPuL4fDcNzLSJCMyyKDoxQKTrg6YbBRdA2Xq4Vi
	700to6TE0y/LY5MHmnAP7xIFZBU1g6vLX1WAPsp+OdVs/BhAtdAJs=
X-Received: by 2002:a5d:5c81:0:b0:43d:729e:f23a with SMTP id ffacd0b85a97d-43fe408dab9mr19081632f8f.22.1776762324596;
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm39945351f8f.6.2026.04.21.02.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:05:21 +0200
From: Petr Mladek <pmladek@suse.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
	mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aec90caYZDHDAHgw@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260420144429.57b45f2beece690bceea96ec@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420144429.57b45f2beece690bceea96ec@kernel.org>

On Mon 2026-04-20 14:44:29, Masami Hiramatsu wrote:
> Hi Song,
> 
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
> > From: Song Chen <chensong_2000@189.cn>
> > 
> > The current notifier chain implementation uses a single-linked list
> > (struct notifier_block *next), which only supports forward traversal
> > in priority order. This makes it difficult to handle cleanup/teardown
> > scenarios that require notifiers to be called in reverse priority order.
> 
> What about introducing a new notification callback API that allows you
> to describe dependencies between callback functions?
> 
> For example, when registering a callback, you could register a string
> as an ID and specify whether to call it before or after that ID,
> or you could register a comparison function that is called when adding
> to a list. (I prefer @name and @depends fields so that it can be easily
> maintained.)

This looks too complex. It would make sense only
when this API has more users.

Also this won't be enough for the ftrace/livepatch callbacks.
They need to be ordered against against each other. But they
also need to be called before/after all other callbacks.
For example, when the module is loaded:

   + 1st frace
   + 2nd livepatch
   + then other notifiers

See the commit c1bf08ac26e92122 ("ftrace: Be first to run code
modification on modules").

> This would allow for better dependency building when adding to the list.
 
> > 
> > A concrete example is the ordering dependency between ftrace and
> > livepatch during module load/unload. see the detail here [1].
> 
> If this only concerns notification callback issues with the ftrace
> and livepatch modules, it's far more robust to simply call the
> necessary processing directly when the modules load and unload,
> rather than registering notification callbacks externally.
> 
> There are fprobe, kprobe and its trace-events, all of them are using
> ftrace as its fundation layer. In this case, I always needs to
> consider callback order when a module is unloaded.
> 
> If ftrace is working as a part of module callbacks, it will conflict
> with fprobe/kprobe module callback. Of course we can reorder it with
> modifying its priority. But this is ugly, because when we introduce
> a new other feature which depends on another layer, we need to
> reorder the callback's priority number on the list.
> 
> Based on the above, I don't think this can be resolved simply by
> changing the list of notification callbacks to a bidirectional list.

I agree. I would keep it as is (hardcoded).

Best Regards,
Petr
