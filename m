Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F9F175A5
	for <dm-devel@lists.linux.dev>; Mon,  4 Aug 2025 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754316170; cv=none; b=bvk0VO6lpvU/NJPkd+uMI0DyPl1g0Xn+MRXrI6yV5j10X+iS59bd6emWf+NCgGdfQcfqczXgiHn8LTlNSbm+THm+khmkblZzVIBPDb14Zfs5D+VF9i7nrim8k63E7tcX5iY5+JtYrPs5cUlsGddveQJwb75/A+7Pw6altfF2vVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754316170; c=relaxed/simple;
	bh=B5xeiUPE7KxVX9LWwPpmV5xtY7UslGFFR8OzFKKVV+Y=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=TTry5G8brd7y8DCpiiIsZQWbiBITLLOvhtBRCG2OWIUGGkKXoriV3ZO6dCHNXa2CLNZxaLa/4WSTAlQqaAbtjHBNi+HG7Pal2roU/s6Dkc//eicahby1n7jl3jeDsZXbD7r8h8lAU93g1ura8uxLcoHAjzcqs7nWrfcxuJcgzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMBHAIGN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMBHAIGN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754316167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9WfMWmPk7RAB+DzSrtJrKGcPRp9+Ehcyzyjh00uAoFA=;
	b=DMBHAIGNfjj92EuIOtHM9Z3VISL40Wx3o8QvkzH0JJV2xhumWjQpGEiPaQ/BXUnajI+t1G
	TZxLWnP4V7E3FD7J9MWczZlDdRSs3b9Jce9TsfzoE7LgvKwJqCDzwhZz3DqR2k06X95Kp9
	AbOXePwNWHSMtFDFLM/tO2p6kRop8BY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-VoL1fRg-N1CVjT-QuGKizw-1; Mon,
 04 Aug 2025 10:02:46 -0400
X-MC-Unique: VoL1fRg-N1CVjT-QuGKizw-1
X-Mimecast-MFC-AGG-ID: VoL1fRg-N1CVjT-QuGKizw_1754316164
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50E21180048E;
	Mon,  4 Aug 2025 14:02:39 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1822A30002D2;
	Mon,  4 Aug 2025 14:02:34 +0000 (UTC)
Date: Mon, 4 Aug 2025 16:02:28 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Damien Le Moal <dlemoal@kernel.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
    Eric Biggers <ebiggers@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Kent Overstreet <kent.overstreet@linux.dev>, 
    LongPing Wei <weilongping@oppo.com>, 
    Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
    Purva Yeshi <purvayeshi550@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 6.17
Message-ID: <abad6192-a8ff-2d7d-a101-8e5349b442c3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q8puc52PDVHyoniIPlRWbI-iBt7tXGy92eAuuJ9705g_1754316164
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 86731a2a651e58953fc949573895f2fa6d456841:

  Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-changes

for you to fetch changes up to 55a0fbd2ac3fe8f61a30ea697b2eb3034f6778c8:

  dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin (2025-07-31 16:30:02 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
dm-table: fix checking for request-based stackable devices

dm-flakey: fix corrupt_bio_byte setup checks

dm raid: add support for resync w/o metadata devices

dm, dm-mpath, vm-vdo, dm-raid: small code simplification

dm-verity: remove support for asynchronous hashes

dm-zoned-target: close smatch warning

dm-thin: update the documentation

dm-thin: enable inline-crypto passthrough
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaJC5oRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbX+RAP911rivQBhdJSiktvnSulBvSANzzNWa
9pNIuHGCmX3RVwEA53xpdUBkWjvGbtrUwk2eu8SK728H9aOFrpaDImKdVws=
=gUBT
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Benjamin Marzinski (1):
      dm-table: fix checking for rq stackable devices

Damien Le Moal (2):
      dm: Remove unnecessary return in dm_zone_endio()
      dm: Simplify dm_io_complete()

Dmitry Antipov (1):
      dm: ima: avoid extra calls to strlen()

Eric Biggers (1):
      dm-verity: remove support for asynchronous hashes

Heinz Mauelshagen (1):
      dm raid: add support for resync w/o metadata devices

Kent Overstreet (1):
      dm-flakey: Fix corrupt_bio_byte setup checks

LongPing Wei (2):
      dm-thin: update the documentation
      dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin

Mikulas Patocka (3):
      dm-mpath: make dm_unregister_path_selector return void
      dm-mpath: don't print the "loaded" message if registering fails
      vdo: omit need_resched() before cond_resched()

Pavel Tikhomirov (1):
      dm-raid: do not include dm-core.h

Purva Yeshi (1):
      md: dm-zoned-target: Initialize return variable r to avoid uninitialized use

 .../device-mapper/thin-provisioning.rst            |  16 +-
 drivers/md/dm-flakey.c                             |   9 +-
 drivers/md/dm-ima.c                                |  42 +++--
 drivers/md/dm-path-selector.c                      |   8 +-
 drivers/md/dm-path-selector.h                      |   2 +-
 drivers/md/dm-ps-historical-service-time.c         |   9 +-
 drivers/md/dm-ps-io-affinity.c                     |   5 +-
 drivers/md/dm-ps-queue-length.c                    |   9 +-
 drivers/md/dm-ps-round-robin.c                     |   9 +-
 drivers/md/dm-ps-service-time.c                    |   9 +-
 drivers/md/dm-raid.c                               |   7 +-
 drivers/md/dm-table.c                              |  10 +-
 drivers/md/dm-thin.c                               |   7 +-
 drivers/md/dm-vdo/funnel-workqueue.c               |   3 +-
 drivers/md/dm-verity-fec.c                         |   4 +-
 drivers/md/dm-verity-target.c                      | 185 ++++-----------------
 drivers/md/dm-verity.h                             |  22 +--
 drivers/md/dm-zone.c                               |   2 -
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/md/dm.c                                    |  11 +-
 20 files changed, 110 insertions(+), 261 deletions(-)

