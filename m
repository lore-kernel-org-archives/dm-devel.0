Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75012FF6E
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 22:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736117; cv=none; b=D7kFTeFKHo+1Uf5hbnb/TsOmtZd2xFUzoBYaZ9GWo3z3L15aNIXaKiiut/EQoKWVCMBOS1nPz/UcRtNNZ02i+34DJaqZIYj1fVT7afYwnczl5/jfqsS8mi3k2Kpgws9pxTCq/NPX+xlazle6P8pY9iJBQet1tKkxprI4mR5JBOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736117; c=relaxed/simple;
	bh=qg7BGXDybvC7zIb1UbjdhRIWhvioUjoNzc2x3f1U96A=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eQ1EaKMxRisZDljk5SJ2fjhxqpMUinUFHb3Diyf/8GNTEtSlZdWlI2oVzaoFv9qivnOB+cSBtH6F7HU93OX4lmJ3zcAhJjZ5D2JO09Jx1l5tCpx7IMT0vFERdpfq7Ixpj24TItz7v/m89rAnSNfjTa+9n0WID5hP+TTniibHZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btbBfYCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btbBfYCh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03695C116B1;
	Thu, 11 Jul 2024 22:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720736117;
	bh=qg7BGXDybvC7zIb1UbjdhRIWhvioUjoNzc2x3f1U96A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=btbBfYChS4iEw1Jgm7jjeJLOr3lS2y9mBjBDSRB7R4615l1P1sjhSD2zTRYVJR3oF
	 zr2k1khVBaQV5HKSBfv11LrvqX7rfBeqnMwqdIN5HGpyg5e8x7eOt1i7E6K9HR9B+r
	 GPN90/5X/81NfYqj4tHOAct6071akHMRRnPZ0J7AxqNZ75zwL3v13iPlDoSERWezNW
	 /AmCDqIiIBI4rZSao58HfABFeo+SKIK9K3w+eFRZ3AsuiH2pO59ARF3HJOHDRSgN7j
	 bZg87THvscDoipNK7cuTxrc99wLmP8R4QCH1UEZjKgDPyAqYgHQklR3Nh46tGwI5md
	 lDme2BHbvNx1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2231C43468;
	Thu, 11 Jul 2024 22:15:16 +0000 (UTC)
Subject: Re: [git pull] device mapper fix for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <58c35db9-151e-266d-8df0-62275d8f96c9@redhat.com>
References: <58c35db9-151e-266d-8df0-62275d8f96c9@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <58c35db9-151e-266d-8df0-62275d8f96c9@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes-2
X-PR-Tracked-Commit-Id: d5cfecfe7f3293a4773c4486ac92d742143e8659
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43db1e03c086ed20cc75808d3f45e780ec4ca26e
Message-Id: <172073611691.27878.15692458826414613376.pr-tracker-bot@kernel.org>
Date: Thu, 11 Jul 2024 22:15:16 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bruce Johnston <bjohnsto@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 11 Jul 2024 22:31:27 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43db1e03c086ed20cc75808d3f45e780ec4ca26e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
