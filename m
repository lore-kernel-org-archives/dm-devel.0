Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887591;
	b=RKzqZhvRnqXHdxu47BijJ58IyqKnlGmQhtuhjlMJEsYVnnj67s8OstpC4Rw5/On9QJ7y
	 Om10hZ8/K35CUY3+FiJAIi6PBoVm/U7hsL5sF8d5Ed+W8rrUUjQOaY8GFdFttn4gO2Zit
	 RypbIMaBBntzorNeO2+1uiQ11324QoYTvLIVODiFm2Zz0Gt4iIYJb7FibeD8ebFJhHUKq
	 O6b7cHuv3WbjgHugba0/QWSkogzjOYVfbjdJdZHyJmKxdc5moZJeCeJLglLhRjgCnZhpR
	 yd1eUHkA+WN1E+HrGzEBj7rkwbE0V6RHcb/fzWOsC44JDUpfOzIf8Os18MYg4+aJKPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887591;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=RWFOpDHwqFOjff6tqSiabnl2BTN+1//6A+JnKiErkBM=;
	b=FetJSaXvgZ0LWScaiEQR2RFesbuIfFFTxukrBBcOXA1E1u9VD/qjed8jLUfyVO54FpFx
	 gpHK7+G55SnodaNcXe+B3emnjTrUCaNsSgbI0zyQOSe10Acwpp5EdwS56G8jxGooEy/am
	 3+UbI+QClHfPE6MvmUtlevmYttAU3tFFSmy8inwdujDsFqAkOsh2NwPh5YB1lMf2pcqIN
	 HXHJIvhV8tUnWYiOLvH4mTslVtqAWOg0v3u2uFq2vKLS0Gt04YVFj+KX6Zn+QgCaJMA08
	 06x154n2Nz9goKzVB67MMICGwWOWfxhc23gUAUnGLFJdMXAasjufetME8Wyp8VGkovg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="T/cYgx3+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAC606A31A
	for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T/cYgx3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D291F01828;
	Sun, 25 Oct 2026 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887590;
	bh=RWFOpDHwqFOjff6tqSiabnl2BTN+1//6A+JnKiErkBM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=T/cYgx3+qnqi/M3Fe/hoB5UnsiZMYkvxfk+bOqmb9A5AD0YXvD2O4JZ7HqjbNGIH5
	 3XtmwcFpSrNVh/oP7LgGpqCd53h35Y3j1SyoJ6rP7nthbaVbzScDqv4ECqe/3oYepl
	 PFekQwYXNvk8MleO6c9yltSU+TzRrcJ3fKBIwzqDUZzhqyDY7/A2KINyq0KJGq7Lty
	 MKLyKgHvwYzMrJIIHjZWnp1wSph0TXmdOl4rQMPOK4S4YArlKPDSVc6j1kpeakSOvN
	 FK7ZzK2OBt0jwJ+VZRCAaPQQhPrylEsUBaOdBXNNwXeUJ6R701GyL+Yq3d6hUZVnvq
	 xRhelBr/ocncw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE6CE391B1B3;
	Sun, 25 Oct 2026 00:19:50 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <c19c2552-cecc-43ae-b6df-0d50edfce764@redhat.com>
References: <c19c2552-cecc-43ae-b6df-0d50edfce764@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <c19c2552-cecc-43ae-b6df-0d50edfce764@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-changes
X-PR-Tracked-Commit-Id: 334714e4bdf8868c17a7650a7502ba1c90a8721f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 696e75b3a616649cf50a63b1d7b816c8e31b235c
Message-Id: <179288758921.1837419.15049439334383379048.pr-tracker-bot@kernel.org>
Date: Sun, 25 Oct 2026 00:19:49 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ayoub Zaki <ayoub.zaki@embetrix.com>, Benjamin Marzinski <bmarzins@redhat.com>, Colin Ian King <colin.i.king@gmail.com>, Elouan Da Costa Peixoto <elouandacostapeixoto@gmail.com>, Fan Wu <wufan@kernel.org>, Hao Zhang <zhanghao1@kylinos.cn>, Hemanth Selam <hemanth.selam@gmail.com>, Henry Wong <henry@stuffedcow.net>, Itai Handler <itai.handler@gmail.com>, Matthew Sakai <msakai@redhat.com>, Matthias Goergens <matthias.goergens@gmail.com>, Peng Fan <peng.fan@nxp.com>, Thorsten Blum <blum@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

The pull request you sent on Tue, 20 Oct 2026 15:55:03 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/696e75b3a616649cf50a63b1d7b816c8e31b235c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
