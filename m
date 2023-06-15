Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380BEEB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686851800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CHUxim5pbq4mPEQKtunY8wdZ3Mbz43hNBzKlVutkLO8=;
	b=MCGnxMspn6nKgY/ALfwx0lCwJwLSYX+FKoFYQjRJXJlG5hdHHALELo+qPhXB40nLQqaXox
	AcwlQg9Rd8NQ7bX7n/jqhUq3zQlnhpjDOIC1SCXdM0aVsOTlARPBWiZmj9oQuOMIORidPY
	Z1Qzy9QKC3UdanpGPznXKsv4+vb1Hwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-GL5DiE7vMOiHBbuMoD0GhQ-1; Thu, 15 Jun 2023 13:56:38 -0400
X-MC-Unique: GL5DiE7vMOiHBbuMoD0GhQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FEB5101A52C;
	Thu, 15 Jun 2023 17:56:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE1052166B26;
	Thu, 15 Jun 2023 17:56:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F7011946594;
	Thu, 15 Jun 2023 17:56:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47E081946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 17:56:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C20E40C20F5; Thu, 15 Jun 2023 17:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 057A040C20F4
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 17:56:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE2D781DA29
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 17:56:34 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-fAl5PB2XMy-Ss0QdZDyU7Q-1; Thu, 15 Jun 2023 13:56:33 -0400
X-MC-Unique: fAl5PB2XMy-Ss0QdZDyU7Q-1
Received: by mail-qv1-f53.google.com with SMTP id
 6a1803df08f44-62ff4f06b3cso5168206d6.1
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 10:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686851792; x=1689443792;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ux3LNqHXiVRVHHXI1YrGB67pM2l99TmywKdYzW7u9cw=;
 b=a3Mqi9IwdHmOdA0vxaOT9MqJRRnrE5CFVn7wL48Rbp1Ukfu+GwcHBGjHK2FTwblU3l
 3y1hV0HTW1fi46+GpF8RhMn//MAGcwAEoLu55Bj/66rQV5v26ggtKh/vayFKg4uiUnHP
 UoEBX1GB/9ayLPcHk9AT06Ga/52i0Dnu59hzQZKLIsbciQgLkkCueRL30HqzjLrKe85c
 SmRZic/KpZunLDugWf2BBhbnBBSeAVy9Er13/7zgY8pEL6BQURWoWh6uQLr4wqdHnlje
 T0882tutyl+ve/NoLSvJOFG4qEdwxyVpEoFmWms+TXLWItreeViISnqbW1X3YapJS03n
 egnQ==
X-Gm-Message-State: AC+VfDzUo0R+UgJXwLgUXNNn4GHdUXbaImMj2OKQujCAoK7nweCvnsSL
 Vr/9ghEkPKoFEtedV08tJO/1G7g=
X-Google-Smtp-Source: ACHHUZ6Op1iJYarJUSJf4VP6LVaDkRcorQ86vr8KhtOl8L0D+NRk4TIHNaHjR7yqwmo6uTLBeO872w==
X-Received: by 2002:a05:6214:20e3:b0:625:775e:8802 with SMTP id
 3-20020a05621420e300b00625775e8802mr24344268qvk.18.1686851792526; 
 Thu, 15 Jun 2023 10:56:32 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 c17-20020a0ce651000000b00621268e14efsm6009526qvn.55.2023.06.15.10.56.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Jun 2023 10:56:32 -0700 (PDT)
Date: Thu, 15 Jun 2023 13:56:30 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZItQzl4ommfR82jP@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [git pull] device mapper fixes for 6.4-rc7
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Li Lingfeng <lilingfeng3@huawei.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6:

  Linux 6.4-rc2 (2023-05-14 12:51:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.4/dm-fixes

for you to fetch changes up to be04c14a1bd262a49e5764e5cf864259b7e740fd:

  dm: use op specific max_sectors when splitting abnormal io (2023-06-15
  12:47:16 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM thinp discard performance regression introduced during 6.4
  merge; where DM core was splitting large discards every 128K
  (max_sectors_kb) rather than every 64M (discard_max_bytes).

- Extend DM core LOCKFS fix, made during 6.4 merge, to also fix race
  between do_mount and dm's do_suspend (in addition to the earlier
  fix's do_mount race with dm's do_resume).

- Fix DM thin metadata operations to first check if the thin-pool is
  in "fail_io" mode; otherwise UAF can occur.

- Fix DM thinp's call to __blkdev_issue_discard to use GFP_NOIO rather
  than GFP_NOWAIT (__blkdev_issue_discard cannot handle NULL return
  from bio_alloc).
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmSLTh0ACgkQxSPxCi2d
A1rmqggAildPKBjT8nqZmU86lpsy60E03OwvBnGPkMF5pjkOUmTjkb5EWVSAmeuO
ojj0pWlC+1ZvVkiDfkWxt0NL/4ETD4q+5oy1ARBcOawPX6bj0eXLoBr6m10b+KOb
mKAoXgYrESEzQ2qPBe4a4Lj3zIBXzXpMpW9TtF23z4HnDpnwpED5xNPWBgiWc3O/
/6MF1ASLp0DWldoL+gmIp9hEzyQzbzgM4uBOGC4UAYk3U1I55qwX6bWDZ9cQNGMh
AqCSrphuKHvbsb31yb1X3hB3g1XbAeSvvcizgFY0g9ZpncddKm5gx0BWVDO7qGBG
UxLIec19kQ2CIEx/QJZIhEjneLlJ/g==
=mME4
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Li Lingfeng (2):
      dm: don't lock fs when the map is NULL during suspend or resume
      dm thin metadata: check fail_io before using data_sm

Mike Snitzer (2):
      dm thin: fix issue_discard to pass GFP_NOIO to __blkdev_issue_discard
      dm: use op specific max_sectors when splitting abnormal io

 drivers/md/dm-ioctl.c         |  5 +----
 drivers/md/dm-thin-metadata.c | 20 ++++++++++++--------
 drivers/md/dm-thin.c          |  3 +--
 drivers/md/dm.c               | 29 ++++++++++++++++++++---------
 4 files changed, 34 insertions(+), 23 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

