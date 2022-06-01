Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5771C43334
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 21:01:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-C19EfS0EP7iUYV_u58w09A-1; Wed, 01 Jun 2022 17:01:02 -0400
X-MC-Unique: C19EfS0EP7iUYV_u58w09A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32C9918A6525;
	Wed,  1 Jun 2022 21:01:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D54D40314B;
	Wed,  1 Jun 2022 21:00:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EBACF1947B8B;
	Wed,  1 Jun 2022 21:00:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47B831947B8E
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 21:00:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1817C1731B; Wed,  1 Jun 2022 21:00:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13E7E8288A
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 21:00:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAAF31066682
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 21:00:55 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-P4Ab9YQIOWOKPJ-E9jQf-g-1; Wed, 01 Jun 2022 17:00:00 -0400
X-MC-Unique: P4Ab9YQIOWOKPJ-E9jQf-g-1
Received: by mail-qk1-f182.google.com with SMTP id 14so2302585qkl.6
 for <dm-devel@redhat.com>; Wed, 01 Jun 2022 13:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=3Il2sr4cXjU8yOwsfjBHoPflo5uLJpNZAFsBDi52fpw=;
 b=j/wWT70eBjtleLaBgseiBRBDvu1WDv4nG59K+qvd4tezwDNj0GmoRQiODr/y4PWHiX
 4MRjg4m3t6e/VvvLKJQbyqKBiBJrWTJEgLoMJTbVNaF4z2BvHVn1wDXguiyk9qWeK263
 W5c8o0BoEg5/+nOogVcivnR+gvPJgUcsjrSVLZlM918eWFSY7U1kjKOhMhZnaj9ZpSPh
 Tx8CfsqU0G1KdzvTgwkZA5W5HVvciLVji2cO+9c4QCTPyjj28mSJXc/M/dzApkvmz8/M
 B5vYumiwr7ldllb+d5bu1FJZzP0/ZAyy/bphmZPyxPx6czCngwsBCtE52sGx1hyB/dRL
 HNAQ==
X-Gm-Message-State: AOAM5329ZD2IzwS9pL99dxJu1Wu0YVi5MbWcbbXJcLqs9UDy9EYhzBJY
 wMXW9CUxDztS+Z44UmHeh1lcZKBFfBLYIXY=
X-Google-Smtp-Source: ABdhPJyD9xv6RupucWCiGGBWA4YEtS55Ndss4nBseM+kOnW6oYvBleLUYOueHZSBL+6CJAA6y254sg==
X-Received: by 2002:a05:620a:1a22:b0:6a5:dac3:7fb1 with SMTP id
 bk34-20020a05620a1a2200b006a5dac37fb1mr1077202qkb.377.1654117188277; 
 Wed, 01 Jun 2022 13:59:48 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 d16-20020ac81190000000b002f93ece0df3sm1681790qtj.71.2022.06.01.13.59.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Jun 2022 13:59:47 -0700 (PDT)
Date: Wed, 1 Jun 2022 16:59:46 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YpfTQgw6RsEYxSFD@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [git pull] device mapper fixes for 5.19-rc1
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
Cc: linux-block@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>,
 dm-devel@redhat.com, Kees Cook <keescook@chromium.org>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit ca522482e3eafd005b8d4e8b1331c911505a58d5:

  dm: pass NULL bdev to bio_alloc_clone (2022-05-11 13:58:52 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes

for you to fetch changes up to 4caae58406f8ceb741603eee460d79bacca9b1b5:

  dm verity: set DM_TARGET_IMMUTABLE feature flag (2022-05-31 16:22:30 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM core's dm_table_supports_poll to return false if no data
  devices.

- Fix DM verity target so that it cannot be switched to a different DM
  target type (e.g. dm-linear) via DM table reload.

----------------------------------------------------------------
Mike Snitzer (1):
      dm table: fix dm_table_supports_poll to return false if no data devices

Sarthak Kukreti (1):
      dm verity: set DM_TARGET_IMMUTABLE feature flag

 drivers/md/dm-table.c         | 19 +++++++++++++++----
 drivers/md/dm-verity-target.c |  1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

