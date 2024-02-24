Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EE04D59B;
	Sat, 24 Feb 2024 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708798279; cv=none; b=Rg+RuGxE3NiLXsHyRERBzI0H7G6HgbhYmZdi+jeqT3WhB/8TcoovdbY/0yE32e39hAgAzEIms5tTCPQBlOk0bAd9vHdzAYwcGK2aplW/pV3IEhZ02YzA9yZwTBpeCdGeuSCTrNbjenT70Lz9wUrdGXv7v6eK8C9jW6BZLdx9zCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708798279; c=relaxed/simple;
	bh=frJK9Sfjll0tfHUKs0sEM63pCMlylhTsPrA5oLlV2zY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LkUVSSXWpsWseAltUnEM9O3xkxWvln7httapePR4Ew54sSwUbHITHp1Z0wuyzGZwY0nirq5yVGy/yEgJblk4YywZTFv2cm4js0kr1mlYjVI24yacvjOyaiz/8MCReDl29ZI8x07wQYNVN7C26xExsC9ZwzhJ2OYtI5UCr03KJ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VV0lbbgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VV0lbbgL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 803A8C433C7;
	Sat, 24 Feb 2024 18:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708798279;
	bh=frJK9Sfjll0tfHUKs0sEM63pCMlylhTsPrA5oLlV2zY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VV0lbbgL4qUt0DXCzaXhV8Y0C9/MuNmyjdCOzrSWpWYCty9Ab40FhJ4b8+1xH1JN7
	 ZKlQXYipIo/iLf2L6n+GHVb3ebg8brZHANu0NDWK+X9O/SMnNCQb2ASVjq7BdBf8/9
	 3UI5Dgk5sYRKuUXeHmiEBlZQq/7gDML1m2gBKhaCLT1sdHjT0k6GLUDCYZe0j19AYh
	 1XLRtCWlbXrAnrRWG5X61cN3LumwzcxVLd8MAPZMNzcZG3pScPgv1wDErXpQjccQvo
	 GXavUW7mE5JTMtyl6UcKnuuM1j8/8wKWu4PjOlT2A31Vp4vpEWuQt92Kru9e8YeKJy
	 sxzloVhZXKeCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F589C39563;
	Sat, 24 Feb 2024 18:11:19 +0000 (UTC)
Subject: Re: [git pull] device mapper fix for 6.8-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZdoT4rC0f5MkY6NQ@redhat.com>
References: <ZdoT4rC0f5MkY6NQ@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZdoT4rC0f5MkY6NQ@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fix-3
X-PR-Tracked-Commit-Id: 66ad2fbcdbeab0edfd40c5d94f32f053b98c2320
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2e367d6ad3bdc527c2b14e759c2f010d6b2b7a1
Message-Id: <170879827945.13776.3735586896147192800.pr-tracker-bot@kernel.org>
Date: Sat, 24 Feb 2024 18:11:19 +0000
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 24 Feb 2024 11:05:54 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fix-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2e367d6ad3bdc527c2b14e759c2f010d6b2b7a1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
