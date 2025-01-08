Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23622594A2
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736348136; cv=none; b=tTS1gIZOUkNh6KuK9Z9KuIEvT/tLUOKy+4kd9A93RdWHg/32uf3YIturk29/z86XQEFK16ugLvLvS/p5BlIIv+O6V1LB/mkOYQL8/+KUgSNlK7DDqfym4PwkATfUZOEFbIZlqbJc4nMImocPkdhY0dnmuaVvbtYpm8V8JLSLJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736348136; c=relaxed/simple;
	bh=X1p21Ht4x/mR7IwJJYWjJvVfQ9lnqYYaf9qwR+NGEOM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=pvFJr9V2EyeulwSUnt/lZpv6aqXHp4za0bPzOileWk7nD63CM33RffKDWDoU4AgVjf1pVVKLkU4cxDSlNTvEoGcE/0iWS9SddQiE9H04O2TG0SmVgaLAfB7MfuFH6wEJDXQkbX2B2UbJOLTsmi2Sk8ViabC476ywXiPxrLGeLWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PitJhL70; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PitJhL70"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736348133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Yu6I4LWLB16+EGwtHQaLY0xN1vkOcHBIGcTAmBBx/m8=;
	b=PitJhL70loW689T4Q/dixiFn+TJlnDdB6s7vSy/DVKechEMT697/a3RWTmZ3tBh7vM8TDP
	R28OukduLPwM/SATK6WYIxSJEUxdkwl8pZj4IjK5nG5C832dWaJhTANhA9fDpFCwreX05z
	o1vFcURHC4ksXK51M0WGSx6RldgWNz4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-LfjLgi7ONv-sS8KGGJh2MQ-1; Wed,
 08 Jan 2025 09:55:30 -0500
X-MC-Unique: LfjLgi7ONv-sS8KGGJh2MQ-1
X-Mimecast-MFC-AGG-ID: LfjLgi7ONv-sS8KGGJh2MQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 318A3195606F;
	Wed,  8 Jan 2025 14:55:29 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5DBB1956053;
	Wed,  8 Jan 2025 14:55:26 +0000 (UTC)
Date: Wed, 8 Jan 2025 15:55:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Krister Johansen <kjlx@templeofstupid.com>, 
    Milan Broz <gmazyland@gmail.com>, Ming-Hung Tsai <mtsai@redhat.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 6.13
Message-ID: <713cc4d7-7828-5083-844b-95dd61015663@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YvdkfGAUveH1O_tS9acD5nDo3ldkdoeGwKbVO2HMFWU_1736348129
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit a573e404cbf269d46b3a96b18f7316aa57161fdf:

  dm-verity: remove the unused "data_start" variable (2024-11-20 11:44:44 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.13/dm-fixes

for you to fetch changes up to 80f130bfad1dab93b95683fc39b87235682b8f72:

  dm thin: make get_first_thin use rcu-safe list first function (2025-01-08 15:29:39 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-array fixes

- dm-verity forward error correction fixes

- remove the flag DM_TARGET_PASSES_INTEGRITY from dm-ebs

- dm-thin RCU list fix
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZ36OARQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbQOrAP0c8fRH2lrrWr71G8SBPeAwUGAS3lh0
Rhm4Bf9hiwVqHAD+LG0Jq9IX8zo4Ou9xeHYI3NIBvQ2M7Kum7tGKcxvlXAE=
=Qmf0
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Krister Johansen (1):
      dm thin: make get_first_thin use rcu-safe list first function

Mikulas Patocka (1):
      dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY

Milan Broz (2):
      dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)
      dm-verity FEC: Avoid copying RS parity bytes twice.

Ming-Hung Tsai (3):
      dm array: fix releasing a faulty array block twice in dm_array_cursor_end
      dm array: fix unreleased btree blocks on closing a faulty array cursor
      dm array: fix cursor index when skipping across block boundaries

 drivers/md/dm-ebs-target.c            |  2 +-
 drivers/md/dm-thin.c                  |  5 ++-
 drivers/md/dm-verity-fec.c            | 59 ++++++++++++++++++-----------------
 drivers/md/persistent-data/dm-array.c | 19 ++++++-----
 4 files changed, 45 insertions(+), 40 deletions(-)

