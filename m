Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460F4189F5C
	for <dm-devel@lists.linux.dev>; Wed, 17 Sep 2025 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758134289; cv=none; b=EsYT4NJaKGLrcmlGL1xdEDoRwUydfb74dPkIuifMT39iE1aHO1q+tuBMewZsxWD2yFoqbbsE79sgeiaZbNvz1Ktg3nHexFV5FAdLtORRi6VjLEzxcd19eA0h9j7YresvWe9sHRZqV7VTsSlxiWCy+lNXWyBAdv3IsxJDSj8yZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758134289; c=relaxed/simple;
	bh=mOw4LgccH1c2scrO9Uz2gG+CB5qy9XjNZm7pwDi95Rg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Bgl9RG7COR4f6u+uBHqAxXwI5FPYoo3MQMky5WJyMD8F4o4ulB87d3gbnJteuhiYt3k1jVhVXV/r+LQZJx1MtlUYEjJz4/bv0fNEgkLoWDbOT4LmV4R0Ss6ifGLQiMem6JXVb9KPi7WeblrayRI/8EiK4QaQP9TVjw9CDqhcgt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8ohp/XS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8ohp/XS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297D2C4CEE7;
	Wed, 17 Sep 2025 18:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758134289;
	bh=mOw4LgccH1c2scrO9Uz2gG+CB5qy9XjNZm7pwDi95Rg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=h8ohp/XS3CbSr0LLno7cC5WuUBoM78VItCuy47Ebwm1uZ5LzWvutImUE2p33pE7Cs
	 ulJqLnZZE2E5vx3q9V8BazDqXwNJUz9vQ/8j7g0R32itoca4FvvGvGo7sA3W9fCbiV
	 Y/gAYg2gKhxnoFDFVwcOXVMbmK4jbiOP59yMUM8t4G1295q4SmbfKR1jABvQst2FvJ
	 1tMWVmedN+1GmBjT3b+kf9wLiK382guNtDyM4hXetjwNnNsd6PtUoJyvtIbIqYmqft
	 WCK9vCeKYQnAvhSAy/L77yb/Ewabka49Pwv+wqGthuazlkXn4jy+WjuilETojeZoeV
	 ZLmkJ9P3nPqaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF0239D0C20;
	Wed, 17 Sep 2025 18:38:10 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <26358e47-e03b-82f0-5bf6-2cc2db3ec8ef@redhat.com>
References: <26358e47-e03b-82f0-5bf6-2cc2db3ec8ef@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <26358e47-e03b-82f0-5bf6-2cc2db3ec8ef@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-fixes
X-PR-Tracked-Commit-Id: a86556264696b797d94238d99d8284d0d34ed960
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4b779985a6c853be5693fa6e8994034f8492abc
Message-Id: <175813428961.2102736.6889495205910272372.pr-tracker-bot@kernel.org>
Date: Wed, 17 Sep 2025 18:38:09 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 17 Sep 2025 16:16:18 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4b779985a6c853be5693fa6e8994034f8492abc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
