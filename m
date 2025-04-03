Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5D1494D8
	for <dm-devel@lists.linux.dev>; Thu,  3 Apr 2025 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743659180; cv=none; b=pdNqj3zBq9VWHQ3PtcZ6qLHg25imCSL5mObIpzfU+AeZBWb4HzJ7lMQaqSAy3cKkp1q2s0tpAoYteWpfjm0u4XFrutlP/IgwO3chDIsWO9s7kHQ7r4pEn/MYIl590a0BxuBMCET+J0t8S7AOWWKhc/R7zCidnuhGCHub++K2tqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743659180; c=relaxed/simple;
	bh=FoTNZPf7I9d8NeearJpS+BlWyqNmP6yYojQWlZBv/rU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OShzyDBVaz/j0+49xyPAh3Tbxi2GiHTpl9MjLgNrv+Y/aU1H9LHATemyKPSEdCXAX+N5lu9y4pHYt1dKJWZO3ipO+YtcsXMLO9EPdqBsTvdCDeDkM8GwUEneTRweIRfaDw7jo6FYj9qbL5eDG1sbuYNJNL6dTVYjOa5GhgWAW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6zvTpYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6zvTpYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F34C4CEE3;
	Thu,  3 Apr 2025 05:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743659179;
	bh=FoTNZPf7I9d8NeearJpS+BlWyqNmP6yYojQWlZBv/rU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=I6zvTpYUicONBw2yOoR9+KU5sRYXA+f5VIunMmAB2b0BNUe8o/+KFPl3XWiGaixea
	 a9p8+k9NGSU6Cup4q6WD62GE7F3LbHRAx/XDpAgiLsDJM/Idrn0y1ar2Bd2jxAx/Jc
	 7qhGt3+CMgxParryRlroVa2Jp07M3KxKKSNTydFAOvcpxT0bCE2RCIkMbsZ+lKT/cg
	 71wUnirqKU7SB652tFZyNHU69ZUq32+lsoGymz6Sz382X/ctYA+rCUJfxARXWvGtQJ
	 ewMz+OzsRbEu1AHCqdjKJGsKBoRYwnpCHOWpInDeczYSvpuP6eHqMMXMVHGPzZK8H0
	 L3X2iGKQ21Rvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE71C381090F;
	Thu,  3 Apr 2025 05:46:57 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <c82a1392-624b-ecb3-1b38-008e8653ab9e@redhat.com>
References: <c82a1392-624b-ecb3-1b38-008e8653ab9e@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <c82a1392-624b-ecb3-1b38-008e8653ab9e@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-changes
X-PR-Tracked-Commit-Id: 9c565428788fb9b49066f94ab7b10efc686a0a4c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5014bebee0cffda14fafae5a2534d08120b7b9e8
Message-Id: <174365921629.1797294.12325023446032825.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 05:46:56 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Ed Tsai <ed.tsai@mediatek.com>, Eric Biggers <ebiggers@google.com>, Christoph Hellwig <hch@lst.de>, Chung Chung <cchung@redhat.com>, Jinliang Zheng <alexjlzheng@gmail.com>, Jo Van Bulck <jo.vanbulck@kuleuven.be>, Ken Raeburn <raeburn@redhat.com>, LongPing Wei <weilongping@oppo.com>, Matthew Sakai <msakai@redhat.com>, Milan Broz <gmazyland@gmail.com>, Ming-Hung Tsai <mtsai@redhat.com>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 1 Apr 2025 12:24:54 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5014bebee0cffda14fafae5a2534d08120b7b9e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
