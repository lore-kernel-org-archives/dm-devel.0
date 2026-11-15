Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794781799;
	b=F0wEnX4lYUUVvEq6otOQx1p20BaAZbgHWT8kz9uSLXmMqXzf0BzDyUxVo13SNCDtc75H
	 RXISaCTSC2io60wwFMQTWT329wJNkfZTvY9saPHAuWpOspHXODkUutaUhw14ZtZicQNZq
	 FRA2i1h2Y4E287EoSxOEKCPbkyPMtBswLjqIiV71KkRcF6ulFOlfVw9Gc0mLhDj6l8BPk
	 8gB6Md1eF00ofYk5d7OU7BsHDUIGedsGsN2kxHVWcPQ1q9irUQix3hHHrhHAU4BjzW61c
	 Vu9Vbqywit42bIR3mHmz8h2sWXFbUNP0pqxC5GvMubsGfFQjrn9KRmKmn8V9MpzBWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794781799;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=o+10pti+x4snul4ibKYKRNasEIh8tgYYEo9ooStnrPI=;
	b=UJTXLoKgRqBXu4uf4IXCRTXEAtgz3ruqk+U8qUxIVpGFAJhVS4vYcI+AN4/jlAW1bcXr
	 unxqXcyOnrJc3GKJIVzchzsKXgjqknpAvKzYhNFpVo7YXdNg82Gg1h/BkFTchvtq5LQye
	 XrWAnyUynsbpFwaz7RnkIUgvbx1wNwoc1goJY8oKRQydtpCCnkx0NtRLmmo+XBzwzGK6n
	 IjRq/FcjhihNLtwy688LwJYo20+buB8LjPDiSYr10YnUsnsKPqhBgs6crKz1PHazvoh4U
	 IPTRoG5kuCUHT/GMA1pYxn3yygNxOZQh0Z0TtxxRLGPOtzirjOOnes1B6pEt5WoZOSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GpiyA/yb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB2E606A32C
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GpiyA/yb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B381F000C4;
	Sun, 15 Nov 2026 22:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794781799;
	bh=o+10pti+x4snul4ibKYKRNasEIh8tgYYEo9ooStnrPI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=GpiyA/ybAGZlzpKvoHeh2rIvkEVMBJIm/90rJlnzdP11qdrwaLnJQhWMy1etqJP9D
	 eK6aedup/0KnVKN03SUtSt5IOCP7x4NtURtT6bkjBtzj/N1wygT+Hq2mzUlmXnSESx
	 l1BdFfMQe/TDYO3gGmiLhtgsUwkcBltaRVb179aD0o1YX3ik5LH/DTgcUoLcL6/bG5
	 4qjGG0zc/JYeO5aS4/OyJL+jyF+SrBTLGO8vN6o5mLmpqTam7NzgXDEa5kKHQOGNeF
	 kPHI179NRJhAbX+ExTBEelIdAkK1uUfcA12M2LZElztaGmu5OgnmTOchZ3c1ub9DZ6
	 8dYF9Adl7KRBA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A51D380823F;
	Sun, 15 Nov 2026 22:29:59 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <44a2bbbf-26a6-931b-68f5-decd011ad19f@redhat.com>
References: <44a2bbbf-26a6-931b-68f5-decd011ad19f@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <44a2bbbf-26a6-931b-68f5-decd011ad19f@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-fixes
X-PR-Tracked-Commit-Id: e92cd41e8e5ee5616c6c7cd4378661d942f0a7c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 87aecd24f58e15256870befed777bbffc5d4a9d5
Message-Id: <179478179782.2784423.3463580905639413494.pr-tracker-bot@kernel.org>
Date: Sun, 15 Nov 2026 22:29:57 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, Daejun Park <daejun7.park@samsung.com>, Edward Adam Davis <eadavis@sina.com>, guolingxing <guolingxing@tju.edu.cn>, Chen Cheng <chencheng@fnnas.com>, Jay Vadayath <jay@artiphishell.com>, Josef Schlehofer <pepe.schlehofer@gmail.com>, Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>, Kyrylo Biryuk <illofspeed@gmail.com>, Li Youhong <liyouhong@kylinos.cn>, Mark Bundschuh <mkbund@amazon.com>, Ming-Hung Tsai <mtsai@redhat.com>, "shao.mingyin" <shao.mingyin@zte.com.cn>, Sinan Polat <sinan86polat@gmail.com>, Weijiang Zhou <weijiang.zhou@unisoc.com>, wuyuehong <wuyuehong@cmss.chinamobile.com>, xietangxin <xietangxin@h-partners.com>, Yaohan Li <shunsheng1218@gmail.com>, Yingjie Wang <x-professor@outlook.com>, Yingjie Wang <1075151112@qq.com>, Zhao Feng <zhaofeng2@cmss.chinamobile.com>, dm-devel@lists.linux.dev
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

The pull request you sent on Sun, 15 Nov 2026 13:30:46 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/87aecd24f58e15256870befed777bbffc5d4a9d5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
