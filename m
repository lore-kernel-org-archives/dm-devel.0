Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3D2149C5D;
	Tue, 21 May 2024 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716317599; cv=none; b=mkXsN/G/s0NhPWt5tiGF7BIcxGSP4K7tNjlcrDsWhOjCATAABZxtrRmlknXOLOfm7MegNzkciU70ZwuR+NH1rb5xuWCrtNAzggp/zYAzlWk7ZVGB8PTKB4kov/fOMpr3FlcRdWHPKL3gTWioZygVzu2nHjZdSE4s6NEh0mtsfJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716317599; c=relaxed/simple;
	bh=LjZeBsEO2K0zw2RCYDro1OcIDDZupMG8aj7htvluqHc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PFvnwfYcnWS0x/ayKna8ZEqvZepWDDdmQFEwnIjpWYpHchAXe7LFg/mlpuDJOegWZri99lhT185Hz96bV8TjIn92c6YhkwljfGAbQuXM31+qQv2h+1D+qw2pY2gxtoPhJGOXzZeiudMKmZJGfiWI+WmMcAt937tlNlvCz7Fe6Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4aTbl2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4aTbl2x"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B854C2BD11;
	Tue, 21 May 2024 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716317599;
	bh=LjZeBsEO2K0zw2RCYDro1OcIDDZupMG8aj7htvluqHc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=a4aTbl2xAzjcjYWacriWh9s+0lQ6vSgrTr+jii92wLcCsdfGbu/APPXHqvN15cIxR
	 uAo+aYd4w39C+Sxqlh3w/arIaV/4oYTC6ff4KEd3moM3JDtbKKRlB8CgJJOSvqS1FD
	 v4QsJWcmWTmMBYuehh6TIxKT8xXngs6rSq2sdn+up3vdy6p70xuDs2VbbVyh7KcjIf
	 G+0CMYSiU0PDt9Hzj/hRo9Ie392rH/589uWnRiuVqEatbg69yFELX4MV9zvYHSi5ex
	 Nd6sBHRtParM/mHVzOhbJb4FIy8fD3js6TWcRvi42FQ2uVZmS9LnGszKxR9A/QcUdt
	 8Ryne9anbZPRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A965C4936D;
	Tue, 21 May 2024 18:53:19 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZkzDAsx_7FvmFbSX@kernel.org>
References: <ZkzDAsx_7FvmFbSX@kernel.org>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZkzDAsx_7FvmFbSX@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes
X-PR-Tracked-Commit-Id: 825d8bbd2f32cb229c3b6653bd454832c3c20acb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 856726396d6548ef21a9b02e5b685ec39e555248
Message-Id: <171631759929.16717.11074821623831122508.pr-tracker-bot@kernel.org>
Date: Tue, 21 May 2024 18:53:19 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 21 May 2024 11:51:30 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/856726396d6548ef21a9b02e5b685ec39e555248

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
