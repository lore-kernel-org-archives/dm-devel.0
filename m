Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B367313272
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550439; cv=none; b=F/K0U41WYtcmr2kgeXE5Z+m7WD4I+onF18nb4MDWxeukqDkDl3aWK3ND7GSH8/vkRDVjDRH0huOslVsvrxaMaD5FcbVot3jG2dQUZv3BLLWqDmDVHP76h9xlS++eQwl9tVKXD92wKQuhhLqSYkCrmmxCdJJQPWoZNzsqi/9Ya+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550439; c=relaxed/simple;
	bh=4c47xPDDjPzKoGhx+Hw49R/bsT19NYfF3G1wXkGS2Do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=HlzzQnEsMZyyHAr6vbgHIfwqSfjymuObqHc8rKi0y/AzriAuOlD+l9ot51EPhG8PLzGGp27p030Y18maFdsUd0/Cujy5AcGh5efCFpQCsKYAc4PXbgN8RElo5TPaC+scQrnEew1cR7Gz/5MFLDYQGbWSkvbM9ld+p1ZFHbdeZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsJW4ZyK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsJW4ZyK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781550437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AgbsOK3sdnnjgNQF2vGdF101ICJqv9hd6ctTt0ntyUA=;
	b=UsJW4ZyK3KKXY6e+Cab/liw+d78wzOeiFJLFjNfq/JWJpqxWPTR4y2I8xX+0BLe4kChqMX
	Niz0SPR2eBPsdqgNFfvMelqvTPX6TncMH90InCe2AB/i+uY26qRoXZzPDHYbwbbXWjdo9x
	VgrPrlWkPQX/5RQp3WssH/yFaRvpQ/4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-DMNyVgP7M3qZUe0XSvn07Q-1; Mon,
 15 Jun 2026 15:07:14 -0400
X-MC-Unique: DMNyVgP7M3qZUe0XSvn07Q-1
X-Mimecast-MFC-AGG-ID: DMNyVgP7M3qZUe0XSvn07Q_1781550433
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EB6418007E9;
	Mon, 15 Jun 2026 19:07:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FA011800661;
	Mon, 15 Jun 2026 19:07:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FJ7B0L797586
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 15:07:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FJ7B3Q797585;
	Mon, 15 Jun 2026 15:07:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/4] minio cleanup patches.
Date: Mon, 15 Jun 2026 15:07:07 -0400
Message-ID: <20260615190711.797573-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iX54M2Utx8UR-d1nzNm2Wt26ruDsAwEKArqN_55mYa8_1781550433
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
multipath config options. It's a companion of the patchset to handle
their deprecation in the man pages.
https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/

It does not completely remove the minio setting code, since there are
ideas for reusing this in the future. The final patch is simply a change
to avoid a kernel warning message that I hit while testing these
patches.

Benjamin Marzinski (4):
  libmultipath: deprecate rr_weight, and make it do nothing
  libmultipath: deprecate rr_min_io_rq, and make it do nothing
  libmultipath: deprecate rr_min_io
  libmultipath: don't set hwhander for bio based devices

 libmultipath/config.c    |  6 ---
 libmultipath/config.h    |  6 ---
 libmultipath/configure.c |  1 -
 libmultipath/defaults.h  |  2 +-
 libmultipath/dict.c      | 90 +++++++---------------------------------
 libmultipath/dmparser.c  | 28 +------------
 libmultipath/hwtable.c   |  3 --
 libmultipath/propsel.c   | 54 ++++++------------------
 libmultipath/propsel.h   |  1 -
 libmultipath/structs.h   |  1 -
 tests/hwtable.c          | 13 ++----
 tests/test-lib.c         |  1 -
 12 files changed, 33 insertions(+), 173 deletions(-)

-- 
2.53.0

