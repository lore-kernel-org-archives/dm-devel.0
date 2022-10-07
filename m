Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F915C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=topUfwbnyanbx8WnhB89WsGyAf4nNRUAee3tm3YnTeU=;
	b=YUPlcfjR6TpK37WfALuphklSA3qqmJ+K5Q1kyIZ4Z1Da45UZ5XcJdB2KxtmTgifr/U6f0J
	6fSMN2CZz77KxP8BReaRmaY8Uy0hcJSBoj9yWBpSHvATj60c/hGRG0xASvIWc8BX9L4Gd0
	A8k3/7AIb8m0CegEmiSzFrfOB24A+dI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-LIxlY72YP2yvdZMwk2-dcA-1; Fri, 07 Oct 2022 13:35:52 -0400
X-MC-Unique: LIxlY72YP2yvdZMwk2-dcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E546195D680;
	Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64FE440C6F9F;
	Fri,  7 Oct 2022 17:35:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53C5F1946A49;
	Fri,  7 Oct 2022 17:35:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 088A51946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EECADC2C8D1; Fri,  7 Oct 2022 17:35:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6EBAC2C8CC;
 Fri,  7 Oct 2022 17:35:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZjaT006754;
 Fri, 7 Oct 2022 12:35:45 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZjum006753;
 Fri, 7 Oct 2022 12:35:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:36 -0500
Message-Id: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 0/8] mutipath: handle nvme:tcp paths better
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

nvme:tcp devices set BLK_MQ_F_BLOCKING (they are the only block devices
which multipath supports that do so), meaning that block_mq expects that
they can block at certain points while servicing a request.  However,
due to the way device-mapper sets up its queue, it is not able to set
BLK_MQ_F_BLOCKING when it includes paths that set this flag.  Patches
were written to address this issue but they were rejected upstream

https://lore.kernel.org/linux-block/YcH%2FE4JNag0QYYAa@infradead.org/T/#t

The proposed solution was to have multipath use the bio queue_mode for
multipath devices that include nvme:tcp paths.

Multipathd currently doesn't handle queue_mode as well as it could. Once
a multipath device is created, queue_mode cannot be changed, but
multipath doesn't enforce this. This patchset improves multipath's
handling of the queue_mode feature, and then makes sure that if a
multipath device includes a nvme:tcp path, it will have queue_mode
set to bio.

Benjamin Marzinski (8):
  libmultipath: cleanup remove_feature
  libmultipath: cleanup add_feature
  multipath tests: tests for adding and removing features
  libmultipath: fix queue_mode feature handling
  multipath tests: tests for reconcile_features_with_queue_mode
  libmultipath: prepare proto_id for use by non-scsi devivces
  libmultipath: get nvme path transport protocol
  libmultipath: enforce queue_mode bio for nmve:tcp paths

 libmultipath/configure.c   |  28 +-
 libmultipath/discovery.c   |  31 ++-
 libmultipath/dmparser.c    |   2 +
 libmultipath/print.c       |   6 +-
 libmultipath/propsel.c     |  55 ++++
 libmultipath/structs.c     | 155 +++++------
 libmultipath/structs.h     |  44 ++-
 libmultipath/structs_vec.c |   7 +
 multipath/multipath.conf.5 |  17 +-
 multipathd/fpin_handlers.c |   2 +-
 tests/Makefile             |   4 +-
 tests/features.c           | 549 +++++++++++++++++++++++++++++++++++++
 12 files changed, 784 insertions(+), 116 deletions(-)
 create mode 100644 tests/features.c

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

