Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67643165F16
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005048; cv=none; b=fupEsS7OsWcWZNA/gc+U9krL6XmakewMYbjxkvAhTOeCPZIQUV1OF8sGtYYUrLe+ZpLVFGdWb1zQAtghGaiuMbOpnVVHlk3KUnAb6vzDN08064itBcmX31ez2QyOOzQkne2ZGeReT237YCNmLtfooN+iYcC47MV3dwVMswoqFdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005048; c=relaxed/simple;
	bh=qmSpga37zGI0Xb7B2nvqLzr70Ah5eoI+3TEVKbY7ajw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=aYG9+QtHtRJzsvJN7KWBAHptNDVbr9PBl9ES8U+wqFON41HK+LBJo8DQI+2MQbmLMvVMrS3FuzGY2Q1LK7BQ0SQgIA51nWAFqLsW1Swusz1Ep6Uho/vl1AcitlmQ2TqZh9pr1rjVq8nPdmc7uLOHfWAOVsDWuDKiIKYKdouRRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwBHUe8p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwBHUe8p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764005045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=g3pr6/i+U1Bu/ER0gQ5SOYlfgb2AFP69FWqFk+XuAE4=;
	b=TwBHUe8pgKen05Pk7HLTOubnvxIRmTrBsWghdJf2XELktUuYliSkazT8sUA5Wofuud6mzF
	ZcrdiibzJOKxAZZuQPZzNFdC4dW//s16tV584UBtceX+Ji46ZtGRXqowx1P/wAn6A3/5H+
	30V2salEAesRcG5bppXI8xzXRH9Mmlg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-tKwMIf6KO5eSK3kDO-nEpQ-1; Mon,
 24 Nov 2025 12:23:59 -0500
X-MC-Unique: tKwMIf6KO5eSK3kDO-nEpQ-1
X-Mimecast-MFC-AGG-ID: tKwMIf6KO5eSK3kDO-nEpQ_1764005038
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D53841954B0C;
	Mon, 24 Nov 2025 17:23:57 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16D1D3003761;
	Mon, 24 Nov 2025 17:23:54 +0000 (UTC)
Date: Mon, 24 Nov 2025 18:23:48 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Li Chen <chenl311@chinatelecom.cn>, 
    Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>
Subject: [git pull] device mapper fixes for 6.18
Message-ID: <f61beafb-51de-8783-dbb5-b94d6fba7cc7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8xKgEhyCcBeR5k1n1hBmfjVOFnLqO6NXr7BlrXMtJHs_1764005038
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 6a23ae0a96a600d1d12557add110e0bb6e32730c:

  Linux 6.18-rc6 (2025-11-16 14:25:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-fixes

for you to fetch changes up to fe680d8c747f4e676ac835c8c7fb0f287cd98758:

  dm-verity: fix unreliable memory allocation (2025-11-21 12:51:41 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-pcache fixes

- dm: fix a regression with empty flush bios

- dm-verity: fix unreliable memory allocation with GFP_NOWAIT
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaSSRaRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbVntAQCs9dZccAOOondJ43c15Jrinz6eh9gE
g3y0rlM866VjCgEA7RM12YglsEy4MyX7Cpiu4xs3hvkjnG9L5p2yK9kJ5Ag=
=dEko
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Li Chen (3):
      dm-pcache: allow built-in build and rename flush helper
      dm-pcache: reuse meta_addr in pcache_meta_find_latest
      dm-pcache: zero cache_info before default init

Mikulas Patocka (2):
      dm: fix failure when empty flush's bi_sector points beyond the device end
      dm-verity: fix unreliable memory allocation

 drivers/md/dm-pcache/Makefile          | 2 +-
 drivers/md/dm-pcache/cache.c           | 4 ++--
 drivers/md/dm-pcache/cache.h           | 2 +-
 drivers/md/dm-pcache/cache_req.c       | 6 +++---
 drivers/md/dm-pcache/pcache_internal.h | 2 +-
 drivers/md/dm-verity-fec.c             | 6 +-----
 drivers/md/dm.c                        | 2 +-
 7 files changed, 10 insertions(+), 14 deletions(-)

