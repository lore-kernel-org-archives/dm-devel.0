Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5BFEB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 20:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690490517;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7caaEc3WuBbl2YHL2/tfBVDst/dVS+QT5OGy2NpJ5IQ=;
	b=ErwS6qiiCITL8jsYkPFjGoyew9aJU021mKKowC0+IPA4VpyurhxVIqbOAdB4iq+igpOJNz
	BzucnMMKTCsHK00UX7J8qO/H5gYH8mF8V8xxDJIsUHE06lzHQnxTatOCF6kCY2uRzjeYMM
	yuURbHb1gVGFRjtlxEvcbzcIiU2uJn8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-se0R19NRPeq42Hh_g37oyA-1; Thu, 27 Jul 2023 16:41:54 -0400
X-MC-Unique: se0R19NRPeq42Hh_g37oyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5502C29AB3E6;
	Thu, 27 Jul 2023 20:41:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA28AC57965;
	Thu, 27 Jul 2023 20:41:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E4AC1946A6A;
	Thu, 27 Jul 2023 20:41:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FD331946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 20:41:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C3C240C206F; Thu, 27 Jul 2023 20:41:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14D6540C2063
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 20:41:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1383858F1E
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 20:41:42 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-M3auZb9zO5CAilGTxkzmKw-1; Thu, 27 Jul 2023 16:41:41 -0400
X-MC-Unique: M3auZb9zO5CAilGTxkzmKw-1
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-76754b9eac0so120025485a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 13:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690490500; x=1691095300;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=imzr9gf0e2pNdaKE7K17eEPetoldcbtASO5vqhQPuOs=;
 b=W3OlJ/WiJy+Q99/kaxzzays1AdU1rw8ILvYiZ1YiK7ZRP0bN1ScwvY0S84aWM9zC0f
 ecJsm4Apm2ilrQQ+SWOQB2EEU9qV726lDwx3n/mVYBXIrlPoorjwi5FBCVncEyoXCIy8
 PnnVd40+FPIh0y9a+melijETjP71IU38BTvaedEEilNau3u91KpJ3ns87NmtuLnmAfWc
 H4UZ1loCTDXuQVxRWIZLgsESmefKkryqPw9OsJivWxqt6NXFZoMtcfUMrFVYjkmIYtHo
 vGwAR8UV3J3yiT8atOddrg8cPGw235COKtG5rfIXfhYEOB+nOLFVxAl4dNrLNWHE7vfl
 qouw==
X-Gm-Message-State: ABy/qLbgoLu3Hdz6U1hvjRy7Exd9xt5Mn1r9XrVPfvFJqCpTxaFAXtgV
 P1FyffbjdZkjgekJPpOaTgriTPSNOZ+gLRmvYJo1
X-Google-Smtp-Source: APBJJlEdn+lfgl6m0z4xO9GaLOCk+43ZMDakR8zQH9o7S3KDV1QulUPjcSb2rs+mdlhI4WHm+HVceA==
X-Received: by 2002:a05:620a:46a5:b0:769:542:b3fd with SMTP id
 bq37-20020a05620a46a500b007690542b3fdmr705916qkb.8.1690490500539; 
 Thu, 27 Jul 2023 13:41:40 -0700 (PDT)
Received: from localhost ([185.202.220.182]) by smtp.gmail.com with ESMTPSA id
 ow34-20020a05620a822200b00767c61ee342sm656143qkn.48.2023.07.27.13.41.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Jul 2023 13:41:39 -0700 (PDT)
Date: Thu, 27 Jul 2023 16:41:38 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZMLWgk816vYI3j11@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [git pull] device mapper fixes for 6.5-rc4
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
Cc: Joe Thornber <ejt@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Yu Kuai <yukuai3@huawei.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.5/dm-fixes

for you to fetch changes up to 1e4ab7b4c881cf26c1c72b3f56519e03475486fb:

  dm cache policy smq: ensure IO doesn't prevent cleaner policy progress (2023-07-25 11:55:50 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix double free on memory allocation failure in DM integrity
  target's integrity_recalc()

- Fix locking in DM raid target's raid_ctr() and around call to
  md_stop()

- Fix DM cache target's cleaner policy to always allow work to be
  queued for writeback; even if cache isn't idle.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmTC1UoACgkQxSPxCi2d
A1pIGAgAhQjlNQ83DexvmMUoNDRGFxOBiOcL9DnVtiXsLd/wTXZTEDIDXJaH9hCq
MAj7aqadBeHlWT+vNMOYH9ePPtySEKGs8VM/4/fwNtT6wMyqxZZk4JyN7z+YBVJV
d/9lryVZYRWK7ICgRenR/VSxv8/JgVTBGZZqyl20SXhtlYxndxGcLeV0X8fP3G1Q
pxdsNuE7TBclB8qrXiPIOlIK0HcSikz6CfQIar3zgip6fO+Wwb92CZ1DOGGi1RJz
bsTmZXn08l3d1tMJ+y4umZm+Izq8gvWSgDBywRdWq/D6Ao1ScVqY4TExFSSkjDk0
PUY49vMF/FsKfNt5/VK0/i2U7QAKDQ==
=92HI
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Joe Thornber (1):
      dm cache policy smq: ensure IO doesn't prevent cleaner policy progress

Mikulas Patocka (1):
      dm integrity: fix double free on memory allocation failure

Yu Kuai (3):
      dm raid: fix missing reconfig_mutex unlock in raid_ctr() error paths
      dm raid: clean up four equivalent goto tags in raid_ctr()
      dm raid: protect md_stop() with 'reconfig_mutex'

 drivers/md/dm-cache-policy-smq.c | 28 ++++++++++++++++++----------
 drivers/md/dm-integrity.c        |  1 +
 drivers/md/dm-raid.c             | 20 +++++++++-----------
 drivers/md/md.c                  |  2 ++
 4 files changed, 30 insertions(+), 21 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

