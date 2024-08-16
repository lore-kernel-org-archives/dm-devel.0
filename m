Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C01AD3FC
	for <dm-devel@lists.linux.dev>; Fri, 16 Aug 2024 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723816948; cv=none; b=gmOECaEYbokj+0aI4FuYTmdJSYTuzPZLokuHpkXFafX6nBEoV1gMtD7r8Dk4qFjh5R8yo46LC+QyDJt7c7JJvLWK7FpP2r6NEjIZrJQXb61NSSO+ZhCMh95hprrb+MFrX0+psfif1TcGL0T4jKp7ERmK2kf7v8qOIWVRQHd4XOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723816948; c=relaxed/simple;
	bh=+MVUxVJT49cQePQshGHILCMuTPFpiOvc46aGHJKspus=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=akf8q/5+I/PLQLFuO3H4Po/vRnZK2i1cJQMq4eCI2ONN7EKZz5Hau/tOQmtW9eePehsGtozxGdAlXEXMgmuv6FlQvSmzEI/iQKini6JYVl6gRLHqF98LE9wEJOOrJ6IjaM5z6Yv0XwoW5ncKZh6AkddoVsFeYPM8hGK3XBRemcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAHXu778; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAHXu778"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723816946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xLnf4qvWA6UGISQ6XXl/72aXKO7qCPF0u6JxMcT9BBY=;
	b=gAHXu7781aB8HRZvdLbdVJYxWIPvPDIJSCFpJzEW7gGq2R3/pEB957pKhziBL+fmlP85sb
	1toqQao+Vc7nJMl++EIc/dDe4QG1iwGdNnAqRc5Ijinhd+uCIxcox42qcYceIsRi8ydy1y
	00bYAm/uPd/mVSpqfrlbDGN4CfZfraA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-RF0aEGEcMTigxjMvsHig_g-1; Fri,
 16 Aug 2024 10:02:25 -0400
X-MC-Unique: RF0aEGEcMTigxjMvsHig_g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1B061955D48;
	Fri, 16 Aug 2024 14:02:23 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EE8C1955F38;
	Fri, 16 Aug 2024 14:02:23 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 2582D30C1C1E; Fri, 16 Aug 2024 14:02:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 225943FB48;
	Fri, 16 Aug 2024 16:02:22 +0200 (CEST)
Date: Fri, 16 Aug 2024 16:02:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Daniel Yang <danielyangkang@gmail.com>, 
    Khazhismel Kumykov <khazhy@google.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper fixes for 6.11
Message-ID: <9ead5ab3-f5e1-3de6-f88-6bac6c3b1355@redhat.com>
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

The following changes since commit 7c626ce4bae1ac14f60076d00eafe71af30450ba:

  Linux 6.11-rc3 (2024-08-11 14:27:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes

for you to fetch changes up to faada2174c08662ae98b439c69efe3e79382c538:

  dm persistent data: fix memory allocation failure (2024-08-13 21:14:21 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix misbehavior if suspend or resume is interrupted by a signal

- fix wrong indentation in dm-crypt.rst

- fix memory allocation failure in dm-persistent-data
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZr9XxBQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbWZGAQDNczuQiRv21Rrlb/hmvwyv1r9125Kk
KKEl+/baxTL0qwD9GJo5l8C1RLp2M3AQyCF4JbY0lXBY42ywGLwOCC9KXw0=
=e/lM
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Daniel Yang (1):
      Documentation: dm-crypt.rst warning + error fix

Khazhismel Kumykov (1):
      dm resume: don't return EINVAL when signalled

Mikulas Patocka (2):
      dm suspend: return -ERESTARTSYS instead of -EINTR
      dm persistent data: fix memory allocation failure

 .../admin-guide/device-mapper/dm-crypt.rst         | 15 ++++++++-------
 drivers/md/dm-ioctl.c                              | 22 ++++++++++++++++++++--
 drivers/md/dm.c                                    |  4 ++--
 drivers/md/persistent-data/dm-space-map-metadata.c |  4 ++--
 4 files changed, 32 insertions(+), 13 deletions(-)

