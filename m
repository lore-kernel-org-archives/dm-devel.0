Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFD8165F13
	for <dm-devel@lists.linux.dev>; Mon,  4 Aug 2025 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754323583; cv=none; b=riM/EskUHnr78eT2M46rNVly2GYHf13QKytAzZF6bvcdbx78OL2KA4phNr4S0y6PlcrPfsfYe8yfphIAqkqOFBCPtUBKjDsdbXNgYhPjVDl+K/iqPI8sabHEaE6Ovvad09RV/7fA67k+cAjRLKwRySsNCER4H2TOOuYcs+AQ5iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754323583; c=relaxed/simple;
	bh=lcHRrWvdm+8mpZ8S/x5V7zQh5L0vXPTmR+agN3TbZfo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sea/+03w7b+ZNzoKer0DAgTAKGDt/IjyOWxWZTD2jJ9VbqzRNE+7M0bYbLNE46xGxzw28JydtKAA63GRQLt6Fc9CZuu5UyXre+lx9RTjGHheLM3ChvVb67NNcoaANhPMzhPS6928l51n6ThTj3vTZoY6aakjXQbT0zj3xgc4v9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cd6vpX9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cd6vpX9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5245AC4CEF6;
	Mon,  4 Aug 2025 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754323583;
	bh=lcHRrWvdm+8mpZ8S/x5V7zQh5L0vXPTmR+agN3TbZfo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cd6vpX9TAo3zZ432FFDP1j4TnDJI6zZlZ0hS50Ev+pkEDTLUgCxufmOBavI/6bvae
	 fT6gZZl0kIVWkMP8oGCJuESZxvsvNB3I9H/YYj/S0sqSDUCXcC65m7r3dx/twSRq8U
	 MEsRRCCR6KYf+eaSH5znilR4JEGWhKUJz3xCw8w9/0XYbZsX9SwJIRoU7XtLpG0zhP
	 YHYsIUCkIJoCcOvVVSe/X2RzvqOGko1Xq7izVB0vkxRCkLfHYNuG3pOY3FKNpxLi+O
	 IcQMGowvxUC64PXQ7qmEr6YI4QWGEDNaEyVQVG0OKCMCgGO6KERq/n7XtoWEfpLPyX
	 bPS3rM0uNlrCw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF2C383BF56;
	Mon,  4 Aug 2025 16:06:38 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <abad6192-a8ff-2d7d-a101-8e5349b442c3@redhat.com>
References: <abad6192-a8ff-2d7d-a101-8e5349b442c3@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <abad6192-a8ff-2d7d-a101-8e5349b442c3@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-changes
X-PR-Tracked-Commit-Id: 55a0fbd2ac3fe8f61a30ea697b2eb3034f6778c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d632ab86aff2cef21f794e337a8e7f2320ac3973
Message-Id: <175432359750.1247654.17293064437132782009.pr-tracker-bot@kernel.org>
Date: Mon, 04 Aug 2025 16:06:37 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, Dmitry Antipov <dmantipov@yandex.ru>, Eric Biggers <ebiggers@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, Kent Overstreet <kent.overstreet@linux.dev>, LongPing Wei <weilongping@oppo.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Purva Yeshi <purvayeshi550@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 4 Aug 2025 16:02:28 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d632ab86aff2cef21f794e337a8e7f2320ac3973

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
