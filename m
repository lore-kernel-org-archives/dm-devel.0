Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED9218C910
	for <dm-devel@lists.linux.dev>; Tue, 28 Jan 2025 01:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029448; cv=none; b=Pm7UVZWiTJRtE/Iq2uIElDGnUpBg9hCzU2EMtJyZ6zFHxaU5nx4/QI2KJ/qaUsF2XqHVyX8Dfwks/namnoW4vBmFmDnCODWM8cz6ZTyxy5HafuEoCZ/11rnAuKDUi4OPmlDx8kc1PMZ4YtmUKubNQcopD8fO9gg0hOLxLWdMtks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029448; c=relaxed/simple;
	bh=jiAy8ODzzFP76vJRR8Ak5+cL4T+FPGfOH59GUFE0aCw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sQQE1xYuRdD/ey5ermmcKAucPl4MgRKiWqzgwOIdpo6eNkEXKoKw/h4zz9N1Us0nDQU1xlrVIk9lG18YZbXl6H0equk3qBGhEfOuNHsx9rp2DBzPAVxWtlFaH93WGoqUa+bpnP9ypNnMMTji0lcynH8pg7/sXizcelAQPPxrmm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+YQsS8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+YQsS8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C427C4CED2;
	Tue, 28 Jan 2025 01:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738029448;
	bh=jiAy8ODzzFP76vJRR8Ak5+cL4T+FPGfOH59GUFE0aCw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=M+YQsS8/p57VegxHalzMVSQyrYmeFQWu9JOM587wEMi9rpWNiMfqf+jd3mgETjGod
	 eJvV2EvBj5jzw1/u3x/yq3VeBgyilYb1BhBqCRYewLw2YINqgpGyk1Koai5qpvU524
	 hSRri0ZM8+bQ1C0iGRTV227F5KMIsUJr+5xNfXu3aOl/jbeGvl7vogwKkRRNSBlMS8
	 BxugNEz1nQyUi5oFiEPL72Nm5ojLeQUsYFIKkl+SpIP7u3CavgpLH3R0STg4OgI2tn
	 RfbFSqbV6DCGZRHONdwh/8fyBN2lvKVVfQh+DVES5yB869T6jSs77QuRqJdy2XIRMH
	 Z+mbdR/uMHwVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE1F380AA63;
	Tue, 28 Jan 2025 01:57:54 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <5588bffe-da8f-9bf8-1367-b3d711e66e62@redhat.com>
References: <5588bffe-da8f-9bf8-1367-b3d711e66e62@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <5588bffe-da8f-9bf8-1367-b3d711e66e62@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-changes
X-PR-Tracked-Commit-Id: 8b8f8037765757861f899ed3a2bfb34525b5c065
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9629d83f05bdc7fdc21363979e96696886bd129a
Message-Id: <173802947364.3293641.13310724024512964323.pr-tracker-bot@kernel.org>
Date: Tue, 28 Jan 2025 01:57:53 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ethan Carter Edwards <ethan@ethancedwards.com>, Hou Tao <houtao1@huawei.com>, John Garry <john.g.garry@oracle.com>, liujing <liujing@cmss.chinamobile.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 27 Jan 2025 11:11:37 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9629d83f05bdc7fdc21363979e96696886bd129a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
