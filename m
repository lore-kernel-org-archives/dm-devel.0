Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAC7C00140
	for <dm-devel@archiver.kernel.org>; Fri,  5 Aug 2022 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659726686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CFagGdxa2sDfHAEJAKvv2V9I/pxZsXTYOAmvqWl3P6E=;
	b=KCnYyISaBrvmiKMGXpDz24bDA3/SNzITtW6Gp+0VRpTZy6eTU8Mj9KnBfH/q3FNBUaQ8Zd
	957Czb9X3XYT4HsdLRkL4K4G1bCktQQRBBsEPw28wgP9mwfCIZ9gNeSXk3qmvobxKO+pMY
	43/gW7MJ46OdmtO0oELGLcwAEr52Uhw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-GGhU8lxjNwCBuVGNO6W_OQ-1; Fri, 05 Aug 2022 15:11:23 -0400
X-MC-Unique: GGhU8lxjNwCBuVGNO6W_OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5847E1C06ED9;
	Fri,  5 Aug 2022 19:11:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38E0540C1288;
	Fri,  5 Aug 2022 19:11:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECA4E1932220;
	Fri,  5 Aug 2022 19:11:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 591BF1932216
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 Aug 2022 19:11:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4A63240C1288; Fri,  5 Aug 2022 19:11:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 467BB4010E37
 for <dm-devel@redhat.com>; Fri,  5 Aug 2022 19:11:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3310A1991C58
 for <dm-devel@redhat.com>; Fri,  5 Aug 2022 19:10:56 +0000 (UTC)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-ohO482JHNPaphGrzirzO_g-1; Fri, 05 Aug 2022 15:10:54 -0400
X-MC-Unique: ohO482JHNPaphGrzirzO_g-1
Received: by mail-qk1-f174.google.com with SMTP id p4so1355258qkm.1
 for <dm-devel@redhat.com>; Fri, 05 Aug 2022 12:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=M9gX/uf12sWsOSRDHrNVPPG966ZdqGBVh/pkIWrHveQ=;
 b=SXdLICft4g/45L53kKqAVI1safCYVPJTAGrTCu6mMwN17cxq5gMhpgRpaNwheUW2co
 VGBwrgsu+0z5EPNseIrn/G7j7gzR4V/0rCzSGOk5t3gTFFdAGXwybye7Saj5qkH07Cfl
 qLPuxsvnlg4dK5BhkhXjN6G0D9S0C7+1F+5YvVI0bM/moLdveX+3SbxgmfUzuBKVzaRn
 zyU0Ey/XDU4FmwSvgzvFZybssh7UTk/pxxDB7JCAER964ruSvcWUjVIpDGqJaWvP98pe
 580GDGlw0p8H5tCePO6L8x62w60BVcS5Flk3NBRk4zAt8lET9khQWfl+jclmjQQKMcwr
 M/tA==
X-Gm-Message-State: ACgBeo3BhkTTlHQ7CY+fijSwd0ZKiwyMbFY4bD+uaARSxAPytRmZTczZ
 QcQSsLQBIlvF431ob84spM+kfIE=
X-Google-Smtp-Source: AA6agR4BAS+hM+EUim+IVcRyzqXoa4HKnh/Tj6GF+O0Vtd8DD4LdM/Qa2nW6CnG7PB2XkzY2m+F19A==
X-Received: by 2002:a05:620a:2545:b0:6b6:6773:f278 with SMTP id
 s5-20020a05620a254500b006b66773f278mr6337214qko.390.1659726652464; 
 Fri, 05 Aug 2022 12:10:52 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 ew7-20020a05622a514700b0031eb65e1cb6sm3124914qtb.5.2022.08.05.12.10.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Aug 2022 12:10:52 -0700 (PDT)
Date: Fri, 5 Aug 2022 15:10:50 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yu1rOopN++GWylUi@redhat.com>
References: <YugiaQ1TO+vT1FQ5@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YugiaQ1TO+vT1FQ5@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [git pull] Additional device mapper changes for 6.0
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
Cc: Eric Biggers <ebiggers@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

