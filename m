Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660C3BD246
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297342; cv=none; b=gl2Nbf6n0MYiJIfTMR5jaQz5GgLydhZBkVTBH/M5c8JCmmV3hBRp5W+Dokd+WSuy5RlAFfpcevRxUVdU0tTHKoHLG4ZGTMw/ZVUZZMo3nAG1HMsUq5/6TYHHLbFF5rSGNhmz+9/NjIyummCEpZHCO/47abYzMfb7dC8xO+/b5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297342; c=relaxed/simple;
	bh=kpUr2B14u1ifRj2B5+5yIVE5ah2Xq93GEq413z0Ebhs=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ivgAGbMfWF5fgjnWQEHbC8ayxkmK/Or7pRt6jYXD3eiAfrxw5Ce4KeXhnKKaEuscCu1Gvg79YKSD0qH78qfFwU1oTbb361DAf7a6cBqfZDpUb16IsKLWU44+oAGklWgXKlmVMgmP13evtarH5DctOWoAz78K3u2tnKiO5LGeY4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0WlwWSj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0WlwWSj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777297340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aM9nHoOSJPtj2SUswkFOf2BAU6lmdaPtIAohMGJVT8I=;
	b=A0WlwWSjZkVta34O11Gi3P0mOeIY/dL6b4mrVEDx3bwuSf9YsNIWnhM+wU76LV+ExZcgcF
	3A9RLbaPEBkipNo9Gq7AtWxfJa6OZ2sDYA4T/8x9hoY3YcbSszn+eG7Fjn9qS3Jn2hgEg5
	B03M5mHVsOX3wWkT+zenbQIgKtfx/wM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-RZ1jwJemNpOSr1hcGCg_Xg-1; Mon,
 27 Apr 2026 09:42:15 -0400
X-MC-Unique: RZ1jwJemNpOSr1hcGCg_Xg-1
X-Mimecast-MFC-AGG-ID: RZ1jwJemNpOSr1hcGCg_Xg_1777297334
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 124A019560B5;
	Mon, 27 Apr 2026 13:42:14 +0000 (UTC)
Received: from [10.44.34.100] (unknown [10.44.34.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B9E519560AB;
	Mon, 27 Apr 2026 13:42:12 +0000 (UTC)
Date: Mon, 27 Apr 2026 15:42:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 7.1
Message-ID: <9591e654-efbf-7252-d3dc-3f026627cf49@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UMq_vRV6BMbYAEsVE5djsuoGEpFR8Xe2hY_8g7AszGk_1777297334
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 028ef9c96e96197026887c0f092424679298aae8:

  Linux 7.0 (2026-04-12 13:48:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes

for you to fetch changes up to 09a65adc7d8bbfce06392cb6d375468e2728ead5:

  dm-thin: fix metadata refcount underflow (2026-04-20 19:56:44 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- fix metadata corruption in dm-thin
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCae9j2xQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbZNOAQCRaAC3AItYoodZnPgVZe9jAiVWEowg
YwKsPaBHo+WWHgEAnQbmUJ/twEMFNEP7RHcDqcorO2fu83W+lFkCV7hU+g4=
=m1L+
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (1):
      dm-thin: fix metadata refcount underflow

 drivers/md/persistent-data/dm-btree-remove.c | 8 ++++++++
 1 file changed, 8 insertions(+)

