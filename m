Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7F41885A3
	for <dm-devel@lists.linux.dev>; Wed, 11 Sep 2024 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726056148; cv=none; b=KLJo0rrGWZYpYNfFVa7NH1LE0I40C5kIPeKb2uxsDlRHl45rUJmzOJRjiTv5k3E1CfF1POM5JLeoIn7z4YwPjNi4a7y/SVx3yDdZsJegzeenEdM4JYGlziJ7RBPVUmw2lnLcbJ9Gn043lVKePQ7bi0dhen8FLA8v/N15kkrhXXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726056148; c=relaxed/simple;
	bh=V8N8NSUN+vLK6Npj0Y5gwcG2MPJvz9M9la5ZDXMBmBk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=UUg26OC1ZLhcPNzAgnPTwF7SS334JLiguroxz65jKbSP//rPXy0rrlQT/cCtRZxX0h/ht/zAJA4wcVBRT4xtJLP7BvsOFggAWJ/tKEtGJddHQskk7jDI+GQeNNfv9zn8cXeW4CEQYwfx3pf1jmV9C8xzfOFX+wlRQo7d4HxHwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8rOlXQe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8rOlXQe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726056145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=viKk6IdhS6r4gimlVzxLWk0TdzZj9Ds/zT7LqRjGt1M=;
	b=E8rOlXQeHyWEgUUdjiTvOKLxFt1UEXR8y+EZBJ6bZPRlA42KTvI3idSRzbzCBshQVifHH5
	bmxVJn9jveS3ZZsf85dE9hmdL9WChg8IB7XHXsQoqNSk4ewSGdMMx6sBa6IvXJbSneNV7v
	W4Xda6aXhVoenPPFWX+XHoaaF1KiUVI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-Y4erGap6Mo6BLnDa3oa-NA-1; Wed,
 11 Sep 2024 08:02:22 -0400
X-MC-Unique: Y4erGap6Mo6BLnDa3oa-NA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 563EC1955DC3;
	Wed, 11 Sep 2024 12:02:21 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB9F8193495F;
	Wed, 11 Sep 2024 12:02:14 +0000 (UTC)
Date: Wed, 11 Sep 2024 14:02:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper fixes 2 for 6.11
Message-ID: <2089346b-f103-dce8-f1e1-a5af3e2dc51b@redhat.com>
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

Hi Linus

The following changes since commit faada2174c08662ae98b439c69efe3e79382c538:

  dm persistent data: fix memory allocation failure (2024-08-13 21:14:21 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.11/dm-fixes-2

for you to fetch changes up to f8e1ca92e35e9041cc0a1bc226ef07a853a22de4:

  dm-integrity: fix a race condition when accessing recalc_sector (2024-09-06 12:38:16 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix a race condition in dm-integrity
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZuGERRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbQDOAQDP5McFAyla+jgWuuZWr3yL6sOibQuN
mHAIwFsiKhdEgwEA5lfHaI6gVCycoiGpmD5EhL4sZSgA4B3e3GXuHb/lRQ8=
=wFGJ
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (1):
      dm-integrity: fix a race condition when accessing recalc_sector

 drivers/md/dm-integrity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