In my previous 6.0 pull request I should have forecast the potential
for sending another one.

The changes in this pull request add an optional feature to the DM 
verity target. These changes were proposed for inclussion on dm-devel
a couple weeks before the merge window opened. I reviewed and worked
the changes with Nathan and others for about a week. At that time the
changes still had some clear issues (exposed with the additional
testing Milan Broz provided in terms of a revised cryptsetup testsuite
that introduced veritysetup's --use-tasklets). I had to put it aside
once this merge window opened but Nathan continued to investigate.

Nathan found and fixed the remaining issues on Tuesday/Wednesday:
https://listman.redhat.com/archives/dm-devel/2022-August/051766.html 

Yesterday I then folded the fixes in, and refined the code a bit
further in response. The crytpsetup testsuite passes now (both with
and without the use of veritysetup's --use-tasklets flag).

All said: I think it worthwhile to merge these changes for 6.0, rather
than hold until 6.1, now that we have confidence this _optional_ DM
verity feature is working as expected. Please be aware there was a
small linux-next merge fixup needed:
https://lore.kernel.org/all/20220805125744.475531-1-broonie@kernel.org/T/

The following changes since commit 9dd1cd3220eca534f2d47afad7ce85f4c40118d8:

  dm: fix dm-raid crash if md_handle_request() splits bio (2022-07-28 17:36:30 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.0/dm-changes-2

for you to fetch changes up to 12907efde6ad984f2d76cc1a7dbaae132384d8a5:

  dm verity: have verify_wq use WQ_HIGHPRI if "try_verify_in_tasklet" (2022-08-04 15:59:52 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Add flags argument to dm_bufio_client_create and introduce
  DM_BUFIO_CLIENT_NO_SLEEP flag to have dm-bufio use spinlock rather
  than mutex for its locking.

- Add optional "try_verify_in_tasklet" feature to DM verity target.
  This feature gives users the option to improve IO latency by using a
  tasklet to verify, using hashes in bufio's cache, rather than wait
  to schedule a work item via workqueue. But if there is a bufio cache
  miss, or an error, then the tasklet will fallback to using workqueue.

- Incremental changes to both dm-bufio and the DM verity target to use
  jump_label to minimize cost of branching associated with the niche
  "try_verify_in_tasklet" feature. DM-bufio in particular is used by
  quite a few other DM targets so it doesn't make sense to incur
  additional bufio cost in those targets purely for the benefit of
  this niche verity feature if the feature isn't ever used.

- Optimize verity_verify_io, which is used by both workqueue and
  tasklet based verification, if FEC is not configured or tasklet
  based verification isn't used.

- Remove DM verity target's verify_wq's use of the WQ_CPU_INTENSIVE
  flag since it uses WQ_UNBOUND. Also, use the WQ_HIGHPRI flag if
  "try_verify_in_tasklet" is specified.

----------------------------------------------------------------
Mike Snitzer (7):
      dm verity: allow optional args to alter primary args handling
      dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP
      dm verity: conditionally enable branching for "try_verify_in_tasklet"
      dm verity: optimize verity_verify_io if FEC not configured
      dm verity: only copy bvec_iter in verity_verify_io if in_tasklet
      dm verity: remove WQ_CPU_INTENSIVE flag since using WQ_UNBOUND
      dm verity: have verify_wq use WQ_HIGHPRI if "try_verify_in_tasklet"

Nathan Huckleberry (3):
      dm bufio: Add flags argument to dm_bufio_client_create
      dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP flag
      dm verity: Add optional "try_verify_in_tasklet" feature

 drivers/md/dm-bufio.c                         |  32 +++++-
 drivers/md/dm-ebs-target.c                    |   3 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/md/dm-snap-persistent.c               |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/dm-verity-target.c                 | 160 ++++++++++++++++++++++----
 drivers/md/dm-verity.h                        |   6 +-
 drivers/md/persistent-data/dm-block-manager.c |   3 +-
 include/linux/dm-bufio.h                      |   8 +-
 9 files changed, 187 insertions(+), 33 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

