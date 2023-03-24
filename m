Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C9FC6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680663;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sjhNwLyzlrI5Nd6RoxkAUFLFg+nASntlmvZEf8TPf7g=;
	b=YbJe7lmW58s7Y6sBtzEUtwdDoTtasnxfkIh17B83tmLU12BXbJ/0p22YT9eH0bS37OxhPA
	z4Pu95n2eIu7NkA1lCfBpsno4jhQ5HVU6ntRIC6FK/mNmwv2rJE+y0YTwIdaVxvgtbvq2d
	2b2jdxVjzI4QUTgTbhwO1s4Nsa0lM/g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-IvDMLeIlOc2r8NokWh-wwQ-1; Fri, 24 Mar 2023 13:57:41 -0400
X-MC-Unique: IvDMLeIlOc2r8NokWh-wwQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B85F63C0DDB6;
	Fri, 24 Mar 2023 17:57:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7779E492B0C;
	Fri, 24 Mar 2023 17:57:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A90919472CC;
	Fri, 24 Mar 2023 17:57:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E22661946A6D
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95BCB2A68; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EA88440D6
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68BF5101A531
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-xUz75s0PMEObkyvqqL_2PQ-1; Fri, 24 Mar 2023 13:57:02 -0400
X-MC-Unique: xUz75s0PMEObkyvqqL_2PQ-1
Received: by mail-qv1-f46.google.com with SMTP id o44so2165760qvo.4
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680620;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=0pgbVxku/SERnvHwqjL/zSj3oN14cdGjOWYCaoljOO4=;
 b=Ern6bv/rZxyQlrgt7cEWbI9AP7aI8Q0qWZwSF5PhMgJ43/3dLVZ1D1o3LQuGzYv+g2
 KHrZjrMfwH2OP8oqz32LvCf5jRE+zvYI+0SXXs90DJTJ4PT7Dg0+gvx4aye3psFVCGxm
 7bfvji+nJjnigNy1qvc6YMoDddZUyJeUcTGW4tCU7t7lz3lOSKdtBgveM7gUOOYJOTdT
 Y1Maqij84Xblqln0oxNuggpvlZuG7SE9PY1zC89p5dG9cU/BDgWObGbeTO8Lh03kBh0q
 iiQY3Ota0O3vBFN5RH14Q3EKgzqg1BxvLmxE0I4Bm8BcPIMhOCBQPyFsWr4kUDPJh19U
 Mspw==
X-Gm-Message-State: AAQBX9ePYAQKzkXwn58u4cSgp1WdtGESegPrOSrL6+Fv6PUXG4CG5zNC
 8n0Tpam4VSNMPTsA/s/s7Hh/4L1vNu0RTcYaH5iV+JyviPqYf7EJQUE6xSUNYCHIL6oUNSXkikW
 parteIPQho41WB3Vj3+ox1OdchmigzjJkFVGULryUm9lP210O2PQip0tGdoc/gPCXl4uV+YwPfK
 s=
X-Google-Smtp-Source: AKy350YIMdLtee9pqwLUGDnz2HJDv9utRDKSI0McKyJpOJ5/JI3+moTTSTAHfS8GD6Ef0QjCYYY8Ug==
X-Received: by 2002:a05:6214:d05:b0:56e:9c11:651e with SMTP id
 5-20020a0562140d0500b0056e9c11651emr6039810qvh.27.1679680620491; 
 Fri, 24 Mar 2023 10:57:00 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 u18-20020a0cea52000000b005dd8b9345c5sm857446qvp.93.2023.03.24.10.56.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:00 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:47 -0400
Message-Id: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [dm-6.4 PATCH v2 0/9] dm bufio,
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patchset has been staged in linux-next for the 6.4 merge
window. The relevant linux-dm.git branch is here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.4

The initial patchset I posted earlier in the week for this line of
work didn't properly split DM thin's discards. To be clear: both Joe
and I missed this, and the issue impacted the patchset I posted _and_
code Joe had developed and tested to that point.

device-mapper-test-suite's "discard_with_fstrim_passdown_true_ext4"
test reliably reproduced the incorrect splitting.  The issue was the
DM thin target wasn't respecting the new restrictions imposed by
dm bio-prison-v1 (which the DM thin target uses). Joe fixed this and
the code reflects that in patch 9.

All said, and as detailed in the "Testing" section of the header for
patch 3: these changes have _now_ been extensively tested in terms of
dm-thin (and dm-cache as much as device-mapper-test-suite
provides). The cryptsetup testsuite also passes (DM integrity uses
dm-bufio).

PLEASE HELP with further testing of other more exotic DM bufio
consumers and elaborate usecases (be it via Android, Chrome OS, etc).

Please use whatever tests you have to put pressure on bufio.
In particular: focused testing of bufio's shrinker, verify
DM_BUFIO_CLIENT_NO_SLEEP (via dm-verity's tasklets), etc.

There is still time to add fixes for 6.4 should any issues turn
up.

All review is welcome (I'll rebase to include Reviewed-by or Acked-by
tags). Also, positive reports in the form of Tested-by replies are
welcome!

Thanks,
Mike

Joe Thornber (4):
  dm bufio: remove unused dm_bufio_release_move interface
  dm bufio: improve concurrent IO performance
  dm thin: speed up cell_defer_no_holder()
  dm bio prison v1: improve concurrent IO performance

Mike Snitzer (3):
  dm bufio: move dm_buffer struct
  dm bufio: move dm_bufio_client members to avoid spanning cachelines
  dm: split discards further if target sets max_discard_granularity

Mikulas Patocka (2):
  dm bufio: use waitqueue_active in __free_buffer_wake
  dm bufio: use multi-page bio vector

 drivers/md/dm-bio-prison-v1.c |   87 +-
 drivers/md/dm-bio-prison-v1.h |   10 +
 drivers/md/dm-bufio.c         | 1970 ++++++++++++++++++++++-----------
 drivers/md/dm-thin.c          |  110 +-
 drivers/md/dm.c               |   25 +-
 include/linux/device-mapper.h |    6 +
 include/linux/dm-bufio.h      |    6 -
 include/uapi/linux/dm-ioctl.h |    4 +-
 8 files changed, 1509 insertions(+), 709 deletions(-)

-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

