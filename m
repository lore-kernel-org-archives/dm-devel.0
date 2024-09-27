Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE52AD00
	for <dm-devel@lists.linux.dev>; Fri, 27 Sep 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727445795; cv=none; b=L2VEJSvc7n38e4yaEfE/N7+RNchrcai2+CAT9rpCZMnSF5RlrnEmB7AB85RgvAdK7upFGS7NulT60bAonAgW91ctpjGqgC4cAMNzCkqcy7+WptCqucFAOKLJi+UloOmunRbvYMJ9m24gKxxPEP8vkKnRWmO5/IEVucItzpw2koc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727445795; c=relaxed/simple;
	bh=xiRjspU1Lexs3Jl+q7dLupDdRE9Zf+UMeiT2k5PFJqQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=rSEfij/Trh8E8FexMUS88fZNtR5ioGZROy8Up0CzxqmTYf9VsFVW/sTrilARjv0veBM/elUJu++Wh9IXAlloFNIovIGK5N1+x7pLYn5vLgJgNa0b8KatdMc86XHcWQmVOy2eTaNnb8VXAo1Sa9gJN+R7XtaN3ODthLJQF5rT4l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRuasOxR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRuasOxR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727445792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=HIhCeofmRHfWV8/qu6FMovYzVe7PoxIXAlxFqo4wU8k=;
	b=bRuasOxR9RgciwcOzal4MYru9nI80KHCSLlyrQndiDQnJf1ZduzJ9kEuxPpRTInIK02wV9
	4ycPPnTprY7QRlwH22XP5nFCqiP0Mfqf6t1FVLotb6Uzx7GqZjOzEzdWLRhYfchctjsVvN
	m6/8+HDWfjDxWGPFrwX19NO0g2M5Aok=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-TEONvkdMMkWC694GUl_n4Q-1; Fri,
 27 Sep 2024 10:03:09 -0400
X-MC-Unique: TEONvkdMMkWC694GUl_n4Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A87A919034FE;
	Fri, 27 Sep 2024 14:03:06 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EACF1955D90;
	Fri, 27 Sep 2024 14:02:59 +0000 (UTC)
Date: Fri, 27 Sep 2024 16:02:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bruce Johnston <bjohnsto@redhat.com>, 
    Dipendra Khadka <kdipendra88@gmail.com>, 
    Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Hongbo Li <lihongbo22@huawei.com>, Chen Ni <nichen@iscas.ac.cn>, 
    Ingo Franzki <ifranzki@linux.ibm.com>, Ken Raeburn <raeburn@redhat.com>, 
    Luca Boccassi <bluca@debian.org>, 
    Markus Elfring <elfring@users.sourceforge.net>, 
    Matthew Sakai <msakai@redhat.com>, Shen Lichuan <shenlichuan@vivo.com>, 
    Susan LeGendre-McGhee <slegendr@redhat.com>, 
    Yue Haibing <yuehaibing@huawei.com>, Yuesong Li <liyuesong@vivo.com>, 
    Zhang Zekun <zhangzekun11@huawei.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    device-mapper development <dm-devel@lists.linux.dev>
Subject: [git pull] device mapper changes for 6.12
Message-ID: <892af38e-2c56-181d-94ef-eb53de22e234@redhat.com>
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

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-changes

for you to fetch changes up to 579b2ba40ece57f3f9150f59dfe327e60a5445b5:

  dm verity: fallback to platform keyring also if key in trusted keyring is rejected (2024-09-26 17:27:08 +0200)

Please, pull, thanks
Mikulas


----------------------------------------------------------------
- Misc VDO fixes

- Remove unused declarations dm_get_rq_mapinfo() and dm_zone_map_bio()

- Dm-delay: Improve kernel documentation

- Dm-crypt: Allow to specify the integrity key size as an option

- Dm-bufio: Remove pointless NULL check

- Small code cleanups: Use ERR_CAST; remove unlikely() around IS_ERR; use
  __assign_bit

- Dm-integrity: Fix gcc 5 warning; convert comma to semicolon; fix smatch
  warning

- Dm-integrity: Support recalculation in the 'I' mode

- Revert "dm: requeue IO if mapping table not yet available"

- Dm-crypt: Small refactoring to make the code more readable

