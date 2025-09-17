Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285AF2D97AB
	for <dm-devel@lists.linux.dev>; Wed, 17 Sep 2025 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118592; cv=none; b=IJPy6zP21uWnmxlVrxUap1kNvyFGCOrbgjWD8r5g/UgMCtW95JGCmmQhCtI7yO8GqIJxKhbnc5zmfuS3ZhvJlpLDNVw3bHXI1EYJTwIR8MezLYLwy+fYoRSisio7gK7b8XLy2Kbundqz3lyIVTnPBJaPfi08teznZS2oF0QOTMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118592; c=relaxed/simple;
	bh=sXwgIKOHycRtBK/nt02G6XYEwWXiRcHvlStfFbcnqDs=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=spH0HNFeDc46jSmfYkLaZHqKSN68J/5Sj6KI3AiXB4DahvVJ5kkE0S7v6CME/PDPeKFZpDL5R9y1mkskDp7qW1JRTE0H5yoIJnQ9pXcqNA3ntEFKXB5fovlZ/KAzxgydafPFonqpS9sk/bYs+LexdaQSQMzzOkbKV+LK9c5i7Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exPGGm8L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exPGGm8L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758118589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ktVlG533lJ0vfugr5ik2wt7ogF2xjRUiez4Q/Uf7goo=;
	b=exPGGm8LYO/9jnawwHpKwNtmU9WefoShGIbulTSicYKKB/3gaGF9ndH/03VCfvcsxVvJ5P
	wSNukQsuTOFsNSVDTQBrbhBabKg3uTmSxfwx0Bo1wsrkI8Vik9OdZLz0CGkDDpo2RGk+J9
	ba3q5dg08qgIgd/mBBz1NNOQ6xPLqss=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-DmiE4hcaMta4WEmbukJl-w-1; Wed,
 17 Sep 2025 10:16:28 -0400
X-MC-Unique: DmiE4hcaMta4WEmbukJl-w-1
X-Mimecast-MFC-AGG-ID: DmiE4hcaMta4WEmbukJl-w_1758118586
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4906219560B2;
	Wed, 17 Sep 2025 14:16:26 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2D4E1800446;
	Wed, 17 Sep 2025 14:16:24 +0000 (UTC)
Date: Wed, 17 Sep 2025 16:16:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 6.17
Message-ID: <26358e47-e03b-82f0-5bf6-2cc2db3ec8ef@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xdid1lEdM6z4_CJ8JPxPz2j-Qh-HkGQTX5tUs543OvA_1758118586
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.17/dm-fixes

for you to fetch changes up to a86556264696b797d94238d99d8284d0d34ed960:

  dm-raid: don't set io_min and io_opt for raid1 (2025-09-17 16:04:29 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix integer overflow in dm-stripe

- limit tag size in dm-integrity to 255 bytes

- fix 'alignment inconsistency' warning in dm-raid
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaMrAdRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbYhtAQDsWJHG7dOVuvoY+kyM9SmC2My6l5u2
awYBsjVT//9KDAD/c6s+ffeseY6VpBuFmPx5i75ieCmUcuKTMUxgdIErPwM=
=FXwZ
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (3):
      dm-stripe: fix a possible integer overflow
      dm-integrity: limit MAX_TAG_SIZE to 255
      dm-raid: don't set io_min and io_opt for raid1

 drivers/md/dm-integrity.c |  2 +-
 drivers/md/dm-raid.c      |  6 ++++--
 drivers/md/dm-stripe.c    | 10 +++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)

