Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091538656D
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 07:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596485; cv=none; b=PQiQQy+XaORpWboEYxiMYYfChNM7qrctGasqLQHIAJEYec6P0FKXFPX61UMqaiHmkry9nxoiL/Ra0rqdVm1cZU3c0Bp03FLRpSc/sP4ID6zdF3l8Sfbe9rYeIxDAyE7mUiyvFlFrf5sCoBnzlMIBMa8G5K+hjU0/WFs/JPq5rwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596485; c=relaxed/simple;
	bh=Ii0wCAXik7KVsX1G7csbsZZ+il3f1bNVN66fzC5kA6Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AEPiCKy+kVhwAO62LDeMz6zV3v6BL2ebNJNhMue7JkjPSKYJvTNwrU/sn44nfYAWqPPiaGaXd7qHbUxqCevRn+yX2yyeNrZEekd+JWdHVh3lVGIEZOpptn+7CBugFAVgSJwF9g+5sQ4+q3eWTQSkqeq2pVamSm7jCSuI8LE5mZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMO+Rj5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMO+Rj5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153BF1F00A3A;
	Tue, 16 Jun 2026 07:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781596484;
	bh=CQFX5P8Wp4YT2wPS/LxQWQfNiRud3smgDZQeNGah1sU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=dMO+Rj5LEWyYo1HssfcfSyewHatJcrUm09IqjXutUmn4FRjDsorT/gWbQA5nfmqSX
	 AywjBw2wPgQ0hYMK2MN6NqQpYI/HEiME8HEpwaPSrXmAXAXh/MgO2tA2EhZcl9bKqB
	 Z/PN9Iq21Owh5CiW3Fa0sQkJdaZP5hB7QFf/p+S0wyGF413Rce5nKGJdEKPiMeVZsA
	 rGHajrSrrz18Td93C53yqB/LMDElSkR2zHQfeG2WzuMyNm0ndyMQsqbWjvRgCtYilA
	 sEAWkOg7TRsbAJipQY4VBNKwDjEMzZP1AkXTfwldLwLFXj9QG4iMyGMw3arBHSOLDJ
	 HulhvrgWEpP5Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A25383BF68;
	Tue, 16 Jun 2026 07:54:40 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <60192373-6ffb-86cd-145c-0fe82b05e9e4@redhat.com>
References: <60192373-6ffb-86cd-145c-0fe82b05e9e4@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <60192373-6ffb-86cd-145c-0fe82b05e9e4@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-changes
X-PR-Tracked-Commit-Id: 55c99f2d901c783c49dddd98f7c05d98ad834ce9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1cbabe84ca1381a004fb91ee1791a1a53bce44e
Message-Id: <178159647859.515891.7401929159021094534.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:54:38 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Cao Guanghui <caoguanghui@kylinos.cn>, David Carlier <devnexen@gmail.com>, David Laight <david.laight.linux@gmail.com>, Eric Biggers <ebiggers@google.com>, Fengnan Chang <changfengnan@bytedance.com>, Linlin Zhang <linlin.zhang@oss.qualcomm.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 15 Jun 2026 17:26:21 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1cbabe84ca1381a004fb91ee1791a1a53bce44e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