- Dm-cache: Remove pointless error check

- Dm: Fix spelling errors

- Dm-verity: Restart or panic on an I/O error if restart or panic was
  requested

- Dm-verity: Fallback to platform keyring also if key in trusted keyring
  is rejected
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZvapzRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbdKAAP4gHNU7aRmwTPcmvytEqBO4Pcz4eGB/
tytj2+o1orph3AD/YD2X75YHOrdNKTLq+N0ecetAt0yDVUnJAUtKiOnx6Q8=
=0f9T
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bruce Johnston (1):
      dm vdo: add dmsetup message for returning configuration info

Chen Ni (1):
      dm integrity: Convert comma to semicolon

Dipendra Khadka (1):
      dm-cache: remove pointless error check

Eric Biggers (1):
      dm-integrity: check mac_size against HASH_MAX_DIGESTSIZE in sb_mac()

Heinz Mauelshagen (1):
      dm delay: enhance kernel documentation

Hongbo Li (2):
      dm integrity: Remove extra unlikely helper
      dm: Make use of __assign_bit() API

Ingo Franzki (1):
      dm-crypt: Allow to specify the integrity key size as option

Ken Raeburn (2):
      dm vdo: don't refer to dedupe_context after releasing it
      dm vdo: remove bad check of bi_next field

Luca Boccassi (1):
      dm verity: fallback to platform keyring also if key in trusted keyring is rejected

Markus Elfring (2):
      dm-crypt: Use up_read() together with key_put() only once in crypt_set_keyring_key()
      dm-crypt: Use common error handling code in crypt_set_keyring_key()

Matthew Sakai (1):
      dm vdo: handle unaligned discards correctly

Mikulas Patocka (4):
      dm integrity: fix gcc 5 warning
      dm-integrity: support recalculation in the 'I' mode
      Revert "dm: requeue IO if mapping table not yet available"
      dm-verity: restart or panic on an I/O error

Shen Lichuan (2):
      dm vdo indexer: Convert comma to semicolon
      dm: fix spelling errors

Susan LeGendre-McGhee (2):
      dm vdo: abort loading dirty VDO with the old recovery journal format
      dm vdo: force read-only mode for a corrupt recovery journal

Yue Haibing (1):
      dm: Remove unused declaration dm_get_rq_mapinfo()

Yuesong Li (2):
      dm bufio: Remove NULL check of list_entry()
      dm: Convert to use ERR_CAST()

Zhang Zekun (1):
      dm: Remove unused declaration and empty definition "dm_zone_map_bio"

 Documentation/admin-guide/device-mapper/delay.rst  |  41 ++-
 .../admin-guide/device-mapper/dm-crypt.rst         |   4 +
 Documentation/admin-guide/device-mapper/vdo.rst    |   7 +-
 drivers/md/dm-bufio.c                              |   3 -
 drivers/md/dm-cache-target.c                       |   6 +-
 drivers/md/dm-clone-metadata.c                     |   5 +-
 drivers/md/dm-crypt.c                              |  47 +--
 drivers/md/dm-integrity.c                          | 326 +++++++++++++++++----
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/dm-rq.c                                 |   4 +-
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/dm-vdo/data-vio.c                       |  15 +-
 drivers/md/dm-vdo/dedupe.c                         |   3 +
 drivers/md/dm-vdo/dm-vdo-target.c                  |  29 +-
 drivers/md/dm-vdo/indexer/chapter-index.c          |   2 +-
 drivers/md/dm-vdo/io-submitter.c                   |   1 -
 drivers/md/dm-vdo/message-stats.c                  |  48 +++
 drivers/md/dm-vdo/message-stats.h                  |   1 +
 drivers/md/dm-vdo/repair.c                         |  41 +--
 drivers/md/dm-vdo/status-codes.c                   |   2 +-
 drivers/md/dm-vdo/status-codes.h                   |   2 +-
 drivers/md/dm-verity-target.c                      |  23 +-
 drivers/md/dm-verity-verify-sig.c                  |   2 +-
 drivers/md/dm.c                                    |  11 +-
 drivers/md/dm.h                                    |   5 -
 include/linux/device-mapper.h                      |   1 -
 26 files changed, 487 insertions(+), 146 deletions(-)

