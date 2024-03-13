Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55E19AF06;
	Wed, 13 Mar 2024 17:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710349445; cv=none; b=RDsyp62LwXnx4ikRl31+QY5a8EuqlqFl7aWgcZ4czfB0TrJMDxcXvqaDxSqVwXUfbHGzV1agmmzZjNHHu97pV9931ilufYx1LYIo0D0Uxf+SynSeM45D63D6oR5rtXoS3sTcnQIaJh/Q6b+6tusHLw7Inv9x+45FGaJ3yhREr3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710349445; c=relaxed/simple;
	bh=31BY+f5ervYq/V7noUUIt55x9qNOdRNZ2RJ2EkHHbQE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YJ3VaLNM05wL9+O7TrakW5JR2wzaWPWhVvpKDrCA5ToPT50khy4YbrwooCn/hEQt04L7HbwNCfbc4CFJ/fVrMU1lZHGbzKBly3oVvbMPAT96a6tXEYYx9/Htkkjxw2hLgX7aIO6mWHjTcN3PEoewHykiWPpRZ2sXbhmEP4/lcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gy1BuxMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gy1BuxMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0BB5C433F1;
	Wed, 13 Mar 2024 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710349444;
	bh=31BY+f5ervYq/V7noUUIt55x9qNOdRNZ2RJ2EkHHbQE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gy1BuxMQTMmcepfg8nMcNcS06DDdoY2UokmCovhHT9ZA+j5t+AK0NNPjrCTcLXp1W
	 HRbE05+XbUSIR0l+0rNwmigZW46B2XjWZwc4t38jjjcjv06Y40cay8L/zVZm4zAug7
	 hu6hg6Cc4YS2kFq6w16qUiFKE854dZY+wvr6qJDn68CWtASJcc+wjbv2xmEuGqD0Hq
	 Z66ELX8akEaxViTvk+yHUOjDYDhIZGYIPrcIegCOLuvXSZHqVZO0vtfE+aYyE9kCmm
	 4anZpk7psvvrObxbh48cJv0Ajdfm2FOVr12nd8yEBlyiXreGWG8g8WN3Fdg6/4CAdQ
	 8tiiRh/rKBKBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA7A5D95054;
	Wed, 13 Mar 2024 17:04:04 +0000 (UTC)
Subject: Re: [git pull] device mapper changes to switch to BH workqueue for 6.9
From: pr-tracker-bot@kernel.org
In-Reply-To: <Ze9PXaiOHXiKFjT2@redhat.com>
References: <Ze9OCmWb-9LX5t8W@redhat.com> <Ze9PXaiOHXiKFjT2@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <Ze9PXaiOHXiKFjT2@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-bh-wq
X-PR-Tracked-Commit-Id: c375b223338828f29aed76625b33be6d3a21f8af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c0499a081285dcacacd10b0cb20ccba777411b88
Message-Id: <171034944469.7471.6619723840060376057.pr-tracker-bot@kernel.org>
Date: Wed, 13 Mar 2024 17:04:04 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Tejun Heo <tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 11 Mar 2024 14:37:17 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-bh-wq

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c0499a081285dcacacd10b0cb20ccba777411b88

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
