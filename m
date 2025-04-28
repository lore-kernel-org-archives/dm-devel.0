Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9BF25392E
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 19:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745869484; cv=none; b=HuYejdL7Phok7WcX4ThGFt7sUwEl9m98tSb0JIJ/OZBE0v6cCiYUI+Ymc07j2D5GhpJF5wXKG82RneQ63qBLH8R2VLM1f5KxaQ9mS+pqZvQeEfzboqVI5ZzVsczJgpmrv/lJajPynw/i7eqTNVfXRz8DWqBs2hfdk1vAGYmVZfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745869484; c=relaxed/simple;
	bh=l8/Su25FRqSfQ+f7kmaeQ63GMPQL6MNl1oTFok0lOmU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jGR7kkNcj3Gvn5cAoeyy+v21RE1F1CDRyrvSGCrpu7Zh0TnaRGckHjc1Vyd3OBogSnviJ92pp5TIVZxb178dQqrNOP5LN9mgbJXAEcRp9qYyZnvmEnqDu+QGXurlSzDY3qgVHdLwlXJdA32gUKb5YeKHaTvJuIcGQT7tieBKpYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuzR69oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuzR69oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF06C4CEE4;
	Mon, 28 Apr 2025 19:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745869484;
	bh=l8/Su25FRqSfQ+f7kmaeQ63GMPQL6MNl1oTFok0lOmU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UuzR69oh10yqj7iXlXUTzso1ucEkKA9pmyc0AZ1qyhMbwzn7gNoJto6CqH9W0NHN2
	 u60Fw939DRWIAqvF0ERorplhGXV70swoihDRQQRZ3wbsxiw3XulFkkoWlwrjsA3hVz
	 DDY5Nn/z98C0/Xb//4L49ISiWmuQU/025ER+aSkFXp4fOnf3adBCje811nyR1Xjc3T
	 h2T1d1JTPTf0+lxfcz6BVeX6YMQBlvCTRlQdQWO6WNDx4oSHVBReHp0fYk4kokK/FW
	 O2avjZbZHbR1/OHoxpMh6Mnhf7JkVsMjk03JgFnN+sdE26bSEtfSEEi3+2qValrl4u
	 +/dD4AIeRQWBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F5A3822D43;
	Mon, 28 Apr 2025 19:45:24 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <7f751e0d-49ff-9099-5269-af809a70fd08@redhat.com>
References: <7f751e0d-49ff-9099-5269-af809a70fd08@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <7f751e0d-49ff-9099-5269-af809a70fd08@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes
X-PR-Tracked-Commit-Id: 5a2a6c428190f945c5cbf5791f72dbea83e97f66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78109c591b806e41987e0b83390e61d675d1f724
Message-Id: <174586952276.1022398.14599879438742288778.pr-tracker-bot@kernel.org>
Date: Mon, 28 Apr 2025 19:45:22 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Benjamin Marzinski <bmarzins@redhat.com>, LongPing Wei <weilongping@oppo.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 28 Apr 2025 18:01:56 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78109c591b806e41987e0b83390e61d675d1f724

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
