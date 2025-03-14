Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D7A1FAC34
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741955827; cv=none; b=hIKAOFMuBwp129/ilA944QjuEsC9aMj+TMQeNXbNeffklZAoVBg9YQ1/sNf6zZ8a0i/i56+SCXQiaHmQIswaTaEHVUFVd7+JbZEVHUWhprH/2ZMx83U9d9TK+3B9QzUBVcHwUcej5DE/w3y6OSt1nVYeUlQ89PA/CEVcdEIqPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741955827; c=relaxed/simple;
	bh=mxwmUmTPo14E96qu6gZRVcPwS7s06ATRpsgFZowZ5Sg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=j2+VkKvC3Bm/S9DLpfBUXmxvRpHJzxcPcrjCe9vV1sencXUHK2H2Uyt9YB24Qp4qv1cOo5EwjQQNMuqwBzXhB9OT9rIMisg9WVOl/X75W58ZGStvySR3ayBqWHjQnR3c8JRWQXZxl9gKPJ4lMQ3F1OZgZ7tUpSVHxPeihgbsVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fS+C23zM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fS+C23zM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741955824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DxOyD6e4c2I9g65B1bYddqmsiZ6zHH6f+PuB7chTQnU=;
	b=fS+C23zMIuR1E05uq3xftUZBAEyGPSJyHqVswxrf6MX17prnpjAydrnDDwfjayf21BuYQW
	rMNgKkhMHkHjP8hxR2voQ7IJtipIqP74iR95urJsWsZeSUF8kPqdv1i/cOtCM2kqHM9ji4
	3YAnyDROcBTkj4vV0Ddj0cKiEXmm0eo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-dwv_dr1MPmq2W_E1gLQzDg-1; Fri,
 14 Mar 2025 08:37:01 -0400
X-MC-Unique: dwv_dr1MPmq2W_E1gLQzDg-1
X-Mimecast-MFC-AGG-ID: dwv_dr1MPmq2W_E1gLQzDg_1741955821
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90814180035C;
	Fri, 14 Mar 2025 12:37:00 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FD0818001D4;
	Fri, 14 Mar 2025 12:36:58 +0000 (UTC)
Date: Fri, 14 Mar 2025 13:36:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kent Overstreet <kent.overstreet@linux.dev>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 6.14
Message-ID: <f965255f-978d-af57-50f5-fd3942edd570@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wQP3p65bukVADtsp0f3YpFh_AVTettXe3EV-H65IQtQ_1741955821
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 36e1b81f599a093ec7477e4593e110104adcfb96:

  dm vdo: add missing spin_lock_init (2025-02-24 12:07:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.14/dm-fixes-2

for you to fetch changes up to 57e9417f69839cb10f7ffca684c38acd28ceb57b:

  dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature (2025-03-13 18:54:11 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-flakey: fix memory corruption in optional corrupt_bio_byte feature
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ9QgCxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbQOXAP0dT6GGRIeW02cWgBeDAT4dmCOMyZhV
Y4QYbBWnfpm97QEAmuEkUrw8apznS9kJ+n/O4NFbBa3gWJJ0K80HnPxX8wE=
=HWcU
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Kent Overstreet (1):
      dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature

 drivers/md/dm-flakey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

