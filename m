Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738C854789;
	Fri, 22 Mar 2024 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711137893; cv=none; b=aAdvbgBoTStYiI4cWHGgI/T9y4ef5MTvywQdt8i3HFoNPbRytpSQqrMpKWY5hzyb5a7pOWiJ1dgnJE4sHqTYJ6A4zd7Dg/9EMyWoykRa1qzW8qccf1rg66trGfcr+d3NJ2gvYZ9z7KoCPwSrUDVev2RYt04xCRVXcvSNF8PtZzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711137893; c=relaxed/simple;
	bh=sQL3QfrvZTsRGtALfl2+a+SFJHxLbG1JekgomFTkGKI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=srVeSK+XHKFu76GLDLm6jV65o7TWS9OLQ31JidGeummzR8c54J6rCplyG72LU2nxL7PkzHhPFhX5C+xn/6clv5/bCvJGEiNO++UdrrewsdRB4WhdNFJc+0WzvTzGOpP4m1V69IAcavYV3jV+20/0RSpWxNDHxXzgpQbUiS9XkcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwBW0gQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwBW0gQn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5508BC433F1;
	Fri, 22 Mar 2024 20:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711137893;
	bh=sQL3QfrvZTsRGtALfl2+a+SFJHxLbG1JekgomFTkGKI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hwBW0gQn0nZKTmphj4HKhSDgDgPKSPdLmK2XTzM0hWyHr/KxY7pJjNcgAUkXLDFSa
	 F5p37Q5Tux4AaJwEeKu+8JyxFTC0leGI92gPsZ5Oo6t/dV2+z2WJiyEIACTgIBeAnj
	 0aaPQfQ2LC5kKfgkXFhplrQicmnqwCqkNYFUFYIxa0cgUQF2G1MTTn6sgbYhPFsNiy
	 fB3M5oskMwIM5MAyS7vnHgvQnaFR054OqgpQPs6NHDWTQ0r/G4dF2UvOvKcqdxMFvg
	 zhdgqMLB2kS3y5+8yqKrK5yH6e7pwiYLRHy+vWHTWa2GEBb7s65/D8ASaO3aDorsrb
	 PcDpbtMfKH7Uw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44D3BD8BCE0;
	Fri, 22 Mar 2024 20:04:53 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.9-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zf2yuk3U49ztCwdp@redhat.com>
References: <Zf2yuk3U49ztCwdp@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zf2yuk3U49ztCwdp@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes
X-PR-Tracked-Commit-Id: b4d78cfeb30476239cf08f4f40afc095c173d6e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64f799ffb44b08f86b5c6f318e6dd627a527357f
Message-Id: <171113789327.14477.3508930134474385634.pr-tracker-bot@kernel.org>
Date: Fri, 22 Mar 2024 20:04:53 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 22 Mar 2024 12:32:58 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64f799ffb44b08f86b5c6f318e6dd627a527357f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
