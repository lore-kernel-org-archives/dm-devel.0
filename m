Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA319AF0D;
	Wed, 13 Mar 2024 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710349445; cv=none; b=neFzYBLGTfg0sN0t0HiD4CpHOd6PvIQwgMWhVb1iRu+weq5hhOr9Zz1egORDSuBJO42/t9DaUqMciM1OyQij08nzo1rEUMPaRXxL7wBy8/3s3AD+WbuIiIAvamRKLMdV8tg5r84JHSX6CTsKotaboC/B77nRXCy30j04a+7AZkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710349445; c=relaxed/simple;
	bh=N7LE9KXhWLqCJgHyjJFZZtb9L1TzaxLfv98xLSVoKxU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qcq+AunH3d0F5uOPSgDOTsLVdJImeXD0OVNHWfAGHIkmWIszFNBUCf3lq7cZS5lUwy6ecULJuyk4V6ydDjHCkTcogqfSGhb+Zd9Xb9QRv/XrgLOMMxvfmTfNkmZ54j6nvMROCUhfAEhbPu9G3jeY0qk+CbERh0zrODrWC98HU1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bzt1MI9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bzt1MI9P"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE201C43390;
	Wed, 13 Mar 2024 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710349445;
	bh=N7LE9KXhWLqCJgHyjJFZZtb9L1TzaxLfv98xLSVoKxU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Bzt1MI9P0NVyr2Qzaju/viSZmhVJav3gIO5xH7zPf0gl/C72bFlvnKyfpNkdUpTPa
	 /sYPCG42BG/g1+cKHNww9TT6Nl1rNW4sFDLeD9Yil6jtpOW+kBIQ2QUWsiMU/6JDjs
	 hgHvdUwnLA31aNboN5Lo2rOV4J0QT5AUoGChuGPjt8MaI5RvQPESJRC67M0COxP8y9
	 SOTyTHpv0Y6vwAeBIBzmmOvdivP9gU1ML1gfXFkAxhhCzH1sFA+TPtUzbxIjw659md
	 ue6i0p1197LHtbey7sA1hBuQ+dFRrLRosOqQdmGKo0qGUnf//rAe1ErkSex3eNdxli
	 mDwrumA1BebpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBA80D95054;
	Wed, 13 Mar 2024 17:04:04 +0000 (UTC)
Subject: Re: [git pull] device mapper changes to add VDO target for 6.9
From: pr-tracker-bot@kernel.org
In-Reply-To: <Ze9Q5P10RERiflfL@redhat.com>
References: <Ze9OCmWb-9LX5t8W@redhat.com> <Ze9Q5P10RERiflfL@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <Ze9Q5P10RERiflfL@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-vdo
X-PR-Tracked-Commit-Id: cb824724dccb3195d22cad96e7b65fe13621d0a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 61387b8dcf1dc0f30cf690956a48768a3fce1810
Message-Id: <171034944489.7471.13439636710855598442.pr-tracker-bot@kernel.org>
Date: Wed, 13 Mar 2024 17:04:04 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Bruce Johnston <bjohnsto@redhat.com>, Chung Chung <cchung@redhat.com>, Dan Carpenter <dan.carpenter@linaro.org>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Ken Raeburn <raeburn@redhat.com>, Matthew Sakai <msakai@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Susan LeGendre-McGhee <slegendr@redhat.com>, Yang Li <yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 11 Mar 2024 14:43:48 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-vdo

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/61387b8dcf1dc0f30cf690956a48768a3fce1810

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
