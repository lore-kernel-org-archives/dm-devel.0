Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8003D6CDF
	for <dm-devel@lists.linux.dev>; Wed, 19 Aug 2026 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787169360; cv=none; b=mJsQN1Tiqxkhquv0GES6vcc6k39pi7vL8Pk9COrOk530fXZt5reN2u4B+jVOwjK/7yY9vbtpwntjWOya3a44m1bUBHKwmWV1NmYaI55AsPJ/VvJQfBOXxLLATNHWScqIZkpcFndaFoVsjUkcYWpW8weD3own8wBifFECNE0GCrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787169360; c=relaxed/simple;
	bh=I/6W8J7g48qf2efbPQNRHxSzRC1QVywIOjW/kjCI64Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iOY8SBdWX0JrnjhzFvt5Afh/S78hCO+JV7UJ58fW5imYkXxhrN33ojSclbrs8s7/bw9cbiipN6MDVfbAPTa2DxL+OfocvZkqJKvYPUStEmwSnCMpUdxW3oX56c6GJSRoecj76Br3jRu2UadB8kkOch6j4A09VmBG+CvskVJEPrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZBTb68S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZBTb68S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF0C1F000E9;
	Wed, 19 Aug 2026 19:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787169356;
	bh=/arVLTxznLUOXhItfzQkf9me6z4Vhshg3lap8kNU25c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JZBTb68SVBqSacdsXAexgF4a0TnNR/Xvey4SK4x257euGFYdEgw0wsPtJ8ULP0YCL
	 /jK1XTzQULpMfKD+YpAfPwyYnM+O0Ca/olJTw5EcpGZI9tw6l5HF7Bo4o5SMQ7Jabu
	 FNxr5ZxMViBA7v4D+WhfR2GrPFZ8ABMVtvdcE8jcDsEorXLPcYasxWBjIDFD2kMRdz
	 s5GgvqOdlikmRdVzk16m7CFIXDLAtxXP/cIvPfuowsv6qKOOG2nXam+rEtvXuy84Dv
	 MnAIj2IKI60XtyRBMFaOojcTTNlsNcB82gXRjrg4xIyGqKonvUH/5iLKdIlazTpUDc
	 JzBRw8jOgaESQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93D0C3811A47;
	Wed, 19 Aug 2026 19:55:08 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <80e03616-ac55-cfcc-4fc7-f47bad3e0ac7@redhat.com>
References: <80e03616-ac55-cfcc-4fc7-f47bad3e0ac7@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <80e03616-ac55-cfcc-4fc7-f47bad3e0ac7@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-changes
X-PR-Tracked-Commit-Id: 39c5aa3bd8ec3912d2cd0b3fe092642b0d2b0713
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7fa7d4c6038bb4b394478ba1b31a6e8d89ed4f60
Message-Id: <178716930717.3672948.3351844985707092876.pr-tracker-bot@kernel.org>
Date: Wed, 19 Aug 2026 19:55:07 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, Bryam Vargas <hexlabsecurity@proton.me>, bui duc phuc <phucduc.bui@gmail.com>, corwin <corwincoburn@google.com>, David Laight <david.laight.linux@gmail.com>, Haotian Zhang <vulab@iscas.ac.cn>, Ilya Krutskih <devsec@tpz.ru>, "Jiangong.Han" <jiangong.han@windriver.com>, Jianyun Gao <jianyungao89@gmail.com>, Keith Busch <kbusch@kernel.org>, liyouhong <liyouhong@kylinos.cn>, Matthew Sakai <msakai@redhat.com>, Samuel Moelius <sam.moelius@trailofbits.com>, "shaikh.kamal" <shaikhkamal2012@gmail.com>, Shukai Ni <shukai.ni@kuleuven.be>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 17 Aug 2026 22:41:41 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7fa7d4c6038bb4b394478ba1b31a6e8d89ed4f60

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
