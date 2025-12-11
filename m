Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DA1286A4
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765424810; cv=none; b=DfRuRUxR+XKOvVtJlKF6NxfLYoYboFvBmv8u8MfZGuhRdFZ5l68GVBt00ooLVB45Q3o0kuL2DVbsn1P31a3A6cv42EMfbs4i7ZkkraySD47rdbYXFwUew05Mx5nCsAtdFTc73FHELiz7kQOX9Hi/SXMCfpLpyaZ2R4k2VXLNXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765424810; c=relaxed/simple;
	bh=oIkuu189+LXad5z/wPcmzKBa4Y6wJCqszp4BRGlc/4Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VWRpsoGH4ntZN7zo1pIp+06iYGA2m+Rd1nr8KcC7XWmA0n7xUUNoK1DtQORTVevSJYb4ppsQoLTrUX1iIKbyIJ4eLYvQCBjaQawq7qtOtWlGIRGqXKLf3jA/CcNkdIg3G3ESzezi5MqG7JBW/DFTE/zuQTbspYekfdJ7Q271m/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fp9s9mdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fp9s9mdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC71BC4CEFB;
	Thu, 11 Dec 2025 03:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765424809;
	bh=oIkuu189+LXad5z/wPcmzKBa4Y6wJCqszp4BRGlc/4Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fp9s9mdB5wIaRHhHhxYEs2Ns8pydRfTvBmBUlrMP3dO6/KqqngZ5DtvtNaRB4wbbN
	 C9NiJVe6a7VIEoLE9DirqXljI/SCMOwoWHtqvZzqoJApDxy/LwAKW+BmSO6+o2RUnS
	 9VDVockUmMNCQVhByJcoiwI4UIr9IPZozno+IqzwNebAoGn8ol0FVI9S1judUyJuph
	 TtDesIFfrKi2lfLe/+OAb58VtoSs2wBYpttepY4l6PiAicy1V8AtNJCgnzNeklKdNt
	 NFMaevzZoJhZ8EC4QmTw1HRdjqmDSVxu2TyhJnIn5bNZZhR48uVnXeKy6FAFn3yIRl
	 Dki3Tuo9sXPsw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BC0F3809A2D;
	Thu, 11 Dec 2025 03:43:45 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.19/dm-changes
X-PR-Tracked-Commit-Id: 13ea55ea20176736516b20b9ea2d8cf97dbe74f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d358e5254674b70f34c847715ca509e46eb81e6f
Message-Id: <176542462377.1214680.7616102617541805910.pr-tracker-bot@kernel.org>
Date: Thu, 11 Dec 2025 03:43:43 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, Alexey Simakov <bigalex934@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Biggers <ebiggers@kernel.org>, Haotian Zhang <vulab@iscas.ac.cn>, Heinz Mauelshagen <heinzm@redhat.com>, Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, John Garry <john.g.garry@oracle.com>, Jon Hunter <jonathanh@nvidia.com>, Li Chen <chenl311@chinatelecom.cn>, Matthew Sakai <msakai@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pedro Demarchi Gomes <pedrodemargomes@gmail.com>, Shubhankar Mishra <shubhankarm@google.com>, Uladzislau Rezki <urezki@gmail.com>, Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 10 Dec 2025 20:18:03 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.19/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d358e5254674b70f34c847715ca509e46eb81e6f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
