Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8F23E342
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783798681; cv=none; b=EEZTaWnCAcBOUj6N9ApCs7+cs8fTjs4OGDpwt+VxkHMinN5buGXIK34eYygwb20ksHwNh20WOwsTgXdVOIvkiKIKnPf/sI2jpWoiAilOcK8uXrw8jFc9T9ZDrSR+PNskQb2cq8D4WwAjm5YYDLNGSpV53Eat6Xw3I6DS6R4dqCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783798681; c=relaxed/simple;
	bh=mgGSZH31roZs9/OkNXNspoihXW00aoxhUf1vvvwZTwg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Hzx96r1KMBpq7/C3ECK0JBi+l7EpNj7tc+tqMIhmVsWy9cq8hgdL9LJNyV4IcX7tHtHAoDT4f6CTpw3pVAET9rX5vXCL0yJ39MDfsPwFzuJa5bJ20OSy6XTbCr9BGSUzgSKNrbrYkMUtX6MSNXLvBRMVO0NdVHdfLjxOKtNzZUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnwRiNWz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnwRiNWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783798678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=si6JlENi4bnjfHXfzoOa5cMYTPvKJJwOqQ9QabZj498=;
	b=GnwRiNWzuFSSvwnHABCrlVclP1MhKRAZiCSfrFVe+ajBHwzrEKSMDEKOeAD3qp0ZMqsajI
	hPZqb5iSqgHnnDmrz7yLCaeWU/cvSqId0TQVqVJPTqVTn2aRnb6+lne8R3Ox6kgIbuZQfW
	byewV+QxJkST7XXv9Y/FpnXVoqiQFOg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-LKOAGY6BMxiMWKFDXK_E-A-1; Sat,
 11 Jul 2026 15:37:55 -0400
X-MC-Unique: LKOAGY6BMxiMWKFDXK_E-A-1
X-Mimecast-MFC-AGG-ID: LKOAGY6BMxiMWKFDXK_E-A_1783798673
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 938EB1956058;
	Sat, 11 Jul 2026 19:37:52 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08D6536933;
	Sat, 11 Jul 2026 19:37:47 +0000 (UTC)
Date: Sat, 11 Jul 2026 21:37:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Cao Guanghui <caoguanghui@kylinos.cn>, 
    Genjian Zhang <zhanggenjian@kylinos.cn>, 
    Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
    Ingo Blechschmidt <iblech@speicherleck.de>, 
    Ming-Hung Tsai <mtsai@redhat.com>, 
    Samuel Moelius <sam.moelius@trailofbits.com>, 
    Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 7.2
Message-ID: <624cc8db-c745-7cd2-846f-efbb6193aa33@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wJNs4uw3MkDXm0bTi-m9PzZ1DRnQu9fLhSa6dKvuZQ4_1783798673
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda:

  Linux 7.2-rc2 (2026-07-05 14:44:06 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-fixes

for you to fetch changes up to 4b22d0801fadfcae2e106e6ba32e49439c7c7ebf:

  dm thin metadata: fix superblock refcount leak on snapshot shadow failure (2026-07-11 15:18:51 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- dm-log: fix overflow on 32-bit machines

- dm-era: fix out of bounds memory access; fix crashes on invalid args

- dm-verity: fix buffer overflow in forward error correction

- dm-thin: fix misbehavior on I/O failures

- dm-pcache: fix NULL pointer dereference on invalid arguments

- dm-inlinecrypt: fix memory leak on error handling

- dm-integrity: fix ignoring the 'fix_hmac' option on device open

- dm: don't store the keyring in memory for a long term

- 12 miscellaneous fixes for bugs found by Claude Opus 4.6
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCalKUaxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbbQwAP9pHgNUinD95o9vnu3d3QNmjnEDmrgZ
+kxNFRpWXvbzKQEArYWPLS/2dwf4nG0Fa8PtJTwkjI/6UeublAy5MrdTqA0=
=pkBx
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Benjamin Marzinski (1):
      dm-log: fix a bitset_size overflow on 32bit machines

Cao Guanghui (2):
      dm era: fix NULL pointer dereference in metadata_open()
      dm era: fix error code propagation in era_ctr()

Christophe JAILLET (1):
      dm-inlinecrypt: Fix an error handling path in inlinecrypt_ctr()

Genjian Zhang (1):
      dm thin metadata: fix superblock refcount leak on snapshot shadow failure

Ingo Blechschmidt (1):
      dm: avoid leaking the caller's thread keyring via the table device file

Mikulas Patocka (14):
      dm-verity: fix buffer overflow in FEC calculation
      dm-integrity: fix the 'fix_hmac' option
      dm-integrity: fix leaking uninitialized kernel memory
      dm-integrity: don't increment hash_offset twice
      dm-integrity: fix a bug if the bio is out of limits
      dm_early_create: fix freeing used table on dm_resume failure
      dm-ioctl: fix a possible overflow in list_version_get_info
      dm-verity: avoid double increment of &use_bh_wq_enabled
      dm-verity: fix a possible NULL pointer dereference
      dm-verity: increase sprintf buffer size
      dm-verity: make error counter atomic
      dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
      dm-stats: fix merge accounting
      dm-stats: fix dm_jiffies_to_msec64

Ming-Hung Tsai (1):
      dm thin metadata: fix metadata snapshot consistency on commit failure

Samuel Moelius (2):
      dm era: fix out-of-bounds memory access for non-zero start sector
      dm-pcache: reject option groups without values

 drivers/md/dm-bufio.c            |  4 ++-
 drivers/md/dm-era-target.c       | 16 ++++++----
 drivers/md/dm-inlinecrypt.c      |  4 ++-
 drivers/md/dm-integrity.c        | 26 +++++++++++-----
 drivers/md/dm-ioctl.c            |  4 +--
 drivers/md/dm-log.c              |  3 ++
 drivers/md/dm-pcache/dm_pcache.c |  8 +++++
 drivers/md/dm-stats.c            | 10 +++---
 drivers/md/dm-thin-metadata.c    | 67 +++++++++++++---------------------------
 drivers/md/dm-verity-fec.c       |  4 +--
 drivers/md/dm-verity-fec.h       |  2 +-
 drivers/md/dm-verity-loadpin.c   |  2 +-
 drivers/md/dm-verity-target.c    | 16 ++++++----
 drivers/md/dm-verity.h           |  2 +-
 drivers/md/dm.c                  | 11 ++++++-
 15 files changed, 97 insertions(+), 82 deletions(-)

