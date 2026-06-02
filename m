Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77B365A12
	for <dm-devel@lists.linux.dev>; Tue,  2 Jun 2026 02:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780369095; cv=none; b=NE0zIzr8VOC2dtaSopzTbr474mockC/rieeKqfCxU0zGka+KHzQv7JhD6DPPM5gN6dyOo0+mgqbyW8hNellb7YfazUU+t4F45v4Xj8A/Pjmws37BkpTVVjNY1eYioEkmEfHCD6QAOyJLbWxrK9tsQvJFWvyR8r57n5RZXefct0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780369095; c=relaxed/simple;
	bh=MOrDSZx2brCNaFn8D08/NJZYGrgjc5TlMyPcKaBsQyc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AjkFo4sgzASNZswtBgXXCYkXbF7bmD2L1oUfuUMDYBAgah0bkLchfxzDHklAxgrJvtib27n3gOSMiqg9tcnKMdjthN3BDVkm5CuTNElEPHWn92dPPqRwksGUfzw+Df1kUvfGqdIMhUd2bfZrjhTn0RhZGlaaRCIHWZnpofDVT3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxbtC+Q1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxbtC+Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDE71F00893;
	Tue,  2 Jun 2026 02:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780369094;
	bh=s45VDJyVSqRb1Lw82lH6DVoET+6C0SzfK142FiDQetw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=oxbtC+Q1OlzuQzldQ7L17Jp0Nsq2JFFHMs3rPBmZyTq5kZZPXnzxnXs4tVw24OwFC
	 g3w8D599qZLK+ZGibMDH9y8SLjNVXC2Y9yFJAUublbW00gZACApEuTqSSrzmsyhfEx
	 NBisVEAk8rkcTEHf142wHnFF+9h4ZZ6UDC86IdKLaDiRjO9pGpAiaFlof81HEQrU0B
	 BCSwW3gDs4VjSTwgcnNpYwqvVwmphOJTt0U6V3MsQ587S9c8J2XHu5Diadk2ezq/uX
	 FmPniWhE6zx40LuI+TYNPf93lbW2PfI5UVmufCPCN9YGP2pEBk9IxQyFJIPjGNmjPa
	 EMSGDi4Up30PQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A5E38119F9;
	Tue,  2 Jun 2026 02:58:17 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 3 for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <cc233087-609d-8bde-ea0b-51d654636ac4@redhat.com>
References: <cc233087-609d-8bde-ea0b-51d654636ac4@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <cc233087-609d-8bde-ea0b-51d654636ac4@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-3
X-PR-Tracked-Commit-Id: d3f0a606b9f278ece8a0df626ded9c4044071235
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f3ed7fec72fc8979b2a8c7219c0a9fcfc8d07b5
Message-Id: <178036909619.219847.10534221280452032531.pr-tracker-bot@kernel.org>
Date: Tue, 02 Jun 2026 02:58:16 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, Ming-Hung Tsai <mtsai@redhat.com>, Guangshuo Li <lgs201920130244@gmail.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 1 Jun 2026 17:42:51 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f3ed7fec72fc8979b2a8c7219c0a9fcfc8d07b5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
