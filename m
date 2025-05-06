Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB091284B5E
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549464; cv=none; b=luO7iYvIN5SHLfRKtyVq9fzhrw7a6YXaMzeGtGeWs87IcRzgCFgiYsK38K9dvG2FJxU1av6GAeGxTYnl31mgh7OB6+VDu422EKDwDxGdcpFsJxVg4Mg9MTh6HBShxitNgtIm71IzmU1famnT8nZr/faHY5cGCsM8SNwQVwFaHxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549464; c=relaxed/simple;
	bh=8JJaNJStPQrgJrLmILJYS1JlbbSWpQ/goa2952Etjwk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eP+W8gVnkT5sDemvcTg/0a3KNVdjV1WdmGJNz10eSRxCQHRSmGAWm9Ao8hWrkzF1G2nHNkPDlPJg5OwQTXKoDDF6m/EMdZL9OVpIX9IrBhhv3qn1lI1NJjivVaz06r7eNeT4U4YvCYOcIfm3TCIVvie/QgkXHEGPaMDR10npvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guQc1vCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guQc1vCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD91C4CEE4;
	Tue,  6 May 2025 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549464;
	bh=8JJaNJStPQrgJrLmILJYS1JlbbSWpQ/goa2952Etjwk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=guQc1vCnfIn3Kl5tnOxetYMFRJ8FH63X7psuRhODmNngYI2VruzVMGvcXx3BLYoAw
	 UhpXGOGpJ7Zas09IIjXjD/lCepp9hXhu6Og6uyoZUPMuv6lscuMs75nzu6MquTP61F
	 4A/DoaI0CVT7SB6C65wBoMawH+5Mz6bkXBAHhpjGxu6sWW44tjuw+y/Wbo5Dmz2u+e
	 uPX59nlYLieNZcZTAa0e2E7HYRFeej/LFM/iG9fYnMtTR4J6qnPwf7n9gV51OghkcL
	 UGTNy/0TCX+Z/7qGf66H1XWPsuYXhWs+2gzksGzChvRQTmXR/rMxyf4DD3PwvhXDph
	 /Y44TliDBSFww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE43380CFD7;
	Tue,  6 May 2025 16:38:24 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <32f30a35-1bab-0538-8cd8-31ba3635ea7f@redhat.com>
References: <32f30a35-1bab-0538-8cd8-31ba3635ea7f@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <32f30a35-1bab-0538-8cd8-31ba3635ea7f@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes-2
X-PR-Tracked-Commit-Id: f1aff4bc199cb92c055668caed65505e3b4d2656
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cccd03371475e4c25ddad7f5b2467d9b4d3f5a09
Message-Id: <174654950318.1583977.120993953881906101.pr-tracker-bot@kernel.org>
Date: Tue, 06 May 2025 16:38:23 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Carpenter <dan.carpenter@linaro.org>, Tudor Ambarus <tudor.ambarus@linaro.org>, Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 6 May 2025 14:26:45 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cccd03371475e4c25ddad7f5b2467d9b4d3f5a09

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
