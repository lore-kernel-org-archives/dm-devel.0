Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258AA1EDA35
	for <dm-devel@lists.linux.dev>; Tue,  1 Apr 2025 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743503114; cv=none; b=MTvyqaU7bSAlT9mY/cTcWuu4U0HhRxdrTMGESGaR9MrPaFs+2zSMRlOASGGVexEnYbOeEfBYlUfLF7kFPdB0IHOHKhqgPsjYL+Ycv0xJ2ftddj6HkGDq7L8kHBQ0mje6sUMyQnUhD2nGOF2IpL2Y/A+Z58f7/MTK014UxKut/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743503114; c=relaxed/simple;
	bh=1iYecbYRLkb6Vd1IACXE9GzrPOKNeGaAjcZ5UhIyYno=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=fvXGP2YirzVasaUspqyKUGknHzJdGZAOuS20kvXYwPjlRZYOpzK4PFd5wGToBIq3ZFtiDn+MWPPN5kyMYgpL2wK1EAutt/F+x7+jtx/uYvorAP+PW6ejH9QwNv3K44VRoVt9kN2Li7KrlL2/D3JQscDBAEG+BiuM/K6TVmvQy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYEsCHOy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYEsCHOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743503111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=z2936sbQCTxzC5HIHKbdwj/qDXvxxaEAZPywovDaNwc=;
	b=GYEsCHOySwWV/oTXV9x7N9bFhaVZKymE6AlXfTp/0N0KipFIOu8zXcyCd4knZ70+WTDVaQ
	Cir37MEKHPaCqn6aftLvBAEm5DkleX/FyNiBsUNVSdxhGbdBaTrVNgViuiAXyy5jAm6xBX
	8WvfvzKplxTeAqjqb/za9BGeB2B6/js=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-v90YyBQlPku9jHUO574cCQ-1; Tue,
 01 Apr 2025 06:25:08 -0400
X-MC-Unique: v90YyBQlPku9jHUO574cCQ-1
X-Mimecast-MFC-AGG-ID: v90YyBQlPku9jHUO574cCQ_1743503106
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3CCA180034D;
	Tue,  1 Apr 2025 10:25:05 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7664F180B489;
	Tue,  1 Apr 2025 10:25:00 +0000 (UTC)
Date: Tue, 1 Apr 2025 12:24:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Ed Tsai <ed.tsai@mediatek.com>, Eric Biggers <ebiggers@google.com>, 
    Christoph Hellwig <hch@lst.de>, Chung Chung <cchung@redhat.com>, 
    Jinliang Zheng <alexjlzheng@gmail.com>, 
    Jo Van Bulck <jo.vanbulck@kuleuven.be>, Ken Raeburn <raeburn@redhat.com>, 
    LongPing Wei <weilongping@oppo.com>, Matthew Sakai <msakai@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, Ming-Hung Tsai <mtsai@redhat.com>, 
    Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 6.15
Message-ID: <c82a1392-624b-ecb3-1b38-008e8653ab9e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9glCsf2fdiqdTfIKW_cW7G_SslJOBc4PLU8Se3FClAk_1743503106
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-changes

