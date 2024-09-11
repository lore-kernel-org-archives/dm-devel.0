Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C01B7917
	for <dm-devel@lists.linux.dev>; Wed, 11 Sep 2024 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726079474; cv=none; b=NX82IX+Wwg7Yq9jYcAYDaK1fNGKNA0IyjiLxnesFqv72IfzsvyrwSjGnC3U1E2ohgVkA0p2d0UkMmXMzziLexcZK4NfOmF4Yd7ZtbMOa2XNOt8ZhoUp5/FuvUqKREojmDhrYCpHFPPkicUrPUvyTkoK2VQGeOslSUFIZsybq7uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726079474; c=relaxed/simple;
	bh=Y3XD4P/sG6CFoijRTJwWwT/dnzev6F/ux8UwYRtnlZc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=J+Z8tpM/GbWjy8If4nEazlfMR2DHtJryObBd3x2OojRc6GTUjlDpHzvaSvbgWWGCnapv3wCJFWwlef1pVPGlR/HUOdfxt0t7viBa16SqP9UFdJ8VggBZ2Vr/alJz45ujZKIZqaxbU757PAuQtFLOitH0f05ysq5Vfn4JV6C71iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pR4oE+GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pR4oE+GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6A0C4CEC0;
	Wed, 11 Sep 2024 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726079474;
	bh=Y3XD4P/sG6CFoijRTJwWwT/dnzev6F/ux8UwYRtnlZc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pR4oE+GU5dsG2rUX05yY+uF9o/JNDU8Xku2noGsZ9c3i7IuEcQgewC7wBc7jBA3dI
	 ajEv3oAEiQsKA10SkwD8MPfOnsWta6wKHj0B/2e0BBIimFTApqdyH3qKNlycHmuGWl
	 PyGD94zg6rUgYarlK1orqsFc0gxJCyJBTubc99eY+CkukHcWRpWVssZHfjUKpMY7P4
	 rCX+DPMPzSFOtSepRcicGO6RBOacZCc43Jpj+zvZGF0YU/mT4o5ZLhKAZp6Q2xnaQX
	 GtBIaYl1NS61aH3fwjz83LGB8Xrsr+cMnOCFfxK21b7wz2mjJkaKW036HG6VnhsUpT
	 oAjeDCx+dPtTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 91B043806656;
	Wed, 11 Sep 2024 18:31:16 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <2089346b-f103-dce8-f1e1-a5af3e2dc51b@redhat.com>
References: <2089346b-f103-dce8-f1e1-a5af3e2dc51b@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <2089346b-f103-dce8-f1e1-a5af3e2dc51b@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes-2
X-PR-Tracked-Commit-Id: f8e1ca92e35e9041cc0a1bc226ef07a853a22de4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3857c7b0411a4e726fb943d41f38676c5ea992ee
Message-Id: <172607947533.1012158.6486343615482628086.pr-tracker-bot@kernel.org>
Date: Wed, 11 Sep 2024 18:31:15 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 11 Sep 2024 14:02:06 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3857c7b0411a4e726fb943d41f38676c5ea992ee

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
