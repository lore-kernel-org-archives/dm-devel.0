Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C3BBE4E
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825273; cv=none; b=mc0vN2JA5oPae2YCPqkMOH7dosoOIVMPpaAMnGVXD5nZtW7EcdgwzQnXoGePKhxuONH4qQOF4EdB2KzqcDk1qehbluisDndu/kAJyrgEaCYESeH+AK91VY8OZ80OLkIKxEg9qlVnl1ilK38581jvphcPOMSsAmvEni8CKjSdHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825273; c=relaxed/simple;
	bh=SnfYH3vXTXusGTjck5yxRuO0pzFrrmyQkqIwiFFJBGI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=oHd3VC3TH9nMTlLN6jAh5W47EMJud8GbYNcJy1l/swquTp43Nj8Hd7lS6Ktl/bnxR7FKfqY0olaZ6IpQoklzgvUScrgT1MF8gxAKdz2q3q5/zrt4aGaQP1Akm8f9eJ/zSaOP+G/Cq6D5MwA7vfjfyP4shOX8IXKgIqyEYDaHI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPKS9Azg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPKS9Azg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730825270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=3VENzBYvFejhZBcWldUHtuDaNX62COgzILABI9nQ1q0=;
	b=NPKS9Azg4MJr3Sz9E3IxbKICbXxRftn51eB0VWzavllky/EyCp/zYFUdSQ6Jdp+OaFlT7O
	VJhhWPXu9qrS9tDpGItximCxIr+NtAbeW2RK3qsJiyuLmyzEr2A5gElKvbOO2ZjaftfB1s
	oi51jYGPIoz22b84hp0EzPbcct4S59M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-3Ze06erQMcyjA-UKoe4amw-1; Tue,
 05 Nov 2024 11:47:49 -0500
X-MC-Unique: 3Ze06erQMcyjA-UKoe4amw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61CED19560B6;
	Tue,  5 Nov 2024 16:47:48 +0000 (UTC)
Received: from [10.45.225.180] (unknown [10.45.225.180])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D36D19560A2;
	Tue,  5 Nov 2024 16:47:45 +0000 (UTC)
Date: Tue, 5 Nov 2024 17:47:41 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ming-Hung Tsai <mtsai@redhat.com>, Zichen Xie <zichenxie0106@gmail.com>, 
    Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 6.12
Message-ID: <17b8149d-5d70-9423-a904-fd0ff6aa243c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 8e929cb546ee42c9a61d24fae60605e9e3192354:

  Linux 6.12-rc3 (2024-10-13 14:33:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-2

for you to fetch changes up to c0ade5d98979585d4f5a93e4514c2e9a65afa08d:

  dm cache: fix potential out-of-bounds access on the first resume (2024-11-04 17:39:31 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix memory safety bugs in dm-cache

- fix restart/panic logic in dm-verity

- fix 32-bit unsigned integer overflow in dm-unstriped

- fix a device mapper crash if blk_alloc_disk fails
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZyj5MhQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbSpeAQCcyhjrFxvFQuTJm/nv65Txwqw3+nvu
i45pJ1DbK1awEQD/W0xUhhWrHfXwnb2dHV/mowLSnlou7uUh/JUx9q24OQg=
=5qjV
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (2):
      dm: fix a crash if blk_alloc_disk fails
      dm-verity: don't crash if panic_on_corruption is not selected

Ming-Hung Tsai (5):
      dm cache: correct the number of origin blocks to match the target length
      dm cache: fix flushing uninitialized delayed_work on cache_ctr error
      dm cache: fix out-of-bounds access to the dirty bitset when resizing
      dm cache: optimize dirty bit checking with find_next_bit when resizing
      dm cache: fix potential out-of-bounds access on the first resume

Zichen Xie (1):
      dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow

 drivers/md/dm-cache-target.c  | 59 ++++++++++++++++++++++---------------------
 drivers/md/dm-unstripe.c      |  4 +--
 drivers/md/dm-verity-target.c |  9 ++++---
 drivers/md/dm-verity.h        |  1 +
 drivers/md/dm.c               |  4 ++-
 5 files changed, 42 insertions(+), 35 deletions(-)

