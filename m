Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618B0CD37AC
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694810654;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H+JwtgSTcSZE6t9lJ0DZ3+lvhgLKHh1NZHjVzRoS3I4=;
	b=W9+3zhM1odFPz9c+QujOMG3G0pRH/W6+Odde3m1EaAUmDesFyQ1lKw3F15+YNxTKui6rbT
	Nr4DpnK37+ltwIveik9DuBxg/A55Q7v2cxpQ3Wc73XIhPv3brBTmrK5wqKu8VZV/9aMJMy
	QNKu+Iz6Feo/jcPi7TgLJ4J1U3nrgq8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-0NpacadMP4mrdb8H5izDtQ-1; Fri, 15 Sep 2023 16:44:12 -0400
X-MC-Unique: 0NpacadMP4mrdb8H5izDtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3F49858285;
	Fri, 15 Sep 2023 20:44:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 326232026D76;
	Fri, 15 Sep 2023 20:44:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC406194658C;
	Fri, 15 Sep 2023 20:44:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 80FDB1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:44:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3EB661D0AF; Fri, 15 Sep 2023 20:44:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C4C28FB
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:44:07 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15E86829DF8
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:44:07 +0000 (UTC)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com
 [209.85.222.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-3f6gL4v6Nryb0FfT9Ve40g-1; Fri, 15 Sep 2023 16:44:03 -0400
X-MC-Unique: 3f6gL4v6Nryb0FfT9Ve40g-1
Received: by mail-ua1-f42.google.com with SMTP id
 a1e0cc1a2514c-78caeb69125so1079245241.3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694810642; x=1695415442;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=RaheZZ3aWH4dfOldn9ZCeIYAt4mkA7cmMxZmrmD0nnI=;
 b=mwOcOgzAy1Z66fl0Yk1wpDu2hiCEV0+1KWdPKrUzbdv+vU3VlXM9vHXYttVhs+/grD
 4DAzO5WPDOkIBVHnJuuS2Qmb1JZd1YADLiShP1ngZHL177KFU4mD+sc/+oYTxOPmAEy/
 me5vv/UXko4cIpcLdK0qhJssQkb+03JTFm5aZPoalM6qT4s6bI7b1F61hfBnY7DvYlCm
 oMxG5xi/DNfdZKMBgE9eRSwPD7MYwRuQL/uIpc/dLnSMRbpXbB7sICJwLKaCR91AYFMh
 orwGdX2QzmFfXUAVOK/AYBhjsMYXTZOdLYqcXvpQyAiH46yg6fHJqs5AuQYr+jdJ9o7I
 4VUg==
X-Gm-Message-State: AOJu0YxJRM2la87hxvrFWv+Bvm4ibEGUQ/3m4xYvUsrR0PcjDpCdXKL5
 +VXRZOZsJyAudYCu/1stT1oQYLM=
X-Google-Smtp-Source: AGHT+IHh+CGQ1LQ9+nYV2h3rP3/WaZ66pFpMDO8YYt+Q4kieKGfGbDhPXKVAhMW8KfLvX71gD/W7IQ==
X-Received: by 2002:a67:f7da:0:b0:44d:5c61:e473 with SMTP id
 a26-20020a67f7da000000b0044d5c61e473mr2854709vsp.22.1694810642718; 
 Fri, 15 Sep 2023 13:44:02 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 h15-20020a0cf44f000000b0064f5d70d072sm1525969qvm.37.2023.09.15.13.44.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:44:02 -0700 (PDT)
Date: Fri, 15 Sep 2023 16:44:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZQTCEOrIV+JmvfIE@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [git pull] device mapper fixes for 6.6-rc2
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

  Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.6/dm-fixes

for you to fetch changes up to a9ce385344f916cd1c36a33905e564f5581beae9:

  dm: don't attempt to queue IO under RCU protection (2023-09-15 15:39:59 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM core retrieve_deps() UAF race due to missing locking of a DM
  table's list of devices that is managed using dm_{get,put}_device.

- Revert DM core's half-baked RCU optimization if IO submitter has set
  REQ_NOWAIT. Can be revisited, and properly justified, after
  comprehensively auditing all of DM to also pass GFP_NOWAIT for any
  allocations if REQ_NOWAIT used.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmUEt7wACgkQxSPxCi2d
A1prNwf/RB4EyKiSx7XS3ysM6mh/BPGO5FNjWwHebkrSFzAkEowo4i0cY9lRD0N4
x9Wbd5bcV8HarH/fiyffQxgdfXspAIrMt8z5hRnfElkBLzg6hHixxg/3sFCwg+U3
LG6AZFNLil7VmDeca9Pd8MCyXoy1u4ErWjkz3fU8pzzT+NDwRZPZhUMd/MFCWag6
q22S8KMXkYKiAHqKauF52CeDH77XsO66G70t/AElemZ66PpyKpasg2p99RCuHgTg
7jNuMTM6qXYWSWw8OswVXCPZEVfCp4zTFv1ebu9bagfDKR4ppNxwzyz7/CMkir14
4uKKzQ/cy8QND6OR/05zKh4U3ctqyA==
=rVpu
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Jens Axboe (1):
      dm: don't attempt to queue IO under RCU protection

Mikulas Patocka (1):
      dm: fix a race condition in retrieve_deps

 drivers/md/dm-core.h  |  1 +
 drivers/md/dm-ioctl.c |  7 ++++++-
 drivers/md/dm-table.c | 32 ++++++++++++++++++++++++--------
 drivers/md/dm.c       | 23 ++---------------------
 4 files changed, 33 insertions(+), 30 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

