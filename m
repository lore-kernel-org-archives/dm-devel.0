Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F564A3F20
	for <dm-devel@lists.linux.dev>; Thu,  3 Sep 2026 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453359; cv=none; b=qyNxDbtTQR0JN+YZ6O1WhNRg/VwkqQFecJPX0UnPPLRUGmeaZRKtLOoijUdFZRONLZUA3QFglwnpzkeNtwAOcvSaCJ2mjYWBfCnRazKXF2n/E2sf/X194oTwiCD3GjbVGo36EPigHg+AHvSiHfjcmQyGBKSWyEvl3woFauTc9Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453359; c=relaxed/simple;
	bh=sdtO6qrRMstwuuVQoSEP8zcB8ybKL3ggGBhK0NOFcUY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Dcn9kHk/scvjHA3Lc3tRAUEc4tW8LYwPbF48FWTIK85ugZDHImB3GfWKD0eR2wFHzoF0G9MUNXjk53evXlkfaw/54smKR27nLwERiEaONYjnqO9KKOF1N3khwxaCs1xchPFU9B7FURnKj22qt6Hi5xmN1TToqto0fphiH4o7h/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6Q2GESn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6Q2GESn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EF41F000E9;
	Thu,  3 Sep 2026 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453357;
	bh=KDx20F3dylVgSuwgJxT+lWQkQC+bZF7iZDN+28GVmh0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=W6Q2GESn5QVpuIFNLaS/DjUKNFQchU+GpgGfsp0A4sVtvwftoEdKmHMeB7uWybDPU
	 x2T6nHREdtRwNxjCLoiXiup+NwPcvNnyU8/472qeVTjN/tm27cGMhIZXdFMrYywYmI
	 kieut1/7UjKBnl07vzlB5MvCpNkqkPFrWQlNyXSEngJlJEIdB5L8vcuovmcp20gS9/
	 9kiwRTMNu7hd3p46V7lz22XM+A9x5O9mnwxISJ9sqeDcWg9m4fIcWJgGjRFsI2iMoF
	 8WRgsTPE01TQxYyNs136N7H47Z2+fFBJ+vimlAapThCIqzaDxycl4DQUiNbQewuaSY
	 M0rozvfYI0jSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1994F38119D1;
	Thu,  3 Sep 2026 16:35:00 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <e50b0304-3b2d-80d0-4fc1-90339278ea8e@redhat.com>
References: <e50b0304-3b2d-80d0-4fc1-90339278ea8e@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <e50b0304-3b2d-80d0-4fc1-90339278ea8e@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes
X-PR-Tracked-Commit-Id: 7ac81e2d2240f2c57bd073b0733e0b2abca38e82
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ab1afb2eb246ab15b301cd255b5943d208a93c1
Message-Id: <178845329862.3436244.15086884589300247472.pr-tracker-bot@kernel.org>
Date: Thu, 03 Sep 2026 16:34:58 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Ben Cressey <ben@cressey.dev>, Benjamin Marzinski <bmarzins@redhat.com>, Genjian Zhang <zhanggenjian@kylinos.cn>, Chen Cheng <chencheng@fnnas.com>, Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 3 Sep 2026 17:00:18 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ab1afb2eb246ab15b301cd255b5943d208a93c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
