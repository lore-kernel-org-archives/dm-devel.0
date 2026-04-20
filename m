Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6E313B7AE;
	Mon, 20 Apr 2026 05:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776663882; cv=none; b=itBzLN4UA/uBT5ZEVXFWZ1BWKXjcW+LeOp/uw8XkqVqaw9zSi1wfXhuxRbr8mQJ/NK0s0v+OK9s3OptlVUBRYLRpJBfWmM/Y2RfnjRt09JcCP14I7zRKrHjHkgYzE7VWub0uF5R8Ck1vTGyhL10KOIMZh8qckgqSKA4t+USVX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776663882; c=relaxed/simple;
	bh=xkmJx488oioqlVuBsBzqvzkV5ymXtO1NzGZYZJ9TN6o=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZOf2AHNvTYhH75yx6IzlP41EowrBuL0iesKY9r0GX810FMQijZmkXZ54maJYbuULFSkbcdMqVszox6WLFzLFOs3lYT+mva6xnjU+g+4D3VfhTqTZSq+qoLQJJbhNQZOFhp61tCmaRLFVR1rgOfoNhK6mYESh/q/jd1ECQFWwPnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5kXwHUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5kXwHUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37CCC19425;
	Mon, 20 Apr 2026 05:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776663881;
	bh=xkmJx488oioqlVuBsBzqvzkV5ymXtO1NzGZYZJ9TN6o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q5kXwHULe0trWEeW3PwHiwxYGtKmrwmWyVHVaGSkUoY3z3Mo0/bAik7KYgBHhgIq7
	 quTUXQCdK5BfLEChkYI14e5JXsFGCpWvmTE+wW1Bz6AinJmPQYkeV1Gojt53OvGMap
	 qTj3Ncjit17pKYlm0HroYdtdqlFVmo0KZ/K8H2PIGK1QEykw6Ib4z5u8zWI6gjicEN
	 rrkIeFBWlAj3n5GwnrGD7tJr/aS9NJ/j1Gjd4rRDlXUsAZ4XUaf46iG7dq7K0UOWpD
	 qs5bnkYdCRwClUqH1xONKowKxlWBpz19Lx3F7K4JDdkwljBS2HiPwqM0j8LXwF7Ws+
	 U8TrOa5Lke3nw==
Date: Mon, 20 Apr 2026 14:44:29 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, paulmck@kernel.org,
 frederic@kernel.org, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, atomlin@atomlin.com,
 jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list
 with double-linked list for reverse traversal
Message-Id: <20260420144429.57b45f2beece690bceea96ec@kernel.org>
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>
References: <20260415070137.17860-1-chensong_2000@189.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Song,

On Wed, 15 Apr 2026 15:01:37 +0800
chensong_2000@189.cn wrote:

> From: Song Chen <chensong_2000@189.cn>
> 
> The current notifier chain implementation uses a single-linked list
> (struct notifier_block *next), which only supports forward traversal
> in priority order. This makes it difficult to handle cleanup/teardown
> scenarios that require notifiers to be called in reverse priority order.

What about introducing a new notification callback API that allows you
to describe dependencies between callback functions?

For example, when registering a callback, you could register a string
as an ID and specify whether to call it before or after that ID,
or you could register a comparison function that is called when adding
to a list. (I prefer @name and @depends fields so that it can be easily
maintained.)

This would allow for better dependency building when adding to the list.

> 
> A concrete example is the ordering dependency between ftrace and
> livepatch during module load/unload. see the detail here [1].

If this only concerns notification callback issues with the ftrace
and livepatch modules, it's far more robust to simply call the
necessary processing directly when the modules load and unload,
rather than registering notification callbacks externally.

There are fprobe, kprobe and its trace-events, all of them are using
ftrace as its fundation layer. In this case, I always needs to
consider callback order when a module is unloaded.

If ftrace is working as a part of module callbacks, it will conflict
with fprobe/kprobe module callback. Of course we can reorder it with
modifying its priority. But this is ugly, because when we introduce
a new other feature which depends on another layer, we need to
reorder the callback's priority number on the list.

Based on the above, I don't think this can be resolved simply by
changing the list of notification callbacks to a bidirectional list.

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
