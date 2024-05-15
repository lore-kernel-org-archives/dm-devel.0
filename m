Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7323B293;
	Wed, 15 May 2024 01:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715737758; cv=none; b=ldTCn2fFpBs6nMzUlx2UYuHRW1zP2Armealtrg6SiVs9HP8+IDLqBeXKByUDIbjrhY3j7DxOrtnAuuA/fw84BOFNG4hR5nK88dVjeA1Pd/F+tOj6KM+hvQcC94nnqqafdCpwaqTRaYULZa/Jb6Dr9alRLxclt5aYW+6K/73yBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715737758; c=relaxed/simple;
	bh=hQMAZFhf7ihzw2VJOzuaSpN4197wZEIt0nPmaxcihHc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Hx3Atd0AhhTCB94aSbE6AHiRuNssj8qWsUSDr8LO6fzLIJBmRYwEvw8z0MZmal+yA8LSL1UobKaYaTxueZvLWyZFW1BQUxU7vTPTnsjYpbx36ZBq0l//bOYArSf1oj1Ke2YhfHG74g0wFw75A+dV7O4MqXtlhLxV02S8Nml0JTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjQW9gct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjQW9gct"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 927F2C2BD10;
	Wed, 15 May 2024 01:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715737757;
	bh=hQMAZFhf7ihzw2VJOzuaSpN4197wZEIt0nPmaxcihHc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hjQW9gct65g3C+g8BfuMl6emUgmYwelx1DVd+XbT3M8li0k7Pdo2+dCsyG9xl7C3d
	 r+gVILn+LJkIL/bba7KEHzHIRrjRiBwTWrhabw3HHLO9i8xoYmNByOywUsRwqJrCJr
	 ZDhz4lN0UmbXobn/tH9OzFnsSR/V+mieailgChFPvxlgGbyTeWToezVNEE2rVXc+iD
	 hRFzUsF8CEcSzkb9zo4GHORHPXGfr4aJjuVccoBDcmBuKeVpP/4TaviKvdOacTeXT0
	 lJKrDgl1xFIUxwKW1QJ4Les+4LM3zBQx2GgH+aJpb1nnmNGBnQkNP+RqoX/sxA2KKI
	 eF42yUvBqtrXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88B94C1614E;
	Wed, 15 May 2024 01:49:17 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZkOMczEgGuPBOCrr@redhat.com>
References: <ZkOMczEgGuPBOCrr@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZkOMczEgGuPBOCrr@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-changes
X-PR-Tracked-Commit-Id: 8b21ac87d550acc4f6207764fed0cf6f0e3966cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f8b6f25eb1e51febd426da764a0b0ea652ad238
Message-Id: <171573775755.23667.11330689717464782357.pr-tracker-bot@kernel.org>
Date: Wed, 15 May 2024 01:49:17 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@lst.de>, Joel Colledge <joel.colledge@linbit.com>, yangerkun <yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 14 May 2024 12:08:19 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f8b6f25eb1e51febd426da764a0b0ea652ad238

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
