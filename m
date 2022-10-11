Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207C1C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 21:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665525194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X35AgdM4nksiPyCyXGjNEWFd+s8//tG/Sg/LAKUwuzM=;
	b=Of4mWlbf2Etroq7Eb+Pj5gZEwULh3vyJxy4KiIhSin33MmsQrcKXHIZN2tYwELrVJOavDL
	BW/D+SLMAXLf9DBmAm9k/1dxznHrwh+Z/aEtXcEvKSfjkYpIguLC2+26dWaiDHFHKcu61+
	Ry8apV7aN8J+JMcWwEPHjgXbqh2tvu0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-hagaeJO1PK6meUgrp7HaJQ-1; Tue, 11 Oct 2022 17:53:10 -0400
X-MC-Unique: hagaeJO1PK6meUgrp7HaJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30FB13810782;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3990040C206B;
	Tue, 11 Oct 2022 21:53:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD520194658F;
	Tue, 11 Oct 2022 21:53:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9C021946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 21:53:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98015C23F70; Tue, 11 Oct 2022 21:53:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C85CC23F6F;
 Tue, 11 Oct 2022 21:53:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29BLr4tH027415;
 Tue, 11 Oct 2022 16:53:04 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29BLr36V027414;
 Tue, 11 Oct 2022 16:53:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 Oct 2022 16:52:59 -0500
Message-Id: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 0/4] remove dangerous cleanup __attribute__ uses
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

the cleanup __attribute__ is only run when a variable goes out of scope
normally. It is not run on pthread cancellation. This means that
multipathd could leak whatever resources were supposed to be cleaned up
if the thread was cancelled in a function using variables with the
cleanup __attribute__. This patchset removes all these uses in cases
where the code is run by multipathd and includes a cancellation point
in the variables scope (usually condlog(), which calls fprintf(), a
cancellation point, the way multipathd is usually run).

Benjamin Marzinski (4):
  libmultipath: don't print garbage keywords
  libmultipath: avoid STRBUF_ON_STACK with cancellation points
  libmultipath: use regular array for field widths
  libmultipath: avoid cleanup __attribute__ with cancellation points

 libmpathutil/parser.c                    | 13 ++--
 libmpathutil/strbuf.h                    |  4 +-
 libmultipath/alias.c                     | 59 ++++++++++-------
 libmultipath/blacklist.c                 |  4 +-
 libmultipath/configure.c                 |  6 +-
 libmultipath/discovery.c                 | 34 ++++++----
 libmultipath/dmparser.c                  | 23 +++----
 libmultipath/foreign.c                   |  9 +--
 libmultipath/generic.c                   | 14 ++--
 libmultipath/libmultipath.version        |  4 +-
 libmultipath/print.c                     | 82 ++++++++++++++----------
 libmultipath/print.h                     |  4 +-
 libmultipath/prioritizers/weightedpath.c | 22 ++++---
 libmultipath/propsel.c                   | 76 ++++++++++++++++------
 libmultipath/sysfs.h                     | 11 +---
 libmultipath/uevent.c                    |  6 +-
 multipath/main.c                         |  5 +-
 multipathd/cli_handlers.c                | 52 +++++++--------
 multipathd/main.c                        | 49 ++++++++------
 19 files changed, 286 insertions(+), 191 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

