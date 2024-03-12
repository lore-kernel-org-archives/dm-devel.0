Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714F757307
	for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710250583; cv=none; b=RqAaBbqOu3Od8WtrE8ZCr0BxQaLnT15L0n4qrBnUGOx8ts3aEe9KT3Kn3ysgek6gycCUSXvLZUNF71p3O8hRkpRme9REqVKmyK0QknqnBb+PkgPfTmIE+zMjPgZfv2+M+6MwXzRCpzRfo0P0bRqSxPXpfrbfCx7HQfC/qLWTDbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710250583; c=relaxed/simple;
	bh=bmUuuvESusiy+pZhS6PXrmBShssfghLGuwHkuPDQrwU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=duRdIYObBmVY+GEd0jEEU+omfT7oF2AW7fXwzJ4NpWa2bzaJIKs8uXXMwTelDpqqAEqb9SmOQgpvD8wJmhAqep4YUctS7nmvLlSC+wog+HpnsEBGW0+TFxL9spAHxpgYAO6eDuTnqjrs20Q2v+D47ri3wQ+CjBh7F9Ra7K3Vb7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-781753f52afso389835385a.2
        for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 06:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710250580; x=1710855380;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wRVwJfy2hVyEpKZtYOibpDw9Qz3j4RUWpPkp2OvpVok=;
        b=e8yrJEr+3ZvlABNzj5Cnm2sjCR3/ix0WnZRqa27W9HBe8aIR/yyrFVedgI3s6PHwm6
         fNmvYx1CmD5U4tbVAj9tjKJIpflS+YO0pSEJQD0fHWdv9p5BE85At/Ug+bI3xC2YaAQr
         IIZVMzktScRt0P4WGtFlvBhihh7R5aC3HwbXAX6HZYzxTavzwaXktm00zDvgXm3F2ZZm
         3YbTX+PnFXdCRripfU/DrDOzF+j1dTSh6VSwXPchwMnZFhmf+G+S4fvl3sEO4Dj7Zax+
         ZrIb0bsSbSfj1W8YoDSjNuo/1xQuR2znqQlMkEWOgUhpnL604tRa/SC63ld8r5eXxD7y
         bfuw==
X-Gm-Message-State: AOJu0YwNXqdGHyFUo0sHKQu7jtN4GHf9f3Z5Ca5nq2y//l/vB/VrDqtp
	Fsc8YXtRctavz+TrQ6WdugKGJfdW9FoyD17gh6q8zVT5gheYFHsZ63qa4M+QTg==
X-Google-Smtp-Source: AGHT+IGic3n9G3deCfgl0GmCPYG7YSpk6/GbuhN9Nf0ggiFI3GIT7wH3RIyrRlJ9Acz/oTP2NNPTgA==
X-Received: by 2002:a05:620a:2225:b0:788:6632:20e with SMTP id n5-20020a05620a222500b007886632020emr7245002qkh.34.1710250580232;
        Tue, 12 Mar 2024 06:36:20 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id v18-20020a05620a091200b0078812f8a042sm3701092qkv.90.2024.03.12.06.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 06:36:19 -0700 (PDT)
Date: Tue, 12 Mar 2024 09:36:18 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Fan Wu <wufan@linux.microsoft.com>,
	Hongyu Jin <hongyu.jin@unisoc.com>, Lizhe <sensor1010@163.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [git pull v2] device mapper changes for 6.9
Message-ID: <ZfBaUu2O0J9ST3PY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

I dropped this patch because it is only needed with the change you
reverted (commit 8e0ef4128694 dm: use queue_limits_set):
https://patchwork.kernel.org/project/dm-devel/patch/20240309164140.719752-1-hch@lst.de/

