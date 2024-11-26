Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE0481DD
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 02:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732589979; cv=none; b=doD+IFCCdd5QLOTG5lLvXVdijF1n4eRP/UxrGVVtadxNQvC9rX+KlHCCYXJbKXn2cE/hBeYzj0kWQzSYd+fUJ8jgYjCrr8jvlHbNNr/MLJgTd+jEP+GRFoI7khpCpwU0Tg5Vgjs5DRa9paPMF/0nhBeJ2Pg6j81ypXrMYOFd810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732589979; c=relaxed/simple;
	bh=xAISgCiKiUWyTAhs8+OzM40Y3TPB59RmZk3KzyJh2u4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Tj02OhbzdaidVCmZVlvhgJPeQ94HKtFGedBUWvvW0aE+dNaiAyA56Tjkj7CP2PZ0nAcFsmqQ1qygPm9xJ4kPWpTKf8taurNtrrw2KiRKbGvEnSmvk+26W2EbqcJXPQi05DXboniobsXTKC5WgTYOzKCgzLuQLpxC3HwbWiMw/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7wOchhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7wOchhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313DFC4CECE;
	Tue, 26 Nov 2024 02:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732589979;
	bh=xAISgCiKiUWyTAhs8+OzM40Y3TPB59RmZk3KzyJh2u4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=N7wOchhCOZRsBXDR+PnuB4qR58ngQ/u2uLF19M3ZZXsnBKpOY/JtImraEz7jVPw8u
	 5KB1AhneWbOAlkARASif97KLCmIbILpJ9OmKiNxiMb/9fxbigQ03U9kLM6i3iiNfl0
	 gpAydF1fkoOIbLs/eFvL9xJ+Pe29htYo+LPS+91sdSrlJIC/GejpkwrlH1hsm3HSWC
	 LcBSS+3FbsT2/xBOP7eWE4PjADNRtfEL913lItER6rC71jHkViWBm48nNJNJgwoZq3
	 +x+9xc/TmcvcaO6t4IGtrRBlvXM+xhWavkcVXOYmvJ7G5whe6x2gqtIQkDIYs446v3
	 MCPUSCQ3u98yg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E7B3809A00;
	Tue, 26 Nov 2024 02:59:53 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <3a4c7559-166b-d618-0d3b-c09d62b0a4a6@redhat.com>
References: <3a4c7559-166b-d618-0d3b-c09d62b0a4a6@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <3a4c7559-166b-d618-0d3b-c09d62b0a4a6@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-changes
X-PR-Tracked-Commit-Id: a573e404cbf269d46b3a96b18f7316aa57161fdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7eef7e306d3c40a0c5b9ff6adc9b273cc894dbd5
Message-Id: <173258999172.4123769.3381854468640193605.pr-tracker-bot@kernel.org>
Date: Tue, 26 Nov 2024 02:59:51 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Coddington <bcodding@redhat.com>, Colin Ian King <colin.i.king@gmail.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Matthew Sakai <msakai@redhat.com>, Ssuhung Yeh <ssuhung@gmail.com>, Susan LeGendre-McGhee <slegendr@redhat.com>, Yuan Can <yuancan@huawei.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 25 Nov 2024 17:56:51 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7eef7e306d3c40a0c5b9ff6adc9b273cc894dbd5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
