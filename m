Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ACB4C6EE0
	for <dm-devel@lists.linux.dev>; Thu,  3 Sep 2026 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788447637; cv=none; b=jv/B4SdeJ54j0rESz1XW94WvObBXVt9GOUP1vlatSIqxUu2DTiMfP9hQAFI1RuxC4vbeGVzFujSe1j3K3Ecoc8GIGv5/njO2yINwIHpQ38zu6aT3nOlwNazzG/U1NbLvQPXYla9m+APpNQZ+hSCIcDt/1bqfHqbFMJ53YjAQxRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788447637; c=relaxed/simple;
	bh=gsNd4XmjtHI2hfa+ulR85GH8o8vL/W0E/oJcWCCWzKQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=WAhJnoS8sP0/PvEiAyxjlVGumy4xAt+KkWdn/px1Wi6zLtemrHNOtRI7YRX8/S1ZmN6UQ9kdBzNp43mZN8HB1gotvh0Xz1pg/23g7MaB+kMGjuFmFtOF66A/cRKJfXErLlXFC2bCrOoVTKT5kLnYpUfOIrKMpGsNkSv6+3QJvuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLxb7+SV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLxb7+SV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788447635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+UpBWi5EjKh0rWj+9ru5QOhH3RcemZp4/FEZU0wtv8U=;
	b=ZLxb7+SVTXyNEiWC7s7ZAgSOmPgYBwWg7jFspp0fUaRn3JXEIAUnAluU3iXtgPlsyLFeid
	Mzvu+z1JPfpWl5wN4logyXxDAmPG9DzfYtVXtRxEE1Xf7FubWpGQD1l+S4a+7nOmNcnBAY
	Bf7I8OtvPpjJOraZQaF0Nc8ShUNgMXo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-Lzu2-56xM6mt-sVps0yMOA-1; Thu, 03 Sep 2026 11:00:33 -0400
X-MC-Unique: Lzu2-56xM6mt-sVps0yMOA-1
X-Mimecast-MFC-AGG-ID: Lzu2-56xM6mt-sVps0yMOA_1788447631
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-482e8e1ac69so607589f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 03 Sep 2026 08:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788447631; x=1789052431;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+UpBWi5EjKh0rWj+9ru5QOhH3RcemZp4/FEZU0wtv8U=;
        b=TyOl76KABU8pNj9o3DifsbwfPCkd+LD19u1pFcEo5JaiCq5Fm2He7uup3t4zOPSy2e
         jjFLI6jFs/fD9BNoYDU56pOsmTZwouQkTR6dIGA/UxRH0rOZM8qJXwPmXUxXRNanZhHB
         lounI9RyMXkHul0sE/T1c4yIdEynLrDjv5iSqlQagzQTfVaOdHUeCHldZ3HofGr+PstZ
         0+JKLHS4ZmAGZB/QV0sNdMlzKhgY0SGvUBmjvauJSf0iYh3G5DeQ+SeoGx9354RawLGG
         yn9HsLLXiKM2CXRTOZGL8FTNFTTRyh6oNDI0LWIwrugCLrFp5VQbO9wslAXnIRuhawhN
         0vtw==
X-Forwarded-Encrypted: i=1; AKwUvBy75w0Nnhp0oEU74Hi/vsdjSQDg/WExj5bYdjBwVjibTxT9Jp65vJMd+FYcR7440orI8PCG1ofLjQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lIBfBEeowURfJ5SFJutocI4TEdjtWXP/8jv79SAhErV1rhFrsg
	E3A8dmFzYcAgBeuW2ex53uEptkOLoBMbC+UrL4R7CTnrkxgfNkTdpFrNTSza3LeGTFEggJhyf4T
	xvOZzI/g9TRg4jduQot+Wo0FC2HQ9bnTSEJjmOvpzaHGfvNUxvarBNEdhNnl/
