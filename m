Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356E13A89E;
	Fri, 29 Mar 2024 19:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711740451; cv=none; b=hJ1dJTLHRCGTrP65E0OYNZorHOj7bZSoSbeIFWc0kxSOhE5Z4gdc+vj8hmFfqNz75GBRsacPyWgbVSObYs0UYAkNZ8HQPn8ZA6FHTt1ZBw/7hoTyD+3w4EH4Xtmvp0XbI/WUlalb6udcF9pbLlkDPbS1FmO8vqYsr3N5338areE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711740451; c=relaxed/simple;
	bh=zQx6slfbQwkr5CxuDiu9WPG+iL7RXOVvhowcv+VoKpc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AW+MS9JqKexlsX8nvWV0/g4ltHPsnl8ORjQ147BLvRIZ+RPz3mq6XwUok66o7QajLZKffPQCY0q3hn82lRq1RnHCP5D3DrlLMrK+nmk4A1nF4ZDv1OjN6IO20AUt6vsoxj9xq1jnSzwG5iFu+FOaKOmwwbEAyUXURDLSi9lT+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DX+MlK3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DX+MlK3g"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C24D0C433F1;
	Fri, 29 Mar 2024 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711740450;
	bh=zQx6slfbQwkr5CxuDiu9WPG+iL7RXOVvhowcv+VoKpc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DX+MlK3gA5Sh5nKxM0bF97DFO9+mNrdgtyQvJeDvRm0tHPtV2LOflMyPUOxqUoBfa
	 8nhUOJO2jdvPT0YBiwmazYZRemwc4D1oedy+WpiBmbRXL+VzHGNKFrhkIMAUagfbaj
	 lMXiYhQ67ZmRjs1buVF5JYVjpNtXrxQ1b7aASjsk1InPhWT4/vLU7Uq7n+xPQ18vts
	 MRaw/c8hnRcBrStFXwx6PZAM+lQqJL1a0X/cjgXXGTHjAMHu8NgbnicnSwRV361P9F
	 OuP0m0TCZpIT3qlGhvN35KMJGL42CZo5JN8ai8N0moEi77vStUtBkfYTdqiMbyN4i8
	 ZEA5Zd8F3R6Dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAC8ED2D0EB;
	Fri, 29 Mar 2024 19:27:30 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.9-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZgbOJlMv2nYOEbWe@redhat.com>
References: <ZgbOJlMv2nYOEbWe@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZgbOJlMv2nYOEbWe@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes-2
X-PR-Tracked-Commit-Id: 8e91c2342351e0f5ef6c0a704384a7f6fc70c3b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3508f318a1dbbc6a19cc873bb312c7d221550ba0
Message-Id: <171174045076.16736.10562119489660838087.pr-tracker-bot@kernel.org>
Date: Fri, 29 Mar 2024 19:27:30 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Kuan-Wei Chiu <visitorckw@gmail.com>, Ken Raeburn <raeburn@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 29 Mar 2024 10:20:22 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3508f318a1dbbc6a19cc873bb312c7d221550ba0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
