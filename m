Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E767C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44BA960F12
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44BA960F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sgZwKRPr0do+5Iqy03yEXzpsg5g2XoYD9gqpxkwseQc=;
	b=Y9XslnXLTAHDG9ReHLSUxF65XZQD9Y2QERgHkca88TTUtj2vCi9Chdvs/DIKhyAXfxkvPQ
	tlavMZhgHgWrmKm2c5omfl3r9RSG2Bs7MOfLax9nuQcNQqkDpdsyi3vJHFOL7Lal6nlwp+
	iybjoF8Wq61n2iupYG7JGv32aY8Pga0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-EtTHK5AIPmiUUMNqy3JedA-1; Thu, 02 Sep 2021 18:04:20 -0400
X-MC-Unique: EtTHK5AIPmiUUMNqy3JedA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE431107ACF5;
	Thu,  2 Sep 2021 22:04:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C26B65C261;
	Thu,  2 Sep 2021 22:04:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 961E918087F1;
	Thu,  2 Sep 2021 22:04:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182Lvu5C013322 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:57:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A1FC66608B; Thu,  2 Sep 2021 21:57:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCB5960853;
	Thu,  2 Sep 2021 21:57:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182LvoeN012291; 
	Thu, 2 Sep 2021 16:57:50 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182LvoUS012290;
	Thu, 2 Sep 2021 16:57:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:43 -0500
Message-Id: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/6] Mulitpath: miscellaneous patches
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

Here are a couple of unconnected patches. They (at least
libmultipath.version) are meant to be applied on top of
Martin's recent patchset.

Changes from v1:

3/6: Reworked this to keep the logic in multipath, and prefix the output
     with "Warning" as suggested by Martin Wilck.
6/6: New patch to simplify code that I noticed while reworking patch
     3/6.

Benjamin Marzinski (6):
  multipath.conf: fix typo in ghost_delay description
  mpathpersist: fail commands when no usable paths exist
  multipath: print warning if multipathd is not running.
  libmultipath: remove unneeded code in coalesce_paths
  libmultipath: deal with dynamic PTHREAD_STACK_MIN
  libmultipath: drop unnecessary parameter from remove_map()

 libmpathpersist/mpath_persist.c   | 10 ++++-
 libmultipath/configure.c          | 62 ++++---------------------------
 libmultipath/configure.h          |  1 +
 libmultipath/libmultipath.version |  5 +++
 libmultipath/structs_vec.c        | 12 +++---
 libmultipath/structs_vec.h        | 11 +-----
 libmultipath/util.c               |  4 +-
 multipath/main.c                  | 18 +++++++--
 multipath/multipath.conf.5        |  2 +-
 multipathd/dmevents.c             |  2 +-
 multipathd/main.c                 | 12 +++---
 11 files changed, 54 insertions(+), 85 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

