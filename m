Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB6D22D4DC
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752523820; cv=none; b=E4jmg/A0PEuhgNnM9LVLn36dMu30ssD5xaTYIrkQCFAdS5y/MIoDsM1Pp8P2qsKMZZYXflwpIvgmcWZbtzL/V+erK4qtzEU2QiULzT52DCPvMlpFXMXlUxs6XsHpbJXbkkaZfjETsaBCG+u1WeYP1HSsFfNvVXvYXqa5ei9Jvqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752523820; c=relaxed/simple;
	bh=RBie6HAVyzOo+1QiyMS7ZRhPana17U9YU5SsK02DLW8=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=axKn6N5WPj1hW+WbemvWauTRGprEUexX1HSne4Hx0bfYh+6m+t6+aUW8DKygfyqfFO/zss5aJHYOhcwUxgfJTIR1mjDdnZH8fWaj03czlA4if5qGwcGrSbbeOALCtYVc9J5oT6o8GJhiFCPHJwcR/3Ft3vYoDaLUxmBO3kzLsZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i+4eSaGb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i+4eSaGb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752523815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hpUHItiK1rlOoEfRan/Yrz35NHG0+f2SNN4kH0tTyAc=;
	b=i+4eSaGbLH0ahPRpfRXsbEcJwGIRvdb4Kf3ekCTyFt7o+lKIbHhBo28tVnOeTFFH5Vr5rO
	gJiNUEt/KiDzJqmrryEuGfd8zDTngjD5TzR5mYpKer5L5Ag1eJpa9d/m0GVX9HnQ4jI25F
	VVvybwSGFFzciUrKIN2VcasCPaRCtJg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-kr0v4w_PPL2ySFRUFKYBaQ-1; Mon,
 14 Jul 2025 16:10:11 -0400
X-MC-Unique: kr0v4w_PPL2ySFRUFKYBaQ-1
X-Mimecast-MFC-AGG-ID: kr0v4w_PPL2ySFRUFKYBaQ_1752523810
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7000F1800287;
	Mon, 14 Jul 2025 20:10:10 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94B3F180045B;
	Mon, 14 Jul 2025 20:10:07 +0000 (UTC)
Date: Mon, 14 Jul 2025 22:10:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sheng Yong <shengyong1@xiaomi.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes 2 for 6.16
Message-ID: <2f8014be-7269-b451-aeb8-9785e4ef5e10@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6ZlHLJrbi9Vi25DlpTH_vcg5DTBcuxLEBFLjKkO-BGo_1752523810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit db53805156f1e0aa6d059c0d3f9ac660d4ef3eb4:

  dm-raid: fix variable in journal device check (2025-06-23 16:42:37 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.16/dm-fixes-2

for you to fetch changes up to b1bf1a782fdf5c482215c0c661b5da98b8e75773:

  dm-bufio: fix sched in atomic context (2025-07-10 16:48:50 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-bufio: fix scheduling in atomic
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaHU0NhQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbYuhAP9E3m1AlDYfwP1ZOwv0FGXBVtiGFlNw
n9HMdwmNBbiMXQD+MxhLAPfly1oot4qUHy7akqK39ANkwlWLDZgpAcI2dA0=
=kh23
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Sheng Yong (1):
      dm-bufio: fix sched in atomic context

 drivers/md/dm-bufio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

