Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F83421A4B9
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731447528; cv=none; b=U9fJfl5BtYjS/j8XTwpVju8IvY1ioiTwBjS9/YOeYysiy5BhaP2LRq1YiYMi0FRk+5X+61nOt6z25s71s+9TDwnVACjOi8PfSM07z45BtQgDN8GaLnrAt7pHGpPqw+H07gJzT6+a6qdbKdCxDfJrvcYDcVXd5wymwW+BKy+3Gw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731447528; c=relaxed/simple;
	bh=VdvlpL1WNHVapt8+cAGFRBBej5L+tYvZzrMLnRyvJKQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I1RYtRpOITkjN0SrfGi9S3iwb9+gmkdyR5P3cgJ3pWUvpRsaS35X4lkRCLhV5iaY3A4bBi26g16vU6ZZ7jVnNxS6OB8obieRTyjj02dKzaIES/HwfNS1nPTGRf/J0Fc81jp0DPtUO9iOEGLF4eaG1goEiUqq9I/N47G7qO9VUZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5fDgzu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5fDgzu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01768C4CED5;
	Tue, 12 Nov 2024 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731447528;
	bh=VdvlpL1WNHVapt8+cAGFRBBej5L+tYvZzrMLnRyvJKQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k5fDgzu8OPddIP6VASIwISy9ucnQTFTUZDpb9ngfWgWM12Vqv0XqeulflAAJ1bWUK
	 t8IJeS4atAJDs7nL3JJfRDLDlQyfH8jFG6+Ak1XKR6pfwl2qOQbSfZcNLuKuN8Os6k
	 ErPNW9gYUU72aKO1UJcv+SaMak8oC70PBAMuhJ/zKlzgr+Tt2JiI9/0yXZrQV+yKUt
	 2XhB/etGVqGqiqI0PHLcXaBMpBfh+l8Fbsc296D5OKH1jswEVRkUR4hdhG0T0jk97f
	 hIbbZdQeNkH+26nRgsKUBBLzn/7N1M6sAQYZ445YyCLXtILT2C2MLHnygi5k5NA0eH
	 17xoqtBhBPaBA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7124C3809A80;
	Tue, 12 Nov 2024 21:38:59 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 3 for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <896b202d-3378-856d-eed9-97e443f9c7d7@redhat.com>
References: <896b202d-3378-856d-eed9-97e443f9c7d7@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <896b202d-3378-856d-eed9-97e443f9c7d7@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-3
X-PR-Tracked-Commit-Id: 346dbf1b1345476a6524512892cceb931bee3039
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5456ec9dab3a918ccfc0dc82677d38a74fab4212
Message-Id: <173144753814.678506.9578881232870407196.pr-tracker-bot@kernel.org>
Date: Tue, 12 Nov 2024 21:38:58 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, thornber@redhat.com, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 11 Nov 2024 22:40:53 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5456ec9dab3a918ccfc0dc82677d38a74fab4212

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
