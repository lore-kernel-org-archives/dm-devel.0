Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EED4C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 01:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638495277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5mcVGNoLL9WHIgCWpLxavhCrgDIsmuVJXEPQ23Xwl3k=;
	b=HLxcQTiqVnUe7odu9YOiZtmhpdOVdMBQanLIbbspiiPsjhpRdriChtcjh04bvgoc5hNGPu
	PP6CE3/3IijoaEQr0fY9D0VwGH5TjO8/B2+sSjz2Jx6a2cDWciMrz7or4qBIkzdtYPZ6lv
	yIqPnnR4gvY0SpnuXre7u+PS8X/J5HM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-3jWQ21EiMJGs6UxBl3jy-w-1; Thu, 02 Dec 2021 20:34:35 -0500
X-MC-Unique: 3jWQ21EiMJGs6UxBl3jy-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81B1E100C660;
	Fri,  3 Dec 2021 01:34:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B965694C0;
	Fri,  3 Dec 2021 01:34:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 40D514BB7C;
	Fri,  3 Dec 2021 01:34:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B31YUi9028509 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 20:34:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B0017196E2; Fri,  3 Dec 2021 01:34:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 950BA19724;
	Fri,  3 Dec 2021 01:34:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B31YDUC015777; 
	Thu, 2 Dec 2021 19:34:13 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B31YCjO015776;
	Thu, 2 Dec 2021 19:34:12 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Dec 2021 19:34:09 -0600
Message-Id: <1638495252-15739-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 0/3] multipathd: avoid unnecessary read-only
	reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is an expanded version of my single patch
"multipathd: avoid unnecessary path read-only reloads" That also
makes some changes to how the multipath dm_info is handled.

Benjamin Marzinski (3):
  libmultipath: keep existing dm_info if you fail to get a new one
  multipathd: update dm_info on multipath change events
  multipathd: avoid unnecessary path read-only reloads

 libmultipath/devmapper.c          | 24 ++++++++++++++----------
 libmultipath/libmultipath.version |  1 +
 libmultipath/sysfs.c              | 22 ++++++++++++++++++++++
 libmultipath/sysfs.h              |  1 +
 multipathd/main.c                 | 27 ++++++++++++++++++++++++++-
 5 files changed, 64 insertions(+), 11 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

