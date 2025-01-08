Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BC201116
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360122; cv=none; b=ax4fft/w3UMDHxaVvyvcE2NJpFzgk61N743GYbq74Q/1l1HXMXHEhGe4ZZU8SLhyFMzvMctk9bpRit61u0El1yi9+q8eRgRZ7/J1tFb6s4OopZ7NH+o5GvXIxj6Vh2idJBDiLcYFw84XoU8v10hQm5tn1LEJyN6JHQAdWOIa31Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360122; c=relaxed/simple;
	bh=ru7MwhbC7G0fSHC+v10FW9m1Wxoc4gMBmSgTgTsB/2c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PTcFskWR8K7cWDa9ZY6Uweq3gx9VchwEj3JEiJfYorVJgk8LiXYF+/0/29GewHnHr+gZvzu43PN3fOvOZ4gJXvcsD7nD8gXrgbuoMrg+/U8GUm7wus1ALg2Co8cc8OWc/cnW+ZbP7ZCeuXkQ6XoiokIRPGyacUx/f74p/QwVz1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRfvWv50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRfvWv50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74499C4CED3;
	Wed,  8 Jan 2025 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736360121;
	bh=ru7MwhbC7G0fSHC+v10FW9m1Wxoc4gMBmSgTgTsB/2c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rRfvWv50J1XoLMTrtTGIOV+LSWz/E1F6opkt8KgxisinkJ1UyILMepynFzepwyJSS
	 LtzRR7VODAo+TtNc53ON52Mm+3q61SJ9/Ted7M44YSKJdvK6ss4RQVgNp3nHawEB/P
	 Xi/tcMBOfdif6TSevYiMuQnRS1050B5Cc8JONAN4Yb4GKp24fez1o+ZfiTtv9at+q0
	 WJgxoMCwF4RRGUr/qalFjrEX802CQzoJhT8NHGVJNgwma6GteP0m/8EecGyjPNZP8i
	 /lNHd/PGiTI0Qaj7KvCiiCr16t/LyFrPI6AZ2I+Q+pIBpBZ9GEsDV9dykC4jkffKAD
	 04Nk4i1wWdvbw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3438F380A965;
	Wed,  8 Jan 2025 18:15:44 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <713cc4d7-7828-5083-844b-95dd61015663@redhat.com>
References: <713cc4d7-7828-5083-844b-95dd61015663@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <713cc4d7-7828-5083-844b-95dd61015663@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-fixes
X-PR-Tracked-Commit-Id: 80f130bfad1dab93b95683fc39b87235682b8f72
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b7958fa05d562e514fd0abe2a4800042abf868b
Message-Id: <173636014282.735018.9021828183209525717.pr-tracker-bot@kernel.org>
Date: Wed, 08 Jan 2025 18:15:42 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Krister Johansen <kjlx@templeofstupid.com>, Milan Broz <gmazyland@gmail.com>, Ming-Hung Tsai <mtsai@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 8 Jan 2025 15:55:22 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b7958fa05d562e514fd0abe2a4800042abf868b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