X-Gm-Gg: AYBFou0peP5JDEm5Uf+Eowwmmp+31YlcY6F91ojjqZzmEucREbqwciUkhMVCRcNEhpL
	kj2Rlw7QtiIsBpz8d6XpVmFC/aU/xDgwKI2K9DGSvHbREjJWNRHaQNXvDh1zrqELKNmdWR5xoED
	BCAxlNw+rhhP5+a5SjnNSp5rnbQ/z5jjE6BpZfUdu3GatncexQYxiWFmtHBKSdEYn/qE4d3WdNq
	MuRUlGD55XYam+GigEjM2BPFXSGXSeAW4fZ4zbktazUJnQ6V4Wv8ZbBzUY9SoUt6xfsY/Hd24pR
	Qip8VpwP+bxtQfmwjIFPp4dhaof0zfnJmSAK8zN5ophoC+cFjD2lJjiYJrQcKmNyNFoGfZ+TUka
	9mXVvv9lVxI3jCw9qKSDbcFEXcKlOl6Gt8fqk0Fjr0iw/ZvcZBrFkCc0VUiUVGuhIuQbbPGF3hv
	Wm1xQK3TzRouZijXEVoSWLFXlYB74wIxFhiA==
X-Received: by 2002:a05:600c:3b0a:b0:49c:ee3b:723d with SMTP id 5b1f17b1804b1-49cf13e8ddamr44155265e9.0.1788447630814;
        Thu, 03 Sep 2026 08:00:30 -0700 (PDT)
X-Received: by 2002:a05:600c:3b0a:b0:49c:ee3b:723d with SMTP id 5b1f17b1804b1-49cf13e8ddamr44151575e9.0.1788447627944;
        Thu, 03 Sep 2026 08:00:27 -0700 (PDT)
Received: from [2a00:1028:8391:4248:f5e6:b076:8305:ccd2] (dynamic-2a00-1028-8391-4248-f5e6-b076-8305-ccd2.ipv6.o2.cz. [2a00:1028:8391:4248:f5e6:b076:8305:ccd2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d5d12sm75800955e9.5.2026.09.03.08.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:00:25 -0700 (PDT)
Date: Thu, 3 Sep 2026 17:00:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Ben Cressey <ben@cressey.dev>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Genjian Zhang <zhanggenjian@kylinos.cn>, Chen Cheng <chencheng@fnnas.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 7.3
Message-ID: <e50b0304-3b2d-80d0-4fc1-90339278ea8e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g0CnrPN3nahdssmSKzTExdEnK9lpxEaxbaoj9WAyaio_1788447631
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes

for you to fetch changes up to 7ac81e2d2240f2c57bd073b0733e0b2abca38e82:

  dm-ebs: fix incorrect device offset check in ebs_ctr() (2026-09-02 17:01:13 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- dm-crypt: fix a race condition that could make errors not being reported

- dm-cache: fix rwsem being locked and unlocked from different processes

- dm-integrity: set the 'stable writes' flag

- dm-integrity: fix a buffer overflow introduced in this merge window

- dm-integrity: fix an infinite loop if tag size is greater than 64

- dm-cache: fix demotion statistics

- dm-integrity: fix NULL pointer dereference in the data-recovery mode

- dm-ebs: remove a bogus restriction on the starting sector offset
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCapmHXxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbXwlAP9TGvtNybtjhdQJmo3t528XRdwYrYuJ
TZTRcQ+KMXEAkgEAxG1l4vvECTwSkUhZXub2own7+IypiY8N5cFOWCkdVwc=
=hVzb
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Ben Cressey (3):
      dm-crypt: fix a tiny race condition in crypt_dec_pending
      dm-integrity: fix buffer overflow with keyed discard
      dm-integrity: fix infinite loop on discard with large tag size

Benjamin Marzinski (1):
      dm cache: fix issue with background work locking

Chen Cheng (1):
      dm-integrity: require stable writes for internal hash modes

Genjian Zhang (1):
      dm-ebs: fix incorrect device offset check in ebs_ctr()

Mikulas Patocka (1):
      dm-integrity: fix NULL pointer dereference when the 'R' flag is used

Ming-Hung Tsai (1):
      dm cache: fix demotion stats in passthrough mode

 drivers/md/dm-cache-target.c | 59 +++++++++++++++++++++++---------------------
 drivers/md/dm-crypt.c        |  3 +--
 drivers/md/dm-ebs-target.c   |  3 +--
 drivers/md/dm-integrity.c    | 13 ++++++++--
 4 files changed, 44 insertions(+), 34 deletions(-)

