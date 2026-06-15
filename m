Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A22402438
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537202; cv=none; b=P2GaLfcTlMPtDMWX4BFg0vg1pq3AtAD5IPNhMVF2Emhh4ma6QW5Xf55hOVN/M9LN2AjOOFVqH3FBYktH1rzG0+xFq/7cFzm2BmKuRRuRWlt6mIAnBClkLyxidncKw/LSoItzHYqAoNFV19TB5Fp7YFHxKcd/C2Mr1QhP9tH3yG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537202; c=relaxed/simple;
	bh=3JhXoO+xV1CUt7MbBsjUmbDfbiPYaYGrgTcL/0AGdZg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Xri/nZEm55j5BHOMtVJMJiPjB7NlI3hZSISAFxSmqefr+F4AImEjntTeyIKUanY1G/hYfMsx/dMwRm6QfZqexSq3w0ZEg4A2fICvgrn3P50rFoQsJlL8bdOjEI68zax8BdS6K6R9Omm09n1XhQ5hfMrXMiihGdVi0nTcnw9KgJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZqbWEl4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZqbWEl4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781537200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Aq5l7E4pvA/4zb6Ci40VJXV75RXU4+DwuM24635PAMQ=;
	b=iZqbWEl4x0Eh4CI7kmhu33BtLaIFR0x9l83m2Kc6lpfX8ixFcsTsla9lxuBPvK1wP1WjZr
	/Rjrm6uyOGrb/f3iRBTMgz/RzmDnKmQIJYH4CZLB3iioCdbp+NfmnV3x/XNtMdxtvMsE3Z
	I2+L1koAfGwuyDp5GO8JxL4O+sO+pRI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-Qd7nMJYIOeCxWmGv808Jmg-1; Mon,
 15 Jun 2026 11:26:33 -0400
X-MC-Unique: Qd7nMJYIOeCxWmGv808Jmg-1
X-Mimecast-MFC-AGG-ID: Qd7nMJYIOeCxWmGv808Jmg_1781537192
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DB071800661;
	Mon, 15 Jun 2026 15:26:31 +0000 (UTC)
Received: from [10.44.32.53] (unknown [10.44.32.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 414161955BCE;
	Mon, 15 Jun 2026 15:26:28 +0000 (UTC)
Date: Mon, 15 Jun 2026 17:26:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Cao Guanghui <caoguanghui@kylinos.cn>, David Carlier <devnexen@gmail.com>, 
    David Laight <david.laight.linux@gmail.com>, 
    Eric Biggers <ebiggers@google.com>, 
    Fengnan Chang <changfengnan@bytedance.com>, 
    Linlin Zhang <linlin.zhang@oss.qualcomm.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 7.2
Message-ID: <60192373-6ffb-86cd-145c-0fe82b05e9e4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pUq4EjPfZJdKXwgPuI2HYA3nW9Vb1fltanOs9ehrgYA_1781537192
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 7fd2df204f342fc17d1a0bfcd474b24232fb0f32:

  Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.2/dm-changes

for you to fetch changes up to 55c99f2d901c783c49dddd98f7c05d98ad834ce9:

  dm-zoned-metadata: Use strscpy() to copy device name (2026-06-08 14:59:14 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- small cleanups in dm-vdo, dm-raid, dm-cache, dm-zoned-metadata

- rework of dm-ima

- introduce dm-inlinecrypt

- fix wrong return value in dm-ioctl

- fix rcu stall when polling
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCajAXChQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbaiMAP9WzwyH3Y/cOdpdFoqqPi7IsXZisJPo
rFiAVL4rOgF3kQD/RRp5dkn4iKSYovjZr3+i6a7srxIkpfDEf4kP2mOJBAk=
=2jnV
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Benjamin Marzinski (11):
      dm-raid: only requeue bios when dm is suspending
      dm-ima: remove dm_ima_reset_data()
      dm-ima: remove broken last_target_measured logic
      dm-ima: Remove status_flags from dm_ima_measure_on_table_load()
      dm-ima: don't copy the active table to the inactive table
      dm-ima: Fix UAF errors and measuring incorrect context
      dm-ima: remove new_map from dm_ima_measure_on_device_clear
      dm-ima: Fix issues with dm_ima_measure_on_device_rename
      dm-ima: Handle race between rename and table swap
      dm-ima: Fail more gracefully in dm_ima_measure_on_*
      dm-ima: use active table's size if available

Cao Guanghui (1):
      dm cache: make smq background work limit configurable

David Carlier (1):
      dm vdo: use get_random_u32() where appropriate

David Laight (1):
      dm-zoned-metadata: Use strscpy() to copy device name

Eric Biggers (2):
      block: export blk-crypto symbols required by dm-inlinecrypt
      dm-inlinecrypt: add target for inline block device encryption

Fengnan Chang (1):
      dm: limit target bio polling to one shot

Linlin Zhang (2):
      dm: add documentation for dm-inlinecrypt target
      dm-inlinecrypt: add support for hardware-wrapped keys

Mikulas Patocka (1):
      dm-ioctl: report an error if a device has no table

 .../admin-guide/device-mapper/dm-inlinecrypt.rst   | 129 +++++
 Documentation/admin-guide/device-mapper/index.rst  |   1 +
 block/blk-crypto.c                                 |   3 +
 drivers/md/Kconfig                                 |  11 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-cache-policy-smq.c                   |  12 +-
 drivers/md/dm-ima.c                                | 492 ++++++++--------
 drivers/md/dm-ima.h                                |  68 ++-
 drivers/md/dm-inlinecrypt.c                        | 618 +++++++++++++++++++++
 drivers/md/dm-ioctl.c                              | 151 ++++-
 drivers/md/dm-raid.c                               |   6 +
 drivers/md/dm-vdo/indexer/index-layout.c           |   2 +-
 drivers/md/dm-zoned-metadata.c                     |   2 +-
 drivers/md/dm.c                                    |  15 +-
 drivers/md/md.h                                    |   2 +
 drivers/md/raid5.c                                 |   7 +-
 16 files changed, 1214 insertions(+), 306 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
 create mode 100644 drivers/md/dm-inlinecrypt.c

