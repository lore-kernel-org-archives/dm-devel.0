Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C529357CBC
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721385813; cv=none; b=IsLmlOpCm/Hv42Ush8/SvFZmDK9nY5WF8VaCAkQOTPcD4zbpdpncT2vHRvOhUfWSeEYNtiCCQZ/7hmnI2dbULpcn/ZWLELi0aX0AYhWX3i/xh5JWeg1wjoJJM6KeWQOhLo9EEBMb0TEmN675SwbIBEY4oq69NAMvFmAPcSSTTnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721385813; c=relaxed/simple;
	bh=hpYELE4WIFTYKTMaYVuiKD5Yd7CZ2vR+GMqp6DNv/aA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=HpMQzZrkGENbWp/qMpmJmnwJdagTrNvI+/N+XYfoUs9LhcsAwp4D3IgQAcNkjy4vOtEwl56/OzusNgwUFHF837pn+MwhsN8V6ltcZ8Ax+RqPjOWPQ6kr7hIDTgeF/etShYQT4uN97RgXCtj5ku8RzIu4jvp2fJqp08ml7U/ut0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UE9981/F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UE9981/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721385809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DurDymoLk0Lb3oVs1hPaEkPYjupY69fQ0ScCU5gje8g=;
	b=UE9981/F71/cpTeliGioK6Ly0V3PzMURsN0jxLobAKglIJlrhc6ypWedRiXbfPm2XdsTG9
	3NZe3YspIQbo3WHd5jVmxQmsFeIyW+cDPRKbQnRm7CKYXs2ALB4yTYQLANQIEeH35SrMlA
	cxOduFIDv2kLls5r+WUEUDJyCPS4aJ4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-4vfyPTHZPcCvfEm3eGqP2w-1; Fri,
 19 Jul 2024 06:43:24 -0400
X-MC-Unique: 4vfyPTHZPcCvfEm3eGqP2w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F45B1944B29;
	Fri, 19 Jul 2024 10:43:21 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FAB81955D47;
	Fri, 19 Jul 2024 10:43:20 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 12AF630C1C17; Fri, 19 Jul 2024 10:43:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 10F903FD4B;
	Fri, 19 Jul 2024 12:43:19 +0200 (CEST)
Date: Fri, 19 Jul 2024 12:43:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Damien Le Moal <dlemoal@kernel.org>, 
    "Dr. David Alan Gilbert" <linux@treblig.org>, 
    Eric Biggers <ebiggers@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
    Christoph Hellwig <hch@lst.de>, 
    Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, 
    Luca Boccassi <bluca@debian.org>, Masatake YAMATO <yamato@redhat.com>, 
    Matthew Sakai <msakai@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper changes for 6.11
