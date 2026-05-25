Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391813E02A
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779739380; cv=none; b=itWiH7Nx6OYGVQybARmqnIV5MbVAfaakpctzKXNy8P0L/oEJxgE1E95DSSsDRyswYkJQ9Ra8nnieRNLo/fay2XfodT5VBqAUZLoVt9RITN5a+hYvn2AIU9gPcLZvrG8bQdTFqzBI2ou0h0UGY+yXgvtUp0+TS1+vs0ZdZBgsMbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779739380; c=relaxed/simple;
	bh=V2A5P9CIA0BLMol6RiC6R3X3DQeAqrhoZKx3aI9o6h8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Gv63+Esd0+l5mIdNbwStkAkaFqgDi4TuitAlHjNvD/HrXuz9iZSwQUeR9cm+mCzTHydRvc+kwWzlMqUmRE/ZMZ1yLEtXDVH+6Jhjs9uGTkBICcxbXy6t4cSrHNLjHyiF17TkTlIxt7MuzntUOMJ5kw1FQpKr4vfgL2jefSa8DVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrdTSHW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrdTSHW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A171F000E9;
	Mon, 25 May 2026 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779739378;
	bh=CRRY/ds5KA8TUNEBmw2o8/Ir/mcgdFaFdaKiroIxas0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ZrdTSHW1878ZXX7+KLWr0Gqxz1Cpl+w9uz+9/rjask24mPGJjgVBFe4EAUbHoJtj5
	 FFKRpiIo70btDsCSiuQkKLhhgLKutjIIOwl60XtXzrkjzkp02Ixchc9MGnwgigNcIg
	 6pFMIua09evuVyya0LXgN3Ii5iNeoc0JjLLnlgRJkNWUg/RgY1iPFpg3pk4Gexy6Uz
	 FyXapgwFj34rziybDzdtFssPXVDIXkHmx+wJd7oMY0kosDZklN4H/HgS/5DA6n7kiN
	 rnJKnKcNRHskG7ukP8o91wuqtbBsXThw2kZcKh9fvPy7WoQieGngIJQqwCcmOm8q5o
	 hlHm0FLwp+LcQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93E2C380AA76;
	Mon, 25 May 2026 20:03:06 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <2e3844a2-d5b0-f365-60c8-6a1e0d856b5b@redhat.com>
References: <2e3844a2-d5b0-f365-60c8-6a1e0d856b5b@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <2e3844a2-d5b0-f365-60c8-6a1e0d856b5b@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-2
X-PR-Tracked-Commit-Id: fb7415f2ab0e3c818254cbf5fb0afda71bef4333
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13e4d2579eb34e9731bcc5ca73205708355e5d99
Message-Id: <177973938523.3099881.14248004270507716095.pr-tracker-bot@kernel.org>
Date: Mon, 25 May 2026 20:03:05 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, Bruce Johnston <bjohnsto@redhat.com>, Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 25 May 2026 14:34:01 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13e4d2579eb34e9731bcc5ca73205708355e5d99

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
