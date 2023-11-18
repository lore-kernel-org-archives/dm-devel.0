Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345A171B9
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-66d134a019cso3802576d6.3
        for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 08:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700323494; x=1700928294;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmjNlhzCWiV/pzFdRSQr2WSe8u2j+LeFg7yCMUNFqRE=;
        b=Tjaml4yglTp0gqqkyVSm3pNVWWLiPNh85pnbwsoqOKXOnV2aRmPtrzRskIRtrppZx/
         aiOVklm2nh/XGBWg2HXqlvjnvWtpqCNYu8jnud3RNhk/UpsELC9Sta4Jwych+oLq/c/U
         VJB5Ztz+vFwK3Lxa7+Tyh+WxXIpLt7owQCM1THyPV6phAOa8yYIq6ZwHtAJcCngm4KUx
         5qj6424Kgyn5n+ArvoldkyOkZCri1njHnJ007a2AlWNY4m9NYU0e07Vws65ZsXZpIHoi
         HIHt7YhBcJ+F0YOHgliWiQQhDHC3YaYexcbULwvZ0zN3DLmz3Xj2onIbz0fNvb9LuSGb
         MIHg==
X-Gm-Message-State: AOJu0Yy12wO+1x255Jgzm6juRZYkuZoZ3jMuU+TzN9hvKRJ/G0NqUcYS
	g99AfPuOnWRh4Mu3O/kgzjJe4Kjnk3jJhMZqvg==
X-Google-Smtp-Source: AGHT+IHoMsxWUn1iD0Xd/zCyDj/ZPuUai94lBqedMc6QyFk8vrxeIJoi/joIbcuY195VKmFWQ8t7Jw==
X-Received: by 2002:a05:6214:e4b:b0:671:e02a:8bf6 with SMTP id o11-20020a0562140e4b00b00671e02a8bf6mr2761078qvc.34.1700323494092;
        Sat, 18 Nov 2023 08:04:54 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id f10-20020ad4558a000000b006655cc8f872sm1478315qvx.99.2023.11.18.08.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 08:04:53 -0800 (PST)
Date: Sat, 18 Nov 2023 11:04:52 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] device mapper fixes for 6.7-rc2
Message-ID: <ZVjgpLACW4/0NkBB@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa86:

  Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-fixes

for you to fetch changes up to 13648e04a9b831b3dfa5cf3887dfa6cf8fe5fe69:

  dm-crypt: start allocating with MAX_ORDER (2023-11-17 14:41:15 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Various fixes for the DM delay target to address regressions
  introduced during the 6.7 merge.

- Fixes to both DM bufio and the verity target for no-sleep mode, to
  address sleeping while atomic issues.

- Update DM crypt target in response to the treewide change that made
  MAX_ORDER inclusive.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmVY35gACgkQxSPxCi2d
A1pt/gf+NVN/3N0BMYlc/L129+QCIreDH/PuhoxVxMLrhZ8oERw7XkgGIu5JoR1C
Sec5OWJWV0+AZ3kSeW8WBoFFGDdfTYQTId2R3mF3a+34mpAvjTMqnvGkA1GrixCt
xvj2cQjQkBWwwbikAkHZOUoK3UEPFurk/a7oXTAl43kZaV6gWHEAY/bxet9Wuc7+
NWN6xEg7sHhdVgJYltGkOl8Pf9y3zPDUT8SqFT0J7dPEGytNHscozDdRJiLmvoS6
g4WkMkrg87Ude7g0/l7hCM9b3ElamtMsZtyy43cvaKp3UrwFiAzFMCprEl4TS5Br
LNhuwegIBWMVCklRiTDG+uHnbMxKZg==
=9Lfg
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (6):
      dm-delay: fix a race between delay_presuspend and delay_bio
      dm-delay: fix bugs introduced by kthread mode
      dm-delay: avoid duplicate logic
      dm-bufio: fix no-sleep mode
      dm-verity: don't use blocking calls from tasklets
      dm-crypt: start allocating with MAX_ORDER

 drivers/md/dm-bufio.c         |  87 ++++++++++++++++++++++----------
 drivers/md/dm-crypt.c         |   2 +-
 drivers/md/dm-delay.c         | 112 ++++++++++++++++++++----------------------
 drivers/md/dm-verity-fec.c    |   4 +-
 drivers/md/dm-verity-target.c |  23 ++++-----
 drivers/md/dm-verity.h        |   2 +-
 6 files changed, 130 insertions(+), 100 deletions(-)
