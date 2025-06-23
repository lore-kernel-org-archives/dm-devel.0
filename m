Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952A87E1
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750695246; cv=none; b=t4tbC0xIaNQvypjWYDqIuKXS6EukNOXQJrwql2RmYxyrqEKa0JEbnrHkrUgOi8fp2OfaU6vNCK4JRtFYgWr08VY3WUuSO7ZdXX2CTyUR6CYiR4C98dtCYuD/C1Nz5Qn3KK54uAkuFNo1z78phu9uQdI7q9EWRxXE1nf9RCjjifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750695246; c=relaxed/simple;
	bh=3Sa5EOwpju+0LAzYgx8+FeaoYLm/agC4WHNmeeSuZAg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=G4V6/cCsv68Vt/+v+OMFVmA9fQsFb+FfFmbf2ygnP102oAQm0uXNSt3WrT4osLe/IY77KtmrFlMry5q3lByLRNjWZ4JOliVxI6995EF5AyzdZJOKKaTZVmbik265Xn4dz0WdRapmlsP8mADDVnHXZ43ix/1kKXxXKk/P5URdXtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPIb+OUC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPIb+OUC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750695243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+aTUkMGaFDRbYAlRbF2fLl6fkJQpm6AHyN7LIlCCB8M=;
	b=WPIb+OUCpqUL9eHVb6FWbE3RY/pMhudYI1ZYmPfTyXCXl+BB9FR3f8wuJ+Fn9qWzuygOsU
	5jdlMaALO2Sw02DRnlFBghHYOQnUxuP/U5and7c8bLLsJFLDlLAHA+lZ0oerI3y1TBB5g9
	6m/tCQgX9N+q1ifzgUrTDZw6bI6sKA0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-6VQhg-2dMECPYXMlYbhnLw-1; Mon,
 23 Jun 2025 12:13:58 -0400
X-MC-Unique: 6VQhg-2dMECPYXMlYbhnLw-1
X-Mimecast-MFC-AGG-ID: 6VQhg-2dMECPYXMlYbhnLw_1750695237
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8FEE18011EF;
	Mon, 23 Jun 2025 16:13:56 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7929D180045C;
	Mon, 23 Jun 2025 16:13:54 +0000 (UTC)
Date: Mon, 23 Jun 2025 18:13:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Heinz Mauelshagen <heinzm@redhat.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, Milan Broz <gmazyland@gmail.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 6.16
Message-ID: <4ac30b56-92f5-c33c-1270-864fd5ceee90@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1GW8_Gi5gBoB8uCDmRoIU6mCOpPnkjP6hV8nwIHDjQA_1750695237
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 86731a2a651e58953fc949573895f2fa6d456841:

  Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes

for you to fetch changes up to db53805156f1e0aa6d059c0d3f9ac660d4ef3eb4:

  dm-raid: fix variable in journal device check (2025-06-23 16:42:37 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-crypt: fix a crash on 32-bit machines

- dm-raid: replace "rdev" with correct loop variable name "r"
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaFl3iRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbcRMAP92ueTp0NFJr9dJne79HbhpJkBAS+b+
25/qycKPv2XDfwD/c3/e3sBOhTIK8PohFR7lR62NepdfrOFVaaKubmNUlAU=
=FD8P
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm-raid: fix variable in journal device check

Herbert Xu (1):
      dm-crypt: Extend state buffer size in crypt_iv_lmk_one

 drivers/md/dm-crypt.c | 11 +++++++----
 drivers/md/dm-raid.c  |  2 +-
 include/crypto/hash.h |  2 ++
 include/crypto/md5.h  |  4 ++++
 4 files changed, 14 insertions(+), 5 deletions(-)

