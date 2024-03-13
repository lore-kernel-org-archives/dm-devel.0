Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFBD19AF16;
	Wed, 13 Mar 2024 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710349445; cv=none; b=NtEq0CA3z9/DdrZoVELyhyZsbvJ7HkGg2/1opVEQdObscC6Z1+ykHAOTSo3S6NwzR88Xng63pPpNO2iVxxXlJgasWXQotH68L8PvDihcaI9IQZlwoJX8QlO8EigMcq4ziNGCXJK+mxSYxUvwOUGI8grS2ChulnYU9oHJGlVpU7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710349445; c=relaxed/simple;
	bh=CicKRqm756u3sn94d57iqbycU3fWhTRwLXCPp8jUfc0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bK7TlDMa3r1ESVxAAFn1m22e3xXkSdgxH128Jv8cFk5Ga3YUqFnZsxIdCOo6HsE1ChY7+S1+oP/Wvcb7BurLVXhS/jcC07JNrGTWenBmNULeDoJ17PINRB3pUa2pV5dG49vI2/XjpsKsFalaclQKgR2yoUT3FMI6fcqvzJ+SqqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4oOyHE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4oOyHE2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E2E1C433A6;
	Wed, 13 Mar 2024 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710349445;
	bh=CicKRqm756u3sn94d57iqbycU3fWhTRwLXCPp8jUfc0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=I4oOyHE2TuZChDDdMH9zuGmXkgII+67+kGoHYD7AT5Dx5VT9EIYKcMTOOrhwIehlK
	 wAsEFVxpRhVNjWf5vV2jQoWnXWTvJHi+QgwFGJMm9IHuAuVFtpmqxS2AZpt6GqhErg
	 xKsdd+DLu6+Hyn9YOsF+PFAKkP8zyrXIBNPPLPUPUgZshUgHW374rGGqQOPcIPzzjY
	 ACutl4I/gvRn2enGKeEhE6GOp9itQJCWal6B0p837kBd7VKCHUHKW6IeAEQWIZLxn/
	 JyIipxZ8jYVLJGqPPXrwekKQZqhFRqhW4FC3HAiq5I6GJP8eTmOyNXdckSlx76HajB
	 OIKKi7T0tsdZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29176D95054;
	Wed, 13 Mar 2024 17:04:05 +0000 (UTC)
Subject: Re: [git pull v2] device mapper changes for 6.9
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZfBaUu2O0J9ST3PY@redhat.com>
References: <ZfBaUu2O0J9ST3PY@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZfBaUu2O0J9ST3PY@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-changes
X-PR-Tracked-Commit-Id: 65e8fbde64520001abf1c8d0e573561b4746ef38
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2bac0823d046117de295120edff3d860dc6554b
Message-Id: <171034944516.7471.15723756413187930482.pr-tracker-bot@kernel.org>
Date: Wed, 13 Mar 2024 17:04:05 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@lst.de>, Fan Wu <wufan@linux.microsoft.com>, Hongyu Jin <hongyu.jin@unisoc.com>, Lizhe <sensor1010@163.com>, Ming Lei <ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 12 Mar 2024 09:36:18 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2bac0823d046117de295120edff3d860dc6554b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