Message-ID: <ce9cfca3-73bc-b79f-28ef-88c9ffc293d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit cf546dd289e0f6d2594c25e2fb4e19ee67c6d988:

  block: change rq_integrity_vec to respect the iterator (2024-06-26 09:14:33 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-changes

for you to fetch changes up to 7f1c4909a821dbfd258177db9ec96dda3ae91346:

  dm vdo: fix a minor formatting issue in vdo.rst (2024-07-19 12:08:21 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- Optimize processing of flush bios in the dm-linear and dm-stripe
  targets

- Dm-io cleansups and refactoring

- Remove unused 'struct thunk' in dm-cache

- Handle minor device numbers > 255 in dm-init

- Dm-verity refactoring & enabling platform keyring

- Fix warning in dm-raid

- Improve dm-crypt performance - split bios to smaller pieces, so that
  They could be processed concurrently

- Stop using blk_limits_io_{min,opt}

- Dm-vdo cleanup and refactoring

- Remove max_write_zeroes_granularity and max_secure_erase_granularity

- Dm-multipath cleanup & refactoring

- Add dm-crypt and dm-integrity support for non-power-of-2 sector size

- Fix reshape in dm-raid

- Make dm_block_validator const
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZpo+9xQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbYKDAQCZP2pJyh9tRZ8GsHtk3l/ZMftmk1/c
26v6vYlOTObJHAEA3TH2ahVnzhqYs/x3zEW/n91feTSeUJrrJ9DqHxWt+Ac=
=S3yx
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Benjamin Marzinski (7):
      dm io: bump num_bvecs to handle offset memory
      dm io: don't call the async_io notify.fn on invalid num_regions
      dm io: remove code duplication between sync_io and aysnc_io
      dm init: Handle minors larger than 255
      dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume
      dm: factor out helper function from dm_get_device
      dm mpath: don't call dm_get_device in multipath_message

Christoph Hellwig (1):
      dm: stop using blk_limits_io_{min,opt}

Christophe JAILLET (1):
      dm: Constify struct dm_block_validator

Damien Le Moal (2):
      dm: Remove max_write_zeroes_granularity
      dm: Remove max_secure_erase_granularity

Dr. David Alan Gilbert (2):
      dm cache metadata: remove unused struct 'thunk'
      dm vdo: remove unused struct 'uds_attribute'

Eric Biggers (8):
      dm-verity: move hash algorithm setup into its own function
      dm-verity: move data hash mismatch handling into its own function
      dm-verity: make real_digest and want_digest fixed-length
      dm-verity: provide dma_alignment limit in io_hints
      dm-verity: always "map" the data blocks
      dm-verity: make verity_hash() take dm_verity_io instead of ahash_request
      dm-verity: hash blocks with shash import+finup when possible
      dm-verity: fix dm_is_verity_target() when dm-verity is builtin

Heinz Mauelshagen (2):
      dm raid: move _get_reshape_sectors() as prerequisite to fixing reshape size issues
      dm raid: fix stripes adding reshape size issues

Jiapeng Chong (1):
      dm vdo indexer: use swap() instead of open coding it

Luca Boccassi (1):
      dm verity: add support for signature verification with platform keyring

Masatake YAMATO (1):
      dm vdo: fix a minor formatting issue in vdo.rst

Matthew Sakai (2):
      dm vdo repair: add missing kerneldoc fields
      dm vdo int-map: fix kerneldoc formatting

Mikulas Patocka (5):
      dm: optimize flushes
      dm-crypt: limit the size of encryption requests
      dm-crypt: support for per-sector NVMe metadata
      dm: introduce the target flag mempool_needs_integrity
      dm-integrity: introduce the Inline mode

 .../admin-guide/device-mapper/dm-crypt.rst         |  11 +
 Documentation/admin-guide/device-mapper/vdo.rst    |   1 +
 drivers/md/Kconfig                                 |  10 +
 drivers/md/dm-cache-metadata.c                     |  15 +-
 drivers/md/dm-cache-target.c                       |   4 +-
 drivers/md/dm-clone-metadata.c                     |   6 +-
 drivers/md/dm-clone-target.c                       |   4 +-
 drivers/md/dm-core.h                               |   2 +
 drivers/md/dm-crypt.c                              |  77 ++--
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-era-target.c                         |  10 +-
 drivers/md/dm-init.c                               |   4 +-
 drivers/md/dm-integrity.c                          | 408 +++++++++++++++--
 drivers/md/dm-io.c                                 |  84 ++--
 drivers/md/dm-linear.c                             |   1 +
 drivers/md/dm-mpath.c                              |  11 +-
 drivers/md/dm-raid.c                               |  63 ++-
 drivers/md/dm-stripe.c                             |   5 +-
 drivers/md/dm-table.c                              |  44 +-
 drivers/md/dm-thin-metadata.c                      |   6 +-
 drivers/md/dm-thin.c                               |   6 +-
 drivers/md/dm-vdo/dedupe.c                         |   5 -
 drivers/md/dm-vdo/dm-vdo-target.c                  |   4 +-
 drivers/md/dm-vdo/indexer/index.c                  |   5 +-
 drivers/md/dm-vdo/int-map.c                        |   2 +-
 drivers/md/dm-vdo/repair.c                         |   8 +-
 drivers/md/dm-verity-fec.c                         |  32 +-
 drivers/md/dm-verity-fec.h                         |   6 +-
 drivers/md/dm-verity-target.c                      | 485 ++++++++++-----------
 drivers/md/dm-verity-verify-sig.c                  |   7 +
 drivers/md/dm-verity.h                             |  39 +-
 drivers/md/dm-zoned-target.c                       |   4 +-
 drivers/md/dm.c                                    |  54 ++-
 drivers/md/persistent-data/dm-array.c              |   6 +-
 drivers/md/persistent-data/dm-block-manager.c      |  12 +-
 drivers/md/persistent-data/dm-block-manager.h      |  14 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   2 +-
 drivers/md/persistent-data/dm-btree-spine.c        |   6 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  12 +-
 .../md/persistent-data/dm-transaction-manager.c    |   8 +-
 .../md/persistent-data/dm-transaction-manager.h    |   6 +-
 include/linux/device-mapper.h                      |  38 +-
 42 files changed, 947 insertions(+), 582 deletions(-)

