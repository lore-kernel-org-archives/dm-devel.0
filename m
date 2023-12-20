Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89039487A9;
	Wed, 20 Dec 2023 20:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jghUCq4x"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A3D4C433CB;
	Wed, 20 Dec 2023 20:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703103192;
	bh=WbGwXAvqGOP3h5/gLrPtlOOHkYDGIuqOGejmanazRmQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jghUCq4x0NBdKgUd0NQLG7pvf+8ZoZsHcg3I6/Lmah/N1vANh5OhCH6yZ/W1ZB91Z
	 qfz4xMI5Snhw3+oxB+FiJ74++TngmDNMSM1gWSZOu305P1VqBSsFVEhSW0RPMgL2wn
	 5VSsVpdCCC5om9z8t3LukbSm2Kj05lQjkc6Qtleo7hS/q7VGBslg+bF3OCa5OeUBdu
	 ECLh4bWOjJe9mv66pChP8FVMUm5NNvV5cIWYX5Fn6aJpofOaZN9NDplmr1VMmz3Yih
	 wmnNmVWDlAtS/V+P/dVe6FlPBELGAGJPfflUw+xznsQjMbKHedUGgPVKWcj9QjJ32i
	 UMw8c+EX6oA0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4362ED8C985;
	Wed, 20 Dec 2023 20:13:12 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.7-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZYHo0kWJ/abSbCRF@redhat.com>
References: <ZYHo0kWJ/abSbCRF@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZYHo0kWJ/abSbCRF@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-6.7/dm-fixes-3
X-PR-Tracked-Commit-Id: 5d6f447b07d5432686ba69183af6e96ac58069c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a7a93d96d124bf252430090b15feb4239bcf752
Message-Id: <170310319227.16038.12458478712789685201.pr-tracker-bot@kernel.org>
Date: Wed, 20 Dec 2023 20:13:12 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 19 Dec 2023 14:02:42 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-6.7/dm-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a7a93d96d124bf252430090b15feb4239bcf752

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
