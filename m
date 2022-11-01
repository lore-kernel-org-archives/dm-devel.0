Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4227C43219
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 20:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667336029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ix+Cuw5Wbn4STDfSR8NBM+Uq4QpDj7sQwgUP8r3oQcc=;
	b=PfZkzgpPklPqt9Seso2UtqrpkC3nnBbWb44N2H6joDkE8+Rik38S0V1kg8RY/a9SeCvwRH
	fFTZqm6EpdsIYSR9wHzplyg0QPnuQaN8VVjQKwpdJJzMoE57DHazDuIlsIFwCJVsUM1ZiE
	6DoJvzVmnf6T6ESDVR+ZFXXqnCMYxXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-khkN77SiN6OVa9yOmvnnpg-1; Tue, 01 Nov 2022 16:53:45 -0400
X-MC-Unique: khkN77SiN6OVa9yOmvnnpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 909E785A59D;
	Tue,  1 Nov 2022 20:53:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6861940C2140;
	Tue,  1 Nov 2022 20:53:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B9E019465B3;
	Tue,  1 Nov 2022 20:53:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3DE61946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 20:53:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1007468A47; Tue,  1 Nov 2022 20:53:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89DE0468A41;
 Tue,  1 Nov 2022 20:53:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A1KrZDa007815; Tue, 1 Nov 2022 16:53:35 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A1KrZ6B007811; Tue, 1 Nov 2022 16:53:35 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 1 Nov 2022 16:53:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2211011652360.7766@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 1/4] dm-ioctl: fix misbehavior if list_versions
 races with module loading
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

__list_versions will first estimate the required space using the
"dm_target_iterate(list_version_get_needed, &needed)" call and then will
fill the space using the "dm_target_iterate(list_version_get_info,
&iter_info)" call. Each of these calls locks the targets using the
"down_read(&_lock)" and "up_read(&_lock)" calls, however between the first
and second "dm_target_iterate" there is no lock held and the target
modules can be loaded at this point, so the second "dm_target_iterate"
call may need more space than what was the first "dm_target_iterate"
returned.

The code tries to handle this overflow (see the beginning of
list_version_get_info), however this handling is incorrect.

The code sets "param->data_size = param->data_start + needed" and
"iter_info.end = (char *)vers+len" - "needed" is the size returned by the
first dm_target_iterate call; "len" is the size of the buffer allocated by
userspace.

"len" may be greater than "needed"; in this case, the code will write up
to "len" bytes into the buffer, however param->data_size is set to
"needed", so it may write data past the param->data_size value. The ioctl
interface copies only up to param->data_size into userspace, thus part of
the result will be truncated.

We fix this bug by setting "iter_info.end = (char *)vers + needed;" - this
guarantees that the second "dm_target_iterate" call will write only up to
the "needed" buffer and it will exit with "DM_BUFFER_FULL_FLAG" if it
overflows the "needed" space - in this case, userspace will allocate a
larger buffer and retry.

Note that there is also a bug in list_version_get_needed - we need to add
"strlen(tt->name) + 1" to the needed size, not "strlen(tt->name)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2022-11-01 16:17:26.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2022-11-01 16:17:26.000000000 +0100
@@ -655,7 +655,7 @@ static void list_version_get_needed(stru
     size_t *needed = needed_param;
 
     *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name);
+    *needed += strlen(tt->name) + 1;
     *needed += ALIGN_MASK;
 }
 
@@ -720,7 +720,7 @@ static int __list_versions(struct dm_ioc
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
 	iter_info.flags = 0;
-	iter_info.end = (char *)vers+len;
+	iter_info.end = (char *)vers + needed;
 
 	/*
 	 * Now loop through filling out the names & versions.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

