Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F491FBB
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306696; cv=none; b=fS/bRppU8fbnX83sVS2Koo/wJpk6XUFWGB9bCDGHPs9efr3MPzUhIBUtWDS7jMijRiRlII+wJvHJrdiu/x4AAAXeU+5ZPxh0qmMGHtyPM1ENN6ydCuovBW46/aQjHpWOWOOlv7ZFVO1j422kSZc4dhsZlwD3dT5rhe2u8qd9PW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306696; c=relaxed/simple;
	bh=iSpfOIx0o9dbEGDiBN2NtB9eIseJUfY/7UsdMGG8muM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Udn8mTCPYy1SB1thfF9wOqNnPZ6alj0go+/oqJED3zQmR/pnt45DwjuW/RsDkRjvqH2+LlgYeqDhzn4zDshaf3JpY0sW+XsC1efAcWIMXK+JnfMcl+gjeFddEc7AkozhEw868K0X7uM9rygCXwV/sIbtGHHS9oT/UkZ8BgzRavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-43e0d564136so1982491cf.0
        for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 08:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716306692; x=1716911492;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3De1QFzgbPPwSmcZozXuROE2g1GOTCX6cTHGr9CUkjA=;
        b=ohm79CfwzbkWmMbRxQzUdgNfeRFZyWBLFJ7RS+PC6o3j+O7DYk4MZz1k5M3Ui1WE6X
         fP7w61+iTvnidjiZe5LDv6+n0UT4ryeApeogpsSGzQnsamtYfa4ttnNDn85xRwGS6xWI
         sDUeFMxQiJNZ35TDrzHfzsJt7297hSJftHCgde6XwZy6eG686TQuWMtbkuNmRwen88UV
         VQGFiSofBAqpkbSyewfSwVNzoaB2x7nUXdT5U6+iGmjM89qYHCCPmqN7xwn6PHQMHsTz
         pFH7d7PosTMVemQGxWZfNipjlwDjwRV+3iQqJ6Dxegn4f9N9V8KmO7PGCCKuz6dbBJIj
         sViQ==
X-Gm-Message-State: AOJu0YzJ8juryIxL6/ugWDS563ZxWPl5o91Vjfs8B5pbZnyCgsL4jTbv
	INl/3QnZ/vV1oEdq9cDwzjfsIc+FR4ayfIRo35iQWUNRcLnrSx610fzzEQBNKN0=
X-Google-Smtp-Source: AGHT+IHUEOPrgKJ6HbohQiTwSikK/8/E5PDHZvUKNBZxMqMWsSsJbzf+Kk/nlbrlqu6UwI3Ps6L4dQ==
X-Received: by 2002:ac8:5916:0:b0:43e:3c19:a2dd with SMTP id d75a77b69052e-43e3c19a722mr216079541cf.46.1716306691772;
        Tue, 21 May 2024 08:51:31 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e251233c6sm104502741cf.84.2024.05.21.08.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 08:51:31 -0700 (PDT)
Date: Tue, 21 May 2024 11:51:30 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>
Subject: [git pull] device mapper fixes for 6.10-rc1
Message-ID: <ZkzDAsx_7FvmFbSX@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 8b21ac87d550acc4f6207764fed0cf6f0e3966cd:

  dm-delay: remove timer_lock (2024-05-09 09:10:58 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes

for you to fetch changes up to 825d8bbd2f32cb229c3b6653bd454832c3c20acb:

  dm: always manage discard support in terms of max_hw_discard_sectors (2024-05-20 15:51:19 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM discard regressions due to DM core switching over to using
  queue_limits_set() without DM core and targets first being updated
  to set (and stack) discard limits in terms of max_hw_discard_sectors
  and not max_discard_sectors.

- Fix stable@ DM integrity discard support to set device's
  discard_granularity limit to the device's logical block size.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmZMv3kACgkQxSPxCi2d
A1pX2gf+NjaTP+6otMJ44sYwUGHuWtgwDy7NcoTiF4RvLQjjrUh8Lgm2p3i4evFs
4AzMNXy5V6/mEx/AZb7sjCtPkIGOykkBud3+jhStohQKvXEJQcYtwACNv151NW2c
Fw2tcPZbPKH8P8UkDkegLaCu+4DotYjhuw44dfHFVZ95Wlhcm2UmcjWQEf/LtYW0
Si2FE0z2n1yi1mY6cExuL0bJ+LaMrXRQzHE3ZPaPRn4PFNUTY1juKsHYbgyL7cZ+
xQM1W/KBrKzDztCJGKH4Cl86L3kNPRkiQ7BQ/2Wtse20o10EGT0+lPvevCNcPNpi
gbjAo7OPy9WPA9N/AR8Wfj06YQFaGA==
=Pp+x
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mike Snitzer (1):
      dm: always manage discard support in terms of max_hw_discard_sectors

Mikulas Patocka (1):
      dm-integrity: set discard_granularity to logical block size

 drivers/md/dm-cache-target.c | 5 ++---
 drivers/md/dm-clone-target.c | 4 ++--
 drivers/md/dm-integrity.c    | 1 +
 drivers/md/dm-log-writes.c   | 2 +-
 drivers/md/dm-snap.c         | 2 +-
 drivers/md/dm-target.c       | 1 -
 drivers/md/dm-thin.c         | 4 ++--
 drivers/md/dm-zero.c         | 1 -
 drivers/md/dm-zoned-target.c | 1 -
 drivers/md/dm.c              | 2 +-
 10 files changed, 10 insertions(+), 13 deletions(-)
