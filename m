Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F5359B6E;
	Fri,  1 Dec 2023 21:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4O9BzGm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6F94C433C7;
	Fri,  1 Dec 2023 21:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701467384;
	bh=8Nm2KSdwwXhRl0bpR+53/0P7krba9PAQmX8zBwyXn+E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s4O9BzGmQ4wsBLmlmCtTLuk2AsFQB6dlHYUicfVN923xfu6BdXgusqFb7veNfKfXJ
	 ie51iqrxqyBp8OlIkLgpEglPX05/LCdvl/+LYay+2H7pBt7ZRB2uSL8Vk7q9KPf+yC
	 KE4jrO5LatQwscGLaJryTSThDwxpkCT1TXf+YSaXR2T3EiSp6kUAzmUjK8vjT3t6SY
	 65g/5UuXzkeMO5RB3RtnsPwa5dktMQl8gKglL0muVG0ljMqabj3W3PKQm/Uq2UWmTU
	 avuy4CGK7fWNS9ukLMIWAPpzNm4ook7Ol6WtspUfN0zvD7k2SJem6LTKTWS7Q/W9sz
	 t3OmQJ7FREILA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A4CDDFAA94;
	Fri,  1 Dec 2023 21:49:44 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.7-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZWojiLENEOmcKFCo@redhat.com>
References: <ZWojiLENEOmcKFCo@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZWojiLENEOmcKFCo@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-6.7/dm-fixes-2
X-PR-Tracked-Commit-Id: 41e05548fa6b069a2b895cf4c7bd9ad618b21e2f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: abd792f330fa328e8f8c30f3e32e609006c846fc
Message-Id: <170146738462.2332.15443873252372891912.pr-tracker-bot@kernel.org>
Date: Fri, 01 Dec 2023 21:49:44 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Wu Bo <bo.wu@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 1 Dec 2023 13:18:48 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-6.7/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/abd792f330fa328e8f8c30f3e32e609006c846fc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
