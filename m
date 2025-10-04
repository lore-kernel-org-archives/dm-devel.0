Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD426222582
	for <dm-devel@lists.linux.dev>; Sat,  4 Oct 2025 02:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759545725; cv=none; b=ma1CBCpvdoH11HIxyv6zOqGJSpwL0HZkKFpe0f6Hr7zcqc/fUvXGjbUVO6jHHpWLGehdzK9YnS4wlEI1h1rytm6Pdm+fLBqFQE2bPWkn6TSac6MZgJdGOatYtaqUjktYcd843wAXWPAoq7PJZ/x/dpKQiVeOS9Mqr54a5Y6Eink=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759545725; c=relaxed/simple;
	bh=RMbGSyRK4w1wpD30Iq0samN3N2QPS+aXHjctsF+/0uA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ixqJ76J7ABKjWNfHVLWfgiZoZ6vFRmf2U3EcfabIlaXKQPAN+oN1jDiUku3Yz/KogXsGiDAbSWExbBJYdaRPV9qxHYRf/++DaEUdaZKJNAveQfjrLs40PXmpeL40Ne7Cg5CKvJod6NkBT5ms3DXg1wqtsniVdyrdecZiT6IREt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCLYP6Ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCLYP6Ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D5BC4CEFD;
	Sat,  4 Oct 2025 02:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759545725;
	bh=RMbGSyRK4w1wpD30Iq0samN3N2QPS+aXHjctsF+/0uA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YCLYP6IjEdGEKHQPjyHwU4sA5JGoV5mmiH10odaQZAs+GJAIMtjjyc8CweQxYOoG2
	 ksHAkA5owHRl6J0h97wy0e5W/wEAZnHtIQ10bdvzjnmf56f252IgzMJXDek0Z3rpO0
	 ifwKSYXteofy5YbTFGMNep/fuw09XT8I3rRYF/qDMJSZOFaEDDqyNhsQadkMSZpxU7
	 23QGXP1GuznODBjnP06XjXAhp8lgNTB9gUaMmFtXUgpwDVR05LJ/y6pkIx7c6fjexM
	 YnhbTeHu85gT89e88qTxlChdoWwzjGIeMzlBYNRNbmwueEfFUDroK0JLiV2z7I1Rbx
	 nI0RHg/PlbGYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AB09539D0CA0;
	Sat,  4 Oct 2025 02:41:57 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <b85c04ba-3708-82b2-72b0-63d026c4d7c0@redhat.com>
References: <b85c04ba-3708-82b2-72b0-63d026c4d7c0@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <b85c04ba-3708-82b2-72b0-63d026c4d7c0@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-changes
X-PR-Tracked-Commit-Id: 55dcfdf8af9c38cce6f5b2058d3b58dde25e5020
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7dbec0bbc3b468310be172f1ce6ddc9411c84952
Message-Id: <175954571644.163446.2077559948679486023.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 02:41:56 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Bruce Johnston <bjohnsto@redhat.com>, Dmitry Antipov <dmantipov@yandex.ru>, Dongsheng Yang <dongsheng.yang@linux.dev>, Heinz Mauelshagen <heinzm@redhat.com>, Christoph Hellwig <hch@lst.de>, Ivan Abramov <i.abramov@mt-integration.ru>, Qianfeng Rong <rongqianfeng@vivo.com>, Shubham Sharma <slopixelz@gmail.com>, Soham Metha <sohammetha01@gmail.com>, Xichao Zhao <zhao.xichao@vivo.com>, Zheng Qixing <zhengqixing@huawei.com>, Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 3 Oct 2025 16:09:55 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7dbec0bbc3b468310be172f1ce6ddc9411c84952

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
