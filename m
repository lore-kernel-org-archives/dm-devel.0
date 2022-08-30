Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE5CC0502C
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661887706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MXyrtjcQg/ahC7b3JqoATjwvUkqsjwSdlojdia8ERsI=;
	b=YDuzOVdnXoZaAwVcSti1Vv7efutEeb+/PpZa8rRGe1RKSeCx72jFPTmohHb+J7fDOZ0e9Y
	JELKJCYZx8o1o6I37NI3Bxqwn75pf76y/ivEG/hKtnhsBQvhzxK/bcHjxD2Dbzobt1JGiu
	yDNi22JB6BZm8EJIuUR/gzaYjuqyC8Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-hEk3b0HANmSL4A8Z2xiPUw-1; Tue, 30 Aug 2022 15:28:25 -0400
X-MC-Unique: hEk3b0HANmSL4A8Z2xiPUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A874983DE43;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95D3DC15BB3;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F3611946A7E;
	Tue, 30 Aug 2022 19:28:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 700FF1946A75
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64286492C3B; Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 608ED492CA2
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 474EC85A599
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-267-PqqQHQlPOZCrj-zzCYnl5A-1; Tue,
 30 Aug 2022 15:28:14 -0400
X-MC-Unique: PqqQHQlPOZCrj-zzCYnl5A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 33A6621E8E;
 Tue, 30 Aug 2022 19:28:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0199913B0C;
 Tue, 30 Aug 2022 19:28:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id OBojOsxkDmO5GgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 30 Aug 2022 19:28:12 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Aug 2022 21:27:13 +0200
Message-Id: <20220830192713.19778-13-mwilck@suse.com>
In-Reply-To: <20220830192713.19778-1-mwilck@suse.com>
References: <20220830192713.19778-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v4 12/12] multipathd: fix use-after-free in
 handle_path_wwid_change()
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Found by coverity (defect #380536).

Fixes: b4eb57e ("libmultipath, multipathd: log failure setting sysfs attributes")
---
 multipathd/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 66177cd..2d0a7bc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -951,10 +951,12 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	struct udev_device *udd;
 	static const char add[] = "add";
 	ssize_t ret;
+	char dev[FILE_NAME_SIZE];
 
 	if (!pp || !pp->udev)
 		return;
 
+	strlcpy(dev, pp->dev, sizeof(dev));
 	udd = udev_device_ref(pp->udev);
 	if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) && pp->mpp) {
 		pp->dmstate = PSTATE_FAILED;
@@ -965,8 +967,7 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	udev_device_unref(udd);
 	if (ret != sizeof(add) - 1)
 		log_sysfs_attr_set_value(1, ret,
-					 "%s: failed to trigger add event",
-					 pp->dev);
+					 "%s: failed to trigger add event", dev);
 }
 
 bool
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

