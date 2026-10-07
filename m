Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E54A2A5D
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791382514; cv=none; b=Zl0ZDOm6bQBcY30VkAQ9bFTo1vBnIqbU19XcEudZ9rv43gG3nLp2ijYzlvAK5pBG0h52ry2RxVXzhOCd+JsUtxd3mrAcv4gc9/pwaF+hMSEjNQ5ruxt2W9ErbQcRo2wuTVQWRYeo3viVFB5n4jlXeMqQszSvtXoedX5pQzMwGVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791382514; c=relaxed/simple;
	bh=4MNoMhj+VBPYnahjmXIz21vMi5oFpb32CVoK/h6Dpz8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XrV6NmA0m4itWnZ2EVB+3rmjOoV1ucu3iB3sj/dI7EBSvyVMX/gNssSkGcwQSphe7KgxVz9Uyyb2K4on6yDUu9SEUrkozHeNKOrNgW7fWuZAAqWZKaBxo/YXPI7NeOU9dVQ3ghJs8WxWksHaiiD3Nj5xRmrHgR53iYkaTYHd6Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctFYL7FN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctFYL7FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A441F0089C;
	Wed,  7 Oct 2026 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791382506;
	bh=sOaOfzNVSz+VVgibeIym565Y67D30DJnT8tJnAM15Cs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ctFYL7FNo64y/hYiv6yqxINp4ZExk/1WO41ieIT947c+3B3GvXW72BkpntKd2Y2v3
	 7LvIwpEPTY80mgccJ8ABqaKfdA5jzX2SruR/jXIW7EvKyIkw0u3VlyjOVRv/ml9mIP
	 aaGLZP3Dp7txkzG3k1YyV0RFQ8+j+5wmtJxC8xLS2VdsnUFX9c4wyajz2ilwH+1ARo
	 E2IEIKblOhnobeNU/dlsC/lMXyDM6V6XmU0LCFgyxmxRzzE7XIFy+LuAN6UeDm/BA2
	 qXDtZGdp/36rf73J7yZNs0DQwj9ygbd5CSFAWdPafE/NlmsEyPCvgjYuS+UxiOWpXD
	 F/8uCGWAwFn2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3623808209;
	Wed,  7 Oct 2026 14:15:06 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <36d38e30-5861-35c5-e375-a6b0fd889ed7@redhat.com>
References: <36d38e30-5861-35c5-e375-a6b0fd889ed7@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <36d38e30-5861-35c5-e375-a6b0fd889ed7@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes-2
X-PR-Tracked-Commit-Id: fc79aeb86a2c244c1f1894e2d8f2966fe2b60fa2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f2732620d6ec49d3e6c06831575eaec6bc99d42
Message-Id: <179138250478.3561993.2397774345411491165.pr-tracker-bot@kernel.org>
Date: Wed, 07 Oct 2026 14:15:04 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ben Cressey <ben@cressey.dev>, Ma Xinmeng <1564938642@qq.com>, Palla Raghunath <raghunathpalla.0209@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 7 Oct 2026 12:10:12 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f2732620d6ec49d3e6c06831575eaec6bc99d42

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
