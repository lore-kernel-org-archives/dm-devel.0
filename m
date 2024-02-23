Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA39014263E;
	Fri, 23 Feb 2024 18:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708713856; cv=none; b=qZEmR9SxqRBgBfJbi53yxZgVia35d3AW/PAxq9DS1sgb2pRaaaY8g5nJpkrmhvJ5pcY4D+aOSapQOM8Svqnwu7It+uQg4mrlPzjZosmrEBZq0vBNC8fmtFlm8PnkS3bdt96Gn+7a/noK1xWYWxSyB/5QN4zQce4uMm+oSFEQoKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708713856; c=relaxed/simple;
	bh=0qtWwjwN0gdDGdkOcAYn1dE4DlZdFM2Fl6oCTV4TBMI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oQWwNkK1NKn0PfJ8433pBciNIxtHcwtoX+hnZ3CU4TPTce2GlWmFX749CZVzR94N3FnfB8wQ+fW3WdvSW+lPnvgPPOJzT/CIWYG+osgw9rU/WqtkUJCcxYmV/vDe/PZIKKfVwmfSSZNS48hygK975hpShT4EVMUfqSNFCvlBMak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pshxISfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pshxISfs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC372C433F1;
	Fri, 23 Feb 2024 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708713855;
	bh=0qtWwjwN0gdDGdkOcAYn1dE4DlZdFM2Fl6oCTV4TBMI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pshxISfsY3odTH7dJd0BlzsbVRGXJpbGUnquw0CctoIwtv8y+prsjr3E5Bx6Xd1pk
	 S5LC/QIQrFkmvrVuKXLYxX1CcK54DZP1q/wv2XDGEvh2nBGLt+/gF/YWbUGnQf8sLa
	 AxATff4OFRV4A/FP+Y1oJg0dwc+G03mvkjnimXmF9/eQAVdI4OQFCwNNcJRWJyasWW
	 3lpy1+9Yo3EFRSvWPPNlTA3Uiv2PG0fTHrawnVRtYeZC9cD0mUFNbqlI08soyog5U0
	 ueoP8+V4KbHCy+zApAG22jZhPoIMO6iurtLqa+Wd/MkJ8xyOxnDelz94f2XDYi1FxT
	 ZsTVB1lECs1UA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8344D990CB;
	Fri, 23 Feb 2024 18:44:15 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.8-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZdjTMZRwZ_9GjCmc@redhat.com>
References: <ZdjTMZRwZ_9GjCmc@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZdjTMZRwZ_9GjCmc@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fixes-2
X-PR-Tracked-Commit-Id: 0e0c50e85a364bb7f1c52c84affe7f9e88c57da7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e7768e65cd777182553b98f5b4eaffb624974976
Message-Id: <170871385574.26987.9880431009272808241.pr-tracker-bot@kernel.org>
Date: Fri, 23 Feb 2024 18:44:15 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 23 Feb 2024 12:17:37 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e7768e65cd777182553b98f5b4eaffb624974976

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
