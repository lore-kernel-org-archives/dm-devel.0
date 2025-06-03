Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8B1C700C
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748972176; cv=none; b=i66HMP16d7PDuie2D/bdFzS/qZZo+eB7EWpMWkrAsaJ2q6VbcQ3FCO9Mm5dmGCW433ljIbzkFQcrTBvWvgGD9I8qwcqlUdw8cL5oOtBEpfJ1LoyoT6kyHHcr8ljGPG9DvoZlKwQb++KqWQuDBqMaqEpBx1Odaemcr9VMpA2ZPXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748972176; c=relaxed/simple;
	bh=RAIgqpsbK6orNFbt0s2dn6y1bXMCMqlsm8e0019AjxM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=BQ+zj37q0Wr9U2Ck28eRIDbbqT8KgLG7y71lala+NJXxDUF++kX9njKTwB5q7U/soCd8cZ6IJzXMIo/k+aACGZAzGL1HZdBiDiDvxirakpgsl1MTFlkULmidqBaUogTEeydgBjYm4+r0NGJegH39VKg/aw5z5SdyCFWYajvOYeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HJNTCK82; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJNTCK82"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748972173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=66MYEWhcV5lEnDBvK+Gmy3UQzTg6wBbAAz1awOtVLAk=;
	b=HJNTCK82iBs7XSpPy0IonoVkM+jBSt8T8jFffkM4fK71NYx9qQ8OyS6tl3XXCfgNqzl8CB
	TG/7FBqKfr3nxMrzYZPI1BXS8ARHYLAmlhj3UfCPgsyl+OjlyZuMGYQQGQpTixaQuJ8yF+
	xlB4s37MDPk0pZe6tYRXqNFlVYUy73Q=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-oB-4t-BkOF-hdPwI_M8UWw-1; Tue,
 03 Jun 2025 13:36:12 -0400
X-MC-Unique: oB-4t-BkOF-hdPwI_M8UWw-1
X-Mimecast-MFC-AGG-ID: oB-4t-BkOF-hdPwI_M8UWw_1748972171
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1206C19560B1;
	Tue,  3 Jun 2025 17:36:11 +0000 (UTC)
Received: from [10.22.80.20] (unknown [10.22.80.20])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99F5D19560A3;
	Tue,  3 Jun 2025 17:36:08 +0000 (UTC)
Date: Tue, 3 Jun 2025 19:36:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bart Van Assche <bvanassche@acm.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Eric Biggers <ebiggers@google.com>, John Garry <john.g.garry@oracle.com>, 
    Kevin Wolf <kwolf@redhat.com>, Matthew Sakai <msakai@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 6.16
Message-ID: <ef920398-c100-7c69-b7f2-50009396b99b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tsD0x83t8MbUZCWnxO35NyituvqfvPQcY4KyGVOWSE4_1748972171
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-changes

for you to fetch changes up to 9f2f6316d753fe80c764e924cee475306f38ceb6:

  dm-stripe: small code cleanup (2025-06-03 19:06:32 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm: better error handling when reloading a table

- dm-delay: don't busy-wait in kthread

- dm: use use generic disable_* functions instead of open coding them

- dm: lock queue limits when reading them

- dm-verity: use softirq context only when !need_resched()

- dm-bufio: remove maximum age based eviction

- dm: remove unneeded kvfree from alloc_targets

- dm-flakey: various fixes

- dm-mpath: interface for explicit probing of active paths

- dm: fix BLK_FEAT_ATOMIC_WRITES

- dm: pass through operations on wrapped inline crypto keys

- dm vdo indexer: don't read request structure after enqueuing

- dm-zone: Use bdev_*() helper functions where applicable

- dm-mpath: replace spin_lock_irqsave with spin_lock_irq

- dm-mirror: fix a tiny race condition

- dm-verity: fix a memory leak if some arguments are specified multiple times

- dm-stripe: small code cleanup
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaD8vFBQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbYGFAQC/V62PzDUa326WSdvwhtYe6jphInlW
ZSmh37L4MIcV2wD/S8UqIaC9GSakee6jEWBTRiDqNZNEOIWhbd7f6gnTOQ0=
=eYUe
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bart Van Assche (1):
      dm-zone: Use bdev_*() helper functions where applicable

Benjamin Marzinski (14):
      dm: don't change md if dm_table_set_restrictions() fails
      dm: free table mempools if not used in __bind
      dm: handle failures in dm_table_set_restrictions
      dm: fix dm_blk_report_zones
      dm: limit swapping tables for devices with zone write plugs
      dm: fix native zone append devices on top of emulated ones
      dm-delay: don't busy-wait in kthread
      dm: remove unneeded kvfree from alloc_targets
      dm-flakey: Clean up parsing messages
      dm-flakey: error all IOs when num_features is absent
      dm-flakey: remove useless ERROR_READS check in flakey_end_io
      dm-flakey: make corrupting read bios work
      dm-mpath: Don't grab work_mutex while probing paths
      dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock

Eric Biggers (4):
      dm-verity: use softirq context only when !need_resched()
      dm-bufio: remove maximum age based eviction
      blk-crypto: export wrapped key functions
      dm: pass through operations on wrapped inline crypto keys

John Garry (1):
      dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits

Kevin Wolf (2):
      dm: Allow .prepare_ioctl to handle ioctls directly
      dm mpath: Interface for explicit probing of active paths

Matthew Sakai (1):
      dm vdo indexer: don't read request structure after enqueuing

Mikulas Patocka (6):
      dm: use generic functions instead of disable_discard and disable_write_zeroes
      dm: lock limits when reading them
      dm mpath: replace spin_lock_irqsave with spin_lock_irq
      dm-mirror: fix a tiny race condition
      dm-verity: fix a memory leak if some arguments are specified multiple times
      dm-stripe: small code cleanup

 block/blk-crypto-profile.c         |   4 +
 drivers/md/dm-bufio.c              | 189 +++++---------------------
 drivers/md/dm-core.h               |   4 +-
 drivers/md/dm-delay.c              |  17 ++-
 drivers/md/dm-dust.c               |   4 +-
 drivers/md/dm-ebs-target.c         |   3 +-
 drivers/md/dm-flakey.c             | 118 +++++++++--------
 drivers/md/dm-ioctl.c              |   1 +
 drivers/md/dm-linear.c             |   4 +-
 drivers/md/dm-log-writes.c         |   4 +-
 drivers/md/dm-mpath.c              | 243 +++++++++++++++++++++++++---------
 drivers/md/dm-raid1.c              |   5 +-
 drivers/md/dm-rq.c                 |   4 +-
 drivers/md/dm-stripe.c             |   5 +-
 drivers/md/dm-switch.c             |   4 +-
 drivers/md/dm-table.c              | 263 ++++++++++++++++++++++++++++++++++---
 drivers/md/dm-vdo/indexer/volume.c |  24 ++--
 drivers/md/dm-verity-fec.c         |   4 +
 drivers/md/dm-verity-target.c      |  15 ++-
 drivers/md/dm-verity-verify-sig.c  |  17 ++-
 drivers/md/dm-zone.c               |  98 ++++++++++----
 drivers/md/dm-zoned-target.c       |   3 +-
 drivers/md/dm.c                    |  73 +++++-----
 drivers/md/dm.h                    |   6 +
 include/linux/blkdev.h             |   7 +
 include/linux/device-mapper.h      |   9 +-
 include/uapi/linux/dm-ioctl.h      |   9 +-
 27 files changed, 746 insertions(+), 391 deletions(-)

