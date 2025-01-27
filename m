Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FAD1FECA1
	for <dm-devel@lists.linux.dev>; Mon, 27 Jan 2025 10:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737972713; cv=none; b=Py2EyaOX8lHlxCHqPlKXS067x0oJNkmYzn0pxADZcSuw8Bq4FifQIah85n6noNiwr1tCMbfzimul1y1abB6NBZk0tOc1wmeN8wqw7I4WHhfNPHMzx8eBB9vtZ3xKDOfHS8cI5jGkD2BleYJrDtr640Bobo8YqX4axU1zcgr3gmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737972713; c=relaxed/simple;
	bh=ud3MVEYVZYgfjwSvs6KoKEWRguqsaHQSpfIkNGT6OYk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=kU/L7bd+idXgZiCtZb8QQ6RsHRNO4CG1+h1rVXO5R9wrHXtqgaS509/1NZHWfNrl1XRpzlksl257PG1Z/Ntvw4pwZRa++QqDzQ7RwPzew6d6rJ869gIkNxLpVM8dlcIWqx+w1wR1m38eIaR9fVqNfkiwyrKC5dmStVhpWnjz4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R0llerRD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R0llerRD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737972710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1wS4Gd/oUMpSSilRi0ryyO0xFfvWhSzVY19/0SPoVsA=;
	b=R0llerRDukEyKkY9qrO32jzt6q1bfQ1dzMkMfr6KH0Fp4mmw/5glPR1D01kTxVQ3D34LkV
	iQnMps6adDcLyUC50AV7R9vq8V4GXAHgEUChuLG1yhqCfG+uj1YY5C5NswbzTifC5nayJ7
	WD86zbyLFTuwUS0SiMdoGdrU108Goqc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-Dl70cxDFNQmOcAeVT_YbUA-1; Mon,
 27 Jan 2025 05:11:47 -0500
X-MC-Unique: Dl70cxDFNQmOcAeVT_YbUA-1
X-Mimecast-MFC-AGG-ID: Dl70cxDFNQmOcAeVT_YbUA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FE0918009C1;
	Mon, 27 Jan 2025 10:11:45 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A84C195608A;
	Mon, 27 Jan 2025 10:11:42 +0000 (UTC)
Date: Mon, 27 Jan 2025 11:11:37 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ethan Carter Edwards <ethan@ethancedwards.com>, 
    Hou Tao <houtao1@huawei.com>, John Garry <john.g.garry@oracle.com>, 
    liujing <liujing@cmss.chinamobile.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper changes for 6.14
Message-ID: <5588bffe-da8f-9bf8-1367-b3d711e66e62@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Om-D0VW9ouwMWkIfUsy2m0BK-FT_n2t35Vetm06Jgy4_1737972706
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 554b22864cc79e28cd65e3a6e1d0d1dfa8581c68:

  block: Don't trim an atomic write (2025-01-17 13:13:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-changes

for you to fetch changes up to 8b8f8037765757861f899ed3a2bfb34525b5c065:

  dm-crypt: track tag_offset in convert_context (2025-01-21 22:02:12 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix a spelling error in dm-raid

- change kzalloc to kcalloc

- remove useless test in alloc_multiple_bios

- disable REQ_NOWAIT for flushes

- dm-transaction-manager: use red-black trees instead of linear lists

- atomic writes support for dm-linear, dm-stripe and dm-mirror

- dm-crypt: code cleanups and two bugfixes
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ5dX9RQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhba9VAP97UEbvgxZU4UnysTZc+4t9eUlmWmmU
Tf/ERJGoi/nKXQEAr//Zj5oDLBxd80hgR8iDqLeG3L/QH8vMd8IxLwWJQg8=
=pRsj
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Ethan Carter Edwards (1):
      dm: change kzalloc to kcalloc

Hou Tao (6):
      dm-crypt: set atomic as false when calling crypt_convert() in kworker
      dm-crypt: fully initialize clone->bi_iter in crypt_alloc_buffer()
      dm-crypt: use bi_sector in bio when initialize integrity seed
      dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()
      dm-crypt: don't initialize cc_sector again
      dm-crypt: track tag_offset in convert_context

John Garry (6):
      dm-table: atomic writes support
      dm: Ensure cloned bio is same length for atomic write
      dm-linear: Enable atomic writes
      dm-stripe: Enable atomic writes
      dm-io: Warn on creating multiple atomic write bios for a region
      dm-mirror: Support atomic writes

Mikulas Patocka (3):
      dm: remove useless test in alloc_multiple_bios
      dm: disable REQ_NOWAIT for flushes
      dm-transaction-manager: use red-black trees instead of linear lists

liujing (1):
      dm raid: fix spelling errors in raid_ctr()

 drivers/md/dm-crypt.c                              | 42 +++++++----------
 drivers/md/dm-io.c                                 |  1 +
 drivers/md/dm-linear.c                             |  5 +-
 drivers/md/dm-ps-io-affinity.c                     |  2 +-
 drivers/md/dm-raid.c                               |  2 +-
 drivers/md/dm-raid1.c                              |  5 +-
 drivers/md/dm-stripe.c                             |  5 +-
 drivers/md/dm-table.c                              | 29 ++++++++++++
 drivers/md/dm.c                                    | 31 +++++++++----
 .../md/persistent-data/dm-transaction-manager.c    | 54 +++++++++++++++-------
 include/linux/device-mapper.h                      |  3 ++
 include/uapi/linux/dm-ioctl.h                      |  4 +-
 12 files changed, 120 insertions(+), 63 deletions(-)

