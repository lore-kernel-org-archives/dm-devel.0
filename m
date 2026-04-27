Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A737C93C
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777334044; cv=none; b=b2DYlKaYbe3Ojf/YtTuTLaDGzaQ/3zlpXDl2KuGkZIytbHX/2sr24bCnR5l2pXQO3gnZYv7GCu1y9bqZmDXtnCygPu8SLtKfXcs1J52YH892nNML/5rCNE4ltrbMX54DLjyE+e3Kny+zphM6Bb3Hb78KCFh+XPAmoXNNh/Gj1OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777334044; c=relaxed/simple;
	bh=Tg2/dhE8OVjQv5J1xQlyohdTHhM/VsS6OKH1eQLm5VE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pUwri3BsFKZd6V3LRvYdZjOlPaMSwFoQS2UOLffurI54UExNEFGcD3gluiMj4AbB2RGikdzUuWw5R5h2lmM3XUCqqDc89D4YXMi4H0rp4tmobCO8k/yFyMWzuSb4+CF0S6TY2jFOJFhJSzupV0/GLQmSZZcrDg78ZoLRJnF+n2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6sgxNWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6sgxNWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE4C19425;
	Mon, 27 Apr 2026 23:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777334044;
	bh=Tg2/dhE8OVjQv5J1xQlyohdTHhM/VsS6OKH1eQLm5VE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=W6sgxNWI2hunWIUp1vtYj/2mcUtCPy12stiuhM+Fh1/mE3QrOJVQZRu/mxhDiE048
	 C533AO8VvR1pFZ0X1ND/ajk/2AJ+68CFWRE/Yi+KE9Zhgh2+Dz7r8ym41Un0m3cHZa
	 pbQH2aJm/4j8sJ+oEDuW/rvgW2utrd3A8iKEOiWsVZnv1csXCO4ogNlOvBkBhItcc/
	 JR9FQoUxJLgoFW7H7tT/QhdAPAGuuzY8y9wShyC1iftzzHb8pwHKKRgIX+50l3b78z
	 qRSokTFCYP4ySexCULMTXjZFEAmxk7dxEqTT7eThzBcOLxvxeCGdWiyFIO2i71eBBD
	 5wP4Y1r+TQ6Wg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 03066392FFCA;
	Mon, 27 Apr 2026 23:53:23 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <9591e654-efbf-7252-d3dc-3f026627cf49@redhat.com>
References: <9591e654-efbf-7252-d3dc-3f026627cf49@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <9591e654-efbf-7252-d3dc-3f026627cf49@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes
X-PR-Tracked-Commit-Id: 09a65adc7d8bbfce06392cb6d375468e2728ead5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d762a96e3dc2c82b551f0cc3506e89c904880cf9
Message-Id: <177733400153.159864.7686887347715036531.pr-tracker-bot@kernel.org>
Date: Mon, 27 Apr 2026 23:53:21 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 27 Apr 2026 15:42:10 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d762a96e3dc2c82b551f0cc3506e89c904880cf9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
