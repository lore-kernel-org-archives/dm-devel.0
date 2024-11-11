Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB4A1ACDE7
	for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 21:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731361266; cv=none; b=bgPbHkvPO+y5PSHIjuc2uynJBqtOVjmMQpgXXqqaw+2EynoEJUJLWfESs/p9n6fn5UYlvYrsrKX9KuCrEWQ0l9QB2fMuXvLvYPsShTJOtyFoXRt7195VpETPDaDbGr4Gi7dWpoC6bcfazBDkTN4IzvocLEYX9FTbdgREmb0DOmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731361266; c=relaxed/simple;
	bh=To7UuAwL+ZEjnLCLmovf7kHF3vVuTQXoLf6JtdMllxE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=aRZ+b/Wi+MN2KjR79ZrJqyEz9g7cURQX2JsbuloT9VNyCPU39v/GIMXKnBQomHWiU4dPJRQOF/UAkZTRmO/y9ZdH5xeLapP/sBU8SK7EtWrbNRgHVs9IkHWll1nTQtxuJmcu1N1TZDAoAKgSJ08Kwh2mad3P5MIjYJjnbhMy/Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQsVIwGo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQsVIwGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731361263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DRnUA0lLmS9E4vZW0l2LkNWy93zNFg+WJv0ck2fH0tk=;
	b=hQsVIwGoAE0hcv2E49gTTYm3VmxjOTTVtLtkw/xQgfJ8BK3g7mbo8RkAAtKl8ez5X8jN1T
	u6wIvVicxGEmqbb/Lxoa5bQGmYgeTuEu0gG0eUXuEmpTxNi/QA7vELDMJRApRm1FGvzoSP
	kOEr/ORuRXKezfc5DUBgH7He2HK3riU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-217-GizHQII6PjylcqWCbVHvyw-1; Mon,
 11 Nov 2024 16:40:59 -0500
X-MC-Unique: GizHQII6PjylcqWCbVHvyw-1
X-Mimecast-MFC-AGG-ID: GizHQII6PjylcqWCbVHvyw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9236C1955D4D;
	Mon, 11 Nov 2024 21:40:58 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B5F19560A3;
	Mon, 11 Nov 2024 21:40:56 +0000 (UTC)
Date: Mon, 11 Nov 2024 22:40:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    thornber@redhat.com, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 3 for 6.12
Message-ID: <896b202d-3378-856d-eed9-97e443f9c7d7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3-3Lf6oJ7J7nQU-l9TKD4JA0Ukb9xHQaam0ybLFcZGM_1731361259
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 2d5404caa8c7bb5c4e0435f94b28834ae5456623:

  Linux 6.12-rc7 (2024-11-10 14:19:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes-3

for you to fetch changes up to 346dbf1b1345476a6524512892cceb931bee3039:

  dm-cache: fix warnings about duplicate slab caches (2024-11-11 17:04:39 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix warnings about duplicate slab cache names
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZzItHBQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbRzaAQD0c/ERvaahr7yR3fD7b1pyT6g6LpwE
e2P80QUQRKhCPAD9EXwZo1DdpCNQX7g6eU3jtof9oQoAggAdMjJRc4SF+g4=
=W477
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (2):
      dm-bufio: fix warnings about duplicate slab caches
      dm-cache: fix warnings about duplicate slab caches

 drivers/md/dm-bufio.c                    | 12 ++++++++----
 drivers/md/dm-cache-background-tracker.c | 25 ++++++-------------------
 drivers/md/dm-cache-background-tracker.h |  8 ++++++++
 drivers/md/dm-cache-target.c             | 25 ++++++++++++++++++++-----
 4 files changed, 42 insertions(+), 28 deletions(-)

