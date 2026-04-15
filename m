Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D938B7C9
	for <dm-devel@lists.linux.dev>; Wed, 15 Apr 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292690; cv=none; b=Of6Z9srbNN8dt9i0tnssBZj8VX0nTcyp1fwcnv+nQnWfD7jGlZAqSEt3wc+W09Sr8fBFvGmAJEz8MKcDF0FPCPcFeA+j7f0QhUYIyBk3Lr1P3Cv3Hf0clZddnfLbgbogcckpHqFkNiRTW90kanhDS1US4Qusp3amwGTOWauX+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292690; c=relaxed/simple;
	bh=kRvhdR7dEQMwuRWBSlTnG3GBU4KiNPxRjQ2EBkmhq5I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OyWFfgc0mw6ZoXMENwRSXYaS6FFqDdiVpkhYHj1tcS6IMGenACXt/MZOqUXoFkLZlo9nuiep0DSK/ACwkQ6jWTb3czUWVhgFiYtaB5H3wmik4yaPvtpLk21X/1gXzqpOi7oJbnyyvZ76w97T0cZY5QHly0aaJodw4rLb5teIgYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qCzgh+Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCzgh+Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C94DC19424;
	Wed, 15 Apr 2026 22:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776292690;
	bh=kRvhdR7dEQMwuRWBSlTnG3GBU4KiNPxRjQ2EBkmhq5I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qCzgh+CxuJ2ErtOn60tqEc+nUxQYFT2JSLCTCqNji/KsbmNWdgZc9BQchlmyNb/6D
	 nRLptmivg0MgBfdvHQvkUAHaStqiz3+0Mhxhst4XUAc5UsmrUvcXCKSe9gHk9ZZS6D
	 DIZjdLqeHO5SbDITYnnohp8TU1aAFtJVcj1akFonAU5WWXWUYd4bIRol4hLUrtj3k5
	 EWkRsthY4dPZBdrvIOL5/ahPab6F1JY2lijhGjyog5u78McL2s7VIQKmvjAc0rsaDj
	 Yhn1elYL86kzI95AuzmzNwZLw1OItzJez2uoPQ7COYZh85ZuuFRV8cHMZQkRmOWqvT
	 wMPkE2xEid33g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CE6F380A963;
	Wed, 15 Apr 2026 22:37:40 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ad672n9Rn9CFIYyA@redhat.com>
References: <ad672n9Rn9CFIYyA@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ad672n9Rn9CFIYyA@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-changes
X-PR-Tracked-Commit-Id: 8c0ee19db81f0fa1ff25fd75b22b17c0cc2acde3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a5f998094fa344cdd1342164948abb4d7c6101ce
Message-Id: <177629265896.2482053.1935491747915388305.pr-tracker-bot@kernel.org>
Date: Wed, 15 Apr 2026 22:37:38 +0000
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev, Bruce Johnston <bjohnsto@redhat.com>, Colin Ian King <colin.i.king@gmail.com>, Eric Biggers <ebiggers@kernel.org>, Guillaume Gonnet <ggonnet.linux@gmail.com>, Junrui Luo <moonafterrain@outlook.com>, Keith Busch <kbusch@kernel.org>, Ken Raeburn <raeburn@redhat.com>, Matthew Sakai <msakai@redhat.com>, Ming-Hung Tsai <mtsai@redhat.com>, Rosen Penev <rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 14 Apr 2026 18:12:42 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a5f998094fa344cdd1342164948abb4d7c6101ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
