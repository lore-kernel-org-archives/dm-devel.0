Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6BFC433E6
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 02:20:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB86223AC0
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 02:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB86223AC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610677246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CVlZtWA3tbiDiPCFdVdkqZe1RzONxx2ByKHH42MzWIM=;
	b=eICLHstm2Itu/VB+Em1mWaoNrHFWyzSp4T09DfAQ807HqGMUe7AQDe11ZJJ+mBYbJRhznO
	WVCqR0fQcr1RlsUdz11q4j2/yBPnDwO0OSYakhW0uwwlv0ERFfim6lvDC5NMkip6cpbXct
	NbfJqhuQ2hMdqwHaVaiNggXR2tQ2x/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-n2ONXIyTNJmJJNvO-Mb05A-1; Thu, 14 Jan 2021 21:20:44 -0500
X-MC-Unique: n2ONXIyTNJmJJNvO-Mb05A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF4CC107ACF8;
	Fri, 15 Jan 2021 02:20:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C0F6101E663;
	Fri, 15 Jan 2021 02:20:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C290C4BB7B;
	Fri, 15 Jan 2021 02:20:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10F2KXIj030965 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Jan 2021 21:20:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 316B360C6F; Fri, 15 Jan 2021 02:20:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09C8A60C6B;
	Fri, 15 Jan 2021 02:20:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10F2KSdC023588; 
	Thu, 14 Jan 2021 20:20:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10F2KSOi023587;
	Thu, 14 Jan 2021 20:20:28 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 14 Jan 2021 20:20:21 -0600
Message-Id: <1610677227-23550-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/6] Multipath io_err_stat fixes
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I found an ABBA deadlock in the io_err_stat marginal path code, and in
the process of fixing it, noticed a potential crash on shutdown. This
patchset addresses both of the issues.

Changes from v1:

0002: use cleanup_mutex instead of cleanup_unlock as suggested by
Martin

0003: add pthread_testcancel and use cleanup_mutex instead of
cleanup_unlock as suggested by Martin. Also, make tmp_pathvec a constant
pointer, since it should always equal _pathvec.

0004-0006 are new patches to deal with io_err_stat issues from Martin's
review

Benjamin Marzinski (6):
  libmultipath: make find_err_path_by_dev() static
  multipathd: avoid io_err_stat crash during shutdown
  multipathd: avoid io_err_stat ABBA deadlock
  multipathd: use get_monotonic_time() in io_err_stat code
  multipathd: combine free_io_err_stat_path and destroy_directio_ctx
  multipathd: cleanup logging for marginal paths

 libmultipath/io_err_stat.c | 216 ++++++++++++++++---------------------
 multipathd/main.c          |  25 +++--
 2 files changed, 105 insertions(+), 136 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

