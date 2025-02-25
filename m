Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F7207E13
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740503574; cv=none; b=JZCsmgxQLkIdFL8xB1H9pGr+oQchNAowb27/7EVO9zRt+kpeT7+3PedrFBWJkY3g6pmfBhTpvgsGtR/bqcnqKxiCbz6J20pThNxjezurQynlO2NhDhxCtWQ3rxt4TKpbRYlGMXq7R8ncyHjTvGoLq2ZuTfw0wewnu2R6emiUkb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740503574; c=relaxed/simple;
	bh=oRo8f+Rf8zGQbC86hRD13ZRsKxEMaOpbz2z/SPCZz38=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AFxSY98txOA0c+nHY+FAjlWxda4CZfKazlTkAf3icP4ojCRiuKkm6hDrq5yuj4gmYgwQyt57/limLrEwq89l07fiPZQ7Ps2Jr3MwpfGbigkRmVsFx9VOJiEZXvqWwb+gdCEWCFUq8vM8Rr7I9KolDOV140paOUjknuCsH2n5GB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxwaTfg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxwaTfg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C4C4CEEA;
	Tue, 25 Feb 2025 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740503574;
	bh=oRo8f+Rf8zGQbC86hRD13ZRsKxEMaOpbz2z/SPCZz38=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GxwaTfg5MW6hwtzJRImoxZl44dx5o/rcQDAZz/Qjg9kHOsBqK4qeqMu7sBvi18pZ7
	 1bMSQMBRrv7dhWJl0vefXzWHV1kWoPcuGkf4Go3M67tU6j7xnA2GZF9riszTvIdWFa
	 yeCgmwhhhHqO+ciC8idOozSZ9Vx5EayWUnlXzNWhRnHa4DnbrqPmj0mF6RP968EYMm
	 gTBHZY9OeUCa/iWxg5LSa4kR0qluHAKufL3MAn+mEs8Z3V4O4acJQPKcU18gI1YAzu
	 rYTTYTjIUF5gcoi6LdbKQdAt609x3T4IY4vF5PDHyPX3INl7jTS+WafyTCKmm5+Spp
	 MIIuijHhrCOaw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0E7380CEE8;
	Tue, 25 Feb 2025 17:13:26 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <21cb8031-3dd4-9cb0-94b3-4be4b19b53f1@redhat.com>
References: <21cb8031-3dd4-9cb0-94b3-4be4b19b53f1@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <21cb8031-3dd4-9cb0-94b3-4be4b19b53f1@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes
X-PR-Tracked-Commit-Id: 36e1b81f599a093ec7477e4593e110104adcfb96
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2c24478e5f6e8a1060f5ad2f52210549a4819204
Message-Id: <174050360555.52791.3683607481999628046.pr-tracker-bot@kernel.org>
Date: Tue, 25 Feb 2025 17:13:25 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ken Raeburn <raeburn@redhat.com>, Matthew Sakai <msakai@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 24 Feb 2025 13:48:54 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2c24478e5f6e8a1060f5ad2f52210549a4819204

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
