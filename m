Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1C24DCFB
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748992841; cv=none; b=B6EadwTrUnOAkuWeYHkTiMQURbiKxUXbp8gSs9ziCBXg2JmQL5qCH/Iq3PrkEUbZJlUG90IpZ8hB3NgoGWZhOzwCcvRUCpgGUCSEhELXeuSEs+BbyhltkhVJVEhRG88zUiFLISJNmRWTA1S5YcmFb9J9mWnleFfXDAvrJEWnmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748992841; c=relaxed/simple;
	bh=JLGB3wqn3Y6tNzT+67EBSkDMiftDUV/dVw1tT7GExnU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SR9jn5sS2wXRiVrMjSWYI0TEsifpo/6EbK9dx0LwCbalEwhWgim6hGhwTdQw4M+P+4xFNRFVAYaSIbzr8gK8ze94ZLcgFUIFSaAVze9mpCtpSbcDrYy0yXOloAF7KuGDqqmT4C0GftgmCumucvEA2h5LrbJsL0jQxAHpO+8Gbg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KECctGQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KECctGQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E32C4CEEF;
	Tue,  3 Jun 2025 23:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748992840;
	bh=JLGB3wqn3Y6tNzT+67EBSkDMiftDUV/dVw1tT7GExnU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KECctGQd7S18lLKqxMThIwcEvjkDSS29Wq0vIP3HNijdqy6Cw1lwVUoSUsHzEcxXK
	 jbJt0A9nYYQYsCZnP3y+MfQn5nDjrxvo/rAn174DHzy2vPmejW0/D4w6rhwWPalY8i
	 hPHAKPLgbuI0ROGURAStbO92NIhPV2KN+uOIcFje0XhT4dHPbs8Bq5+Xf9H971YReF
	 26QsCYdQRpngCWIoyL0kX8pvnQ22dJjla8GMJScvx83ldREXDYbet4oYABQOTsgjdg
	 Vwn3kLTbCvZ3O3UYjlVvURvmgPOdbz3O+svK80Zc1eqe/g5xM41aAoiU9xeKVNC8le
	 oQH2JzloScnsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D15380DBEC;
	Tue,  3 Jun 2025 23:21:14 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <ef920398-c100-7c69-b7f2-50009396b99b@redhat.com>
References: <ef920398-c100-7c69-b7f2-50009396b99b@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ef920398-c100-7c69-b7f2-50009396b99b@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-changes
X-PR-Tracked-Commit-Id: 9f2f6316d753fe80c764e924cee475306f38ceb6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3c727285f1c99b4be5458ba68329748b207584ce
Message-Id: <174899287316.1701538.4991481769581765853.pr-tracker-bot@kernel.org>
Date: Tue, 03 Jun 2025 23:21:13 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, Benjamin Marzinski <bmarzins@redhat.com>, Eric Biggers <ebiggers@google.com>, John Garry <john.g.garry@oracle.com>, Kevin Wolf <kwolf@redhat.com>, Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 3 Jun 2025 19:36:05 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3c727285f1c99b4be5458ba68329748b207584ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
