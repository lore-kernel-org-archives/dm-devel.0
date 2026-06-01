Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DC55733E
	for <dm-devel@lists.linux.dev>; Mon,  1 Jun 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780328591; cv=none; b=hUAX46PGzY5fzCF7QhBspdwQ8fjo7hCh1+jPvR+6V/VKTOqEQNDLYSF8Y2UbkpaAi1K8eySKpkzHISqwkyFlbWa7jQY+Hu5Nam59Ux08tubuRCs+I1g86nU1ArnP28oxbcZvYO+naSbX+16Sv4DYrLv8ow7UG781n5BuizDwlhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780328591; c=relaxed/simple;
	bh=13Jg9FYUvoeEcozTZ5h93zGuxKqOfNMjjR93qrdCEJE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ecz742iXQHa9xaTCMAOhXEma+Ins4P0BtzDl9CwabaXWiF+CscB7hTkLD4iksIEl4IRCflCIT4Q8GeENMeFfExMgVThCSsy1PGrWxDUTOELhzwhAyScakz4ad1ooeiaPkeWplOAamGT0NxtPCN9e0BULJaygJJkIxkUKA2ucsaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQj061CR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQj061CR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780328589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=dQGRsJVL0EmG7vVIcBytAKE7iIxGerWJhh1pmLomH+U=;
	b=eQj061CRa/nVVKXTk7OobuSjtNEkNfoBXqY97wev29yQi5x4LI3N9xn/CeP3mTNsrb/pJP
	b7iwhR1JEEDXgWN77R6zjbOTflH36QbINeZCXf1kvyf7dZXHrzmjFuKTRQZJKybk+bjZZB
	17168PGSTb05dJc8tWiZ5B1YNKh43Eo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-Yw827maROSexvsLWboLnaA-1; Mon,
 01 Jun 2026 11:43:06 -0400
X-MC-Unique: Yw827maROSexvsLWboLnaA-1
X-Mimecast-MFC-AGG-ID: Yw827maROSexvsLWboLnaA_1780328581
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D042819560A2;
	Mon,  1 Jun 2026 15:43:00 +0000 (UTC)
Received: from [10.44.49.105] (unknown [10.44.49.105])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE7C91956095;
	Mon,  1 Jun 2026 15:42:58 +0000 (UTC)
Date: Mon, 1 Jun 2026 17:42:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, 
    Guangshuo Li <lgs201920130244@gmail.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 3 for 7.1
Message-ID: <cc233087-609d-8bde-ea0b-51d654636ac4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mfO8N-dbBLZymzosAKjDoO0j2vr3levpgIEurhVLZN0_1780328581
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit fb7415f2ab0e3c818254cbf5fb0afda71bef4333:

  dm vdo: use GFP_NOIO for blkdev_issue_zeroout on format path (2026-05-04 15:02:25 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-fixes-3

for you to fetch changes up to d3f0a606b9f278ece8a0df626ded9c4044071235:

  dm cache policy smq: check allocation under invalidate lock (2026-06-01 17:30:24 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- fix race condition in dm-cache-policy-smq
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCah2mPxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbVGGAQDNaDwK2kE1az7Jpgu91U23R8fSxeBz
SomeFHmqEHcEQAEAk2/3vG20zshIWFbz9Y1ZdZ9q9RKLrAh/83i3YVLbkQQ=
=D0RT
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Guangshuo Li (1):
      dm cache policy smq: check allocation under invalidate lock

 drivers/md/dm-cache-policy-smq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

