Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDF52571A1
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740401350; cv=none; b=GAUqOeRRTK2xw5JIeALfDuEWePqrUnbOQdAm1OJ6zRteq/9OPm/gFhoI/GjrOtFOu6S0Lrn6on6S2+zcT0PZoXWSt9cktIUf1rUITrYIjvZftFdCPc4b8FPJziZn2jkkhQfr96Aim6jED1hNvpzbS0lQa1slbArI8la2UfOPLDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740401350; c=relaxed/simple;
	bh=n77Sv0za7CGRBq3rqjRvfDbwS7FOBbZBmcTY0dTkOtw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=UmXsPvQwNAroNqohzBvYwT2hNngeTAWdnzm/ZPq8AquBqfm7OPzrVqxK2AQGgRo0AB1zFzp3AyOap0DVBozIScBgpgwtz94krMw6/PTeRMC2kSDG8iS8FbD6aPr6GRseVlHRPP5+AJMODt8zs1mnN2p0kqfS1CwcMRvF94DlA3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJ7IwI0q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJ7IwI0q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740401347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=trrO072s26o42y/7/skeNOeG9YbcSngz/Ed5VtEccKY=;
	b=BJ7IwI0qpgh7cPYHYsQDJhhTuWfHRzIOG3MB7WuljKZlP11fTddKuvmNga38RhnfSf8H71
	iLzQsqRkSm4AI/3GR86NnwebCuMJyukogUDBT1vQaIZdFZwK2UK/2Sc8qQMSa3JKy1QZFR
	bl7kMGn6Ds/+mtnjr7EjRPmmMJOfLTM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-2Rac6o_gMi-n-WW44cDzSQ-1; Mon,
 24 Feb 2025 07:49:02 -0500
X-MC-Unique: 2Rac6o_gMi-n-WW44cDzSQ-1
X-Mimecast-MFC-AGG-ID: 2Rac6o_gMi-n-WW44cDzSQ_1740401341
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36C561800875;
	Mon, 24 Feb 2025 12:49:01 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FBDB1800352;
	Mon, 24 Feb 2025 12:48:58 +0000 (UTC)
Date: Mon, 24 Feb 2025 13:48:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ken Raeburn <raeburn@redhat.com>, Matthew Sakai <msakai@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper fixes for 6.14
Message-ID: <21cb8031-3dd4-9cb0-94b3-4be4b19b53f1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WI3aG09HlnmUh-5Z_wBQf_v05UbGtJmhxYXkCTUKnRg_1740401341
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b64319:

  Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes

for you to fetch changes up to 36e1b81f599a093ec7477e4593e110104adcfb96:

  dm vdo: add missing spin_lock_init (2025-02-24 12:07:02 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-vdo: add missing spin_lock_init

- dm-integrity: divide-by-zero fix

- dm-integrity: do not report unused entries in the table line
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ7xnCRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbVueAP47A+AczQa868MpFc2p8w5AmqqF6jyW
s303VCS9wUCtBwD/TkFcYz5AtIRvIIdZiwtOKALPekjeLeOZaOSnrdJVkw0=
=x00V
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Ken Raeburn (1):
      dm vdo: add missing spin_lock_init

Milan Broz (2):
      dm-integrity: Avoid divide by zero in table status in Inline mode
      dm-integrity: Do not emit journal configuration in DM table for Inline mode

 drivers/md/dm-integrity.c  | 25 ++++++++++++++-----------
 drivers/md/dm-vdo/dedupe.c |  1 +
 2 files changed, 15 insertions(+), 11 deletions(-)

