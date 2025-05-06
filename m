Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59A281539
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534420; cv=none; b=cb4PdNSttqQvY/rcbf0Cm9G0EFenVW5DjZ7b+CxFOFOM1V5X3xbTomWjv94ZlhuuJs3JacZp69E7zTj9KhSTIl+8scIJ0gPRQ50gXG0XpPlEkRSPC5AJJ8eSNlibCCxk5i4uHgGvbW9iVoYAniNth6AMJlzwlQRHwV8Mnrkxp90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534420; c=relaxed/simple;
	bh=Dz4yiPptCc2OZ0vmN6FD5Smzpx9iQAdFGccVfSsOn84=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=uJQGhdfwHp8iv1a8fYeuHDHQ9HGTkhi8T6ab3B3KJM17X5D3y4xIUyvpXG31RZ5s76QBtbTQpeEds0BesTcWh4869LOXZ+ia6xV3p7FXqJeIDnHN7rFY5VCXYkhGjCrhEaiiUc61YYZtIq9+DWc4EUdZooX1YHzK7L1ylztKaDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f2aE82Bz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f2aE82Bz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746534417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=7Unn01TyhtWdzshgIUZfV+DF+j+z1W7qStmqZ2Hrzlg=;
	b=f2aE82BzxTs8qDCR5bvndJHi/ugTxyW1Ej5mmgN/XnpJSGyIz7RcsaEwUXrgDdiG8yyvU4
	/JfpkxMx5vlYU6OgoD04kowRwyPlr4sAsTaHa8Rsvh9+SCVVZc4qODPxtgBUzyU5zbmGBz
	1x4GO7ccBIPZfYeEySfxbCLPS2/Qm18=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-Ky2oN1VuPBOi3wooN9iUuQ-1; Tue,
 06 May 2025 08:26:53 -0400
X-MC-Unique: Ky2oN1VuPBOi3wooN9iUuQ-1
X-Mimecast-MFC-AGG-ID: Ky2oN1VuPBOi3wooN9iUuQ_1746534412
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B78011801A13;
	Tue,  6 May 2025 12:26:52 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C71719560A3;
	Tue,  6 May 2025 12:26:50 +0000 (UTC)
Date: Tue, 6 May 2025 14:26:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dan Carpenter <dan.carpenter@linaro.org>, 
    Tudor Ambarus <tudor.ambarus@linaro.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 6.15
Message-ID: <32f30a35-1bab-0538-8cd8-31ba3635ea7f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uo9QHgJ3BATuu21-LNuqmGlu5CUR505nAjfZ7eEgvLI_1746534412
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66:

  dm: always update the array size in realloc_argv on success (2025-04-28 13:11:33 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.15/dm-fixes-2

for you to fetch changes up to f1aff4bc199cb92c055668caed65505e3b4d2656:

  dm: fix copying after src array boundaries (2025-05-06 14:06:59 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm: fix reading past the end of allocated memory

- dm: fix missing dm_put_live_table() in dm_keyslot_evict()
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaBn8PhQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbVCUAQDDMCRu68hiL5SWai9YXhw40rPTuC7k
e/zHIwRsObItgAD/YvRH1d85XBhQY5x3PCHa3j1u9q+S3uF4naG1n1afqw8=
=L5lI
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Dan Carpenter (1):
      dm: add missing unlock on in dm_keyslot_evict()

Tudor Ambarus (1):
      dm: fix copying after src array boundaries

 drivers/md/dm-table.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

