Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2551AC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:28:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9254664FD6
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9254664FD6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615487284;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XFVNO/BUgO5C7XdS/kX12HMlzFmZKkSyzfiDrZOneFU=;
	b=A4unr4ymucI9+xs3gdn8qtmO70MUhZI8qIRHWE7YlUTvtjlocPQi4JmUJOx5wtrEpEO7Yy
	cI6uqgUmtLF+siddFqXuqECxLL0v0WiPN0OUhNSWf9E+hrIqGtqiSHIK7XnzpwRg/F86CR
	5rMBAPw4jSzo7DtquzT6DrlmCcSqwMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-4P9qiKfYNGmu4OXK4ExeGQ-1; Thu, 11 Mar 2021 13:28:02 -0500
X-MC-Unique: 4P9qiKfYNGmu4OXK4ExeGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BEE4363A9;
	Thu, 11 Mar 2021 18:27:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFE895D9F0;
	Thu, 11 Mar 2021 18:27:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 995D157DC1;
	Thu, 11 Mar 2021 18:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BIQrZf029522 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 13:26:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22C165B4A0; Thu, 11 Mar 2021 18:26:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6D0E18A9E;
	Thu, 11 Mar 2021 18:26:48 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 12BIQmuN028808; Thu, 11 Mar 2021 13:26:48 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 12BIQmrQ028804; Thu, 11 Mar 2021 13:26:48 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 11 Mar 2021 13:26:48 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <alpine.LRH.2.02.2103111326050.28706@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2] dm-ioctl: return UUID in DM_LIST_DEVICES_CMD
	result
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When LVM needs to find a device with a particular UUID it needs to ask for
UUID for each device. This patch returns UUID directly in the list of
devices, so that LVM doesn't have to query all the devices with an ioctl.
The UUID is returned if the flag DM_UUID_FLAG is set in the parameters.

Returning UUID is done in backward-compatible way. There's one unused
32-bit word value after the event number. This patch sets the bit
DM_NAME_LIST_FLAG_HAS_UUID if UUID is present and
DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID if it isn't (if none of these bits is
set, then we have an old kernel that doesn't support returning UUIDs). The
UUID is stored after this word. The 'next' value is updated to point after
the UUID, so that old version of libdevmapper will skip the UUID without
attempting to interpret it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   20 +++++++++++++++++---
 include/uapi/linux/dm-ioctl.h |    7 +++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2021-03-09 21:04:07.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2021-03-11 18:53:58.000000000 +0100
@@ -558,7 +558,9 @@ static int list_devices(struct file *fil
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
 		hc = container_of(n, struct hash_cell, name_node);
 		needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
-		needed += align_val(sizeof(uint32_t));
+		needed += align_val(sizeof(uint32_t) * 2);
+		if (param->flags & DM_UUID_FLAG && hc->uuid)
+			needed += align_val(strlen(hc->uuid) + 1);
 	}
 
 	/*
@@ -577,6 +579,7 @@ static int list_devices(struct file *fil
 	 * Now loop through filling out the names.
 	 */
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		void *uuid_ptr;
 		hc = container_of(n, struct hash_cell, name_node);
 		if (old_nl)
 			old_nl->next = (uint32_t) ((void *) nl -
@@ -588,8 +591,19 @@ static int list_devices(struct file *fil
 
 		old_nl = nl;
 		event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
-		*event_nr = dm_get_event_nr(hc->md);
-		nl = align_ptr(event_nr + 1);
+		event_nr[0] = dm_get_event_nr(hc->md);
+		event_nr[1] = 0;
+		uuid_ptr = align_ptr(event_nr + 2);
+		if (param->flags & DM_UUID_FLAG) {
+			if (hc->uuid) {
+				event_nr[1] |= DM_NAME_LIST_FLAG_HAS_UUID;
+				strcpy(uuid_ptr, hc->uuid);
+				uuid_ptr = align_ptr(uuid_ptr + strlen(hc->uuid) + 1);
+			} else {
+				event_nr[1] |= DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID;
+			}
+		}
+		nl = uuid_ptr;
 	}
 	/*
 	 * If mismatch happens, security may be compromised due to buffer
Index: linux-2.6/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2021-03-09 12:20:23.000000000 +0100
+++ linux-2.6/include/uapi/linux/dm-ioctl.h	2021-03-11 18:42:14.000000000 +0100
@@ -193,8 +193,15 @@ struct dm_name_list {
 	__u32 next;		/* offset to the next record from
 				   the _start_ of this */
 	char name[0];
+
+	/* uint32_t event_nr; */
+	/* uint32_t flags; */
+	/* char uuid[0]; */
 };
 
+#define DM_NAME_LIST_FLAG_HAS_UUID		1
+#define DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID	2
+
 /*
  * Used to retrieve the target versions
  */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

