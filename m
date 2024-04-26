Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5298617FF;
	Fri, 26 Apr 2024 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156258; cv=none; b=YBYl8YGykBNSbiCIpCj8W5D+3lASTqtMEophYUxCw1tVTctTRsHM+R2MWL3Ifkm3be6rYfed2GfXmen9+BmmS9zWeK1EHVjULlS6mXpKQc/FqHQLAs55DYpNoh/zCNbCkpx7Y2I0yEvPbnb2P8iFPsmbokgyG7uKB5C+o02oSho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156258; c=relaxed/simple;
	bh=hlZHhXDbfrtY8Hl9c3SinyUT3TjpxduHmRO+a9sgFyA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iHO6B+Alk7E50eqp22oYjV84O+gmZt7wQD0uItfVvb4499O1KxJ2LpUwz1r881JxORgjKLEoV6fR/PQBT7jcSllFRP7e96KvDIcGz7kQq9cT/ihbqiJdXbJlYtA3s1THmZefyxwQPQLJptVAPDHxULkl1CVYp7vxeMZGN9ZI56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDmT4G6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDmT4G6/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD21FC113CD;
	Fri, 26 Apr 2024 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714156257;
	bh=hlZHhXDbfrtY8Hl9c3SinyUT3TjpxduHmRO+a9sgFyA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VDmT4G6/g7S0mKFzwkMTvTv+08XQ4ROhb63ynK2Kw8PC4pI7WZOFrTEXXBqAcVXDR
	 zwcxk+q9uRGQj7ArAu7vATKlzLinLbl5jY+ZGKB1OAVc6ucqTd10VkyP3602S/zEh8
	 uEAab0j5Fsc3SvRHUjWBjD+mk1ismaSGHbbLXL8PLefzN4UplDhimXjvpXViHlIGQS
	 VxasEsgBtIbC/RIIjkZadQDqU9RYQpOUxlq8oIBxZu+UDSdLmG6DSviZi+P2U8cDF/
	 kzks3cXuaqmZb3d6e0FynoOYY0S5kNcqBG5d/7p3xKlvnnPO2ccosG69YekT+Rzu8K
	 y2gLiGvj/z5Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9351DF3C9B;
	Fri, 26 Apr 2024 18:30:57 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for v6.9-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZivWZtBH77F9v1f7@redhat.com>
References: <ZivWZtBH77F9v1f7@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZivWZtBH77F9v1f7@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes-3
X-PR-Tracked-Commit-Id: 48ef0ba12e6b77a1ce5d09c580c38855b090ae7c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 08f0677dfc1a0e4648eca650be5b32f1a40e93ad
Message-Id: <171415625774.22135.12583743369111950372.pr-tracker-bot@kernel.org>
Date: Fri, 26 Apr 2024 18:30:57 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Matthew Sakai <msakai@redhat.com>, Ming Lei <ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 26 Apr 2024 12:29:26 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/08f0677dfc1a0e4648eca650be5b32f1a40e93ad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
