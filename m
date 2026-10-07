Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C546B46C826
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367834; cv=none; b=msjxZdkY8W4mIFy8HyLkpu/4TLfy4YVxW32dIyCjuyrH5uve2vtpBEN8GRQXZ/JxcM9N08dIUMZLZ3rQImKNCvY7kp3JLNKVM8q0trTBBq2KGPIK738EBtU71S1bJNV2wIqGnHZAIlYu5zAysbiuTZv32+QqUm1BsxaCtpr+TcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367834; c=relaxed/simple;
	bh=7X3NDXfJto5uwi9+D9kYZpMT29Wazim0bXcW3FFJ+Ks=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=QRawFYzM3Ab55tFBdPvbb0DdqqatgKTGg1jIe2kGzMCMSUjvqYa8tKw89hx4rERW/rmDL7BCy0BaAwjagYucWjEv41fY/mnG4hLn0Rgcbcj0fTZopZ6pMN0NAbmzNCGa/pvHpYoYi71G9+CCwIvxS0N69o4bIGtHxHSnw7PWcFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1E7Zi/q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1E7Zi/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791367822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=p8++hBs8qGFXPbUjLrjZWU97+hbE1RIfT6sAWO9yqg8=;
	b=g1E7Zi/qFQe3XNvNfd3pZs84JOH9+SdJhmUvqeZHrkY3FgoF2YYBGBE7K3a8MerCqhrAyX
	ffFgeNAgSmqpQprwjxitjszrvak8GaWTY2se9VmIwwubeUNY+iVnWHk/s29vpADUIDuiRq
	sf+dO6Kag13MyiNQVQhnG35TxBqOZDY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-vhjGksGBMd60YixrokJJdQ-1; Wed,
 07 Oct 2026 06:10:19 -0400
X-MC-Unique: vhjGksGBMd60YixrokJJdQ-1
X-Mimecast-MFC-AGG-ID: vhjGksGBMd60YixrokJJdQ_1791367818
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76DCF183EEE4;
	Wed,  7 Oct 2026 10:10:17 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5C5730000E7;
	Wed,  7 Oct 2026 10:10:14 +0000 (UTC)
Date: Wed, 7 Oct 2026 12:10:12 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ben Cressey <ben@cressey.dev>, Ma Xinmeng <1564938642@qq.com>, 
    Palla Raghunath <raghunathpalla.0209@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 7.3
Message-ID: <36d38e30-5861-35c5-e375-a6b0fd889ed7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pDzIIFYXSyP6leHpi2wmXUb1KICmQ7lFm9qIaNYtyPI_1791367818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-fixes-2

for you to fetch changes up to fc79aeb86a2c244c1f1894e2d8f2966fe2b60fa2:

  dm-integrity: validate the superblock on resume (2026-10-01 13:18:00 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- dm-integrity:
   - validate the superblock after re-reading it
   - fix buffer overflow if tag size > 64

- dm:
   - fix reading up to 7 bytes beyond the end of block in dm-ioctl
   - fix reading free memory if the ioctls are called concurrently

- dm-crypt:
   - fix a crash on invalid table line

- dm-snap:
   - fix a crash on invalid table line
-----BEGIN PGP SIGNATURE-----

iIoEABYKADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCasYIiRQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbZsMAQCkQZOhRxNpWdCK1+vOK8TLA8Xvv0Ay
vTsPiZ0BtZbS9gEA4Pv3pKaMxYH061Uw2YPhxw/5LOT+GBUYoHwMA5xeGAQ=
=1Uzr
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Ben Cressey (2):
      dm-integrity: fix buffer overflow in inline mode with large tag size
      dm-crypt: reject the lmk IV mode with AEAD ciphers

Ma Xinmeng (1):
      dm-snap: reject the transient exception store for snapshot-merge

Mikulas Patocka (2):
      dm: fix reading free memory in do_resume
      dm-integrity: validate the superblock on resume

Palla Raghunath (1):
      dm ioctl: don't let data_start run past the buffer

 drivers/md/dm-crypt.c     |  7 +++++-
 drivers/md/dm-integrity.c | 54 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm-ioctl.c     | 14 +++++++++---
 drivers/md/dm-snap.c      | 14 ++++++++++++
 4 files changed, 83 insertions(+), 6 deletions(-)

