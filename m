Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979C415CD74
	for <dm-devel@lists.linux.dev>; Thu, 12 Feb 2026 03:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770868766; cv=none; b=BqZUDgzju4JtTY2i90AGd7baR0QkfxEBBDcPlrzNkT8KnNai3nUH2vCbIl4lFViF/ekmlbKEvPLQr3htOsMk2qnGoMfqTEeoLh7Rnr1B/B/V6DQQoEBkrEGvhAqwzL4v24psGmDPAQdAX8Y0/I92ft/+Y39Ee2z/lD68hymkMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770868766; c=relaxed/simple;
	bh=msHxKueG5asbmGjTHneSY3up4w8u2WoM+q4OlnMo/nY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eoBTN9SM5zzLmgFFFThlDVa0oJ/6rohZz5F3VnIH4+h/KMeX+uPdqJ9TDu3c8AOHHBJ7x2tI3A2Bbx3XTc8A301+XjOewfTG0zjVZJgsZopdAtdKQ5EofLNGcgSZbXl3rx8Aqk2SwDX2JSIbQLsoS4KTwofnBdfYX4402JoigwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ephxTMVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ephxTMVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7755DC4CEF7;
	Thu, 12 Feb 2026 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770868766;
	bh=msHxKueG5asbmGjTHneSY3up4w8u2WoM+q4OlnMo/nY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ephxTMVaxA+ijpKxmak2EPS9VvoADxzwSK65q2hjVadNMiRER8gPdFFnmNsseCRGc
	 MP9A4ZRyqxpi0FC2esYqoZkbBlonYt3bBVrc14SF6f5YalI0C/YRP+7QFePrrHDPwc
	 ug53rpcRcelDfFkji68wbDW3kTFcH+j4Jyz18kjbNOzVN0ff3CAO3xo0abjEn6Ck3h
	 hIi4fLwJEAfCgoVasR9N6BIJAaVdfTUj33VzmFgtX6IbpgIdcjpeg9IQopeha3J3w5
	 bgf0IExsKL+3i3cP53sczUHxpN9cXgnVa6YIE96nsAEl4cGBjfATHzGXHSY5lFzX5g
	 3belMP7Gyvu2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 481D339EF966;
	Thu, 12 Feb 2026 03:59:22 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <30b93671-3771-b7ce-2553-e0bc1a4a17d2@redhat.com>
References: <30b93671-3771-b7ce-2553-e0bc1a4a17d2@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <30b93671-3771-b7ce-2553-e0bc1a4a17d2@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.0/dm-changes
X-PR-Tracked-Commit-Id: 218b16992a37ea97b9e09b7659a25a864fb9976f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 61e629596fabd7f60cc3748a603703c5d9b58428
Message-Id: <177086876079.893578.15253224516450907731.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 03:59:20 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, Akiyoshi Kurita <weibu@redadmin.org>, Benjamin Marzinski <bmarzins@redhat.com>, Daniel Gomez <da.gomez@samsung.com>, Ding Hui <dinghui@sangfor.com.cn>, Eric Biggers <ebiggers@kernel.org>, Christian Brauner <brauner@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, Li Chen <me@linux.beauty>, Marco Crivellari <marco.crivellari@suse.com>, Matthew Sakai <msakai@redhat.com>, Matt Whitlock <kernel@mattwhitlock.name>, Michael Liang <mliang@purestorage.com>, Yongpeng Yang <yangyongpeng@xiaomi.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 10 Feb 2026 13:29:05 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.0/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/61e629596fabd7f60cc3748a603703c5d9b58428

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
