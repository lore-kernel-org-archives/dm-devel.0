Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873256ABB
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-778999c5ecfso479139985a.2
        for <dm-devel@lists.linux.dev>; Wed, 01 Nov 2023 09:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698855576; x=1699460376;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQtTpppYeU9AiypuUG+j2PUMePFfB94rnMKwVfmVaMc=;
        b=Ym9DZBIp+mx/094i4VyEvBDUP+wLaiO6Otwwbw+LYuMG2yDJDfS4RyxPD8X2V38L5g
         gjIz4LTAaQOPR4o+9MMXULB3OqwtcEQdRIp0hQIZOC4X2tiX3VSn7aX70GtcgQ2QQ470
         7Y+5nJekp5lzrEMhVUJ5K1HBauS/tVsyvpSeTMEtux2Q2x8sCM6f3ZEh9P+nPon6uG0g
         3IuDHycJtihQV3+FjNKTORj0MdYO9P2Grsj3S9V7vk3E4u8O5fOYgxUXfRP33OOg8X24
         LzdS2oDXZ57hCow4X4j3CEIdi51gjzfmVkTyuHs9AY0S6XyBaU3UObhvAb2v4JWdI1+A
         ypTw==
X-Gm-Message-State: AOJu0YyHyDm7gkCMi1buL5W6FS3YIirTV6hACzIvImtbA6iBG/8vgF7r
	QoUdiEQrlnGBmiTDD1FWqyqe
X-Google-Smtp-Source: AGHT+IHqr9/GGjbi2gSbzfcHIoxu0l/hcaUpr0DYzQPsXWnTrsUr+fnlf4uomSKcSePYC1EN9IIkQQ==
X-Received: by 2002:ad4:596d:0:b0:655:d82d:2fd0 with SMTP id eq13-20020ad4596d000000b00655d82d2fd0mr15069845qvb.21.1698855576378;
        Wed, 01 Nov 2023 09:19:36 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id lg18-20020a056214549200b0065cfec43097sm1601112qvb.39.2023.11.01.09.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 09:19:36 -0700 (PDT)
Date: Wed, 1 Nov 2023 12:19:34 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: [git pull] device mapper changes for 6.7
Message-ID: <ZUJ6lh4bDU/KqKBc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 3da5d2de92387a8322965c7fb1365f7cae690e5a:

  MAINTAINERS: update the dm-devel mailing list (2023-10-06 19:05:57 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.7/dm-changes

for you to fetch changes up to 9793c269da6cd339757de6ba5b2c8681b54c99af:

  dm crypt: account large pages in cc->n_allocated_pages (2023-10-31 14:25:06 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Update DM core to directly call the map function for both the linear
  and stripe targets; which are provided by DM core.

- Various updates to use new safer string functions.

- Update DM core to respect REQ_NOWAIT flag in normal bios so that
  memory allocations are always attempted with GFP_NOWAIT.

- Add Mikulas Patocka to MAINTAINERS as a DM maintainer!

- Improve DM delay target's handling of short delays (< 50ms) by using
  a kthread to check expiration of IOs rather than timers and a wq.

- Update the DM error target so that it works with zoned storage. This
  helps xfstests to provide proper IO error handling coverage when
  testing a filesystem with native zoned storage support.

- Update both DM crypt and integrity targets to improve performance by
  using crypto_shash_digest() rather than init+update+final sequence.

- Fix DM crypt target by backfilling missing memory allocation
  accounting for compound pages.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmVCeG8ACgkQxSPxCi2d
A1oXAAgAnT0mb1psEwDhKiJG26bUeJDJHIaNTPPw4UpCvKEWU7lTxzJUmthnwLZI
D+JnkrenAfGppdsFkHh1ogTBz8r60aeBTY31SUoCUVS/clwHxRstLCkSE2655an3
WNgrGItta5BRtcgTMxU7bmqVOD4Xyw704L7BK5CM4zKBQuXJtkegylALhdXvYSjs
mvHWoPczFW6Rv79CkF0uTkon7Ji041BvKVjbp+fYQf9Pul5d6S1v4Jrvlo2EqblU
6OM75OosNgziQhdw7faVOgFCVkQfLkEeYsJ47dBOjpC3+sbyKENbC4r+ZmkCZGyI
uJERswpmAkW7pp+Ab6sqG582DXvPvA==
=PPwQ
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Christian Loehle (1):
      dm delay: for short delays, use kthread instead of timers and wq

Damien Le Moal (1):
      dm error: Add support for zoned block devices

Eric Biggers (2):
      dm crypt: use crypto_shash_digest() in crypt_iv_tcw_whitening()
      dm integrity: use crypto_shash_digest() in sb_mac()

Justin Stitt (4):
      dm cache metadata: replace deprecated strncpy with strscpy
      dm crypt: replace open-coded kmemdup_nul
      dm ioctl: replace deprecated strncpy with strscpy_pad
      dm log userspace: replace deprecated strncpy with strscpy

Mike Snitzer (3):
      dm: enhance alloc_multiple_bios() to be more versatile
      dm: respect REQ_NOWAIT flag in normal bios issued to DM
      MAINTAINERS: add Mikulas Patocka as a DM maintainer

Mikulas Patocka (3):
      dm: shortcut the calls to linear_map and stripe_map
      dm: make __send_duplicate_bios return unsigned int
      dm crypt: account large pages in cc->n_allocated_pages

 MAINTAINERS                        |   1 +
 drivers/md/dm-cache-metadata.c     |   6 +-
 drivers/md/dm-crypt.c              |  26 ++++----
 drivers/md/dm-delay.c              | 103 ++++++++++++++++++++++++++-----
 drivers/md/dm-integrity.c          |  30 +++------
 drivers/md/dm-ioctl.c              |   4 +-
 drivers/md/dm-linear.c             |   2 +-
 drivers/md/dm-log-userspace-base.c |   2 +-
 drivers/md/dm-stripe.c             |   2 +-
 drivers/md/dm-table.c              |  23 ++++++-
 drivers/md/dm-target.c             | 106 +++++++++++++++++++++++++++++++-
 drivers/md/dm.c                    | 121 ++++++++++++++++++++++---------------
 drivers/md/dm.h                    |   2 +
 13 files changed, 321 insertions(+), 107 deletions(-)
