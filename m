Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1621AD418
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732553827; cv=none; b=f7M+sR9avHIpw4n0htD71GB7z825xAbCGRVwPfDKyChjzjvoPh5JRUWODGatqdnuooJJyKVkcm1aGHC96R/YNsPXNL4cGAZCcJ5zBpnMiAJhp7JsCjv8T4jQPTPsWH+avcLKrVZ/+RWkvIfStKEXDKV9+Gf3et2yFUDF9vY6hJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732553827; c=relaxed/simple;
	bh=GKlsVvaF8t5x4Q38PbH2AfrI9OnLSEBTaamoROEgCTU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=dBfg8f8O1hYtrM6bsAspkEg4M9jLBj2702EhUry4dgj6hJ2PgrItXitRI2tHgmUDDLAy/S/J0R2+jLDiqq5uc+t/M/LIOR4h5upOe1wLCAZSJ4q9wVCS910fJLyyr97Xx6KqeiE1zT0Tb/7Sh8PtSFDXdlSVmR5TtkBcEwXwuRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C56vZZD8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C56vZZD8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732553824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wrsafgW7HmyCdfzbZGGkBhEiO+o/yCFqZReFyAZf+6I=;
	b=C56vZZD8UqaGGJt55EZGImxv9S2oY3K+vbejFPMer63ojiiXOJ9uJfzDiIrpdqbz45fnPk
	/b9utgVGSUIUn73/V2cemZsdPXpKDjLEW4/oYuHTPS8NLTXNAaoZDx6knRfffm/46T8UGa
	NILJ13pJvQ0cpTbG56TRrBhVKY69xR0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-w8R7UoDOMcegvb3JUA_hGg-1; Mon,
 25 Nov 2024 11:57:00 -0500
X-MC-Unique: w8R7UoDOMcegvb3JUA_hGg-1
X-Mimecast-MFC-AGG-ID: w8R7UoDOMcegvb3JUA_hGg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66F3D1955F43;
	Mon, 25 Nov 2024 16:56:58 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A45AE1956052;
	Mon, 25 Nov 2024 16:56:54 +0000 (UTC)
Date: Mon, 25 Nov 2024 17:56:51 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Coddington <bcodding@redhat.com>, 
    Colin Ian King <colin.i.king@gmail.com>, 
    "Dr. David Alan Gilbert" <linux@treblig.org>, 
    Matthew Sakai <msakai@redhat.com>, Ssuhung Yeh <ssuhung@gmail.com>, 
    Susan LeGendre-McGhee <slegendr@redhat.com>, Yuan Can <yuancan@huawei.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 6.13
Message-ID: <3a4c7559-166b-d618-0d3b-c09d62b0a4a6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J2g2tBd4C2FwoMfUgrq40jiwKlgrxLM08L6WNm4CgCA_1732553818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit adc218676eef25575469234709c2d87185ca223a:

  Linux 6.12 (2024-11-17 14:15:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-changes

for you to fetch changes up to a573e404cbf269d46b3a96b18f7316aa57161fdf:

  dm-verity: remove the unused "data_start" variable (2024-11-20 11:44:44 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- Dm: remove unused functions and variables

- Dm-ioctl: rate-limit error messages in syslog

- Dm-persistent-data: fix typo

- Dm-vdo murmurhash: remove u64 alignment requirement

- Dm-vdo: reset bi_ioprio to the default

- Dm: add support for get_unique_id

- Dm thin: Add missing destroy_work_on_stack()

- Dm-bufio: use kmalloc to allocate power-of-two sized buffers
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ0SJnBQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbV8xAP0dcS6O29X8HzSI8gVIgT8KYCpg3Ms2
amPDlm/RDewdSQD/Z5+CHlyrlYqnKejAIs7cbZlfxD/0avcg/Kc0h4ijGws=
=2dtc
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Benjamin Coddington (1):
      dm: add support for get_unique_id

Colin Ian King (1):
      dm ioctl: rate limit a couple of ioctl based error messages

Dr. David Alan Gilbert (9):
      dm cache: Remove unused btracker_nr_writebacks_queued
      dm cache: Remove unused dm_cache_dump
      dm cache: Remove unused dm_cache_size
      dm cache: Remove unused functions in bio-prison-v1
      dm: Remove unused dm_set_md_type
      dm: Remove unused dm_table_bio_based
      dm: zoned: Remove unused functions
      dm vdo: Remove unused functions
      dm vdo: Remove unused uds_compute_index_size

Matthew Sakai (2):
      dm vdo int-map: remove unused parameters
      dm vdo: fix function doc comment formatting

Mikulas Patocka (2):
      dm-bufio: use kmalloc to allocate power-of-two sized buffers
      dm-verity: remove the unused "data_start" variable

Ssuhung Yeh (1):
      dm: Fix typo in error message

Susan LeGendre-McGhee (2):
      dm-vdo murmurhash: remove u64 alignment requirement
      dm-vdo: reset bi_ioprio to the default value when the bio is reset

Yuan Can (1):
      dm thin: Add missing destroy_work_on_stack()

 drivers/md/dm-bio-prison-v1.c                    | 35 --------------
 drivers/md/dm-bio-prison-v1.h                    | 24 ----------
 drivers/md/dm-bufio.c                            | 25 ++++++++--
 drivers/md/dm-cache-background-tracker.c         |  6 ---
 drivers/md/dm-cache-background-tracker.h         |  1 -
 drivers/md/dm-cache-metadata.c                   | 33 -------------
 drivers/md/dm-cache-metadata.h                   |  3 --
 drivers/md/dm-ioctl.c                            |  4 +-
 drivers/md/dm-table.c                            |  5 --
 drivers/md/dm-thin.c                             |  1 +
 drivers/md/dm-vdo/block-map.c                    |  2 -
 drivers/md/dm-vdo/data-vio.c                     | 36 ++------------
 drivers/md/dm-vdo/data-vio.h                     |  5 --
 drivers/md/dm-vdo/dedupe.c                       |  9 ++--
 drivers/md/dm-vdo/encodings.c                    |  2 +-
 drivers/md/dm-vdo/indexer/index-layout.c         | 26 ----------
 drivers/md/dm-vdo/indexer/indexer.h              |  4 --
 drivers/md/dm-vdo/int-map.c                      | 28 +++++------
 drivers/md/dm-vdo/io-submitter.c                 |  2 +-
 drivers/md/dm-vdo/murmurhash3.c                  |  7 +--
 drivers/md/dm-vdo/packer.c                       |  3 +-
 drivers/md/dm-vdo/physical-zone.c                |  2 +-
 drivers/md/dm-vdo/recovery-journal.c             |  2 +-
 drivers/md/dm-vdo/slab-depot.c                   |  9 ++--
 drivers/md/dm-vdo/vdo.c                          |  4 +-
 drivers/md/dm-vdo/vio.c                          |  1 +
 drivers/md/dm-verity-target.c                    |  6 +--
 drivers/md/dm-verity.h                           |  1 -
 drivers/md/dm-zoned-metadata.c                   | 50 -------------------
 drivers/md/dm-zoned.h                            |  2 -
 drivers/md/dm.c                                  | 61 +++++++++++++++++++++---
 drivers/md/dm.h                                  |  2 -
 drivers/md/persistent-data/dm-space-map-common.c |  2 +-
 33 files changed, 115 insertions(+), 288 deletions(-)

