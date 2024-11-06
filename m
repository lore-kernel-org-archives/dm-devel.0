Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC7F208214
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730916696; cv=none; b=L7ttt8oLfOkYCNjw8mvTfTpG3rR9R7tizQWJOYATJ6sB10RICBxqmsq1gwrKEqPvhXlxCAiyhjg15hs4n4I/zzMNLLbnvu4e2FQLZGlKj9So1uRG2QZPq6zOdJbBQ3PyBhSwy7Mb47fnuycbrvFrD2YOgHmv9tcPesWQM6WiN8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730916696; c=relaxed/simple;
	bh=YZjSfOy8pQg5lUcrUMtwQNovpD2noe1N3XoKYw6wA5g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tyDYofo0ab5lDdz+jcZcKE4CWEm3jO053tYBbjHhv2E/xR4ZHw2IxxCH1/XWFWkOALEg1VABvFZLbZtxq3mqVa/BtBfsXfWc/cqNXmPvb/CcJ357QfzE5cCXKk18ztv/ZadFVZKLZXtHuaUqHfx/JKwIojK75Sjx9r9Pm8ZXZlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MS0xaAPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MS0xaAPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBEC4CECC;
	Wed,  6 Nov 2024 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730916696;
	bh=YZjSfOy8pQg5lUcrUMtwQNovpD2noe1N3XoKYw6wA5g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MS0xaAPC1EL3QplodcI6v3uN32IwilP+z9kZqV1tS8oMg9RWt4cdfebnCx9mc0z0M
	 fNZMxosmeqzDO92bdGPF4s/qZaVjhom+xtHEs8KavGxV2as34YH2s4wFsfrLPgmH8Y
	 PS0TlMg2dmg+fbyCYDIjH72kBXH/CD1OeZfM9JaPhHrXpkmH4aoRCIoxV436eeEQ7/
	 fE0mLu3b/dZMHjGJzoHj5GdGOwQJEsoODOnx78dKB8hHJ7RUOwzuJsPxS/NZJa63ES
	 ry2RdzbElTDwIrkulRppG0zX37ls8JAuMyxZLH2IWXW7ykJXZ4sOITl7Q+8HEuwo0x
	 +gu4Z+rzPTNNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE503809A80;
	Wed,  6 Nov 2024 18:11:46 +0000 (UTC)
Subject: Re: [git pull] device mapper fixes 2 for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <17b8149d-5d70-9423-a904-fd0ff6aa243c@redhat.com>
References: <17b8149d-5d70-9423-a904-fd0ff6aa243c@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <17b8149d-5d70-9423-a904-fd0ff6aa243c@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-2
X-PR-Tracked-Commit-Id: c0ade5d98979585d4f5a93e4514c2e9a65afa08d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e23acf024895a50306508880a075efa18656322
Message-Id: <173091670546.1367622.10345094506958382825.pr-tracker-bot@kernel.org>
Date: Wed, 06 Nov 2024 18:11:45 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ming-Hung Tsai <mtsai@redhat.com>, Zichen Xie <zichenxie0106@gmail.com>, Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 5 Nov 2024 17:47:41 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e23acf024895a50306508880a075efa18656322

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
