Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82D2BFC60
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 20:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783801403; cv=none; b=FX3O7Hs7TtPymw4zdMefHwIovQxuYW83nOqe2JZ76YXozHMQxd2k74A2ikHAtMUdUbh++axVP/M8jT63GdJPuKOJONsaX92XYcxm8BWMGyLy6sRMQpH0u4ExZKaBDx1O4iAWXW+Yta7pR7o7rWvOYhjaaJIKKxY3OCjaWPin4C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783801403; c=relaxed/simple;
	bh=4NKseYW5kuWupETFrVpQ9a7F81xNWaCBBffN+h5R1PY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ly5IkK5s09qQ6JygeIXxDozH87mBmJJdyAapiI822JAQ8hf/JtYY81vMn4TOMu12bNPNypefGT7kQeTRAJx0nIYzLauw4yvIFQoKbh8blHwhyfAT+/i5Lm5kcWALySrZd8nqSwPqgU214hVZvGleeyHBtf2fa5PPldYBs/d/Q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfYPmHI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfYPmHI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537FF1F000E9;
	Sat, 11 Jul 2026 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783801402;
	bh=YgQQ0Pwpx5BDsPfC1DbbJkQyFLkTSN17pp8tpmCXCcY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=KfYPmHI0/MdzmedswDsEQzRz1abdMFGvpSSOryEd+ZayMqaMRHqml7VmM9BR0iSoD
	 9bzyvkcJyAgJcXzG60VlgxwQ72/OsMutl/+LWDBXJJA0yMgUyu+WWhGvSiKHivpX79
	 jUakLhgwA22oUpSij3a/UxYelO513Xqj+UHq17dqZHICs4wpWqDq09k+2S68ZsqT4F
	 i3taR14GfjkG5rEdZQzwipcFUCAQeo3/HtA0LFHl0/kOSb62YHCXHFDmL7Cw1amXDq
	 xdM/ocX8GON22R30BWZXChuQFuk/MvTweH1O5KrFbGcMwnZBb/1sflBwlzgQ6XEr5D
	 nRFvd94ucSiHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B173924A12;
	Sat, 11 Jul 2026 20:23:00 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <624cc8db-c745-7cd2-846f-efbb6193aa33@redhat.com>
References: <624cc8db-c745-7cd2-846f-efbb6193aa33@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <624cc8db-c745-7cd2-846f-efbb6193aa33@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-fixes
X-PR-Tracked-Commit-Id: 4b22d0801fadfcae2e106e6ba32e49439c7c7ebf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 59dee6d28756c629f3a0bb56266f80e36ef7c99c
Message-Id: <178380137888.1201396.6008953348142901602.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jul 2026 20:22:58 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>, Cao Guanghui <caoguanghui@kylinos.cn>, Genjian Zhang <zhanggenjian@kylinos.cn>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Ingo Blechschmidt <iblech@speicherleck.de>, Ming-Hung Tsai <mtsai@redhat.com>, Samuel Moelius <sam.moelius@trailofbits.com>, Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 11 Jul 2026 21:37:42 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/59dee6d28756c629f3a0bb56266f80e36ef7c99c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
