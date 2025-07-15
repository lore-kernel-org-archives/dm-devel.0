Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6295B19DF4F
	for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 02:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752548168; cv=none; b=IiCKlIJCgpDvnM1D6HNfuSz414+PfEs32UyKCnKuyg5AHBNQ/q/YMHUreHqTNKIpmyfIQqYUtnhpPra6E/tp6HcNoC6V9HqkUpjnnRIjh+imJpnoY82UgG1y/nBBcBJMW1CRDJijfq73OaAUwlezvXhVIyIGBzl6aPoi98Xu1Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752548168; c=relaxed/simple;
	bh=yoCzSl46JQDAwy/gYqfGeYeN+dVrbrth8pPFDPNzkgA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=l74FDKJEaTyEHFENLhZdFFEz+sRn3UempQYjeVbTFP7nk0DFZyQ2qAhtaNlPP9XPMOHKvQMpyYV5bx+pWaG5dSSMBU4Ig6ciuGfyLecMzbQ7b3fjOz1MP0pk8v5i6+rk/T+C3FT7rF9AMe5bSxI/vgCiJa1aiL73/uwPfg0C2aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0wV0E12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0wV0E12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4F5C4CEED;
	Tue, 15 Jul 2025 02:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752548168;
	bh=yoCzSl46JQDAwy/gYqfGeYeN+dVrbrth8pPFDPNzkgA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j0wV0E12InH4toVtYfI/uOuyd4lgPbRsdVwImoJxAmLUWPdAUkmQCAdhhSDQDtfwZ
	 mYZh38FteRaAdtvy/Gj3QTnqOFuEwp3aSITQx8kG1DDC/6osHn8O8TFqoY8Hb8QgT0
	 948pK1lTUpdGMVBRlZlZHgAJWxxgC3O1ne5COZaMmraatSdP22dnYfpUdusyyEz5PY
	 3KIuN65/cj5yzEs4e5IcaZ3rBqzo2FAOYlta8c5F1jk3Z5gL/4lVi5FTJ1FeUk4R2I
	 Lo0d0s3hyyljz2l9YMP94P8ZN5mEpSMCabIDJO6975z9Q4908s7hxwsirfdSBW2XUA
	 BoiS4UUEHe1ag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF40383B276;
	Tue, 15 Jul 2025 02:56:29 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <2f8014be-7269-b451-aeb8-9785e4ef5e10@redhat.com>
References: <2f8014be-7269-b451-aeb8-9785e4ef5e10@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <2f8014be-7269-b451-aeb8-9785e4ef5e10@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes-2
X-PR-Tracked-Commit-Id: b1bf1a782fdf5c482215c0c661b5da98b8e75773
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 155a3c003e555a7300d156a5252c004c392ec6b0
Message-Id: <175254818861.4068642.10548829798700640989.pr-tracker-bot@kernel.org>
Date: Tue, 15 Jul 2025 02:56:28 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Sheng Yong <shengyong1@xiaomi.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 14 Jul 2025 22:10:05 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/155a3c003e555a7300d156a5252c004c392ec6b0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
