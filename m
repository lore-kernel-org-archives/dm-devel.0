Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075571754B;
	Fri,  2 Feb 2024 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706906611; cv=none; b=HEN4YYEInJz7IQ9kuzY2cKexpnf4LMa2pzegTWyHhKCDwH7GNHJSESWEQKBqyU5875kocqTF63q2CSxVBXFGkabwXoHWaFhA+xqk0aYJ/zn/BSfUp3QNga6NlioQkV2Iw9AI5e0y+Vor3TQaLCEbIaToCMZYvsuQ1Y7hvXCW4V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706906611; c=relaxed/simple;
	bh=DLuDMpCPPrKDyYAtyBFK8Wy9rQ6rfmQJ25hjH+ShDBE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OrBQe3yn72Guw7Ehy7CpRl1zkEse/qDrQ5gZsPGYc+GVT1qzmaUnlwJr5PzENBGnikk4G2pyVZKTBv9HPBd+K+pnO6Q1MNALojQs4EjoWo8Ji6jmymL/NnwkOSRPuVrQVe7whIPymfs364rGwzI486doJeGvVWas135m0G2GvfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU9FLAnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU9FLAnh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCAD3C433F1;
	Fri,  2 Feb 2024 20:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706906610;
	bh=DLuDMpCPPrKDyYAtyBFK8Wy9rQ6rfmQJ25hjH+ShDBE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TU9FLAnhSHsc/n/vawBb3CUCGDmgzFkBauF8awEQxpoP/q68F9vAkWB6eVpIOA2ok
	 BKcYLCcGDlZsaltjOThdFCe+lC2mLSgk79tmjhxGIOum+2v1u4yKWrTJZCo3Cm7YsW
	 vgiWhwqKL9S22eonLdJW2aX/SEVTEDiRHVsOw9039xjgga+J9RWx8tf6y5dsmLhEh2
	 YJyIfkQPRWp6IpKc2z4ux68NQvSJ4+5qwybGpLvrnGrQoRLcsvo5R+XqhC6Hl3e5Mz
	 xPoXGSnhDIVcUXdhUl3KAOUMZ7+TQI7glccFXpFIRxRfx39RppzticOFi6WIBKB/jc
	 UIttMkoSKL3LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAC83C04E27;
	Fri,  2 Feb 2024 20:43:30 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.8-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zb0txmt9K4MMHst3@redhat.com>
References: <Zb0txmt9K4MMHst3@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zb0txmt9K4MMHst3@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fixes
X-PR-Tracked-Commit-Id: 0a9bab391e336489169b95cb0d4553d921302189
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6897cea7183762b4bc97b0ed1b75274ece9d518b
Message-Id: <170690661069.32059.3542305549821282474.pr-tracker-bot@kernel.org>
Date: Fri, 02 Feb 2024 20:43:30 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 2 Feb 2024 13:00:38 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6897cea7183762b4bc97b0ed1b75274ece9d518b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