The following changes since commit 0e0c50e85a364bb7f1c52c84affe7f9e88c57da7:

  dm-crypt, dm-integrity, dm-verity: bump target version (2024-02-20 13:35:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-changes

for you to fetch changes up to 65e8fbde64520001abf1c8d0e573561b4746ef38:

  dm: call the resume method on internal suspend (2024-03-12 09:27:42 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM core's IO submission (which include dm-io and dm-bufio) such
  that a bio's IO priority is propagated. Work focused on enabling
  both DM crypt and verity targets to retain the appropriate IO
  priority.

- Fix DM raid reshape logic to not allow an empty flush bio to be
  requeued due to false concern about the bio, which doesn't have a
  data payload, accessing beyond the end of the device.

- Fix DM core's internal resume so that it properly calls both presume
  and resume methods, which fixes the potential for a postsuspend and
  resume imbalance.

- Update DM verity target to set DM_TARGET_SINGLETON flag because it
  doesn't make sense to have a DM table with a mix of targets that
  include dm-verity.

- Small cleanups in DM crypt, thin, and integrity targets.

- Fix references to dm-devel mailing list to use latest list address.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmXwWHkACgkQxSPxCi2d
A1oavggAtmftaoAXUJNdiYgIDm6/gKPa0CDyQEoD5cTyQ32R7c6SYNN7u2wrltHX
af36lzoksfsOra8uMa4+Q46/XFeqlRzvfu29bhmfAWMkMT3MMq7iGtTFG/SluD7b
NWjXhsUT8Fv2Q7BKglUc6cXUIbCZNwNUs5cxx2QobdrD57qxVKDz5HkH5/EggptA
cA6dpD7DbpWQhHWm0UN6cOmYNh4kGLiQs4S50N5hc7zlbXfJhhVzflecsVPY+MVN
wS/iv/hNenlLuJ7gzIPBwmxRgBbjHHbrbFNVa2yFrPQ8m/AuRbAUqYQO1sOXNOMZ
Mkk2G0IB7sJtpnEm+6l0x7A4VmSWvg==
=Eoxd
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Christoph Hellwig (1):
      dm-integrity: set max_integrity_segments in dm_integrity_io_hints

Fan Wu (1):
      dm verity: set DM_TARGET_SINGLETON feature flag

Hongyu Jin (4):
      dm io: Support IO priority
      dm bufio: Support IO priority
      dm verity: Fix IO priority lost when reading FEC and hash
      dm crypt: Fix IO priority lost when queuing write bios

Lizhe (1):
      dm crypt: remove redundant state settings after waking up

Mike Snitzer (3):
      dm thin: add braces around conditional code that spans lines
      dm ioctl: update DM_DRIVER_EMAIL to new dm-devel mailing list
      dm: update relevant MODULE_AUTHOR entries to latest dm-devel mailing list

Mikulas Patocka (1):
      dm: call the resume method on internal suspend

Ming Lei (1):
      dm raid: fix false positive for requeue needed during reshape

 drivers/md/dm-bio-prison-v1.c                 |  2 +-
 drivers/md/dm-bufio.c                         | 76 +++++++++++++++++++--------
 drivers/md/dm-cache-policy-smq.c              |  2 +-
 drivers/md/dm-crypt.c                         |  2 +-
 drivers/md/dm-dust.c                          |  2 +-
 drivers/md/dm-ebs-target.c                    |  2 +-
 drivers/md/dm-flakey.c                        |  2 +-
 drivers/md/dm-integrity.c                     | 14 ++---
 drivers/md/dm-io.c                            | 23 ++++----
 drivers/md/dm-ioctl.c                         |  2 +-
 drivers/md/dm-kcopyd.c                        |  4 +-
 drivers/md/dm-log-userspace-base.c            |  2 +-
 drivers/md/dm-log.c                           |  6 +--
 drivers/md/dm-mpath.c                         |  2 +-
 drivers/md/dm-ps-round-robin.c                |  2 +-
 drivers/md/dm-raid.c                          |  8 +--
 drivers/md/dm-raid1.c                         |  6 +--
 drivers/md/dm-region-hash.c                   |  2 +-
 drivers/md/dm-snap-persistent.c               |  4 +-
 drivers/md/dm-thin.c                          | 22 ++++----
 drivers/md/dm-verity-fec.c                    | 21 ++++----
 drivers/md/dm-verity-target.c                 | 23 +++++---
 drivers/md/dm-writecache.c                    | 10 ++--
 drivers/md/dm.c                               | 28 +++++++---
 drivers/md/persistent-data/dm-block-manager.c |  2 +-
 include/linux/dm-bufio.h                      |  7 +++
 include/linux/dm-io.h                         |  3 +-
 27 files changed, 174 insertions(+), 105 deletions(-)
