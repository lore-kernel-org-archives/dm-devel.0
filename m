Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80732E94139
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 23:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696634205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mYdks41lOg0RwLakXG17eWbo1qt6P+rf5AbZZ3gyEVs=;
	b=JJyjckXxyFr5ZEbmWvhONogHtjZ6SftSX9AbqkZSUtMog57LFS1zCqjB6xdJLayToSVjqR
	UTGAXOAzNyJnrWQ6LKr7+OoVhIm6buhZnlzt+pl15FKxzjqIDlSamsrM3wXmvImkpWNhZF
	Rvmg3h8WjG4anQTImDojtD8S0r57xW0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-eNO681uHNBauVZiYps7o2w-1; Fri, 06 Oct 2023 19:16:42 -0400
X-MC-Unique: eNO681uHNBauVZiYps7o2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B75B803470;
	Fri,  6 Oct 2023 23:16:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F16640D1EA;
	Fri,  6 Oct 2023 23:16:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 176021946589;
	Fri,  6 Oct 2023 23:16:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A6B6A1946588
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 23:16:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 694335CC01; Fri,  6 Oct 2023 23:16:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61441170E9
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 23:16:37 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 382E329A9D4F
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 23:16:37 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-Ak5cP7TiOZ-ZChzzMLMH7A-1; Fri, 06 Oct 2023 19:16:35 -0400
X-MC-Unique: Ak5cP7TiOZ-ZChzzMLMH7A-1
Received: by mail-qt1-f169.google.com with SMTP id
 d75a77b69052e-4181f8d82b9so16408111cf.0
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 16:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696634195; x=1697238995;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Q5zVupE3z01tc2sxIrPY9/eebBvlEDweRwNBcoJ4yvQ=;
 b=dygsSplCUxS70ZAfcod3FrFrC3pQfHyP/3norEp/4y4HfOC8HQ2VUpDGIouc9eoDUL
 A9aKpsAw+iNapnZKyY14njK4QD1EpRGnYzum3DaiBS2ILliNQAmo8cVAdUmrYl3fB0Uc
 GQ0BoctgqBNzxzWgTBiZdj70g9O4pxhjphl7HgDZQM8kCCMNJE+TssNn9zHCGQl1BzBS
 zxaZ/hxIhBBCVWmp4ZLuDm39PbIoXFqSExUraartt+6qtYqh5n36YcIu7GSiFo/4ZCz2
 s0EMqQtn2tE76uWbsCrjMb9mZrPwNr4U0Pk+Z5vbfck5dRaWk3RCj131jev5OQShHsdg
 rr2Q==
X-Gm-Message-State: AOJu0YwGK3yjnGcnyvoSsQ5k2YL+6y8xpJYwmQKqMnqyjvgqslzG9bTH
 lbf5Z6ZtHsxmcrzJ4EdF6VsiK6A=
X-Google-Smtp-Source: AGHT+IFy98nmR7XCkLtFSm2p1Dvn7gdJND9vRLfNV51HKET4h69aObyHD+LOxRGaJ3avJvaBBrB6Ng==
X-Received: by 2002:ac8:5a0a:0:b0:418:76c7:52ab with SMTP id
 n10-20020ac85a0a000000b0041876c752abmr10101943qta.52.1696634195277; 
 Fri, 06 Oct 2023 16:16:35 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 g10-20020ac84b6a000000b00417dd1dd0adsm1625036qts.87.2023.10.06.16.16.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 06 Oct 2023 16:16:34 -0700 (PDT)
Date: Fri, 6 Oct 2023 19:16:33 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZSCVUa3D4BAKGsLL@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [git pull] device mapper fixes for 6.6-rc5
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Alasdair G Kergon <agk@redhat.com>, Fedor Pchelkin <pchelkin@ispras.ru>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.6/dm-fixes-2

for you to fetch changes up to 3da5d2de92387a8322965c7fb1365f7cae690e5a:

  MAINTAINERS: update the dm-devel mailing list (2023-10-06 19:05:57 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix memory leak when freeing dm zoned target device

- Update dm-devel mailing list address in MAINTAINERS
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmUglFMACgkQxSPxCi2d
A1rOswf/T5nqpzFrbrzYj80DpRIQZj+nvTvPTId8X2kWQZ6uJqOpXSA1QP8DHeQj
ycn88TEK8sbXn+wvXXWoPuMrh6FVJoZASvdlhq5QhnwpCT0riwRrnh7XQIrl3Ktn
EQNmAoiKPMF/pZe653BalW/SnRJEa6603RhjHFBuGLKVS7i38oWrmbfcVEdQ+/nf
Pq7gIWoFHtL9LgvhfCLHDg/EYO+brNTJtCnqt5t67iILkK6A//BO9y3O6f2QIj8C
9Y5wGduZyaZ0uOj+LuU3sEqMfr8S6q+0vbJn4yQPDhSM0msLfB20hnYN1Nl2TGIx
B0k3YBScNq6u+pmPjKZMcnRXJnKPaA==
=p6BS
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Fedor Pchelkin (1):
      dm zoned: free dmz->ddev array in dmz_put_zoned_devices

Mike Snitzer (1):
      MAINTAINERS: update the dm-devel mailing list

 MAINTAINERS                  |  4 ++--
 drivers/md/dm-zoned-target.c | 15 +++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

