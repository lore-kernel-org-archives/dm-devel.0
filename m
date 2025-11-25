Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3494B1F4CBB
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764086578; cv=none; b=i2YiYRlMOKj90atyXGDky1mnyhVW9ViVzaAgoixcCkt97HothPBfEvYttRLlyybJAnZHWw/NyJbCm0lWiGkUuWk9Ad3rJzKvUcYjd41Bw4cxwJo86SNneAreZsXuEyRuzvEn+giBhDMBOH0W18EKuriRhVi1n+Lc1t4N6McN9AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764086578; c=relaxed/simple;
	bh=Mdo3bynxe4TP3HHuQI1aw5RsYbjhW74AffxT8FogloE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CEeWJaIfnxGMCfZxfPI2Sv619w+E8LKaniHJljSzoArq8WatVoNB9vKFExjyjEyxmCg9ysK0CEXfsGdaGwQ3Y+btujz/SAdkDzYRHX5R2CC2FnCY3dDAQlzjUMCS6rF2tgI7d0vZp1/KKBA0Rjbw/0ho9RBja+ntcpH7VZYBD0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1Nuo9BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1Nuo9BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F126C4CEF1;
	Tue, 25 Nov 2025 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764086578;
	bh=Mdo3bynxe4TP3HHuQI1aw5RsYbjhW74AffxT8FogloE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U1Nuo9BG/WArfmqeLiByQE8emgBx2BdNd4743catN2JLgATCEBnb7jFq9ilVk0ZAr
	 3TJbyUX7+nO+SbohtOs8CUd4jDmVJNlDTv+76XnvV3yukjCApVcwdvI3X0s1EgKcMh
	 7/oVSlgmHSWIXuRUnQYuZsKDcc9FLvBpo9V3IVVyHEtROXeB4jgOKz08UMkgFzMnQb
	 Fld1KKy5XtHs+kRAVSZwbVTIbcEFpOKFTjXIWxmkk4b6nYWTzfwipWzEXWF9QgCxV+
	 Q/5u8G/WkGapLPOqjfQ4d4FZFoGdEZ1tLbcihOuXUQGAv3g+VPHVMYS5Br/FyAAYvj
	 gWTLS8JVm5X3g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE312380A94F;
	Tue, 25 Nov 2025 16:02:21 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <f61beafb-51de-8783-dbb5-b94d6fba7cc7@redhat.com>
References: <f61beafb-51de-8783-dbb5-b94d6fba7cc7@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <f61beafb-51de-8783-dbb5-b94d6fba7cc7@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-fixes
X-PR-Tracked-Commit-Id: fe680d8c747f4e676ac835c8c7fb0f287cd98758
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a2bcda5e139064b255531eb5889ff826a8b6995
Message-Id: <176408654039.819162.18388816949048673981.pr-tracker-bot@kernel.org>
Date: Tue, 25 Nov 2025 16:02:20 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, Li Chen <chenl311@chinatelecom.cn>, Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 24 Nov 2025 18:23:48 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a2bcda5e139064b255531eb5889ff826a8b6995

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
