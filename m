Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC6422577C
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 22:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716586; cv=none; b=BWqSvQ2cz6TAQRbtydox18PO8UQkHgi+5SgJzHdP1Sb/iDQD9uOx7ymnxhvmgeKkYS5IdseTcy17YNlr7DBDDSDbkqxnBLQ6iV9tjeceE2VLg1XtqjWUrWVsnneAYs2n3dlwXUCxnrepEoaZ8M0zVIMutcgzseognbLlB/xajQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716586; c=relaxed/simple;
	bh=8Rlt3j6L1NBtg28L6uFiqPRLpL4OmbdcIl/GIFXNMgc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iK1pUSlFWv86wCzzaZCzELExKURDWgz+76TAPAAsvyzJwYoM0rIk7HUjavSADTjdY16+jC3kyKa+DORM5+sXyNutKcYFV9XmEEj0LZi8Bd/zm3i2bhSIoZ3q2DclXyjFn8BRo1XRwVAg/4DUYyVYI3ids+pla8h2vB4MaKJX+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufsgNtyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufsgNtyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51349C4CEF4;
	Mon, 23 Jun 2025 22:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750716586;
	bh=8Rlt3j6L1NBtg28L6uFiqPRLpL4OmbdcIl/GIFXNMgc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ufsgNtyYmBSb0udfCjJznOnJ78gVr0/DhiPy3SbgZ2Mo9L6LdTYwa8kn1Z4WIkQdo
	 mmJdroAANVn3JfcuLfj9ky4+o+REVqmLx111j2IbV+x288MsJL7ExzmYCXTi7BMHHT
	 Le1GOV8bpnHddEFZ5qHPrEZlFcnIR3TT1/L6d4RdfKqVaP6Si4aziXutjnDx+NIC7u
	 mDIlubHQaOlEfS9DKYNmT5x0qkOh7J8sD+bsLyJdOq7A7qxomnL/8oC+OMXpfYYhh3
	 BKk7kynNWnGswBSAs/CYeUlYtSOE4sZaDV1CJ4FiJN5FHKzNovxMTRQ/RJTyFPAkzI
	 /2fzWs9ramqdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7123B39FEB7D;
	Mon, 23 Jun 2025 22:10:14 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <4ac30b56-92f5-c33c-1270-864fd5ceee90@redhat.com>
References: <4ac30b56-92f5-c33c-1270-864fd5ceee90@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <4ac30b56-92f5-c33c-1270-864fd5ceee90@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes
X-PR-Tracked-Commit-Id: db53805156f1e0aa6d059c0d3f9ac660d4ef3eb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78f4e737a53e1163ded2687a922fce138aee73f5
Message-Id: <175071661338.3311076.12683403294108835094.pr-tracker-bot@kernel.org>
Date: Mon, 23 Jun 2025 22:10:13 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Heinz Mauelshagen <heinzm@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Milan Broz <gmazyland@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 23 Jun 2025 18:13:51 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78f4e737a53e1163ded2687a922fce138aee73f5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
