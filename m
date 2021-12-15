Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53964C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639590268;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mrRElHOAlpEyjHdgcNZa4q+I2sIxS68i0kz3CZ4Nj2I=;
	b=No/27U6nH73Xqk5RasVbUkVDm04tVf8ILsxqk7J8vGsH4i9X1OaTuT9a7kHFPeUHCm9ShO
	ZVcwY+3Ge+cZgQDTojom6i6oK8ZVZJyBDaS4P5P1TFhfymYk2wFTrrH/iOssPSvfwZ9R80
	/qDwzcf6XQIiKL6EblcjOCQA1egqxKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-Clu8DntwMRKTkG7Z5_Y7Hg-1; Wed, 15 Dec 2021 12:44:24 -0500
X-MC-Unique: Clu8DntwMRKTkG7Z5_Y7Hg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4624364170;
	Wed, 15 Dec 2021 17:44:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE83A4D73A;
	Wed, 15 Dec 2021 17:44:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B12A64BB7C;
	Wed, 15 Dec 2021 17:44:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFHiEhv018381 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 12:44:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5401F4D73A; Wed, 15 Dec 2021 17:44:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BFF47A22C;
	Wed, 15 Dec 2021 17:44:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BFHiBdE011331; 
	Wed, 15 Dec 2021 11:44:12 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BFHiB9F011330;
	Wed, 15 Dec 2021 11:44:11 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 15 Dec 2021 11:44:07 -0600
Message-Id: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/3] multipathd: avoid unnecessary read-only
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is an expanded version of my single patch
"multipathd: avoid unnecessary path read-only reloads" That also
makes some changes to how the multipath dm_info is handled.

changes from v1, (suggested by Martin Wilck):

0001:	This has been completely rewritten to embed the dmi structure in
	the multipath structure. This will require a major version bump
	for libmultipath, which I've not included.

0003:	sysfs_get_ro() has been moved to mutlipathd, and needs_ro_update()
	has been changed to work with the embedded dmi structure.

Benjamin Marzinski (3):
  libmultipath: embed dm_info in multipath structure
  multipathd: update dm_info on multipath change events
  multipathd: avoid unnecessary path read-only reloads

 libmultipath/configure.c          |  7 +++--
 libmultipath/devmapper.c          | 51 +++++++++++--------------------
 libmultipath/devmapper.h          |  3 +-
 libmultipath/libmultipath.version |  1 +
 libmultipath/print.c              | 12 +++++---
 libmultipath/structs.c            | 10 ++----
 libmultipath/structs.h            |  3 +-
 multipathd/main.c                 | 51 +++++++++++++++++++++++++++++--
 8 files changed, 85 insertions(+), 53 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

