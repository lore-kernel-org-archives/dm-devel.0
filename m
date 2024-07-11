Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAFF51004
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 20:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720729895; cv=none; b=qpWgwGFyWCyOoEIqpSMNciEHYkVeTfnWlrn2RU8NamoGVI14QX/rHKuvIXjG5dEsghbo/zbm1zVZgqZ156fQo2BIaSJsdV2rky9peo/i7AJaptbxdZAaORyQYQK7u2oqbcmYLdG7CKfjdkKAF/+sKel+g6IuQ6nF+JQAlSi8aOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720729895; c=relaxed/simple;
	bh=KzGfBC5r51fHazm3gJL6lYLLBZ3s+1yCStI84cnld6M=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=oRKKHtrhp+YW37TYspuVNZcbujqtWWCgl7yP4eWKYRGWb5TM6aWNQ2fCvhUXHccd2VAuUyRaYb3pGSJl6WzJrX1AqNpg/TIlagJ1qdzzC3l5MHInZwu/JPGLqqDpIg5Radsqzh0B5oA11FXPajMRHIr5OHdaeQzh3jL6uQEmH5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IykWWbty; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IykWWbty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720729893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=qqj8z890iEtc+smj2zrsw9Xa0pjPO5x1NVDf2cQ706I=;
	b=IykWWbtysrCZMA1UEIbbCCfX80jlai4QD4tKf6L/8V6FwuTjrrT2Gj+MtLJ6+QPRJABSmK
	6vunHRDGbSlD1F3SG0iBDIijO1NcFfNcQmx/d2UeAfdvMxk5w4/vYtiJYn/1x62MDREunO
	WvBkvbKbzp492fdo9zLB0Dc3Mp99Pcc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-X_B0FBItO6eLJ2RP9sMIcQ-1; Thu,
 11 Jul 2024 16:31:30 -0400
X-MC-Unique: X_B0FBItO6eLJ2RP9sMIcQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E52E31956064;
	Thu, 11 Jul 2024 20:31:28 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 687391955E76;
	Thu, 11 Jul 2024 20:31:28 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 792CD30C1C19; Thu, 11 Jul 2024 20:31:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 7651C3FB48;
	Thu, 11 Jul 2024 22:31:27 +0200 (CEST)
Date: Thu, 11 Jul 2024 22:31:27 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bruce Johnston <bjohnsto@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Alasdair G Kergon <agk@redhat.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fix for 6.10
Message-ID: <58c35db9-151e-266d-8df0-62275d8f96c9@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus,

The following changes since commit 825d8bbd2f32cb229c3b6653bd454832c3c20acb:

  dm: always manage discard support in terms of max_hw_discard_sectors (2024-05-20 15:51:19 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.10/dm-fixes-2

for you to fetch changes up to d5cfecfe7f3293a4773c4486ac92d742143e8659:

  dm vdo: replace max_discard_sectors with max_hw_discard_sectors (2024-07-11 21:24:41 +0200)

Please pull, thanks.
Mikulas

----------------------------------------------------------------
- Fix broken discard for device mapper VDO target
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZpAyqhQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbRJyAQD8JNzNUDd2hTJhKEGzf7RZ1cOjbp6e
E0N9kWJHw37HTgD/ZJ+24Z9P2U+Uip8+tzisGCcnbHaJMM4ndc+NS/u4rQw=
=65U3
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bruce Johnston (1):
      dm vdo: replace max_discard_sectors with max_hw_discard_sectors

 drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

