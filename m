Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0EA13EFFB
	for <dm-devel@lists.linux.dev>; Fri, 27 Sep 2024 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727454917; cv=none; b=i6ut2Yh5posqGdu83uyO62K1ZChIn5PsXRK+HfIub5RuHNKgkD45+lyeM+24gckdM8jExAf2p2jy3EV+ywbYmt5Drh9tALbxDg0P9SVCXZEvXHqPYSUVO0hzo8j3rMbgYxS1t5dyr2NsSByrHpOm07ALv/1kOjaqb6CjQVNaov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727454917; c=relaxed/simple;
	bh=AZQRnU9JAf3TfMlKGRNH7TDaqa1Hies2cFbNKaC5ewc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tLe7Ot6Pb25nr+HFFpX/gFIR7Z0xbACcxnxOt/QdD1lEiwUQvBPpBw8Y+uqJjwDeDiVk5fy8T8BvIMTCdTRM6v4RrIOwnsgckQZQhsBzRZge30I5p9wzUnylKtPLSvqit+15d2gNee6+lUyrLDEBmrZuSmjJeer34JCsL+85SUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+4uaEK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+4uaEK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8262BC4CEC4;
	Fri, 27 Sep 2024 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727454917;
	bh=AZQRnU9JAf3TfMlKGRNH7TDaqa1Hies2cFbNKaC5ewc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=n+4uaEK3RZK8MmSMZ139xlUxs+a86d4GtbdNlh/LMsMdhTprVdSbyZk1gJUbI/xMC
	 2l4nVTsmOzhwJcCU06zF0NiyPVwRBGMdMj+o0rHE0S7+VIcz6yvQyENCWg3lr2b1TJ
	 ds/mvK9h3NELQqdfgkjXIrmfnhLl1mOxSyK1aXghCnJwngvRHw2PEJaemzN2CPZbsV
	 rTuJgyunfJrvzPeS87QFumvv2xqki3bDta40pdTnfl8VOugaS33D4Bqe/Dui6XvPyn
	 zQvswsq52jIqP+c43EsJQQMr8zqtEyPBTSO5dx5oQNa28rF/8gnWJau7c/EWHG2gwI
	 9YdnEl8uIy18g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E473809A80;
	Fri, 27 Sep 2024 16:35:21 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <892af38e-2c56-181d-94ef-eb53de22e234@redhat.com>
References: <892af38e-2c56-181d-94ef-eb53de22e234@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <892af38e-2c56-181d-94ef-eb53de22e234@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-changes
X-PR-Tracked-Commit-Id: 579b2ba40ece57f3f9150f59dfe327e60a5445b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e477dba5442c0af7acb9e8bbbbde1108a37ed39c
Message-Id: <172745491996.2017197.4171276583330998582.pr-tracker-bot@kernel.org>
Date: Fri, 27 Sep 2024 16:35:19 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bruce Johnston <bjohnsto@redhat.com>, Dipendra Khadka <kdipendra88@gmail.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Hongbo Li <lihongbo22@huawei.com>, Chen Ni <nichen@iscas.ac.cn>, Ingo Franzki <ifranzki@linux.ibm.com>, Ken Raeburn <raeburn@redhat.com>, Luca Boccassi <bluca@debian.org>, Markus Elfring <elfring@users.sourceforge.net>, Matthew Sakai <msakai@redhat.com>, Shen Lichuan <shenlichuan@vivo.com>, Susan LeGendre-McGhee <slegendr@redhat.com>, Yue Haibing <yuehaibing@huawei.com>, Yuesong Li <liyuesong@vivo.com>, Zhang Zekun <zhangzekun11@huawei.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 27 Sep 2024 16:02:55 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e477dba5442c0af7acb9e8bbbbde1108a37ed39c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