for you to fetch changes up to 9c565428788fb9b49066f94ab7b10efc686a0a4c:

  dm-ebs: fix prefetch-vs-suspend race (2025-03-28 18:26:11 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-crypt: switch to using the crc32 library

- dm-verity, dm-integrity, dm-crypt: documentation improvement

- dm-vdo fixes

- dm-stripe: enable inline crypto passthrough

- dm-integrity: set ti->error on memory allocation failure

- dm-bufio: remove unused return value

- dm-verity: do forward error correction on metadata I/O errors

- dm: fix unconditional IO throttle caused by REQ_PREFLUSH

- dm cache: prevent BUG_ON by blocking retries on failed device resumes

- dm cache: support shrinking the origin device

- dm: restrict dm device size to 2^63-512 bytes

- dm-delay: support zoned devices

- dm-verity: support block number limits for different ioprio classes

- dm-integrity: fix non-constant-time tag verification (security bug)

- dm-verity, dm-ebs: fix prefetch-vs-suspend race
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ+u7shQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbZ0JAQDVhbl77u9jjPWjxJvFodMAqw+KPXGC
MNzkyzG0lu7oPAEA33vt5pHQtr7F3SJj/sDBuZ+rb5bvUtgxeGqpJOQpTAk=
=tj00
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Christoph Hellwig (1):
      dm-delay: support zoned devices

Chung Chung (1):
      dm vdo indexer: prevent unterminated string warning

Ed Tsai (1):
      dm: Enable inline crypto passthrough for striped target

Eric Biggers (1):
      dm-crypt: switch to using the crc32 library

Jinliang Zheng (1):
      dm: fix unconditional IO throttle caused by REQ_PREFLUSH

Jo Van Bulck (1):
      dm-integrity: fix non-constant-time tag verification

Ken Raeburn (6):
      dm vdo vio-pool: add a pool pointer to pooled_vio
      dm vdo vio-pool: support pools with multiple data blocks per vio
      dm vdo vio-pool: allow variable-sized metadata vios
      dm vdo slab-depot: read refcount blocks in large chunks at load time
      dm vdo: rework processing of loaded refcount byte arrays
      dm vdo indexer: reorder uds_request to reduce padding

LongPing Wei (1):
      dm-verity: support block number limits for different ioprio classes

Matthew Sakai (2):
      dm vdo: use a short static string for thread name prefix
      dm vdo: remove checks that can not fail

Mikulas Patocka (6):
      dm-integrity: set ti->error on memory allocation failure
      dm-bufio: remove unused return value
      dm-verity: do forward error correction on metadata I/O errors
      dm: restrict dm device size to 2^63-512 bytes
      dm-verity: fix prefetch-vs-suspend race
      dm-ebs: fix prefetch-vs-suspend race

Milan Broz (3):
      dm-verity: Document restart_on_error and panic_on_error options
      dm-integrity: Document Inline mode for storing integrity data
      dm-crypt: Document integrity_key_size option.

Ming-Hung Tsai (2):
      dm cache: prevent BUG_ON by blocking retries on failed device resumes
      dm cache: support shrinking the origin device

Sweet Tea Dorminy (1):
      dm vdo: remove remaining ring references

 .../admin-guide/device-mapper/dm-crypt.rst         |   5 +
 .../admin-guide/device-mapper/dm-integrity.rst     |   5 +
 Documentation/admin-guide/device-mapper/verity.rst |  20 ++-
 drivers/md/Kconfig                                 |   1 +
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-cache-target.c                       |  96 +++++++++-
 drivers/md/dm-crypt.c                              |  41 ++---
 drivers/md/dm-delay.c                              |  18 +-
 drivers/md/dm-ebs-target.c                         |   7 +
 drivers/md/dm-integrity.c                          |  48 ++---
 drivers/md/dm-stripe.c                             |   2 +-
 drivers/md/dm-table.c                              |   4 +
 drivers/md/dm-vdo/block-map.c                      |  13 +-
 drivers/md/dm-vdo/constants.h                      |   3 -
 drivers/md/dm-vdo/dedupe.c                         |  20 +--
 drivers/md/dm-vdo/encodings.c                      |  20 +--
 drivers/md/dm-vdo/indexer/index-layout.c           |   5 +-
 drivers/md/dm-vdo/indexer/index-session.c          |   6 +-
 drivers/md/dm-vdo/indexer/indexer.h                |  53 +++---
 drivers/md/dm-vdo/io-submitter.c                   |   6 +-
 drivers/md/dm-vdo/io-submitter.h                   |  18 +-
 drivers/md/dm-vdo/packer.h                         |   2 +-
 drivers/md/dm-vdo/priority-table.c                 |   2 +-
 drivers/md/dm-vdo/recovery-journal.h               |   6 +-
 drivers/md/dm-vdo/slab-depot.c                     | 193 +++++++++++++++------
 drivers/md/dm-vdo/slab-depot.h                     |  13 +-
 drivers/md/dm-vdo/types.h                          |   3 +
 drivers/md/dm-vdo/vdo.c                            |  11 +-
 drivers/md/dm-vdo/vio.c                            |  54 +++---
 drivers/md/dm-vdo/vio.h                            |  13 +-
 drivers/md/dm-vdo/wait-queue.c                     |   2 +-
 drivers/md/dm-verity-target.c                      |  62 ++++++-
 drivers/md/dm.c                                    |   8 +-
 33 files changed, 520 insertions(+), 244 deletions(-)

