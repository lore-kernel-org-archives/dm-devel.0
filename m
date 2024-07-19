Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8915149018
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721412569; cv=none; b=Ha8tktz9fFG1Pi/bpXnaY/8VfX3SxZvblNS+6se6FA11C7+xlN+b0B3nwiCRtX74b242eWg1ZKTGi+XWhP3RpvXPAmYMJ7wgMBso93/VChuq+v2qebSpbnzWsqAhrpoGQW+/86NAS1lVO2hm2+XHCqYq49hqMK8GFHAbfcpVRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721412569; c=relaxed/simple;
	bh=CLgSkH/Y5iVu2lUnrQRzzDH7bf6WFef9/R6sTKfWgAY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Gz0ZcMaz/6LQyitQx0W5bqsePiz5MCmVsbou8W87u/4SS1h9PpCIIFpXW+x++QcWeDeqK1vVOh3zH9sn18kdhTwaRkSdq5BlaH2VXutNuv6+ke8zqVOB01Dw5oNOwfphN2luDyXwfQZpN+1VfyWmOWuKk4qB05R12LrAH1aQrhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAumEBDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAumEBDg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80927C32782;
	Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721412569;
	bh=CLgSkH/Y5iVu2lUnrQRzzDH7bf6WFef9/R6sTKfWgAY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uAumEBDggWLC6+r8PI4+F4eIOLR5W+57mBbF09FiSi0A0f8Cfa3Ym4Cbt0Qxw22ix
	 H/YtL5cEIx/+l6JnJXgopVrRROmz2Ob2lSlN3PuuKtj3TIWNfiuxCZRSOf980JdcRB
	 LtZCGV8VoRGOksw7BdaqUJpn5/+u8baNcgz+z9Ztjmxl7+Pslyk6kQhEdx1Z/Vatgc
	 dmXxVOzRwV34gpEyLkNlH9K+aDh2yMsmuUn2urMdMbx9s5bEdmlklpsCw9ivbZe/0n
	 U4dFvkT0pjrdSR9Qv5/g+p4Z6ZAv1ddsnt3318/BM7e520w0CQmL7pD8Y5XE5GAfMQ
	 Y4dIZZ19qBrLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7172BC4332D;
	Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
Subject: Re: [git pull] device mapper changes for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <ce9cfca3-73bc-b79f-28ef-88c9ffc293d@redhat.com>
References: <ce9cfca3-73bc-b79f-28ef-88c9ffc293d@redhat.com>
X-PR-Tracked-List-Id: <dm-devel.lists.linux.dev>
X-PR-Tracked-Message-Id: <ce9cfca3-73bc-b79f-28ef-88c9ffc293d@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-changes
X-PR-Tracked-Commit-Id: 7f1c4909a821dbfd258177db9ec96dda3ae91346
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 661fb4e68cf62bf52eacfcd9b3b0d93fe4260c5b
Message-Id: <172141256945.2862.8511190240693841579.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 18:09:29 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, "Dr. David Alan Gilbert" <linux@treblig.org>, Eric Biggers <ebiggers@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Christoph Hellwig <hch@lst.de>, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Luca Boccassi <bluca@debian.org>, Masatake YAMATO <yamato@redhat.com>, Matthew Sakai <msakai@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, device-mapper development <dm-devel@lists.linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 19 Jul 2024 12:43:19 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/661fb4e68cf62bf52eacfcd9b3b0d93fe4260c5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
