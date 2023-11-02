Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1B3ED8
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 00:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbsMFjWz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D764C433C7;
	Thu,  2 Nov 2023 00:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698883288;
	bh=fK0TOZUZos56ZMpKXSRn0yHhoFD6egOIMGjLoYbNvLw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EbsMFjWzGi2jsp81P8H2ZjXPvQuHK8t27g7DMoJk70gX7qWxZKOkVhECTOgfycjep
	 LCkuDQMuLscB6G/MfFdv8Eq/bfzD4CND1BIzLa543HLi/Z86ZspcfOxL8pGS5Dxs6/
	 7w8ZEc+ZP0rpxlc2q5y7rv9JqXBhNxF6m7fsZoI8QuXDNuKGvfC1KGmL4xGfSjX8x9
	 ehS3TMyqo/ysl7HIFJkzRD4uDgRrhFI2pt6TtRBimnxo85ShK9Gt0fqXFaE5cHT2ZO
	 BKXGZO+/tLbt0dDHnf+nzhMiaIy2pnlFf3vqEY2s2qCRY7umSPg5FtSSqvCiENcJEZ
	 yF+CC139Pjbrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B124C3959F;
	Thu,  2 Nov 2023 00:01:28 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.7
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZUJ6lh4bDU/KqKBc@redhat.com>
References: <ZUJ6lh4bDU/KqKBc@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZUJ6lh4bDU/KqKBc@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-changes
X-PR-Tracked-Commit-Id: 9793c269da6cd339757de6ba5b2c8681b54c99af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0364249d2073c32c5214f02866999ce940bc35a2
Message-Id: <169888328856.31464.9891721377879395427.pr-tracker-bot@kernel.org>
Date: Thu, 02 Nov 2023 00:01:28 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christian Loehle <christian.loehle@arm.com>, Damien Le Moal <dlemoal@kernel.org>, Eric Biggers <ebiggers@google.com>, Justin Stitt <justinstitt@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 1 Nov 2023 12:19:34 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0364249d2073c32c5214f02866999ce940bc35a2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
