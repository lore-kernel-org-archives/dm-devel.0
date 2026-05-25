Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FD3770B
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779712451; cv=none; b=k5MiT1WFyew/iUiz8qlNe+iP/mK9gm+B6wNC840WRoDingCQ+rI5VzQ541lWBr46fZnsMxQ1OLtWuNgYgpqJTjcNZRfCCc/feys+RH5IXT7EtSu/qlMPKT5ar4NLx5VoY2ztuWlvmo5QXm+/aj358JlYYn39ZP8yyVukCCRNtJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779712451; c=relaxed/simple;
	bh=IY9RtWV9D+fa1OLJMKWbKBinnW2orGhDIlO/jDm8AFA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Cgm6zmEkzI0VrIvjyfXYWedyJRmwfu42XN4QMG/NP0yxC3k6oVvdg6z2XC2DkkVDwUIr6VXPoZKU0dgO30l14Kmdt05HL0S3QHn+wHi7W/MLfmyAVYP1A7cUk8okwSPBXg2056bdSGlfB5FJjCFmeHUCajrDPOf1mzEsrWMT9MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CraOpdAT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CraOpdAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779712448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=UN8W5q6LFlCsewL0zASJAtSkwg2hmUpWFwFqi4lA/J4=;
	b=CraOpdATNWFrAO7UsVSdfz/3OCIY6LTRS6qYvUifRmfD4zm+MQdhI4Z+NmzFbhnbHUja7e
	luB7XlfQXB2jZn8P9nxc4+xYjh+V4CLEdR3JfeCRjqh1mRISo5fUw5JlY+tigSRfx6TIcn
	xWWX1H1S7MhJHaULxoLZAfz+xYVWYGs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-DxN_CvVcPDysng5RwJFZNQ-1; Mon,
 25 May 2026 08:34:07 -0400
X-MC-Unique: DxN_CvVcPDysng5RwJFZNQ-1
X-Mimecast-MFC-AGG-ID: DxN_CvVcPDysng5RwJFZNQ_1779712446
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20808180035D;
	Mon, 25 May 2026 12:34:06 +0000 (UTC)
Received: from [10.44.32.28] (unknown [10.44.32.28])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1833B3002D2D;
	Mon, 25 May 2026 12:34:03 +0000 (UTC)
Date: Mon, 25 May 2026 14:34:01 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Bruce Johnston <bjohnsto@redhat.com>, Matthew Sakai <msakai@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 7.1
Message-ID: <2e3844a2-d5b0-f365-60c8-6a1e0d856b5b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QJkV5OJrjuxB5iJmFFiJVz3CtxFOLF0DeS9RKAQLSjs_1779712446
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 8c0ee19db81f0fa1ff25fd75b22b17c0cc2acde3:

  dm cache: fix missing return in invalidate_committed's error path (2026-04-10 15:16:06 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-2

for you to fetch changes up to fb7415f2ab0e3c818254cbf5fb0afda71bef4333:

  dm vdo: use GFP_NOIO for blkdev_issue_zeroout on format path (2026-05-04 15:02:25 +0200)

Please, pull. Thanks.

Mikulas


----------------------------------------------------------------
- fix crashes in dm-vdo if GFP_NOWAIT allocation fails
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCahQ/khQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbfzPAP9KuvzdAfxkV3jixoATrLYjWRxXeLO8
VvUo60xhIan1WAEAyd46noLrXwINvdCYzdHDUeLNa5pb4mclwYcwk69dBw0=
=1g2Q
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bruce Johnston (1):
      dm vdo: use GFP_NOIO for blkdev_issue_zeroout on format path

 drivers/md/dm-vdo/vdo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

