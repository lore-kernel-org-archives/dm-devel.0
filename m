Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9CAC761A6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679947997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/4tuYYHvwjup5khDTMs7LTMIWjyxGdP1Oda3iXlu6D0=;
	b=HUCk1TGo/KJ6dVrcnhBS9KevAjiV+JhUeUpiHN7GkN2SvKfeBsNQrjwKFvAkUI9c3s2due
	ARXeoV6sXrukRlraapPQFXfIjpAzdEx5WZicoWlkIR5sP2u/nSQ9jRZ3sGMAyMoHRIRMzL
	mKtORWDXOUPW+9NLdo5ZJdog1EkVwuM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-2WHPAPbwNDOPxZPKPdUWqQ-1; Mon, 27 Mar 2023 16:13:14 -0400
X-MC-Unique: 2WHPAPbwNDOPxZPKPdUWqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140318028B2;
	Mon, 27 Mar 2023 20:13:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0968940B3ED9;
	Mon, 27 Mar 2023 20:13:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D883219465A2;
	Mon, 27 Mar 2023 20:13:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A7C6194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B923C15BB8; Mon, 27 Mar 2023 20:13:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53B0BC15BA0
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 389068828C1
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:09 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-6A-5rislO2Ck9qiAWXmu_A-1; Mon, 27 Mar 2023 16:13:07 -0400
X-MC-Unique: 6A-5rislO2Ck9qiAWXmu_A-1
Received: by mail-qt1-f180.google.com with SMTP id ga7so9827910qtb.2
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947987;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=0qJNUeSlBs/QEWgQxKgn+fN4efQ2Lsv6ieQkqZqD36k=;
 b=ZnKE7jzOwW37lp+MtyQ4NzofTZzKuV7S7sAIXXAQ7tq1CnFCFLotG9vmILaUI+68cM
 AyViNkxiLlesKY/bLWs86z3jDOwpRppR/TnMvQ1TQht793vCRRiMshvi63B5XTzDYOm1
 qfeZEuzhbBVNf+YFlKqt4WheODeVvaFfkkwlguIUqSOEAY4iqsCBbALoTA0ibmrRbiC3
 swjX1IigF/IsCj7hqp/J+wzdeKX/g4pqEnQ+slyAJ/nxCPaTEgvxfwZxys7ef+/g15l8
 Y9m8Zc/Gv6UnZD1NS1X8dRhzSIzu9dsXu9l+Cwn6T9e/hAVErjWFXRDB8mw6wQtwT2Ib
 MUXQ==
X-Gm-Message-State: AAQBX9clB4WOTp6G7XQYg/hMOatrv4DXmW8xHC17cINkVVFypUxwhANa
 dy5XGlpmvyLvQlIsikXouSuBBt5aDgXrAvG6mZKJ+WQ7Yh/1FOLKeS1HFoSP3ujRmOlRM4nswPC
 imatra/xrOUxfiWXZLM8GkdE5IRlgURZx7fIGHKTACCeWGSsiPTNLSWUAjY3MTIG9MWfdT7lX6z
 Y=
X-Google-Smtp-Source: AK7set/ppDiFJOM41j6nJOJdse4DtNuQjF0Ham2H9Bi3wiljlVirf95cZyVIlW0IDk8G6l/Z0J0d8A==
X-Received: by 2002:a05:622a:1a20:b0:3e3:9041:3f6e with SMTP id
 f32-20020a05622a1a2000b003e390413f6emr23188584qtb.7.1679947986828; 
 Mon, 27 Mar 2023 13:13:06 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 he8-20020a05622a600800b003b835e7e283sm380873qtb.44.2023.03.27.13.13.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:06 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:23 -0400
Message-Id: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH v3 00/20] dm bufio,
 thin: improve concurrent IO performance
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Please review and/or test. Thanks.

Available via git here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.4-dev3

Diffstat from v2 to v3:

git diff dm/dm-6.4-dev2 dm/dm-6.4-dev3 | diffstat
 dm-bio-prison-v1.c |   80 ++++++++++--------
 dm-bio-prison-v1.h |    5 +
 dm-bufio.c         |  226 ++++++++++++++++++++++++++++-------------------------
 dm-thin.c          |   29 ++++--
 dm.h               |   10 ++
 5 files changed, 197 insertions(+), 153 deletions(-)

Changes from v2 to v3:
- fixed inconsistent braces in conditionals and other whitespace nits
  in response to the quick review Jens offered on v2
- also fixed struct layout Jens noted, so locks and data they protect
  are on the same cacheline
- split v2's really large dm-bufio-improve-concurrent-IO-performance
  patch to be 4 patches (patches 5-8)
- removed the (ab)use of BUG_ON in most of dm-bufio.c (in preliminary
  patches 2-4 and also within patches 5-7)
- removed the bio-prison-v1.c's BUG_ON (introduced in patch 14) in
  favor of higher level dm-thin.c code checking when it builds the
  prison key (allowing for graceful error handling), in patch 15.
- introduced dm_num_sharded_locks and use it to remove the "NR_LOCKS"
  magic value (64) used to split locks in both dm-bio-prison-v1 and
  dm-bufio (patches 16-20).

Changes from v1 to v2:
- fixed dm-thin to properly split discards to respect
  dm-bio-prison-v1's BIO_PRISON_MAX_RANGE limit

Joe Thornber (7):
  dm bufio: remove unused dm_bufio_release_move interface
  dm bufio: add LRU abstraction
  dm bufio: add dm_buffer_cache abstraction
  dm bufio: improve concurrent IO performance
  dm bufio: add lock_history optimization for cache iterators
  dm thin: speed up cell_defer_no_holder()
  dm bio prison v1: improve concurrent IO performance

Mike Snitzer (11):
  dm bufio: use WARN_ON in dm_bufio_client_destroy and dm_bufio_exit
  dm bufio: never crash if dm_bufio_in_request()
  dm bufio: don't bug for clear developer oversight
  dm bufio: move dm_bufio_client members to avoid spanning cachelines
  dm: split discards further if target sets max_discard_granularity
  dm bio prison v1: add dm_cell_key_has_valid_range
  dm: add dm_num_sharded_locks()
  dm bufio: prepare to intelligently size dm_buffer_cache's buffer_trees
  dm bufio: intelligently size dm_buffer_cache's buffer_trees
  dm bio prison v1: prepare to intelligently size dm_bio_prison's
    prison_regions
  dm bio prison v1: intelligently size dm_bio_prison's prison_regions

Mikulas Patocka (2):
  dm bufio: use waitqueue_active in __free_buffer_wake
  dm bufio: use multi-page bio vector

 drivers/md/dm-bio-prison-v1.c |   93 +-
 drivers/md/dm-bio-prison-v1.h |   15 +
 drivers/md/dm-bufio.c         | 1988 +++++++++++++++++++++++----------
 drivers/md/dm-thin.c          |  125 ++-
 drivers/md/dm.c               |   25 +-
 drivers/md/dm.h               |   10 +
 include/linux/device-mapper.h |    6 +
 include/linux/dm-bufio.h      |    6 -
 include/uapi/linux/dm-ioctl.h |    4 +-
 9 files changed, 1558 insertions(+), 714 deletions(-)

-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

