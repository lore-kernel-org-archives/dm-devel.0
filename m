Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEF63DEFE6
	for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351269; cv=none; b=SlGfoxLgf6C1h0LVjhIdYqPw59ELcXSaQSgiWQvC4YolGMKDwHyCIkVcVZ06+uHjAxlGAtc2H/IJ0Y4d6Wm3Baa8kYNxkhCNmhp82s0yORB/eNCDsC56jzygQPk/1w0Hh/16SrdXS5+cHtVwbTM1+zYDAIbh8ZpZfWRky2/8yGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351269; c=relaxed/simple;
	bh=EPHRfB7I5uH7xIWit20L1zYnCi9wOT2o59aqll9Yfh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMvcPZ6nLj2e2wxPPY91GdfYFCNCFxSwiUuITuBgl9FdkJzaWs3dQ2Ay12E6c//3QZWB0J6XuVR3dvCQaK0uR0w+09pJW7K/Dw1iN10ISH8C1qIgN/EAOBnG3p83BMA7PsmsUnsHBmM1iLjnwNHXPyciZubr8iq6aReIUA3xon0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WbH8dYzz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WbH8dYzz"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488a29e6110so85163635e9.3
        for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776351266; x=1776956066; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nUk9+5ugjhG90uPs8bskXfY1v/H6BYvalTyZQcNSMUA=;
        b=WbH8dYzzhvIg+X4Yo9FQYbL1raoxk3/vSpjSzMcZfM/o0cgMy1TfUa20H4HPjxyWr3
         kEtlfepbs02Q26Yy1HQCxakmZsEt9IlpRwUmBawU/1i/TUAA4TK9D3qXpP1/hqJ5rVdX
         OTnYf4aZtzdOVU0Mvs0NtT3plDHLxdn2hlzlvWawZl1VoZn4cn303/2FBczCtRCF4XV/
         JZTiBW2OtUQmBxLY8cGHWJGX++MLen5R2Pr9VMVj/z6bTYCwMak0OS2Dsri48xHrfY0u
         KTHJI6KZYUm9FY9lvXkfDAbTLMVoe5y3rXjQaVcrOrpvMueP0BWbd13mZLHrDtfLf3XE
         SEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351266; x=1776956066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUk9+5ugjhG90uPs8bskXfY1v/H6BYvalTyZQcNSMUA=;
        b=bbGqj30hxExB2+XULOpiZoIbGVVZokIWwcLdNsBulYeS6FO+v8m8ZxlauHkpwUX3C/
         DfA3zi49qsgSy34WCprnXVvyp3HAcVWJ/7CntRYsOtpqxizGuu20WnWEv3eVjOBXatEU
         rRfrZs48oXTa3/NBRRpLuR+QL/MIJg0oo1C97qsvR95nEKUUabQJqISpQJIUG68bi5x5
         MUdIVsLZ2Y9ztFfPVBVp/jf532niXOUFyx8aSCHEkyNz6kvbeVoSnisc4sCvUJeQdMeu
         uz8I/FfXqqvnHCCOtLuzIul/Sd17n/W2QT4LZ3yRp/+IiajPMU1xlgZxhqICJNtsOVjN
         5CxA==
X-Forwarded-Encrypted: i=1; AFNElJ+uUu6SunYW3ISPK1L5+qn6r15XXRh/GTqNCRQUytmPlLdbpe+s7t3oCWfpKZHf9VCS+Rrmnfbq6w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2Q3RdVcuzAPLvtuoimLu+gn63BT4v/kwNpDc7vJCRe8eiWouA
	2e1PXj/ksOT/cLwwiwqd0XoG7WjkH+2HIUBGT9ED8iervqWrOq9HDB/ZjAwkwZ+LmsE=
X-Gm-Gg: AeBDiesP6AlHzFp4x6vVE6UyJGH+r3+HUWc71eOxQqfAuTJhUp6e5ojG730lT7zkswW
	0Wc/CZIDApffjnW/IiWeC5+CfVW4fkMc66Dtwc6rxhizW5nwK9mdubnvqXLl/I3v9l2wYlbl++V
	39Wj+AGP4q6MakI8A8uOQt1mBZqjfWiu4+GHDST+oVmdsZu+srafqByWjRA/O6IFpCI9sHCjGJg
	/9B9PvaJYimAiuCr6kjYWyPLrGDXdSIHmqLAHLhmiyFGON6KfIMaAHevLHZayLJiYgwp1Llgm7r
	GvZgNLoaXphnlVCmmwbEJsSdplG/amviM0IhKwRYTRIcddOfB7xvsvC1Cr/HMF59uz0tpkTejOZ
	yPc6NNqCm+OKmdyPvYRj/Llz28ec6xSYkUZgcfd7mhXc8UnBYK221SJmfST8dJv8b8ifsZ/CQBU
	IcfRItU5KsSGaXdC6Im8m7JEvp7Q==
X-Received: by 2002:a05:600d:4:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-488d68ab2bfmr302762205e9.24.1776351266415;
        Thu, 16 Apr 2026 07:54:26 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead2decafsm12915427f8f.0.2026.04.16.07.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 07:54:26 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:54:23 +0200
From: Petr Mladek <pmladek@suse.com>
To: David Laight <david.laight.linux@gmail.com>
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
	mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aeD4H8P1DiPQoM8V@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260416133004.07bd2886@pumpkin>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416133004.07bd2886@pumpkin>

On Thu 2026-04-16 13:30:04, David Laight wrote:
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
> If it is only cleanup/teardown then the list can be order-reversed
> as part of that process at the same time as the list is deleted.

Interesting idea. But it won't work in all situations.

Note that the motivation for this update are the module loader
notifiers which are called several times for each loaded/removed module.

Best Regards,
Petr
