Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9357216A01
	for <dm-devel@lists.linux.dev>; Wed,  2 Oct 2024 19:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727898738; cv=none; b=qH8xr4o40f+OEDa66TTXRHCpTgEnkktHyIjV3HPpZrraXJQImHaVUz4SN++YBvzxL+1xIrxqmWoJIPktgSG0BW3M07P6bvVBOzcESoXCQKJRxzWlV0E096EKEj5rE09E7LeH6w37JqtZ5BUf0vQEnjppvEvhgWSBKctrAY6Nd9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727898738; c=relaxed/simple;
	bh=zjd+lwvWbqhd17TjJLPZNy5SEViZPBaU1T3q9QkrcD0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=k18KCoQyJjx4qpUQPSJGcVdtbfzcE0YNP+SymnCmPPTCk8XxVJLHPARE8AsoBEyDKxLrGk5DJdZrRq2zW7R/+uE6o2heKtRd2/vzrve0URZ535Q9xYYuEmDBEt8ZkRC83zMdLA2allrVVCEHw9tF7JKHYpsXqjlTIeEHSMj4nOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYUTOBJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYUTOBJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA98DC4CEC2;
	Wed,  2 Oct 2024 19:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727898738;
	bh=zjd+lwvWbqhd17TjJLPZNy5SEViZPBaU1T3q9QkrcD0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fYUTOBJVTKiF0hho6vDHnahka5FDiR5c321MkSODhDcCJjc/Y9i54heqZ2RiNEWw+
	 xiIKN4L442hOvBKg6IzDVDhtLOp4OrxLjlCw3OnY31y+kufqnnGSTmsr7x5SL9hly5
	 iw0ZVm8ipxPbhpoytGnwuL/ndkzg5Pidx+SGDpI4iAlNVCuh0IhySq2PCoUj/VeJTu
	 p4MOhh+WPG2VD4a1Qlfl5eYBrghisUWTwXwzNkmkfMj0Ck4wZADU0Lsd5qmM/kJoXD
	 PWV05WIILIY0cz/XwVqv9MousIOSfIajLx2G8lNYE1sRsIj/KX2X9kVsz/8CVWLFHi
	 En8YR9wl4CS9A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3572D380DBD1;
	Wed,  2 Oct 2024 19:52:23 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <2790bb57-22bd-f146-570b-9f4956838a6e@redhat.com>
References: <2790bb57-22bd-f146-570b-9f4956838a6e@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <2790bb57-22bd-f146-570b-9f4956838a6e@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes
X-PR-Tracked-Commit-Id: f811b83879fb6717cdb288e34253cf26d135b019
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 359cdf5a328360fdc41e5ca979f22625f4aceb44
Message-Id: <172789874169.1292614.889729422000820385.pr-tracker-bot@kernel.org>
Date: Wed, 02 Oct 2024 19:52:21 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 2 Oct 2024 16:42:51 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/359cdf5a328360fdc41e5ca979f22625f4aceb44

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
