Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EAC1BCA0B
	for <dm-devel@lists.linux.dev>; Fri, 16 Aug 2024 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723825972; cv=none; b=OMjTQSsu+Ii4nIv1AE72YC9I6I1c8TO+fUWGPdnLQKwTgneR50pvGWIzICyeor1lrIpFTIKOK8tY17r0GbwDyPbWSXD5jLAJgcOvF0TD7HpE9Z6kZArVcy2CDeMJZnd5GmUDfpUEYhwatQlCq4jl2O8sxsQfOS7t/BvVwXzsxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723825972; c=relaxed/simple;
	bh=rV27fIrLrf5XjoyXEwb6fuVmCmQE/yB1Rx65y7DZxCQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KI+xdsRYksNy2Fucx1K7Q9M18VmTOP+m9+1lSFLUJeJUcZ28KUHEctMvkvr9pCmhLJA61+BuiExMBZWdewFfArpAiIwiXE6euq/zv2oH/BWU0pLLFVHSJhpgjDAURrHxt0Vndgm0kuH2pvZRlpGHhuac9w0AV5BZsKESa5HJBGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiIb7x30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiIb7x30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F46DC32782;
	Fri, 16 Aug 2024 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723825971;
	bh=rV27fIrLrf5XjoyXEwb6fuVmCmQE/yB1Rx65y7DZxCQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TiIb7x30K+YVamzTNABJ4CI8MmU28Tiy4A1l6g1EqNPPeegWyTuPirAVR37MXgbTI
	 JiX8wiqib4ZjZx61QVTo55lgIphg8KEUOMB/lBHpOgkstbdaKNZo1KqXf9e8hedWF6
	 rDzFGw6hki3/2t0ACFx6OZS5pwZTTcJzvvXF1+gcgU3RWAmBQ59tR7XYgp5ZLXlCtP
	 Z2vaTzS2HOnT+d2QSaYad50htXgUn/ZVNFrJ7XfPBxVGq3n9S4RVrq6ItJk+jIgQKC
	 MFJZfH9M/GyviB9N4SSGwnNvOpc/93y0GlGBmg9k2TbXk4G0n+zCH8ZjL+CHWYj4jp
	 hwU+/Ps+FOBUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3427538231F8;
	Fri, 16 Aug 2024 16:32:52 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <9ead5ab3-f5e1-3de6-f88-6bac6c3b1355@redhat.com>
References: <9ead5ab3-f5e1-3de6-f88-6bac6c3b1355@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <9ead5ab3-f5e1-3de6-f88-6bac6c3b1355@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes
X-PR-Tracked-Commit-Id: faada2174c08662ae98b439c69efe3e79382c538
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 670c12ce09a8180ebe0c608d8a789a7e58fe7d8e
Message-Id: <172382597073.3569819.14085314060780255282.pr-tracker-bot@kernel.org>
Date: Fri, 16 Aug 2024 16:32:50 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Daniel Yang <danielyangkang@gmail.com>, Khazhismel Kumykov <khazhy@google.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 16 Aug 2024 16:02:22 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/670c12ce09a8180ebe0c608d8a789a7e58fe7d8e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
