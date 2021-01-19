Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68C2C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 04:46:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A4BC21D42
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 04:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A4BC21D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611031583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IcmeeALM4b9b+2Z9sCtvmHqtCPIOnRLdi5XRoAJHwHk=;
	b=Jmkz9ocaVSsCA9YxIU8HCphXeSTsrJRAwx+pH0KAY2b6RiPn4PCxn5/Bf2yFluAIJ3VoOy
	Ew3uNn33HydaHpfWw2g5cURbp5XTZ/srifjJNftLoAHu/fgbwzDChXuU7GxI+rtWeBaKcH
	xD6IEzjPGtDoZrElohRLqkjO1VRBh68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-DCyRiyCkNtyoBJobYEBT8g-1; Mon, 18 Jan 2021 23:46:21 -0500
X-MC-Unique: DCyRiyCkNtyoBJobYEBT8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86B1D107ACE3;
	Tue, 19 Jan 2021 04:46:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAB4D57;
	Tue, 19 Jan 2021 04:46:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09CEE4A7C7;
	Tue, 19 Jan 2021 04:46:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J4k9Wf017560 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Jan 2021 23:46:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 759249CA0; Tue, 19 Jan 2021 04:46:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B686F95D;
	Tue, 19 Jan 2021 04:46:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10J4k45T018701; 
	Mon, 18 Jan 2021 22:46:05 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10J4k4La018700;
	Mon, 18 Jan 2021 22:46:04 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 18 Jan 2021 22:46:03 -0600
Message-Id: <1611031564-18663-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 0/1] Multipath io_err_stat fixes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I found an ABBA deadlock in the io_err_stat marginal path code, and in
the process of fixing it, noticed a potential crash on shutdown. This
patchset addresses both of the issues.

Changes from v2:

0001: This is patch 0006 from v2. It is exactly the same code. But the
commit message now mentions that check_path() no longer switches paths
from delayed to pending.

Changes from v1:

0002: use cleanup_mutex instead of cleanup_unlock as suggested by
Martin

0003: add pthread_testcancel and use cleanup_mutex instead of
cleanup_unlock as suggested by Martin. Also, make tmp_pathvec a constant
pointer, since it should always equal _pathvec.

0004-0006 are new patches to deal with io_err_stat issues from Martin's
review


Benjamin Marzinski (1):
  multipathd: cleanup logging for marginal paths

 libmultipath/io_err_stat.c |  7 +++----
 multipathd/main.c          | 25 ++++++++++++++-----------
 2 files changed, 17 insertions(+), 15 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

