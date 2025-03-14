Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001F1DFED
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 21:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741988106; cv=none; b=mMzkv2nqd97MukIRDbhg4rxosPLEUObhunIJ1pLx0k1ZmTIoVAH6Hdbg5STR/tbHj2UcXKOV4X9ZyTEv9ODQSI1gviXhA4TI9/tS44PEPiSLwRsN/A31F5we+IAJlRJVxH6mkceat6BXW8kAZ9GXGObmlgYMEkMyJqq17R3dCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741988106; c=relaxed/simple;
	bh=WgoOL83A8CWredtDiKphDJ1rFM1pHRhX2VOdKtAQLd4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TD283sM1S9unOU9e2D8XlZNyw1z86tVSvAJ6oOBzzq/45kzY/DHZZkb+JEUrCpiWH4D5DOwDqOgqO9vHJulrPAHVV7idE7f2y7aJiIUNrekd8TMXspigpXaWRLcHFqkiwSxOHXTH1ynIXRh7ZeYYSgwQxqc5ZbryPdSebK7MZrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjBgRWk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjBgRWk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24C9C4CEE3;
	Fri, 14 Mar 2025 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741988106;
	bh=WgoOL83A8CWredtDiKphDJ1rFM1pHRhX2VOdKtAQLd4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GjBgRWk617sW4vcJbe525tYMShZXfnGlvyah2RVEyo1W5r5SvsgfvccgUIYNftR8h
	 L4iYAmXWI66p/Tm6g/USD816GE8XFeXq5nwBPGoxqnhnryzCwK35tegK5Cah221zbc
	 SqESUqCMFDZq3GMHk71krwJ53VHe7L5OXCmeJmoX+sUcS6QTRTJQkV1i5qNO8JREA5
	 03sofXUqFouRCvjYUFvWXSEATJ2pEYjeNynvvhGg+AcfWChHqtwcvXNTx5ye3BPO0g
	 4ay7yuXzep0S1rpobKOeWYtfHoXzChkPDqmCGuAovU4KTT8b6HFW6xL757pZdNzbks
	 ipPxqRp+EX0zw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1DB380CEE2;
	Fri, 14 Mar 2025 21:35:41 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <f965255f-978d-af57-50f5-fd3942edd570@redhat.com>
References: <f965255f-978d-af57-50f5-fd3942edd570@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <f965255f-978d-af57-50f5-fd3942edd570@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes-2
X-PR-Tracked-Commit-Id: 57e9417f69839cb10f7ffca684c38acd28ceb57b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b35233e7bfa04045388967d3dc219e80cc88bc74
Message-Id: <174198814057.2391063.17804644400830418837.pr-tracker-bot@kernel.org>
Date: Fri, 14 Mar 2025 21:35:40 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 14 Mar 2025 13:36:53 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b35233e7bfa04045388967d3dc219e80cc88bc74

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
