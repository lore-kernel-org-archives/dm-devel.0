Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63925C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675194104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bQcMiiHvwD+y5cE8r3pZUDvKOI3z8HECiKTaj07pu+M=;
	b=KAmSYxl98UaOxS0btg5ejm52mA55lgEniMNav6YF6SwEs3YEfucyqFQ/yt4RZwM8wWhtHU
	8fC0LQiG6eNRtLvlR3RUlxf0TQPCBvj65ZdgNyr0noOTSOsZl6/Ljk5ekuyUKFk0Q3sP7a
	oQ1pHMjrqYttYODVVQnstFaDPoz+mWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-h7RnZQN8PVOgfMBuatLXUg-1; Tue, 31 Jan 2023 14:41:43 -0500
X-MC-Unique: h7RnZQN8PVOgfMBuatLXUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A63E85D063;
	Tue, 31 Jan 2023 19:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDE372166B33;
	Tue, 31 Jan 2023 19:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B16381946589;
	Tue, 31 Jan 2023 19:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DFD11946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 19:34:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3885E2166B35; Tue, 31 Jan 2023 19:34:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E31A2166B33;
 Tue, 31 Jan 2023 19:34:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 30VJYMkh001185;
 Tue, 31 Jan 2023 13:34:22 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 30VJYMjD001184;
 Tue, 31 Jan 2023 13:34:22 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 31 Jan 2023 13:34:17 -0600
Message-Id: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 0/4] multipath: fix multipathd renaming issue
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a multipath device needs to be renamed and reloaded when multipathd
starts, it will only get reloaded. This can happen if the multipath
configuration is different between the initramfs and regular filesystem.
The only thing that can happen along with a rename is a force reload.

This patchset makes libmultipath also do all the other actions that are
compatible with a rename.

Benjamin Marzinski (4):
  libmultipath: use select_reload_action in select_action
  libmultipath: select resize action even if reload is forced
  libmultipath: cleanup ACT_CREATE code in select_action
  libmultipath: keep renames from stopping other multipath actions

 libmultipath/configure.c | 105 +++++++++++++++++----------------------
 libmultipath/configure.h |   4 +-
 2 files changed, 48 insertions(+), 61 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

