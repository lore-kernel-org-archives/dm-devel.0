Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614FB2309A3
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745856129; cv=none; b=DnY9RVEHGiwNdTSKlyJN2E9QckTjMgB3J61sy4vU3YmcTLyAYlY2IIoddwj+YurQESEw1FEQro5S5/oPInlqPKzIcg3+ggC8qIZkJbJD2Y+hxCcaL8iMraXwecNAkGuFMEkB4wXPltqdiOkVjoHApmg5NWsCiNNxhhrbRP2FGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745856129; c=relaxed/simple;
	bh=UtxF7/vS4xDx+uVIMx7Wpr1ZoOIJWKs2osfNRO5h1B8=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=tZbA+U/OimMWV4V/Se2NW2wCBhTk4884GCw/qUJnKTUtzR4bjQc3k3cYfY7ncv238STqLcSTp4sqig75byQtXa++t4/g5YGendKuXN1v4LVK2b/utAFQAoaX5+CZ6e8BlAhAzSQ4Xbkxu8Z6abIu4D4WHv/zzkqpG1hYuDILTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5Fuwj0d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5Fuwj0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745856126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LGL4h6jtmaNm5WINV1tIqCZcBSGiXCoIT0M4XhBHKG0=;
	b=h5Fuwj0dy1+IrUV/7orj3sWV+ShkuTVuT9jvGM3O1OSFTyX1M97eLoV5x9mmyG7FQu7VeN
	Ds6fm1/d3OFpPA2rF7e0VxsvHnWGFf0/SwGCQD9cBwJSc9jkljQAzMd8/+VoW08KzKVCRb
	YKRkNNcXDMikmVV2/hgXhCuq74JMo0I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-yrDRScgTOCWgKKzrB0VIQA-1; Mon,
 28 Apr 2025 12:02:04 -0400
X-MC-Unique: yrDRScgTOCWgKKzrB0VIQA-1
X-Mimecast-MFC-AGG-ID: yrDRScgTOCWgKKzrB0VIQA_1745856122
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A67C1955F01;
	Mon, 28 Apr 2025 16:02:02 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5239E1801381;
	Mon, 28 Apr 2025 16:01:59 +0000 (UTC)
Date: Mon, 28 Apr 2025 18:01:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    LongPing Wei <weilongping@oppo.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 6.15
Message-ID: <7f751e0d-49ff-9099-5269-af809a70fd08@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1b_bHvfmC6dTBYyfiGR6CZxgzsaeMXaudT3Ktu5bv4Q_1745856122
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes

for you to fetch changes up to 5a2a6c428190f945c5cbf5791f72dbea83e97f66:

  dm: always update the array size in realloc_argv on success (2025-04-28 13:11:33 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm: always update the array size in realloc_argv on success

- dm-integrity: fix a warning on invalid table line

- dm-bufio: don't schedule in atomic context

- dm: Fix W=1 build with clang
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaA+jNxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbUzpAP0Q/RPWwWg/x31Qj119bDDkgEFBTrZd
PqVPJzKsnZgTTQEA4AaxwgVz4pYDknrPCmHHGYKrLI0QxoVv4s7GOMrA9wc=
=ze9q
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Andy Shevchenko (1):
      dm table: Fix W=1 build warning when mempool_needs_integrity is unused

Benjamin Marzinski (1):
      dm: always update the array size in realloc_argv on success

LongPing Wei (1):
      dm-bufio: don't schedule in atomic context

Mikulas Patocka (1):
      dm-integrity: fix a warning on invalid table line

 drivers/md/dm-bufio.c     | 9 ++++++++-
 drivers/md/dm-integrity.c | 2 +-
 drivers/md/dm-table.c     | 8 +++-----
 3 files changed, 12 insertions(+), 7 deletions(-)

