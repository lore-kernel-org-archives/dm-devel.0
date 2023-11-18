Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69A4107A6;
	Sat, 18 Nov 2023 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCVaVugJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DB28C433C7;
	Sat, 18 Nov 2023 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700332607;
	bh=TkYrS3K2fr5ZjxLi0nXsUA0zNkQzAIgLCmMWCzIw6fQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tCVaVugJmedURTNm/koAAGCVM7QVQpjpNmXWPKBWapxiHUj6ByLEGFN1kfCSKQdtT
	 quhNnjOiwYqYELc/qWq7oQ+S7qUntT4MVEQsFuZwnoPUOGTROSUsVrQ9bPi103sKgQ
	 /W9SZI8cKaUjOiUnhZ/GxHxDSGQJW7RV78oAYMiMrSY7w/o6aaZecMRrZB70urPtL/
	 /T36FYQKx1u/K8cICEQbjcsP1BGZVxX0kN6ha/l9jt+Sa4RppPKXxQvs5UE9gU1UcC
	 rbkJO/0oBer8yWUm+1pJ0oBgPDnsnOLK8usQ1MYup8Y07y0t//tfvq+OrezF4gEsJH
	 qgHFlC9/fxy9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50B8DEA6300;
	Sat, 18 Nov 2023 18:36:47 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZVjgpLACW4/0NkBB@redhat.com>
References: <ZVjgpLACW4/0NkBB@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZVjgpLACW4/0NkBB@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-fixes
X-PR-Tracked-Commit-Id: 13648e04a9b831b3dfa5cf3887dfa6cf8fe5fe69
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05aa69b096a089dc85391e36ccdce76961694e22
Message-Id: <170033260732.12341.14175641124209562186.pr-tracker-bot@kernel.org>
Date: Sat, 18 Nov 2023 18:36:47 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 18 Nov 2023 11:04:52 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05aa69b096a089dc85391e36ccdce76961694e22

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
